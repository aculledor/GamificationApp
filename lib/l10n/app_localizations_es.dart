// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cuestionario Aquatechinn';

  @override
  String get tabQuestionnaire => 'Cuestionario';

  @override
  String get tabPerformance => 'Rendimiento';

  @override
  String get tabOptions => 'Opciones';

  @override
  String get counterFlame => 'Racha';

  @override
  String get counterEnergy => 'Energía';

  @override
  String get counterMedals => 'Medallas';

  @override
  String get changeLanguage => 'Cambiar idioma';

  @override
  String get exportResults => 'Exportar resultados';

  @override
  String get resetProgress => 'Restablecer progreso';

  @override
  String get profileNameLabel => 'Nombre';

  @override
  String get profileSurnameLabel => 'Apellidos';

  @override
  String get profileEmailLabel => 'Correo electrónico';

  @override
  String languageSetTo({required String code}) {
    return 'Idioma establecido a $code';
  }

  @override
  String get resetAllProgressTitle => '¿Restablecer todo el progreso?';

  @override
  String get resetAllProgressBody =>
      'Esto eliminará todos los resultados del cuestionario (estrellas, intentos, porcentajes) y los datos de racha.\n\nTu perfil personal y la configuración de idioma NO se eliminarán.\nEsta acción no se puede deshacer.';

  @override
  String get allProgressResetDone => 'Todo el progreso ha sido restablecido.';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonReset => 'Restablecer';

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
    return '$field actualizado';
  }

  @override
  String get reportTitle => 'Informe de rendimiento del cuestionario';

  @override
  String get reportNameLabel => 'Nombre';

  @override
  String get reportEmailLabel => 'Correo electrónico';

  @override
  String get reportGeneratedLabel => 'Generado';

  @override
  String get reportColTopic => 'Tema';

  @override
  String get reportColBestPct => 'Mejor %';

  @override
  String get reportColStars => 'Estrellas';

  @override
  String get reportColBestCt => 'Mejor (c/t)';

  @override
  String get reportColDate => 'Fecha';

  @override
  String moduleTitle({required String number, required String name}) {
    return 'Módulo $number: $name';
  }

  @override
  String topicTitle({required String name}) {
    return '$name';
  }

  @override
  String get earnMoreStars => '¡Gana más estrellas para desbloquear!';

  @override
  String starsProgress({required String have, required String need}) {
    return '$have/$need';
  }

  @override
  String starsLeft({required num count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltan # estrellas',
      one: 'Falta # estrella',
      zero: 'Desbloqueado',
    );
    return '$_temp0';
  }

  @override
  String get summaryModuleTitle => 'Resumen del módulo';

  @override
  String summaryTopicTitle({required Object number}) {
    return 'Resumen del tema $number';
  }

  @override
  String get noPreviousScore => 'Sin puntuación previa';

  @override
  String lastBestScore({required Object score, required Object total}) {
    return 'Mejor puntuación anterior: $score/$total';
  }

  @override
  String dateLabel({required Object date}) {
    return 'Fecha: $date';
  }

  @override
  String get startQuiz => 'Iniciar cuestionario';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get backTooltip => 'Volver';

  @override
  String get performanceOverview => 'Resumen general';

  @override
  String get badgesTitle => 'Insignias';

  @override
  String get achievementsTitle => 'Logros';

  @override
  String get reviewAll => 'ver todo';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String streakDays({required String days}) {
    return 'Racha de $days días';
  }

  @override
  String badgesCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count insignias',
      one: '1 insignia',
      zero: 'Sin insignias',
    );
    return '$_temp0';
  }

  @override
  String achievementsCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count logros',
      one: '1 logro',
      zero: 'Sin logros',
    );
    return '$_temp0';
  }

  @override
  String badgeGenericTitle({required String number}) {
    return 'Logro $number';
  }

  @override
  String get badgeDateLabel => 'Fecha';

  @override
  String get achStreak2days => 'Racha de 2 días';

  @override
  String get achStreak5days => 'Racha de 5 días';

  @override
  String get achStreak7days => 'Racha de 7 días';

  @override
  String get achProfileUpdated => 'Perfil actualizado';

  @override
  String get achExportedOnce => 'Resultados exportados una vez';

  @override
  String get badgeAllTopicsAnyScore => 'Todos los temas intentados';

  @override
  String get badgeAllTopicsAtLeast2Stars => 'Al menos 2★ en todos los temas';

  @override
  String get badgeAllTopics3Stars => '3★ en todos los temas';

  @override
  String badgeTopicThreeStars({required String topic}) {
    return '$topic – 3★';
  }

  @override
  String get achStreak2daysDesc => 'Inicia sesión dos días consecutivos.';

  @override
  String get achStreak5daysDesc => 'Inicia sesión cinco días consecutivos.';

  @override
  String get achStreak7daysDesc => 'Inicia sesión siete días consecutivos.';

  @override
  String get achProfileUpdatedDesc => 'Actualiza la información de tu perfil.';

  @override
  String get achExportedOnceDesc => 'Exporta tus resultados al menos una vez.';

  @override
  String get newAwardsTitle => '¡Nuevas recompensas desbloqueadas!';

  @override
  String get newAchievementsTitle => 'Logros';

  @override
  String get newBadgesTitle => 'Insignias';

  @override
  String get okGotIt => 'Entendido';

  @override
  String badgeTopicThreeStarsDesc({required String topic}) {
    return 'Consigue 3 estrellas en el tema $topic.';
  }

  @override
  String get badgeAllTopicsAnyScoreDesc =>
      'Intenta todos los temas del cuestionario al menos una vez.';

  @override
  String get badgeAllTopicsAtLeast2StarsDesc =>
      'Consigue al menos 2 estrellas en todos los temas.';

  @override
  String get badgeAllTopics3StarsDesc =>
      'Consigue 3 estrellas en todos los temas.';

  @override
  String get keepPlayingToUnlock =>
      '¡Sigue jugando para desbloquear más recompensas!';

  @override
  String get summaryLabel => 'Resumen';

  @override
  String topicsProgressLabel({required String done, required String total}) {
    return '$done/$total temas';
  }

  @override
  String get warningTitle => 'Aviso';

  @override
  String get quizExitWarning =>
      '¿Seguro que quieres salir del cuestionario? Perderás el progreso actual.';

  @override
  String get yesExit => 'Sí, salir';

  @override
  String get continueQuiz => 'Continuar cuestionario';

  @override
  String get question => 'Pregunta';

  @override
  String get check => 'Comprobar';

  @override
  String get successes => 'Aciertos';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get freeTextHint => 'Escribe tu respuesta aquí';
}
