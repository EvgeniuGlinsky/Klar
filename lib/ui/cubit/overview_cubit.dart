import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klar/core/time/clock.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/core/time/local_date_time.dart';
import 'package:klar/features/settings/domain/models/app_settings.dart';
import 'package:klar/features/settings/domain/repos/settings_repo.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';
import 'package:klar/features/tasks/domain/repos/lists_repo.dart';
import 'package:klar/features/tasks/domain/repos/tasks_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class OverviewState extends Equatable {
  const OverviewState({
    required this.now,
    this.tasks = const [],
    this.lists = const [],
    this.settings = const AppSettings(),
    this.loaded = false,
  });

  final List<Task> tasks;
  final List<TaskList> lists;
  final AppSettings settings;
  final LocalDateTime now;
  final bool loaded;

  LocalDate get today => now.date;

  TaskList? list(String id) => lists.where((l) => l.id == id).firstOrNull;

  Iterable<Task> get active => tasks.where((t) => !t.isCompleted);

  OverviewState copyWith({
    List<Task>? tasks,
    List<TaskList>? lists,
    AppSettings? settings,
    LocalDateTime? now,
    bool? loaded,
  }) => OverviewState(
    tasks: tasks ?? this.tasks,
    lists: lists ?? this.lists,
    settings: settings ?? this.settings,
    now: now ?? this.now,
    loaded: loaded ?? this.loaded,
  );

  @override
  List<Object?> get props => [tasks, lists, settings, now, loaded];
}

/// All tasks and lists, shared by the tab pages; also ticks every minute so overdue marks stay current.
class OverviewCubit extends Cubit<OverviewState> {
  OverviewCubit(this._tasksRepo, this._listsRepo, this._settingsRepo, this._clock)
    : super(OverviewState(now: _clock.localNow(), settings: _settingsRepo.current)) {
    _subscription =
        Rx.combineLatest3(
          _tasksRepo.watchAll(),
          _listsRepo.watchAll(),
          _settingsRepo.watch(),
          (tasks, lists, settings) => (tasks, lists, settings),
        ).listen(
          (data) => emit(
            state.copyWith(tasks: data.$1, lists: data.$2, settings: data.$3, now: _clock.localNow(), loaded: true),
          ),
        );
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => _tick());
  }

  static const _uuid = Uuid();

  final TasksRepo _tasksRepo;
  final ListsRepo _listsRepo;
  final SettingsRepo _settingsRepo;
  final Clock _clock;
  late final StreamSubscription<Object?> _subscription;
  late final Timer _ticker;

  void _tick() {
    final now = _clock.localNow();
    if (now != state.now) emit(state.copyWith(now: now));
  }

  Future<void> quickAdd(String title, {String listId = TaskList.inboxId, LocalDate? date}) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return Future.value();
    return _tasksRepo.save(
      Task(
        id: _uuid.v4(),
        listId: listId,
        title: trimmed,
        createdAt: _clock.now(),
        dueDate: date,
        sortOrder: _clock.now().millisecondsSinceEpoch ~/ 1000,
      ),
    );
  }

  /// Returns the task before completion for undo, or `null` if nothing changed.
  Future<Task?> complete(Task task) => _tasksRepo.complete(task.id);

  Future<Task?> find(String id) => _tasksRepo.get(id);

  Future<void> reopen(Task task) => _tasksRepo.reopen(task.id);

  Future<void> restore(Task task) => _tasksRepo.restore(task);

  Future<void> delete(Task task) => _tasksRepo.delete(task.id);

  Future<void> setSubtaskDone(String subtaskId, {required bool done}) =>
      _tasksRepo.setSubtaskDone(subtaskId, done: done);

  Future<void> saveList(TaskList list) => _listsRepo.save(list);

  Future<void> deleteList(TaskList list) => _listsRepo.delete(list.id);

  String newListId() => _uuid.v4();

  @override
  Future<void> close() async {
    _ticker.cancel();
    await _subscription.cancel();
    return super.close();
  }
}
