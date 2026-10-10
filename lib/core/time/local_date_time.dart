import 'package:equatable/equatable.dart';
import 'package:klar/core/time/local_date.dart';

/// A wall-clock moment: a [LocalDate] plus minutes since midnight, without a time zone.
///
/// The native alarm engine converts it to an instant with the device's current zone at arming time,
/// so time-zone and DST changes are handled there.
class LocalDateTime extends Equatable implements Comparable<LocalDateTime> {
  const LocalDateTime(this.date, this.minutes) : assert(minutes >= 0 && minutes < 24 * 60);

  factory LocalDateTime.fromDateTime(DateTime dateTime) =>
      LocalDateTime(LocalDate.fromDateTime(dateTime), dateTime.hour * 60 + dateTime.minute);

  /// Normalizes [minutes] that may be negative or exceed a day.
  factory LocalDateTime.normalized(LocalDate date, int minutes) {
    final dayShift = minutes >= 0 ? minutes ~/ _day : -((-minutes + _day - 1) ~/ _day);
    return LocalDateTime(date.addDays(dayShift), minutes - dayShift * _day);
  }

  static const _day = 24 * 60;

  final LocalDate date;
  final int minutes;

  int get hour => minutes ~/ 60;

  int get minute => minutes % 60;

  int get _ordinal => date.epochDay * _day + minutes;

  LocalDateTime addMinutes(int delta) => LocalDateTime.normalized(date, minutes + delta);

  bool isAfter(LocalDateTime other) => compareTo(other) > 0;

  DateTime toDateTime() => date.toDateTime(minutes);

  /// `yyyy-MM-ddTHH:mm`
  String get iso => '${date.iso}T${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(LocalDateTime other) => _ordinal.compareTo(other._ordinal);

  @override
  List<Object?> get props => [date, minutes];

  @override
  String toString() => iso;
}
