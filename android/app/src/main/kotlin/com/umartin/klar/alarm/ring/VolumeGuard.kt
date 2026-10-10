package com.umartin.klar.alarm.ring

import android.content.Context
import android.media.AudioManager
import android.util.Log
import com.umartin.klar.alarm.AlarmStore
import kotlin.math.ceil

/**
 * Raises the alarm stream to the configured minimum while ringing and restores it afterwards. The original
 * level is persisted, so a process death during ringing is repaired on the next start or boot.
 */
object VolumeGuard {
    private const val PREFS = "klar_volume"
    private const val KEY_ORIGINAL = "original"
    private const val KEY_RAISED = "raised"

    private fun prefs(context: Context) =
        AlarmStore.deviceContext(context).getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun raise(context: Context, minPercent: Int?) {
        if (minPercent == null) return
        val audio = context.getSystemService(AudioManager::class.java)
        val max = audio.getStreamMaxVolume(AudioManager.STREAM_ALARM)
        val target = ceil(max * minPercent / 100.0).toInt().coerceIn(1, max)
        val current = audio.getStreamVolume(AudioManager.STREAM_ALARM)
        if (current >= target) return
        try {
            if (!prefs(context).contains(KEY_ORIGINAL)) {
                prefs(context).edit().putInt(KEY_ORIGINAL, current).putInt(KEY_RAISED, target).commit()
            }
            audio.setStreamVolume(AudioManager.STREAM_ALARM, target, 0)
        } catch (e: SecurityException) {
            Log.w("KlarVolume", "Cannot raise alarm volume", e)
        }
    }

    fun restore(context: Context) {
        val prefs = prefs(context)
        if (!prefs.contains(KEY_ORIGINAL)) return
        val audio = context.getSystemService(AudioManager::class.java)
        try {
            // Leave it alone if the user changed the volume meanwhile.
            if (audio.getStreamVolume(AudioManager.STREAM_ALARM) == prefs.getInt(KEY_RAISED, -1)) {
                audio.setStreamVolume(AudioManager.STREAM_ALARM, prefs.getInt(KEY_ORIGINAL, 0), 0)
            }
        } catch (e: SecurityException) {
            Log.w("KlarVolume", "Cannot restore alarm volume", e)
        }
        prefs.edit().clear().commit()
    }
}
