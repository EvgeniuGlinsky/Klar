package com.umartin.klar.alarm.next

import android.app.ForegroundServiceStartNotAllowedException
import android.app.Notification
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat
import com.umartin.klar.R
import com.umartin.klar.alarm.ActionReceiver
import com.umartin.klar.alarm.AlarmStore
import com.umartin.klar.alarm.Notifier
import com.umartin.klar.alarm.core.EngineCore
import com.umartin.klar.alarm.core.Kind
import com.umartin.klar.alarm.core.Spec
import com.umartin.klar.alarm.core.Upcoming
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Locale

/**
 * Keeps the next timed task pinned in the shade with a live countdown and a "Done" action. Being a
 * foreground service also keeps the process alive, which helps alarms on aggressive OEM builds.
 * [com.umartin.klar.alarm.Arming] wakes the engine when the task is due so the notification moves on.
 */
class NextTaskService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val next = current(this)
        // A started foreground service must always promote itself, even if it stops right away.
        val notification = next?.let { build(this, it) }
            ?: NotificationCompat.Builder(this, Notifier.CHANNEL_NEXT_TASK).setSmallIcon(R.drawable.ic_stat_klar).build()
        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE
        } else {
            0
        }
        ServiceCompat.startForeground(this, Notifier.NEXT_TASK_NOTIFICATION_ID, notification, type)
        if (next == null) {
            ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE)
            stopSelf()
            return START_NOT_STICKY
        }
        return START_STICKY
    }

    companion object {
        private const val TAG = "KlarNextTask"
        private const val COUNTDOWN_LIMIT_MS = 12 * 60 * 60_000L
        private val locale = Locale.forLanguageTag("ru")

        private fun current(context: Context): Upcoming? =
            EngineCore.nextUpcoming(AlarmStore.read(context), ZoneId.systemDefault(), System.currentTimeMillis())

        /** Shows, updates or removes the pinned notification to match the engine state. */
        fun refresh(context: Context) {
            val intent = Intent(context, NextTaskService::class.java)
            if (current(context) == null) {
                context.stopService(intent)
                NotificationManagerCompat.from(context).cancel(Notifier.NEXT_TASK_NOTIFICATION_ID)
                return
            }
            try {
                ContextCompat.startForegroundService(context, intent)
            } catch (e: Exception) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && e is ForegroundServiceStartNotAllowedException) {
                    // Not allowed from this background state: show the same content as a plain notification.
                    Log.w(TAG, "Cannot start the next-task service now", e)
                    current(context)?.let { post(context, build(context, it)) }
                } else {
                    throw e
                }
            }
        }

        private fun post(context: Context, notification: Notification) {
            if (!NotificationManagerCompat.from(context).areNotificationsEnabled()) return
            try {
                NotificationManagerCompat.from(context).notify(Notifier.NEXT_TASK_NOTIFICATION_ID, notification)
            } catch (_: SecurityException) {
            }
        }

        fun spec(upcoming: Upcoming) = Spec(
            key = "next|${upcoming.taskId}|${upcoming.occurrence}",
            taskId = upcoming.taskId,
            occurrence = upcoming.occurrence,
            trigger = upcoming.due,
            kind = Kind.NOTIFICATION,
            title = upcoming.title,
            body = upcoming.list,
        )

        /** «14:30», «Завтра, 14:30» or «пт, 17 окт., 14:30». */
        fun dueLabel(context: Context, due: LocalDateTime): String {
            val time = due.format(DateTimeFormatter.ofPattern("HH:mm"))
            return when (due.toLocalDate()) {
                LocalDate.now() -> time
                LocalDate.now().plusDays(1) -> context.getString(R.string.next_task_tomorrow, time)
                else -> "${due.format(DateTimeFormatter.ofPattern("EE, d MMM", locale))}, $time"
            }
        }

        private fun build(context: Context, upcoming: Upcoming): Notification {
            val spec = spec(upcoming)
            val dueAt = EngineCore.epochOf(upcoming.due, ZoneId.systemDefault())
            val label = dueLabel(context, upcoming.due)
            val text = listOf(label, upcoming.list).filter { it.isNotEmpty() }.joinToString(" · ")
            val countdown = dueAt - System.currentTimeMillis() < COUNTDOWN_LIMIT_MS
            val publicVersion = NotificationCompat.Builder(context, Notifier.CHANNEL_NEXT_TASK)
                .setSmallIcon(R.drawable.ic_stat_klar)
                .setContentTitle(context.getString(R.string.next_task_public, label))
                .build()
            return NotificationCompat.Builder(context, Notifier.CHANNEL_NEXT_TASK)
                .setSmallIcon(R.drawable.ic_stat_klar)
                .setColor(0xFFD9CBB3.toInt())
                .setContentTitle(upcoming.title)
                .setContentText(text)
                .setSubText(context.getString(R.string.next_task_label))
                .setWhen(dueAt)
                .setShowWhen(countdown)
                .setUsesChronometer(countdown)
                .setChronometerCountDown(countdown)
                .setOngoing(true)
                .setSilent(true)
                .setOnlyAlertOnce(true)
                .setCategory(NotificationCompat.CATEGORY_REMINDER)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setVisibility(NotificationCompat.VISIBILITY_PRIVATE)
                .setPublicVersion(publicVersion)
                .setContentIntent(Notifier.openTaskIntent(context, spec))
                .addAction(0, context.getString(R.string.action_done), Notifier.action(context, ActionReceiver.ACTION_DONE, spec))
                .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
                .build()
        }
    }
}
