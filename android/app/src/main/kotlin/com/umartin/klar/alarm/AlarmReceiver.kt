package com.umartin.klar.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.PowerManager

/** Woken by [Arming]; processes due signals off the main thread while holding a short wake lock. */
class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != ACTION_WAKE) return
        runAsync(context, "klar:wake") { Engine.onWake(context) }
    }

    companion object {
        const val ACTION_WAKE = "com.umartin.klar.WAKE"
    }
}

/** Runs [work] on a background thread, keeping the receiver and the CPU alive until it finishes. */
internal fun BroadcastReceiver.runAsync(context: Context, tag: String, work: () -> Unit) {
    val pending = goAsync()
    val wakeLock = context.getSystemService(PowerManager::class.java)
        .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, tag)
        .apply { acquire(60_000) }
    Thread {
        try {
            work()
        } finally {
            if (wakeLock.isHeld) wakeLock.release()
            pending.finish()
        }
    }.start()
}
