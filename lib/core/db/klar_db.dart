import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:klar/core/db/converters.dart';
import 'package:klar/core/db/tables.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';

part 'klar_db.g.dart';

@DriftDatabase(
  tables: [TaskListsTable, TasksTable, SubtasksTable, RemindersTable, CompletionsTable, SettingsTable],
)
class KlarDb extends _$KlarDb {
  KlarDb([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'klar'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await into(taskListsTable).insert(
        TaskListsTableCompanion.insert(
          id: TaskList.inboxId,
          name: 'Входящие',
          colorKey: 'birch',
          iconKey: 'tray',
          createdAt: DateTime.now(),
        ),
      );
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
