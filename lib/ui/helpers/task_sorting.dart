import 'package:klar/features/tasks/domain/models/task.dart';

/// By due date, then time (all-day last within a day), then priority.
int byDue(Task a, Task b) {
  final date = _compareNullable(a.dueDate, b.dueDate);
  if (date != 0) return date;
  final time = (a.dueTime ?? 24 * 60).compareTo(b.dueTime ?? 24 * 60);
  return time != 0 ? time : byPriority(a, b);
}

/// Higher priority first, then oldest first.
int byPriority(Task a, Task b) {
  final priority = b.priority.index.compareTo(a.priority.index);
  return priority != 0 ? priority : a.createdAt.compareTo(b.createdAt);
}

int _compareNullable<T extends Comparable<T>>(T? a, T? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}
