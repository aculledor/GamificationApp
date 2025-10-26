import 'package:flutter/widgets.dart';

/// Centralized design assets (colors are defined elsewhere)
/// Provides const paths and a reusable [AppIcon] widget.
abstract class AppIcons {
  // === Base paths ===
  static const flame        = 'assets/icons/flame.png';
  static const thunder      = 'assets/icons/thunder.png';
  static const medal        = 'assets/icons/medal.png';

  static const checklist    = 'assets/icons/checklist.png';
  static const trophy       = 'assets/icons/trophy.png';
  static const cogwheel     = 'assets/icons/cogwheel.png';

  static const rightArrow   = 'assets/icons/right_arrow.png';
  static const verticalLine = 'assets/icons/vertical_line.png';
  static const list         = 'assets/icons/list.png';
  static const close       = 'assets/icons/close.png';

  static const filledStar   = 'assets/icons/filled_star.png';
  static const emptyStar    = 'assets/icons/empty_star.png';

  static const lock         = 'assets/icons/lock.png';
  static const add_image         = 'assets/icons/add_image.png';
  static const es_flag         = 'assets/icons/es_flag.png';
  static const en_flag         = 'assets/icons/en_flag.png';
  static const it_flag         = 'assets/icons/it_flag.png';
  static const el_flag         = 'assets/icons/el_flag.png';
  static const tr_flag         = 'assets/icons/tr_flag.png';
  static const fr_flag         = 'assets/icons/fr_flag.png';
  static const pt_flag         = 'assets/icons/pt_flag.png';

  // === Optional pre-built providers (handy for precaching or ImageIcon) ===
  static const flameProvider        = AssetImage(flame);
  static const thunderProvider      = AssetImage(thunder);
  static const medalProvider        = AssetImage(medal);
  static const checklistProvider    = AssetImage(checklist);
  static const trophyProvider       = AssetImage(trophy);
  static const cogwheelProvider     = AssetImage(cogwheel);
  static const filledStarProvider   = AssetImage(filledStar);
  static const emptyStarProvider    = AssetImage(emptyStar);
  static const lockProvider         = AssetImage(lock);
  static const closeProvider       = AssetImage(close);
  static const addImageProvider    = AssetImage(add_image);
  static const esFlagProvider      = AssetImage(es_flag);
  static const enFlagProvider      = AssetImage(en_flag);
  static const itFlagProvider      = AssetImage(it_flag);
  static const elFlagProvider      = AssetImage(el_flag);
  static const trFlagProvider      = AssetImage(tr_flag);
  static const frFlagProvider      = AssetImage(fr_flag);
  static const ptFlagProvider      = AssetImage(pt_flag);
}

/// Generic reusable icon widget for all raster icons in [AppIcons].
/// It standardizes size, quality, and supports optional tint for monochrome icons.
class AppIcon extends StatelessWidget {
  final String path;
  final double size;
  final BoxFit fit;
  final bool allowTint;
  final Color? color;

  const AppIcon(
    this.path, {
    super.key,
    this.size = 24,
    this.fit = BoxFit.contain,
    this.allowTint = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Use ImageIcon only when tinting (single-color PNGs)
    if (allowTint && color != null) {
      return ImageIcon(AssetImage(path), size: size, color: color);
    }
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: fit,
      filterQuality: FilterQuality.medium,
    );
  }
}
