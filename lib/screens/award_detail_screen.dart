import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aquatechinn_quiz/design/app_assets.dart';
import 'package:aquatechinn_quiz/design/app_colors.dart';
import 'package:aquatechinn_quiz/widgets/aqua_page_header.dart';
import 'package:aquatechinn_quiz/l10n/app_localizations.dart';

class AwardDetailScreen extends StatelessWidget {
  final String title;          // Texto ya localizado
  final String description;    // Texto ya localizado
  final DateTime? earnedDate;  // null si no se ha conseguido
  final String iconPath;       // por defecto el trofeo
  final bool earned;           // true => color, false => gris

  const AwardDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.earned,
    this.earnedDate,
    this.iconPath = AppIcons.trophy,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AquaPageHeader(
        title: title,
        leading: AquaLeading.close,                 // como en el mock
        onPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // --- Icono grande circular ---
            Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: earned
                      ? RadialGradient(colors: [
                          AppColors.lightBlue.withValues(alpha: 0.65),
                          AppColors.green.withValues(alpha: 0.65),
                        ])
                      : const RadialGradient(colors: [
                          Color(0xFFE0E0E0),
                          Color(0xFFBDBDBD),
                        ]),
                  border: Border.all(
                    color: AppColors.darkBlue,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightBlue.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: ColorFiltered(
                  colorFilter: earned
                      ? const ColorFilter.mode(
                          Colors.transparent, BlendMode.srcOver)
                      : const ColorFilter.matrix(_grayscaleMatrix),
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // --- Descripción ---
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            // --- Fecha (solo si está ganado) ---
            if (earned && earnedDate != null)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lightBlue.withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: Text(
                    '${t.badgeDateLabel}: ${df.format(earnedDate!)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Matriz para convertir a escala de grises
const List<double> _grayscaleMatrix = <double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0,      0,      0,      1, 0,
];
