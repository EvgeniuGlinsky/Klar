import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/cubit/overview_cubit.dart';
import 'package:klar/ui/helpers/formatters.dart';
import 'package:klar/ui/helpers/task_sorting.dart';
import 'package:klar/ui/widgets/empty_state.dart';
import 'package:klar/ui/widgets/page_header.dart';
import 'package:klar/ui/widgets/quick_add_bar.dart';
import 'package:klar/ui/widgets/section_header.dart';
import 'package:klar/ui/widgets/task_actions.dart';
import 'package:klar/ui/widgets/task_tile.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key});

  static const _days = 14;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return BlocBuilder<OverviewCubit, OverviewState>(
      builder: (context, state) {
        final today = state.today;
        final lastDay = today.addDays(_days);
        final upcoming = state.active.where((t) => t.dueDate != null && t.dueDate!.isAfter(today)).toList()..sort(byDue);
        final byDay = groupBy(upcoming.where((t) => !t.dueDate!.isAfter(lastDay)), (Task t) => t.dueDate!);
        final later = upcoming.where((t) => t.dueDate!.isAfter(lastDay)).toList();
        final tomorrow = today.addDays(1);

        List<Widget> section(String title, List<Task> tasks, {bool showDate = false}) => [
          SliverToBoxAdapter(child: SectionHeader(title)),
          SliverList.list(
            children: [
              for (final task in tasks)
                TaskTile(
                  task: task,
                  list: state.list(task.listId),
                  now: state.now,
                  showDate: showDate,
                  onToggle: () => context.toggleTask(task),
                  onTap: () => context.openTask(task),
                  onDelete: () => context.deleteTask(task),
                ),
            ],
          ),
        ];

        String dayTitle(LocalDate date) => date == tomorrow ? '${l10n.tomorrow} · ${formatLongDate(date)}' : formatLongDate(date);

        return Stack(
          children: [
            SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: PageHeader(title: l10n.navUpcoming)),
                  if (state.loaded && upcoming.isEmpty)
                    SliverToBoxAdapter(child: EmptyState(title: l10n.emptyUpcomingTitle, body: l10n.emptyUpcomingBody)),
                  for (final entry in byDay.entries) ...section(dayTitle(entry.key), entry.value),
                  if (later.isNotEmpty) ...section(l10n.later, later, showDate: true),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomDock(
                child: QuickAddBar(
                  onSubmit: (title) => context.read<OverviewCubit>().quickAdd(title, date: tomorrow),
                  onExpand: (title) => context.newTask(title: title, date: tomorrow),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
