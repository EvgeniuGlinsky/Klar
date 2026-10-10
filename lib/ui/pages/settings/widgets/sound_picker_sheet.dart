import 'package:flutter/material.dart';
import 'package:klar/di/app_dependencies.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/widgets/klar_row.dart';
import 'package:klar/ui/widgets/klar_sheet.dart';
import 'package:klar/ui/widgets/section_header.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// What the user chose; `sound == null` means "as in settings".
class SoundSelection {
  const SoundSelection(this.sound);

  final SoundRef? sound;
}

String soundTitle(L10n l10n, SoundRef? sound) => switch (sound?.type) {
  null => l10n.asInSettings,
  SoundType.system => l10n.soundSystemDefault,
  SoundType.silent => l10n.soundSilent,
  _ => sound!.title,
};

Future<SoundSelection?> showSoundPicker(BuildContext context, {required SoundRef? current, bool allowDefault = false}) =>
    showKlarSheet<SoundSelection>(
      context,
      title: L10n.of(context).soundPickerTitle,
      expand: true,
      builder: (_) => _SoundPicker(current: current, allowDefault: allowDefault),
    );

class _SoundPicker extends StatefulWidget {
  const _SoundPicker({required this.current, required this.allowDefault});

  final SoundRef? current;
  final bool allowDefault;

  @override
  State<_SoundPicker> createState() => _SoundPickerState();
}

class _SoundPickerState extends State<_SoundPicker> {
  final _engine = getIt<AlarmEngine>();
  late SoundRef? _selected = widget.current;
  late SoundRef? _custom = widget.current?.type == SoundType.file ? widget.current : null;
  SoundRef? _playing;

  @override
  void dispose() {
    _engine.stopPreview();
    super.dispose();
  }

  Future<void> _select(SoundRef? sound) async {
    setState(() => _selected = sound);
    if (sound == null || sound.type == SoundType.silent || sound == _playing) {
      await _stop();
      return;
    }
    setState(() => _playing = sound);
    await _engine.previewSound(sound);
  }

  Future<void> _stop() async {
    setState(() => _playing = null);
    await _engine.stopPreview();
  }

  Future<void> _pick(Future<SoundRef?> Function() picker) async {
    await _stop();
    final sound = await picker();
    if (sound == null || !mounted) return;
    setState(() => _custom = sound);
    await _select(sound);
  }

  Widget _row(String title, SoundRef? sound, {IconData? icon}) {
    final selected = _selected == sound;
    final playable = sound != null && sound.type != SoundType.silent;
    return KlarRow(
      icon: icon,
      title: title,
      selected: selected,
      onTap: () => _select(sound),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (playable && _playing == sound)
            const Icon(PhosphorIconsLight.waveform, size: 18, color: KlarColors.birch),
          const SizedBox(width: 12),
          Icon(
            selected ? PhosphorIconsFill.checkCircle : PhosphorIconsLight.circle,
            size: 22,
            color: selected ? KlarColors.birch : KlarColors.lineStrong,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.allowDefault) _row(l10n.asInSettings, null, icon: PhosphorIconsLight.gearSix),
        SectionHeader(l10n.soundSectionKlar),
        for (final sound in SoundRef.bundled) _row(sound.title, sound, icon: PhosphorIconsLight.musicNote),
        SectionHeader(l10n.soundSectionDevice),
        _row(l10n.soundSystemDefault, SoundRef.system, icon: PhosphorIconsLight.alarm),
        if (_custom != null) _row(_custom!.title, _custom, icon: PhosphorIconsLight.fileAudio),
        KlarRow(
          icon: PhosphorIconsLight.bellRinging,
          title: l10n.soundPickSystem,
          onTap: () => _pick(_engine.pickSystemSound),
        ),
        KlarRow(icon: PhosphorIconsLight.folder, title: l10n.soundPickFile, onTap: () => _pick(_engine.pickAudioFile)),
        const Divider(height: 24),
        _row(l10n.soundSilent, SoundRef.silent, icon: PhosphorIconsLight.speakerSlash),
        Padding(
          padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 20, KlarDimens.gutter, 0),
          child: FilledButton(
            onPressed: () => Navigator.pop(context, SoundSelection(_selected)),
            child: Text(l10n.done),
          ),
        ),
      ],
    );
  }
}
