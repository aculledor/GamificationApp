import 'package:flutter/widgets.dart';

class AppLocaleController extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale? l) {
    if (_locale == l) return;
    _locale = l;
    notifyListeners();
  }
}

class AppLocaleScope extends InheritedNotifier<AppLocaleController> {
  const AppLocaleScope({
    super.key,
    required AppLocaleController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  /// Versión segura: devuelve null si no existe en el árbol
  static AppLocaleController? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    return scope?.notifier;
  }

  /// Versión estricta (manténla por si la usas)
  static AppLocaleController of(BuildContext context) {
    final ctrl = maybeOf(context);
    assert(ctrl != null, 'AppLocaleScope no está en el árbol.');
    return ctrl!;
  }
}
