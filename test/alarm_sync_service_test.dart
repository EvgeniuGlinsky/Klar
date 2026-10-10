import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klar/core/db/klar_db.dart';
import 'package:klar/core/time/clock.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/alarms/data/alarm_sync_service.dart';
import 'package:klar/features/alarms/domain/alarm_planner.dart';
import 'package:klar/features/alarms/domain/models/alarm_spec.dart';
import 'package:klar/features/alarms/domain/models/done_event.dart';
import 'package:klar/features/alarms/domain/models/engine_config.dart';
import 'package:klar/features/alarms/domain/models/permission_report.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/alarms/domain/models/upcoming_task.dart';
import 'package:klar/features/alarms/domain/models/vibration_pattern.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/features/settings/data/repos/settings_repo_impl.dart';
import 'package:klar/features/tasks/data/repos/lists_repo_impl.dart';
import 'package:klar/features/tasks/data/repos/tasks_repo_impl.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';
import 'package:klar/features/tasks/domain/models/reminder.dart';
import 'package:klar/features/tasks/domain/models/task.dart';
import 'package:klar/features/tasks/domain/models/task_list.dart';

class FakeEngine implements AlarmEngine {
  final events = <DoneEvent>[];
  final calls = <({List<AlarmSpec> specs, List<UpcomingTask> upcoming, Map<String, String> live, int ackSeq})>[];
  final _changed = StreamController<void>.broadcast();

  @override
  Stream<void> get eventsChanged => _changed.stream;

  @override
  Stream<String> get openTaskRequests => const Stream.empty();

  @override
  Future<List<DoneEvent>> drainEvents() async => List.of(events);

  @override
  Future<void> replaceAll({
    required EngineConfig config,
    required List<AlarmSpec> specs,
    required List<UpcomingTask> upcoming,
    required Map<String, String> liveTasks,
    required int ackSeq,
  }) async {
    events.removeWhere((e) => e.seq <= ackSeq);
    calls.add((specs: specs, upcoming: upcoming, live: liveTasks, ackSeq: ackSeq));
  }

  @override
  Future<String?> takeLaunchTaskId() async => null;

  @override
  Future<void> testAlarm({required int seconds}) async {}

  @override
  Future<SoundRef?> pickSystemSound() async => null;

  @override
  Future<SoundRef?> pickAudioFile() async => null;

  @override
  Future<void> previewSound(SoundRef sound) async {}

  @override
  Future<void> previewVibration(VibrationPattern pattern) async {}

  @override
  Future<void> stopPreview() async {}

  @override
  Future<PermissionReport> permissionReport() async => const PermissionReport();

  @override
  Future<bool> requestNotificationPermission() async => true;

  @override
  Future<void> openSettings(SettingsTarget target) async {}
}

void main() {
  late KlarDb db;
  late FakeEngine engine;
  late TasksRepoImpl tasks;
  late AlarmSyncService service;
  final clock = FixedClock(DateTime(2026, 10, 10, 8));

  setUp(() async {
    db = KlarDb(NativeDatabase.memory());
    engine = FakeEngine();
    tasks = TasksRepoImpl(db, clock);
    final settings = SettingsRepoImpl(db);
    await settings.init();
    service = AlarmSyncService(
      tasksRepo: tasks,
      listsRepo: ListsRepoImpl(db),
      settingsRepo: settings,
      engine: engine,
      planner: AlarmPlanner(
        texts: ({required task, required reminder, required due, list}) => (title: task.title, body: ''),
        horizonDays: 3,
      ),
      clock: clock,
    );
  });

  tearDown(() => db.close());

  Task pills() => Task(
    id: 'pills',
    listId: TaskList.inboxId,
    title: 'Витамины',
    createdAt: clock.now(),
    dueDate: LocalDate.parse('2026-10-10'),
    dueTime: 9 * 60,
    recurrence: RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: LocalDate.parse('2026-10-10')),
    reminders: const [Reminder(id: 'r', offsetMinutes: 0, kind: ReminderKind.alarm)],
  );

  test('sends the full plan with live tasks and upcoming occurrences', () async {
    await tasks.save(pills());
    await service.sync();
    final call = engine.calls.single;
    expect(call.specs.map((s) => s.occurrence.iso), ['2026-10-10', '2026-10-11', '2026-10-12', '2026-10-13']);
    expect(call.upcoming.first.due.iso, '2026-10-10T09:00');
    expect(call.live, {'pills': '2026-10-10'});
    expect(call.ackSeq, 0);
  });

  test('applies native done events before planning and acknowledges them', () async {
    await tasks.save(pills());
    engine.events.add(DoneEvent(seq: 4, taskId: 'pills', occurrence: LocalDate.parse('2026-10-10')));
    await service.sync();

    expect((await tasks.get('pills'))!.dueDate, LocalDate.parse('2026-10-11'));
    final call = engine.calls.single;
    expect(call.ackSeq, 4);
    expect(call.specs.first.occurrence.iso, '2026-10-11');
    expect(engine.events, isEmpty);
  });

  test('a repeated event is applied once', () async {
    await tasks.save(pills());
    final event = DoneEvent(seq: 1, taskId: 'pills', occurrence: LocalDate.parse('2026-10-10'));
    engine.events.add(event);
    await service.sync();
    engine.events.add(event);
    await service.sync();
    expect((await tasks.get('pills'))!.dueDate, LocalDate.parse('2026-10-11'));
  });

  test('concurrent sync requests collapse into one extra run', () async {
    await tasks.save(pills());
    await Future.wait([service.sync(), service.sync(), service.sync()]);
    expect(engine.calls.length, 2);
  });
}
