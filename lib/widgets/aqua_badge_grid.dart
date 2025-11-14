import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aquatechinn_quiz/design/app_assets.dart';
import 'package:aquatechinn_quiz/design/app_colors.dart';
import 'package:aquatechinn_quiz/l10n/app_localizations.dart';

/// Rejilla de trofeos o logros con títulos y fechas.
/// Muestra hasta 6 elementos (3 por fila) adaptados al ancho.
///
/// Parametrización extra:
/// - [onTap]: callback al pulsar un elemento.
/// - [unlocked]: lista que indica si el ítem está desbloqueado (gris y sin fecha cuando es false).
/// - [iconPaths]: icono por ítem (por defecto trofeo).
class AquaBadgeGrid extends StatelessWidget {
  final int count;
  final List<String>? titles;
  final List<DateTime>? dates;

  /// NUEVO: ¿está desbloqueado cada ítem? (si no, se pinta gris y no se muestra la fecha)
  final List<bool>? unlocked;

  /// NUEVO: icono por ítem
  final List<String>? iconPaths;

  /// NUEVO: callback al pulsar
  final void Function(int index)? onTap;

  const AquaBadgeGrid({
    super.key,
    required this.count,
    this.titles,
    this.dates,
    this.unlocked,
    this.iconPaths,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final items = List.generate(count.clamp(0, 6), (i) => i);
    final df = DateFormat('dd/MM/yyyy');

    // calcular ancho disponible
    final screenWidth = MediaQuery.of(context).size.width;
    // padding horizontal total (16 izquierda + 16 derecha + espaciados internos)
    final totalPadding = 16 * 2 + 12 * 2;
    final cellWidth = (screenWidth - totalPadding) / 3;
    final aspectRatio = cellWidth / (cellWidth * 1.2); // un poco más alto

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, i) {
        final String title = (titles != null && i < titles!.length)
            ? titles![i]
            : t.badgeGenericTitle(number: '${i + 1}');
        final DateTime? date =
            (dates != null && i < dates!.length) ? dates![i] : DateTime.now();
        final bool isUnlocked =
            (unlocked != null && i < unlocked!.length) ? unlocked![i] : true;
        final String iconPath = (iconPaths != null && i < iconPaths!.length)
            ? iconPaths![i]
            : AppIcons.trophy;

        final tile = SizedBox(
          width: cellWidth,
          child: Column(
            children: [
              // Icono circular con degradado o gris si bloqueado
              Container(
                width: cellWidth * 0.6,
                height: cellWidth * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isUnlocked
                      ? RadialGradient(
                          colors: [
                            AppColors.lightBlue.withValues(alpha: 0.65),
                            AppColors.green.withValues(alpha: 0.65),
                          ],
                        )
                      : const RadialGradient(
                          colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
                        ),
                  border: Border.all(color: AppColors.darkBlue, width: 2),
                ),
                padding: const EdgeInsets.all(10),
                child: ColorFiltered(
                  colorFilter: isUnlocked
                      ? const ColorFilter.mode(
                          Colors.transparent, BlendMode.srcOver)
                      : const ColorFilter.matrix(_kGrayMatrix),
                  child: AppIcon(iconPath, size: 38),
                ),
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

              // Fecha (solo si está desbloqueado)
              if (isUnlocked && date != null)
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Text(
                      '${t.badgeDateLabel}: ${df.format(date)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                ),
            ],
          ),
        );

        return GestureDetector(
          onTap: () => onTap?.call(i),
          child: tile,
        );
      },
    );
  }
}

/// matriz de escala de grises (sRGB)
const List<double> _kGrayMatrix = <double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0,      0,      0,      1, 0,
];
