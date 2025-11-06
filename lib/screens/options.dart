// lib/screens/options.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:quiz/data/achievements_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quiz/widgets/aqua_pill_button.dart';
import 'package:quiz/design/app_colors.dart';
import 'package:quiz/design/app_assets.dart';
import 'package:quiz/l10n/app_localizations.dart';
import 'package:quiz/widgets/aqua_bottom_nav.dart';
import 'package:quiz/data/progress_service.dart';
import 'package:quiz/data/user_profile_service.dart';
import 'package:quiz/data/content_repository.dart';
import 'package:quiz/data/models.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:quiz/data/achievements_service.dart';
import 'package:quiz/core/app_locale.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});
  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  final _progress = ProgressService();
  final _profileSvc = UserProfileService();
  final _picker = ImagePicker();
  final _contentRepo = ContentRepository();

  String _name = 'User';
  String _surname = 'User';
  String _email = 'User@user.com';
  Uint8List? _avatar;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await _profileSvc.load();
    setState(() {
      _name = p.name;
      _surname = p.surname;
      _email = p.email;
      _avatar = p.avatarBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F4FF),
        elevation: 0,
        centerTitle: true,
        title: const SizedBox.shrink(),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const AquaBottomNav(current: AquaTab.options),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
          children: [
            // Avatar con badge "+"
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: _avatar == null
                          ? Image.asset(
                              AppIcons
                                  .add_image, // ícono de usuario redondo en tus assets
                              fit: BoxFit.cover,
                            )
                          : Image.memory(_avatar!, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _pickAvatar,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.lightBlue,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            _EditableLine(
              label: t.profileNameLabel,
              value: _name,
              onEdit: () => _editField(
                titleLabel: t.profileNameLabel,
                initial: _name,
                onSaved: (v) async {
                  setState(() => _name = v);
                  await _saveProfile();
                },
              ),
            ),
            const SizedBox(height: 10),

            _EditableLine(
              label: t.profileSurnameLabel,
              value: _surname,
              onEdit: () => _editField(
                titleLabel: t.profileSurnameLabel,
                initial: _surname,
                onSaved: (v) async {
                  setState(() => _surname = v);
                  await _saveProfile();
                },
              ),
            ),
            const SizedBox(height: 10),

            _EditableLine(
              label: t.profileEmailLabel,
              value: _email,
              onEdit: () => _editField(
                titleLabel: t.profileEmailLabel,
                initial: _email,
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) async {
                  setState(() => _email = v);
                  await _saveProfile();
                },
              ),
            ),

            const SizedBox(height: 12),
            const Divider(thickness: 2, color: Color(0xFF5B3ECC)),
            const SizedBox(height: 14),

            AquaPillButton(
              label: t.changeLanguage, // 🔤 traducible
              onPressed: _openLanguageSheet,
              backgroundColor: AppColors.green,
              textColor: AppColors.darkBlue,
              borderColor: const Color(0xFF5B3ECC),
            ),
            const SizedBox(height: 18),

            AquaPillButton(
              label: t.exportResults, // 🔤 traducible
              onPressed: _exportResults,
              backgroundColor: AppColors.green,
              textColor: AppColors.darkBlue,
              borderColor: const Color(0xFF5B3ECC),
            ),
            const SizedBox(height: 18),

            AquaPillButton(
              label: t.resetProgress, // 🔤 traducible
              onPressed: _confirmReset,
              backgroundColor: const Color(0xFFFF6B6B),
              textColor: Colors.white,
              borderColor: const Color(0xFF5B3ECC),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Actions ----------

  Future<void> _pickAvatar() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 90,
    );
    if (x == null) return;
    final bytes = await x.readAsBytes();
    setState(() => _avatar = bytes);
    await _saveProfile();
  }

  Future<void> _saveProfile() async {
    await _profileSvc.save(
      UserProfile(
        name: _name,
        surname: _surname,
        email: _email,
        avatarBytes: _avatar,
      ),
    );
    final ach = AchievementsService();
    final bundle = await _contentRepo.load();
    final module = bundle.modules.firstWhere(
      (m) => m.id == 'm2',
      orElse: () => bundle.modules.first,
    );
    final topics = module.topicIds
        .map((tid) => bundle.topics.firstWhere((t) => t.id == tid))
        .toList();
    final strings = await ContentStrings.loadForLocale(
      Localizations.localeOf(context),
    );

    // 👇 marca logro de “perfil actualizado”
    await AchievementsService().markProfileUpdatedAndCheck(
      context: context,
      module: module,
      topics: topics,
      strings: strings,
    );
  }

  Future<void> _openLanguageSheet() async {
    if (!mounted) return;

    // Autónimos (nombre en su propio idioma) + banderas
    const langs = <_LangOption>[
      _LangOption(
        code: 'en',
        nativeName: 'English',
        flagPath: AppIcons.en_flag,
      ),
      _LangOption(
        code: 'es',
        nativeName: 'Español',
        flagPath: AppIcons.es_flag,
      ),
      _LangOption(
        code: 'it',
        nativeName: 'Italiano',
        flagPath: AppIcons.it_flag,
      ),
      _LangOption(
        code: 'el',
        nativeName: 'Ελληνικά',
        flagPath: AppIcons.el_flag,
      ),
      _LangOption(code: 'tr', nativeName: 'Türkçe', flagPath: AppIcons.tr_flag),
      _LangOption(
        code: 'fr',
        nativeName: 'Français',
        flagPath: AppIcons.fr_flag,
      ),
      _LangOption(
        code: 'pt',
        nativeName: 'Português',
        flagPath: AppIcons.pt_flag,
      ),
    ];

    final currentCode = Localizations.localeOf(
      context,
    ).languageCode.toLowerCase();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final l in langs)
                _LangTile(
                  code: l.code,
                  name: l.nativeName, // 👈 nombre nativo, no traducido
                  flagPath: l.flagPath,
                  isCurrent: l.code == currentCode,
                  onTap: () => _pickLang(l.code),
                ),
            ],
          ),
        );
      },
    );
  }

  void _pickLang(String code) {
    // cierra el bottom sheet
    Navigator.pop(context);

    // intenta con el contexto actual…
    AppLocaleController? ctrl = AppLocaleScope.maybeOf(context);
    // …o con el rootNavigator (por si el bottom sheet está en otro árbol)
    ctrl ??= AppLocaleScope.maybeOf(
      Navigator.of(context, rootNavigator: true).context,
    );

    if (ctrl == null) {
      // Si ves este SnackBar, es que RootApp NO está montado (o no reiniciaste la app).
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Language controller not found. Is RootApp mounted?'),
        ),
      );
      return;
    }

    ctrl.setLocale(Locale(code)); // ✅ cambia idioma

    final t = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.languageSetTo(code: code.toUpperCase()))),
    );
    // No necesitas setState(); el cambio de locale rehace el árbol
  }

  Future<void> _exportResults() async {
    // 1) Perfil y contenido
    final profile = await _profileSvc.load();
    final bundle = await _contentRepo.load();

    // Localización de strings de contenido (para títulos de topics)
    final locale = Localizations.localeOf(context);
    final strings = await ContentStrings.loadForLocale(locale);

    // Selecciona tu módulo principal (ajusta si usas varios)
    final Module module = bundle.modules.firstWhere(
      (m) => m.id == 'm2',
      orElse: () => bundle.modules.first,
    );

    final List<Topic> topics = module.topicIds
        .map((tid) => bundle.topics.firstWhere((t) => t.id == tid))
        .toList();

    // 2) Construcción de PDF con fuentes Roboto
    final fontRegular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    final fontBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );

    final pdf = pw.Document();

    pw.Widget avatar() {
      if (profile.avatarBytes == null) return pw.SizedBox();
      final img = pw.MemoryImage(profile.avatarBytes!);
      return pw.Container(
        width: 80,
        height: 80,
        decoration: const pw.BoxDecoration(shape: pw.BoxShape.circle),
        child: pw.Image(img, fit: pw.BoxFit.cover),
      );
    }

    final t = AppLocalizations.of(context)!;

    final header = pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        avatar(),
        pw.SizedBox(width: 16),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              t.reportTitle, // "Quiz Performance Report" ✅
              style: pw.TextStyle(font: fontBold, fontSize: 18),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '${t.reportNameLabel}: ${profile.name} ${profile.surname}', // ✅
              style: pw.TextStyle(font: fontRegular),
            ),
            pw.Text(
              '${t.reportEmailLabel}: ${profile.email}', // ✅
              style: pw.TextStyle(font: fontRegular),
            ),
            pw.Text(
              '${t.reportGeneratedLabel}: ${DateTime.now().toIso8601String().split("T").first}', // ✅
              style: pw.TextStyle(font: fontRegular),
            ),
          ],
        ),
      ],
    );

    final rows = <pw.TableRow>[
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE0E0E0)),
        children: [
          _cell(t.reportColTopic, bold: true, font: fontBold),
          _cell(t.reportColBestPct, bold: true, font: fontBold),
          _cell(t.reportColStars, bold: true, font: fontBold),
          _cell(t.reportColBestCt, bold: true, font: fontBold),
          _cell(t.reportColDate, bold: true, font: fontBold),
        ],
      ),
    ];

    for (final t in topics) {
      final pct = await _progress.getBestPct(module.id, t.id);
      final stars = await _progress.getBestStars(module.id, t.id);
      final (c, tot) = await _progress.getBestRaw(module.id, t.id);
      final date = await _progress.getBestDate(module.id, t.id);

      rows.add(
        pw.TableRow(
          children: [
            _cell(strings.t(t.titleKey), font: fontRegular),
            _cell(pct.toStringAsFixed(1), font: fontRegular),
            _cell('$stars', font: fontRegular),
            _cell(
              (c == null || tot == null) ? '-' : '$c/$tot',
              font: fontRegular,
            ),
            _cell(
              date == null ? '-' : date.toIso8601String().split('T').first,
              font: fontRegular,
            ),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 36),
        build: (_) => [
          header,
          pw.SizedBox(height: 16),
          pw.Divider(),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(
              color: const PdfColor.fromInt(0xFFBDBDBD),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.4),
              4: const pw.FlexColumnWidth(1.6),
            },
            children: rows,
          ),
        ],
      ),
    );

    // 3) Compartir/guardar (share sheet nativo)
    final bytes = await pdf.save();
    final fileName =
        'AQUATECHinn4.0_Results_${DateTime.now().millisecondsSinceEpoch}.pdf';
    await Printing.sharePdf(bytes: bytes, filename: fileName);

    // marca logro de “exportado una vez”
    await AchievementsService().markExportedOnce();

    // recomputa badges/achievements por si cambia algo más
    await AchievementsService().checkForUpdates(
      context: context,
      module: module,
      topics: topics,
      strings: strings,
    );
  }

  pw.Widget _cell(String text, {bool bold = false, required pw.Font font}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset all progress?'),
        content: const Text(
          'This will delete all quiz results (stars, attempts, percentages) and streak data.\n\n'
          'Your personal profile and language settings will NOT be deleted.\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    // 1️⃣ Borra todo el progreso de cuestionarios y rachas
    await _progress.clearAllProgressData();

    // 2️⃣ Borra también logros e insignias, si los usas
    final ach = AchievementsService();
    await ach.clearAll();

    // 3️⃣ Muestra confirmación
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All progress has been reset.')),
    );

    // 4️⃣ Recarga la pantalla de Questionnaire para reflejar los cambios
    //    (opcional, si prefieres solo setState() puedes dejarlo así)
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/questionnaire');
  }

  Future<void> _editField({
    required String titleLabel, // ✅ ahora recibimos etiqueta localizada
    required String initial,
    TextInputType? keyboardType,
    required Future<void> Function(String value) onSaved,
  }) async {
    final t = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: initial);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.editFieldTitle(field: titleLabel)), // ✅ "Edit Name", etc.
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: titleLabel, // ✅
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.commonCancel), // ✅
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.commonSave), // ✅
          ),
        ],
      ),
    );
    if (saved == true) {
      await onSaved(controller.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.fieldUpdated(field: titleLabel))), // ✅
      );
    }
  }
}

// ===== Widgets auxiliares =====

class _EditableLine extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _EditableLine({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF4C2DBB);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Etiqueta fija con separación
          Flexible(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          const SizedBox(width: 6),

          // Valor: elipsis si no cabe
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: const TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),

          // Botón de edición
          IconButton(
            icon: const Icon(Icons.edit, color: color, size: 20),
            tooltip: 'Edit',
            onPressed: onEdit,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _LangOption {
  final String code;
  final String nativeName;
  final String flagPath;
  const _LangOption({
    required this.code,
    required this.nativeName,
    required this.flagPath,
  });
}

class _LangTile extends StatelessWidget {
  final String code;
  final String name; // nombre nativo
  final String flagPath;
  final VoidCallback onTap;
  final bool isCurrent;

  const _LangTile({
    required this.code,
    required this.name,
    required this.flagPath,
    required this.onTap,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AppIcon(flagPath, size: 32),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCurrent)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.check, size: 18, color: Colors.green),
            ),
          Text(code.toUpperCase(), style: const TextStyle(color: Colors.grey)),
        ],
      ),
      onTap: onTap,
    );
  }
}
