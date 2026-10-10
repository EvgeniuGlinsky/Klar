import 'package:get_it/get_it.dart';
import 'package:klar/core/db/klar_db.dart';
import 'package:klar/core/time/clock.dart';
import 'package:klar/features/alarms/data/alarm_engine_channel.dart';
import 'package:klar/features/alarms/data/alarm_sync_service.dart';
import 'package:klar/features/alarms/data/alarm_texts.dart';
import 'package:klar/features/alarms/domain/alarm_planner.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/features/settings/data/repos/settings_repo_impl.dart';
import 'package:klar/features/settings/domain/repos/settings_repo.dart';
import 'package:klar/features/tasks/data/repos/lists_repo_impl.dart';
import 'package:klar/features/tasks/data/repos/tasks_repo_impl.dart';
import 'package:klar/features/tasks/domain/repos/lists_repo.dart';
import 'package:klar/features/tasks/domain/repos/tasks_repo.dart';
import 'package:klar/l10n/app_localizations.dart';

final getIt = GetIt.instance;

abstract final class AppDependencies {
  static Future<void> init(L10n l10n) async {
    final db = KlarDb();
    const clock = Clock();
    final settingsRepo = SettingsRepoImpl(db);
    await settingsRepo.init();

    getIt
      ..registerSingleton<Clock>(clock)
      ..registerSingleton<KlarDb>(db)
      ..registerSingleton<SettingsRepo>(settingsRepo)
      ..registerSingleton<TasksRepo>(TasksRepoImpl(db, clock))
      ..registerSingleton<ListsRepo>(ListsRepoImpl(db))
      ..registerSingleton<AlarmEngine>(AlarmEngineChannel())
      ..registerSingleton(
        AlarmSyncService(
          tasksRepo: getIt(),
          listsRepo: getIt(),
          settingsRepo: settingsRepo,
          engine: getIt(),
          planner: AlarmPlanner(texts: alarmTexts(l10n)),
          clock: clock,
        ),
      );
  }
}
