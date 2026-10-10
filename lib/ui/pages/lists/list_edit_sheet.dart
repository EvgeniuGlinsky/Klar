import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/cubit/overview_cubit.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';
import 'package:klar/ui/widgets/klar_sheet.dart';
import 'package:klar/ui/widgets/list_icons.dart';

/// Creates a list, or edits [list]; returns `true` when the list was deleted.
Future<bool?> showListEditSheet(BuildContext context, {TaskList? list}) {
  final cubit = context.read<OverviewCubit>();
  final l10n = L10n.of(context);
  return showKlarSheet<bool>(
    context,
    title: list == null ? l10n.newList : l10n.editList,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _ListEditForm(list: list),
    ),
  );
}

class _ListEditForm extends StatefulWidget {
  const _ListEditForm({this.list});

  final TaskList? list;

  @override
  State<_ListEditForm> createState() => _ListEditFormState();
}

class _ListEditFormState extends State<_ListEditForm> {
  late final _name = TextEditingController(text: widget.list?.name ?? '');
  late String _color = widget.list?.colorKey ?? 'sage';
  late String _icon = widget.list?.iconKey ?? 'leaf';

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final cubit = context.read<OverviewCubit>();
    final existing = widget.list;
    await cubit.saveList(
      existing?.copyWith(name: name, colorKey: _color, iconKey: _icon) ??
          TaskList(
            id: cubit.newListId(),
            name: name,
            colorKey: _color,
            iconKey: _icon,
            sortOrder: cubit.state.lists.length,
          ),
    );
    if (mounted) Navigator.of(context).pop(false);
  }

  Future<void> _delete() async {
    final list = widget.list!;
    final l10n = L10n.of(context);
    final navigator = Navigator.of(context);
    final cubit = context.read<OverviewCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteListTitle),
        content: Text(l10n.deleteListBody(list.name)),
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
    await cubit.deleteList(list);
    navigator.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final accent = KlarColors.list(_color);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KlarDimens.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.14), shape: BoxShape.circle),
                child: Icon(ListIcons.of(_icon), color: accent, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _name,
                  autofocus: widget.list == null,
                  style: KlarTypography.title,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(hintText: l10n.listNameHint),
                  onSubmitted: (_) => _save(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(l10n.listColor.toUpperCase(), style: KlarTypography.label),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final entry in KlarColors.lists.entries)
                GestureDetector(
                  onTap: () => setState(() => _color = entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 34,
                    height: 34,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _color == entry.key ? entry.value : Colors.transparent, width: 1.5),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: entry.value, shape: BoxShape.circle),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 28),
          Text(l10n.listIcon.toUpperCase(), style: KlarTypography.label),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (final entry in ListIcons.all.entries)
                IconButton(
                  onPressed: () => setState(() => _icon = entry.key),
                  isSelected: _icon == entry.key,
                  style: IconButton.styleFrom(
                    backgroundColor: _icon == entry.key ? accent.withValues(alpha: 0.14) : Colors.transparent,
                  ),
                  icon: Icon(entry.value, color: _icon == entry.key ? accent : KlarColors.textMuted),
                ),
            ],
          ),
          const SizedBox(height: 28),
          ListenableBuilder(
            listenable: _name,
            builder: (context, _) =>
                FilledButton(onPressed: _name.text.trim().isEmpty ? null : _save, child: Text(l10n.save)),
          ),
          if (widget.list != null && !widget.list!.isInbox) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _delete,
              style: TextButton.styleFrom(foregroundColor: KlarColors.lingon),
              icon: const Icon(KlarIcons.trash, size: 18),
              label: Text(l10n.delete),
            ),
          ],
        ],
      ),
    );
  }
}
