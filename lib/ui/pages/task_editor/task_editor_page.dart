import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klar/core/time/clock.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/di/app_dependencies.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/cubit/overview_cubit.dart';
import 'package:klar/ui/helpers/formatters.dart';
import 'package:klar/ui/pages/settings/widgets/sound_picker_sheet.dart';
import 'package:klar/ui/pages/settings/widgets/vibration_picker_sheet.dart';
import 'package:klar/ui/pages/task_editor/cubit/task_editor_cubit.dart';
import 'package:klar/ui/pages/task_editor/widgets/date_sheet.dart';
import 'package:klar/ui/pages/task_editor/widgets/reminder_sheet.dart';
import 'package:klar/ui/pages/task_editor/widgets/repeat_sheet.dart';
import 'package:klar/ui/pages/task_editor/widgets/subtasks_section.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';
import 'package:klar/ui/widgets/klar_choices.dart';
import 'package:klar/ui/widgets/klar_row.dart';
import 'package:klar/ui/widgets/klar_sheet.dart';
import 'package:klar/ui/widgets/list_icons.dart';
import 'package:klar/ui/widgets/section_header.dart';

class TaskEditorPage extends StatelessWidget {
  const TaskEditorPage({this.taskId, this.title, this.listId, this.date, super.key});

  final String? taskId;
  final String? title;
  final String? listId;
  final LocalDate? date;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => TaskEditorCubit(
      tasksRepo: getIt(),
      listsRepo: getIt(),
      settingsRepo: getIt(),
      clock: getIt(),
    )..load(taskId: taskId, title: title, listId: listId, date: date),
    child: BlocConsumer<TaskEditorCubit, TaskEditorState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == EditorStatus.closed) Navigator.of(context).pop();
      },
      builder: (context, state) => state.draft == null ? const Scaffold() : const _Editor(),
    ),
  );
}

class _Editor extends StatelessWidget {
  const _Editor();

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final cubit = context.read<TaskEditorCubit>();
    final state = context.watch<TaskEditorCubit>().state;
    final task = state.task;
    final today = getIt<Clock>().today();
    final list = state.list;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(KlarIcons.x),
        ),
        title: Text(state.isNew ? l10n.newTask : l10n.editTask, style: KlarTypography.body),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(onPressed: state.canSave ? cubit.save : null, child: Text(l10n.save)),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 32),
        children: [
          _TitleField(
            initial: task.title,
            autofocus: state.isNew && task.title.isEmpty,
            onChanged: cubit.setTitle,
          ),
          _NotesField(initial: task.notes, onChanged: cubit.setNotes),
          const SizedBox(height: 8),
          const Divider(),
          KlarRow(
            icon: ListIcons.of(list?.iconKey ?? ''),
            iconColor: KlarColors.list(list?.colorKey ?? ''),
            title: l10n.fieldList,
            value: list?.name,
            onTap: () => _pickList(context, state),
          ),
          _PriorityRow(priority: task.priority, onChanged: cubit.setPriority),
          const Divider(),
          KlarRow(
            icon: KlarIcons.calendarBlank,
            title: l10n.fieldDate,
            value: task.dueDate == null ? l10n.noDate : formatDate(l10n, task.dueDate!, today),
            onTap: () async {
              final choice = await showDateSheet(context, today: today, current: task.dueDate);
              if (choice != null) cubit.setDate(choice.date);
            },
          ),
          KlarRow(
            icon: KlarIcons.clock,
            title: l10n.fieldTime,
            value: task.dueTime == null ? l10n.allDay : formatTime(task.dueTime!),
            trailing: task.dueTime == null
                ? null
                : IconButton(
                    tooltip: l10n.timeClear,
                    onPressed: () => cubit.setTime(null),
                    icon: const Icon(KlarIcons.x, size: 16, color: KlarColors.textMuted),
                  ),
            onTap: () async {
              final minutes = await pickTime(context, initial: task.dueTime);
              if (minutes != null) cubit.setTime(minutes);
            },
          ),
          KlarRow(
            icon: KlarIcons.repeat,
            title: l10n.fieldRepeat,
            value: task.recurrence == null ? l10n.repeatNone : formatRecurrence(l10n, task.recurrence!),
            onTap: () async {
              final choice = await showRepeatSheet(
                context,
                anchor: task.dueDate ?? today,
                current: task.recurrence,
              );
              if (choice != null) cubit.setRecurrence(choice.rule);
            },
          ),
          SectionHeader(l10n.fieldReminders),
          _RemindersSection(task: task, allDayMinutes: state.settings.allDayMinutes),
          if (task.hasAlarm) ...[
            SectionHeader(l10n.fieldSound),
            KlarRow(
              icon: KlarIcons.musicNote,
              title: l10n.settingSound,
              value: soundTitle(l10n, task.sound),
              onTap: () async {
                final selection = await showSoundPicker(context, current: task.sound, allowDefault: true);
                if (selection != null) cubit.setSound(selection.sound);
              },
            ),
            KlarRow(
              icon: KlarIcons.vibrate,
              title: l10n.settingVibration,
              value: task.vibration == null ? l10n.asInSettings : formatVibration(l10n, task.vibration!),
              onTap: () async {
                final selection = await showVibrationPicker(context, current: task.vibration, allowDefault: true);
                if (selection != null) cubit.setVibration(selection.pattern);
              },
            ),
          ],
          SectionHeader(l10n.fieldSubtasks),
          SubtasksSection(
            subtasks: task.subtasks,
            onAdd: cubit.addSubtask,
            onChanged: cubit.updateSubtask,
            onRemove: cubit.removeSubtask,
            onReorder: cubit.reorderSubtasks,
          ),
          if (!state.isNew) ...[
            const SizedBox(height: 32),
            Center(
              child: TextButton.icon(
                onPressed: () => _delete(context, task),
                style: TextButton.styleFrom(foregroundColor: KlarColors.lingon),
                icon: const Icon(KlarIcons.trash, size: 18),
                label: Text(l10n.deleteTask),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickList(BuildContext context, TaskEditorState state) async {
    final cubit = context.read<TaskEditorCubit>();
    final id = await showKlarSheet<String>(
      context,
      title: L10n.of(context).fieldList,
      builder: (context) => Column(
        children: [
          for (final list in state.lists)
            KlarRow(
              icon: ListIcons.of(list.iconKey),
              iconColor: KlarColors.list(list.colorKey),
              title: list.name,
              selected: list.id == state.task.listId,
              trailing: list.id == state.task.listId
                  ? const Icon(KlarIcons.check, size: 18, color: KlarColors.birch)
                  : null,
              onTap: () => Navigator.pop(context, list.id),
            ),
        ],
      ),
    );
    if (id != null) cubit.setList(id);
  }

  Future<void> _delete(BuildContext context, Task task) async {
    final l10n = L10n.of(context);
    final cubit = context.read<TaskEditorCubit>();
    final overview = context.read<OverviewCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTaskTitle),
        content: Text(l10n.deleteTaskBody(task.title)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: KlarColors.lingon),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final deleted = await cubit.delete();
    if (deleted == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.taskDeleted),
        action: SnackBarAction(label: l10n.undo, onPressed: () => overview.restore(deleted)),
      ),
    );
  }
}

class _TitleField extends StatefulWidget {
  const _TitleField({required this.initial, required this.autofocus, required this.onChanged});

  final String initial;
  final bool autofocus;
  final ValueChanged<String> onChanged;

  @override
  State<_TitleField> createState() => _TitleFieldState();
}

class _TitleFieldState extends State<_TitleField> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 12, KlarDimens.gutter, 4),
    child: TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      style: KlarTypography.title.copyWith(fontSize: 24),
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(hintText: L10n.of(context).titleHint),
      onChanged: widget.onChanged,
    ),
  );
}

class _NotesField extends StatefulWidget {
  const _NotesField({required this.initial, required this.onChanged});

  final String initial;
  final ValueChanged<String> onChanged;

  @override
  State<_NotesField> createState() => _NotesFieldState();
}

class _NotesFieldState extends State<_NotesField> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 8, KlarDimens.gutter, 8),
    child: TextField(
      controller: _controller,
      style: KlarTypography.bodyMuted.copyWith(fontSize: 15),
      maxLines: null,
      minLines: 1,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(hintText: L10n.of(context).notesHint),
      onChanged: widget.onChanged,
    ),
  );
}

class _PriorityRow extends StatelessWidget {
  const _PriorityRow({required this.priority, required this.onChanged});

  final Priority priority;
  final ValueChanged<Priority> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 8, KlarDimens.gutter, 12),
            child: Row(
              children: [
                const Icon(KlarIcons.flag, size: 22, color: KlarColors.textMuted),
                const SizedBox(width: 16),
                Text(l10n.fieldPriority, style: KlarTypography.body),
              ],
            ),
          ),
          KlarChoices(
            padding: const EdgeInsets.only(left: KlarDimens.gutter + 38, right: KlarDimens.gutter),
            values: Priority.values,
            selected: priority,
            label: (p) => formatPriority(l10n, p),
            leading: (p) => p == Priority.none
                ? const SizedBox.shrink()
                : Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: priorityColor(p), shape: BoxShape.circle),
                  ),
            onSelected: onChanged,
          ),
        ],
      ),
    );
  }
}

class _RemindersSection extends StatelessWidget {
  const _RemindersSection({required this.task, required this.allDayMinutes});

  final Task task;
  final int allDayMinutes;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final cubit = context.read<TaskEditorCubit>();
    if (task.dueDate == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: KlarDimens.gutter, vertical: 8),
        child: Text(l10n.remindersNeedDate, style: KlarTypography.bodyMuted),
      );
    }
    final allDay = task.dueTime == null;
    return Column(
      children: [
        for (final reminder in task.reminders)
          KlarRow(
            icon: reminder.kind == ReminderKind.alarm ? KlarIcons.alarm : KlarIcons.bell,
            iconColor: reminder.kind == ReminderKind.alarm ? KlarColors.birch : KlarColors.fjord,
            title: formatReminder(l10n, reminder, allDay: allDay, allDayMinutes: allDayMinutes),
            subtitle: reminder.kind == ReminderKind.alarm ? l10n.reminderKindAlarm : l10n.reminderKindNotification,
            trailing: IconButton(
              onPressed: () => cubit.removeReminder(reminder.id),
              icon: const Icon(KlarIcons.x, size: 16, color: KlarColors.textMuted),
            ),
            onTap: () async {
              final draft = await showReminderSheet(
                context,
                allDay: allDay,
                allDayMinutes: allDayMinutes,
                current: reminder,
              );
              if (draft != null) {
                cubit.updateReminder(reminder.copyWith(offsetMinutes: draft.offsetMinutes, kind: draft.kind));
              }
            },
          ),
        KlarRow(
          icon: KlarIcons.plus,
          title: l10n.addReminder,
          onTap: () async {
            final draft = await showReminderSheet(context, allDay: allDay, allDayMinutes: allDayMinutes);
            if (draft != null) cubit.addReminder(draft.offsetMinutes, draft.kind);
          },
        ),
      ],
    );
  }
}
