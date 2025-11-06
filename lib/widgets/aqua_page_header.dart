import 'package:flutter/material.dart';
import 'package:quiz/design/app_assets.dart';
import 'package:quiz/design/app_colors.dart';

/// Tipo de leading a mostrar.
enum AquaLeading { back, close, none, custom }

/// Header reutilizable con icono de vuelta/close, título centrado y barra inferior.
class AquaPageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPressed; // acción del leading
  final AquaLeading leading;
  final String? customIconPath;  // si leading == custom
  final List<Widget>? actions;

  final Color backgroundColor;
  final Color titleColor;
  final Color dividerColor;
  final double dividerHeight;
  final bool centerTitle;

  const AquaPageHeader({
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
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w700,
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
        // Usamos el PNG de flecha derecha y lo espejamos para que apunte a la izquierda
        icon = Transform.scale(
          scaleX: -1, // espejo horizontal -> izquierda
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
