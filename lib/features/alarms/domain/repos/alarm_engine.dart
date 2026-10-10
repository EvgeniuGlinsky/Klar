import 'package:klar/features/alarms/domain/models/alarm_spec.dart';
import 'package:klar/features/alarms/domain/models/done_event.dart';
import 'package:klar/features/alarms/domain/models/engine_config.dart';
import 'package:klar/features/alarms/domain/models/permission_report.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/models/upcoming_task.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';

enum SettingsTarget { notifications, exactAlarms, fullScreen, battery, reminderChannel, app }

/// The native alarm engine.
abstract interface class AlarmEngine {
  /// Fires when the native side recorded new events (e.g. "done" pressed on a ringing alarm).
  Stream<void> get eventsChanged;

  /// Task ids the user asked to open from a notification.
  Stream<String> get openTaskRequests;

  Future<String?> takeLaunchTaskId();

  Future<List<DoneEvent>> drainEvents();

  /// Replaces the whole schedule.
  ///
  /// [liveTasks] maps every not completed task to its current due date: snoozes of other tasks or of
  /// older occurrences are dropped and ringing for them stops. Events up to [ackSeq] are deleted.
  /// [upcoming] feeds the pinned "next task" notification.
  Future<void> replaceAll({
    required EngineConfig config,
    required List<AlarmSpec> specs,
    required List<UpcomingTask> upcoming,
    required Map<String, String> liveTasks,
    required int ackSeq,
  });

  /// Rings a sample alarm after [seconds].
  Future<void> testAlarm({required int seconds});

  Future<SoundRef?> pickSystemSound();

  Future<SoundRef?> pickAudioFile();

  Future<void> previewSound(SoundRef sound);

  Future<void> previewVibration(VibrationPattern pattern);

  Future<void> stopPreview();

  Future<PermissionReport> permissionReport();

  Future<bool> requestNotificationPermission();

  Future<void> openSettings(SettingsTarget target);
}
