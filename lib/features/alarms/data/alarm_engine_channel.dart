import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:klar/features/alarms/domain/models/alarm_spec.dart';
import 'package:klar/features/alarms/domain/models/done_event.dart';
import 'package:klar/features/alarms/domain/models/engine_config.dart';
import 'package:klar/features/alarms/domain/models/permission_report.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';

/// [AlarmEngine] backed by `AlarmChannel.kt`.
class AlarmEngineChannel implements AlarmEngine {
  AlarmEngineChannel({MethodChannel channel = const MethodChannel('klar/alarms')}) : _channel = channel {
    _channel.setMethodCallHandler(_onCall);
  }

  final MethodChannel _channel;
  final _eventsChanged = StreamController<void>.broadcast();
  final _openTask = StreamController<String>.broadcast();

  @override
  Stream<void> get eventsChanged => _eventsChanged.stream;

  @override
  Stream<String> get openTaskRequests => _openTask.stream;

  Future<Object?> _onCall(MethodCall call) async {
    switch (call.method) {
      case 'eventsChanged':
        _eventsChanged.add(null);
      case 'openTask':
        _openTask.add(call.arguments! as String);
    }
    return null;
  }

  @override
  Future<String?> takeLaunchTaskId() => _channel.invokeMethod<String>('takeLaunchTaskId');

  @override
  Future<List<DoneEvent>> drainEvents() async {
    final raw = await _channel.invokeListMethod<Map<Object?, Object?>>('drainEvents') ?? const [];
    return raw.map(DoneEvent.fromJson).toList();
  }

  @override
  Future<void> replaceAll({
    required EngineConfig config,
    required List<AlarmSpec> specs,
    required Map<String, String> liveTasks,
    required int ackSeq,
  }) => _channel.invokeMethod<void>('replaceAll', {
    // One JSON string keeps thousands of specs cheap to pass through the codec.
    'payload': jsonEncode({
      'config': config.toJson(),
      'specs': [for (final s in specs) s.toJson()],
      'live': liveTasks,
      'ackSeq': ackSeq,
    }),
  });

  @override
  Future<void> testAlarm({required int seconds}) => _channel.invokeMethod<void>('testAlarm', {'seconds': seconds});

  @override
  Future<SoundRef?> pickSystemSound() => _pick('pickSystemSound');

  @override
  Future<SoundRef?> pickAudioFile() => _pick('pickAudioFile');

  Future<SoundRef?> _pick(String method) async {
    final raw = await _channel.invokeMapMethod<String, Object?>(method);
    return raw == null ? null : SoundRef.fromJson(raw);
  }

  @override
  Future<void> previewSound(SoundRef sound) =>
      _channel.invokeMethod<void>('previewSound', {'sound': jsonEncode(sound.toJson())});

  @override
  Future<void> previewVibration(VibrationPattern pattern) =>
      _channel.invokeMethod<void>('previewVibration', {'pattern': pattern.name});

  @override
  Future<void> stopPreview() => _channel.invokeMethod<void>('stopPreview');

  @override
  Future<PermissionReport> permissionReport() async =>
      PermissionReport.fromJson(await _channel.invokeMapMethod<String, Object?>('permissionReport') ?? const {});

  @override
  Future<bool> requestNotificationPermission() async =>
      await _channel.invokeMethod<bool>('requestNotificationPermission') ?? false;

  @override
  Future<void> openSettings(SettingsTarget target) =>
      _channel.invokeMethod<void>('openSettings', {'target': target.name});
}
