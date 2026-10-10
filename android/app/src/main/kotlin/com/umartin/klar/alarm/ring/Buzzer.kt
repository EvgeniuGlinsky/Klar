package com.umartin.klar.alarm.ring

import android.content.Context
import android.media.AudioAttributes
import android.os.Build
import android.os.VibrationAttributes
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager

/** Vibration patterns matching Flutter's `VibrationPattern`. */
class Buzzer(context: Context) {
    private val vibrator: Vibrator =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Vibrator::class.java)
        }

    /** Starts [pattern]; repeats until [stop] unless [once]. Returns false for "off". */
    fun start(pattern: String, once: Boolean = false): Boolean {
        val (timings, amplitudes) = PATTERNS[pattern] ?: return false
        if (!vibrator.hasVibrator()) return false
        val repeat = if (once) -1 else 0
        val effect = if (vibrator.hasAmplitudeControl()) {
            VibrationEffect.createWaveform(timings, amplitudes, repeat)
        } else {
            VibrationEffect.createWaveform(timings, repeat)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            vibrator.vibrate(effect, VibrationAttributes.createForUsage(VibrationAttributes.USAGE_ALARM))
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(effect, AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ALARM).build())
        }
        return true
    }

    fun stop() = vibrator.cancel()

    companion object {
        private val PATTERNS = mapOf(
            "gentle" to (longArrayOf(0, 260, 1740) to intArrayOf(0, 90, 0)),
            "standard" to (longArrayOf(0, 600, 900) to intArrayOf(0, 200, 0)),
            "pulse" to (longArrayOf(0, 140, 140, 140, 140, 140, 1100) to intArrayOf(0, 220, 0, 220, 0, 220, 0)),
            "heartbeat" to (longArrayOf(0, 110, 120, 200, 1300) to intArrayOf(0, 255, 0, 160, 0)),
            "strong" to (longArrayOf(0, 1000, 400) to intArrayOf(0, 255, 0)),
        )
    }
}
