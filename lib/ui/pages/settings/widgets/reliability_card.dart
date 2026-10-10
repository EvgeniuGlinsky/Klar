import 'package:flutter/material.dart';
import 'package:klar/features/alarms/domain/models/permission_report.dart';
import 'package:klar/features/alarms/domain/repos/alarm_engine.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';

/// Shows everything that can stop alarms from ringing, with a shortcut to fix each item.
class ReliabilityCard extends StatelessWidget {
  const ReliabilityCard({required this.report, required this.onFix, super.key});

  final PermissionReport report;
  final ValueChanged<SettingsTarget> onFix;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final items = [
      (l10n.permNotifications, l10n.permNotificationsHint, report.notifications, SettingsTarget.notifications),
      (l10n.permExactAlarms, l10n.permExactAlarmsHint, report.exactAlarms, SettingsTarget.exactAlarms),
      (l10n.permFullScreen, l10n.permFullScreenHint, report.fullScreen, SettingsTarget.fullScreen),
      (l10n.permBattery, l10n.permBatteryHint, report.batteryUnrestricted, SettingsTarget.battery),
      if (!report.alarmChannelEnabled)
        (l10n.permAlarmChannel, l10n.permAlarmChannelHint, false, SettingsTarget.notifications),
      if (report.restrictedBucket) (l10n.permRestricted, l10n.permRestrictedHint, false, SettingsTarget.battery),
    ];
    final allGood = report.allGood;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: KlarColors.surface,
          borderRadius: BorderRadius.circular(KlarDimens.radius),
          border: Border.all(color: KlarColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    allGood ? KlarIcons.checkCircle : KlarIcons.warning,
                    color: allGood ? KlarColors.sage : KlarColors.clay,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      allGood ? l10n.reliabilityAllGood : l10n.reliabilityIssues,
                      style: KlarTypography.body.copyWith(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            if (report.wasForceStopped)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(l10n.forceStoppedBanner, style: KlarTypography.meta.copyWith(color: KlarColors.clay)),
              ),
            const Divider(),
            for (final (title, hint, ok, target) in items)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: ok ? KlarColors.sage : KlarColors.lingon,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: KlarTypography.body.copyWith(fontSize: 15)),
                          Text(hint, style: KlarTypography.meta),
                        ],
                      ),
                    ),
                    if (!ok) TextButton(onPressed: () => onFix(target), child: Text(l10n.permFix)),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Text(l10n.oemHint, style: KlarTypography.meta.copyWith(color: KlarColors.textFaint)),
            ),
          ],
        ),
      ),
    );
  }
}
