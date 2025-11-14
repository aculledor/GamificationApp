import 'package:flutter/widgets.dart';
import 'package:aquatechinn_quiz/data/content_repository.dart';

class ContentI18nController extends ChangeNotifier {
  ContentStrings? _strings;
  Locale? _current;

  String t(String key) => _strings?.t(key) ?? key;

  Future<void> syncWith(BuildContext context) async {
    final loc = Localizations.localeOf(context);
    if (_current == loc && _strings != null) return;
    _current = loc;
    _strings = await ContentStrings.loadForLocale(loc);
    notifyListeners();
  }
}

class ContentI18nScope extends InheritedNotifier<ContentI18nController> {
  const ContentI18nScope({
    super.key,
    required ContentI18nController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static ContentI18nController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ContentI18nScope>();
    assert(scope != null, 'ContentI18nScope no está en el árbol.');
    return scope!.notifier!;
  }
}

/// Autosincroniza con el Locale cada vez que cambia Localizations.
class ContentI18nAutoSync extends StatefulWidget {
  final Widget child;
  const ContentI18nAutoSync({super.key, required this.child});

  @override
  State<ContentI18nAutoSync> createState() => _ContentI18nAutoSyncState();
}

class _ContentI18nAutoSyncState extends State<ContentI18nAutoSync> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ContentI18nScope.of(context).syncWith(context);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

abstract class ContentI18n {
  static String t(BuildContext context, String key) =>
      ContentI18nScope.of(context).t(key);
}
