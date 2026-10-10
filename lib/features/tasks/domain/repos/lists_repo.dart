import 'package:klar/features/tasks/domain/models/task_list.dart';

abstract interface class ListsRepo {
  Stream<List<TaskList>> watchAll();

  Future<List<TaskList>> getAll();

  Future<void> save(TaskList list);

  /// Deletes the list together with its tasks.
  Future<void> delete(String id);
}
