package com.umartin.klar.alarm.ring

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.ToneGenerator
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.util.Log
import com.umartin.klar.alarm.core.SoundRef
import com.umartin.klar.channel.SoundLibrary

/**
 * Plays the alarm sound on the alarm stream with a fade-in. Falls back from the chosen sound to the system
 * alarm and then to a bundled tone; during a phone call only a quiet beep plays.
 */
class RingPlayer(private val context: Context) {
    private val audio = context.getSystemService(AudioManager::class.java)
    private val handler = Handler(Looper.getMainLooper())
    private val attributes = AudioAttributes.Builder()
        .setUsage(AudioAttributes.USAGE_ALARM)
        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
        .build()
    private val focusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
        .setAudioAttributes(attributes)
        .setOnAudioFocusChangeListener { /* Keep ringing whatever happens to focus. */ }
        .build()

    private var player: MediaPlayer? = null
    private var tone: ToneGenerator? = null
    private var rampStart = 0L
    private var rampMillis = 0L

    /** Returns true if something audible is playing. */
    fun start(sound: SoundRef, rampSeconds: Int, loop: Boolean = true): Boolean {
        stop()
        if (sound.type == "silent") return false
        if (inCall()) {
            startCallBeep()
            return true
        }
        audio.requestAudioFocus(focusRequest)
        val candidates = listOf(sound, SoundRef.SYSTEM, SoundRef.FJORD).distinct()
        for (candidate in candidates) {
            val uri = SoundLibrary.resolve(context, candidate) ?: continue
            if (play(uri, loop)) {
                startRamp(rampSeconds)
                return true
            }
        }
        return false
    }

    private fun play(uri: Uri, loop: Boolean): Boolean = try {
        player = MediaPlayer().apply {
            setAudioAttributes(attributes)
            setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
            setDataSource(context, uri)
            isLooping = loop
            setOnErrorListener { _, what, extra ->
                Log.w(TAG, "Playback error $what/$extra, switching to the bundled tone")
                handler.post { fallback(loop) }
                true
            }
            prepare()
            setVolume(volumeAt(0f), volumeAt(0f))
            start()
        }
        true
    } catch (e: Exception) {
        Log.w(TAG, "Cannot play $uri", e)
        player?.release()
        player = null
        false
    }

    private fun fallback(loop: Boolean) {
        player?.release()
        player = null
        SoundLibrary.resolve(context, SoundRef.FJORD)?.let { play(it, loop) }
    }

    private fun startRamp(rampSeconds: Int) {
        rampMillis = rampSeconds * 1000L
        rampStart = System.currentTimeMillis()
        if (rampMillis <= 0) {
            player?.setVolume(1f, 1f)
            return
        }
        handler.post(rampTick)
    }

    private val rampTick = object : Runnable {
        override fun run() {
            val p = player ?: return
            val progress = ((System.currentTimeMillis() - rampStart).toFloat() / rampMillis).coerceIn(0f, 1f)
            val volume = volumeAt(progress)
            try {
                p.setVolume(volume, volume)
            } catch (_: IllegalStateException) {
                return
            }
            if (progress < 1f) handler.postDelayed(this, 200)
        }
    }

    /** Perceived loudness grows roughly with the square of amplitude. */
    private fun volumeAt(progress: Float) = if (rampMillis <= 0) 1f else (0.03f + 0.97f * progress * progress)

    private fun inCall() = audio.mode == AudioManager.MODE_IN_CALL || audio.mode == AudioManager.MODE_IN_COMMUNICATION

    private fun startCallBeep() {
        tone = try {
            ToneGenerator(AudioManager.STREAM_ALARM, 40)
        } catch (e: RuntimeException) {
            Log.w(TAG, "No tone generator", e)
            null
        }
        handler.post(beepTick)
    }

    private val beepTick = object : Runnable {
        override fun run() {
            val generator = tone ?: return
            generator.startTone(ToneGenerator.TONE_SUP_CALL_WAITING, 500)
            handler.postDelayed(this, 4000)
        }
    }

    fun stop() {
        handler.removeCallbacks(rampTick)
        handler.removeCallbacks(beepTick)
        player?.run {
            try {
                stop()
            } catch (_: IllegalStateException) {
            }
            release()
        }
        player = null
        tone?.release()
        tone = null
        audio.abandonAudioFocusRequest(focusRequest)
    }

    private companion object {
        const val TAG = "KlarPlayer"
    }
}
