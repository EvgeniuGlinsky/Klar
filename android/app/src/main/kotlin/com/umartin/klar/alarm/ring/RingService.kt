package com.umartin.klar.alarm.ring

import android.app.ForegroundServiceStartNotAllowedException
import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat
import com.umartin.klar.R
import com.umartin.klar.alarm.ActionReceiver
import com.umartin.klar.alarm.Codec
import com.umartin.klar.alarm.Engine
import com.umartin.klar.alarm.Notifier
import com.umartin.klar.alarm.core.Spec
import com.umartin.klar.alarm.ui.AlarmActivity
import org.json.JSONArray

/**
 * Rings alarms: sound, vibration and a full-screen notification that opens [AlarmActivity]. Several alarms
 * queue up in [RingSession]; the service stops when the queue is empty.
 */
class RingService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private lateinit var player: RingPlayer
    private lateinit var buzzer: Buzzer
    private var playingKey: String? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        player = RingPlayer(this)
        buzzer = Buzzer(this)
        Notifier.ensureChannels(this)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Every start must promote to foreground first, even when there is nothing left to ring.
        val incoming = intent?.getStringExtra(EXTRA_SPECS)?.let { Codec.specs(JSONArray(it)) }.orEmpty()
        startForeground(incoming.firstOrNull() ?: RingSession.current())

        val key = intent?.getStringExtra(EXTRA_KEY)
        val target = RingSession.snapshot().firstOrNull { it.key == key } ?: RingSession.current()
        when (intent?.action) {
            ACTION_RING -> RingSession.add(incoming)
            ActionReceiver.ACTION_DONE -> target?.let { spec ->
                Engine.done(this, spec)
                RingSession.remove { it.taskId == spec.taskId && it.occurrence == spec.occurrence }
            }
            ActionReceiver.ACTION_SNOOZE -> target?.let { spec ->
                Engine.snooze(this, spec, intent.getIntExtra(EXTRA_MINUTES, 0).takeIf { it > 0 })
                RingSession.remove { it.key == spec.key }
            }
            ActionReceiver.ACTION_DISMISS -> target?.let { spec -> RingSession.remove { it.key == spec.key } }
            ACTION_REMOVE -> {
                val keys = intent.getStringArrayExtra(EXTRA_KEYS).orEmpty().toSet()
                RingSession.remove { it.key in keys }
            }
        }
        refresh()
        return START_NOT_STICKY
    }

    private fun startForeground(spec: Spec?) {
        val notification = spec?.let { buildNotification(it) } ?: placeholderNotification()
        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            ServiceInfo.FOREGROUND_SERVICE_TYPE_SYSTEM_EXEMPTED
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
        } else {
            0
        }
        ServiceCompat.startForeground(this, Notifier.RING_NOTIFICATION_ID, notification, type)
    }

    /** Plays the current alarm, or stops when none is left. */
    private fun refresh() {
        val current = RingSession.current()
        if (current == null) {
            stopRinging()
            ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE)
            stopSelf()
            return
        }
        startForeground(current)
        if (current.key == playingKey) return
        playingKey = current.key

        val config = Engine.config(this)
        player.stop()
        buzzer.stop()
        VolumeGuard.raise(this, config.minVolume)
        val audible = player.start(current.sound ?: config.sound, config.rampSeconds)
        val vibration = current.vibration ?: config.vibration
        // Never ring silently: without sound, vibrate at least.
        if (!buzzer.start(vibration) && !audible) buzzer.start("standard")

        handler.removeCallbacks(autoSilence)
        // Without a visible notification there is no way to stop the alarm, so keep it short.
        val minutes = if (Notifier.canNotify(this)) config.autoSilenceMinutes else 1
        handler.postDelayed(autoSilence, minutes * 60_000L)
    }

    private val autoSilence = Runnable {
        val current = RingSession.current() ?: return@Runnable
        Notifier.missed(this, listOf(current))
        RingSession.remove { it.key == current.key }
        refresh()
    }

    private fun stopRinging() {
        handler.removeCallbacks(autoSilence)
        playingKey = null
        player.stop()
        buzzer.stop()
        VolumeGuard.restore(this)
    }

    override fun onDestroy() {
        stopRinging()
        super.onDestroy()
    }

    private fun buildNotification(spec: Spec): Notification {
        val snoozeMinutes = Engine.config(this).snoozeMinutes
        val more = RingSession.snapshot().size - 1
        val fullScreen = PendingIntent.getActivity(
            this,
            0,
            Intent(this, AlarmActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_NO_USER_ACTION),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        return NotificationCompat.Builder(this, Notifier.CHANNEL_ALARM)
            .setSmallIcon(R.drawable.ic_stat_klar)
            .setColor(0xFFD9CBB3.toInt())
            .setContentTitle(spec.title)
            .setContentText(spec.body)
            .setSubText(if (more > 0) getString(R.string.ring_more, more) else null)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setFullScreenIntent(fullScreen, true)
            .setContentIntent(fullScreen)
            .setDeleteIntent(Notifier.action(this, ActionReceiver.ACTION_DISMISS, spec))
            .addAction(0, getString(R.string.action_done), Notifier.action(this, ActionReceiver.ACTION_DONE, spec))
            .addAction(
                0,
                getString(R.string.action_snooze, snoozeMinutes),
                Notifier.action(this, ActionReceiver.ACTION_SNOOZE, spec, snoozeMinutes),
            )
            .addAction(0, getString(R.string.action_dismiss), Notifier.action(this, ActionReceiver.ACTION_DISMISS, spec))
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .build()
    }

    private fun placeholderNotification(): Notification = NotificationCompat.Builder(this, Notifier.CHANNEL_ALARM)
        .setSmallIcon(R.drawable.ic_stat_klar)
        .setSilent(true)
        .build()

    companion object {
        private const val TAG = "KlarRing"
        const val ACTION_RING = "com.umartin.klar.RING"
        private const val ACTION_REMOVE = "com.umartin.klar.REMOVE"
        private const val EXTRA_SPECS = "specs"
        private const val EXTRA_KEY = "key"
        private const val EXTRA_KEYS = "keys"
        private const val EXTRA_MINUTES = "minutes"

        /** Starts ringing [specs]. Allowed from the background because an exact alarm woke us. */
        fun ring(context: Context, specs: List<Spec>) {
            val intent = Intent(context, RingService::class.java)
                .setAction(ACTION_RING)
                .putExtra(EXTRA_SPECS, JSONArray(specs.map(Codec::spec)).toString())
            try {
                ContextCompat.startForegroundService(context, intent)
            } catch (e: Exception) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && e is ForegroundServiceStartNotAllowedException) {
                    // E.g. without exact-alarm permission: let the full-screen activity start the service instead.
                    Log.w(TAG, "Cannot start ringing from the background", e)
                    AlarmActivity.launchFallback(context, specs)
                } else {
                    throw e
                }
            }
        }

        /** Done / snooze / dismiss for a ringing alarm; [key] defaults to the current one. */
        fun command(context: Context, action: String, key: String? = null, minutes: Int? = null) {
            val intent = Intent(context, RingService::class.java)
                .setAction(action)
                .putExtra(EXTRA_KEY, key)
                .apply { minutes?.let { putExtra(EXTRA_MINUTES, it) } }
            ContextCompat.startForegroundService(context, intent)
        }

        fun removeKeys(context: Context, keys: List<String>) {
            val intent = Intent(context, RingService::class.java)
                .setAction(ACTION_REMOVE)
                .putExtra(EXTRA_KEYS, keys.toTypedArray())
            ContextCompat.startForegroundService(context, intent)
        }
    }
}
