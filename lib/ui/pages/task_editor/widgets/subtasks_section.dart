import 'package:flutter/material.dart';
import 'package:klar/features/tasks/domain/models/subtask.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';
import 'package:klar/ui/widgets/check_circle.dart';

class SubtasksSection extends StatelessWidget {
  const SubtasksSection({
    required this.subtasks,
    required this.onAdd,
    required this.onChanged,
    required this.onRemove,
    required this.onReorder,
    super.key,
  });

  final List<Subtask> subtasks;
  final ValueChanged<String> onAdd;
  final ValueChanged<Subtask> onChanged;
  final ValueChanged<String> onRemove;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        onReorderItem: onReorder,
        proxyDecorator: (child, _, _) => Material(color: KlarColors.surfaceRaised, child: child),
        children: [
          for (final (i, subtask) in subtasks.indexed)
            _SubtaskRow(
              key: ValueKey(subtask.id),
              index: i,
              subtask: subtask,
              onChanged: onChanged,
              onRemove: () => onRemove(subtask.id),
            ),
        ],
      ),
      _AddSubtask(onAdd: onAdd),
    ],
  );
}

class _SubtaskRow extends StatefulWidget {
  const _SubtaskRow({
    required this.index,
    required this.subtask,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final int index;
  final Subtask subtask;
  final ValueChanged<Subtask> onChanged;
  final VoidCallback onRemove;

  @override
  State<_SubtaskRow> createState() => _SubtaskRowState();
}

class _SubtaskRowState extends State<_SubtaskRow> {
  late final _controller = TextEditingController(text: widget.subtask.title);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = widget.subtask.done;
    return Padding(
      padding: const EdgeInsets.only(left: KlarDimens.gutter - 10, right: 4),
      child: Row(
        children: [
          CheckCircle(
            done: done,
            size: 20,
            onTap: () => widget.onChanged(widget.subtask.copyWith(done: !done)),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: KlarTypography.body.copyWith(
                fontSize: 15,
                color: done ? KlarColors.textFaint : KlarColors.text,
                decoration: done ? TextDecoration.lineThrough : null,
                decorationColor: KlarColors.textFaint,
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (title) => widget.onChanged(widget.subtask.copyWith(title: title)),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
          IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(KlarIcons.x, size: 16, color: KlarColors.textFaint),
          ),
          ReorderableDragStartListener(
            index: widget.index,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(KlarIcons.dotsSixVertical, size: 18, color: KlarColors.textFaint),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSubtask extends StatefulWidget {
  const _AddSubtask({required this.onAdd});

  final ValueChanged<String> onAdd;

  @override
  State<_AddSubtask> createState() => _AddSubtaskState();
}

class _AddSubtaskState extends State<_AddSubtask> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    widget.onAdd(_controller.text);
    _controller.clear();
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 6, KlarDimens.gutter, 6),
    child: Row(
      children: [
        const Icon(KlarIcons.plus, size: 20, color: KlarColors.textMuted),
        const SizedBox(width: 18),
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            style: KlarTypography.body.copyWith(fontSize: 15),
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(hintText: L10n.of(context).addSubtask),
            onSubmitted: (_) => _submit(),
          ),
        ),
      ],
    ),
  );
}
