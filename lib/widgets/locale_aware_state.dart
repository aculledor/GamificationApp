import 'package:flutter/widgets.dart';

/// Mixin que detecta cambios de Locale y llama a [onLocaleChanged].
mixin LocaleAwareState<T extends StatefulWidget> on State<T> {
  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = Localizations.localeOf(context);
    if (_lastLocale != loc) {
      _lastLocale = loc;
      onLocaleChanged(loc);
    }
  }

  /// Sobrescribe en tus pantallas para recargar datos dependientes del idioma.
  void onLocaleChanged(Locale locale) {}
}
