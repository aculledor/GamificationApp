import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _kBestPct = 'bestPct';   // double 0..100
  static const _kBestStars = 'bestStars'; // int 0..3
  static const _kLastLogin = 'lastLoginDate'; // yyyy-mm-dd
  static const _kStreak = 'loginStreak';

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
    if (pct >= 99.999) return 3;     // treat 100% robustly
    if (pct >= 75.0) return 2;
    if (pct >= 50.0) return 1;
    return 0;
  }

  /// Save only if it's better than previous best.
  Future<void> saveAttempt(String moduleId, String topicId, double percent) async {
    final sp = await SharedPreferences.getInstance();
    final prevPct = await getBestPct(moduleId, topicId);
    if (percent <= prevPct) return;
    final stars = starsFromPercent(percent);
    await sp.setDouble(_topicKey(moduleId, topicId, _kBestPct), percent);
    await sp.setInt(_topicKey(moduleId, topicId, _kBestStars), stars);
  }

  /// Sum all best stars for a module.
  Future<int> totalStarsForModule(String moduleId, List<String> topicIds) async {
    int sum = 0;
    for (final tid in topicIds) { sum += await getBestStars(moduleId, tid); }
    return sum;
  }

  /// Unlock condition: topic index (1-based) needs (index-1)*2 total stars.
  int requiredStarsForIndex(int oneBasedIndex) => max(0, (oneBasedIndex - 1) * 2);

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
}
