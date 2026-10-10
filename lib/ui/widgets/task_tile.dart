import 'package:flutter/material.dart';
import 'package:klar/core/time/local_date_time.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/helpers/formatters.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_typography.dart';
import 'package:klar/ui/widgets/check_circle.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.now,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
    this.list,
    this.showDate = false,
    super.key,
  });

  final Task task;
  final TaskList? list;
  final LocalDateTime now;
  final bool showDate;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final done = task.isCompleted;
    final overdue = task.isOverdue(now);

    return Dismissible(
      key: ValueKey('task-${task.id}'),
      background: const _SwipeBackground(
        color: KlarColors.sage,
        icon: PhosphorIconsLight.check,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: const _SwipeBackground(
        color: KlarColors.lingon,
        icon: PhosphorIconsLight.trash,
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onToggle();
          // Recurring tasks stay in place with a new date; others leave via the list update.
          return false;
        }
        onDelete();
        return true;
      },
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(KlarDimens.gutter - 10, 4, KlarDimens.gutter, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckCircle(done: done, color: priorityColor(task.priority), onTap: onToggle),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: KlarTypography.body.copyWith(
                          color: done ? KlarColors.textFaint : KlarColors.text,
                          decoration: done ? TextDecoration.lineThrough : null,
                          decorationColor: KlarColors.textFaint,
                        ),
                        child: Text(task.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                      _Meta(task: task, list: list, now: now, overdue: overdue, showDate: showDate, l10n: l10n),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({
    required this.task,
    required this.list,
    required this.now,
    required this.overdue,
    required this.showDate,
    required this.l10n,
  });

  final Task task;
  final TaskList? list;
  final LocalDateTime now;
  final bool overdue;
  final bool showDate;
  final L10n l10n;

  @override
  Widget build(BuildContext context) {
    final color = overdue ? KlarColors.lingon : KlarColors.textMuted;
    final dueDate = task.dueDate;
    final time = task.dueTime;
    final items = <Widget>[
      if (dueDate != null && (showDate || overdue || time != null))
        _MetaItem(
          icon: task.hasAlarm ? PhosphorIconsLight.alarm : (time != null ? PhosphorIconsLight.clock : null),
          text: [
            if (showDate || overdue || dueDate != now.date) formatDate(l10n, dueDate, now.date),
            if (time != null) formatTime(time),
          ].join(', '),
          color: color,
        )
      else if (task.reminders.isNotEmpty)
        _MetaItem(icon: task.hasAlarm ? PhosphorIconsLight.alarm : PhosphorIconsLight.bell, color: color),
      if (task.isRecurring) _MetaItem(icon: PhosphorIconsLight.repeat, color: KlarColors.textMuted),
      if (task.subtasks.isNotEmpty)
        _MetaItem(
          icon: PhosphorIconsLight.listChecks,
          text: '${task.subtasksDone}/${task.subtasks.length}',
          color: KlarColors.textMuted,
        ),
      if (task.notes.isNotEmpty) const _MetaItem(icon: PhosphorIconsLight.textAlignLeft, color: KlarColors.textMuted),
      if (list != null && !list!.isInbox) _ListMark(list: list!),
    ];
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Wrap(spacing: 12, runSpacing: 4, children: items),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.color, this.icon, this.text});

  final IconData? icon;
  final String? text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (icon != null) Icon(icon, size: 14, color: color),
      if (icon != null && text != null) const SizedBox(width: 4),
      if (text != null) Text(text!, style: KlarTypography.meta.copyWith(color: color)),
    ],
  );
}

class _ListMark extends StatelessWidget {
  const _ListMark({required this.list});

  final TaskList list;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: KlarColors.list(list.colorKey), shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(list.name, style: KlarTypography.meta),
    ],
  );
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({required this.color, required this.icon, required this.alignment});

  final Color color;
  final IconData icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: color.withValues(alpha: 0.16),
    child: Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Icon(icon, color: color, size: 22),
      ),
    ),
  );
}
