import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/cubit/overview_cubit.dart';
import 'package:klar/ui/helpers/formatters.dart';
import 'package:klar/ui/helpers/task_sorting.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';
import 'package:klar/ui/widgets/empty_state.dart';
import 'package:klar/ui/widgets/page_header.dart';
import 'package:klar/ui/widgets/quick_add_bar.dart';
import 'package:klar/ui/widgets/section_header.dart';
import 'package:klar/ui/widgets/task_actions.dart';
import 'package:klar/ui/widgets/task_tile.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  bool _showDone = false;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return BlocBuilder<OverviewCubit, OverviewState>(
      builder: (context, state) {
        final today = state.today;
        final active = state.active.toList();
        final overdue = active.where((t) => t.dueDate != null && t.dueDate!.isBefore(today)).toList()..sort(byDue);
        final dueToday = active.where((t) => t.dueDate == today);
        final scheduled = dueToday.where((t) => t.dueTime != null).toList()..sort(byDue);
        final anytime = dueToday.where((t) => t.dueTime == null).toList()..sort(byPriority);
        final done =
            state.tasks.where((t) => t.completedAt != null && LocalDate.fromDateTime(t.completedAt!) == today).toList()
              ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
        final total = overdue.length + scheduled.length + anytime.length + done.length;

        Widget tiles(List<Task> tasks, {bool showDate = false}) => SliverList.list(
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
        );

        return Stack(
          children: [
            SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: PageHeader(title: l10n.today, subtitle: formatLongDate(today)),
                  ),
                  if (total > 0)
                    SliverToBoxAdapter(
                      child: _Progress(done: done.length, total: total),
                    ),
                  if (state.loaded && total == 0)
                    SliverToBoxAdapter(
                      child: EmptyState(title: l10n.emptyTodayTitle, body: l10n.emptyTodayBody),
                    ),
                  if (overdue.isNotEmpty) ...[
                    SliverToBoxAdapter(child: SectionHeader(l10n.sectionOverdue, color: KlarColors.lingon)),
                    tiles(overdue, showDate: true),
                  ],
                  if (scheduled.isNotEmpty) ...[
                    SliverToBoxAdapter(child: SectionHeader(l10n.sectionScheduled)),
                    tiles(scheduled),
                  ],
                  if (anytime.isNotEmpty) ...[
                    SliverToBoxAdapter(child: SectionHeader(l10n.sectionAnytime)),
                    tiles(anytime),
                  ],
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
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomDock(
                child: QuickAddBar(
                  onSubmit: (title) => context.read<OverviewCubit>().quickAdd(title, date: today),
                  onExpand: (title) => context.newTask(title: title, date: today),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 18, KlarDimens.gutter, 0),
    child: Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: total == 0 ? 0 : done / total),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 3,
                color: KlarColors.sage,
                backgroundColor: KlarColors.line,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(L10n.of(context).todayProgress(done, total), style: KlarTypography.meta),
      ],
    ),
  );
}
