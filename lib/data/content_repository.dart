import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart'; // <-- needed for Locale
import 'models.dart';

class ContentRepository {
  ContentBundle? _cache;
  Future<ContentBundle> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/content/modules.json');
    _cache = ContentBundle.fromJson(json.decode(raw));
    return _cache!;
  }
}

class ContentStrings {
  final Map<String, String> _m;
  ContentStrings(this._m);

  String t(String key) => _m[key] ?? key;

  static Future<ContentStrings> loadForLocale(Locale locale) async {
    final lang = locale.languageCode.toLowerCase();
    final fallback = 'assets/i18n_content/questions_en.json';
    final path = 'assets/i18n_content/questions_$lang.json';

    try {
      final raw = await rootBundle.loadString(path);
      final map = Map<String, dynamic>.from(json.decode(raw));
      return ContentStrings(map.map((k, v) => MapEntry(k, v.toString())));
    } catch (e) {
      // fallback if missing or not yet translated
      // ignore: avoid_print
      print('⚠️ Missing or invalid $path, falling back to English');
      final raw = await rootBundle.loadString(fallback);
      final map = Map<String, dynamic>.from(json.decode(raw));
      return ContentStrings(map.map((k, v) => MapEntry(k, v.toString())));
    }
  }
}

