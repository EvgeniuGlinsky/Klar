package com.umartin.klar.channel

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.umartin.klar.R
import com.umartin.klar.alarm.Codec
import com.umartin.klar.alarm.Engine
import com.umartin.klar.alarm.Notifier
import com.umartin.klar.alarm.core.Kind
import com.umartin.klar.alarm.core.Spec
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.concurrent.Executors

/** The `klar/alarms` channel used by Flutter's `AlarmEngineChannel`. */
class AlarmChannel(private val activity: Activity, messenger: BinaryMessenger) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, NAME)
    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private val context get() = activity.applicationContext

    private var pendingPick: MethodChannel.Result? = null
    private var pendingPermission: MethodChannel.Result? = null

    /** A task to open that arrived before Flutter asked for it. */
    var launchTaskId: String? = null

    init {
        channel.setMethodCallHandler(this)
        Notifier.ensureChannels(context)
        Engine.onEvents = { channel.invokeMethod("eventsChanged", null) }
    }

    fun dispose() {
        Engine.onEvents = null
        channel.setMethodCallHandler(null)
        io.shutdown()
    }

    fun openTask(taskId: String) = channel.invokeMethod("openTask", taskId)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "replaceAll" -> background(result) {
                val payload = JSONObject(call.argument<String>("payload")!!)
                Engine.replaceAll(
                    context,
                    Codec.config(payload.getJSONObject("config")),
                    Codec.specs(payload.getJSONArray("specs")),
                    payload.optJSONArray("upcoming")?.let(Codec::upcoming).orEmpty(),
                    Codec.live(payload.getJSONObject("live")),
                    payload.getLong("ackSeq"),
                )
                null
            }
            "drainEvents" -> background(result) {
                Engine.drainEvents(context).map { mapOf("seq" to it.seq, "taskId" to it.taskId, "occurrence" to it.occurrence) }
            }
            "takeLaunchTaskId" -> result.success(launchTaskId.also { launchTaskId = null })
            "testAlarm" -> {
                testAlarm(call.argument<Int>("seconds") ?: 10)
                result.success(null)
            }
            "pickSystemSound" -> pick(result, ringtonePicker(), REQUEST_RINGTONE)
            "pickAudioFile" -> pick(
                result,
                Intent(Intent.ACTION_OPEN_DOCUMENT).addCategory(Intent.CATEGORY_OPENABLE).setType("audio/*"),
                REQUEST_FILE,
            )
            "previewSound" -> {
                Codec.sound(JSONObject(call.argument<String>("sound")!!))?.let { SoundLibrary.preview(context, it) }
                result.success(null)
            }
            "previewVibration" -> {
                SoundLibrary.previewVibration(context, call.argument<String>("pattern")!!)
                result.success(null)
            }
            "stopPreview" -> {
                SoundLibrary.stopPreview()
                result.success(null)
            }
            "permissionReport" -> result.success(PermissionsReport.build(context))
            "requestNotificationPermission" -> requestNotifications(result)
            "openSettings" -> {
                PermissionsReport.open(activity, call.argument<String>("target")!!)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun background(result: MethodChannel.Result, work: () -> Any?) {
        io.execute {
            try {
                val value = work()
                main.post { result.success(value) }
            } catch (e: Exception) {
                main.post { result.error("engine", e.message, null) }
            }
        }
    }

    private fun testAlarm(seconds: Int) {
        val now = System.currentTimeMillis()
        val spec = Spec(
            key = "${Spec.TEST_TASK_PREFIX}|$now",
            taskId = "${Spec.TEST_TASK_PREFIX}$now",
            occurrence = LocalDate.now().toString(),
            trigger = LocalDateTime.now().plusSeconds(seconds.toLong()),
            kind = Kind.ALARM,
            title = context.getString(R.string.test_alarm_title),
            body = context.getString(R.string.test_alarm_body),
        )
        io.execute { Engine.testAlarm(context, spec, now + seconds * 1000L) }
    }

    private fun ringtonePicker() = Intent(RingtoneManager.ACTION_RINGTONE_PICKER)
        .putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_ALL)
        .putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, false)
        .putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, false)

    private fun pick(result: MethodChannel.Result, intent: Intent, requestCode: Int) {
        pendingPick?.success(null)
        pendingPick = result
        activity.startActivityForResult(intent, requestCode)
    }

    /** Returns true if the result was ours. */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_RINGTONE && requestCode != REQUEST_FILE) return false
        val result = pendingPick ?: return true
        pendingPick = null
        val uri: Uri? = if (resultCode != Activity.RESULT_OK) {
            null
        } else if (requestCode == REQUEST_RINGTONE) {
            @Suppress("DEPRECATION")
            data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
        } else {
            data?.data
        }
        if (uri == null) {
            result.success(null)
            return true
        }
        background(result) {
            val title = if (requestCode == REQUEST_RINGTONE) SoundLibrary.ringtoneTitle(context, uri) else null
            SoundLibrary.import(context, uri, title)?.let { mapOf("type" to it.type, "id" to it.id, "title" to it.title) }
        }
        return true
    }

    private fun requestNotifications(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU ||
            ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
        ) {
            result.success(true)
            return
        }
        pendingPermission?.success(false)
        pendingPermission = result
        ActivityCompat.requestPermissions(activity, arrayOf(Manifest.permission.POST_NOTIFICATIONS), REQUEST_NOTIFICATIONS)
    }

    fun onRequestPermissionsResult(requestCode: Int, grantResults: IntArray): Boolean {
        if (requestCode != REQUEST_NOTIFICATIONS) return false
        pendingPermission?.success(grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED)
        pendingPermission = null
        return true
    }

    companion object {
        const val NAME = "klar/alarms"
        private const val REQUEST_RINGTONE = 7101
        private const val REQUEST_FILE = 7102
        private const val REQUEST_NOTIFICATIONS = 7103
    }
}
