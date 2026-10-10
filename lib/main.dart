import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:klar/app.dart';
import 'package:klar/di/app_dependencies.dart';
import 'package:klar/features/alarms/data/alarm_sync_service.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/theme/klar_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'ru';
  await initializeDateFormatting('ru');
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(KlarTheme.overlayStyle);
  await AppDependencies.init(lookupL10n(const Locale('ru')));
  getIt<AlarmSyncService>().start();
  runApp(const KlarApp());
}
