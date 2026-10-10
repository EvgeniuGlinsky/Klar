import 'package:equatable/equatable.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/core/time/local_date_time.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/subtask.dart';

enum Priority { none, low, medium, high }

class Task extends Equatable {
  const Task({
    required this.id,
    required this.listId,
    required this.title,
    required this.createdAt,
    this.notes = '',
    this.priority = Priority.none,
    this.dueDate,
    this.dueTime,
    this.recurrence,
    this.completedAt,
    this.sortOrder = 0,
    this.sound,
    this.vibration,
    this.subtasks = const [],
    this.reminders = const [],
  });

  final String id;
  final String listId;
  final String title;
  final String notes;
  final Priority priority;
  final LocalDate? dueDate;

  /// Minutes since midnight; `null` means the task is for the whole day.
  final int? dueTime;
  final RecurrenceRule? recurrence;
  final DateTime? completedAt;
  final DateTime createdAt;
  final int sortOrder;

  /// Per-task overrides of the default alarm sound and vibration.
  final SoundRef? sound;
  final VibrationPattern? vibration;
  final List<Subtask> subtasks;
  final List<Reminder> reminders;

  bool get isCompleted => completedAt != null;

  bool get isRecurring => recurrence != null;

  bool get hasAlarm => reminders.any((r) => r.kind == ReminderKind.alarm);

  int get subtasksDone => subtasks.where((s) => s.done).length;

  /// The due moment, using [allDayMinutes] for tasks without a time.
  LocalDateTime? dueAt({required int allDayMinutes}) {
    final date = dueDate;
    return date == null ? null : LocalDateTime(date, dueTime ?? allDayMinutes);
  }

  bool isOverdue(LocalDateTime now) {
    final date = dueDate;
    if (date == null || isCompleted) return false;
    if (date.isBefore(now.date)) return true;
    final time = dueTime;
    return date == now.date && time != null && time < now.minutes;
  }

  Task copyWith({
    String? listId,
    String? title,
    String? notes,
    Priority? priority,
    LocalDate? Function()? dueDate,
    int? Function()? dueTime,
    RecurrenceRule? Function()? recurrence,
    DateTime? Function()? completedAt,
    int? sortOrder,
    SoundRef? Function()? sound,
    VibrationPattern? Function()? vibration,
    List<Subtask>? subtasks,
    List<Reminder>? reminders,
  }) => Task(
    id: id,
    listId: listId ?? this.listId,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    priority: priority ?? this.priority,
    dueDate: dueDate != null ? dueDate() : this.dueDate,
    dueTime: dueTime != null ? dueTime() : this.dueTime,
    recurrence: recurrence != null ? recurrence() : this.recurrence,
    completedAt: completedAt != null ? completedAt() : this.completedAt,
    createdAt: createdAt,
    sortOrder: sortOrder ?? this.sortOrder,
    sound: sound != null ? sound() : this.sound,
    vibration: vibration != null ? vibration() : this.vibration,
    subtasks: subtasks ?? this.subtasks,
    reminders: reminders ?? this.reminders,
  );

  @override
  List<Object?> get props => [
    id,
    listId,
    title,
    notes,
    priority,
    dueDate,
    dueTime,
    recurrence,
    completedAt,
    createdAt,
    sortOrder,
    sound,
    vibration,
    subtasks,
    reminders,
  ];
}
