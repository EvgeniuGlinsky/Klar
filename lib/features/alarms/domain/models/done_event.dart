import 'package:equatable/equatable.dart';
import 'package:klar/core/time/local_date.dart';

/// "Done" pressed on a ringing alarm or a reminder notification while the app may not be running.
class DoneEvent extends Equatable {
  const DoneEvent({required this.seq, required this.taskId, required this.occurrence});

  factory DoneEvent.fromJson(Map<Object?, Object?> json) => DoneEvent(
    seq: json['seq']! as int,
    taskId: json['taskId']! as String,
    occurrence: LocalDate.parse(json['occurrence']! as String),
  );

  final int seq;
  final String taskId;
  final LocalDate occurrence;

  @override
  List<Object?> get props => [seq, taskId, occurrence];
}
