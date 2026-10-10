import 'package:klar/core/time/local_date_time.dart';
import 'package:klar/features/alarms/domain/alarm_planner.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/helpers/formatters.dart';

/// Texts of alarms and reminder notifications, e.g. «Через 15 минут · 07:30 · Работа».
AlarmTextBuilder alarmTexts(L10n l10n) =>
    ({required Task task, required Reminder reminder, required LocalDateTime due, TaskList? list}) {
      final trigger = due.addMinutes(-reminder.offsetMinutes);
      final when = task.dueTime != null ? formatTime(due.minutes) : formatDate(l10n, due.date, trigger.date);
      return (
        title: task.title,
        body: [
          if (reminder.offsetMinutes > 0) l10n.alarmIn(formatDuration(l10n, reminder.offsetMinutes)),
          when,
          if (list != null && !list.isInbox) list.name,
        ].join(' · '),
      );
    };
