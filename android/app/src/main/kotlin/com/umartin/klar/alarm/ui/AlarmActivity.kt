package com.umartin.klar.alarm.ui

import android.animation.ValueAnimator
import android.app.Activity
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.TextUtils
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.view.ViewGroup.LayoutParams.WRAP_CONTENT
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import android.window.OnBackInvokedDispatcher
import androidx.core.app.NotificationCompat
import androidx.core.view.ViewCompat
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import com.umartin.klar.R
import com.umartin.klar.alarm.ActionReceiver
import com.umartin.klar.alarm.Codec
import com.umartin.klar.alarm.Engine
import com.umartin.klar.alarm.Notifier
import com.umartin.klar.alarm.core.Spec
import com.umartin.klar.alarm.ring.RingService
import com.umartin.klar.alarm.ring.RingSession
import org.json.JSONArray
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.Locale

/** Full-screen ringing alarm, shown over the lock screen. Built in code to match the Flutter palette. */
class AlarmActivity : Activity() {
    private val handler = Handler(Looper.getMainLooper())
    private lateinit var time: TextView
    private lateinit var date: TextView
    private lateinit var title: TextView
    private lateinit var body: TextView
    private lateinit var more: TextView
    private lateinit var snoozeRow: LinearLayout
    private var breathing: ValueAnimator? = null

    private val sessionListener: () -> Unit = { handler.post(::render) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        showOverLockScreen()
        WindowCompat.setDecorFitsSystemWindows(window, false)
        setContentView(buildContent())
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // An alarm is answered with a button, never with Back.
            onBackInvokedDispatcher.registerOnBackInvokedCallback(OnBackInvokedDispatcher.PRIORITY_OVERLAY) {}
        }
    }

    @Deprecated("Only used before Android 13")
    @Suppress("MissingSuperCall")
    override fun onBackPressed() = Unit

    override fun onResume() {
        super.onResume()
        // Fallback path: the alarm woke us but could not start the service from the background.
        intent.getStringExtra(EXTRA_SPECS)?.let { json ->
            intent.removeExtra(EXTRA_SPECS)
            getSystemService(NotificationManager::class.java).cancel(FALLBACK_NOTIFICATION_ID)
            RingService.ring(this, Codec.specs(JSONArray(json)))
        }
        RingSession.listen(sessionListener)
        render()
        handler.post(clockTick)
    }

    override fun onPause() {
        RingSession.unlisten(sessionListener)
        handler.removeCallbacks(clockTick)
        super.onPause()
    }

    override fun onDestroy() {
        breathing?.cancel()
        super.onDestroy()
    }

    private fun showOverLockScreen() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        }
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }

    private fun render() {
        val current = RingSession.current()
        if (current == null && intent.getStringExtra(EXTRA_SPECS) == null) {
            finish()
            return
        }
        current ?: return
        title.text = current.title
        body.text = current.body
        body.visibility = if (current.body.isEmpty()) View.GONE else View.VISIBLE
        val queued = RingSession.snapshot().size - 1
        more.text = getString(R.string.ring_more, queued)
        more.visibility = if (queued > 0) View.VISIBLE else View.GONE
    }

    private val clockTick = object : Runnable {
        override fun run() {
            val now = LocalDateTime.now()
            time.text = now.format(DateTimeFormatter.ofPattern("HH:mm"))
            date.text = now.format(DateTimeFormatter.ofPattern("EEEE, d MMMM", Locale.forLanguageTag("ru")))
            handler.postDelayed(this, 1000L * (60 - now.second))
        }
    }

    private fun command(action: String, minutes: Int? = null) {
        val key = RingSession.current()?.key ?: return
        RingService.command(this, action, key, minutes)
    }

    private fun buildContent(): View {
        val light = font("Manrope-Light.ttf")
        val regular = font("Manrope-Regular.ttf")
        val semiBold = font("Manrope-SemiBold.ttf")

        time = text(light, 76f, TEXT).apply { letterSpacing = -0.03f }
        date = text(regular, 15f, TEXT_MUTED)
        title = text(regular, 26f, TEXT).apply {
            maxLines = 4
            ellipsize = TextUtils.TruncateAt.END
            setLineSpacing(0f, 1.15f)
        }
        body = text(regular, 15f, TEXT_MUTED)
        more = text(semiBold, 12f, TEXT_FAINT).apply { letterSpacing = 0.12f }

        val ring = BreathingRing(this)
        breathing = ValueAnimator.ofFloat(0f, 1f).apply {
            duration = 4200
            repeatMode = ValueAnimator.REVERSE
            repeatCount = ValueAnimator.INFINITE
            addUpdateListener { ring.phase = it.animatedValue as Float }
            start()
        }

        val clock = FrameLayout(this).apply {
            addView(ring, FrameLayout.LayoutParams(dp(260), dp(260), Gravity.CENTER))
            addView(
                LinearLayout(context).apply {
                    orientation = LinearLayout.VERTICAL
                    gravity = Gravity.CENTER_HORIZONTAL
                    addView(time)
                    addView(date)
                },
                FrameLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, Gravity.CENTER),
            )
        }

        val snoozeMinutes = Engine.config(this).snoozeMinutes
        snoozeRow = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
            (listOf(snoozeMinutes) + listOf(5, 15, 30).filter { it != snoozeMinutes }).take(3).sorted().forEach { minutes ->
                addView(
                    pill(getString(R.string.snooze_minutes, minutes), semiBold, filled = false) {
                        command(ActionReceiver.ACTION_SNOOZE, minutes)
                    },
                    LinearLayout.LayoutParams(0, dp(48), 1f).apply { marginStart = dp(4); marginEnd = dp(4) },
                )
            }
        }

        val actions = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            addView(
                pill(getString(R.string.action_done), semiBold, filled = true) { command(ActionReceiver.ACTION_DONE) },
                LinearLayout.LayoutParams(MATCH_PARENT, dp(56)),
            )
            addView(
                text(semiBold, 11.5f, TEXT_FAINT).apply {
                    text = getString(R.string.snooze_label).uppercase()
                    letterSpacing = 0.14f
                    gravity = Gravity.CENTER
                },
                LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT).apply { topMargin = dp(28); bottomMargin = dp(10) },
            )
            addView(snoozeRow, LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT))
            addView(
                text(semiBold, 15f, TEXT_MUTED).apply {
                    text = getString(R.string.action_dismiss)
                    gravity = Gravity.CENTER
                    setPadding(0, dp(16), 0, dp(16))
                    setOnClickListener { command(ActionReceiver.ACTION_DISMISS) }
                },
                LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT).apply { topMargin = dp(8) },
            )
        }

        val content = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(dp(28), dp(24), dp(28), dp(16))
            addView(View(context), LinearLayout.LayoutParams(MATCH_PARENT, 0, 1f))
            addView(clock, LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT))
            addView(View(context), LinearLayout.LayoutParams(MATCH_PARENT, 0, 0.6f))
            addView(more)
            addView(title, LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT).apply { topMargin = dp(10) })
            addView(body, LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT).apply { topMargin = dp(8) })
            addView(View(context), LinearLayout.LayoutParams(MATCH_PARENT, 0, 1f))
            addView(actions, LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT))
        }

        val root = FrameLayout(this).apply {
            setBackgroundColor(BACKGROUND)
            addView(content, FrameLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT))
        }
        ViewCompat.setOnApplyWindowInsetsListener(root) { view, insets ->
            val bars = insets.getInsets(WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout())
            view.setPadding(bars.left, bars.top, bars.right, bars.bottom)
            WindowInsetsCompat.CONSUMED
        }
        return root
    }

    private fun font(name: String): Typeface = try {
        Typeface.createFromAsset(assets, "flutter_assets/assets/fonts/$name")
    } catch (_: RuntimeException) {
        Typeface.DEFAULT
    }

    private fun text(typeface: Typeface, sp: Float, color: Int) = TextView(this).apply {
        this.typeface = typeface
        setTextSize(TypedValue.COMPLEX_UNIT_SP, sp)
        setTextColor(color)
        gravity = Gravity.CENTER
        includeFontPadding = false
    }

    private fun pill(label: String, typeface: Typeface, filled: Boolean, onClick: () -> Unit) =
        text(typeface, 15f, if (filled) BACKGROUND else TEXT).apply {
            text = label
            background = GradientDrawable().apply {
                cornerRadius = dp(28).toFloat()
                if (filled) setColor(SAGE) else setStroke(dp(1), LINE_STRONG)
            }
            isClickable = true
            isFocusable = true
            setOnClickListener { onClick() }
        }

    private fun dp(value: Int) = (value * resources.displayMetrics.density).toInt()

    /** A thin birch-colored ring that slowly breathes behind the clock. */
    private class BreathingRing(context: Context) : View(context) {
        private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            color = BIRCH
        }

        var phase = 0f
            set(value) {
                field = value
                invalidate()
            }

        override fun onDraw(canvas: Canvas) {
            val density = resources.displayMetrics.density
            val maxRadius = minOf(width, height) / 2f - 4 * density
            val radius = maxRadius * (0.86f + 0.14f * phase)
            paint.strokeWidth = 1.2f * density
            paint.alpha = (60 + 90 * (1 - phase)).toInt()
            canvas.drawCircle(width / 2f, height / 2f, radius, paint)
            paint.alpha = (25 + 35 * phase).toInt()
            canvas.drawCircle(width / 2f, height / 2f, radius * 0.82f, paint)
        }
    }

    companion object {
        private const val EXTRA_SPECS = "specs"
        private const val FALLBACK_NOTIFICATION_ID = 1004

        private val BACKGROUND = Color.parseColor("#121314")
        private val TEXT = Color.parseColor("#ECE8E1")
        private val TEXT_MUTED = Color.parseColor("#9A9893")
        private val TEXT_FAINT = Color.parseColor("#65645F")
        private val LINE_STRONG = Color.parseColor("#3C4146")
        private val SAGE = Color.parseColor("#8FA89B")
        private val BIRCH = Color.parseColor("#D9CBB3")

        /** Shows the alarm via a full-screen notification when the ring service cannot start from the background. */
        fun launchFallback(context: Context, specs: List<Spec>) {
            val intent = Intent(context, AlarmActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                .putExtra(EXTRA_SPECS, JSONArray(specs.map(Codec::spec)).toString())
            val pending = PendingIntent.getActivity(
                context,
                FALLBACK_NOTIFICATION_ID,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            val spec = specs.first()
            val notification = NotificationCompat.Builder(context, Notifier.CHANNEL_ALARM)
                .setSmallIcon(R.drawable.ic_stat_klar)
                .setContentTitle(spec.title)
                .setContentText(spec.body)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setFullScreenIntent(pending, true)
                .setContentIntent(pending)
                .setAutoCancel(true)
                .build()
            context.getSystemService(NotificationManager::class.java).notify(FALLBACK_NOTIFICATION_ID, notification)
        }
    }
}
