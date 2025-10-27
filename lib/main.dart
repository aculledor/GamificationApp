// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/questionnaire.dart';
import 'core/app_locale.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});
  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final _localeCtrl = AppLocaleController();

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      controller: _localeCtrl,
      child: AnimatedBuilder(
        animation: _localeCtrl,
        builder: (context, _) {
          return MaterialApp(
            title: 'AQUATECHinn 4.0 Gamification Quiz App',
            locale: _localeCtrl.locale, // 👈 fuerza el locale elegido
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.lightGreen),
            home: const Questionnaire(),
          );
        },
      ),
    );
  }
}
