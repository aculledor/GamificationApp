import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _kBestPct = 'bestPct'; // double 0..100
  static const _kBestStars = 'bestStars'; // int 0..3
  static const _kLastLogin = 'lastLoginDate'; // yyyy-mm-dd
  static const _kStreak = 'loginStreak';
  static const _kBestCorrect = 'bestCorrect';
  static const _kBestTotal = 'bestTotal';
  static const _kBestDateIso = 'bestDateIso';

  String _topicKey(String moduleId, String topicId, String field) =>
      'mod:$moduleId|topic:$topicId|$field';

  Future<int> getBestStars(String moduleId, String topicId) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_topicKey(moduleId, topicId, _kBestStars)) ?? 0;
  }

  Future<double> getBestPct(String moduleId, String topicId) async {
    final sp = await SharedPreferences.getInstance();
    return (sp.getDouble(_topicKey(moduleId, topicId, _kBestPct)) ?? 0);
  }

  /// Convert percent correct -> stars per your rule.
  int starsFromPercent(double pct) {
    if (pct >= 99.999) return 3; // treat 100% robustly
    if (pct >= 75.0) return 2;
    if (pct >= 50.0) return 1;
    return 0;
  }

  /// Save only if it's better than previous best.
  Future<void> saveAttempt(
    String moduleId,
    String topicId,
    double percent, {
    int? correct,
    int? total,
    DateTime? when,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final prevPct = await getBestPct(moduleId, topicId);
    if (percent <= prevPct) return;

    final stars = starsFromPercent(percent);
    await sp.setDouble(_topicKey(moduleId, topicId, _kBestPct), percent);
    await sp.setInt(_topicKey(moduleId, topicId, _kBestStars), stars);

    if (correct != null && total != null) {
      await sp.setInt(_topicKey(moduleId, topicId, _kBestCorrect), correct);
      await sp.setInt(_topicKey(moduleId, topicId, _kBestTotal), total);
    }
    await sp.setString(
      _topicKey(moduleId, topicId, _kBestDateIso),
      (when ?? DateTime.now()).toIso8601String(),
    );
  }

  /// Sum all best stars for a module.
  Future<int> totalStarsForModule(
    String moduleId,
    List<String> topicIds,
  ) async {
    int sum = 0;
    for (final tid in topicIds) {
      sum += await getBestStars(moduleId, tid);
    }
    return sum;
  }

  /// Unlock condition: topic index (1-based) needs (index-1)*2 total stars.
  int requiredStarsForIndex(int oneBasedIndex) =>
      max(0, (oneBasedIndex - 1) * 2);

  /// Simple login streak: call once per app open.
  Future<int> updateAndGetStreak(DateTime now) async {
    final sp = await SharedPreferences.getInstance();
    final today = DateTime(now.year, now.month, now.day);
    final lastRaw = sp.getString(_kLastLogin);
    final streak = sp.getInt(_kStreak) ?? 0;

    DateTime? last = lastRaw == null ? null : DateTime.tryParse(lastRaw);
    int nextStreak = streak;

    if (last == null) {
      nextStreak = 1;
    } else {
      final lastDay = DateTime(last.year, last.month, last.day);
      final diff = today.difference(lastDay).inDays;
      if (diff == 0) {
        nextStreak = streak; // same day
      } else if (diff == 1) {
        nextStreak = streak + 1; // consecutive day
      } else if (diff > 1) {
        nextStreak = 1; // streak broken
      }
    }
    await sp.setString(_kLastLogin, today.toIso8601String());
    await sp.setInt(_kStreak, nextStreak);
    return nextStreak;
  }

  Future<(int? correct, int? total)> getBestRaw(
    String moduleId,
    String topicId,
  ) async {
    final sp = await SharedPreferences.getInstance();
    final c = sp.getInt(_topicKey(moduleId, topicId, _kBestCorrect));
    final t = sp.getInt(_topicKey(moduleId, topicId, _kBestTotal));
    return (c, t);
  }

  Future<DateTime?> getBestDate(String moduleId, String topicId) async {
    final sp = await SharedPreferences.getInstance();
    final iso = sp.getString(_topicKey(moduleId, topicId, _kBestDateIso));
    return iso == null ? null : DateTime.tryParse(iso);
  }

  // --- DEV / DEBUG HELPERS ---

  Future<void> clearTopic(String moduleId, String topicId) async {
    final sp = await SharedPreferences.getInstance();
    final keys = <String>[
      _kBestPct,
      _kBestStars,
      _kBestCorrect,
      _kBestTotal,
      _kBestDateIso,
    ];
    for (final k in keys) {
      await sp.remove(_topicKey(moduleId, topicId, k));
    }
  }

  Future<void> clearModule(String moduleId, List<String> topicIds) async {
    for (final tid in topicIds) {
      await clearTopic(moduleId, tid);
    }
  }

  Future<void> resetStreak() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kLastLogin);
    await sp.remove(_kStreak);
  }

  Future<void> devSetLastLoginTo(DateTime date) async {
    final sp = await SharedPreferences.getInstance();
    final d = DateTime(date.year, date.month, date.day);
    await sp.setString(_kLastLogin, d.toIso8601String());
  }

  /// sin tocar perfil ni idioma ni otros datos de la app.
  Future<void> clearAllProgressData() async {
    final sp = await SharedPreferences.getInstance();
    final keys = sp.getKeys();

    // Campos que guarda _topicKey(...)
    const fields = [
      _kBestPct,
      _kBestStars,
      _kBestCorrect,
      _kBestTotal,
      _kBestDateIso,
    ];

    // Regex que machaca EXACTAMENTE el patrón que usas:
    // mod:<moduleId>|topic:<topicId>|<field>
    final fieldAlt = fields.map(RegExp.escape).join('|');
    final re = RegExp(r'^mod:.*\|topic:.*\|(' + fieldAlt + r')$');

    // 1) Borra todas las claves de progreso por-topic
    for (final k in keys) {
      if (re.hasMatch(k)) {
        await sp.remove(k);
      }
    }

    // 2) Borra también racha y último login
    await sp.remove(_kLastLogin);
    await sp.remove(_kStreak);
  }

  // === NUEVO: obtener racha actual sin modificarla ===
  Future<int> getStreakDays() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kStreak) ?? 0;
  }

  // === NUEVO: obtener estrellas por topic de un módulo ===
  // topics: lista de topicIds del módulo
  Future<List<int>> bestStarsForTopics(
    String moduleId,
    List<String> topics,
  ) async {
    final list = <int>[];
    for (final tid in topics) {
      list.add(await getBestStars(moduleId, tid));
    }
    return list;
  }

  // === NUEVO: saber si un topic fue intentado (cualquier progreso) ===
  Future<bool> wasTopicAttempted(String moduleId, String topicId) async {
    final sp = await SharedPreferences.getInstance();
    final pct = sp.getDouble(_topicKey(moduleId, topicId, _kBestPct));
    final correct = sp.getInt(_topicKey(moduleId, topicId, _kBestCorrect));
    final total = sp.getInt(_topicKey(moduleId, topicId, _kBestTotal));
    return (pct != null) || (correct != null && total != null);
  }
}
