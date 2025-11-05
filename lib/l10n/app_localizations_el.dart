// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Κουίζ Aquatechinn';

  @override
  String get tabQuestionnaire => 'Ερωτηματολόγιο';

  @override
  String get tabPerformance => 'Απόδοση';

  @override
  String get tabOptions => 'Επιλογές';

  @override
  String get counterFlame => 'Φλόγα';

  @override
  String get counterEnergy => 'Ενέργεια';

  @override
  String get counterMedals => 'Μετάλλια';

  @override
  String get changeLanguage => 'Αλλαγή γλώσσας';

  @override
  String get exportResults => 'Εξαγωγή αποτελεσμάτων';

  @override
  String get resetProgress => 'Επαναφορά προόδου';

  @override
  String get profileNameLabel => 'Όνομα';

  @override
  String get profileSurnameLabel => 'Επώνυμο';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String languageSetTo({required String code}) {
    return 'Η γλώσσα ορίστηκε σε $code';
  }

  @override
  String get resetAllProgressTitle => 'Επαναφορά όλης της προόδου;';

  @override
  String get resetAllProgressBody =>
      'Αυτό θα διαγράψει όλα τα αποτελέσματα κουίζ (αστέρια, προσπάθειες, ποσοστά) και τα δεδομένα συνεχόμενων ημερών.\n\nΤο προσωπικό σας προφίλ και οι ρυθμίσεις γλώσσας ΔΕΝ θα διαγραφούν.\nΑυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get allProgressResetDone => 'Όλη η πρόοδος διαγράφηκε.';

  @override
  String get commonCancel => 'Άκυρο';

  @override
  String get commonSave => 'Αποθήκευση';

  @override
  String get commonReset => 'Επαναφορά';

  @override
  String editFieldTitle({required String field}) {
    return 'Επεξεργασία $field';
  }

  @override
  String editFieldTooltip({required String field}) {
    return 'Επεξεργασία $field';
  }

  @override
  String fieldUpdated({required String field}) {
    return 'Το $field ενημερώθηκε';
  }

  @override
  String get reportTitle => 'Αναφορά απόδοσης κουίζ';

  @override
  String get reportNameLabel => 'Όνομα';

  @override
  String get reportEmailLabel => 'Email';

  @override
  String get reportGeneratedLabel => 'Ημερομηνία δημιουργίας';

  @override
  String get reportColTopic => 'Θέμα';

  @override
  String get reportColBestPct => 'Καλύτερο %';

  @override
  String get reportColStars => 'Αστέρια';

  @override
  String get reportColBestCt => 'Καλύτερο (σ/π)';

  @override
  String get reportColDate => 'Ημερομηνία';

  @override
  String moduleTitle({required String number, required String name}) {
    return 'Ενότητα $number: $name';
  }

  @override
  String topicTitle({required String name}) {
    return '$name';
  }

  @override
  String get earnMoreStars =>
      'Κερδίστε περισσότερα αστέρια για να ξεκλειδώσετε!';

  @override
  String starsProgress({required String have, required String need}) {
    return '$have/$need';
  }

  @override
  String starsLeft({required num count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Απομένουν # αστέρια',
      one: 'Απομένει # αστέρι',
      zero: 'Ξεκλειδώθηκε',
    );
    return '$_temp0';
  }

  @override
  String get summaryModuleTitle => 'Περίληψη ενότητας';

  @override
  String summaryTopicTitle({required Object number}) {
    return 'Περίληψη θέματος $number';
  }

  @override
  String get noPreviousScore => 'Χωρίς προηγούμενη βαθμολογία';

  @override
  String lastBestScore({required Object score, required Object total}) {
    return 'Τελευταία καλύτερη βαθμολογία: $score/$total';
  }

  @override
  String dateLabel({required Object date}) {
    return 'Ημερομηνία: $date';
  }

  @override
  String get startQuiz => 'Έναρξη κουίζ';

  @override
  String get tryAgain => 'Προσπαθήστε ξανά';

  @override
  String get backTooltip => 'Πίσω';

  @override
  String get performanceOverview => 'Επισκόπηση';

  @override
  String get badgesTitle => 'Διακριτικά';

  @override
  String get achievementsTitle => 'Επιτεύγματα';

  @override
  String get reviewAll => 'προβολή όλων';

  @override
  String get comingSoon => 'Έρχεται σύντομα';

  @override
  String streakDays({required String days}) {
    return 'Σειρά $days ημερών';
  }

  @override
  String badgesCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count διακριτικά',
      one: '1 διακριτικό',
      zero: 'Χωρίς διακριτικά',
    );
    return '$_temp0';
  }

  @override
  String achievementsCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count επιτεύγματα',
      one: '1 επίτευγμα',
      zero: 'Χωρίς επιτεύγματα',
    );
    return '$_temp0';
  }

  @override
  String badgeGenericTitle({required String number}) {
    return 'Επίτευγμα $number';
  }

  @override
  String get badgeDateLabel => 'Ημερομηνία';

  @override
  String get achStreak2days => 'Σειρά 2 ημερών';

  @override
  String get achStreak5days => 'Σειρά 5 ημερών';

  @override
  String get achStreak7days => 'Σειρά 7 ημερών';

  @override
  String get achProfileUpdated => 'Το προφίλ ενημερώθηκε';

  @override
  String get achExportedOnce => 'Εξαγωγή αποτελεσμάτων μία φορά';

  @override
  String get badgeAllTopicsAnyScore => 'Όλα τα θέματα δοκιμάστηκαν';

  @override
  String get badgeAllTopicsAtLeast2Stars => 'Τουλάχιστον 2★ σε όλα τα θέματα';

  @override
  String get badgeAllTopics3Stars => '3★ σε όλα τα θέματα';

  @override
  String badgeTopicThreeStars({required String topic}) {
    return '$topic – 3★';
  }

  @override
  String get achStreak2daysDesc => 'Συνδεθείτε δύο συνεχόμενες ημέρες.';

  @override
  String get achStreak5daysDesc => 'Συνδεθείτε πέντε συνεχόμενες ημέρες.';

  @override
  String get achStreak7daysDesc => 'Συνδεθείτε επτά συνεχόμενες ημέρες.';

  @override
  String get achProfileUpdatedDesc =>
      'Ενημερώστε τις πληροφορίες του προφίλ σας.';

  @override
  String get achExportedOnceDesc =>
      'Εξαγάγετε τα αποτελέσματά σας τουλάχιστον μία φορά.';

  @override
  String get newAwardsTitle => 'Ξεκλειδώθηκαν νέα βραβεία!';

  @override
  String get newAchievementsTitle => 'Επιτεύγματα';

  @override
  String get newBadgesTitle => 'Διακριτικά';

  @override
  String get okGotIt => 'Εντάξει, κατάλαβα';

  @override
  String badgeTopicThreeStarsDesc({required String topic}) {
    return 'Κερδίστε 3 αστέρια στο θέμα $topic.';
  }

  @override
  String get badgeAllTopicsAnyScoreDesc =>
      'Προσπαθήστε όλα τα θέματα του κουίζ τουλάχιστον μία φορά.';

  @override
  String get badgeAllTopicsAtLeast2StarsDesc =>
      'Κερδίστε τουλάχιστον 2 αστέρια σε όλα τα θέματα.';

  @override
  String get badgeAllTopics3StarsDesc => 'Κερδίστε 3 αστέρια σε όλα τα θέματα.';

  @override
  String get keepPlayingToUnlock =>
      'Συνεχίστε να παίζετε για να ξεκλειδώσετε περισσότερες ανταμοιβές!';

  @override
  String get summaryLabel => 'Περίληψη';

  @override
  String topicsProgressLabel({required String done, required String total}) {
    return '$done/$total θέματα';
  }

  @override
  String get warningTitle => 'Προειδοποίηση';

  @override
  String get quizExitWarning =>
      'Είστε βέβαιοι ότι θέλετε να αποχωρήσετε από το κουίζ; Η τρέχουσα πρόοδος θα χαθεί.';

  @override
  String get yesExit => 'Ναι, έξοδος';

  @override
  String get continueQuiz => 'Συνέχεια κουίζ';

  @override
  String get question => 'Ερώτηση';

  @override
  String get check => 'Έλεγχος';

  @override
  String get successes => 'Επιτυχίες';

  @override
  String get continueLabel => 'Συνέχεια';

  @override
  String get freeTextHint => 'Πληκτρολογήστε την απάντησή σας εδώ';
}
