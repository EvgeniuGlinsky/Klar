import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:klar/core/db/klar_db.dart';
import 'package:klar/core/time/clock.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/subtask.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/repos/tasks_repo.dart';

class TasksRepoImpl implements TasksRepo {
  TasksRepoImpl(this._db, this._clock);

  final KlarDb _db;
  final Clock _clock;

  @override
  Stream<List<Task>> watchAll() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.tasksTable, _db.subtasksTable, _db.remindersTable},
      )
      .watch()
      .asyncMap((_) => getAll());

  @override
  Future<List<Task>> getAll() => _db.transaction(() async {
    final tasks = await (_db.select(_db.tasksTable)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    final subtasks = await (_db.select(_db.subtasksTable)..orderBy([(s) => OrderingTerm.asc(s.sortOrder)])).get();
    final reminders = await (_db.select(_db.remindersTable)..orderBy([(r) => OrderingTerm.asc(r.sortOrder)])).get();
    final subtasksByTask = subtasks.groupListsBy((s) => s.taskId);
    final remindersByTask = reminders.groupListsBy((r) => r.taskId);
    return [
      for (final row in tasks) _toTask(row, subtasksByTask[row.id] ?? const [], remindersByTask[row.id] ?? const []),
    ];
  });

  @override
  Future<Task?> get(String id) => _db.transaction(() async {
    final row = await (_db.select(_db.tasksTable)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final subtasks =
        await (_db.select(_db.subtasksTable)
              ..where((s) => s.taskId.equals(id))
              ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
            .get();
    final reminders =
        await (_db.select(_db.remindersTable)
              ..where((r) => r.taskId.equals(id))
              ..orderBy([(r) => OrderingTerm.asc(r.sortOrder)]))
            .get();
    return _toTask(row, subtasks, reminders);
  });

  @override
  Future<void> save(Task task) => _db.transaction(() async {
    await _db.into(_db.tasksTable).insertOnConflictUpdate(_toCompanion(task));
    await (_db.delete(_db.subtasksTable)..where((s) => s.taskId.equals(task.id))).go();
    await (_db.delete(_db.remindersTable)..where((r) => r.taskId.equals(task.id))).go();
    await _db.batch((batch) {
      batch.insertAll(_db.subtasksTable, [
        for (final (i, s) in task.subtasks.indexed)
          SubtasksTableCompanion.insert(id: s.id, taskId: task.id, title: s.title, done: Value(s.done), sortOrder: i),
      ]);
      batch.insertAll(_db.remindersTable, [
        for (final (i, r) in task.reminders.indexed)
          RemindersTableCompanion.insert(
            id: r.id,
            taskId: task.id,
            offsetMinutes: r.offsetMinutes,
            kind: r.kind,
            sortOrder: i,
          ),
      ]);
    });
  });

  @override
  Future<void> delete(String id) => (_db.delete(_db.tasksTable)..where((t) => t.id.equals(id))).go();

  @override
  Future<Task?> complete(String id, {LocalDate? occurrence, bool onlyIfCurrent = false}) => _db.transaction(() async {
    final task = await get(id);
    if (task == null || task.isCompleted) return null;

    final rule = task.recurrence;
    final dueDate = task.dueDate;
    if (rule == null || dueDate == null) {
      await save(task.copyWith(completedAt: () => _clock.now()));
      return task;
    }

    final completed = occurrence ?? dueDate;
    if (onlyIfCurrent && completed.isBefore(dueDate)) return null;
    final inserted = await _db
        .into(_db.completionsTable)
        .insert(
          CompletionsTableCompanion.insert(taskId: id, occurrence: completed, completedAt: _clock.now()),
          mode: InsertMode.insertOrIgnore,
        );
    if (inserted == 0 && onlyIfCurrent) return null;

    final next = rule.nextAfter(LocalDate.max(completed, _clock.today()));
    await save(
      next == null
          ? task.copyWith(completedAt: () => _clock.now())
          : task.copyWith(
              dueDate: () => next,
              subtasks: [for (final s in task.subtasks) s.copyWith(done: false)],
            ),
    );
    return task;
  });

  @override
  Future<void> restore(Task previous) => _db.transaction(() async {
    final current = await get(previous.id);
    final dueDate = previous.dueDate;
    if (previous.isRecurring && dueDate != null && current != null && current.dueDate != dueDate) {
      // Undo of a recurring completion: forget every occurrence completed since the restored due date.
      await (_db.delete(_db.completionsTable)
            ..where((c) => c.taskId.equals(previous.id) & c.occurrence.isBiggerOrEqualValue(dueDate.iso)))
          .go();
    }
    await save(previous);
  });

  @override
  Future<void> reopen(String id) =>
      (_db.update(_db.tasksTable)..where((t) => t.id.equals(id))).write(const TasksTableCompanion(completedAt: Value(null)));

  @override
  Future<void> setSubtaskDone(String subtaskId, {required bool done}) =>
      (_db.update(_db.subtasksTable)..where((s) => s.id.equals(subtaskId))).write(SubtasksTableCompanion(done: Value(done)));

  Task _toTask(TaskRow row, List<SubtaskRow> subtasks, List<ReminderRow> reminders) => Task(
    id: row.id,
    listId: row.listId,
    title: row.title,
    notes: row.notes,
    priority: row.priority,
    dueDate: row.dueDate,
    dueTime: row.dueTime,
    recurrence: row.recurrence,
    completedAt: row.completedAt,
    createdAt: row.createdAt,
    sortOrder: row.sortOrder,
    sound: row.sound,
    vibration: row.vibration,
    subtasks: [for (final s in subtasks) Subtask(id: s.id, title: s.title, done: s.done)],
    reminders: [for (final r in reminders) Reminder(id: r.id, offsetMinutes: r.offsetMinutes, kind: r.kind)],
  );

  TasksTableCompanion _toCompanion(Task task) => TasksTableCompanion.insert(
    id: task.id,
    listId: task.listId,
    title: task.title,
    notes: Value(task.notes),
    priority: Value(task.priority),
    dueDate: Value(task.dueDate),
    dueTime: Value(task.dueDate == null ? null : task.dueTime),
    recurrence: Value(task.dueDate == null ? null : task.recurrence),
    completedAt: Value(task.completedAt),
    createdAt: task.createdAt,
    sortOrder: Value(task.sortOrder),
    sound: Value(task.sound),
    vibration: Value(task.vibration),
  );
}
