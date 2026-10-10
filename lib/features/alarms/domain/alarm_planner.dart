import 'package:klar/core/time/local_date.dart';
import 'package:klar/core/time/local_date_time.dart';
import 'package:klar/features/alarms/domain/models/alarm_spec.dart';
import 'package:klar/features/alarms/domain/models/upcoming_task.dart';
import 'package:klar/features/settings/domain/models/app_settings.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';

typedef AlarmTexts = ({String title, String body});

/// Builds the user-visible texts of a signal.
typedef AlarmTextBuilder = AlarmTexts Function({
  required Task task,
  required Reminder reminder,
  required LocalDateTime due,
  TaskList? list,
});

class AlarmPlan {
  const AlarmPlan({
    required this.specs,
    required this.liveTasks,
    required this.horizonEnd,
    this.upcoming = const [],
  });

  final List<AlarmSpec> specs;

  /// The next timed task occurrences, soonest first, for the pinned notification.
  final List<UpcomingTask> upcoming;

  /// Not completed task id → current due date (`''` when it has none).
  final Map<String, String> liveTasks;

  /// The moment after which nothing is planned.
  final LocalDateTime horizonEnd;
}

/// Computes every future signal from the tasks; pure and deterministic.
class AlarmPlanner {
  const AlarmPlanner({
    required this.texts,
    this.horizonDays = 180,
    this.maxSpecs = 2000,
    this.upcomingDays = 14,
    this.maxUpcoming = 30,
  });

  /// Signals due this recently are still sent: the native engine knows which ones it already handled,
  /// and dropping them here could lose an alarm whose wake-up is a few seconds late.
  static const recentMinutes = 5;

  final AlarmTextBuilder texts;
  final int horizonDays;
  final int maxSpecs;
  final int upcomingDays;
  final int maxUpcoming;

  AlarmPlan plan({
    required List<Task> tasks,
    required List<TaskList> lists,
    required AppSettings settings,
    required LocalDateTime now,
  }) {
    final listsById = {for (final l in lists) l.id: l};
    final lastDate = now.date.addDays(horizonDays);
    final earliest = now.addMinutes(-recentMinutes);
    final specs = <AlarmSpec>[];
    final upcoming = <UpcomingTask>[];
    final upcomingEnd = now.date.addDays(upcomingDays);
    final liveTasks = <String, String>{};

    for (final task in tasks) {
      if (task.isCompleted) continue;
      liveTasks[task.id] = task.dueDate?.iso ?? '';
      final dueDate = task.dueDate;
      if (dueDate == null) continue;

      final time = task.dueTime;
      if (time != null) {
        final list = listsById[task.listId];
        for (final occurrence in _occurrences(task, dueDate, from: now.date, to: upcomingEnd)) {
          final due = LocalDateTime(occurrence, time);
          if (!due.isAfter(now)) continue;
          upcoming.add(
            UpcomingTask(
              taskId: task.id,
              occurrence: occurrence,
              due: due,
              title: task.title,
              listName: list == null || list.isInbox ? '' : list.name,
            ),
          );
        }
      }
      if (task.reminders.isEmpty) continue;

      for (final occurrence in _occurrences(task, dueDate, from: earliest.date, to: lastDate.addDays(1))) {
        final due = LocalDateTime(occurrence, task.dueTime ?? settings.allDayMinutes);
        for (final reminder in task.reminders) {
          final trigger = due.addMinutes(-reminder.offsetMinutes);
          if (!trigger.isAfter(earliest) || trigger.date.isAfter(lastDate)) continue;
          final t = texts(task: task, reminder: reminder, due: due, list: listsById[task.listId]);
          specs.add(
            AlarmSpec(
              taskId: task.id,
              reminderId: reminder.id,
              occurrence: occurrence,
              trigger: trigger,
              kind: reminder.kind,
              title: t.title,
              body: t.body,
              sound: task.sound,
              vibration: task.vibration,
            ),
          );
        }
      }
    }

    specs.sort((a, b) => a.trigger.compareTo(b.trigger));
    upcoming.sort((a, b) => a.due.compareTo(b.due));
    final truncated = specs.length > maxSpecs;
    final planned = truncated ? specs.sublist(0, maxSpecs) : specs;
    return AlarmPlan(
      specs: planned,
      liveTasks: liveTasks,
      horizonEnd: truncated ? planned.last.trigger : LocalDateTime(lastDate, 23 * 60 + 59),
      upcoming: upcoming.take(maxUpcoming).toList(),
    );
  }

  /// The current due date plus the following occurrences of a recurring task within `[from, to]`.
  Iterable<LocalDate> _occurrences(
    Task task,
    LocalDate dueDate, {
    required LocalDate from,
    required LocalDate to,
  }) sync* {
    yield dueDate;
    final rule = task.recurrence;
    if (rule == null) return;
    final start = LocalDate.max(dueDate.addDays(1), from);
    yield* rule.occurrencesBetween(start, to).where((d) => d != dueDate);
  }
}
