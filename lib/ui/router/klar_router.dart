import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/di/app_dependencies.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/features/settings/domain/repos/settings_repo.dart';
import 'package:klar/ui/cubit/overview_cubit.dart';
import 'package:klar/ui/pages/lists/list_detail_page.dart';
import 'package:klar/ui/pages/lists/lists_page.dart';
import 'package:klar/ui/pages/onboarding/onboarding_page.dart';
import 'package:klar/ui/pages/settings/settings_page.dart';
import 'package:klar/ui/pages/task_editor/task_editor_page.dart';
import 'package:klar/ui/pages/today/today_page.dart';
import 'package:klar/ui/pages/upcoming/upcoming_page.dart';
import 'package:klar/ui/router/shell_scaffold.dart';

abstract final class KlarRouter {
  static final _rootKey = GlobalKey<NavigatorState>();

  static GoRouter create() {
    final router = GoRouter(
      navigatorKey: _rootKey,
      initialLocation: getIt<SettingsRepo>().current.onboarded ? '/today' : '/onboarding',
      routes: [
        GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingPage()),
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => ShellScaffold(shell: shell),
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/today', builder: (_, _) => const TodayPage())],
            ),
            StatefulShellBranch(
              routes: [GoRoute(path: '/upcoming', builder: (_, _) => const UpcomingPage())],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/lists',
                  builder: (_, _) => const ListsPage(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (_, state) => ListDetailPage(listId: state.pathParameters['id']!),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [GoRoute(path: '/settings', builder: (_, _) => const SettingsPage())],
            ),
          ],
        ),
        GoRoute(
          path: '/task/:id',
          parentNavigatorKey: _rootKey,
          pageBuilder: (_, state) {
            final id = state.pathParameters['id']!;
            final query = state.uri.queryParameters;
            final date = query['date'];
            return MaterialPage(
              fullscreenDialog: true,
              child: TaskEditorPage(
                taskId: id == 'new' ? null : id,
                title: query['title'],
                listId: query['list'],
                date: date == null ? null : LocalDate.parse(date),
              ),
            );
          },
        ),
      ],
    );
    _openTasksFromNotifications(router);
    return router;
  }

  /// Opens the task the user tapped in a notification, both on launch and while running.
  static void _openTasksFromNotifications(GoRouter router) {
    final engine = getIt<AlarmEngine>();
    engine.openTaskRequests.listen((id) => router.push('/task/$id'));
    unawaited(
      engine.takeLaunchTaskId().then((id) {
        if (id != null && getIt<SettingsRepo>().current.onboarded) router.push('/task/$id');
      }),
    );
  }
}

/// Provides the shared [OverviewCubit] above the router.
class OverviewScope extends StatelessWidget {
  const OverviewScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => OverviewCubit(getIt(), getIt(), getIt(), getIt()),
    child: child,
  );
}
