// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

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
  String get changeLanguage => 'Change Language';

  @override
  String get exportResults => 'Export Results';

  @override
  String get resetProgress => 'Reset Progress';

  @override
  String get profileNameLabel => 'Name';

  @override
  String get profileSurnameLabel => 'Surname';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String languageSetTo({required String code}) {
    return 'Language set to $code';
  }

  @override
  String get resetAllProgressTitle => 'Reset all progress?';

  @override
  String get resetAllProgressBody =>
      'This will delete all quiz results (stars, attempts, percentages) and streak data.\n\nYour personal profile and language settings will NOT be deleted.\nThis action cannot be undone.';

  @override
  String get allProgressResetDone => 'All progress has been reset.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonReset => 'Reset';

  @override
  String editFieldTitle({required String field}) {
    return 'Edit $field';
  }

  @override
  String editFieldTooltip({required String field}) {
    return 'Edit $field';
  }

  @override
  String fieldUpdated({required String field}) {
    return '$field updated';
  }

  @override
  String get reportTitle => 'Quiz Performance Report';

  @override
  String get reportNameLabel => 'Name';

  @override
  String get reportEmailLabel => 'Email';

  @override
  String get reportGeneratedLabel => 'Generated';

  @override
  String get reportColTopic => 'Topic';

  @override
  String get reportColBestPct => 'Best %';

  @override
  String get reportColStars => 'Stars';

  @override
  String get reportColBestCt => 'Best (c/t)';

  @override
  String get reportColDate => 'Date';

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

  @override
  String summaryTopicTitle({required Object number}) {
    return 'Summary Topic $number';
  }

  @override
  String get noPreviousScore => 'No previous score';

  @override
  String lastBestScore({required Object score, required Object total}) {
    return 'Last best Score: $score/$total';
  }

  @override
  String dateLabel({required Object date}) {
    return 'Date: $date';
  }

  @override
  String get startQuiz => 'Start quiz';

  @override
  String get tryAgain => 'Try again';

  @override
  String get backTooltip => 'Back';

  @override
  String get performanceOverview => 'Overview';

  @override
  String get badgesTitle => 'Badges';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get reviewAll => 'review all';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String streakDays({required String days}) {
    return '$days Day Streak';
  }

  @override
  String badgesCount({required String count}) {
    return '$count Badges';
  }

  @override
  String achievementsCount({required String count}) {
    return '$count Achievement(s)';
  }

  @override
  String badgeGenericTitle({required String number}) {
    return 'Achievement $number';
  }

  @override
  String get badgeDateLabel => 'Date';

  @override
  String get achStreak2days => '2-day streak';

  @override
  String get achStreak5days => '5-day streak';

  @override
  String get achStreak7days => '7-day streak';

  @override
  String get achProfileUpdated => 'Profile updated';

  @override
  String get achExportedOnce => 'Exported results once';

  @override
  String get badgeAllTopicsAnyScore => 'All topics attempted';

  @override
  String get badgeAllTopicsAtLeast2Stars => 'At least 2★ in all topics';

  @override
  String get badgeAllTopics3Stars => '3★ in all topics';

  @override
  String badgeTopicThreeStars({required String topic}) {
    return '$topic – 3★';
  }
}
