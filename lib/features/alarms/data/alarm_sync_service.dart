import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:klar/core/time/clock.dart';
import 'package:klar/features/alarms/domain/alarm_planner.dart';
import 'package:klar/features/alarms/domain/models/engine_config.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/features/settings/domain/repos/settings_repo.dart';
import 'package:klar/features/tasks/domain/repos/lists_repo.dart';
import 'package:klar/features/tasks/domain/repos/tasks_repo.dart';
import 'package:rxdart/rxdart.dart';

/// Keeps the native alarm schedule in line with the database.
///
/// Every run first applies "done" events recorded natively, then sends the complete plan, so a stale
/// plan can never resurrect an alarm the user already completed. Runs are serialized; changes that
/// arrive during a run trigger exactly one more run.
class AlarmSyncService {
  AlarmSyncService({
    required this._tasksRepo,
    required this._listsRepo,
    required this._settingsRepo,
    required this._engine,
    required this._planner,
    required this._clock,
  });

  static const _debounce = Duration(milliseconds: 300);

  final TasksRepo _tasksRepo;
  final ListsRepo _listsRepo;
  final SettingsRepo _settingsRepo;
  final AlarmEngine _engine;
  final AlarmPlanner _planner;
  final Clock _clock;

  final _subscriptions = <StreamSubscription<Object?>>[];
  AppLifecycleListener? _lifecycle;
  Timer? _timer;
  Future<void>? _running;
  bool _dirty = false;

  void start({bool observeLifecycle = true}) {
    _subscriptions
      ..add(
        MergeStream<Object?>([
          _tasksRepo.watchAll(),
          _listsRepo.watchAll(),
          _settingsRepo.watch(),
        ]).listen((_) => schedule()),
      )
      ..add(_engine.eventsChanged.listen((_) => schedule(immediate: true)));
    if (observeLifecycle) _lifecycle = AppLifecycleListener(onResume: () => schedule(immediate: true));
    schedule(immediate: true);
  }

  Future<void> dispose() async {
    _timer?.cancel();
    _lifecycle?.dispose();
    for (final s in _subscriptions) {
      await s.cancel();
    }
  }

  void schedule({bool immediate = false}) {
    _timer?.cancel();
    _timer = Timer(immediate ? Duration.zero : _debounce, sync);
  }

  /// Runs a sync now, or once more after the current one.
  Future<void> sync() {
    _dirty = true;
    return _running ??= _drain().whenComplete(() => _running = null);
  }

  Future<void> _drain() async {
    while (_dirty) {
      _dirty = false;
      try {
        await _runOnce();
      } on Object catch (e, s) {
        log('Alarm sync failed', error: e, stackTrace: s, name: 'klar.alarms');
      }
    }
  }

  Future<void> _runOnce() async {
    final events = await _engine.drainEvents();
    var ackSeq = 0;
    for (final event in events) {
      await _tasksRepo.complete(event.taskId, occurrence: event.occurrence, onlyIfCurrent: true);
      ackSeq = math.max(ackSeq, event.seq);
    }

    final settings = _settingsRepo.current;
    final plan = _planner.plan(
      tasks: await _tasksRepo.getAll(),
      lists: await _listsRepo.getAll(),
      settings: settings,
      now: _clock.localNow(),
    );
    await _engine.replaceAll(
      config: EngineConfig.fromSettings(settings, horizonEnd: plan.horizonEnd.toDateTime()),
      specs: plan.specs,
      upcoming: plan.upcoming,
      liveTasks: plan.liveTasks,
      ackSeq: ackSeq,
    );
  }
}
