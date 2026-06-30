// lib/screens/topic_quiz_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aquatechinn_quiz/design/app_assets.dart';
import 'package:aquatechinn_quiz/design/app_colors.dart';
import 'package:aquatechinn_quiz/data/content_repository.dart';
import 'package:aquatechinn_quiz/data/models.dart';
import 'package:aquatechinn_quiz/data/progress_service.dart';
import 'package:aquatechinn_quiz/l10n/app_localizations.dart';
import 'package:aquatechinn_quiz/widgets/aqua_page_header.dart';
import 'package:aquatechinn_quiz/widgets/aqua_rounded_card.dart';
import 'package:aquatechinn_quiz/widgets/aqua_pill_button.dart';

// ===== Config =====
const int kQuestionTimeSeconds = 60; // ⏱️ cambia aquí el tiempo por pregunta
const int kMaxQuestionsPerAttempt = 20;

// ====== QUIZ SCREEN ======
class TopicQuizScreen extends StatefulWidget {
  final String moduleId;
  final String topicId;
  final String topicTitle; // ya localizado

  const TopicQuizScreen({
    super.key,
    required this.moduleId,
    required this.topicId,
    required this.topicTitle,
  });

  @override
  State<TopicQuizScreen> createState() => _TopicQuizScreenState();
}

class _TopicQuizScreenState extends State<TopicQuizScreen> {
  final _repo = ContentRepository();
  final _progress = ProgressService();

  bool _loading = true;
  late ContentStrings _strings;
  late Topic _topic;
  late List<Question> _questions;

  int _idx = 0;
  int _correct = 0;

  // Estado por tipo de pregunta
  String? _selectedAnswerId; // para MULTI
  final _textCtrl = TextEditingController(); // para TEXT

  // Timer
  Timer? _timer;
  int _secondsLeft = kQuestionTimeSeconds;

  // Feedback flotante ✔︎ / ✖︎
  bool _showFeedback = false;
  bool _isCorrect = false;
  String? _highlightCorrectAnswerId;
  String? _correctFreeTextLabel;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void onLocaleChanged(Locale locale) {
    _reloadStrings(locale);
  }

  Future<void> _init() async {
    final bundle = await _repo.load();

    _topic = bundle.topics.firstWhere((t) => t.id == widget.topicId);
    _questions = _topic.questionIds
        .map((id) => bundle.questions.firstWhere((q) => q.id == id))
        .take(kMaxQuestionsPerAttempt)
        .toList();

    // 🔀 Shuffle the answers of multiple-choice questions
    for (final q in _questions) {
      if (q.type == QuestionType.multi) {
        q.answers.shuffle();
      }
    }

    await _reloadStrings(Localizations.localeOf(context));

    setState(() {
      _loading = false;
    });

    _startTimer();
  }

  Future<void> _reloadStrings(Locale locale) async {
    final s = await ContentStrings.loadForLocale(locale);
    if (!mounted) return;
    setState(() {
      _strings = s;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = kQuestionTimeSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        _onTimeout();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onTimeout() {
    _showAnswerFeedback(
      false,
      correctAnswerId: _correctAnswerId(),
      correctFreeTextLabel: _firstCorrectFreeTextLabel(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textCtrl.dispose();
    super.dispose();
  }

  Question get _q => _questions[_idx];
  String _normalizeAnswer(String s) {
    // quita comillas sueltas de inicio/fin (por si alguien escribió "hola")
    s = s.trim();
    if (s.length >= 2 &&
        ((s.startsWith('"') && s.endsWith('"')) ||
            (s.startsWith('\'') && s.endsWith('\'')))) {
      s = s.substring(1, s.length - 1);
    }

    // minúsculas + colapsa espacios
    s = s.toLowerCase();
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();

    // quita espacios y guiones/guion_bajo alrededor (opcional)
    s = s.replaceAll(RegExp(r'^[\-_\.]+|[\-_\.]+$'), '');

    // si quieres ser más permisivo: elimina puntuación común
    s = s.replaceAll(RegExp(r'[.,;:!?\u00B4`´]'), '');

    // Nota: Quitar acentos/diacríticos requeriría lib extra;
    // si te hace falta, podemos añadir un mapa básico para es/el/tr.
    return s;
  }

  String? _correctAnswerId() {
    if (_q.type != QuestionType.multi) return null;
    return _q.answers.where((a) => a.correct).map((a) => a.id).firstOrNull;
  }

  String? _firstCorrectFreeTextLabel() {
    final first = _q.correctFreeText?.firstOrNull;
    if (first == null) return null;
    return _strings.t(first);
  }

  void _checkAndNext() {
    if (_q.type == QuestionType.multi) {
      if (_selectedAnswerId == null) return; // nada seleccionado
      final ans = _q.answers.firstWhere((a) => a.id == _selectedAnswerId);
      _showAnswerFeedback(ans.correct, correctAnswerId: _correctAnswerId());
    } else {
      // ===== Texto libre robusto =====
      final userRaw = _textCtrl.text;
      final user = _normalizeAnswer(userRaw);

      // Cada entrada puede ser una clave i18n o un literal.
      // Comparamos contra AMBOS: la clave y su traducción.
      final valid = (_q.correctFreeText ?? [])
          .expand((k) {
            final keyNorm = _normalizeAnswer(k);
            final trNorm = _normalizeAnswer(_strings.t(k));
            return [keyNorm, trNorm];
          })
          .where((s) => s.isNotEmpty)
          .toSet()
          .contains(user);

      _showAnswerFeedback(
        valid,
        correctFreeTextLabel: _firstCorrectFreeTextLabel(),
      );
    }
  }

  void _showAnswerFeedback(
    bool ok, {
    String? correctAnswerId,
    String? correctFreeTextLabel,
  }) async {
    _timer?.cancel();
    setState(() {
      _isCorrect = ok;
      _showFeedback = true;
      _highlightCorrectAnswerId = ok ? null : correctAnswerId;
      _correctFreeTextLabel = ok ? null : correctFreeTextLabel;
    });

    if (ok) _correct++;

    await Future.delayed(Duration(milliseconds: ok ? 900 : 1500));
    if (!mounted) return;

    // Siguiente o fin
    if (_idx + 1 < _questions.length) {
      setState(() {
        _idx++;
        _selectedAnswerId = null;
        _textCtrl.clear();
        _showFeedback = false;
        _highlightCorrectAnswerId = null;
        _correctFreeTextLabel = null;
      });
      _startTimer();
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    final total = _questions.length;
    final pct = (total == 0) ? 0.0 : (_correct * 100.0 / total);
    await _progress.saveAttempt(
      widget.moduleId,
      widget.topicId,
      pct,
      correct: _correct,
      total: total,
    );
    if (!mounted) return;

    // Navegamos a resultados; al cerrar resultados hacemos pop(true)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _QuizResultScreen(
          topicTitle: widget.topicTitle,
          correct: _correct,
          total: total,
          stars: _progress.starsFromPercent(pct),
        ),
      ),
    );
  }

  Future<void> _confirmExit() async {
    final t = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.warningTitle),
        content: Text(t.quizExitWarning),
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.pop(context),
              Navigator.pop(context, true),
            },
            child: Text(t.continueQuiz),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => {
              Navigator.pop(context),
              Navigator.pop(context, true),
            },
            child: Text(t.yesExit),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      Navigator.pop(context); // vuelve sin cambios
      Navigator.pop(context, true); // vuelve sin cambios
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final questionLabel = '${t.question} ${_idx + 1}/${_questions.length}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AquaPageHeader(
        title: questionLabel,
        leading: AquaLeading.close,
        onPressed: _confirmExit,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                // Barra tiempo
                _TimeBar(secondsLeft: _secondsLeft),
                const SizedBox(height: 12),

                // Media (opcional)
                if (_q.imageAsset != null) ...[
                  AquaRoundedCard(
                    bgColor: Colors.white,
                    borderColor: AppColors.darkBlue,
                    radius: 16,
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        _q.imageAsset!,
                        fit: BoxFit.cover,
                        height: 180,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Enlace a vídeo (simple, sin dependencias)
                if (_q.videoUrl != null) ...[
                  Text(
                    'Video: ${_q.videoUrl}',
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Enunciado
                AquaRoundedCard(
                  bgColor: Colors.white,
                  borderColor: AppColors.darkBlue,
                  radius: 14,
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _strings.t(_q.textKey),
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Respuestas
                if (_q.type == QuestionType.multi)
                  _MultiAnswers(
                    answers: _q.answers
                        .map((a) => (id: a.id, label: _strings.t(a.textKey)))
                        .toList(),
                    selectedId: _selectedAnswerId,
                    correctId: _highlightCorrectAnswerId,
                    feedbackVisible: _showFeedback,
                    onSelect: (id) => setState(() => _selectedAnswerId = id),
                  )
                else ...[
                  _FreeTextField(
                    controller: _textCtrl,
                    hint: t.freeTextHint, // i18n
                  ),
                  if (_correctFreeTextLabel != null) ...[
                    const SizedBox(height: 10),
                    AquaRoundedCard(
                      bgColor: AppColors.green.withOpacity(0.3),
                      borderColor: AppColors.darkBlue,
                      radius: 16,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _correctFreeTextLabel!,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),

            // Botón CHECK
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SizedBox(
                height: 54,
                child: AquaPillButton(
                  label: t.check,
                  onPressed: _checkAndNext,
                  backgroundColor: AppColors.green,
                  textColor: AppColors.darkBlue,
                  borderColor: AppColors.darkBlue,
                ),
              ),
            ),

            // Feedback ✔︎ / ✖︎
            if (_showFeedback)
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: _isCorrect ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isCorrect ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 90,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ===== RESULT SCREEN =====
class _QuizResultScreen extends StatelessWidget {
  final String topicTitle;
  final int correct;
  final int total;
  final int stars;

  const _QuizResultScreen({
    required this.topicTitle,
    required this.correct,
    required this.total,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AquaPageHeader(
        // Muestra el título del tema; al cerrar devolvemos `true` para refrescar
        title: '${t.summaryLabel} – $topicTitle',
        leading: AquaLeading.close,
        onPressed: () => {Navigator.pop(context), Navigator.pop(context, true)},
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AppIcon(
                          i < stars ? AppIcons.filledStar : AppIcons.emptyStar,
                          size: 42,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '$correct/$total ${t.successes}',
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SizedBox(
                height: 56,
                child: AquaPillButton(
                  label: t.continueLabel,
                  onPressed: () => {
                    Navigator.pop(context),
                    Navigator.pop(context, true),
                  },
                  backgroundColor: AppColors.green,
                  textColor: AppColors.darkBlue,
                  borderColor: AppColors.darkBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== widgets auxiliares =====

class _TimeBar extends StatelessWidget {
  final int secondsLeft;
  const _TimeBar({required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    final ratio = secondsLeft / kQuestionTimeSeconds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            FractionallySizedBox(
              widthFactor: ratio.clamp(0.0, 1.0),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: ratio > 0.33 ? AppColors.green : Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${secondsLeft}s',
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MultiAnswers extends StatelessWidget {
  final List<({String id, String label})> answers;
  final String? selectedId;
  final String? correctId;
  final bool feedbackVisible;
  final ValueChanged<String> onSelect;

  const _MultiAnswers({
    required this.answers,
    required this.selectedId,
    required this.correctId,
    required this.feedbackVisible,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: answers
          .map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AquaPillButton(
                label: a.label,
                onPressed: () => onSelect(a.id),
                backgroundColor: correctId == a.id
                    ? AppColors.green.withOpacity(0.45)
                    : feedbackVisible && selectedId == a.id
                        ? Colors.red.withOpacity(0.25)
                        : selectedId == a.id
                            ? AppColors.green.withOpacity(0.3)
                            : Colors.white,
                textColor: AppColors.darkBlue,
                borderColor: correctId == a.id || selectedId == a.id
                    ? AppColors.darkBlue
                    : AppColors.darkBlue.withOpacity(0.5),
                uppercase: false,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _FreeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _FreeTextField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return AquaRoundedCard(
      bgColor: Colors.white,
      borderColor: AppColors.darkBlue,
      radius: 16,
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: hint.isNotEmpty ? hint : 'Type your answer',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
