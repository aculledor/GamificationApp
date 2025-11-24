import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Aquatechinn Quiz'**
  String get appTitle;

  /// No description provided for @tabQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire'**
  String get tabQuestionnaire;

  /// No description provided for @tabPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get tabPerformance;

  /// No description provided for @tabOptions.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get tabOptions;

  /// No description provided for @counterFlame.
  ///
  /// In en, this message translates to:
  /// **'Flame'**
  String get counterFlame;

  /// No description provided for @counterEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get counterEnergy;

  /// No description provided for @counterMedals.
  ///
  /// In en, this message translates to:
  /// **'Medals'**
  String get counterMedals;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @exportResults.
  ///
  /// In en, this message translates to:
  /// **'Export Results'**
  String get exportResults;

  /// No description provided for @resetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset Progress'**
  String get resetProgress;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileNameLabel;

  /// No description provided for @profileSurnameLabel.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get profileSurnameLabel;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// Snackbar shown after user selects a new language
  ///
  /// In en, this message translates to:
  /// **'Language set to {code}'**
  String languageSetTo({required String code});

  /// No description provided for @resetAllProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all progress?'**
  String get resetAllProgressTitle;

  /// No description provided for @resetAllProgressBody.
  ///
  /// In en, this message translates to:
  /// **'This will delete all quiz results (stars, attempts, percentages) and streak data.\n\nYour personal profile and language settings will NOT be deleted.\nThis action cannot be undone.'**
  String get resetAllProgressBody;

  /// No description provided for @allProgressResetDone.
  ///
  /// In en, this message translates to:
  /// **'All progress has been reset.'**
  String get allProgressResetDone;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get commonReset;

  /// Title of the edit field dialog
  ///
  /// In en, this message translates to:
  /// **'Edit {field}'**
  String editFieldTitle({required String field});

  /// Tooltip for the edit field button
  ///
  /// In en, this message translates to:
  /// **'Edit {field}'**
  String editFieldTooltip({required String field});

  /// Snackbar shown after user updates a profile field
  ///
  /// In en, this message translates to:
  /// **'{field} updated'**
  String fieldUpdated({required String field});

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz Performance Report'**
  String get reportTitle;

  /// No description provided for @reportNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get reportNameLabel;

  /// No description provided for @reportEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get reportEmailLabel;

  /// No description provided for @reportGeneratedLabel.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get reportGeneratedLabel;

  /// No description provided for @reportColTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get reportColTopic;

  /// No description provided for @reportColBestPct.
  ///
  /// In en, this message translates to:
  /// **'Best %'**
  String get reportColBestPct;

  /// No description provided for @reportColStars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get reportColStars;

  /// No description provided for @reportColBestCt.
  ///
  /// In en, this message translates to:
  /// **'Best (c/t)'**
  String get reportColBestCt;

  /// No description provided for @reportColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get reportColDate;

  /// No description provided for @moduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Module {number}: {name}'**
  String moduleTitle({required String number, required String name});

  /// No description provided for @topicTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String topicTitle({required String name});

  /// No description provided for @earnMoreStars.
  ///
  /// In en, this message translates to:
  /// **'Earn more stars to unlock!'**
  String get earnMoreStars;

  /// No description provided for @starsProgress.
  ///
  /// In en, this message translates to:
  /// **'{have}/{need}'**
  String starsProgress({required String have, required String need});

  /// No description provided for @starsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Unlocked} one{# star left} other{# stars left}}'**
  String starsLeft({required num count});

  /// No description provided for @summaryModuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Module Summary'**
  String get summaryModuleTitle;

  /// Title of the topic summary screen with topic index
  ///
  /// In en, this message translates to:
  /// **'Summary Topic {number}'**
  String summaryTopicTitle({required Object number});

  /// Shown when the user has not answered this topic before
  ///
  /// In en, this message translates to:
  /// **'No previous score'**
  String get noPreviousScore;

  /// Shows the previous best raw score
  ///
  /// In en, this message translates to:
  /// **'Last best Score: {score}/{total}'**
  String lastBestScore({required Object score, required Object total});

  /// Date of the previous best score
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLabel({required Object date});

  /// CTA when user has no previous score
  ///
  /// In en, this message translates to:
  /// **'Start quiz'**
  String get startQuiz;

  /// CTA when user has a previous score
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Tooltip for the back/close button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backTooltip;

  /// No description provided for @performanceOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get performanceOverview;

  /// No description provided for @badgesTitle.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badgesTitle;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @reviewAll.
  ///
  /// In en, this message translates to:
  /// **'review all'**
  String get reviewAll;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} Day Streak'**
  String streakDays({required String days});

  /// Displays the number of badges with plural logic.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No badges} =1 {1 Badge} other {{count} Badges}}'**
  String badgesCount({required int count});

  /// Displays the number of achievements with plural logic.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No achievements} =1 {1 Achievement} other {{count} Achievements}}'**
  String achievementsCount({required int count});

  /// Generic title for achievements or badges
  ///
  /// In en, this message translates to:
  /// **'Achievement {number}'**
  String badgeGenericTitle({required String number});

  /// No description provided for @badgeDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get badgeDateLabel;

  /// No description provided for @achStreak2days.
  ///
  /// In en, this message translates to:
  /// **'2-day streak'**
  String get achStreak2days;

  /// No description provided for @achStreak5days.
  ///
  /// In en, this message translates to:
  /// **'5-day streak'**
  String get achStreak5days;

  /// No description provided for @achStreak7days.
  ///
  /// In en, this message translates to:
  /// **'7-day streak'**
  String get achStreak7days;

  /// No description provided for @achProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get achProfileUpdated;

  /// No description provided for @achExportedOnce.
  ///
  /// In en, this message translates to:
  /// **'Exported results once'**
  String get achExportedOnce;

  /// No description provided for @badgeAllTopicsAnyScore.
  ///
  /// In en, this message translates to:
  /// **'All topics attempted'**
  String get badgeAllTopicsAnyScore;

  /// No description provided for @badgeAllTopicsAtLeast2Stars.
  ///
  /// In en, this message translates to:
  /// **'At least 2★ in all topics'**
  String get badgeAllTopicsAtLeast2Stars;

  /// No description provided for @badgeAllTopics3Stars.
  ///
  /// In en, this message translates to:
  /// **'3★ in all topics'**
  String get badgeAllTopics3Stars;

  /// Badge for getting 3 stars in a specific topic
  ///
  /// In en, this message translates to:
  /// **'{topic} – 3★'**
  String badgeTopicThreeStars({required String topic});

  /// No description provided for @achStreak2daysDesc.
  ///
  /// In en, this message translates to:
  /// **'Log in on two consecutive days.'**
  String get achStreak2daysDesc;

  /// No description provided for @achStreak5daysDesc.
  ///
  /// In en, this message translates to:
  /// **'Log in on five consecutive days.'**
  String get achStreak5daysDesc;

  /// No description provided for @achStreak7daysDesc.
  ///
  /// In en, this message translates to:
  /// **'Log in on seven consecutive days.'**
  String get achStreak7daysDesc;

  /// No description provided for @achProfileUpdatedDesc.
  ///
  /// In en, this message translates to:
  /// **'Update your profile information.'**
  String get achProfileUpdatedDesc;

  /// No description provided for @achExportedOnceDesc.
  ///
  /// In en, this message translates to:
  /// **'Export your results at least once.'**
  String get achExportedOnceDesc;

  /// No description provided for @newAwardsTitle.
  ///
  /// In en, this message translates to:
  /// **'New awards unlocked!'**
  String get newAwardsTitle;

  /// No description provided for @newAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get newAchievementsTitle;

  /// No description provided for @newBadgesTitle.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get newBadgesTitle;

  /// No description provided for @okGotIt.
  ///
  /// In en, this message translates to:
  /// **'OK, got it'**
  String get okGotIt;

  /// Description for the badge for getting 3 stars in a specific topic
  ///
  /// In en, this message translates to:
  /// **'Earn 3 stars in the topic {topic}.'**
  String badgeTopicThreeStarsDesc({required String topic});

  /// No description provided for @badgeAllTopicsAnyScoreDesc.
  ///
  /// In en, this message translates to:
  /// **'Attempt all topics in the quiz at least once.'**
  String get badgeAllTopicsAnyScoreDesc;

  /// No description provided for @badgeAllTopicsAtLeast2StarsDesc.
  ///
  /// In en, this message translates to:
  /// **'Earn at least 2 stars in all topics.'**
  String get badgeAllTopicsAtLeast2StarsDesc;

  /// No description provided for @badgeAllTopics3StarsDesc.
  ///
  /// In en, this message translates to:
  /// **'Earn 3 stars in all topics.'**
  String get badgeAllTopics3StarsDesc;

  /// No description provided for @keepPlayingToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Keep playing to unlock more rewards!'**
  String get keepPlayingToUnlock;

  /// No description provided for @summaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryLabel;

  /// No description provided for @topicsProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} Topics'**
  String topicsProgressLabel({required String done, required String total});

  /// No description provided for @warningTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warningTitle;

  /// No description provided for @quizExitWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the quiz? Your current progress will be lost.'**
  String get quizExitWarning;

  /// No description provided for @yesExit.
  ///
  /// In en, this message translates to:
  /// **'Yes, exit'**
  String get yesExit;

  /// No description provided for @continueQuiz.
  ///
  /// In en, this message translates to:
  /// **'Continue quiz'**
  String get continueQuiz;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @successes.
  ///
  /// In en, this message translates to:
  /// **'Successes'**
  String get successes;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @freeTextHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here'**
  String get freeTextHint;

  /// No description provided for @unlockAllTopicsButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock all topics'**
  String get unlockAllTopicsButton;

  /// No description provided for @unlockAllTopicsEnabled.
  ///
  /// In en, this message translates to:
  /// **'All topics are now unlocked.'**
  String get unlockAllTopicsEnabled;

  /// No description provided for @unlockAllTopicsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Star requirements have been restored.'**
  String get unlockAllTopicsDisabled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'el',
    'en',
    'es',
    'fr',
    'it',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
