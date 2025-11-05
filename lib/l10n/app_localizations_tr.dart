// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Aquatechinn Testi';

  @override
  String get tabQuestionnaire => 'Anket';

  @override
  String get tabPerformance => 'Performans';

  @override
  String get tabOptions => 'Ayarlar';

  @override
  String get counterFlame => 'Alev';

  @override
  String get counterEnergy => 'Enerji';

  @override
  String get counterMedals => 'Madalya';

  @override
  String get changeLanguage => 'Dili Değiştir';

  @override
  String get exportResults => 'Sonuçları Dışa Aktar';

  @override
  String get resetProgress => 'İlerlemeyi Sıfırla';

  @override
  String get profileNameLabel => 'Ad';

  @override
  String get profileSurnameLabel => 'Soyad';

  @override
  String get profileEmailLabel => 'E-posta';

  @override
  String languageSetTo({required String code}) {
    return 'Dil $code olarak ayarlandı';
  }

  @override
  String get resetAllProgressTitle =>
      'Tüm ilerlemeyi sıfırlamak istiyor musunuz?';

  @override
  String get resetAllProgressBody =>
      'Bu işlem tüm test sonuçlarını (yıldızlar, denemeler, yüzdeler) ve seri verilerini silecektir.\n\nKişisel profiliniz ve dil ayarlarınız SİLİNMEYECEKTİR.\nBu işlem geri alınamaz.';

  @override
  String get allProgressResetDone => 'Tüm ilerleme sıfırlandı.';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonReset => 'Sıfırla';

  @override
  String editFieldTitle({required String field}) {
    return '$field düzenle';
  }

  @override
  String editFieldTooltip({required String field}) {
    return '$field düzenle';
  }

  @override
  String fieldUpdated({required String field}) {
    return '$field güncellendi';
  }

  @override
  String get reportTitle => 'Test Performans Raporu';

  @override
  String get reportNameLabel => 'Ad';

  @override
  String get reportEmailLabel => 'E-posta';

  @override
  String get reportGeneratedLabel => 'Oluşturulma Tarihi';

  @override
  String get reportColTopic => 'Konu';

  @override
  String get reportColBestPct => 'En İyi %';

  @override
  String get reportColStars => 'Yıldızlar';

  @override
  String get reportColBestCt => 'En İyi (d/s)';

  @override
  String get reportColDate => 'Tarih';

  @override
  String moduleTitle({required String number, required String name}) {
    return 'Modül $number: $name';
  }

  @override
  String topicTitle({required String name}) {
    return '$name';
  }

  @override
  String get earnMoreStars => 'Kilidi açmak için daha fazla yıldız kazanın!';

  @override
  String starsProgress({required String have, required String need}) {
    return '$have/$need';
  }

  @override
  String starsLeft({required num count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# yıldız kaldı',
      one: '# yıldız kaldı',
      zero: 'Kilidi Açıldı',
    );
    return '$_temp0';
  }

  @override
  String get summaryModuleTitle => 'Modül Özeti';

  @override
  String summaryTopicTitle({required Object number}) {
    return 'Konu Özeti $number';
  }

  @override
  String get noPreviousScore => 'Önceki puan yok';

  @override
  String lastBestScore({required Object score, required Object total}) {
    return 'Son en iyi skor: $score/$total';
  }

  @override
  String dateLabel({required Object date}) {
    return 'Tarih: $date';
  }

  @override
  String get startQuiz => 'Testi başlat';

  @override
  String get tryAgain => 'Tekrar dene';

  @override
  String get backTooltip => 'Geri';

  @override
  String get performanceOverview => 'Genel Bakış';

  @override
  String get badgesTitle => 'Rozetler';

  @override
  String get achievementsTitle => 'Başarılar';

  @override
  String get reviewAll => 'tümünü incele';

  @override
  String get comingSoon => 'Yakında geliyor';

  @override
  String streakDays({required String days}) {
    return '$days Günlük Seri';
  }

  @override
  String badgesCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rozet',
      one: '1 Rozet',
      zero: 'Rozet yok',
    );
    return '$_temp0';
  }

  @override
  String achievementsCount({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Başarı',
      one: '1 Başarı',
      zero: 'Başarı yok',
    );
    return '$_temp0';
  }

  @override
  String badgeGenericTitle({required String number}) {
    return 'Başarı $number';
  }

  @override
  String get badgeDateLabel => 'Tarih';

  @override
  String get achStreak2days => '2 günlük seri';

  @override
  String get achStreak5days => '5 günlük seri';

  @override
  String get achStreak7days => '7 günlük seri';

  @override
  String get achProfileUpdated => 'Profil güncellendi';

  @override
  String get achExportedOnce => 'Sonuçlar bir kez dışa aktarıldı';

  @override
  String get badgeAllTopicsAnyScore => 'Tüm konular denendi';

  @override
  String get badgeAllTopicsAtLeast2Stars => 'Tüm konularda en az 2★';

  @override
  String get badgeAllTopics3Stars => 'Tüm konularda 3★';

  @override
  String badgeTopicThreeStars({required String topic}) {
    return '$topic – 3★';
  }

  @override
  String get achStreak2daysDesc => 'Ardışık iki gün giriş yapın.';

  @override
  String get achStreak5daysDesc => 'Ardışık beş gün giriş yapın.';

  @override
  String get achStreak7daysDesc => 'Ardışık yedi gün giriş yapın.';

  @override
  String get achProfileUpdatedDesc => 'Profil bilgilerinizi güncelleyin.';

  @override
  String get achExportedOnceDesc => 'Sonuçlarınızı en az bir kez dışa aktarın.';

  @override
  String get newAwardsTitle => 'Yeni ödüller açıldı!';

  @override
  String get newAchievementsTitle => 'Başarılar';

  @override
  String get newBadgesTitle => 'Rozetler';

  @override
  String get okGotIt => 'Tamam, anladım';

  @override
  String badgeTopicThreeStarsDesc({required String topic}) {
    return '$topic konusunda 3 yıldız kazanın.';
  }

  @override
  String get badgeAllTopicsAnyScoreDesc =>
      'Tüm test konularını en az bir kez deneyin.';

  @override
  String get badgeAllTopicsAtLeast2StarsDesc =>
      'Tüm konularda en az 2 yıldız kazanın.';

  @override
  String get badgeAllTopics3StarsDesc => 'Tüm konularda 3 yıldız kazanın.';

  @override
  String get keepPlayingToUnlock =>
      'Daha fazla ödül açmak için oynamaya devam edin!';

  @override
  String get summaryLabel => 'Özet';

  @override
  String topicsProgressLabel({required String done, required String total}) {
    return '$done/$total Konu';
  }

  @override
  String get warningTitle => 'Uyarı';

  @override
  String get quizExitWarning =>
      'Testten çıkmak istediğinizden emin misiniz? Mevcut ilerlemeniz kaybolacak.';

  @override
  String get yesExit => 'Evet, çık';

  @override
  String get continueQuiz => 'Teste devam et';

  @override
  String get question => 'Soru';

  @override
  String get check => 'Kontrol et';

  @override
  String get successes => 'Başarılar';

  @override
  String get continueLabel => 'Devam et';

  @override
  String get freeTextHint => 'Cevabınızı buraya yazın';
}
