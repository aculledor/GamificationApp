// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Quiz Aquatechinn';

  @override
  String get tabQuestionnaire => 'Questionnaire';

  @override
  String get tabPerformance => 'Performance';

  @override
  String get tabOptions => 'Options';

  @override
  String get counterFlame => 'Flamme';

  @override
  String get counterEnergy => 'Énergie';

  @override
  String get counterMedals => 'Médailles';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get exportResults => 'Exporter les résultats';

  @override
  String get resetProgress => 'Réinitialiser la progression';

  @override
  String get profileNameLabel => 'Prénom';

  @override
  String get profileSurnameLabel => 'Nom';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String languageSetTo({required String code}) {
    return 'Langue définie sur $code';
  }

  @override
  String get resetAllProgressTitle => 'Réinitialiser toute la progression ?';

  @override
  String get resetAllProgressBody =>
      'Cela supprimera tous les résultats du quiz (étoiles, tentatives, pourcentages) et les données de série.\n\nVotre profil personnel et vos paramètres de langue ne seront PAS supprimés.\nCette action est irréversible.';

  @override
  String get allProgressResetDone =>
      'Toute la progression a été réinitialisée.';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonReset => 'Réinitialiser';

  @override
  String editFieldTitle({required String field}) {
    return 'Modifier $field';
  }

  @override
  String editFieldTooltip({required String field}) {
    return 'Modifier $field';
  }

  @override
  String fieldUpdated({required String field}) {
    return '$field mis à jour';
  }

  @override
  String get reportTitle => 'Rapport de performance du quiz';

  @override
  String get reportNameLabel => 'Nom';

  @override
  String get reportEmailLabel => 'Email';

  @override
  String get reportGeneratedLabel => 'Généré';

  @override
  String get reportColTopic => 'Sujet';

  @override
  String get reportColBestPct => 'Meilleur %';

  @override
  String get reportColStars => 'Étoiles';

  @override
  String get reportColBestCt => 'Meilleur (c/t)';

  @override
  String get reportColDate => 'Date';

  @override
  String moduleTitle({required String number, required String name}) {
    return 'Module $number : $name';
  }

  @override
  String topicTitle({required String name}) {
    return '$name';
  }

  @override
  String get earnMoreStars => 'Gagnez plus d’étoiles pour débloquer !';

  @override
  String starsProgress({required String have, required String need}) {
    return '$have/$need';
  }

  @override
  String starsLeft({required num count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# étoiles restantes',
      one: '# étoile restante',
      zero: 'Débloqué',
    );
    return '$_temp0';
  }

  @override
  String get summaryModuleTitle => 'Résumé du module';

  @override
  String summaryTopicTitle({required Object number}) {
    return 'Résumé du sujet $number';
  }

  @override
  String get noPreviousScore => 'Aucun score précédent';

  @override
  String lastBestScore({required Object score, required Object total}) {
    return 'Meilleur score précédent : $score/$total';
  }

  @override
  String dateLabel({required Object date}) {
    return 'Date : $date';
  }

  @override
  String get startQuiz => 'Commencer le quiz';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get backTooltip => 'Retour';

  @override
  String get performanceOverview => 'Aperçu';

  @override
  String get badgesTitle => 'Badges';

  @override
  String get achievementsTitle => 'Réussites';

  @override
  String get reviewAll => 'tout examiner';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String streakDays({required String days}) {
    return '$days jour(s) consécutif(s)';
  }

  @override
  String badgesCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count badges',
      one: '1 badge',
      zero: 'Aucun badge',
    );
    return '$_temp0';
  }

  @override
  String achievementsCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count réussites',
      one: '1 réussite',
      zero: 'Aucune réussite',
    );
    return '$_temp0';
  }

  @override
  String badgeGenericTitle({required String number}) {
    return 'Réussite $number';
  }

  @override
  String get badgeDateLabel => 'Date';

  @override
  String get achStreak2days => 'Série de 2 jours';

  @override
  String get achStreak5days => 'Série de 5 jours';

  @override
  String get achStreak7days => 'Série de 7 jours';

  @override
  String get achProfileUpdated => 'Profil mis à jour';

  @override
  String get achExportedOnce => 'Résultats exportés une fois';

  @override
  String get badgeAllTopicsAnyScore => 'Tous les sujets tentés';

  @override
  String get badgeAllTopicsAtLeast2Stars => 'Au moins 2★ dans tous les sujets';

  @override
  String get badgeAllTopics3Stars => '3★ dans tous les sujets';

  @override
  String badgeTopicThreeStars({required String topic}) {
    return '$topic – 3★';
  }

  @override
  String get achStreak2daysDesc => 'Connectez-vous deux jours consécutifs.';

  @override
  String get achStreak5daysDesc => 'Connectez-vous cinq jours consécutifs.';

  @override
  String get achStreak7daysDesc => 'Connectez-vous sept jours consécutifs.';

  @override
  String get achProfileUpdatedDesc =>
      'Mettez à jour les informations de votre profil.';

  @override
  String get achExportedOnceDesc => 'Exportez vos résultats au moins une fois.';

  @override
  String get newAwardsTitle => 'Nouvelles récompenses débloquées !';

  @override
  String get newAchievementsTitle => 'Réussites';

  @override
  String get newBadgesTitle => 'Badges';

  @override
  String get okGotIt => 'OK, compris';

  @override
  String badgeTopicThreeStarsDesc({required String topic}) {
    return 'Obtenez 3 étoiles dans le sujet $topic.';
  }

  @override
  String get badgeAllTopicsAnyScoreDesc =>
      'Essayez tous les sujets du quiz au moins une fois.';

  @override
  String get badgeAllTopicsAtLeast2StarsDesc =>
      'Obtenez au moins 2 étoiles dans tous les sujets.';

  @override
  String get badgeAllTopics3StarsDesc =>
      'Obtenez 3 étoiles dans tous les sujets.';

  @override
  String get keepPlayingToUnlock =>
      'Continuez à jouer pour débloquer plus de récompenses !';

  @override
  String get summaryLabel => 'Résumé';

  @override
  String topicsProgressLabel({required String done, required String total}) {
    return '$done/$total sujets';
  }

  @override
  String get warningTitle => 'Avertissement';

  @override
  String get quizExitWarning =>
      'Êtes-vous sûr de vouloir quitter le quiz ? Votre progression actuelle sera perdue.';

  @override
  String get yesExit => 'Oui, quitter';

  @override
  String get continueQuiz => 'Continuer le quiz';

  @override
  String get question => 'Question';

  @override
  String get check => 'Vérifier';

  @override
  String get successes => 'Réussites';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get freeTextHint => 'Écrivez votre réponse ici';

  @override
  String get unlockAllTopicsButton => 'Déverrouiller tous les sujets';

  @override
  String get unlockAllTopicsEnabled =>
      'Tous les sujets sont maintenant déverrouillés.';

  @override
  String get unlockAllTopicsDisabled =>
      'Les exigences en étoiles ont été rétablies.';
}
