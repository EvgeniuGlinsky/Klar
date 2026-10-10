import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/cubit/overview_cubit.dart';
import 'package:klar/ui/helpers/task_sorting.dart';
import 'package:klar/ui/pages/lists/list_edit_sheet.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/widgets/empty_state.dart';
import 'package:klar/ui/widgets/page_header.dart';
import 'package:klar/ui/widgets/quick_add_bar.dart';
import 'package:klar/ui/widgets/section_header.dart';
import 'package:klar/ui/widgets/task_actions.dart';
import 'package:klar/ui/widgets/task_tile.dart';

class ListDetailPage extends StatefulWidget {
  const ListDetailPage({required this.listId, super.key});

  final String listId;

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  bool _showDone = false;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return BlocBuilder<OverviewCubit, OverviewState>(
      builder: (context, state) {
        final list = state.list(widget.listId);
        if (list == null) return const Scaffold();
        final tasks = state.tasks.where((t) => t.listId == list.id);
        final active = tasks.where((t) => !t.isCompleted).toList()..sort(byDue);
        final done = tasks.where((t) => t.isCompleted).toList()
          ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

        Widget tiles(List<Task> items) => SliverList.list(
          children: [
            for (final task in items)
              TaskTile(
                task: task,
                now: state.now,
                showDate: true,
                onToggle: () => context.toggleTask(task),
                onTap: () => context.openTask(task),
                onDelete: () => context.deleteTask(task),
              ),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => context.go('/lists'),
              icon: const Icon(KlarIcons.caretLeft),
            ),
            actions: [
              IconButton(
                tooltip: l10n.edit,
                onPressed: () async {
                  final deleted = await showListEditSheet(context, list: list);
                  if ((deleted ?? false) && context.mounted) context.go('/lists');
                },
                icon: const Icon(KlarIcons.dotsThree),
              ),
            ],
          ),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: PageHeader(title: list.name, accent: KlarColors.list(list.colorKey)),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  if (state.loaded && tasks.isEmpty)
                    SliverToBoxAdapter(
                      child: EmptyState(title: l10n.emptyListTitle, body: l10n.emptyListBody),
                    ),
                  tiles(active),
                  if (done.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        l10n.sectionDone(done.length),
                        onTap: () => setState(() => _showDone = !_showDone),
                        trailing: AnimatedRotation(
                          turns: _showDone ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(KlarIcons.caretDown, size: 16, color: KlarColors.textFaint),
                        ),
                      ),
                    ),
                    if (_showDone) tiles(done),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomDock(
                  child: QuickAddBar(
                    onSubmit: (title) => context.read<OverviewCubit>().quickAdd(title, listId: list.id),
                    onExpand: (title) => context.newTask(title: title, listId: list.id),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
