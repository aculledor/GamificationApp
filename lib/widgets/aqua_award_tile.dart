import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz/design/app_assets.dart';
import 'package:quiz/design/app_colors.dart';
import 'package:quiz/l10n/app_localizations.dart';

class AquaAwardTile extends StatelessWidget {
  final String title;
  final bool unlocked;
  final DateTime? date;

  const AquaAwardTile({
    super.key,
    required this.title,
    required this.unlocked,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final df = DateFormat('dd/MM/yyyy');
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icono circular (gris si locked)
        ColorFiltered(
          colorFilter: unlocked
              ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
              : const ColorFilter.matrix(<double>[
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.lightBlue.withValues(alpha: 0.65),
                  AppColors.green.withValues(alpha: 0.65),
                ],
              ),
              border: Border.all(color: AppColors.darkBlue, width: 2),
            ),
            padding: const EdgeInsets.all(10), // antes 12
            child: const AppIcon(AppIcons.trophy, size: 38), // antes 42
          ),
        ),

        SizedBox(height: 4 / textScale), // antes 6
        // Título (1 línea)
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 3 / textScale), // antes 4
        // Chip fecha (solo si unlocked) con FittedBox para evitar overflow
        if (unlocked && date != null)
          Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  '${t.badgeDateLabel}: ${df.format(date!)}',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
