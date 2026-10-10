import 'package:flutter/material.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/helpers/formatters.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/widgets/klar_row.dart';
import 'package:klar/ui/widgets/klar_sheet.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Result of the date sheet: `null` when dismissed, [DateChoice.none] to clear the date.
class DateChoice {
  const DateChoice(this.date);

  static const none = DateChoice(null);

  final LocalDate? date;
}

Future<DateChoice?> showDateSheet(BuildContext context, {required LocalDate today, LocalDate? current}) async {
  final l10n = L10n.of(context);
  final options = [
    (l10n.today, today, PhosphorIconsLight.sun),
    (l10n.tomorrow, today.addDays(1), PhosphorIconsLight.sunHorizon),
    (l10n.dateNextWeek, today.addDays(7), PhosphorIconsLight.calendarPlus),
  ];
  final choice = await showKlarSheet<Object>(
    context,
    title: l10n.fieldDate,
    builder: (context) => Column(
      children: [
        for (final (label, date, icon) in options)
          KlarRow(
            icon: icon,
            title: label,
            value: formatShortDate(date),
            selected: current == date,
            onTap: () => Navigator.pop(context, DateChoice(date)),
          ),
        KlarRow(
          icon: PhosphorIconsLight.calendarBlank,
          title: l10n.datePick,
          onTap: () => Navigator.pop(context, 'pick'),
        ),
        if (current != null)
          KlarRow(
            icon: PhosphorIconsLight.x,
            iconColor: KlarColors.lingon,
            title: l10n.dateClear,
            onTap: () => Navigator.pop(context, DateChoice.none),
          ),
      ],
    ),
  );
  if (choice is DateChoice?) return choice;
  if (!context.mounted) return null;
  final picked = await pickDate(context, initial: current ?? today, first: today.addDays(-365));
  return picked == null ? null : DateChoice(picked);
}

Future<LocalDate?> pickDate(BuildContext context, {required LocalDate initial, required LocalDate first}) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: initial.toDateTime(),
    firstDate: (initial.isBefore(first) ? initial : first).toDateTime(),
    lastDate: DateTime(initial.year + 10),
    locale: const Locale('ru'),
  );
  return picked == null ? null : LocalDate.fromDateTime(picked);
}

Future<int?> pickTime(BuildContext context, {int? initial}) async {
  final minutes = initial ?? 9 * 60;
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    builder: (context, child) =>
        MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
  );
  return picked == null ? null : picked.hour * 60 + picked.minute;
}
