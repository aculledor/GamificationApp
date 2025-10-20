import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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
  final Map<String,String> _m;
  ContentStrings(this._m);
  String t(String key) => _m[key] ?? key;

  static Future<ContentStrings> loadForLocale(String localeCode) async {
    // expect assets/i18n_content/questions_en.json etc.
    final lang = (localeCode.split('_').first).toLowerCase();
    final path = 'assets/i18n_content/questions_${lang}.json';
    final raw = await rootBundle.loadString(path);
    final map = Map<String,dynamic>.from(json.decode(raw));
    return ContentStrings(map.map((k,v)=>MapEntry(k, v.toString())));
  }
}
