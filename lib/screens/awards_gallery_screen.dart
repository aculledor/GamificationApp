// lib/screens/awards_gallery_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aquatechinn_quiz/design/app_assets.dart';
import 'package:aquatechinn_quiz/design/app_colors.dart';
import 'package:aquatechinn_quiz/l10n/app_localizations.dart';
import 'package:aquatechinn_quiz/widgets/aqua_bottom_nav.dart';
import 'package:aquatechinn_quiz/widgets/aqua_rounded_card.dart';
import 'package:aquatechinn_quiz/widgets/aqua_award_tile.dart';
import 'package:aquatechinn_quiz/screens/award_detail_screen.dart';
import 'package:aquatechinn_quiz/data/achievements_service.dart';
import 'package:aquatechinn_quiz/data/content_repository.dart';
import 'package:aquatechinn_quiz/data/models.dart';

enum AwardsType { badges, achievements }

// Item para la UI
class _AwardItem {
  final String id;
  final String title;
  final String description;
  final bool unlocked;
  final String iconPath;
  final DateTime? date;
  const _AwardItem(this.id, this.title, this.description, this.unlocked, this.iconPath, this.date);
}

class AwardsGalleryScreen extends StatefulWidget {
  final AwardsType type; // badges o achievements
  const AwardsGalleryScreen({super.key, required this.type});

  @override
  State<AwardsGalleryScreen> createState() => _AwardsGalleryScreenState();
}

class _AwardsGalleryScreenState extends State<AwardsGalleryScreen> {
  final _ach = AchievementsService();
  final _contentRepo = ContentRepository();

  bool _loading = true;
  bool _didLoadOnce = false;
  List<_AwardItem> _items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carga aquí (no en initState) para poder usar Localizations y Locale
    if (!_didLoadOnce) {
      _didLoadOnce = true;
      // microtask para dar tiempo a montar el árbol
      scheduleMicrotask(_load);
    }
  }

  Future<void> _load() async {
    try {
      // Catálogos y estados
      final bundle = await _contentRepo.load();
      final Module module = bundle.modules.firstWhere(
        (m) => m.id == 'm2',
        orElse: () => bundle.modules.first,
      );
      final topics = module.topicIds
          .map((tid) => bundle.topics.firstWhere((tp) => tp.id == tid))
          .toList();
      final strings = await ContentStrings.loadForLocale(
        Localizations.localeOf(context),
      );

      final catalog = widget.type == AwardsType.badges
          ? await _ach.getBadgesCatalog(
              context: context,
              module: module,
              topics: topics,
              strings: strings,
            )
          : await _ach.getAchievementsCatalog(context: context);

      final unlockedIds = widget.type == AwardsType.badges
          ? await _ach.getUnlockedBadgeIds()
          : await _ach.getUnlockedAchievementIds();

      final dateMap = widget.type == AwardsType.badges
          ? await _ach.getBadgeDates()
          : await _ach.getAchievementDates();

      final items = <_AwardItem>[];
      for (final entry in catalog) {
        final isUnlocked = unlockedIds.contains(entry.id);
        final dtIso = dateMap[entry.id];
        final dt = (isUnlocked && dtIso != null)
            ? DateTime.tryParse(dtIso)
            : null; // bloqueado => sin fecha
        items.add(_AwardItem(entry.id, entry.title, entry.description, isUnlocked, entry.iconPath, dt));
      }

      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading awards: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final title = widget.type == AwardsType.badges
        ? t.badgesTitle
        : t.achievementsTitle;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: AppColors.darkBlue),
        ),
      ),
      bottomNavigationBar: const AquaBottomNav(current: AquaTab.performance),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: AquaRoundedCard(
                bgColor: Colors.white,
                borderColor: AppColors.darkBlue,
                radius: 16,
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: _items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.80,
                  ),
                  itemBuilder: (context, i) {
                    final it = _items[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AwardDetailScreen(
                              title: it.title,
                              description: it.description,
                              earned: it.unlocked,
                              earnedDate: it.date,
                              iconPath: AppIcons.trophy,
                            ),
                          ),
                        );
                      },
                      child: AquaAwardTile(
                        title: it.title,
                        unlocked: it.unlocked,
                        date: it.date,
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
