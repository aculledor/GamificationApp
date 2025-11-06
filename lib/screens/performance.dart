// lib/screens/performance.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz/data/models.dart';
import 'package:quiz/design/app_assets.dart';
import 'package:quiz/design/app_colors.dart';
import 'package:quiz/l10n/app_localizations.dart';
import 'package:quiz/data/progress_service.dart';
import 'package:quiz/data/achievements_service.dart';
import 'package:quiz/screens/awards_gallery_screen.dart';
import 'package:quiz/screens/award_detail_screen.dart';
import 'package:quiz/widgets/aqua_bottom_nav.dart';
import 'package:quiz/widgets/aqua_badge_grid.dart';
import 'package:quiz/widgets/aqua_rounded_card.dart';
import 'package:quiz/data/content_repository.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});
  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  final _progress = ProgressService();
  final _ach = AchievementsService();
  final _contentRepo = ContentRepository();

  List<AwardItem> _recentBadges = [];
  List<AwardItem> _recentAchievements = [];

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
    final s = await _progress.updateAndGetStreak(DateTime.now());
    final b = await _ach.getBadgesCount();
    final a = await _ach.getAchievementsCount();

    // Cargar módulo y strings para construir títulos de badges con topic
    final bundle = await _contentRepo.load();
    final Module module = bundle.modules.firstWhere(
      (m) => m.id == 'm2',
      orElse: () => bundle.modules.first,
    );
    final topics = module.topicIds
        .map((tid) => bundle.topics.firstWhere((t) => t.id == tid))
        .toList();
    final strings = await ContentStrings.loadForLocale(
      Localizations.localeOf(context),
    );

    final recentBadges = await _ach.getRecentBadges(
      context: context,
      module: module,
      topics: topics,
      strings: strings,
      limit: 3,
    );
    final recentAchievements = await _ach.getRecentAchievements(
      context: context,
      module: module,
      topics: topics,
      strings: strings,
      limit: 3,
    );

    setState(() {
      _streak = s;
      _badges = b;
      _achievements = a;
      _recentBadges = recentBadges;
      _recentAchievements = recentAchievements;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: Text(
          t.tabPerformance,
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.w800,
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
              tooltip: 'DEV unlock 1 badge + 1 achievement',
              onPressed: () async {
                // Cargar contexto de contenido para titular correctamente el badge
                final bundle = await ContentRepository().load();
                final Module module = bundle.modules.firstWhere(
                  (m) => m.id == 'm2',
                  orElse: () => bundle.modules.first,
                );
                final topics = module.topicIds
                    .map((tid) => bundle.topics.firstWhere((t) => t.id == tid))
                    .toList();
                final strings = await ContentStrings.loadForLocale(
                  Localizations.localeOf(context),
                );

                // Desbloquear 1 de cada tipo (con fecha+popup)
                await _ach.debugUnlockOneEach(
                  context: context,
                  module: module,
                  topics: topics,
                  strings: strings,
                );

                // Refrescar métricas e “últimos 3”
                await _load();
              },
            ),
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.restart_alt, color: AppColors.darkBlue),
              tooltip: 'DEV reset counters and clear all awards',
              onPressed: () async {
                await _ach.clearAll();
                await _load();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All awards and counters reset.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
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
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _PillChip(
                        icon: AppIcons.flame,
                        label: t.streakDays(
                          days: '$_streak',
                        ), // e.g., "2 Day Streak"
                      ),
                      _PillChip(
                        icon: AppIcons.thunder,
                        label: t.badgesCount(count: _badges),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AwardsGalleryScreen(
                                type: AwardsType.badges,
                              ),
                            ),
                          );
                        },
                      ),
                      _PillChip(
                        icon: AppIcons.medal,
                        label: t.achievementsCount(count: _achievements),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AwardsGalleryScreen(
                                type: AwardsType.achievements,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _RowHeader(
                    title: t.badgesTitle,
                    actionLabel: t.reviewAll,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AwardsGalleryScreen(
                            type: AwardsType.badges,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (_recentBadges.isEmpty)
                    AquaRoundedCard(
                      bgColor: AppColors.green.withValues(alpha: 0.85),
                      borderColor: AppColors.darkBlue,
                      radius: 16,
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        t.keepPlayingToUnlock, // 🔤 traducido
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    AquaBadgeGrid(
                      count: _recentBadges.length,
                      titles: _recentBadges.map((b) => b.title ?? '').toList(),
                      dates: _recentBadges
                          .map((b) => b.date)
                          .toList(), // puede haber null
                      unlocked: _recentBadges.map((b) => b.unlocked).toList(),
                      iconPaths: _recentBadges
                          .map((b) => AppIcons.trophy) // TODO: b.iconPath
                          .toList(),
                      onTap: (i) {
                        final b = _recentBadges[i];

                        // Fallbacks por si algo viene null
                        final safeTitle = (b.title == null || b.title!.isEmpty)
                            ? '—' // o t.badgeGenericTitle(number: '${i+1}')
                            : b.title!;
                        final safeDesc = b.description ?? ''; // puede ser vacío
                        final safeIcon = AppIcons.trophy;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AwardDetailScreen(
                              title: safeTitle,
                              description: safeDesc, // nullable permitido
                              earned: b.unlocked,
                              earnedDate: b.unlocked
                                  ? b.date
                                  : null, // si no está ganado, no pases fecha
                              iconPath: safeIcon,
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),
                  _RowHeader(
                    title: t.achievementsTitle,
                    actionLabel: t.reviewAll,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AwardsGalleryScreen(
                            type: AwardsType.achievements,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (_recentAchievements.isEmpty)
                    AquaRoundedCard(
                      bgColor: AppColors.green.withValues(alpha: 0.85),
                      borderColor: AppColors.darkBlue,
                      radius: 16,
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        t.keepPlayingToUnlock, // 🔤 traducido
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    AquaBadgeGrid(
                      count: _recentAchievements.length,
                      titles: _recentAchievements
                          .map((a) => a.title ?? '')
                          .toList(),
                      dates: _recentAchievements
                          .map((a) => a.date)
                          .toList(), // puede haber null
                      unlocked:
                          _recentAchievements.map((a) => a.unlocked).toList(),
                      iconPaths: _recentAchievements
                          .map((a) => AppIcons.trophy) // TODO: a.iconPath
                          .toList(),
                      onTap: (i) {
                        final a = _recentAchievements[i];

                        // Fallbacks por si algo viene null
                        final safeTitle = (a.title == null || a.title!.isEmpty)
                            ? '—' // o t.achievementGenericTitle(number: '${i+1}')
                            : a.title!;
                        final safeDesc = a.description ?? ''; // puede ser vacío
                        final safeIcon = AppIcons.trophy;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AwardDetailScreen(
                              title: safeTitle,
                              description: safeDesc, // nullable permitido
                              earned: a.unlocked,
                              earnedDate: a.unlocked
                                  ? a.date
                                  : null, // si no está ganado, no pases fecha
                              iconPath: safeIcon,
                            ),
                          ),
                        );
                      },
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
        Text(
          title,
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.w800,
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
  const _RowHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

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
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w800,
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
  final VoidCallback? onTap; // NEW

  const _PillChip({
    required this.icon,
    required this.label,
    this.onTap, // NEW
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.90),
        border: Border.all(color: AppColors.darkBlue, width: 2),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlue.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(icon, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );

    // If onTap is provided, make it tappable with ripple
    return onTap == null
        ? child
        : Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: onTap,
              child: child,
            ),
          );
  }
}
