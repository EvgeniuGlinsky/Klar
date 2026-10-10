import 'package:drift/drift.dart';
import 'package:klar/core/db/klar_db.dart';
import 'package:klar/features/settings/domain/models/app_settings.dart';
import 'package:klar/features/settings/domain/repos/settings_repo.dart';

class SettingsRepoImpl implements SettingsRepo {
  SettingsRepoImpl(this._db);

  final KlarDb _db;
  late AppSettings _current;

  SimpleSelectStatement<$SettingsTableTable, SettingsRow> get _query =>
      _db.select(_db.settingsTable)..where((s) => s.id.equals(0));

  @override
  Future<void> init() async {
    final row = await _query.getSingleOrNull();
    if (row == null) {
      _current = const AppSettings();
      await _write(_current);
    } else {
      _current = _fromRow(row);
    }
  }

  @override
  AppSettings get current => _current;

  @override
  Stream<AppSettings> watch() => _query.watchSingle().map((row) => _current = _fromRow(row));

  @override
  Future<void> update(AppSettings Function(AppSettings settings) change) async {
    _current = change(_current);
    await _write(_current);
  }

  Future<void> _write(AppSettings s) => _db
      .into(_db.settingsTable)
      .insertOnConflictUpdate(
        SettingsTableCompanion.insert(
          id: const Value(0),
          sound: s.sound,
          minVolume: Value(s.minVolume),
          rampSeconds: s.rampSeconds,
          vibration: s.vibration,
          snoozeMinutes: s.snoozeMinutes,
          autoSilenceMinutes: s.autoSilenceMinutes,
          allDayMinutes: s.allDayMinutes,
          firstWeekday: s.firstWeekday,
          onboarded: s.onboarded,
        ),
      );

  AppSettings _fromRow(SettingsRow row) => AppSettings(
    sound: row.sound,
    minVolume: row.minVolume,
    rampSeconds: row.rampSeconds,
    vibration: row.vibration,
    snoozeMinutes: row.snoozeMinutes,
    autoSilenceMinutes: row.autoSilenceMinutes,
    allDayMinutes: row.allDayMinutes,
    firstWeekday: row.firstWeekday,
    onboarded: row.onboarded,
  );
}
