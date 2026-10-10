package com.umartin.klar.alarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import com.umartin.klar.MainActivity
import com.umartin.klar.alarm.core.Due
import com.umartin.klar.alarm.core.EngineCore
import com.umartin.klar.alarm.core.EngineState
import com.umartin.klar.alarm.core.Kind
import java.time.ZoneId

/**
 * Arms at most two system alarms: the next ringing alarm via `setAlarmClock` (exact, exempt from Doze,
 * shown as "next alarm") and the next reminder notification via `setExactAndAllowWhileIdle`.
 * The full schedule lives in [AlarmStore], so the 500-alarms-per-app limit never applies.
 */
object Arming {
    private const val TAG = "KlarArming"
    private const val SLOT_ALARM = 1
    private const val SLOT_NOTIFICATION = 2
    private const val SLOT_NEXT_TASK = 3

    fun rearm(context: Context, state: EngineState) {
        val zone = ZoneId.systemDefault()
        arm(context, SLOT_ALARM, EngineCore.next(state, zone, Kind.ALARM))
        arm(context, SLOT_NOTIFICATION, EngineCore.next(state, zone, Kind.NOTIFICATION))
        // Moves the pinned notification on once its task is due.
        armAt(context, SLOT_NEXT_TASK, EngineCore.nextUpcoming(state, zone, System.currentTimeMillis())?.let {
            EngineCore.epochOf(it.due, zone) + 1000
        })
    }

    fun canScheduleExact(context: Context): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarmManager(context).canScheduleExactAlarms()

    private fun arm(context: Context, slot: Int, due: Due?) {
        val manager = alarmManager(context)
        val operation = wakeIntent(context, slot)
        if (due == null) {
            manager.cancel(operation)
            return
        }
        try {
            when {
                !canScheduleExact(context) -> manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, due.at, operation)
                slot == SLOT_ALARM -> manager.setAlarmClock(AlarmManager.AlarmClockInfo(due.at, showIntent(context)), operation)
                else -> manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, due.at, operation)
            }
        } catch (e: SecurityException) {
            Log.w(TAG, "Exact alarms not allowed, falling back to inexact", e)
            manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, due.at, operation)
        }
    }

    private fun armAt(context: Context, slot: Int, at: Long?) {
        val manager = alarmManager(context)
        val operation = wakeIntent(context, slot)
        when {
            at == null -> manager.cancel(operation)
            canScheduleExact(context) -> manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, operation)
            else -> manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, operation)
        }
    }

    private fun wakeIntent(context: Context, slot: Int): PendingIntent = PendingIntent.getBroadcast(
        context,
        slot,
        Intent(context, AlarmReceiver::class.java).setAction(AlarmReceiver.ACTION_WAKE),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

    private fun showIntent(context: Context): PendingIntent = PendingIntent.getActivity(
        context,
        0,
        Intent(context, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

    private fun alarmManager(context: Context) = context.getSystemService(AlarmManager::class.java)
}
