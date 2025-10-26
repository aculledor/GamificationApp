import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gamificationapp/design/app_assets.dart';
import 'package:gamificationapp/design/app_colors.dart';
import 'package:gamificationapp/l10n/app_localizations.dart';

/// Rejilla de trofeos o logros con títulos y fechas.
/// Se usa para pantallas de resumen o perfil.
///
/// Ejemplo:
/// ```dart
/// AquaBadgeGrid(count: 4)
/// ```
class AquaBadgeGrid extends StatelessWidget {
  final int count;
  final List<String>? titles;
  final List<DateTime>? dates;

  /// Si se pasan [titles] o [dates], deben tener longitud igual o menor a [count].
  const AquaBadgeGrid({
    super.key,
    required this.count,
    this.titles,
    this.dates,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final items = List.generate(count.clamp(0, 6), (i) => i);
    final df = DateFormat('dd/MM/yyyy');

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, i) {
        final title = (titles != null && i < titles!.length)
            ? titles![i]
            : t.badgeGenericTitle(number: '${i + 1}');
        final date = (dates != null && i < dates!.length)
            ? dates![i]
            : DateTime.now();

        return Column(
          children: [
            // Icono circular con degradado
            Container(
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
              padding: const EdgeInsets.all(12),
              child: const AppIcon(AppIcons.trophy, size: 42),
            ),

            const SizedBox(height: 6),

            // Título del logro
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.darkBlue,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Fecha con etiqueta traducida
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                '${t.badgeDateLabel}: ${df.format(date)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
