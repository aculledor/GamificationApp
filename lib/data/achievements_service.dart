// lib/data/achievements_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AchievementsService {
  static const _kBadgesCount = 'badgesCount';
  static const _kAchievementsCount = 'achievementsCount';

  Future<int> getBadgesCount() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kBadgesCount) ?? 0;
    }
  Future<int> getAchievementsCount() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kAchievementsCount) ?? 0;
  }

  Future<void> setBadgesCount(int v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kBadgesCount, v);
  }
  Future<void> setAchievementsCount(int v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kAchievementsCount, v);
  }

  Future<void> clearAll() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kBadgesCount);
    await sp.remove(_kAchievementsCount);
  }
}
