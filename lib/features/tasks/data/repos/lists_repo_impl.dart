import 'package:drift/drift.dart';
import 'package:klar/core/db/klar_db.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';
import 'package:klar/features/tasks/domain/repos/lists_repo.dart';

class ListsRepoImpl implements ListsRepo {
  ListsRepoImpl(this._db);

  final KlarDb _db;

  SimpleSelectStatement<$TaskListsTableTable, TaskListRow> get _query =>
      _db.select(_db.taskListsTable)
        ..orderBy([(l) => OrderingTerm.asc(l.sortOrder), (l) => OrderingTerm.asc(l.createdAt)]);

  @override
  Stream<List<TaskList>> watchAll() => _query.watch().map((rows) => rows.map(_toList).toList());

  @override
  Future<List<TaskList>> getAll() async => (await _query.get()).map(_toList).toList();

  @override
  Future<void> save(TaskList list) => _db
      .into(_db.taskListsTable)
      .insert(
        TaskListsTableCompanion.insert(
          id: list.id,
          name: list.name,
          colorKey: list.colorKey,
          iconKey: list.iconKey,
          sortOrder: Value(list.sortOrder),
          createdAt: DateTime.now(),
        ),
        onConflict: DoUpdate(
          (_) => TaskListsTableCompanion(
            name: Value(list.name),
            colorKey: Value(list.colorKey),
            iconKey: Value(list.iconKey),
            sortOrder: Value(list.sortOrder),
          ),
        ),
      );

  @override
  Future<void> delete(String id) {
    assert(id != TaskList.inboxId, 'The inbox cannot be deleted');
    return (_db.delete(_db.taskListsTable)..where((l) => l.id.equals(id))).go();
  }

  TaskList _toList(TaskListRow row) =>
      TaskList(id: row.id, name: row.name, colorKey: row.colorKey, iconKey: row.iconKey, sortOrder: row.sortOrder);
}
