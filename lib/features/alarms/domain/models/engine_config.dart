import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/settings/domain/models/app_settings.dart';

/// Ringing defaults the native engine applies when a spec has no overrides.
class EngineConfig {
  const EngineConfig({
    required this.sound,
    required this.vibration,
    required this.minVolume,
    required this.rampSeconds,
    required this.snoozeMinutes,
    required this.autoSilenceMinutes,
    required this.horizonEnd,
  });

  factory EngineConfig.fromSettings(AppSettings settings, {required DateTime horizonEnd}) => EngineConfig(
    sound: settings.sound,
    vibration: settings.vibration,
    minVolume: settings.minVolume,
    rampSeconds: settings.rampSeconds,
    snoozeMinutes: settings.snoozeMinutes,
    autoSilenceMinutes: settings.autoSilenceMinutes,
    horizonEnd: horizonEnd,
  );

  final SoundRef sound;
  final VibrationPattern vibration;
  final int? minVolume;
  final int rampSeconds;
  final int snoozeMinutes;
  final int autoSilenceMinutes;

  /// When the planned schedule runs out; the engine nudges the user to open the app before that.
  final DateTime horizonEnd;

  Map<String, Object?> toJson() => {
    'sound': sound.toJson(),
    'vibration': vibration.name,
    'minVolume': minVolume,
    'rampSeconds': rampSeconds,
    'snoozeMinutes': snoozeMinutes,
    'autoSilenceMinutes': autoSilenceMinutes,
    'horizonEnd': horizonEnd.millisecondsSinceEpoch,
  };
}
