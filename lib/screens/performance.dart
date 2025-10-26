// lib/screens/performance.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamificationapp/design/app_assets.dart';
import 'package:gamificationapp/design/app_colors.dart';
import 'package:gamificationapp/l10n/app_localizations.dart';
import 'package:gamificationapp/data/progress_service.dart';
import 'package:gamificationapp/data/achievements_service.dart';
import 'package:gamificationapp/widgets/aqua_bottom_nav.dart';
import 'package:gamificationapp/widgets/aqua_badge_grid.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});
  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  final _progress = ProgressService();
  final _ach = AchievementsService();

  int _streak = 0;
  int _badges = 0;
  int _achievements = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // No incrementa la racha: solo la lee recalculando con el día actual
    // Para mostrar el valor correcto, reutilizamos update... (no cambia si es el mismo día)
    final s = await _progress.updateAndGetStreak(DateTime.now());
    final b = await _ach.getBadgesCount();
    final a = await _ach.getAchievementsCount();
    setState(() {
      _streak = s;
      _badges = b;
      _achievements = a;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0.5, centerTitle: false,
        title: Text(
          t.tabPerformance,
          style: const TextStyle(
            color: AppColors.darkBlue, fontWeight: FontWeight.w800,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: AppColors.darkBlue),
        ),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.bolt, color: AppColors.darkBlue),
              tooltip: 'DEV +1 badge / +1 achievement',
              onPressed: () async {
                await _ach.setBadgesCount(_badges + 1);
                await _ach.setAchievementsCount(_achievements + 1);
                await _load();
              },
            ),
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.restart_alt, color: AppColors.darkBlue),
              tooltip: 'DEV reset counters',
              onPressed: () async {
                await _ach.clearAll();
                await _load();
              },
            ),
        ],
      ),
      bottomNavigationBar: const AquaBottomNav(current: AquaTab.performance),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  _SectionHeader(title: t.performanceOverview),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _PillChip(
                        icon: AppIcons.flame,
                        label: t.streakDays(days: '$_streak'), // e.g., "2 Day Streak"
                      ),
                      _PillChip(
                        icon: AppIcons.thunder,
                        label: t.badgesCount(count: '$_badges'),
                      ),
                      _PillChip(
                        icon: AppIcons.medal,
                        label: t.achievementsCount(count: '$_achievements'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _RowHeader(title: t.badgesTitle, actionLabel: t.reviewAll, onTap: () {
                    // TODO: abrir listado completo de badges
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.comingSoon)),
                    );
                  }),
                  const SizedBox(height: 8),
                  AquaBadgeGrid(
                    count: _badges,
                  ),

                  const SizedBox(height: 20),
                  _RowHeader(title: t.achievementsTitle, actionLabel: t.reviewAll, onTap: () {
                    // TODO: abrir listado completo de achievements
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.comingSoon)),
                    );
                  }),
                  const SizedBox(height: 8),
                  AquaBadgeGrid(
                    count: _achievements,
                  ),
                ],
              ),
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style: const TextStyle(
            color: AppColors.darkBlue, fontSize: 20, fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Container(height: 2, color: AppColors.darkBlue),
      ],
    );
  }
}

class _RowHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onTap;
  const _RowHeader({required this.title, required this.actionLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SectionHeader(title: title)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionLabel,
            style: const TextStyle(
              color: AppColors.darkBlue, fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class _PillChip extends StatelessWidget {
  final String icon;
  final String label;
  const _PillChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.35),
        border: Border.all(color: AppColors.darkBlue, width: 2),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlue.withValues(alpha: 0.15),
            blurRadius: 8, offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(icon, size: 22),
          const SizedBox(width: 8),
          Text(label,
            style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}