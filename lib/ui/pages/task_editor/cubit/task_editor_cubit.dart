import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klar/core/time/clock.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/settings/domain/models/app_settings.dart';
import 'package:klar/features/settings/domain/repos/settings_repo.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/subtask.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';
import 'package:klar/features/tasks/domain/repos/lists_repo.dart';
import 'package:klar/features/tasks/domain/repos/tasks_repo.dart';
import 'package:uuid/uuid.dart';

enum EditorStatus { loading, editing, closed }

class TaskEditorState extends Equatable {
  const TaskEditorState({
    required this.settings,
    this.draft,
    this.isNew = true,
    this.lists = const [],
    this.status = EditorStatus.loading,
  });

  final Task? draft;
  final bool isNew;
  final List<TaskList> lists;
  final AppSettings settings;
  final EditorStatus status;

  Task get task => draft!;

  bool get canSave => draft != null && draft!.title.trim().isNotEmpty;

  TaskList? get list => lists.where((l) => l.id == draft?.listId).firstOrNull;

  TaskEditorState copyWith({Task? draft, bool? isNew, List<TaskList>? lists, EditorStatus? status}) => TaskEditorState(
    draft: draft ?? this.draft,
    isNew: isNew ?? this.isNew,
    lists: lists ?? this.lists,
    settings: settings,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [draft, isNew, lists, settings, status];
}

class TaskEditorCubit extends Cubit<TaskEditorState> {
  TaskEditorCubit({
    required TasksRepo tasksRepo,
    required ListsRepo listsRepo,
    required SettingsRepo settingsRepo,
    required Clock clock,
  }) : _tasksRepo = tasksRepo,
       _listsRepo = listsRepo,
       _clock = clock,
       super(TaskEditorState(settings: settingsRepo.current));

  static const _uuid = Uuid();

  final TasksRepo _tasksRepo;
  final ListsRepo _listsRepo;
  final Clock _clock;

  Future<void> load({String? taskId, String? title, String? listId, LocalDate? date}) async {
    final lists = await _listsRepo.getAll();
    final existing = taskId == null ? null : await _tasksRepo.get(taskId);
    final draft =
        existing ??
        Task(
          id: _uuid.v4(),
          listId: lists.any((l) => l.id == listId) ? listId! : TaskList.inboxId,
          title: title ?? '',
          createdAt: _clock.now(),
          dueDate: date,
          sortOrder: _clock.now().millisecondsSinceEpoch ~/ 1000,
        );
    emit(state.copyWith(draft: draft, isNew: existing == null, lists: lists, status: EditorStatus.editing));
  }

  void _update(Task Function(Task task) change) => emit(state.copyWith(draft: change(state.task)));

  void setTitle(String title) => _update((t) => t.copyWith(title: title));

  void setNotes(String notes) => _update((t) => t.copyWith(notes: notes));

  void setList(String listId) => _update((t) => t.copyWith(listId: listId));

  void setPriority(Priority priority) => _update((t) => t.copyWith(priority: priority));

  void setDate(LocalDate? date) => _update((t) {
    if (date == null) {
      return t.copyWith(dueDate: () => null, dueTime: () => null, recurrence: () => null);
    }
    final rule = t.recurrence;
    final previous = t.dueDate;
    RecurrenceRule? reanchored;
    if (rule != null) {
      final followsDay =
          rule.frequency == RecurrenceFrequency.weekly && previous != null && rule.weekdays.length == 1 && rule.weekdays.first == previous.weekday;
      reanchored = rule.anchoredAt(date).copyWith(weekdays: followsDay ? {date.weekday} : null);
    }
    return t.copyWith(dueDate: () => date, recurrence: () => reanchored);
  });

  /// Setting a time for the first time adds an alarm at that moment, so timed tasks ring by default.
  void setTime(int? minutes) => _update((t) {
    final addAlarm = minutes != null && t.dueTime == null && t.reminders.isEmpty;
    return t.copyWith(
      dueDate: () => t.dueDate ?? _clock.today(),
      dueTime: () => minutes,
      reminders: addAlarm ? [Reminder(id: _uuid.v4(), offsetMinutes: 0, kind: ReminderKind.alarm)] : null,
    );
  });

  void setRecurrence(RecurrenceRule? rule) => _update((t) {
    if (rule == null) return t.copyWith(recurrence: () => null);
    final date = t.dueDate ?? rule.anchor;
    return t.copyWith(dueDate: () => date, recurrence: () => rule.anchoredAt(date));
  });

  void addReminder(int offsetMinutes, ReminderKind kind) => _update((t) {
    final reminders = [
      ...t.reminders,
      if (!t.reminders.any((r) => r.offsetMinutes == offsetMinutes && r.kind == kind))
        Reminder(id: _uuid.v4(), offsetMinutes: offsetMinutes, kind: kind),
    ]..sort((a, b) => b.offsetMinutes.compareTo(a.offsetMinutes));
    return t.copyWith(reminders: reminders);
  });

  void updateReminder(Reminder reminder) => _update(
    (t) => t.copyWith(
      reminders: [for (final r in t.reminders) r.id == reminder.id ? reminder : r]
        ..sort((a, b) => b.offsetMinutes.compareTo(a.offsetMinutes)),
    ),
  );

  void removeReminder(String id) =>
      _update((t) => t.copyWith(reminders: t.reminders.where((r) => r.id != id).toList()));

  void addSubtask(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    _update((t) => t.copyWith(subtasks: [...t.subtasks, Subtask(id: _uuid.v4(), title: trimmed)]));
  }

  void updateSubtask(Subtask subtask) =>
      _update((t) => t.copyWith(subtasks: [for (final s in t.subtasks) s.id == subtask.id ? subtask : s]));

  void removeSubtask(String id) => _update((t) => t.copyWith(subtasks: t.subtasks.where((s) => s.id != id).toList()));

  void reorderSubtasks(int oldIndex, int newIndex) => _update((t) {
    final subtasks = [...t.subtasks];
    final item = subtasks.removeAt(oldIndex);
    subtasks.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
    return t.copyWith(subtasks: subtasks);
  });

  void setSound(SoundRef? sound) => _update((t) => t.copyWith(sound: () => sound));

  void setVibration(VibrationPattern? vibration) => _update((t) => t.copyWith(vibration: () => vibration));

  Future<void> save() async {
    if (!state.canSave) return;
    final task = state.task;
    await _tasksRepo.save(
      task.copyWith(
        title: task.title.trim(),
        notes: task.notes.trim(),
        reminders: task.dueDate == null ? const [] : null,
      ),
    );
    emit(state.copyWith(status: EditorStatus.closed));
  }

  /// Returns the task as it was stored, for undo.
  Future<Task?> delete() async {
    final saved = await _tasksRepo.get(state.task.id);
    await _tasksRepo.delete(state.task.id);
    emit(state.copyWith(status: EditorStatus.closed));
    return saved;
  }
}
