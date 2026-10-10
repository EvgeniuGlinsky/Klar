import 'package:flutter/material.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/helpers/formatters.dart';
import 'package:klar/ui/pages/task_editor/widgets/date_sheet.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';
import 'package:klar/ui/widgets/klar_choices.dart';
import 'package:klar/ui/widgets/klar_row.dart';
import 'package:klar/ui/widgets/klar_sheet.dart';

/// Result of the repeat sheet; `rule == null` turns repeating off.
class RepeatChoice {
  const RepeatChoice(this.rule);

  final RecurrenceRule? rule;
}

Future<RepeatChoice?> showRepeatSheet(
  BuildContext context, {
  required LocalDate anchor,
  RecurrenceRule? current,
}) async {
  final l10n = L10n.of(context);
  final weekday = weekdayNames()[anchor.weekday - 1];
  final presets = <(String, RecurrenceRule?)>[
    (l10n.repeatNone, null),
    (l10n.repeatDaily, RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: anchor)),
    (
      l10n.repeatWorkdays,
      RecurrenceRule(frequency: RecurrenceFrequency.weekly, anchor: anchor, weekdays: RecurrenceRule.weekdaysOnly),
    ),
    ('${l10n.repeatWeekly} · $weekday', RecurrenceRule(frequency: RecurrenceFrequency.weekly, anchor: anchor)),
    ('${l10n.repeatMonthly} · ${anchor.day}', RecurrenceRule(frequency: RecurrenceFrequency.monthly, anchor: anchor)),
    (
      '${l10n.repeatYearly} · ${formatShortDate(anchor)}',
      RecurrenceRule(frequency: RecurrenceFrequency.yearly, anchor: anchor),
    ),
  ];
  final isPreset = current == null || presets.any((p) => p.$2 == current.anchoredAt(anchor));

  final choice = await showKlarSheet<Object>(
    context,
    title: l10n.fieldRepeat,
    builder: (context) => Column(
      children: [
        for (final (label, rule) in presets)
          KlarRow(
            title: label,
            selected: isPreset && rule == current?.anchoredAt(anchor),
            trailing: isPreset && rule == current?.anchoredAt(anchor)
                ? const Icon(KlarIcons.check, size: 18, color: KlarColors.birch)
                : null,
            onTap: () => Navigator.pop(context, RepeatChoice(rule)),
          ),
        KlarRow(
          title: isPreset ? l10n.repeatCustom : formatRecurrence(l10n, current),
          selected: !isPreset,
          trailing: const Icon(KlarIcons.caretRight, size: 16, color: KlarColors.textFaint),
          onTap: () => Navigator.pop(context, 'custom'),
        ),
      ],
    ),
  );
  if (choice is RepeatChoice?) return choice;
  if (!context.mounted) return null;
  final custom = await showKlarSheet<RecurrenceRule>(
    context,
    title: l10n.fieldRepeat,
    builder: (_) => _CustomRepeat(
      initial: current?.anchoredAt(anchor) ?? RecurrenceRule(frequency: RecurrenceFrequency.weekly, anchor: anchor),
    ),
  );
  return custom == null ? null : RepeatChoice(custom);
}

class _CustomRepeat extends StatefulWidget {
  const _CustomRepeat({required this.initial});

  final RecurrenceRule initial;

  @override
  State<_CustomRepeat> createState() => _CustomRepeatState();
}

class _CustomRepeatState extends State<_CustomRepeat> {
  late RecurrenceRule _rule = widget.initial;

  void _set(RecurrenceRule rule) => setState(() => _rule = rule);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final names = weekdayNames();
    final units = {
      RecurrenceFrequency.daily: l10n.repeatUnitDay,
      RecurrenceFrequency.weekly: l10n.repeatUnitWeek,
      RecurrenceFrequency.monthly: l10n.repeatUnitMonth,
      RecurrenceFrequency.yearly: l10n.repeatUnitYear,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: KlarDimens.gutter),
          child: Text(formatRecurrence(l10n, _rule), style: KlarTypography.body.copyWith(color: KlarColors.birch)),
        ),
        const SizedBox(height: 20),
        KlarChoices(
          values: units.keys.toList(),
          selected: _rule.frequency,
          label: (f) => units[f]!,
          onSelected: (f) => _set(
            RecurrenceRule(frequency: f, anchor: _rule.anchor, interval: _rule.interval, until: _rule.until),
          ),
        ),
        const SizedBox(height: 16),
        KlarRow(
          title: l10n.repeatInterval,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _rule.interval > 1 ? () => _set(_rule.copyWith(interval: _rule.interval - 1)) : null,
                icon: const Icon(KlarIcons.minus, size: 18),
              ),
              SizedBox(
                width: 32,
                child: Text('${_rule.interval}', textAlign: TextAlign.center, style: KlarTypography.title),
              ),
              IconButton(
                onPressed: _rule.interval < 99 ? () => _set(_rule.copyWith(interval: _rule.interval + 1)) : null,
                icon: const Icon(KlarIcons.plus, size: 18),
              ),
            ],
          ),
        ),
        if (_rule.frequency == RecurrenceFrequency.weekly) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 12, KlarDimens.gutter, 10),
            child: Text(l10n.repeatOnDays.toUpperCase(), style: KlarTypography.label),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: KlarDimens.gutter - 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var day = 1; day <= 7; day++)
                  _DayToggle(
                    label: names[day - 1],
                    selected: _rule.weekdays.contains(day),
                    onTap: () {
                      final days = {..._rule.weekdays};
                      if (!days.remove(day)) days.add(day);
                      if (days.isNotEmpty) _set(_rule.copyWith(weekdays: days));
                    },
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        KlarRow(
          title: l10n.repeatEnds,
          value: _rule.until == null ? l10n.repeatEndsNever : formatShortDate(_rule.until!),
          trailing: _rule.until == null
              ? null
              : IconButton(
                  onPressed: () => _set(_rule.copyWith(until: () => null)),
                  icon: const Icon(KlarIcons.x, size: 16),
                ),
          onTap: () async {
            final until = await pickDate(
              context,
              initial: _rule.until ?? _rule.anchor.addMonths(1),
              first: _rule.anchor,
            );
            if (until != null) _set(_rule.copyWith(until: () => until));
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 20, KlarDimens.gutter, 0),
          child: FilledButton(onPressed: () => Navigator.pop(context, _rule), child: Text(l10n.done)),
        ),
      ],
    );
  }
}

class _DayToggle extends StatelessWidget {
  const _DayToggle({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? KlarColors.birch : Colors.transparent,
        border: Border.all(color: selected ? KlarColors.birch : KlarColors.lineStrong),
      ),
      child: Text(
        label,
        style: KlarTypography.meta.copyWith(color: selected ? KlarColors.onAccent : KlarColors.text),
      ),
    ),
  );
}
