import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/cubit/overview_cubit.dart';
import 'package:klar/ui/helpers/formatters.dart';

/// Task actions shared by every list of tasks, with undo snackbars.
extension TaskActions on BuildContext {
  Future<void> toggleTask(Task task) async {
    final cubit = read<OverviewCubit>();
    if (task.isCompleted) {
      await cubit.reopen(task);
      return;
    }

    final messenger = ScaffoldMessenger.of(this);
    final l10n = L10n.of(this);
    final previous = await cubit.complete(task);
    if (previous == null) return;
    final updated = await cubit.find(task.id);
    final nextDate = previous.isRecurring && updated != null && !updated.isCompleted ? updated.dueDate : null;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            nextDate == null
                ? l10n.taskCompleted
                : l10n.taskNextOccurrence(formatDate(l10n, nextDate, cubit.state.today)),
          ),
          action: SnackBarAction(label: l10n.undo, onPressed: () => cubit.restore(previous)),
        ),
      );
  }

  Future<void> deleteTask(Task task) async {
    final cubit = read<OverviewCubit>();
    final messenger = ScaffoldMessenger.of(this);
    final l10n = L10n.of(this);
    await cubit.delete(task);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.taskDeleted),
          action: SnackBarAction(label: l10n.undo, onPressed: () => cubit.restore(task)),
        ),
      );
  }

  void openTask(Task task) => push('/task/${task.id}');

  void newTask({String? title, String? listId, LocalDate? date}) => push(
    Uri(
      path: '/task/new',
      queryParameters: {
        if (title != null && title.isNotEmpty) 'title': title,
        'list': ?listId,
        if (date != null) 'date': date.iso,
      },
    ).toString(),
  );
}
