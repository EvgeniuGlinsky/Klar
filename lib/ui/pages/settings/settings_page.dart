import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klar/di/app_dependencies.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/features/settings/domain/models/app_settings.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/helpers/formatters.dart';
import 'package:klar/ui/pages/settings/cubit/settings_cubit.dart';
import 'package:klar/ui/pages/settings/widgets/reliability_card.dart';
import 'package:klar/ui/pages/settings/widgets/sound_picker_sheet.dart';
import 'package:klar/ui/pages/settings/widgets/vibration_picker_sheet.dart';
import 'package:klar/ui/pages/task_editor/widgets/date_sheet.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';
import 'package:klar/ui/widgets/klar_choices.dart';
import 'package:klar/ui/widgets/klar_row.dart';
import 'package:klar/ui/widgets/page_header.dart';
import 'package:klar/ui/widgets/section_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => SettingsCubit(getIt(), getIt()),
    child: const _SettingsView(),
  );
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: () => context.read<SettingsCubit>().refreshReport());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final cubit = context.read<SettingsCubit>();
    final state = context.watch<SettingsCubit>().state;
    final s = state.settings;

    Widget label(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(KlarDimens.gutter + 38, 4, KlarDimens.gutter, 10),
      child: Text(text, style: KlarTypography.meta),
    );

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 48),
        children: [
          PageHeader(title: l10n.settingsTitle),
          SectionHeader(l10n.sectionAlarm),
          KlarRow(
            icon: KlarIcons.musicNote,
            title: l10n.settingSound,
            value: soundTitle(l10n, s.sound),
            onTap: () async {
              final selection = await showSoundPicker(context, current: s.sound);
              final sound = selection?.sound;
              if (sound != null) await cubit.update((x) => x.copyWith(sound: sound));
            },
          ),
          KlarRow(
            icon: KlarIcons.vibrate,
            title: l10n.settingVibration,
            value: formatVibration(l10n, s.vibration),
            onTap: () async {
              final selection = await showVibrationPicker(context, current: s.vibration);
              final pattern = selection?.pattern;
              if (pattern != null) await cubit.update((x) => x.copyWith(vibration: pattern));
            },
          ),
          KlarRow(
            icon: KlarIcons.speakerHigh,
            title: l10n.settingVolume,
            subtitle: s.minVolume == null ? l10n.volumeSystemHint : l10n.volumeAtLeast(s.minVolume!),
            trailing: Switch(
              value: s.minVolume != null,
              onChanged: (on) => cubit.update((x) => x.copyWith(minVolume: () => on ? 70 : null)),
            ),
          ),
          if (s.minVolume != null)
            Padding(
              padding: const EdgeInsets.only(left: KlarDimens.gutter + 22, right: KlarDimens.gutter - 8),
              child: Slider(
                value: s.minVolume!.toDouble(),
                min: 20,
                max: 100,
                divisions: 8,
                label: '${s.minVolume}%',
                onChanged: (v) => cubit.update((x) => x.copyWith(minVolume: () => v.round())),
              ),
            ),
          const SizedBox(height: 8),
          KlarRow(icon: KlarIcons.waveform, title: l10n.settingRamp),
          KlarChoices(
            padding: const EdgeInsets.only(left: KlarDimens.gutter + 38, right: KlarDimens.gutter, bottom: 12),
            values: AppSettings.rampOptions,
            selected: s.rampSeconds,
            label: (v) => v == 0 ? l10n.rampOff : l10n.seconds(v),
            onSelected: (v) => cubit.update((x) => x.copyWith(rampSeconds: v)),
          ),
          KlarRow(icon: KlarIcons.timer, title: l10n.settingSnooze),
          KlarChoices(
            padding: const EdgeInsets.only(left: KlarDimens.gutter + 38, right: KlarDimens.gutter, bottom: 12),
            values: AppSettings.snoozeOptions,
            selected: s.snoozeMinutes,
            label: l10n.minutes,
            onSelected: (v) => cubit.update((x) => x.copyWith(snoozeMinutes: v)),
          ),
          KlarRow(icon: KlarIcons.speakerSlash, title: l10n.settingAutoSilence),
          KlarChoices(
            padding: const EdgeInsets.only(left: KlarDimens.gutter + 38, right: KlarDimens.gutter, bottom: 16),
            values: AppSettings.autoSilenceOptions,
            selected: s.autoSilenceMinutes,
            label: l10n.minutes,
            onSelected: (v) => cubit.update((x) => x.copyWith(autoSilenceMinutes: v)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: KlarDimens.gutter, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await cubit.testAlarm();
                messenger.showSnackBar(SnackBar(content: Text(l10n.testAlarmScheduled)));
              },
              icon: const Icon(KlarIcons.bellRinging, size: 20),
              label: Text(l10n.testAlarm),
            ),
          ),
          label(l10n.testAlarmHint),
          SectionHeader(l10n.sectionTasks),
          KlarRow(
            icon: KlarIcons.sun,
            title: l10n.settingAllDayTime,
            value: formatTime(s.allDayMinutes),
            onTap: () async {
              final minutes = await pickTime(context, initial: s.allDayMinutes);
              if (minutes != null) await cubit.update((x) => x.copyWith(allDayMinutes: minutes));
            },
          ),
          SectionHeader(l10n.sectionNotifications),
          KlarRow(
            icon: KlarIcons.pushPin,
            title: l10n.settingPinNext,
            subtitle: l10n.settingPinNextHint,
            trailing: Switch(
              value: s.pinNextTask,
              onChanged: (on) => cubit.update((x) => x.copyWith(pinNextTask: on)),
            ),
          ),
          KlarRow(
            icon: KlarIcons.bell,
            title: l10n.settingNotificationSound,
            subtitle: l10n.settingNotificationSoundHint,
            trailing: const Icon(KlarIcons.arrowUpRight, size: 16, color: KlarColors.textFaint),
            onTap: () => cubit.openSettings(SettingsTarget.reminderChannel),
          ),
          SectionHeader(l10n.sectionReliability),
          if (state.report != null) ReliabilityCard(report: state.report!, onFix: cubit.fix),
          const SizedBox(height: 32),
          Center(
            child: Text('Klar 1.0', style: KlarTypography.meta.copyWith(color: KlarColors.textFaint)),
          ),
        ],
      ),
    );
  }
}
