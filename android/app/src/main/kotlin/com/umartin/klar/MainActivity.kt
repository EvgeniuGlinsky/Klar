package com.umartin.klar

import android.content.Intent
import com.umartin.klar.channel.AlarmChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var alarms: AlarmChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        alarms = AlarmChannel(this, flutterEngine.dartExecutor.binaryMessenger).apply {
            launchTaskId = intent?.getStringExtra(EXTRA_TASK_ID)
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        alarms?.dispose()
        alarms = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        intent.getStringExtra(EXTRA_TASK_ID)?.let { alarms?.openTask(it) }
    }

    @Deprecated("Flutter still routes results through onActivityResult")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (alarms?.onActivityResult(requestCode, resultCode, data) != true) {
            @Suppress("DEPRECATION")
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (alarms?.onRequestPermissionsResult(requestCode, grantResults) != true) {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    companion object {
        const val EXTRA_TASK_ID = "taskId"
    }
}
