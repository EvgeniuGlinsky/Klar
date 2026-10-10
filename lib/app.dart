import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/router/klar_router.dart';
import 'package:klar/ui/theme/klar_theme.dart';

class KlarApp extends StatefulWidget {
  const KlarApp({super.key});

  @override
  State<KlarApp> createState() => _KlarAppState();
}

class _KlarAppState extends State<KlarApp> {
  late final _router = KlarRouter.create();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    onGenerateTitle: (context) => L10n.of(context).appTitle,
    debugShowCheckedModeBanner: false,
    theme: KlarTheme.dark,
    darkTheme: KlarTheme.dark,
    themeMode: ThemeMode.dark,
    locale: const Locale('ru'),
    supportedLocales: L10n.supportedLocales,
    localizationsDelegates: const [
      L10n.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    routerConfig: _router,
  );
}
