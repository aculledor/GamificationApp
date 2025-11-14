// lib/widgets/bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:aquatechinn_quiz/design/app_assets.dart';
import 'package:aquatechinn_quiz/design/app_colors.dart';
import 'package:aquatechinn_quiz/l10n/app_localizations.dart';
import 'package:aquatechinn_quiz/screens/questionnaire.dart';
import 'package:aquatechinn_quiz/screens/performance.dart';
import 'package:aquatechinn_quiz/screens/options.dart';

enum AquaTab { questionnaire, performance, options }

class AquaBottomNav extends StatelessWidget {
  final AquaTab current;
  const AquaBottomNav({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    void go(AquaTab tab) {
      if (tab == current) return;
      Widget dest;
      switch (tab) {
        case AquaTab.questionnaire: dest = const Questionnaire(); break;
        case AquaTab.performance:   dest = const PerformanceScreen(); break;
        case AquaTab.options:       dest = const OptionsScreen(); break;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => dest),
      );
    }

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: AppColors.green.withValues(alpha: 0.45),
        indicatorColor: AppColors.lightBlue,
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.darkBlue,
        )),
      ),
      child: NavigationBar(
        selectedIndex: AquaTab.values.indexOf(current),
        onDestinationSelected: (i) => go(AquaTab.values[i]),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const AppIcon(AppIcons.checklist, size: 28),
            label: t.tabQuestionnaire,
          ),
          NavigationDestination(
            icon: const AppIcon(AppIcons.trophy, size: 28),
            label: t.tabPerformance,
          ),
          NavigationDestination(
            icon: const AppIcon(AppIcons.cogwheel, size: 28),
            label: t.tabOptions,
          ),
        ],
      ),
    );
  }
}
