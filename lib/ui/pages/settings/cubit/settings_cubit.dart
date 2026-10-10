import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klar/features/alarms/domain/models/permission_report.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/features/settings/domain/models/app_settings.dart';
import 'package:klar/features/settings/domain/repos/settings_repo.dart';

class SettingsState extends Equatable {
  const SettingsState({required this.settings, this.report});

  final AppSettings settings;

  /// `null` until the first check finishes.
  final PermissionReport? report;

  SettingsState copyWith({AppSettings? settings, PermissionReport? report}) =>
      SettingsState(settings: settings ?? this.settings, report: report ?? this.report);

  @override
  List<Object?> get props => [settings, report];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._settingsRepo, this._engine) : super(SettingsState(settings: _settingsRepo.current)) {
    _subscription = _settingsRepo.watch().listen((settings) => emit(state.copyWith(settings: settings)));
    unawaited(refreshReport());
  }

  final SettingsRepo _settingsRepo;
  final AlarmEngine _engine;
  late final StreamSubscription<AppSettings> _subscription;

  Future<void> update(AppSettings Function(AppSettings settings) change) => _settingsRepo.update(change);

  Future<void> refreshReport() async {
    final report = await _engine.permissionReport();
    if (!isClosed) emit(state.copyWith(report: report));
  }

  Future<void> fix(SettingsTarget target) async {
    if (target == SettingsTarget.notifications) {
      final granted = await _engine.requestNotificationPermission();
      if (!granted) await _engine.openSettings(target);
    } else {
      await _engine.openSettings(target);
    }
    await refreshReport();
  }

  Future<void> openSettings(SettingsTarget target) => _engine.openSettings(target);

  Future<void> testAlarm() => _engine.testAlarm(seconds: 10);

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
