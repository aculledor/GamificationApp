import 'package:flutter/material.dart';
import 'package:gamificationapp/design/app_assets.dart';
import 'package:gamificationapp/design/app_colors.dart';
import 'package:gamificationapp/data/content_repository.dart';
import 'package:gamificationapp/data/models.dart';
import 'package:gamificationapp/data/progress_service.dart';
import 'package:gamificationapp/l10n/app_localizations.dart';
import 'package:gamificationapp/widgets/aqua_rounded_card.dart';
import 'package:gamificationapp/widgets/aqua_page_header.dart';
import 'package:gamificationapp/screens/topic_summary.dart';

class ModuleSummary extends StatefulWidget {
  final String moduleId; // p.ej. 'm2'
  final int moduleIndexOneBased; // para el título: "Module 1"
  const ModuleSummary({
    super.key,
    required this.moduleId,
    required this.moduleIndexOneBased,
  });

  @override
  State<ModuleSummary> createState() => _ModuleSummaryState();
}

class _ModuleSummaryState extends State<ModuleSummary> {
  final _contentRepo = ContentRepository();
  final _progress = ProgressService();

  bool _loading = true;
  late ContentStrings _strings;
  late Module _module;
  late List<Topic> _topics;

  int _totalStars = 0; // suma de bestStars en el módulo
  int _attempted = 0; // topics con intento previo

  final _topicStars = <String, int>{};
  final _topicBestCorrect = <String, int?>{};
  final _topicBestTotal = <String, int?>{};
  final _topicDate = <String, DateTime?>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bundle = await _contentRepo.load();
    final module = bundle.modules.firstWhere(
      (m) => m.id == widget.moduleId,
      orElse: () => bundle.modules.first,
    );

    final topics = module.topicIds
        .map((tid) => bundle.topics.firstWhere((t) => t.id == tid))
        .toList();

    final strings = await ContentStrings.loadForLocale(
      Localizations.localeOf(context),
    );

    // Cargar progreso por topic
    int sumStars = 0;
    int attempted = 0;

    for (final t in topics) {
      final stars = await _progress.getBestStars(module.id, t.id);
      _topicStars[t.id] = stars;
      sumStars += stars;

      final (c, tot) = await _progress.getBestRaw(module.id, t.id);
      _topicBestCorrect[t.id] = c;
      _topicBestTotal[t.id] = tot;
      if (c != null && tot != null) attempted++;

      final dt = await _progress.getBestDate(module.id, t.id);
      _topicDate[t.id] = dt;
    }

    setState(() {
      _module = module;
      _topics = topics;
      _strings = strings;
      _totalStars = sumStars;
      _attempted = attempted;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AquaPageHeader(
        title: t.summaryModuleTitle,
        leading: AquaLeading.back,
        onPressed: () => Navigator.pop(context),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
                children: [
                  _ModuleOverviewCard(
                    moduleTitle: _strings.t('module.${_module.id}.title'),
                    totalStars: _totalStars,
                    maxStars: _topics.length * 3,
                    attempted: _attempted,
                    totalTopics: _topics.length,
                    progressLabel: t.topicsProgressLabel(
                      done: '$_attempted',
                      total: '${_topics.length}',
                    ),
                  ),
                  const SizedBox(height: 16),

                  for (int i = 0; i < _topics.length; i++) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TopicSummary(
                              moduleId: _module.id,
                              topicId: _topics[i].id,
                              topicTitleKey: _strings.t(_topics[i].titleKey),
                              topicIndexOneBased: i + 1,
                            ),
                          ),
                        );
                      },
                      child: _TopicRowCard(
                        title: _strings.t(_topics[i].titleKey),
                        stars: _topicStars[_topics[i].id] ?? 0,
                        bestCorrect: _topicBestCorrect[_topics[i].id],
                        bestTotal: _topicBestTotal[_topics[i].id],
                        date: _topicDate[_topics[i].id],
                        t: t,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
    );
  }
}

/// Tarjeta superior con resumen del módulo (estrella total + progreso topics)
class _ModuleOverviewCard extends StatelessWidget {
  final String moduleTitle;
  final int totalStars;
  final int maxStars;
  final int attempted;
  final int totalTopics;
  final String progressLabel; // ej: "2/6 Topics" traducido
  final VoidCallback? onTapTitle; // 👈 nuevo parámetro opcional

  const _ModuleOverviewCard({
    required this.moduleTitle,
    required this.totalStars,
    required this.maxStars,
    required this.attempted,
    required this.totalTopics,
    required this.progressLabel,
    this.onTapTitle,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = totalTopics == 0 ? 0.0 : attempted / totalTopics;
    return AquaRoundedCard(
      bgColor: const Color(0xFFD6E5FF),
      borderColor: AppColors.darkBlue,
      radius: 18,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // fila título + estrellas totales
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTapTitle,
                  child: Text(
                    moduleTitle,
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline, // opcional
                    ),
                  ),
                ),
              ),
              const AppIcon(AppIcons.filledStar, size: 22),
              const SizedBox(width: 6),
              Text(
                '$totalStars/$maxStars',
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // barra de progreso + label centrado
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: ratio.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Text(
                progressLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tarjeta por cada topic (similar a TopicSummary compacta)
class _TopicRowCard extends StatelessWidget {
  final String title;
  final int stars; // 0..3
  final int? bestCorrect;
  final int? bestTotal;
  final DateTime? date;
  final AppLocalizations t;

  const _TopicRowCard({
    required this.title,
    required this.stars,
    required this.bestCorrect,
    required this.bestTotal,
    required this.date,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final showFirstTime = bestCorrect == null || bestTotal == null;

    return AquaRoundedCard(
      bgColor: AppColors.green.withValues(alpha: 0.85),
      borderColor: AppColors.green,
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // fila título + estrellas
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  3,
                  (i) => Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: AppIcon(
                      i < stars ? AppIcons.filledStar : AppIcons.emptyStar,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // píldora morada con score + fecha
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    showFirstTime
                        ? t.noPreviousScore
                        : t.lastBestScore(
                            score: '${bestCorrect ?? 0}',
                            total: '${bestTotal ?? 0}',
                          ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    t.dateLabel(date: _fmt(date)),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime? d) {
    if (d == null) return '---';
    final day = d.day.toString().padLeft(2, '0');
    final mon = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$mon/$year';
  }
}
