import 'package:flutter/material.dart';
import 'package:aquatechinn_quiz/l10n/app_localizations.dart';
import 'package:aquatechinn_quiz/design/app_assets.dart';
import 'package:aquatechinn_quiz/design/app_colors.dart';
import 'package:aquatechinn_quiz/data/models.dart';
import 'package:aquatechinn_quiz/data/content_repository.dart';
import 'package:aquatechinn_quiz/data/progress_service.dart';
import 'package:aquatechinn_quiz/screens/topic_summary.dart';
import 'package:flutter/foundation.dart';
import 'package:aquatechinn_quiz/dev/dev_tools.dart';
import 'package:aquatechinn_quiz/widgets/aqua_bottom_nav.dart';
import 'package:aquatechinn_quiz/data/achievements_service.dart';
import 'package:aquatechinn_quiz/screens/module_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aquatechinn_quiz/data/user_profile_service.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({super.key});
  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  final _contentRepo = ContentRepository();
  final _progress = ProgressService();
  late final DevTools _dev = DevTools(_progress);
  final _profileSvc = UserProfileService();
  bool _welcomeScheduled = false;

  Future<void> _maybeShowWelcome(int streak) async {
    final sp = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Solo una vez por día
    final last = sp.getString('welcomeLastShown');
    if (last == todayKey) return;

    final profile = await _profileSvc.load();
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _WelcomeDialog(
        name: (profile.name.trim().isEmpty && profile.surname.trim().isEmpty)
            ? null
            : '${profile.name} ${profile.surname}'.trim(),
        streak: streak,
      ),
    );

    await sp.setString('welcomeLastShown', todayKey);
  }

  Future<(_VM, int, int, int)> _loadVM(BuildContext context) async {
    final bundle = await _contentRepo.load();

    final locale = Localizations.localeOf(context);
    final strings = await ContentStrings.loadForLocale(locale);

    final module = bundle.modules.firstWhere(
      (m) => m.id == 'm2',
      orElse: () => throw StateError(
        'Module "m2" not found. Available: ${bundle.modules.map((m) => m.id).join(", ")}',
      ),
    );

    final moduleIdx = bundle.modules.indexWhere((m) => m.id == module.id);
    final moduleIndexOneBased = moduleIdx >= 0 ? moduleIdx + 1 : 1;

    final topics = <Topic>[];
    for (final tid in module.topicIds) {
      final match = bundle.topics.where((t) => t.id == tid);
      topics.add(
        match.isNotEmpty
            ? match.first
            : Topic(
                id: tid,
                titleKey: 'topic.$tid.title',
                questionIds: const [],
              ),
      );
    }

    final bestStars = <String, int>{};
    for (final t in topics) {
      bestStars[t.id] = await _progress.getBestStars(module.id, t.id);
    }

    final totalStars = await _progress.totalStarsForModule(
      module.id,
      module.topicIds,
    );
    final streak = await _progress.updateAndGetStreak(DateTime.now());

    // Carga logros y badges reales
    final achService = AchievementsService();
    final badges = await achService.getBadgesCount();
    final achievements = await achService.getAchievementsCount();

    // NUEVO: leemos si el modo desbloqueo está activado
    final unlockAll = await _progress.isUnlockAllTopicsEnabled();

    return (
      _VM(module, topics, strings, bestStars, totalStars, moduleIndexOneBased, unlockAll),
      streak,
      badges,
      achievements,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return FutureBuilder<(_VM, int, int, int)>(
      future: _loadVM(context),
      builder: (context, snap) {
        if (snap.hasError) {
          // Helpful error UI instead of infinite spinner
          // ignore: avoid_print
          print('Questionnaire load error: ${snap.error}');
          return Scaffold(
            appBar: AppBar(title: Text(t.appTitle)),
            body: Center(
              child: Text(
                'Error loading content.\n${snap.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final (vm, streak, badges, achievements) = snap.data!;

        if (!_welcomeScheduled) {
          _welcomeScheduled = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _maybeShowWelcome(streak);
          });
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TopCounter(iconPath: AppIcons.flame, value: streak, size: 26),
                _TopCounter(
                  iconPath: AppIcons.thunder,
                  value: badges,
                  size: 26,
                ),
                _TopCounter(
                  iconPath: AppIcons.medal,
                  value: achievements,
                  size: 26,
                ),
                if (kDebugMode) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(
                      Icons.bug_report,
                      color: AppColors.darkBlue,
                    ),
                    tooltip: 'DEV panel',
                    onPressed: () => _openDevSheet(context),
                  ),
                ],
              ],
            ),
          ),

          // ==== Bottom Navigation (with label color fix) ====
          bottomNavigationBar: const AquaBottomNav(
            current: AquaTab.questionnaire,
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                // ===== Module card =====
                _RoundedBorderCard(
                  bgColor: AppColors.green,
                  borderColor: AppColors.darkBlue,
                  radius: 28,
                  padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          vm.strings.t('module.${vm.module.id}.title'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ModuleSummary(
                          moduleId: vm.module.id,
                          moduleIndexOneBased:
                              vm.moduleIndexOneBased, // 👈 ahora existe
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                // ===== Topics from data =====
                for (int i = 0; i < vm.topics.length; i++) ...[
                  _TopicTile(
                    moduleId: vm.module.id,
                    topicIndexOneBased: i + 1,
                    topic: vm.topics[i],
                    strings: vm.strings,
                    bestStars: vm.bestStars[vm.topics[i].id] ?? 0,
                    totalStarsInModule: vm.totalStars,
                    progress: _progress,
                    unlockAllTopics: vm.unlockAllTopics,
                    onReturn: () => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void _openDevSheet(BuildContext context) async {
    final data = await _contentRepo.load();
    final module = data.modules.firstWhere((m) => m.id == 'm2');
    final topics = module.topicIds;

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'DEV • Fake Data',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _dev.seedStars(
                          moduleId: 'm2',
                          topicId: topics[0],
                          stars: 3,
                        );
                        if (mounted) setState(() {});
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('T1 → 3★ (100%)'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _dev.seedStars(
                          moduleId: 'm2',
                          topicId: topics[1],
                          stars: 2,
                        );
                        if (mounted) setState(() {});
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('T2 → 2★ (75%)'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _dev.seedStars(
                          moduleId: 'm2',
                          topicId: topics[2],
                          stars: 1,
                        );
                        if (mounted) setState(() {});
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('T3 → 1★ (50%)'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _dev.seedAttempt(
                          moduleId: 'm2',
                          topicId: topics[3],
                          correct: 0,
                          total: 4,
                        );
                        if (mounted) setState(() {});
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('T4 → 0★ (0%)'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _progress.clearModule('m2', topics);
                        if (mounted) setState(() {});
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Clear Module M2'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _dev.bumpStreak();
                        if (mounted) setState(() {});
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('+1 day streak'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _dev.bumpStreak();
                        await _dev.bumpStreak();
                        await _dev.bumpStreak();
                        await _dev.bumpStreak();
                        await _dev.bumpStreak();
                        await _dev.bumpStreak();
                        await _dev.bumpStreak();
                        if (mounted) setState(() {});
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('+7 day streak'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _progress.resetStreak();
                        if (mounted) setState(() {});
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Reset Streak'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Tip: usa pull-to-refresh para forzar recarga.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VM {
  final Module module;
  final List<Topic> topics;
  final ContentStrings strings;
  final Map<String, int> bestStars;
  final int totalStars;
  final int moduleIndexOneBased; // NUEVO
  final bool unlockAllTopics; // NUEVO

  _VM(
    this.module,
    this.topics,
    this.strings,
    this.bestStars,
    this.totalStars,
    this.moduleIndexOneBased, // NUEVO
    this.unlockAllTopics, // NUEVO
  );
}

/// A tile that shows either unlocked topic with stars or a locked banner.
class _TopicTile extends StatelessWidget {
  final String moduleId;
  final int topicIndexOneBased;
  final Topic topic;
  final ContentStrings strings;
  final int bestStars;
  final int totalStarsInModule;
  final bool unlockAllTopics; // NUEVO
  final ProgressService progress;
  final VoidCallback? onReturn; // NEW

  const _TopicTile({
    required this.moduleId,
    required this.topicIndexOneBased,
    required this.topic,
    required this.strings,
    required this.bestStars,
    required this.totalStarsInModule,
    required this.unlockAllTopics, // NUEVO
    required this.progress,
    this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final requiredStars = progress.requiredStarsForIndex(topicIndexOneBased);
    final unlocked = unlockAllTopics || totalStarsInModule >= requiredStars;

    if (unlocked) {
      return _RoundedBorderCard(
        bgColor: AppColors.green.withValues(alpha: 0.75),
        borderColor: Colors.transparent,
        radius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                strings.t(topic.titleKey),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
            ),
            Row(
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: AppIcon(
                    i < bestStars ? AppIcons.filledStar : AppIcons.emptyStar,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TopicSummary(
                moduleId: moduleId,
                topicId: topic.id,
                topicTitleKey: strings.t(topic.titleKey),
                topicIndexOneBased: topicIndexOneBased,
              ),
            ),
          );
          // Force UI to reload SharedPreferences-based data
          onReturn?.call();
        },
      );
    }

    // Locked banner
    final have = totalStarsInModule;
    final need = requiredStars;
    final t = AppLocalizations.of(context)!;
    return _RoundedBorderCard(
      bgColor: Colors.blueGrey.shade500,
      borderColor: Colors.blueGrey.shade700,
      radius: 20,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AppIcon(AppIcons.lock, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t.earnMoreStars,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '$have/$need',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          AppIcon(AppIcons.emptyStar, size: 26),
        ],
      ),
    );
  }
}

// ===== Small helpers =====

class _TopCounter extends StatelessWidget {
  final String iconPath;
  final int value;
  final double size; // add this line

  const _TopCounter({
    required this.iconPath,
    required this.value,
    this.size = 24, // default
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconPath, width: size, height: size),
        const SizedBox(width: 6),
        Text(
          '$value',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}

class _RoundedBorderCard extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final Color borderColor;
  final double radius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const _RoundedBorderCard({
    required this.child,
    required this.bgColor,
    required this.borderColor,
    this.radius = 24,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor,
          width: borderColor.opacity > 0 ? 3 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlue.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );

    return onTap == null
        ? card
        : InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: card,
          );
  }
}

class _WelcomeDialog extends StatelessWidget {
  final String? name; // si null, mostramos “WELCOME BACK”
  final int streak;

  const _WelcomeDialog({required this.name, required this.streak});

  @override
  Widget build(BuildContext context) {
    final titleTop = (name == null || name!.isEmpty)
        ? 'WELCOME BACK'
        : 'WELCOME BACK\n${name!.toUpperCase()}';
    final streakText = 'Daily streak: $streak';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF8DB7F0), // azul del mock
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.darkBlue, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título grande
            Text(
              titleTop,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w900,
                fontSize: 26,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 14),

            // Línea divisoria del mock
            Container(height: 3, color: AppColors.darkBlue),
            const SizedBox(height: 14),

            // Streak + icono
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  streakText,
                  style: const TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const AppIcon(AppIcons.flame, size: 26),
              ],
            ),

            const SizedBox(height: 18),

            // Botón CONTINUE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.darkBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
