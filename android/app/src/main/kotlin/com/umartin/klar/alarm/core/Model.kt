package com.umartin.klar.alarm.core

import java.time.LocalDateTime

enum class Kind { ALARM, NOTIFICATION }

/** A sound the engine can resolve: `system`, `bundled` (res/raw), `file` (copied into app storage) or `silent`. */
data class SoundRef(val type: String, val id: String = "", val title: String = "") {
    companion object {
        val SYSTEM = SoundRef("system")
        val FJORD = SoundRef("bundled", "klar_fjord", "Fjord")
    }
}

/** One planned signal, as sent by Flutter. [trigger] is wall-clock time, resolved in the current zone when armed. */
data class Spec(
    val key: String,
    val taskId: String,
    val occurrence: String,
    val trigger: LocalDateTime,
    val kind: Kind,
    val title: String,
    val body: String,
    val sound: SoundRef? = null,
    val vibration: String? = null,
) {
    val isTest get() = taskId.startsWith(TEST_TASK_PREFIX)

    companion object {
        const val TEST_TASK_PREFIX = "__test__"
    }
}

data class Config(
    val sound: SoundRef = SoundRef.FJORD,
    val vibration: String = "standard",
    val minVolume: Int? = null,
    val rampSeconds: Int = 30,
    val snoozeMinutes: Int = 10,
    val autoSilenceMinutes: Int = 10,
    /** Keep the next timed task pinned in the shade. */
    val pinNext: Boolean = true,
    /** Epoch millis after which Flutter planned nothing. */
    val horizonEnd: Long = 0,
)

/** A timed task occurrence for the pinned "next task" notification. */
data class Upcoming(
    val taskId: String,
    val occurrence: String,
    val due: LocalDateTime,
    val title: String,
    val list: String,
)

/** A spec re-scheduled by the user to an absolute moment. */
data class Snooze(val spec: Spec, val at: Long)

/** "Done" pressed natively; filters the occurrence until Flutter acknowledges [seq]. */
data class DoneMark(val taskId: String, val occurrence: String, val seq: Long)

data class Event(val seq: Long, val taskId: String, val occurrence: String, val at: Long)

data class EngineState(
    val config: Config = Config(),
    /** Sorted by trigger. */
    val specs: List<Spec> = emptyList(),
    /** Sorted by due time. */
    val upcoming: List<Upcoming> = emptyList(),
    /** Not completed task id -> current due date (`""` when none). */
    val live: Map<String, String> = emptyMap(),
    val snoozes: List<Snooze> = emptyList(),
    val done: List<DoneMark> = emptyList(),
    val events: List<Event> = emptyList(),
    val nextSeq: Long = 1,
    /** Everything due at or before this epoch millis has been handled. 0 until the first plan arrives. */
    val watermark: Long = 0,
    /** The horizon we already nudged the user about. */
    val nudgedHorizon: Long = 0,
)

/** A signal resolved to an instant. */
data class Due(val spec: Spec, val at: Long, val snoozed: Boolean)
