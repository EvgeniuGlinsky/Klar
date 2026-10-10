import 'package:equatable/equatable.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/core/time/local_date_time.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';

/// One planned signal of one reminder of one task occurrence, as sent to the native engine.
class AlarmSpec extends Equatable {
  const AlarmSpec({
    required this.taskId,
    required this.reminderId,
    required this.occurrence,
    required this.trigger,
    required this.kind,
    required this.title,
    required this.body,
    this.sound,
    this.vibration,
  });

  final String taskId;
  final String reminderId;
  final LocalDate occurrence;

  /// Wall-clock time of the signal; the native side resolves it in the current time zone.
  final LocalDateTime trigger;
  final ReminderKind kind;
  final String title;
  final String body;

  /// Task-level overrides; `null` means the engine defaults.
  final SoundRef? sound;
  final VibrationPattern? vibration;

  String get key => '$taskId|$reminderId|${occurrence.iso}';

  Map<String, Object?> toJson() => {
    'key': key,
    'taskId': taskId,
    'occurrence': occurrence.iso,
    'trigger': trigger.iso,
    'kind': kind.name,
    'title': title,
    'body': body,
    if (sound != null) 'sound': sound!.toJson(),
    if (vibration != null) 'vibration': vibration!.name,
  };

  @override
  List<Object?> get props => [key, trigger, kind, title, body, sound, vibration];
}
