import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/cubit/overview_cubit.dart';
import 'package:klar/ui/pages/lists/list_edit_sheet.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';
import 'package:klar/ui/widgets/list_icons.dart';
import 'package:klar/ui/widgets/page_header.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return BlocBuilder<OverviewCubit, OverviewState>(
      builder: (context, state) {
        final counts = <String, int>{};
        for (final task in state.active) {
          counts[task.listId] = (counts[task.listId] ?? 0) + 1;
        }
        return SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PageHeader(
                  title: l10n.listsTitle,
                  trailing: IconButton(
                    tooltip: l10n.newList,
                    onPressed: () => showListEditSheet(context),
                    icon: const Icon(KlarIcons.plus, color: KlarColors.text),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverList.separated(
                itemCount: state.lists.length,
                separatorBuilder: (_, _) => const Divider(indent: 76),
                itemBuilder: (context, i) {
                  final list = state.lists[i];
                  return _ListTile(
                    list: list,
                    count: counts[list.id] ?? 0,
                    onTap: () => context.go('/lists/${list.id}'),
                    onLongPress: () => showListEditSheet(context, list: list),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(KlarDimens.gutter - 8, 12, KlarDimens.gutter, 32),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => showListEditSheet(context),
                      icon: const Icon(KlarIcons.plus, size: 18),
                      label: Text(l10n.newList),
                    ),
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

class _ListTile extends StatelessWidget {
  const _ListTile({required this.list, required this.count, required this.onTap, required this.onLongPress});

  final TaskList list;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final color = KlarColors.list(list.colorKey);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: KlarDimens.gutter, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
              child: Icon(ListIcons.of(list.iconKey), size: 20, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(list.name, style: KlarTypography.body),
                  const SizedBox(height: 2),
                  Text(L10n.of(context).listTasksCount(count), style: KlarTypography.meta),
                ],
              ),
            ),
            const Icon(KlarIcons.caretRight, size: 16, color: KlarColors.textFaint),
          ],
        ),
      ),
    );
  }
}
