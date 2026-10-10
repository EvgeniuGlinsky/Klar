package com.umartin.klar.channel

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.provider.OpenableColumns
import android.provider.Settings
import android.util.Log
import android.webkit.MimeTypeMap
import com.umartin.klar.alarm.AlarmStore
import com.umartin.klar.alarm.core.EngineState
import com.umartin.klar.alarm.core.SoundRef
import com.umartin.klar.alarm.ring.Buzzer
import java.io.File
import java.util.UUID

/**
 * Resolves [SoundRef]s and imports user sounds. Picked sounds are copied into device-protected storage,
 * so they play before the first unlock and survive the original file being moved or deleted.
 */
object SoundLibrary {
    private const val TAG = "KlarSounds"
    private const val PRUNE_AGE_MS = 24 * 60 * 60_000L

    fun resolve(context: Context, sound: SoundRef): Uri? = when (sound.type) {
        "bundled" -> {
            val id = context.resources.getIdentifier(sound.id, "raw", context.packageName)
            if (id == 0) null else Uri.parse("android.resource://${context.packageName}/$id")
        }
        "file" -> File(AlarmStore.soundsDir(context), sound.id).takeIf { it.exists() }?.let(Uri::fromFile)
        "system" -> runCatching { RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_ALARM) }
            .getOrNull() ?: Settings.System.DEFAULT_ALARM_ALERT_URI
        else -> null
    }

    /** Copies [uri] into app storage; returns the new sound or `null` if it cannot be read. */
    fun import(context: Context, uri: Uri, fallbackTitle: String? = null): SoundRef? = try {
        val resolver = context.contentResolver
        val extension = resolver.getType(uri)?.let { MimeTypeMap.getSingleton().getExtensionFromMimeType(it) } ?: "audio"
        val id = "${UUID.randomUUID()}.$extension"
        resolver.openInputStream(uri)!!.use { input ->
            File(AlarmStore.soundsDir(context), id).outputStream().use { input.copyTo(it) }
        }
        SoundRef("file", id, fallbackTitle ?: displayName(context, uri) ?: "Мелодия")
    } catch (e: Exception) {
        Log.w(TAG, "Cannot import $uri", e)
        null
    }

    fun ringtoneTitle(context: Context, uri: Uri): String? =
        runCatching { RingtoneManager.getRingtone(context, uri)?.getTitle(context) }.getOrNull()

    private fun displayName(context: Context, uri: Uri): String? =
        context.contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use { cursor ->
            if (cursor.moveToFirst()) cursor.getString(0)?.substringBeforeLast('.') else null
        }

    /** Deletes imported sounds nothing refers to any more; fresh files are kept for a just-opened picker. */
    fun prune(context: Context, state: EngineState) {
        val used = buildSet {
            add(state.config.sound.id)
            state.specs.forEach { spec -> spec.sound?.let { add(it.id) } }
            state.snoozes.forEach { snooze -> snooze.spec.sound?.let { add(it.id) } }
        }
        val now = System.currentTimeMillis()
        AlarmStore.soundsDir(context).listFiles()?.forEach { file ->
            if (file.name !in used && now - file.lastModified() > PRUNE_AGE_MS) file.delete()
        }
    }

    private var preview: MediaPlayer? = null
    private var previewBuzzer: Buzzer? = null

    fun preview(context: Context, sound: SoundRef) {
        stopPreview()
        val uri = resolve(context, sound) ?: return
        preview = try {
            MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build(),
                )
                setDataSource(context, uri)
                isLooping = true
                prepare()
                start()
            }
        } catch (e: Exception) {
            Log.w(TAG, "Cannot preview $uri", e)
            null
        }
    }

    fun previewVibration(context: Context, pattern: String) {
        previewBuzzer?.stop()
        previewBuzzer = Buzzer(context).also { it.start(pattern, once = true) }
    }

    fun stopPreview() {
        preview?.run {
            runCatching { stop() }
            release()
        }
        preview = null
        previewBuzzer?.stop()
        previewBuzzer = null
    }
}
