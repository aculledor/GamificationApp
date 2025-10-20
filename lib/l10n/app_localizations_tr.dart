// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Aquatechinn Quiz';

  @override
  String get tabQuestionnaire => 'Questionnaire';

  @override
  String get tabPerformance => 'Performance';

  @override
  String get tabOptions => 'Options';

  @override
  String get counterFlame => 'Flame';

  @override
  String get counterEnergy => 'Energy';

  @override
  String get counterMedals => 'Medals';

  @override
  String moduleTitle({required String number, required String name}) {
    return 'Module $number: $name';
  }

  @override
  String topicTitle({required String name}) {
    return '$name';
  }

  @override
  String get earnMoreStars => 'Earn more stars to unlock!';

  @override
  String starsProgress({required String have, required String need}) {
    return '$have/$need';
  }

  @override
  String starsLeft({required num count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# stars left',
      one: '# star left',
      zero: 'Unlocked',
    );
    return '$_temp0';
  }
}
