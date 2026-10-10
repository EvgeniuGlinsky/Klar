package com.umartin.klar.alarm

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.umartin.klar.MainActivity
import com.umartin.klar.R
import com.umartin.klar.alarm.core.Spec
import org.json.JSONObject

object Notifier {
    /** High importance, silent: [com.umartin.klar.alarm.ring.RingService] plays sound and vibration itself. */
    const val CHANNEL_ALARM = "alarm_ring_v1"
    const val CHANNEL_REMINDERS = "reminders_v1"
    private const val CHANNEL_MISSED = "missed_v1"
    const val CHANNEL_NEXT_TASK = "next_task_v1"

    const val RING_NOTIFICATION_ID = 1001
    private const val NUDGE_NOTIFICATION_ID = 1002
    private const val MISSED_SUMMARY_ID = 1003
    const val NEXT_TASK_NOTIFICATION_ID = 1005
    private const val GROUP_MISSED = "missed"

    private const val COLOR_ACCENT = 0xFFD9CBB3.toInt()

    fun ensureChannels(context: Context) {
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.createNotificationChannels(
            listOf(
                NotificationChannel(CHANNEL_ALARM, context.getString(R.string.channel_alarms), NotificationManager.IMPORTANCE_HIGH)
                    .apply {
                        description = context.getString(R.string.channel_alarms_description)
                        setSound(null, null)
                        enableVibration(false)
                        lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                    },
                NotificationChannel(
                    CHANNEL_REMINDERS,
                    context.getString(R.string.channel_reminders),
                    NotificationManager.IMPORTANCE_HIGH,
                ).apply { description = context.getString(R.string.channel_reminders_description) },
                NotificationChannel(CHANNEL_MISSED, context.getString(R.string.channel_missed), NotificationManager.IMPORTANCE_DEFAULT),
                NotificationChannel(CHANNEL_NEXT_TASK, context.getString(R.string.channel_next_task), NotificationManager.IMPORTANCE_LOW)
                    .apply {
                        description = context.getString(R.string.channel_next_task_description)
                        setShowBadge(false)
                    },
            ),
        )
    }

    fun canNotify(context: Context): Boolean {
        val manager = NotificationManagerCompat.from(context)
        if (!manager.areNotificationsEnabled()) return false
        val channel = manager.getNotificationChannel(CHANNEL_ALARM) ?: return true
        return channel.importance != NotificationManager.IMPORTANCE_NONE
    }

    /** Opens the app on the task. */
    fun openTaskIntent(context: Context, spec: Spec): PendingIntent = PendingIntent.getActivity(
        context,
        spec.key.hashCode(),
        Intent(context, MainActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            .putExtra(MainActivity.EXTRA_TASK_ID, spec.taskId),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

    fun action(context: Context, action: String, spec: Spec, minutes: Int? = null): PendingIntent = PendingIntent.getBroadcast(
        context,
        (action + spec.key + (minutes ?: 0)).hashCode(),
        Intent(context, ActionReceiver::class.java)
            .setAction(action)
            .putExtra(ActionReceiver.EXTRA_SPEC, Codec.spec(spec).toString())
            .apply { minutes?.let { putExtra(ActionReceiver.EXTRA_MINUTES, it) } },
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

    private fun specExtras(spec: Spec) = Bundle().apply { putString(ActionReceiver.EXTRA_SPEC, Codec.spec(spec).toString()) }

    fun reminder(context: Context, spec: Spec) {
        ensureChannels(context)
        val snoozeMinutes = Engine.config(context).snoozeMinutes
        val notification = NotificationCompat.Builder(context, CHANNEL_REMINDERS)
            .setSmallIcon(R.drawable.ic_stat_klar)
            .setColor(COLOR_ACCENT)
            .setContentTitle(spec.title)
            .setContentText(spec.body)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(openTaskIntent(context, spec))
            .addAction(0, context.getString(R.string.action_done), action(context, ActionReceiver.ACTION_DONE, spec))
            .addAction(
                0,
                context.getString(R.string.action_snooze, snoozeMinutes),
                action(context, ActionReceiver.ACTION_SNOOZE, spec, snoozeMinutes),
            )
            .addExtras(specExtras(spec))
            .build()
        notify(context, spec.key.hashCode(), notification)
    }

    fun missed(context: Context, specs: List<Spec>) {
        ensureChannels(context)
        specs.forEach { spec ->
            val notification = NotificationCompat.Builder(context, CHANNEL_MISSED)
                .setSmallIcon(R.drawable.ic_stat_klar)
                .setColor(COLOR_ACCENT)
                .setContentTitle(spec.title)
                .setContentText(context.getString(R.string.missed_body, spec.body))
                .setCategory(NotificationCompat.CATEGORY_REMINDER)
                .setGroup(GROUP_MISSED)
                .setAutoCancel(true)
                .setContentIntent(openTaskIntent(context, spec))
                .addAction(0, context.getString(R.string.action_done), action(context, ActionReceiver.ACTION_DONE, spec))
                .addExtras(specExtras(spec))
                .build()
            notify(context, spec.key.hashCode(), notification)
        }
        if (specs.size > 1) {
            val summary = NotificationCompat.Builder(context, CHANNEL_MISSED)
                .setSmallIcon(R.drawable.ic_stat_klar)
                .setColor(COLOR_ACCENT)
                .setContentTitle(context.getString(R.string.missed_title))
                .setGroup(GROUP_MISSED)
                .setGroupSummary(true)
                .setAutoCancel(true)
                .build()
            notify(context, MISSED_SUMMARY_ID, summary)
        }
    }

    fun nudge(context: Context) {
        ensureChannels(context)
        val open = PendingIntent.getActivity(
            context,
            NUDGE_NOTIFICATION_ID,
            Intent(context, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val notification = NotificationCompat.Builder(context, CHANNEL_MISSED)
            .setSmallIcon(R.drawable.ic_stat_klar)
            .setColor(COLOR_ACCENT)
            .setContentTitle(context.getString(R.string.nudge_title))
            .setContentText(context.getString(R.string.nudge_body))
            .setAutoCancel(true)
            .setContentIntent(open)
            .build()
        notify(context, NUDGE_NOTIFICATION_ID, notification)
    }

    fun cancel(context: Context, spec: Spec) = NotificationManagerCompat.from(context).cancel(spec.key.hashCode())

    /** Cancels posted reminder and missed notifications whose spec matches [predicate]. */
    fun cancelReminders(context: Context, predicate: (Spec) -> Boolean) {
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.activeNotifications
            .filter { it.id != RING_NOTIFICATION_ID && it.id != NEXT_TASK_NOTIFICATION_ID }
            .forEach { posted ->
                val json = posted.notification.extras.getString(ActionReceiver.EXTRA_SPEC) ?: return@forEach
                val spec = runCatching { Codec.spec(JSONObject(json)) }.getOrNull() ?: return@forEach
                if (predicate(spec)) manager.cancel(posted.id)
            }
    }

    private fun notify(context: Context, id: Int, notification: Notification) {
        if (!NotificationManagerCompat.from(context).areNotificationsEnabled()) return
        try {
            NotificationManagerCompat.from(context).notify(id, notification)
        } catch (_: SecurityException) {
            // POST_NOTIFICATIONS revoked between the check and the call.
        }
    }
}
