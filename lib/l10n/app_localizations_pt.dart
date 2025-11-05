// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Quiz Aquatechinn';

  @override
  String get tabQuestionnaire => 'Questionário';

  @override
  String get tabPerformance => 'Desempenho';

  @override
  String get tabOptions => 'Opções';

  @override
  String get counterFlame => 'Chama';

  @override
  String get counterEnergy => 'Energia';

  @override
  String get counterMedals => 'Medalhas';

  @override
  String get changeLanguage => 'Mudar idioma';

  @override
  String get exportResults => 'Exportar resultados';

  @override
  String get resetProgress => 'Repor progresso';

  @override
  String get profileNameLabel => 'Nome';

  @override
  String get profileSurnameLabel => 'Apelido';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String languageSetTo({required String code}) {
    return 'Idioma definido para $code';
  }

  @override
  String get resetAllProgressTitle => 'Repor todo o progresso?';

  @override
  String get resetAllProgressBody =>
      'Isto irá eliminar todos os resultados do quiz (estrelas, tentativas, percentagens) e os dados da sequência diária.\n\nO teu perfil pessoal e as definições de idioma NÃO serão eliminados.\nEsta ação não pode ser anulada.';

  @override
  String get allProgressResetDone => 'Todo o progresso foi reposto.';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonReset => 'Repor';

  @override
  String editFieldTitle({required String field}) {
    return 'Editar $field';
  }

  @override
  String editFieldTooltip({required String field}) {
    return 'Editar $field';
  }

  @override
  String fieldUpdated({required String field}) {
    return '$field atualizado';
  }

  @override
  String get reportTitle => 'Relatório de Desempenho do Quiz';

  @override
  String get reportNameLabel => 'Nome';

  @override
  String get reportEmailLabel => 'Email';

  @override
  String get reportGeneratedLabel => 'Gerado em';

  @override
  String get reportColTopic => 'Tópico';

  @override
  String get reportColBestPct => 'Melhor %';

  @override
  String get reportColStars => 'Estrelas';

  @override
  String get reportColBestCt => 'Melhor (c/t)';

  @override
  String get reportColDate => 'Data';

  @override
  String moduleTitle({required String number, required String name}) {
    return 'Módulo $number: $name';
  }

  @override
  String topicTitle({required String name}) {
    return '$name';
  }

  @override
  String get earnMoreStars => 'Ganha mais estrelas para desbloquear!';

  @override
  String starsProgress({required String have, required String need}) {
    return '$have/$need';
  }

  @override
  String starsLeft({required num count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam # estrelas',
      one: 'Falta # estrela',
      zero: 'Desbloqueado',
    );
    return '$_temp0';
  }

  @override
  String get summaryModuleTitle => 'Resumo do Módulo';

  @override
  String summaryTopicTitle({required Object number}) {
    return 'Resumo do Tópico $number';
  }

  @override
  String get noPreviousScore => 'Sem pontuação anterior';

  @override
  String lastBestScore({required Object score, required Object total}) {
    return 'Melhor pontuação anterior: $score/$total';
  }

  @override
  String dateLabel({required Object date}) {
    return 'Data: $date';
  }

  @override
  String get startQuiz => 'Iniciar quiz';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get backTooltip => 'Voltar';

  @override
  String get performanceOverview => 'Visão geral';

  @override
  String get badgesTitle => 'Insígnias';

  @override
  String get achievementsTitle => 'Conquistas';

  @override
  String get reviewAll => 'ver todas';

  @override
  String get comingSoon => 'Brevemente disponível';

  @override
  String streakDays({required String days}) {
    return 'Sequência de $days dia(s)';
  }

  @override
  String badgesCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Insígnias',
      one: '1 Insígnia',
      zero: 'Sem insígnias',
    );
    return '$_temp0';
  }

  @override
  String achievementsCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Conquistas',
      one: '1 Conquista',
      zero: 'Sem conquistas',
    );
    return '$_temp0';
  }

  @override
  String badgeGenericTitle({required String number}) {
    return 'Conquista $number';
  }

  @override
  String get badgeDateLabel => 'Data';

  @override
  String get achStreak2days => 'Sequência de 2 dias';

  @override
  String get achStreak5days => 'Sequência de 5 dias';

  @override
  String get achStreak7days => 'Sequência de 7 dias';

  @override
  String get achProfileUpdated => 'Perfil atualizado';

  @override
  String get achExportedOnce => 'Resultados exportados uma vez';

  @override
  String get badgeAllTopicsAnyScore => 'Todos os tópicos tentados';

  @override
  String get badgeAllTopicsAtLeast2Stars => 'Pelo menos 2★ em todos os tópicos';

  @override
  String get badgeAllTopics3Stars => '3★ em todos os tópicos';

  @override
  String badgeTopicThreeStars({required String topic}) {
    return '$topic – 3★';
  }

  @override
  String get achStreak2daysDesc => 'Inicia sessão em dois dias consecutivos.';

  @override
  String get achStreak5daysDesc => 'Inicia sessão em cinco dias consecutivos.';

  @override
  String get achStreak7daysDesc => 'Inicia sessão em sete dias consecutivos.';

  @override
  String get achProfileUpdatedDesc => 'Atualiza as informações do teu perfil.';

  @override
  String get achExportedOnceDesc =>
      'Exporta os teus resultados pelo menos uma vez.';

  @override
  String get newAwardsTitle => 'Novas recompensas desbloqueadas!';

  @override
  String get newAchievementsTitle => 'Conquistas';

  @override
  String get newBadgesTitle => 'Insígnias';

  @override
  String get okGotIt => 'OK, entendi';

  @override
  String badgeTopicThreeStarsDesc({required String topic}) {
    return 'Ganha 3 estrelas no tópico $topic.';
  }

  @override
  String get badgeAllTopicsAnyScoreDesc =>
      'Tenta todos os tópicos do quiz pelo menos uma vez.';

  @override
  String get badgeAllTopicsAtLeast2StarsDesc =>
      'Ganha pelo menos 2 estrelas em todos os tópicos.';

  @override
  String get badgeAllTopics3StarsDesc =>
      'Ganha 3 estrelas em todos os tópicos.';

  @override
  String get keepPlayingToUnlock =>
      'Continua a jogar para desbloquear mais recompensas!';

  @override
  String get summaryLabel => 'Resumo';

  @override
  String topicsProgressLabel({required String done, required String total}) {
    return '$done/$total Tópicos';
  }

  @override
  String get warningTitle => 'Aviso';

  @override
  String get quizExitWarning =>
      'Tens a certeza de que queres sair do quiz? O teu progresso atual será perdido.';

  @override
  String get yesExit => 'Sim, sair';

  @override
  String get continueQuiz => 'Continuar quiz';

  @override
  String get question => 'Pergunta';

  @override
  String get check => 'Verificar';

  @override
  String get successes => 'Acertos';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get freeTextHint => 'Escreve aqui a tua resposta';
}
