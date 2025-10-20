import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class AppColors {
  static const green = Color(0xFF99EF3D);
  static const darkBlue = Color(0xFF402EB5);
  static const lightBlue = Color(0xFF77B4EB);
}

class AppIcons {
  static const base = 'assets/icons';
  static String p(String name) => '$base/$name.png';

  static final flame = p('flame');
  static final thunder = p('thunder');
  static final medal = p('medal');

  static final checklist = p('checklist');
  static final trophy = p('trophy');
  static final cogwheel = p('cogwheel');

  static final rightArrow = p('right_arrow');
  static final verticalLine = p('vertical_line');
  static final list = p('list');

  static final filledStar = p('filled_star');
  static final emptyStar = p('empty_star');

  static final lock = p('lock');
}

class Questionnaire extends StatelessWidget {
  const Questionnaire({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // Demo data
    final flames = 2;
    final energy = 3;
    final medals = 5;

    final moduleName = "Sustainability Management in Aquaculture";
    final topic1Name = "Environmental, social and economic issues linked to shellfish and finfish farming";
    final topic1Stars = 1; // of 3
    final haveStars = 1;
    final needToUnlock = 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _TopCounter(iconPath: AppIcons.flame, value: flames, size: 26),
            _TopCounter(iconPath: AppIcons.thunder, value: energy, size: 26),
            _TopCounter(iconPath: AppIcons.medal, value: medals, size: 26),
          ],
        ),
      ),

      // Bottom navigation with your PNGs
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.green.withValues(alpha: 0.45),
        indicatorColor: AppColors.lightBlue,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: _NavIcon(AppIcons.checklist, size: 32),
            label: t.tabQuestionnaire,
          ),
          NavigationDestination(
            icon: _NavIcon(AppIcons.trophy, size: 32),
            label: t.tabPerformance,
          ),
          NavigationDestination(
            icon: _NavIcon(AppIcons.cogwheel, size: 32),
            label: t.tabOptions,
          ),
        ],
        // text color + style
        labelTextStyle: WidgetStatePropertyAll(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
          ),
        ),
      ),


      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // ===== Module Card (green with dark blue border + right pill) =====
          _RoundedBorderCard(
            bgColor: AppColors.green,
            borderColor: AppColors.darkBlue,
            radius: 28,
            padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t.moduleTitle(number: '2', name: moduleName),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.darkBlue),
                  ),
                ),
              ],
            ),
            onTap: () {}, // navigate to topics list
          ),

          const SizedBox(height: 14),

          // ===== Topic 1 (unlocked) =====
          _RoundedBorderCard(
            bgColor: AppColors.green.withValues(alpha: 0.75),
            borderColor: AppColors.green.withValues(alpha: 0.0),
            radius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.topicTitle(name: topic1Name),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: List.generate(3, (i) {
                    final filled = i < topic1Stars;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: _AssetIcon(
                        filled ? AppIcons.filledStar : AppIcons.emptyStar,
                        size: 26,
                      ),
                    );
                  }),
                ),
              ],
            ),
            onTap: () {}, // open quiz
          ),

          const SizedBox(height: 14),

          // ===== Locked banner =====
          _RoundedBorderCard(
            bgColor: Colors.blueGrey.shade500,
            borderColor: Colors.blueGrey.shade700,
            radius: 20,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _AssetIcon(AppIcons.lock, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.earnMoreStars,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  t.starsProgress(have: '$haveStars', need: '$needToUnlock'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                _AssetIcon(AppIcons.emptyStar, size: 26),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

// ===== Small helpers =====

class _TopCounter extends StatelessWidget {
  final String iconPath;
  final int value;
  final double size; // add this line

  const _TopCounter({
    required this.iconPath,
    required this.value,
    this.size = 24, // default
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconPath, width: size, height: size),
        const SizedBox(width: 6),
        Text(
          '$value',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String path;
  final double size;
  const _NavIcon(this.path, {this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, width: size, height: size);
  }
}


class _AssetIcon extends StatelessWidget {
  final String path;
  final double size;
  const _AssetIcon(this.path, {this.size = 24});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}

class _RoundedBorderCard extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final Color borderColor;
  final double radius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const _RoundedBorderCard({
    required this.child,
    required this.bgColor,
    required this.borderColor,
    this.radius = 24,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderColor.opacity > 0 ? 3 : 0),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlue.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );

    return onTap == null
        ? card
        : InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: card,
          );
  }
}
