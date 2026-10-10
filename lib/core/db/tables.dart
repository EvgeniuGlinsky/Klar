import 'package:drift/drift.dart';
import 'package:klar/core/db/converters.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/task.dart';

@DataClassName('TaskListRow')
class TaskListsTable extends Table {
  @override
  String get tableName => 'task_lists';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get colorKey => text()();
  TextColumn get iconKey => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TaskRow')
class TasksTable extends Table {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  TextColumn get listId => text().references(TaskListsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get priority => intEnum<Priority>().withDefault(const Constant(0))();
  TextColumn get dueDate => text().map(const LocalDateConverter()).nullable()();
  IntColumn get dueTime => integer().nullable()();
  TextColumn get recurrence => text().map(const RecurrenceConverter()).nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get sound => text().map(const SoundRefConverter()).nullable()();
  TextColumn get vibration => textEnum<VibrationPattern>().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SubtaskRow')
class SubtasksTable extends Table {
  @override
  String get tableName => 'subtasks';

  TextColumn get id => text()();
  TextColumn get taskId => text().references(TasksTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReminderRow')
class RemindersTable extends Table {
  @override
  String get tableName => 'reminders';

  TextColumn get id => text()();
  TextColumn get taskId => text().references(TasksTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get offsetMinutes => integer()();
  TextColumn get kind => textEnum<ReminderKind>()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// History of completed occurrences of recurring tasks; also makes native "done" events idempotent.
@DataClassName('CompletionRow')
class CompletionsTable extends Table {
  @override
  String get tableName => 'completions';

  TextColumn get taskId => text().references(TasksTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get occurrence => text().map(const LocalDateConverter())();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {taskId, occurrence};
}

/// A single row (id = 0) with the app settings.
@DataClassName('SettingsRow')
class SettingsTable extends Table {
  @override
  String get tableName => 'settings';

  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get sound => text().map(const SoundRefConverter())();
  IntColumn get minVolume => integer().nullable()();
  IntColumn get rampSeconds => integer()();
  TextColumn get vibration => textEnum<VibrationPattern>()();
  IntColumn get snoozeMinutes => integer()();
  IntColumn get autoSilenceMinutes => integer()();
  IntColumn get allDayMinutes => integer()();
  IntColumn get firstWeekday => integer()();
  BoolColumn get onboarded => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
