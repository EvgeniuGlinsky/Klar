package com.umartin.klar.alarm

import android.content.Context
import android.util.Log
import androidx.core.util.AtomicFile
import com.umartin.klar.alarm.core.EngineState
import org.json.JSONObject
import java.io.File

/**
 * The engine state, persisted in device-protected storage so alarms work before the first unlock
 * after a reboot. All access is serialized; the in-memory copy is the source of truth while the process lives.
 */
object AlarmStore {
    private const val TAG = "KlarStore"
    private var cached: EngineState? = null

    fun deviceContext(context: Context): Context =
        context.applicationContext.createDeviceProtectedStorageContext()

    fun soundsDir(context: Context): File = File(deviceContext(context).filesDir, "sounds").apply { mkdirs() }

    private fun file(context: Context) = AtomicFile(File(deviceContext(context).filesDir, "engine.json"))

    @Synchronized
    fun read(context: Context): EngineState = cached ?: load(context).also { cached = it }

    /** Applies [change] atomically and persists the result. */
    @Synchronized
    fun <T> update(context: Context, change: (EngineState) -> Pair<EngineState, T>): T {
        val (next, result) = change(read(context))
        if (next != cached) {
            cached = next
            save(context, next)
        }
        return result
    }

    @Synchronized
    fun modify(context: Context, change: (EngineState) -> EngineState): EngineState =
        update(context) { state -> change(state).let { it to it } }

    private fun load(context: Context): EngineState = try {
        val file = file(context)
        if (!file.baseFile.exists()) EngineState() else Codec.state(JSONObject(String(file.readFully())))
    } catch (e: Exception) {
        Log.e(TAG, "Cannot read engine state, starting empty", e)
        EngineState()
    }

    private fun save(context: Context, state: EngineState) {
        val file = file(context)
        val stream = file.startWrite()
        try {
            stream.write(Codec.state(state).toString().toByteArray())
            file.finishWrite(stream)
        } catch (e: Exception) {
            file.failWrite(stream)
            Log.e(TAG, "Cannot write engine state", e)
        }
    }
}
