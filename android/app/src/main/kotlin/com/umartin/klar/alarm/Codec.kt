package com.umartin.klar.alarm

import com.umartin.klar.alarm.core.Config
import com.umartin.klar.alarm.core.DoneMark
import com.umartin.klar.alarm.core.EngineState
import com.umartin.klar.alarm.core.Event
import com.umartin.klar.alarm.core.Kind
import com.umartin.klar.alarm.core.Snooze
import com.umartin.klar.alarm.core.SoundRef
import com.umartin.klar.alarm.core.Spec
import com.umartin.klar.alarm.core.Upcoming
import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDateTime

/** JSON shapes shared with Flutter (`AlarmSpec.toJson`, `EngineConfig.toJson`) and the on-disk store. */
object Codec {
    fun sound(json: JSONObject?): SoundRef? = json?.let {
        SoundRef(it.getString("type"), it.optString("id"), it.optString("title"))
    }

    fun sound(sound: SoundRef): JSONObject =
        JSONObject().put("type", sound.type).put("id", sound.id).put("title", sound.title)

    fun spec(json: JSONObject) = Spec(
        key = json.getString("key"),
        taskId = json.getString("taskId"),
        occurrence = json.getString("occurrence"),
        trigger = LocalDateTime.parse(json.getString("trigger")),
        kind = if (json.getString("kind") == "alarm") Kind.ALARM else Kind.NOTIFICATION,
        title = json.getString("title"),
        body = json.optString("body"),
        sound = sound(json.optJSONObject("sound")),
        vibration = json.optString("vibration").ifEmpty { null },
    )

    fun spec(spec: Spec): JSONObject = JSONObject()
        .put("key", spec.key)
        .put("taskId", spec.taskId)
        .put("occurrence", spec.occurrence)
        .put("trigger", spec.trigger.toString())
        .put("kind", if (spec.kind == Kind.ALARM) "alarm" else "notification")
        .put("title", spec.title)
        .put("body", spec.body)
        .apply {
            spec.sound?.let { put("sound", sound(it)) }
            spec.vibration?.let { put("vibration", it) }
        }

    fun config(json: JSONObject) = Config(
        sound = sound(json.optJSONObject("sound")) ?: SoundRef.FJORD,
        vibration = json.optString("vibration", "standard"),
        minVolume = if (json.isNull("minVolume") || !json.has("minVolume")) null else json.getInt("minVolume"),
        rampSeconds = json.optInt("rampSeconds", 30),
        snoozeMinutes = json.optInt("snoozeMinutes", 10),
        autoSilenceMinutes = json.optInt("autoSilenceMinutes", 10),
        pinNext = json.optBoolean("pinNext", true),
        horizonEnd = json.optLong("horizonEnd", 0),
    )

    fun config(config: Config): JSONObject = JSONObject()
        .put("sound", sound(config.sound))
        .put("vibration", config.vibration)
        .put("minVolume", config.minVolume ?: JSONObject.NULL)
        .put("rampSeconds", config.rampSeconds)
        .put("snoozeMinutes", config.snoozeMinutes)
        .put("autoSilenceMinutes", config.autoSilenceMinutes)
        .put("pinNext", config.pinNext)
        .put("horizonEnd", config.horizonEnd)

    fun specs(array: JSONArray): List<Spec> = List(array.length()) { spec(array.getJSONObject(it)) }

    fun upcoming(array: JSONArray): List<Upcoming> = List(array.length()) {
        array.getJSONObject(it).let { u ->
            Upcoming(
                taskId = u.getString("taskId"),
                occurrence = u.getString("occurrence"),
                due = LocalDateTime.parse(u.getString("due")),
                title = u.getString("title"),
                list = u.optString("list"),
            )
        }
    }

    private fun upcoming(u: Upcoming): JSONObject = JSONObject()
        .put("taskId", u.taskId)
        .put("occurrence", u.occurrence)
        .put("due", u.due.toString())
        .put("title", u.title)
        .put("list", u.list)

    fun live(json: JSONObject): Map<String, String> = json.keys().asSequence().associateWith { json.getString(it) }

    fun state(json: JSONObject) = EngineState(
        config = json.optJSONObject("config")?.let(::config) ?: Config(),
        specs = json.optJSONArray("specs")?.let(::specs).orEmpty(),
        upcoming = json.optJSONArray("upcoming")?.let(::upcoming).orEmpty(),
        live = json.optJSONObject("live")?.let(::live).orEmpty(),
        snoozes = json.optJSONArray("snoozes")?.let { a ->
            List(a.length()) { a.getJSONObject(it).let { s -> Snooze(spec(s.getJSONObject("spec")), s.getLong("at")) } }
        }.orEmpty(),
        done = json.optJSONArray("done")?.let { a ->
            List(a.length()) {
                a.getJSONObject(it).let { d -> DoneMark(d.getString("taskId"), d.getString("occurrence"), d.getLong("seq")) }
            }
        }.orEmpty(),
        events = json.optJSONArray("events")?.let { a -> List(a.length()) { event(a.getJSONObject(it)) } }.orEmpty(),
        nextSeq = json.optLong("nextSeq", 1),
        watermark = json.optLong("watermark", 0),
        nudgedHorizon = json.optLong("nudgedHorizon", 0),
    )

    fun state(state: EngineState): JSONObject = JSONObject()
        .put("config", config(state.config))
        .put("specs", JSONArray(state.specs.map(::spec)))
        .put("upcoming", JSONArray(state.upcoming.map(::upcoming)))
        .put("live", JSONObject(state.live))
        .put("snoozes", JSONArray(state.snoozes.map { JSONObject().put("spec", spec(it.spec)).put("at", it.at) }))
        .put(
            "done",
            JSONArray(state.done.map { JSONObject().put("taskId", it.taskId).put("occurrence", it.occurrence).put("seq", it.seq) }),
        )
        .put("events", JSONArray(state.events.map(::event)))
        .put("nextSeq", state.nextSeq)
        .put("watermark", state.watermark)
        .put("nudgedHorizon", state.nudgedHorizon)

    fun event(event: Event): JSONObject = JSONObject()
        .put("seq", event.seq)
        .put("taskId", event.taskId)
        .put("occurrence", event.occurrence)
        .put("at", event.at)

    private fun event(json: JSONObject) =
        Event(json.getLong("seq"), json.getString("taskId"), json.getString("occurrence"), json.getLong("at"))
}
