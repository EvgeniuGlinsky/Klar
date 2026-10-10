import 'package:equatable/equatable.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.sound = SoundRef.fjord,
    this.minVolume,
    this.rampSeconds = 30,
    this.vibration = VibrationPattern.standard,
    this.snoozeMinutes = 10,
    this.autoSilenceMinutes = 10,
    this.allDayMinutes = 9 * 60,
    this.firstWeekday = DateTime.monday,
    this.onboarded = false,
  });

  static const rampOptions = [0, 10, 30, 60];
  static const snoozeOptions = [5, 10, 15, 20, 30];
  static const autoSilenceOptions = [1, 5, 10, 15, 30];

  final SoundRef sound;

  /// Minimum alarm stream volume in percent while ringing; `null` keeps the system volume.
  final int? minVolume;

  /// How long the alarm takes to fade in; 0 rings at full volume immediately.
  final int rampSeconds;
  final VibrationPattern vibration;
  final int snoozeMinutes;
  final int autoSilenceMinutes;

  /// Reminder time for tasks that have a date but no time.
  final int allDayMinutes;
  final int firstWeekday;
  final bool onboarded;

  AppSettings copyWith({
    SoundRef? sound,
    int? Function()? minVolume,
    int? rampSeconds,
    VibrationPattern? vibration,
    int? snoozeMinutes,
    int? autoSilenceMinutes,
    int? allDayMinutes,
    int? firstWeekday,
    bool? onboarded,
  }) => AppSettings(
    sound: sound ?? this.sound,
    minVolume: minVolume != null ? minVolume() : this.minVolume,
    rampSeconds: rampSeconds ?? this.rampSeconds,
    vibration: vibration ?? this.vibration,
    snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
    autoSilenceMinutes: autoSilenceMinutes ?? this.autoSilenceMinutes,
    allDayMinutes: allDayMinutes ?? this.allDayMinutes,
    firstWeekday: firstWeekday ?? this.firstWeekday,
    onboarded: onboarded ?? this.onboarded,
  );

  @override
  List<Object?> get props => [
    sound,
    minVolume,
    rampSeconds,
    vibration,
    snoozeMinutes,
    autoSilenceMinutes,
    allDayMinutes,
    firstWeekday,
    onboarded,
  ];
}
