import 'package:flutter/material.dart';
import 'package:quiz/design/app_assets.dart';
import 'package:quiz/design/app_colors.dart';

enum AquaLeading { back, close, none, custom }

class AquaPageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPressed;
  final AquaLeading leading;
  final String? customIconPath;
  final List<Widget>? actions;

  final Color backgroundColor;
  final Color titleColor;
  final Color dividerColor;
  final double dividerHeight;
  final bool centerTitle;

  /// Altura calculada a partir del título
  @override
  final Size preferredSize;

  AquaPageHeader({
    super.key,
    required this.title,
    this.onPressed,
    this.leading = AquaLeading.back,
    this.customIconPath,
    this.actions,
    this.backgroundColor = Colors.white,
    this.titleColor = AppColors.darkBlue,
    this.dividerColor = AppColors.darkBlue,
    this.dividerHeight = 2,
    this.centerTitle = true,
  }) : preferredSize = Size.fromHeight(_computeHeight(title));

  /// Estima cuántas líneas necesita el título según su longitud
  static double _computeHeight(String title) {
    const base = kToolbarHeight;           // altura normal (~56)
    const extraPerLine = 20.0;             // píxeles extra por línea adicional
    const charsPerLine = 25;               // aprox. caracteres por línea

    int estimatedLines =
        (title.length / charsPerLine).ceil().clamp(1, 5); // entre 1 y 5 líneas

    return base + (estimatedLines - 1) * extraPerLine;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      titleSpacing: 0,
      toolbarHeight: preferredSize.height, // 🔹 usa la altura calculada
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          title,
          textAlign: centerTitle ? TextAlign.center : TextAlign.start,
          maxLines: 5,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      leading: _buildLeading(),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(dividerHeight),
        child: Container(height: dividerHeight, color: dividerColor),
      ),
    );
  }

  Widget? _buildLeading() {
    if (leading == AquaLeading.none) return null;

    Widget icon;
    switch (leading) {
      case AquaLeading.back:
        icon = Transform.scale(
          scaleX: -1,
          child: const AppIcon(
            AppIcons.rightArrow,
            size: 28,
            allowTint: true,
            color: AppColors.darkBlue,
          ),
        );
        break;
      case AquaLeading.close:
        icon = const AppIcon(
          AppIcons.close,
          size: 28,
          allowTint: true,
          color: AppColors.darkBlue,
        );
        break;
      case AquaLeading.custom:
        icon = AppIcon(
          customIconPath ?? AppIcons.rightArrow,
          size: 28,
          allowTint: true,
          color: AppColors.darkBlue,
        );
        break;
      case AquaLeading.none:
        return null;
    }

    return IconButton(
      onPressed: onPressed,
      icon: icon,
      tooltip: 'Back',
    );
  }
}
