import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/tasks/domain/models/task.dart';

abstract interface class TasksRepo {
  /// All tasks with their subtasks and reminders; emits again on every change.
  Stream<List<Task>> watchAll();

  Future<List<Task>> getAll();

  Future<Task?> get(String id);

  Future<void> save(Task task);

  Future<void> delete(String id);

  /// Completes the task, or [occurrence] (default: the current due date) of a recurring task,
  /// which then moves to its next occurrence.
  ///
  /// With [onlyIfCurrent] an occurrence older than the current due date is ignored; used for
  /// events coming from the alarm engine. Returns the task as it was before, or `null` if nothing changed.
  Future<Task?> complete(String id, {LocalDate? occurrence, bool onlyIfCurrent = false});

  /// Undoes [complete] by restoring [previous].
  Future<void> restore(Task previous);

  Future<void> reopen(String id);

  Future<void> setSubtaskDone(String subtaskId, {required bool done});
}
