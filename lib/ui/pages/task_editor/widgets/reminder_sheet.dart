import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/helpers/formatters.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_typography.dart';
import 'package:klar/ui/widgets/klar_choices.dart';
import 'package:klar/ui/widgets/klar_sheet.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

typedef ReminderDraft = ({int offsetMinutes, ReminderKind kind});

Future<ReminderDraft?> showReminderSheet(
  BuildContext context, {
  required bool allDay,
  required int allDayMinutes,
  Reminder? current,
}) => showKlarSheet<ReminderDraft>(
  context,
  title: L10n.of(context).fieldReminders,
  builder: (_) => _ReminderForm(allDay: allDay, allDayMinutes: allDayMinutes, current: current),
);

class _ReminderForm extends StatefulWidget {
  const _ReminderForm({required this.allDay, required this.allDayMinutes, this.current});

  final bool allDay;
  final int allDayMinutes;
  final Reminder? current;

  @override
  State<_ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<_ReminderForm> {
  late int _offset = widget.current?.offsetMinutes ?? 0;
  late ReminderKind _kind = widget.current?.kind ?? ReminderKind.alarm;

  List<int> get _presets => widget.allDay ? const [0, 1440, 2880] : Reminder.presetOffsets;

  Future<void> _custom() async {
    final l10n = L10n.of(context);
    final controller = TextEditingController(text: _presets.contains(_offset) ? '' : '$_offset');
    final minutes = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reminderCustomTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(5)],
          style: KlarTypography.title,
          decoration: const InputDecoration(hintText: '45'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, int.tryParse(controller.text)),
            child: Text(l10n.done),
          ),
        ],
      ),
    );
    controller.dispose();
    if (minutes != null) setState(() => _offset = minutes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    String label(int offset) => offset == -1
        ? l10n.reminderCustom
        : formatReminder(
            l10n,
            Reminder(id: '', offsetMinutes: offset, kind: _kind),
            allDay: widget.allDay,
            allDayMinutes: widget.allDayMinutes,
          );
    final values = [..._presets, if (!_presets.contains(_offset)) _offset, -1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 0, KlarDimens.gutter, 12),
          child: Text(l10n.reminderWhen.toUpperCase(), style: KlarTypography.label),
        ),
        KlarChoices(
          values: values,
          selected: _offset,
          label: label,
          onSelected: (value) => value == -1 ? _custom() : setState(() => _offset = value),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 28, KlarDimens.gutter, 12),
          child: Text(l10n.reminderHow.toUpperCase(), style: KlarTypography.label),
        ),
        _KindOption(
          icon: PhosphorIconsLight.alarm,
          title: l10n.reminderKindAlarm,
          hint: l10n.reminderKindAlarmHint,
          selected: _kind == ReminderKind.alarm,
          onTap: () => setState(() => _kind = ReminderKind.alarm),
        ),
        const SizedBox(height: 10),
        _KindOption(
          icon: PhosphorIconsLight.bell,
          title: l10n.reminderKindNotification,
          hint: l10n.reminderKindNotificationHint,
          selected: _kind == ReminderKind.notification,
          onTap: () => setState(() => _kind = ReminderKind.notification),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 24, KlarDimens.gutter, 0),
          child: FilledButton(
            onPressed: () => Navigator.pop(context, (offsetMinutes: _offset, kind: _kind)),
            child: Text(l10n.done),
          ),
        ),
      ],
    );
  }
}

class _KindOption extends StatelessWidget {
  const _KindOption({
    required this.icon,
    required this.title,
    required this.hint,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String hint;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: KlarDimens.gutter),
    child: Material(
      color: selected ? KlarColors.surfaceRaised : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KlarDimens.radius),
        side: BorderSide(color: selected ? KlarColors.birch : KlarColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 26, color: selected ? KlarColors.birch : KlarColors.textMuted),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: KlarTypography.body),
                    const SizedBox(height: 2),
                    Text(hint, style: KlarTypography.meta),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
