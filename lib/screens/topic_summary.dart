import 'package:flutter/material.dart';
import 'package:aquatechinn_quiz/design/app_assets.dart';
import 'package:aquatechinn_quiz/design/app_colors.dart';
import 'package:aquatechinn_quiz/data/progress_service.dart';
import 'package:aquatechinn_quiz/l10n/app_localizations.dart';
import 'package:aquatechinn_quiz/screens/topic_quiz.dart';
import 'package:aquatechinn_quiz/widgets/aqua_page_header.dart';
import 'package:flutter/foundation.dart';
import 'package:aquatechinn_quiz/widgets/aqua_rounded_card.dart';
import 'package:aquatechinn_quiz/widgets/aqua_pill_button.dart';

class TopicSummary extends StatefulWidget {
  final String moduleId;
  final String topicId;
  final String topicTitleKey; // ya localizado
  final int topicIndexOneBased;

  const TopicSummary({
    super.key,
    required this.moduleId,
    required this.topicId,
    required this.topicTitleKey,
    required this.topicIndexOneBased,
  });

  @override
  State<TopicSummary> createState() => _TopicSummaryState();
}

class _TopicSummaryState extends State<TopicSummary> {
  final _progress = ProgressService();

  int _bestStars = 0;
  int? _bestCorrect;
  int? _bestTotal;
  DateTime? _bestDate;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stars = await _progress.getBestStars(widget.moduleId, widget.topicId);
    final (c, t) = await _progress.getBestRaw(widget.moduleId, widget.topicId);
    final dt = await _progress.getBestDate(widget.moduleId, widget.topicId);

    setState(() {
      _bestStars = stars;
      _bestCorrect = c;
      _bestTotal = t;
      _bestDate = dt;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final title = t.summaryTopicTitle(number: '${widget.topicIndexOneBased}');
    final showFirstTime = _bestCorrect == null || _bestTotal == null;

    return Scaffold(
      appBar: AquaPageHeader(
        title: t.summaryTopicTitle(number: '${widget.topicIndexOneBased}'),
        leading: AquaLeading.close, // <- flecha a la izquierda
        onPressed: () => Navigator.of(context).pop(),
        actions: kDebugMode
            ? [
                IconButton(
                  icon: const Icon(Icons.bug_report, color: AppColors.darkBlue),
                  onPressed: () => debugPrint('DEV'),
                  tooltip: 'DEV',
                ),
              ]
            : null,
      ),
      backgroundColor: Colors.white,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ---- CONTENIDO SUPERIOR (tarjeta) ----
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AquaRoundedCard(
                          bgColor: AppColors.green.withValues(alpha: 0.85),
                          borderColor: AppColors.green,
                          radius: 18,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Fila 1: Título del tema (grande)
                              Text(
                                widget.topicTitleKey, // ya viene localizado
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.darkBlue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Fila 2: Estrellas (más grandes)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (i) {
                                  final filled = i < _bestStars;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: AppIcon(
                                      filled
                                          ? AppIcons.filledStar
                                          : AppIcons.emptyStar,
                                      size: 34,
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(height: 16),

                              // Fila 3: Píldora morada con best score + fecha (centrada)
// Fila 3: Píldora morada con best score + fecha (centrada)
// Fila 3: Píldora morada con best score + fecha (centrada)
// Fila 3: Píldora morada con best score + fecha (centrada)
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ConstrainedBox(
      constraints: BoxConstraints(
        // la píldora no será más ancha que la pantalla menos márgenes laterales
        maxWidth: MediaQuery.of(context).size.width - 32,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: showFirstTime
            // 👉 Caso sin puntuación previa: un solo texto centrado
            ? Text(
                t.noPreviousScore,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              )
            // 👉 Caso normal: puntuación en la primera línea, fecha en la segunda
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Línea 1: mejor puntuación anterior
                  Text(
                    t.lastBestScore(
                      score: '${_bestCorrect ?? 0}',
                      total: '${_bestTotal ?? 0}',
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Línea 2: fecha
                  Text(
                    t.dateLabel(
                      date: _formatDate(
                        _bestDate ?? DateTime.now(),
                        t,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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



                            
                            
                            
                            
                            ],
                          ),
                        ),

                        // Espacio extra para que el botón flotante no tape contenido si hay scroll
                        const SizedBox(height: 240),
                      ],
                    ),
                  ),

                  // ---- BOTÓN FLOTANTE (centrado con padding) ----
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: AquaPillButton.primary(
                          label: showFirstTime ? t.startQuiz : t.tryAgain,
                          onPressed: () async {
                            final changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TopicQuizScreen(
                                  moduleId: widget.moduleId,
                                  topicId: widget.topicId,
                                  topicTitle:
                                      widget.topicTitleKey, // ya localizado
                                ),
                              ),
                            );

                            if (!mounted) return;
                            if (changed == true) {
                              await _load(); // tu método que re-lee ProgressService
                              if (!mounted) return;
                              setState(
                                () {},
                              ); // refresca la tarjeta con nuevas estrellas/score
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatDate(DateTime d, AppLocalizations t) {
    // Simple dd/MM/yyyy
    final day = d.day.toString().padLeft(2, '0');
    final mon = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$mon/$year';
  }
}
