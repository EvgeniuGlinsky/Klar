import 'package:equatable/equatable.dart';
import 'package:klar/core/time/local_date.dart';

enum RecurrenceFrequency { daily, weekly, monthly, yearly }

/// A repeat rule anchored to a fixed date.
///
/// Occurrences never come before [anchor]. Weekly rules repeat on [weekdays] (1 = Monday … 7 = Sunday)
/// every [interval] weeks counted from the anchor's week. Monthly and yearly rules repeat on the
/// anchor's day of month, clamped to the last day of shorter months.
class RecurrenceRule extends Equatable {
  RecurrenceRule({
    required this.frequency,
    required this.anchor,
    this.interval = 1,
    Set<int> weekdays = const {},
    this.until,
  }) : assert(interval >= 1),
       weekdays = frequency == RecurrenceFrequency.weekly && weekdays.isEmpty ? {anchor.weekday} : weekdays;

  factory RecurrenceRule.fromJson(Map<String, Object?> json) => RecurrenceRule(
    frequency: RecurrenceFrequency.values.byName(json['freq']! as String),
    anchor: LocalDate.parse(json['anchor']! as String),
    interval: json['interval'] as int? ?? 1,
    weekdays: {...?(json['weekdays'] as List<Object?>?)?.cast<int>()},
    until: switch (json['until']) {
      final String until => LocalDate.parse(until),
      _ => null,
    },
  );

  static const weekdaysOnly = {1, 2, 3, 4, 5};

  final RecurrenceFrequency frequency;
  final LocalDate anchor;
  final int interval;
  final Set<int> weekdays;
  final LocalDate? until;

  bool get isWorkdays =>
      frequency == RecurrenceFrequency.weekly &&
      interval == 1 &&
      weekdays.length == 5 &&
      weekdays.containsAll(weekdaysOnly);

  /// The first occurrence on or after [date], or `null` if the rule has ended.
  LocalDate? firstOnOrAfter(LocalDate date) {
    final from = LocalDate.max(date, anchor);
    final candidate = switch (frequency) {
      RecurrenceFrequency.daily => _dailyFrom(from),
      RecurrenceFrequency.weekly => _weeklyFrom(from),
      RecurrenceFrequency.monthly => _monthlyFrom(from, interval),
      RecurrenceFrequency.yearly => _monthlyFrom(from, interval * 12),
    };
    final end = until;
    return end != null && candidate.isAfter(end) ? null : candidate;
  }

  /// The first occurrence strictly after [date].
  LocalDate? nextAfter(LocalDate date) => firstOnOrAfter(date.addDays(1));

  bool occursOn(LocalDate date) => firstOnOrAfter(date) == date;

  /// Occurrences in `[from, to]`, at most [limit] of them.
  Iterable<LocalDate> occurrencesBetween(LocalDate from, LocalDate to, {int limit = 1000}) sync* {
    var next = firstOnOrAfter(from);
    var count = 0;
    while (next != null && !next.isAfter(to) && count < limit) {
      yield next;
      count++;
      next = nextAfter(next);
    }
  }

  /// The same rule re-anchored at [date], keeping its shape.
  RecurrenceRule anchoredAt(LocalDate date) => RecurrenceRule(
    frequency: frequency,
    anchor: date,
    interval: interval,
    weekdays: frequency == RecurrenceFrequency.weekly ? weekdays : const {},
    until: until,
  );

  LocalDate _dailyFrom(LocalDate from) {
    final remainder = anchor.daysUntil(from) % interval;
    return remainder == 0 ? from : from.addDays(interval - remainder);
  }

  LocalDate _weeklyFrom(LocalDate from) {
    final anchorWeek = anchor.weekStart;
    var date = from;
    // Two full cycles always contain a matching day.
    for (var i = 0; i < 7 * interval * 2 + 7; i++) {
      final weekIndex = anchorWeek.daysUntil(date.weekStart) ~/ 7;
      if (weekIndex % interval == 0 && weekdays.contains(date.weekday)) return date;
      date = date.addDays(1);
    }
    throw StateError('Weekly rule without weekdays');
  }

  LocalDate _monthlyFrom(LocalDate from, int stepMonths) {
    final monthsDiff = (from.year - anchor.year) * 12 + (from.month - anchor.month);
    var k = monthsDiff <= 0 ? 0 : monthsDiff ~/ stepMonths;
    while (true) {
      final candidate = anchor.addMonths(k * stepMonths, preferredDay: anchor.day);
      if (!candidate.isBefore(from)) return candidate;
      k++;
    }
  }

  RecurrenceRule copyWith({
    RecurrenceFrequency? frequency,
    LocalDate? anchor,
    int? interval,
    Set<int>? weekdays,
    LocalDate? Function()? until,
  }) => RecurrenceRule(
    frequency: frequency ?? this.frequency,
    anchor: anchor ?? this.anchor,
    interval: interval ?? this.interval,
    weekdays: weekdays ?? this.weekdays,
    until: until != null ? until() : this.until,
  );

  Map<String, Object?> toJson() => {
    'freq': frequency.name,
    'anchor': anchor.iso,
    'interval': interval,
    if (frequency == RecurrenceFrequency.weekly) 'weekdays': (weekdays.toList()..sort()),
    if (until != null) 'until': until!.iso,
  };

  @override
  List<Object?> get props => [frequency, anchor, interval, (weekdays.toList()..sort()).join(','), until];
}
