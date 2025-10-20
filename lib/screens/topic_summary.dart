import 'package:flutter/material.dart';
import 'package:gamificationapp/design/app_assets.dart';
import 'package:gamificationapp/design/app_colors.dart';
import 'package:gamificationapp/data/progress_service.dart';
import 'package:gamificationapp/l10n/app_localizations.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const AppIcon(
            AppIcons.close,
            size: 28,
            allowTint: true,
            color: AppColors.darkBlue,
          ),
          tooltip: t.backTooltip,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 2, color: AppColors.darkBlue),
        ),
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
                        _RoundedBorderCard(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.darkBlue,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          showFirstTime
                                              ? t.noPreviousScore
                                              : t.lastBestScore(
                                                  score: '${_bestCorrect ?? 0}',
                                                  total: '${_bestTotal ?? 0}',
                                                ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        if (!showFirstTime) ...[
                                          const SizedBox(width: 16),
                                          Text(
                                            t.dateLabel(
                                              date: _formatDate(
                                                _bestDate ?? DateTime.now(),
                                                t,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ],
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ), // margen lateral
                      child: SizedBox(
                        width: double.infinity, // se expande, pero respeta el padding
                        height: 56,
                        child: _OutlineFillButton(
                          label: showFirstTime ? t.startQuiz : t.tryAgain,
                          onPressed: () {
                            // TODO: Navegar al quiz pasando moduleId y topicId
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(...)));
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

// --- Reutilizables (card + botón) ---

class _RoundedBorderCard extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final Color borderColor;
  final double radius;
  final EdgeInsetsGeometry padding;

  const _RoundedBorderCard({
    required this.child,
    required this.bgColor,
    required this.borderColor,
    this.radius = 18,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlue.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class _OutlineFillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _OutlineFillButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.85),
            border: Border.all(color: AppColors.darkBlue, width: 2),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightBlue.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
