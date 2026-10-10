import 'package:flutter_test/flutter_test.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/core/time/local_date_time.dart';
import 'package:klar/features/alarms/domain/alarm_planner.dart';
import 'package:klar/features/settings/domain/models/app_settings.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';

const inbox = TaskList(id: TaskList.inboxId, name: 'Входящие', colorKey: 'birch', iconKey: 'tray');
const alarmAtTime = Reminder(id: 'r0', offsetMinutes: 0, kind: ReminderKind.alarm);
const notify15 = Reminder(id: 'r15', offsetMinutes: 15, kind: ReminderKind.notification);

final planner = AlarmPlanner(
  texts: ({required task, required reminder, required due, list}) => (title: task.title, body: due.iso),
  horizonDays: 30,
);

final now = LocalDateTime(LocalDate.parse('2026-10-10'), 12 * 60);

Task task({
  String id = 't',
  String? due = '2026-10-10',
  int? time = 18 * 60,
  List<Reminder> reminders = const [alarmAtTime, notify15],
  RecurrenceRule? recurrence,
  DateTime? completedAt,
}) => Task(
  id: id,
  listId: inbox.id,
  title: 'Task $id',
  createdAt: DateTime(2026),
  dueDate: due == null ? null : LocalDate.parse(due),
  dueTime: time,
  reminders: reminders,
  recurrence: recurrence,
  completedAt: completedAt,
);

AlarmPlan plan(List<Task> tasks, {AppSettings settings = const AppSettings()}) =>
    planner.plan(tasks: tasks, lists: const [inbox], settings: settings, now: now);

void main() {
  test('one spec per reminder, sorted by trigger', () {
    final result = plan([task()]);
    expect(result.specs.map((s) => s.trigger.iso), ['2026-10-10T17:45', '2026-10-10T18:00']);
    expect(result.specs.first.key, 't|r15|2026-10-10');
    expect(result.specs.last.kind, ReminderKind.alarm);
  });

  test('past triggers are dropped, except the last few minutes', () {
    final result = plan([task(time: 12 * 60 + 5)]);
    expect(result.specs.map((s) => s.trigger.iso), ['2026-10-10T12:05']);
    final recent = plan([task(time: 12 * 60 + 18)]);
    expect(recent.specs.map((s) => s.trigger.iso), ['2026-10-10T12:03', '2026-10-10T12:18']);
  });

  test('completed tasks, tasks without a date and without reminders plan nothing', () {
    final result = plan([
      task(id: 'a', completedAt: DateTime(2026, 10, 10)),
      task(id: 'b', due: null),
      task(id: 'c', reminders: const []),
    ]);
    expect(result.specs, isEmpty);
    expect(result.liveTasks, {'b': '', 'c': '2026-10-10'});
  });

  test('all-day tasks ring at the configured time', () {
    final result = plan([task(due: '2026-10-11', time: null)], settings: const AppSettings(allDayMinutes: 8 * 60));
    expect(result.specs.map((s) => s.trigger.iso), ['2026-10-11T07:45', '2026-10-11T08:00']);
  });

  test('reminders before midnight move to the previous day', () {
    const dayBefore = Reminder(id: 'd', offsetMinutes: 1440 + 30, kind: ReminderKind.alarm);
    final result = plan([
      task(due: '2026-10-12', time: 0, reminders: [dayBefore]),
    ]);
    expect(result.specs.single.trigger.iso, '2026-10-10T23:30');
  });

  test('recurring tasks ring for every occurrence in the horizon, overdue or not', () {
    final rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: LocalDate.parse('2026-10-01'));
    final result = plan([
      task(due: '2026-10-08', reminders: const [alarmAtTime], recurrence: rule),
    ]);
    expect(result.specs.first.occurrence.iso, '2026-10-10');
    expect(result.specs.length, 31);
    expect(result.specs.last.occurrence.iso, '2026-11-09');
  });

  test('a due date off the rule still rings, then the rule continues', () {
    final weeklyMonday = RecurrenceRule(
      frequency: RecurrenceFrequency.weekly,
      anchor: LocalDate.parse('2026-10-05'),
      weekdays: const {1},
    );
    final result = plan([
      task(due: '2026-10-14', reminders: const [alarmAtTime], recurrence: weeklyMonday),
    ]);
    expect(result.specs.take(3).map((s) => s.occurrence.iso), ['2026-10-14', '2026-10-19', '2026-10-26']);
  });

  test('the plan is capped and the horizon shrinks to the last planned trigger', () {
    final capped =
        AlarmPlanner(
          texts: planner.texts,
          horizonDays: 30,
          maxSpecs: 5,
        ).plan(
          tasks: [
            task(
              due: '2026-10-11',
              reminders: const [alarmAtTime],
              recurrence: RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: LocalDate.parse('2026-10-11')),
            ),
          ],
          lists: const [inbox],
          settings: const AppSettings(),
          now: now,
        );
    expect(capped.specs.length, 5);
    expect(capped.horizonEnd.iso, '2026-10-15T18:00');
  });

  test('upcoming lists timed occurrences after now, soonest first, without reminders too', () {
    final result = plan([
      task(id: 'late', time: 20 * 60, reminders: const []),
      task(id: 'past', time: 11 * 60),
      task(id: 'allDay', time: null),
      task(
        id: 'daily',
        time: 13 * 60,
        recurrence: RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: LocalDate.parse('2026-10-10')),
      ),
    ]);
    expect(result.upcoming.take(3).map((u) => '${u.taskId} ${u.due.iso}'), [
      'daily 2026-10-10T13:00',
      'late 2026-10-10T20:00',
      'daily 2026-10-11T13:00',
    ]);
    expect(result.upcoming.where((u) => u.taskId == 'daily').length, 15);
  });
}
