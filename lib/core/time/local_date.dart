import 'package:equatable/equatable.dart';

/// A calendar date without a time or a time zone.
///
/// Arithmetic is done on UTC [DateTime]s so it is never affected by DST.
class LocalDate extends Equatable implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day);

  factory LocalDate.fromDateTime(DateTime dateTime) => LocalDate(dateTime.year, dateTime.month, dateTime.day);

  factory LocalDate.fromEpochDay(int epochDay) =>
      LocalDate.fromDateTime(DateTime.utc(1970).add(Duration(days: epochDay)));

  /// Parses `yyyy-MM-dd`.
  factory LocalDate.parse(String iso) {
    final parts = iso.split('-');
    return LocalDate(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  final int year;
  final int month;
  final int day;

  DateTime get _utc => DateTime.utc(year, month, day);

  int get epochDay => _utc.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;

  /// 1 = Monday … 7 = Sunday.
  int get weekday => _utc.weekday;

  LocalDate addDays(int days) => LocalDate.fromEpochDay(epochDay + days);

  /// Adds [months], clamping the day to the last day of the resulting month.
  LocalDate addMonths(int months, {int? preferredDay}) {
    final total = year * 12 + (month - 1) + months;
    final y = total ~/ 12;
    final m = total % 12 + 1;
    final d = preferredDay ?? day;
    final last = daysInMonth(y, m);
    return LocalDate(y, m, d > last ? last : d);
  }

  int daysUntil(LocalDate other) => other.epochDay - epochDay;

  /// Monday of the week containing this date.
  LocalDate get weekStart => addDays(1 - weekday);

  bool isBefore(LocalDate other) => compareTo(other) < 0;

  bool isAfter(LocalDate other) => compareTo(other) > 0;

  /// Local midnight of this date, or [minutes] after it.
  DateTime toDateTime([int minutes = 0]) => DateTime(year, month, day, 0, minutes);

  String get iso => '${_pad(year, 4)}-${_pad(month, 2)}-${_pad(day, 2)}';

  static int daysInMonth(int year, int month) => DateTime.utc(year, month + 1, 0).day;

  static LocalDate max(LocalDate a, LocalDate b) => a.isAfter(b) ? a : b;

  static String _pad(int value, int width) => value.toString().padLeft(width, '0');

  @override
  int compareTo(LocalDate other) => epochDay.compareTo(other.epochDay);

  @override
  List<Object?> get props => [year, month, day];

  @override
  String toString() => iso;
}
