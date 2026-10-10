package com.umartin.klar.channel

import android.app.ActivityManager
import android.app.NotificationManager
import android.app.usage.UsageStatsManager
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import com.umartin.klar.alarm.Arming
import com.umartin.klar.alarm.Notifier

/** What can keep alarms from ringing, and shortcuts to the system screens that fix it. */
object PermissionsReport {
    fun build(context: Context): Map<String, Boolean> {
        val notifications = NotificationManagerCompat.from(context)
        val alarmChannel = notifications.getNotificationChannel(Notifier.CHANNEL_ALARM)
        return mapOf(
            "notifications" to notifications.areNotificationsEnabled(),
            "exactAlarms" to Arming.canScheduleExact(context),
            "fullScreen" to (
                Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE ||
                    context.getSystemService(NotificationManager::class.java).canUseFullScreenIntent()
                ),
            "batteryUnrestricted" to context.getSystemService(PowerManager::class.java)
                .isIgnoringBatteryOptimizations(context.packageName),
            "alarmChannelEnabled" to (alarmChannel == null || alarmChannel.importance != NotificationManager.IMPORTANCE_NONE),
            "restrictedBucket" to (
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.R &&
                    context.getSystemService(UsageStatsManager::class.java).appStandbyBucket ==
                    UsageStatsManager.STANDBY_BUCKET_RESTRICTED
                ),
            "wasForceStopped" to wasForceStopped(context),
        )
    }

    private fun wasForceStopped(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.VANILLA_ICE_CREAM) return false
        return runCatching {
            context.getSystemService(ActivityManager::class.java)
                .getHistoricalProcessStartReasons(1)
                .firstOrNull()
                ?.wasForceStopped() == true
        }.getOrDefault(false)
    }

    fun open(context: Context, target: String) {
        val packageUri = Uri.parse("package:${context.packageName}")
        val intent = when (target) {
            "notifications" -> Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                .putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
            "exactAlarms" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM, packageUri)
            } else {
                null
            }
            "fullScreen" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT, packageUri)
            } else {
                null
            }
            "battery" -> Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, packageUri)
            "reminderChannel" -> Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS)
                .putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
                .putExtra(Settings.EXTRA_CHANNEL_ID, Notifier.CHANNEL_REMINDERS)
            else -> null
        } ?: Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, packageUri)
        try {
            context.startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
        } catch (_: ActivityNotFoundException) {
            context.startActivity(
                Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, packageUri).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
            )
        }
    }
}
