import 'package:equatable/equatable.dart';

/// What can stop alarms from ringing on this device.
class PermissionReport extends Equatable {
  const PermissionReport({
    this.notifications = true,
    this.exactAlarms = true,
    this.fullScreen = true,
    this.batteryUnrestricted = true,
    this.alarmChannelEnabled = true,
    this.restrictedBucket = false,
    this.wasForceStopped = false,
  });

  factory PermissionReport.fromJson(Map<Object?, Object?> json) => PermissionReport(
    notifications: json['notifications'] as bool? ?? true,
    exactAlarms: json['exactAlarms'] as bool? ?? true,
    fullScreen: json['fullScreen'] as bool? ?? true,
    batteryUnrestricted: json['batteryUnrestricted'] as bool? ?? true,
    alarmChannelEnabled: json['alarmChannelEnabled'] as bool? ?? true,
    restrictedBucket: json['restrictedBucket'] as bool? ?? false,
    wasForceStopped: json['wasForceStopped'] as bool? ?? false,
  );

  final bool notifications;
  final bool exactAlarms;
  final bool fullScreen;
  final bool batteryUnrestricted;
  final bool alarmChannelEnabled;
  final bool restrictedBucket;
  final bool wasForceStopped;

  /// Problems that break alarms outright; battery restrictions only make them less reliable.
  bool get hasCriticalIssues => !notifications || !exactAlarms || !alarmChannelEnabled;

  bool get allGood => !hasCriticalIssues && fullScreen && batteryUnrestricted && !restrictedBucket;

  @override
  List<Object?> get props => [
    notifications,
    exactAlarms,
    fullScreen,
    batteryUnrestricted,
    alarmChannelEnabled,
    restrictedBucket,
    wasForceStopped,
  ];
}
