// lib/data/achievements_service.dart
import 'package:flutter/material.dart';
import 'package:quiz/design/app_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:quiz/l10n/app_localizations.dart';
import 'package:quiz/data/progress_service.dart';
import 'package:quiz/data/models.dart';
import 'package:quiz/data/content_repository.dart';

class AchievementsService {
  // === Almacenamiento de estados desbloqueados ===
  static const _kAchievementsUnlocked = 'achievements_unlocked_ids';
  static const _kBadgesUnlocked = 'badges_unlocked_ids';

  // === Contadores visibles (como pediste) ===
  static const _kBadgesCount = 'badgesCount';
  static const _kAchievementsCount = 'achievementsCount';

  // === Flag para saber si exportó al menos una vez ===
  static const _kExportedOnce = 'exported_once';

  // 🔥 NUEVO: fechas por id (ISO 8601)
  static const _kAchDates = 'achievements_dates_map_json';
  static const _kBadDates = 'badges_dates_map_json';

  final ProgressService _progress = ProgressService();

  // ---------- Contadores públicos ----------
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
    await sp.remove(_kAchievementsUnlocked);
    await sp.remove(_kBadgesUnlocked);
    await sp.remove(_kExportedOnce);
  }

  Future<Map<String, String>> _readDateMap(String key) async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(key);
    if (raw == null || raw.isEmpty) return {};
    try {
      return Map<String, dynamic>.from(
        jsonDecode(raw),
      ).map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeDateMap(String key, Map<String, String> m) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(key, jsonEncode(m));
  }

  // ---------- Señalizar que exportó una vez ----------
  Future<void> markExportedOnce() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kExportedOnce, true);

    // si todavía no estaba en la lista de achievements, añádelo y fecha
    final unlockedAch = (sp.getStringList(_kAchievementsUnlocked) ?? <String>[])
        .toSet();
    final achDates = await _readDateMap(_kAchDates);
    if (unlockedAch.add('ach_exported_once')) {
      await sp.setStringList(_kAchievementsUnlocked, unlockedAch.toList());
      achDates['ach_exported_once'] = DateTime.now().toIso8601String();
      await _writeDateMap(_kAchDates, achDates);
    }
  }

  // ==========================================================
  //  checkForUpdates: recalcula logros/insignias y muestra popup
  //  Debes pasarle el módulo y sus topics, y strings para títulos locales.
  // ==========================================================
  Future<void> checkForUpdates({
    required BuildContext context,
    required Module module,
    required List<Topic> topics,
    required ContentStrings strings,
    bool showDialogIfNew = true,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final t = AppLocalizations.of(context)!;

    // Colecciones de ids ya desbloqueados
    final unlockedAch = (sp.getStringList(_kAchievementsUnlocked) ?? <String>[])
        .toSet();
    final unlockedBad = (sp.getStringList(_kBadgesUnlocked) ?? <String>[])
        .toSet();

    final newAchTitles = <String>[];
    final newBadTitles = <String>[];
    final nowIso = DateTime.now().toIso8601String();
    final achDates = await _readDateMap(_kAchDates);
    final badDates = await _readDateMap(_kBadDates);

    // ======== 1) ACHIEVEMENTS ========
    final streak = await _progress.getStreakDays();
    if (streak >= 2 && unlockedAch.add('ach_streak_2')) {
      newAchTitles.add(t.achStreak2days);
      achDates['ach_streak_2'] = nowIso;
    }
    if (streak >= 5 && unlockedAch.add('ach_streak_5')) {
      newAchTitles.add(t.achStreak5days);
      achDates['ach_streak_5'] = nowIso;
    }
    if (streak >= 7 && unlockedAch.add('ach_streak_7')) {
      newAchTitles.add(t.achStreak7days);
      achDates['ach_streak_7'] = nowIso;
    }

    // Perfil actualizado (regla simple: si nombre y email no vacíos)
    // Si tienes un UserProfileService, puedes inyectarlo aquí y hacer la validación real.
    // Por simplicidad, considera mostrar este achievement al guardar perfil correctamente.
    // unlockedAch.add('ach_profile_updated') lo harías desde Options al guardar.
    // Aquí solo lo añadimos si aún no estaba (no repetimos popup).
    if (!(unlockedAch.contains('ach_profile_updated'))) {
      // NO lo marcamos aquí automáticamente; lo marcarás explícitamente al guardar.
    }

    // Exportó una vez
    final exportedOnce = sp.getBool(_kExportedOnce) ?? false;
    if (exportedOnce && unlockedAch.add('ach_exported_once')) {
      newAchTitles.add(t.achExportedOnce);
    }

    // ======== 2) BADGES ========
    // a) Una por cada topic con 3 estrellas
    for (final topic in topics) {
      final stars = await _progress.getBestStars(module.id, topic.id);
      if (stars == 3) {
        final id = 'badge_topic_${topic.id}_3';
        if (unlockedBad.add(id)) {
          // Título localizado del topic
          final topicTitle = strings.t(topic.titleKey);
          newBadTitles.add(t.badgeTopicThreeStars(topic: topicTitle));
          badDates[id] = nowIso;
        }
      }
    }

    // b) Todos los topics intentados (sin importar nota)
    final allAttempted = await Future.wait(
      topics.map((tp) => _progress.wasTopicAttempted(module.id, tp.id)),
    ).then((v) => v.every((x) => x));
    if (allAttempted && unlockedBad.add('badge_all_topics_any')) {
      newBadTitles.add(t.badgeAllTopicsAnyScore);
      badDates['badge_all_topics_any'] = nowIso;
    }

    // c) Al menos 2★ en todos
    final starsList = await _progress.bestStarsForTopics(
      module.id,
      topics.map((e) => e.id).toList(),
    );
    if (starsList.isNotEmpty && starsList.every((s) => s >= 2)) {
      if (unlockedBad.add('badge_all_topics_2')) {
        newBadTitles.add(t.badgeAllTopicsAtLeast2Stars);
        badDates['badge_all_topics_2'] = nowIso;
      }
    }

    // d) 3★ en todos
    if (starsList.isNotEmpty && starsList.every((s) => s == 3)) {
      if (unlockedBad.add('badge_all_topics_3')) {
        newBadTitles.add(t.badgeAllTopics3Stars);
        badDates['badge_all_topics_3'] = nowIso;
      }
    }

    // ======== GUARDAR cambios ========
    await sp.setStringList(_kAchievementsUnlocked, unlockedAch.toList());
    await sp.setStringList(_kBadgesUnlocked, unlockedBad.toList());
    await _writeDateMap(_kAchDates, achDates);
    await _writeDateMap(_kBadDates, badDates);

    // Actualizamos contadores globales visibles
    await setAchievementsCount(unlockedAch.length);
    await setBadgesCount(unlockedBad.length);

    // ======== POPUP si hay novedades ========
    if (showDialogIfNew &&
        (newAchTitles.isNotEmpty || newBadTitles.isNotEmpty)) {
      _showNewAwardsDialog(context, t, newAchTitles, newBadTitles);
    }
  }

  // Usar este helper desde Options al guardar perfil correctamente:
  Future<void> markProfileUpdatedAndCheck({
    required BuildContext context,
    required Module module,
    required List<Topic> topics,
    required ContentStrings strings,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final unlockedAch = (sp.getStringList(_kAchievementsUnlocked) ?? <String>[])
        .toSet();
    final achDates = await _readDateMap(_kAchDates);

    if (unlockedAch.add('ach_profile_updated')) {
      await sp.setStringList(_kAchievementsUnlocked, unlockedAch.toList());
      achDates['ach_profile_updated'] = DateTime.now().toIso8601String();
      await _writeDateMap(_kAchDates, achDates);
    }

    await checkForUpdates(
      context: context,
      module: module,
      topics: topics,
      strings: strings,
      showDialogIfNew: true,
    );
  }

  Future<List<AwardItem>> getRecentAchievements({
    required BuildContext context,
    required Module module,
    required List<Topic> topics,
    required ContentStrings strings,
    int limit = 3,
  }) async {
    final t = AppLocalizations.of(context)!;
    final sp = await SharedPreferences.getInstance();
    final ids = (sp.getStringList(_kAchievementsUnlocked) ?? <String>[]);
    final dates = await _readDateMap(_kAchDates);

    // ordenar por fecha desc
    ids.sort((a, b) {
      final da =
          DateTime.tryParse(dates[a] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final db =
          DateTime.tryParse(dates[b] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });

    String titleFor(String id) {
      switch (id) {
        case 'ach_streak_2':
          return t.achStreak2days;
        case 'ach_streak_5':
          return t.achStreak5days;
        case 'ach_streak_7':
          return t.achStreak7days;
        case 'ach_profile_updated':
          return t.achProfileUpdated;
        case 'ach_exported_once':
          return t.achExportedOnce;
        default:
          return id;
      }
    }

    String descriptionFor(String id) {
      switch (id) {
        case 'ach_streak_2':
          return t.achStreak2daysDesc;
        case 'ach_streak_5':
          return t.achStreak5daysDesc;
        case 'ach_streak_7':
          return t.achStreak7daysDesc;
        case 'ach_profile_updated':
          return t.achProfileUpdatedDesc;
        case 'ach_exported_once':
          return t.achExportedOnceDesc;
        default:
          return '';
      }
    }

    return ids.take(limit).map((id) {
      final d = DateTime.tryParse(dates[id] ?? '') ?? DateTime.now();
      return AwardItem(id: id, title: titleFor(id), description: descriptionFor(id), iconPath: "", date: d, unlocked: true);
    }).toList();
  }

  // 3 últimos badges
  Future<List<AwardItem>> getRecentBadges({
    required BuildContext context,
    required Module module,
    required List<Topic> topics,
    required ContentStrings strings,
    int limit = 3,
  }) async {
    final t = AppLocalizations.of(context)!;
    final sp = await SharedPreferences.getInstance();
    final ids = (sp.getStringList(_kBadgesUnlocked) ?? <String>[]);
    final dates = await _readDateMap(_kBadDates);

    // ordenar por fecha desc
    ids.sort((a, b) {
      final da =
          DateTime.tryParse(dates[a] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final db =
          DateTime.tryParse(dates[b] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });

    String titleFor(String id) {
      if (id.startsWith('badge_topic_') && id.endsWith('_3')) {
        final topicId = id
            .replaceFirst('badge_topic_', '')
            .replaceFirst('_3', '');
        final topic = topics.firstWhere(
          (tp) => tp.id == topicId,
          orElse: () => topics.first,
        );
        final topicTitle = strings.t(topic.titleKey);
        return t.badgeTopicThreeStars(topic: topicTitle);
      }
      switch (id) {
        case 'badge_all_topics_any':
          return t.badgeAllTopicsAnyScore;
        case 'badge_all_topics_2':
          return t.badgeAllTopicsAtLeast2Stars;
        case 'badge_all_topics_3':
          return t.badgeAllTopics3Stars;
        default:
          return id;
      }
    }

    String descriptionFor(String id) {
      if (id.startsWith('badge_topic_') && id.endsWith('_3')) {
        final topicId = id
            .replaceFirst('badge_topic_', '')
            .replaceFirst('_3', '');
        final topic = topics.firstWhere(
          (tp) => tp.id == topicId,
          orElse: () => topics.first,
        );
        final topicTitle = strings.t(topic.titleKey);
        return t.badgeTopicThreeStarsDesc(topic: topicTitle);
      }
      switch (id) {
        case 'badge_all_topics_any':
          return t.badgeAllTopicsAnyScoreDesc;
        case 'badge_all_topics_2':
          return t.badgeAllTopicsAtLeast2StarsDesc;
        case 'badge_all_topics_3':
          return t.badgeAllTopics3StarsDesc;
        default:
          return '';
      }
    }

    return ids.take(limit).map((id) {
      final d = DateTime.tryParse(dates[id] ?? '') ?? DateTime.now();
      return AwardItem(id: id, title: titleFor(id), description: descriptionFor(id), iconPath: "", date: d, unlocked: true);
    }).toList();
  }

  Future<Set<String>> getUnlockedBadgeIds() async {
    final sp = await SharedPreferences.getInstance();
    return (sp.getStringList(_kBadgesUnlocked) ?? <String>[]).toSet();
  }

  Future<Set<String>> getUnlockedAchievementIds() async {
    final sp = await SharedPreferences.getInstance();
    return (sp.getStringList(_kAchievementsUnlocked) ?? <String>[]).toSet();
  }

  Future<Map<String, String>> getBadgeDates() => _readDateMap(_kBadDates);
  Future<Map<String, String>> getAchievementDates() => _readDateMap(_kAchDates);

  // === Catálogo completo de BADGES (ids + títulos localizados)
  Future<List<AwardCatalogEntry>> getBadgesCatalog({
    required BuildContext context,
    required Module module,
    required List<Topic> topics,
    required ContentStrings strings,
  }) async {
    final t = AppLocalizations.of(context)!;

    final list = <AwardCatalogEntry>[];

    // a) 3★ por topic
    for (final tp in topics) {
      final id = 'badge_topic_${tp.id}_3';
      final title = t.badgeTopicThreeStars(topic: strings.t(tp.titleKey));
      final description = t.badgeTopicThreeStarsDesc(topic: strings.t(tp.titleKey));
      list.add(AwardCatalogEntry(id, title, description, AppIcons.trophy));
    }

    // b) globales
    list.add(
      AwardCatalogEntry('badge_all_topics_any', t.badgeAllTopicsAnyScore, t.badgeAllTopicsAnyScoreDesc, AppIcons.trophy),
    );
    list.add(
      AwardCatalogEntry('badge_all_topics_2', t.badgeAllTopicsAtLeast2Stars, t.badgeAllTopicsAtLeast2StarsDesc, AppIcons.trophy),
    );
    list.add(AwardCatalogEntry('badge_all_topics_3', t.badgeAllTopics3Stars, t.badgeAllTopics3StarsDesc, AppIcons.trophy));

    return list;
  }

  // === Catálogo completo de ACHIEVEMENTS
  Future<List<AwardCatalogEntry>> getAchievementsCatalog({
    required BuildContext context,
  }) async {
    final t = AppLocalizations.of(context)!;
    return <AwardCatalogEntry>[
      AwardCatalogEntry('ach_streak_2', t.achStreak2days, t.achStreak2daysDesc, AppIcons.trophy),
      AwardCatalogEntry('ach_streak_5', t.achStreak5days, t.achStreak5daysDesc, AppIcons.trophy),
      AwardCatalogEntry('ach_streak_7', t.achStreak7days, t.achStreak7daysDesc, AppIcons.trophy),
      AwardCatalogEntry('ach_profile_updated', t.achProfileUpdated, t.achProfileUpdatedDesc, AppIcons.trophy),
      AwardCatalogEntry('ach_exported_once', t.achExportedOnce, t.achExportedOnceDesc, AppIcons.trophy),
    ];
  }

  // Desbloquea 1 achievement y 1 badge para pruebas, guardando fecha y mostrando popup.
  Future<void> debugUnlockOneEach({
    required BuildContext context,
    required Module module,
    required List<Topic> topics,
    required ContentStrings strings,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final t = AppLocalizations.of(context)!;

    final ach = (sp.getStringList(_kAchievementsUnlocked) ?? <String>[])
        .toSet();
    final bad = (sp.getStringList(_kBadgesUnlocked) ?? <String>[]).toSet();

    final achDates = await _readDateMap(_kAchDates);
    final badDates = await _readDateMap(_kBadDates);
    final nowIso = DateTime.now().toIso8601String();

    // Achievement de ejemplo: racha de 2 días
    ach.add('ach_streak_2');
    achDates['ach_streak_2'] = nowIso;

    // Badge de ejemplo: 3★ en el primer topic (o "all topics attempted" si no hay topics)
    String badgeId;
    String badgeTitle;
    if (topics.isNotEmpty) {
      final first = topics.first;
      badgeId = 'badge_topic_${first.id}_3';
      bad.add(badgeId);
      badDates[badgeId] = nowIso;
      badgeTitle = t.badgeTopicThreeStars(topic: strings.t(first.titleKey));
    } else {
      badgeId = 'badge_all_topics_any';
      bad.add(badgeId);
      badDates[badgeId] = nowIso;
      badgeTitle = t.badgeAllTopicsAnyScore;
    }

    // Persistir listas y fechas
    await sp.setStringList(_kAchievementsUnlocked, ach.toList());
    await sp.setStringList(_kBadgesUnlocked, bad.toList());
    await _writeDateMap(_kAchDates, achDates);
    await _writeDateMap(_kBadDates, badDates);

    // Actualizar contadores visibles
    await setAchievementsCount(ach.length);
    await setBadgesCount(bad.length);

    // Popup agrupado
    _showNewAwardsDialog(context, t, [t.achStreak2days], [badgeTitle]);
  }

  void _showNewAwardsDialog(
    BuildContext context,
    AppLocalizations t,
    List<String> achievements,
    List<String> badges,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(t.newAwardsTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (achievements.isNotEmpty) ...[
                Text(
                  t.newAchievementsTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                ...achievements.map((e) => Text('• $e')),
                const SizedBox(height: 12),
              ],
              if (badges.isNotEmpty) ...[
                Text(
                  t.newBadgesTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                ...badges.map((e) => Text('• $e')),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t.okGotIt),
            ),
          ],
        );
      },
    );
  }
}

class AwardItem {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final bool unlocked;
  final String iconPath;
  AwardItem({required this.id, required this.title, required this.date, required this.description, required this.unlocked, this.iconPath = AppIcons.trophy});
}

class AwardCatalogEntry {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  AwardCatalogEntry(this.id, this.title, this.description, this.iconPath);
}
