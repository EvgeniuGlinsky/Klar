package com.umartin.klar.alarm.core

import java.time.LocalDateTime
import java.time.ZoneId

/** Pure scheduling logic of the alarm engine; no Android dependencies so it runs in JVM tests. */
object EngineCore {
    /** Signals that were due up to this long ago still ring (e.g. right after a reboot); older ones are "missed". */
    const val RING_WINDOW_MS = 30 * 60_000L

    /** How long before the horizon ends the user is asked to open the app. */
    const val NUDGE_BEFORE_MS = 7 * 24 * 60 * 60_000L

    fun epochOf(trigger: LocalDateTime, zone: ZoneId): Long = trigger.atZone(zone).toInstant().toEpochMilli()

    fun isDone(state: EngineState, spec: Spec) =
        state.done.any { it.taskId == spec.taskId && it.occurrence == spec.occurrence }

    /** Every not yet handled signal: planned specs and snoozes, minus occurrences marked done. */
    fun pending(state: EngineState, zone: ZoneId): Sequence<Due> {
        val specs = state.specs.asSequence().map { Due(it, epochOf(it.trigger, zone), snoozed = false) }
        val snoozes = state.snoozes.asSequence().map { Due(it.spec, it.at, snoozed = true) }
        return (specs + snoozes).filter { it.at > state.watermark && !isDone(state, it.spec) }
    }

    fun next(state: EngineState, zone: ZoneId, kind: Kind): Due? =
        pending(state, zone).filter { it.spec.kind == kind }.minByOrNull { it.at }

    data class Wake(val ring: List<Due>, val notify: List<Due>, val missed: List<Due>, val state: EngineState)

    /**
     * Collects everything that became due since the last wake. Several reminders of the same occurrence
     * collapse into one signal; an alarm wins over a notification.
     */
    fun wake(state: EngineState, zone: ZoneId, now: Long): Wake {
        if (state.watermark == 0L) return Wake(emptyList(), emptyList(), emptyList(), state.copy(watermark = now))
        val due = pending(state, zone).filter { it.at <= now }.toList()
        val (fresh, missed) = due.partition { now - it.at <= RING_WINDOW_MS }
        val collapsed = fresh
            .groupBy { it.spec.taskId to it.spec.occurrence }
            .values
            .map { group -> group.filter { it.spec.kind == Kind.ALARM }.maxByOrNull { it.at } ?: group.maxBy { it.at } }
            .sortedBy { it.at }
        val missedCollapsed = missed
            .filter { m -> collapsed.none { it.spec.taskId == m.spec.taskId && it.spec.occurrence == m.spec.occurrence } }
            .distinctBy { it.spec.taskId to it.spec.occurrence }
        val next = state.copy(
            watermark = now,
            specs = state.specs.filter { epochOf(it.trigger, zone) > now },
            snoozes = state.snoozes.filter { it.at > now },
        )
        return Wake(
            ring = collapsed.filter { it.spec.kind == Kind.ALARM },
            notify = collapsed.filter { it.spec.kind == Kind.NOTIFICATION },
            missed = missedCollapsed,
            state = next,
        )
    }

    /**
     * Replaces the plan. Events and done marks up to [ackSeq] are dropped since Flutter applied them.
     * Snoozes survive only while their task is live and the occurrence is not older than its due date.
     */
    fun replaceAll(
        state: EngineState,
        config: Config,
        specs: List<Spec>,
        live: Map<String, String>,
        ackSeq: Long,
        zone: ZoneId,
        now: Long,
        upcoming: List<Upcoming> = emptyList(),
    ): EngineState {
        val watermark = if (state.watermark == 0L) now else state.watermark
        return state.copy(
            config = config,
            specs = specs.filter { epochOf(it.trigger, zone) > watermark }.sortedBy { it.trigger },
            upcoming = upcoming.sortedBy { it.due },
            live = live,
            snoozes = state.snoozes.filter { it.spec.isTest || isLive(live, it.spec) },
            done = state.done.filter { it.seq > ackSeq },
            events = state.events.filter { it.seq > ackSeq },
            watermark = watermark,
        )
    }

    fun isLive(live: Map<String, String>, spec: Spec): Boolean {
        val due = live[spec.taskId] ?: return false
        return due.isEmpty() || spec.occurrence >= due
    }

    fun snooze(state: EngineState, spec: Spec, minutes: Int, now: Long): EngineState = state.copy(
        snoozes = state.snoozes.filter { it.spec.key != spec.key } + Snooze(spec, now + minutes * 60_000L),
    )

    fun schedule(state: EngineState, spec: Spec, at: Long): EngineState =
        state.copy(snoozes = state.snoozes.filter { it.spec.key != spec.key } + Snooze(spec, at))

    /** Marks the occurrence done and records an event for Flutter. Test alarms record nothing. */
    fun done(state: EngineState, spec: Spec, now: Long): EngineState {
        val remaining = state.snoozes.filter { !(it.spec.taskId == spec.taskId && it.spec.occurrence == spec.occurrence) }
        if (spec.isTest) return state.copy(snoozes = remaining)
        val seq = state.nextSeq
        return state.copy(
            snoozes = remaining,
            done = state.done + DoneMark(spec.taskId, spec.occurrence, seq),
            events = state.events + Event(seq, spec.taskId, spec.occurrence, now),
            nextSeq = seq + 1,
        )
    }

    /** The next timed task still ahead of [now] and not marked done, if the pinned notification is on. */
    fun nextUpcoming(state: EngineState, zone: ZoneId, now: Long): Upcoming? {
        if (!state.config.pinNext) return null
        return state.upcoming.firstOrNull { u ->
            epochOf(u.due, zone) > now && state.done.none { it.taskId == u.taskId && it.occurrence == u.occurrence }
        }
    }

    /** The clock moved backwards: never leave the watermark in the future. */
    fun onClockChanged(state: EngineState, now: Long): EngineState =
        if (state.watermark > now) state.copy(watermark = now) else state

    fun needsNudge(state: EngineState, now: Long): Boolean {
        val end = state.config.horizonEnd
        return end > 0 && now > end - NUDGE_BEFORE_MS && state.nudgedHorizon != end
    }
}
