package com.umartin.klar.alarm.core

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.LocalDateTime
import java.time.ZoneId

class EngineCoreTest {
    private val zone = ZoneId.of("Europe/Berlin")

    private fun at(iso: String) = EngineCore.epochOf(LocalDateTime.parse(iso), zone)

    private fun spec(
        task: String = "t",
        reminder: String = "r",
        occurrence: String = "2026-10-10",
        trigger: String = "2026-10-10T18:00",
        kind: Kind = Kind.ALARM,
    ) = Spec("$task|$reminder|$occurrence", task, occurrence, LocalDateTime.parse(trigger), kind, "Task $task", "")

    private fun planned(vararg specs: Spec, now: String = "2026-10-10T12:00", live: Map<String, String>? = null) =
        EngineCore.replaceAll(
            EngineState(),
            Config(),
            specs.toList(),
            live ?: specs.associate { it.taskId to it.occurrence },
            ackSeq = 0,
            zone = zone,
            now = at(now),
        )

    @Test
    fun `next picks the earliest pending signal per kind`() {
        val state = planned(
            spec(reminder = "a", trigger = "2026-10-10T18:00"),
            spec(reminder = "b", trigger = "2026-10-10T17:45", kind = Kind.NOTIFICATION),
            spec(task = "u", trigger = "2026-10-10T16:00"),
        )
        assertEquals("u", EngineCore.next(state, zone, Kind.ALARM)!!.spec.taskId)
        assertEquals(at("2026-10-10T17:45"), EngineCore.next(state, zone, Kind.NOTIFICATION)!!.at)
    }

    @Test
    fun `the first plan sets the watermark so past signals never ring`() {
        val state = planned(spec(trigger = "2026-10-10T11:58"), now = "2026-10-10T12:00")
        assertEquals(at("2026-10-10T12:00"), state.watermark)
        assertNull(EngineCore.next(state, zone, Kind.ALARM))
    }

    @Test
    fun `wake rings once per occurrence and prefers the alarm`() {
        val state = planned(
            spec(reminder = "early", trigger = "2026-10-10T17:45", kind = Kind.NOTIFICATION),
            spec(reminder = "atTime", trigger = "2026-10-10T18:00"),
        )
        val wake = EngineCore.wake(state, zone, at("2026-10-10T18:00"))
        assertEquals(listOf("t|atTime|2026-10-10"), wake.ring.map { it.spec.key })
        assertTrue(wake.notify.isEmpty())
        assertTrue(wake.state.specs.isEmpty())
        assertEquals(at("2026-10-10T18:00"), wake.state.watermark)
    }

    @Test
    fun `signals older than the ring window are reported as missed`() {
        val state = planned(spec(task = "old", trigger = "2026-10-10T13:00"), spec(task = "new", trigger = "2026-10-10T14:50"))
        val wake = EngineCore.wake(state, zone, at("2026-10-10T15:00"))
        assertEquals(listOf("new"), wake.ring.map { it.spec.taskId })
        assertEquals(listOf("old"), wake.missed.map { it.spec.taskId })
    }

    @Test
    fun `done filters other reminders of the occurrence until acknowledged`() {
        val first = spec(reminder = "a", trigger = "2026-10-10T17:45")
        val second = spec(reminder = "b", trigger = "2026-10-10T18:00")
        var state = planned(first, second)
        state = EngineCore.done(state, first, at("2026-10-10T17:46"))
        assertNull(EngineCore.next(state, zone, Kind.ALARM))
        assertEquals(1, state.events.single().seq)

        // A stale plan sent before Flutter applied the event must not resurrect the alarm.
        state = EngineCore.replaceAll(state, Config(), listOf(second), mapOf("t" to "2026-10-10"), 0, zone, at("2026-10-10T17:47"))
        assertNull(EngineCore.next(state, zone, Kind.ALARM))

        state = EngineCore.replaceAll(state, Config(), emptyList(), emptyMap(), ackSeq = 1, zone = zone, now = at("2026-10-10T17:48"))
        assertTrue(state.done.isEmpty())
        assertTrue(state.events.isEmpty())
    }

    @Test
    fun `snoozes survive a new plan only while the task is live`() {
        val ringing = spec(trigger = "2026-10-10T18:00")
        var state = EngineCore.wake(planned(ringing), zone, at("2026-10-10T18:00")).state
        state = EngineCore.snooze(state, ringing, 10, at("2026-10-10T18:00"))
        assertEquals(at("2026-10-10T18:10"), EngineCore.next(state, zone, Kind.ALARM)!!.at)

        val kept = EngineCore.replaceAll(state, Config(), emptyList(), mapOf("t" to "2026-10-10"), 0, zone, at("2026-10-10T18:01"))
        assertEquals(1, kept.snoozes.size)

        val advanced = EngineCore.replaceAll(state, Config(), emptyList(), mapOf("t" to "2026-10-11"), 0, zone, at("2026-10-10T18:01"))
        assertTrue(advanced.snoozes.isEmpty())

        val deleted = EngineCore.replaceAll(state, Config(), emptyList(), emptyMap(), 0, zone, at("2026-10-10T18:01"))
        assertTrue(deleted.snoozes.isEmpty())
    }

    @Test
    fun `wall-clock triggers follow the zone at arming time`() {
        val state = planned(spec(occurrence = "2026-10-11", trigger = "2026-10-11T18:00"))
        val tokyo = ZoneId.of("Asia/Tokyo")
        val due = EngineCore.next(state, tokyo, Kind.ALARM)!!
        assertEquals(EngineCore.epochOf(LocalDateTime.parse("2026-10-11T18:00"), tokyo), due.at)
    }

    @Test
    fun `a trigger inside the spring-forward gap rings right after the gap`() {
        val state = planned(spec(occurrence = "2026-03-29", trigger = "2026-03-29T02:30"), now = "2026-03-28T12:00")
        val due = EngineCore.next(state, zone, Kind.ALARM)!!
        assertEquals(at("2026-03-29T03:30"), due.at)
    }

    @Test
    fun `clock moved back pulls the watermark to now`() {
        val state = planned(spec(trigger = "2026-10-10T18:00"), now = "2026-10-10T17:00")
        val moved = EngineCore.onClockChanged(state, at("2026-10-10T16:00"))
        assertEquals(at("2026-10-10T16:00"), moved.watermark)
        assertEquals(state, EngineCore.onClockChanged(state, at("2026-10-10T17:30")))
    }

    @Test
    fun `test alarms record no events and survive plans`() {
        val test = spec(task = "${Spec.TEST_TASK_PREFIX}1", trigger = "2026-10-10T12:00")
        var state = EngineCore.schedule(planned(), test, at("2026-10-10T12:00") + 10_000)
        state = EngineCore.replaceAll(state, Config(), emptyList(), emptyMap(), 0, zone, at("2026-10-10T12:00"))
        assertEquals(1, state.snoozes.size)
        assertTrue(EngineCore.done(state, test, at("2026-10-10T12:01")).events.isEmpty())
    }

    @Test
    fun `next upcoming skips past and done occurrences and respects the setting`() {
        val upcoming = listOf(
            Upcoming("a", "2026-10-10", LocalDateTime.parse("2026-10-10T11:00"), "A", ""),
            Upcoming("b", "2026-10-10", LocalDateTime.parse("2026-10-10T13:00"), "B", ""),
            Upcoming("c", "2026-10-10", LocalDateTime.parse("2026-10-10T15:00"), "C", ""),
        )
        var state = EngineCore.replaceAll(EngineState(), Config(), emptyList(), emptyMap(), 0, zone, at("2026-10-10T12:00"), upcoming)
        assertEquals("b", EngineCore.nextUpcoming(state, zone, at("2026-10-10T12:00"))!!.taskId)

        state = EngineCore.done(state, spec(task = "b"), at("2026-10-10T12:01"))
        assertEquals("c", EngineCore.nextUpcoming(state, zone, at("2026-10-10T12:01"))!!.taskId)

        state = state.copy(config = Config(pinNext = false))
        assertNull(EngineCore.nextUpcoming(state, zone, at("2026-10-10T12:01")))
    }

    @Test
    fun `nudge fires once per horizon`() {
        val end = at("2026-10-20T00:00")
        val state = EngineState(config = Config(horizonEnd = end))
        assertFalse(EngineCore.needsNudge(state, at("2026-10-10T00:00")))
        assertTrue(EngineCore.needsNudge(state, at("2026-10-15T00:00")))
        assertFalse(EngineCore.needsNudge(state.copy(nudgedHorizon = end), at("2026-10-15T00:00")))
    }
}
