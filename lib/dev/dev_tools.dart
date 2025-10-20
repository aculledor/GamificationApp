// lib/dev/dev_tools.dart
import 'package:flutter/foundation.dart';
import 'package:gamificationapp/data/progress_service.dart';

class DevTools {
  final ProgressService _progress;
  DevTools(this._progress);

  /// Seed a specific attempt for a topic.
  Future<void> seedAttempt({
    required String moduleId,
    required String topicId,
    required int correct,
    required int total,
    DateTime? when,
  }) async {
    final pct = (total == 0) ? 0.0 : (correct * 100.0 / total);
    await _progress.saveAttempt(
      moduleId,
      topicId,
      pct,
      correct: correct,
      total: total,
      when: when ?? DateTime.now(),
    );
  }

  /// Seed stars by percent thresholds (1★ 50%, 2★ 75%, 3★ 100%).
  Future<void> seedStars({
    required String moduleId,
    required String topicId,
    required int stars, // 0..3
  }) async {
    int correct = 0, total = 4;
    switch (stars) {
      case 3:
        correct = 4;
        break; // 100%
      case 2:
        correct = 3;
        break; // 75%
      case 1:
        correct = 2;
        break; // 50%
      default:
        correct = 0; // 0%
    }
    await seedAttempt(
      moduleId: moduleId,
      topicId: topicId,
      correct: correct,
      total: total,
    );
  }

  /// Clear all best data for a list of topicIds.
  Future<void> clearModuleM2(List<String> topicIds) async {
    await _progress.clearModule('m2', topicIds);
  }

  /// Update or start the login streak.
  Future<int> bumpStreak() async {
    final now = DateTime.now();
    // Simula que el último login fue AYER, así diff==1 y sube la racha:
    await _progress.devSetLastLoginTo(now.subtract(const Duration(days: 1)));
    return _progress.updateAndGetStreak(now);
  }
}
