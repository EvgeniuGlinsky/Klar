import 'package:klar/features/settings/domain/models/app_settings.dart';

abstract interface class SettingsRepo {
  /// Loads the settings; must complete before [current] is read.
  Future<void> init();

  AppSettings get current;

  /// Emits the current settings and every change.
  Stream<AppSettings> watch();

  Future<void> update(AppSettings Function(AppSettings settings) change);
}
