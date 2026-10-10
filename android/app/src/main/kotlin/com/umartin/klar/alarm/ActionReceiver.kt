package com.umartin.klar.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.umartin.klar.alarm.ring.RingService
import com.umartin.klar.alarm.ring.RingSession
import org.json.JSONObject

/**
 * Notification actions. A ringing alarm is handled by [RingService]; anything else (reminder
 * notifications, a stale alarm notification) is applied to the engine directly, without Flutter.
 */
class ActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val spec = intent.getStringExtra(EXTRA_SPEC)?.let { Codec.spec(JSONObject(it)) } ?: return
        val action = intent.action ?: return
        if (RingSession.snapshot().any { it.key == spec.key }) {
            RingService.command(context, action, spec.key, intent.getIntExtra(EXTRA_MINUTES, 0).takeIf { it > 0 })
            return
        }
        runAsync(context, "klar:action") {
            when (action) {
                ACTION_DONE -> Engine.done(context, spec)
                ACTION_SNOOZE -> Engine.snooze(context, spec, intent.getIntExtra(EXTRA_MINUTES, 0).takeIf { it > 0 })
            }
            Notifier.cancel(context, spec)
        }
    }

    companion object {
        const val ACTION_DONE = "com.umartin.klar.DONE"
        const val ACTION_SNOOZE = "com.umartin.klar.SNOOZE"
        const val ACTION_DISMISS = "com.umartin.klar.DISMISS"
        const val EXTRA_SPEC = "spec"
        const val EXTRA_MINUTES = "minutes"
    }
}
