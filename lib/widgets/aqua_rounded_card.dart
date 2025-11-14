import 'package:flutter/material.dart';
import 'package:aquatechinn_quiz/design/app_colors.dart';

/// Reutilizable para todas las pantallas con estilo AquaTechInn.
///
/// Crea una tarjeta con:
/// - Fondo de color personalizable
/// - Borde redondeado y color de borde
/// - Sombra suave
/// - Padding configurable
///
/// Ejemplo:
/// ```dart
/// AquaRoundedCard(
///   bgColor: AppColors.green.withValues(alpha: 0.85),
///   borderColor: AppColors.green,
///   radius: 18,
///   padding: const EdgeInsets.all(16),
///   child: Text("Contenido"),
/// )
/// ```
class AquaRoundedCard extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final Color borderColor;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double borderWidth;
  final bool hasShadow;

  const AquaRoundedCard({
    super.key,
    required this.child,
    required this.bgColor,
    required this.borderColor,
    this.radius = 18,
    this.padding = const EdgeInsets.all(16),
    this.borderWidth = 2,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.lightBlue.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      padding: padding,
      child: child,
    );
  }
}
