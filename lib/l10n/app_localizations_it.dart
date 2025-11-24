// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Quiz Aquatechinn';

  @override
  String get tabQuestionnaire => 'Questionario';

  @override
  String get tabPerformance => 'Prestazioni';

  @override
  String get tabOptions => 'Opzioni';

  @override
  String get counterFlame => 'Fiamma';

  @override
  String get counterEnergy => 'Energia';

  @override
  String get counterMedals => 'Medaglie';

  @override
  String get changeLanguage => 'Cambia lingua';

  @override
  String get exportResults => 'Esporta risultati';

  @override
  String get resetProgress => 'Reimposta progressi';

  @override
  String get profileNameLabel => 'Nome';

  @override
  String get profileSurnameLabel => 'Cognome';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String languageSetTo({required String code}) {
    return 'Lingua impostata su $code';
  }

  @override
  String get resetAllProgressTitle => 'Reimpostare tutti i progressi?';

  @override
  String get resetAllProgressBody =>
      'Questo eliminerà tutti i risultati del quiz (stelle, tentativi, percentuali) e i dati delle serie.\n\nIl tuo profilo personale e le impostazioni della lingua NON saranno eliminati.\nQuesta azione non può essere annullata.';

  @override
  String get allProgressResetDone =>
      'Tutti i progressi sono stati reimpostati.';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonReset => 'Reimposta';

  @override
  String editFieldTitle({required String field}) {
    return 'Modifica $field';
  }

  @override
  String editFieldTooltip({required String field}) {
    return 'Modifica $field';
  }

  @override
  String fieldUpdated({required String field}) {
    return '$field aggiornato';
  }

  @override
  String get reportTitle => 'Rapporto sulle prestazioni del quiz';

  @override
  String get reportNameLabel => 'Nome';

  @override
  String get reportEmailLabel => 'Email';

  @override
  String get reportGeneratedLabel => 'Generato';

  @override
  String get reportColTopic => 'Argomento';

  @override
  String get reportColBestPct => 'Miglior %';

  @override
  String get reportColStars => 'Stelle';

  @override
  String get reportColBestCt => 'Miglior (c/t)';

  @override
  String get reportColDate => 'Data';

  @override
  String moduleTitle({required String number, required String name}) {
    return 'Modulo $number: $name';
  }

  @override
  String topicTitle({required String name}) {
    return '$name';
  }

  @override
  String get earnMoreStars => 'Guadagna più stelle per sbloccare!';

  @override
  String starsProgress({required String have, required String need}) {
    return '$have/$need';
  }

  @override
  String starsLeft({required num count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# stelle rimanenti',
      one: '# stella rimanente',
      zero: 'Sbloccato',
    );
    return '$_temp0';
  }

  @override
  String get summaryModuleTitle => 'Riepilogo modulo';

  @override
  String summaryTopicTitle({required Object number}) {
    return 'Riepilogo argomento $number';
  }

  @override
  String get noPreviousScore => 'Nessun punteggio precedente';

  @override
  String lastBestScore({required Object score, required Object total}) {
    return 'Ultimo miglior punteggio: $score/$total';
  }

  @override
  String dateLabel({required Object date}) {
    return 'Data: $date';
  }

  @override
  String get startQuiz => 'Inizia il quiz';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get backTooltip => 'Indietro';

  @override
  String get performanceOverview => 'Panoramica';

  @override
  String get badgesTitle => 'Distintivi';

  @override
  String get achievementsTitle => 'Obiettivi';

  @override
  String get reviewAll => 'rivedi tutto';

  @override
  String get comingSoon => 'Prossimamente';

  @override
  String streakDays({required String days}) {
    return '$days giorni consecutivi';
  }

  @override
  String badgesCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count distintivi',
      one: '1 distintivo',
      zero: 'Nessun distintivo',
    );
    return '$_temp0';
  }

  @override
  String achievementsCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obiettivi',
      one: '1 obiettivo',
      zero: 'Nessun obiettivo',
    );
    return '$_temp0';
  }

  @override
  String badgeGenericTitle({required String number}) {
    return 'Obiettivo $number';
  }

  @override
  String get badgeDateLabel => 'Data';

  @override
  String get achStreak2days => 'Serie di 2 giorni';

  @override
  String get achStreak5days => 'Serie di 5 giorni';

  @override
  String get achStreak7days => 'Serie di 7 giorni';

  @override
  String get achProfileUpdated => 'Profilo aggiornato';

  @override
  String get achExportedOnce => 'Risultati esportati una volta';

  @override
  String get badgeAllTopicsAnyScore => 'Tutti gli argomenti tentati';

  @override
  String get badgeAllTopicsAtLeast2Stars => 'Almeno 2★ in tutti gli argomenti';

  @override
  String get badgeAllTopics3Stars => '3★ in tutti gli argomenti';

  @override
  String badgeTopicThreeStars({required String topic}) {
    return '$topic – 3★';
  }

  @override
  String get achStreak2daysDesc => 'Accedi per due giorni consecutivi.';

  @override
  String get achStreak5daysDesc => 'Accedi per cinque giorni consecutivi.';

  @override
  String get achStreak7daysDesc => 'Accedi per sette giorni consecutivi.';

  @override
  String get achProfileUpdatedDesc =>
      'Aggiorna le informazioni del tuo profilo.';

  @override
  String get achExportedOnceDesc =>
      'Esporta i tuoi risultati almeno una volta.';

  @override
  String get newAwardsTitle => 'Nuovi premi sbloccati!';

  @override
  String get newAchievementsTitle => 'Obiettivi';

  @override
  String get newBadgesTitle => 'Distintivi';

  @override
  String get okGotIt => 'OK, capito';

  @override
  String badgeTopicThreeStarsDesc({required String topic}) {
    return 'Ottieni 3 stelle nell\'argomento $topic.';
  }

  @override
  String get badgeAllTopicsAnyScoreDesc =>
      'Prova tutti gli argomenti del quiz almeno una volta.';

  @override
  String get badgeAllTopicsAtLeast2StarsDesc =>
      'Ottieni almeno 2 stelle in tutti gli argomenti.';

  @override
  String get badgeAllTopics3StarsDesc =>
      'Ottieni 3 stelle in tutti gli argomenti.';

  @override
  String get keepPlayingToUnlock =>
      'Continua a giocare per sbloccare più ricompense!';

  @override
  String get summaryLabel => 'Riepilogo';

  @override
  String topicsProgressLabel({required String done, required String total}) {
    return '$done/$total Argomenti';
  }

  @override
  String get warningTitle => 'Avviso';

  @override
  String get quizExitWarning =>
      'Sei sicuro di voler uscire dal quiz? I progressi attuali andranno persi.';

  @override
  String get yesExit => 'Sì, esci';

  @override
  String get continueQuiz => 'Continua quiz';

  @override
  String get question => 'Domanda';

  @override
  String get check => 'Verifica';

  @override
  String get successes => 'Successi';

  @override
  String get continueLabel => 'Continua';

  @override
  String get freeTextHint => 'Scrivi qui la tua risposta';

  @override
  String get unlockAllTopicsButton => 'Sblocca tutti gli argomenti';

  @override
  String get unlockAllTopicsEnabled =>
      'Tutti gli argomenti sono ora sbloccati.';

  @override
  String get unlockAllTopicsDisabled =>
      'I requisiti di stelle sono stati ripristinati.';
}
