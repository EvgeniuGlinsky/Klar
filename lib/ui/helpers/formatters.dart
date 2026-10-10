import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/theme/klar_colors.dart';

const _locale = 'ru';

String formatTime(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';

/// «Сегодня», «Завтра», «пт, 17 окт» or «17 окт 2027».
String formatDate(L10n l10n, LocalDate date, LocalDate today) {
  switch (today.daysUntil(date)) {
    case 0:
      return l10n.today;
    case 1:
      return l10n.tomorrow;
    case -1:
      return l10n.yesterday;
  }
  final value = date.toDateTime();
  if (date.year != today.year) return DateFormat('d MMM y', _locale).format(value);
  return DateFormat('EE, d MMM', _locale).format(value);
}

/// «пятница, 10 октября».
String formatLongDate(LocalDate date) => DateFormat('EEEE, d MMMM', _locale).format(date.toDateTime());

String formatShortDate(LocalDate date) => DateFormat('d MMM', _locale).format(date.toDateTime());

/// Short weekday names in calendar order starting from Monday: «пн» … «вс».
List<String> weekdayNames() => [
  for (var i = 0; i < 7; i++) DateFormat('EEEEEE', _locale).format(DateTime(2024, 1, 1 + i)),
];

String formatDuration(L10n l10n, int minutes) {
  if (minutes > 0 && minutes % 1440 == 0) return l10n.durationDays(minutes ~/ 1440);
  if (minutes > 0 && minutes % 60 == 0) return l10n.durationHours(minutes ~/ 60);
  return l10n.durationMinutes(minutes);
}

String formatReminder(L10n l10n, Reminder reminder, {required bool allDay, required int allDayMinutes}) {
  if (reminder.offsetMinutes == 0) {
    return allDay ? l10n.reminderAllDayAt(formatTime(allDayMinutes)) : l10n.reminderAtTime;
  }
  return l10n.reminderBefore(formatDuration(l10n, reminder.offsetMinutes));
}

String formatRecurrence(L10n l10n, RecurrenceRule rule) {
  final base = switch (rule.frequency) {
    RecurrenceFrequency.daily => rule.interval == 1 ? l10n.repeatDaily : l10n.repeatEveryDays(rule.interval),
    RecurrenceFrequency.weekly when rule.isWorkdays => l10n.repeatWorkdays,
    RecurrenceFrequency.weekly => _weekly(l10n, rule),
    RecurrenceFrequency.monthly => rule.interval == 1 ? l10n.repeatMonthly : l10n.repeatEveryMonths(rule.interval),
    RecurrenceFrequency.yearly => rule.interval == 1 ? l10n.repeatYearly : l10n.repeatEveryYears(rule.interval),
  };
  final until = rule.until;
  return until == null ? base : '$base ${l10n.repeatUntil(formatShortDate(until))}';
}

String _weekly(L10n l10n, RecurrenceRule rule) {
  final every = rule.interval == 1 ? l10n.repeatWeekly : l10n.repeatEveryWeeks(rule.interval);
  if (rule.weekdays.length == 1 && rule.weekdays.first == rule.anchor.weekday) return every;
  final names = weekdayNames();
  final days = (rule.weekdays.toList()..sort()).map((d) => names[d - 1]).join(', ');
  return '$every: $days';
}

String formatPriority(L10n l10n, Priority priority) => switch (priority) {
  Priority.none => l10n.priorityNone,
  Priority.low => l10n.priorityLow,
  Priority.medium => l10n.priorityMedium,
  Priority.high => l10n.priorityHigh,
};

Color priorityColor(Priority priority) => switch (priority) {
  Priority.none => KlarColors.lineStrong,
  Priority.low => KlarColors.fjord,
  Priority.medium => KlarColors.clay,
  Priority.high => KlarColors.lingon,
};

String formatVibration(L10n l10n, VibrationPattern pattern) => switch (pattern) {
  VibrationPattern.off => l10n.vibrationOff,
  VibrationPattern.gentle => l10n.vibrationGentle,
  VibrationPattern.standard => l10n.vibrationStandard,
  VibrationPattern.pulse => l10n.vibrationPulse,
  VibrationPattern.heartbeat => l10n.vibrationHeartbeat,
  VibrationPattern.strong => l10n.vibrationStrong,
};
