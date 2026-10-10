package com.umartin.klar.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.umartin.klar.alarm.ring.RingSession
import com.umartin.klar.alarm.ring.VolumeGuard

/**
 * Re-arms after a reboot (also before the first unlock), an app update, a force-stop on Android 15+,
 * a clock or time-zone change and a change of the exact-alarm permission.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        runAsync(context, "klar:boot") {
            Notifier.ensureChannels(context)
            if (RingSession.snapshot().isEmpty()) VolumeGuard.restore(context)
            if (intent.action == Intent.ACTION_TIME_CHANGED) Engine.onClockChanged(context)
            Engine.onWake(context)
        }
    }
}
