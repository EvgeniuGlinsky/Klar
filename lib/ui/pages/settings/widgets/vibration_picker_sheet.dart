import 'package:flutter/material.dart';
import 'package:klar/di/app_dependencies.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/helpers/formatters.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/widgets/klar_row.dart';
import 'package:klar/ui/widgets/klar_sheet.dart';

/// What the user chose; `pattern == null` means "as in settings".
class VibrationSelection {
  const VibrationSelection(this.pattern);

  final VibrationPattern? pattern;
}

Future<VibrationSelection?> showVibrationPicker(
  BuildContext context, {
  required VibrationPattern? current,
  bool allowDefault = false,
}) => showKlarSheet<VibrationSelection>(
  context,
  title: L10n.of(context).vibrationPickerTitle,
  builder: (_) => _VibrationPicker(current: current, allowDefault: allowDefault),
);

class _VibrationPicker extends StatefulWidget {
  const _VibrationPicker({required this.current, required this.allowDefault});

  final VibrationPattern? current;
  final bool allowDefault;

  @override
  State<_VibrationPicker> createState() => _VibrationPickerState();
}

class _VibrationPickerState extends State<_VibrationPicker> {
  final _engine = getIt<AlarmEngine>();
  late VibrationPattern? _selected = widget.current;

  @override
  void dispose() {
    _engine.stopPreview();
    super.dispose();
  }

  void _select(VibrationPattern? pattern) {
    setState(() => _selected = pattern);
    if (pattern == null) {
      _engine.stopPreview();
    } else {
      _engine.previewVibration(pattern);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    Widget row(String title, VibrationPattern? pattern) => KlarRow(
      title: title,
      icon: pattern == VibrationPattern.off ? KlarIcons.prohibit : KlarIcons.vibrate,
      selected: _selected == pattern,
      onTap: () => _select(pattern),
      trailing: Icon(
        _selected == pattern ? KlarIcons.checkCircleFill : KlarIcons.circle,
        size: 22,
        color: _selected == pattern ? KlarColors.birch : KlarColors.lineStrong,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.allowDefault) row(l10n.asInSettings, null),
        for (final pattern in VibrationPattern.values) row(formatVibration(l10n, pattern), pattern),
        Padding(
          padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 20, KlarDimens.gutter, 0),
          child: FilledButton(
            onPressed: () => Navigator.pop(context, VibrationSelection(_selected)),
            child: Text(l10n.done),
          ),
        ),
      ],
    );
  }
}
