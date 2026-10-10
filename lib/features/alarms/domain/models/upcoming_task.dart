import 'package:klar/core/time/local_date.dart';
import 'package:klar/core/time/local_date_time.dart';

/// A timed task occurrence shown in the pinned "next task" notification.
class UpcomingTask {
  const UpcomingTask({
    required this.taskId,
    required this.occurrence,
    required this.due,
    required this.title,
    required this.listName,
  });

  final String taskId;
  final LocalDate occurrence;
  final LocalDateTime due;
  final String title;

  /// Empty for the inbox.
  final String listName;

  Map<String, Object?> toJson() => {
    'taskId': taskId,
    'occurrence': occurrence.iso,
    'due': due.iso,
    'title': title,
    'list': listName,
  };
}
