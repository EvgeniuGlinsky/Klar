import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klar/core/db/klar_db.dart';
import 'package:klar/core/time/clock.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/tasks/data/repos/tasks_repo_impl.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/subtask.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';

void main() {
  late KlarDb db;
  late FixedClock clock;
  late TasksRepoImpl repo;

  setUp(() {
    db = KlarDb(NativeDatabase.memory());
    clock = FixedClock(DateTime(2026, 10, 10, 12));
    repo = TasksRepoImpl(db, clock);
  });

  tearDown(() => db.close());

  Task daily({String due = '2026-10-10'}) => Task(
    id: 't1',
    listId: TaskList.inboxId,
    title: 'Витамины',
    createdAt: clock.now(),
    dueDate: LocalDate.parse(due),
    dueTime: 9 * 60,
    recurrence: RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: LocalDate.parse('2026-10-01')),
    subtasks: const [Subtask(id: 's1', title: 'Утром', done: true)],
    reminders: const [Reminder(id: 'r1', offsetMinutes: 0, kind: ReminderKind.alarm)],
  );

  test('save and read back with subtasks and reminders', () async {
    await repo.save(daily());
    final loaded = await repo.get('t1');
    expect(loaded, daily());
  });

  test('completing a plain task sets completedAt; restore undoes it', () async {
    final plain = daily().copyWith(recurrence: () => null);
    await repo.save(plain);
    final previous = await repo.complete('t1');
    expect((await repo.get('t1'))!.completedAt, clock.now());
    await repo.restore(previous!);
    expect((await repo.get('t1'))!.isCompleted, isFalse);
  });

  test('completing a recurring task moves it to the next occurrence and resets subtasks', () async {
    await repo.save(daily());
    await repo.complete('t1');
    final next = (await repo.get('t1'))!;
    expect(next.dueDate, LocalDate.parse('2026-10-11'));
    expect(next.isCompleted, isFalse);
    expect(next.subtasks.single.done, isFalse);
  });

  test('an overdue recurring task skips to after today', () async {
    await repo.save(daily(due: '2026-10-05'));
    await repo.complete('t1');
    expect((await repo.get('t1'))!.dueDate, LocalDate.parse('2026-10-11'));
  });

  test('engine events are idempotent and ignore older occurrences', () async {
    await repo.save(daily());
    final occurrence = LocalDate.parse('2026-10-10');
    expect(await repo.complete('t1', occurrence: occurrence, onlyIfCurrent: true), isNotNull);
    expect(await repo.complete('t1', occurrence: occurrence, onlyIfCurrent: true), isNull);
    expect((await repo.get('t1'))!.dueDate, LocalDate.parse('2026-10-11'));
  });

  test('undo of a recurring completion allows completing the occurrence again', () async {
    await repo.save(daily());
    final previous = await repo.complete('t1');
    await repo.restore(previous!);
    expect((await repo.get('t1'))!.dueDate, LocalDate.parse('2026-10-10'));
    expect(await repo.complete('t1', occurrence: LocalDate.parse('2026-10-10'), onlyIfCurrent: true), isNotNull);
  });

  test('deleting a list cascades to its tasks', () async {
    await db
        .into(db.taskListsTable)
        .insert(
          TaskListsTableCompanion.insert(id: 'work', name: 'Работа', colorKey: 'sage', iconKey: 'briefcase', createdAt: clock.now()),
        );
    await repo.save(daily().copyWith(listId: 'work'));
    await (db.delete(db.taskListsTable)..where((l) => l.id.equals('work'))).go();
    expect(await repo.getAll(), isEmpty);
    expect(await db.select(db.subtasksTable).get(), isEmpty);
  });
}
