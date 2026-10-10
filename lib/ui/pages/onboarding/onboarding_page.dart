import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klar/di/app_dependencies.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/pages/settings/cubit/settings_cubit.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => SettingsCubit(getIt(), getIt()),
    child: const _OnboardingView(),
  );
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
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

  Future<void> _start() async {
    final router = GoRouter.of(context);
    await context.read<SettingsCubit>().update((s) => s.copyWith(onboarded: true));
    router.go('/today');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final cubit = context.read<SettingsCubit>();
    final report = context.watch<SettingsCubit>().state.report;
    final steps = [
      (
        KlarIcons.bell,
        l10n.onboardingNotifications,
        report?.notifications ?? false,
        SettingsTarget.notifications,
      ),
      (KlarIcons.alarm, l10n.onboardingFullScreen, report?.fullScreen ?? false, SettingsTarget.fullScreen),
      (
        KlarIcons.batteryHigh,
        l10n.onboardingBattery,
        report?.batteryUnrestricted ?? false,
        SettingsTarget.battery,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: KlarDimens.gutter + 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 36,
                height: 3,
                decoration: BoxDecoration(color: KlarColors.birch, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.appTitle,
                style: KlarTypography.display.copyWith(fontSize: 56, letterSpacing: -1.5, height: 1),
              ),
              const SizedBox(height: 16),
              Text(l10n.onboardingTagline, style: KlarTypography.title),
              const SizedBox(height: 16),
              Text(l10n.onboardingBody, style: KlarTypography.bodyMuted.copyWith(fontSize: 15)),
              const Spacer(),
              for (final (icon, title, granted, target) in steps)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(icon, size: 24, color: granted ? KlarColors.sage : KlarColors.textMuted),
                      const SizedBox(width: 16),
                      Expanded(child: Text(title, style: KlarTypography.body)),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: granted
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(KlarIcons.check, color: KlarColors.sage),
                              )
                            : TextButton(onPressed: () => cubit.fix(target), child: Text(l10n.onboardingAllow)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: _start, child: Text(l10n.onboardingStart)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
