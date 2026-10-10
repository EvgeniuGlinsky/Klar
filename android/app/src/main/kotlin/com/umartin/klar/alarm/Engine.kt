package com.umartin.klar.alarm

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.umartin.klar.alarm.core.Config
import com.umartin.klar.alarm.core.EngineCore
import com.umartin.klar.alarm.core.Event
import com.umartin.klar.alarm.core.Spec
import com.umartin.klar.alarm.core.Upcoming
import com.umartin.klar.alarm.ring.RingService
import com.umartin.klar.alarm.next.NextTaskService
import com.umartin.klar.alarm.ring.RingSession
import com.umartin.klar.channel.SoundLibrary
import java.time.ZoneId

/** Android-side entry points of the alarm engine; every state change goes through [AlarmStore]. */
object Engine {
    /** Set while the Flutter UI is attached; told when new events are waiting. */
    @Volatile
    var onEvents: (() -> Unit)? = null

    private val main = Handler(Looper.getMainLooper())

    private fun now() = System.currentTimeMillis()

    fun replaceAll(
        context: Context,
        config: Config,
        specs: List<Spec>,
        upcoming: List<Upcoming>,
        live: Map<String, String>,
        ackSeq: Long,
    ) {
        val state = AlarmStore.modify(context) {
            EngineCore.replaceAll(it, config, specs, live, ackSeq, ZoneId.systemDefault(), now(), upcoming)
        }
        Arming.rearm(context, state)
        NextTaskService.refresh(context)
        // Stop ringing or showing what the user completed or deleted in the app.
        val stale = RingSession.snapshot().filter { !it.isTest && !EngineCore.isLive(live, it) }
        if (stale.isNotEmpty()) RingService.removeKeys(context, stale.map { it.key })
        Notifier.cancelReminders(context) { spec -> !spec.isTest && !EngineCore.isLive(live, spec) }
        SoundLibrary.prune(context, state)
    }

    /** Handles everything that became due; called by the system alarm and after boot or clock changes. */
    fun onWake(context: Context) {
        val wake = AlarmStore.update(context) { state ->
            EngineCore.wake(state, ZoneId.systemDefault(), now()).let { it.state to it }
        }
        if (wake.ring.isNotEmpty()) RingService.ring(context, wake.ring.map { it.spec })
        wake.notify.forEach { Notifier.reminder(context, it.spec) }
        if (wake.missed.isNotEmpty()) Notifier.missed(context, wake.missed.map { it.spec })
        val state = wake.state
        if (EngineCore.needsNudge(state, now())) {
            Notifier.nudge(context)
            AlarmStore.modify(context) { it.copy(nudgedHorizon = it.config.horizonEnd) }
        }
        Arming.rearm(context, AlarmStore.read(context))
        NextTaskService.refresh(context)
    }

    fun onClockChanged(context: Context) {
        AlarmStore.modify(context) { EngineCore.onClockChanged(it, now()) }
    }

    fun snooze(context: Context, spec: Spec, minutes: Int? = null) {
        val state = AlarmStore.modify(context) { EngineCore.snooze(it, spec, minutes ?: it.config.snoozeMinutes, now()) }
        Arming.rearm(context, state)
    }

    fun done(context: Context, spec: Spec) {
        val state = AlarmStore.modify(context) { EngineCore.done(it, spec, now()) }
        Arming.rearm(context, state)
        Notifier.cancelReminders(context) { it.taskId == spec.taskId && it.occurrence == spec.occurrence }
        NextTaskService.refresh(context)
        onEvents?.let { callback -> main.post(callback) }
    }

    fun drainEvents(context: Context): List<Event> = AlarmStore.read(context).events

    fun testAlarm(context: Context, spec: Spec, at: Long) {
        val state = AlarmStore.modify(context) { EngineCore.schedule(it, spec, at) }
        Arming.rearm(context, state)
    }

    fun config(context: Context): Config = AlarmStore.read(context).config
}
