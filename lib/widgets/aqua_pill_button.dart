import 'package:flutter/material.dart';
import 'package:quiz/design/app_colors.dart';

/// Botón tipo “píldora” reutilizable para toda la app.
/// - Fondo, texto y borde configurables.
/// - Radio, altura, padding, sombra, mayúsculas.
/// - Soporta leading/trailing widgets (iconos).
///
/// Ejemplo básico:
/// AquaPillButton(
///   label: 'TRY AGAIN',
///   onPressed: () {},
/// )
///
/// Variantes rápidas:
/// AquaPillButton.primary(label: 'EXPORT', onPressed: () {});
/// AquaPillButton.danger(label: 'RESET', onPressed: () {});
class AquaPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;

  final double radius;
  final double? height;
  final EdgeInsetsGeometry padding;
  final bool uppercase;
  final bool showShadow;

  final Widget? leading;
  final Widget? trailing;
  final TextStyle? textStyle;

  const AquaPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFB7F48E), // similar a tu green
    this.textColor = AppColors.darkBlue,
    this.borderColor = AppColors.darkBlue,
    this.borderWidth = 2,
    this.radius = 28,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    this.uppercase = true,
    this.showShadow = true,
    this.leading,
    this.trailing,
    this.textStyle,
  });

  /// Preset con colores “primarios” de la app (verde).
  factory AquaPillButton.primary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool uppercase = true,
  }) {
    return AquaPillButton(
      key: key,
      label: label,
      onPressed: onPressed,
      backgroundColor: AppColors.green.withValues(alpha: 0.85),
      textColor: AppColors.darkBlue,
      borderColor: AppColors.darkBlue,
      uppercase: uppercase,
    );
  }

  /// Preset de “peligro” (rojo) para acciones destructivas.
  factory AquaPillButton.danger({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool uppercase = true,
  }) {
    return AquaPillButton(
      key: key,
      label: label,
      onPressed: onPressed,
      backgroundColor: const Color(0xFFFF6B6B),
      textColor: Colors.white,
      borderColor: AppColors.darkBlue,
      uppercase: uppercase,
    );
  }

  /// Preset neutro (fondo blanco con borde).
  factory AquaPillButton.neutral({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool uppercase = true,
  }) {
    return AquaPillButton(
      key: key,
      label: label,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: AppColors.darkBlue,
      borderColor: AppColors.darkBlue,
      uppercase: uppercase,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null;

    final bg = disabled ? backgroundColor.withOpacity(0.5) : backgroundColor;
    final txtCol = disabled ? textColor.withOpacity(0.6) : textColor;
    final bdCol = disabled ? borderColor.withOpacity(0.4) : borderColor;

    final childText = Text(
      uppercase ? label.toUpperCase() : label,
      softWrap: true, // 🔹 permite saltos de línea
      maxLines: 3, // 🔹 o null si quieres ilimitado
      overflow: TextOverflow.visible, // 🔹 sin puntos suspensivos
      textAlign: TextAlign.center, // 🔹 mejor para respuestas largas
      style:
          (textStyle ??
                  const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.8,
                  ))
              .copyWith(color: txtCol),
    );

    final row = Row(
      mainAxisSize: MainAxisSize.max, // 🔹 ocupa todo el ancho del botón
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 8)],
        Expanded(
          child: childText,
        ), // 🔹 deja que el texto se ajuste y rompa línea
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );

    final content = Container(
      width: double.infinity, // 🔹 botón a ancho completo
      constraints: const BoxConstraints(
        minHeight: 48, // altura mínima razonable
      ),
      padding: padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: bdCol, width: borderWidth),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.lightBlue.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: row,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: disabled ? null : onPressed,
        child: content,
      ),
    );
  }
}
