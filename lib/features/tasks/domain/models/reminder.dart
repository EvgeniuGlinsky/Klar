import 'package:equatable/equatable.dart';

/// How a reminder signals: a full-screen ringing alarm or a regular notification.
enum ReminderKind { alarm, notification }

class Reminder extends Equatable {
  const Reminder({required this.id, required this.offsetMinutes, required this.kind});

  static const presetOffsets = [0, 5, 10, 15, 30, 60, 120, 1440];

  final String id;

  /// Minutes before the due moment; 0 means exactly at it.
  final int offsetMinutes;
  final ReminderKind kind;

  Reminder copyWith({int? offsetMinutes, ReminderKind? kind}) =>
      Reminder(id: id, offsetMinutes: offsetMinutes ?? this.offsetMinutes, kind: kind ?? this.kind);

  @override
  List<Object?> get props => [id, offsetMinutes, kind];
}
