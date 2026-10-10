package com.umartin.klar.alarm.ring

import com.umartin.klar.alarm.core.Spec
import java.util.concurrent.CopyOnWriteArraySet

/** Alarms ringing right now, in order; the first one is shown and heard. Lives as long as the process. */
object RingSession {
    private val items = mutableListOf<Spec>()
    private val listeners = CopyOnWriteArraySet<() -> Unit>()

    @Synchronized
    fun snapshot(): List<Spec> = items.toList()

    @Synchronized
    fun current(): Spec? = items.firstOrNull()

    /** Adds new alarms; returns true if the current one changed. */
    fun add(specs: List<Spec>): Boolean = mutate {
        val before = items.firstOrNull()
        specs.filter { new -> items.none { it.key == new.key } }.forEach { items.add(it) }
        before?.key != items.firstOrNull()?.key
    }

    /** Removes alarms matching [predicate]; returns true if the current one changed. */
    fun remove(predicate: (Spec) -> Boolean): Boolean = mutate {
        val before = items.firstOrNull()
        items.removeAll(predicate)
        before?.key != items.firstOrNull()?.key
    }

    private fun mutate(change: () -> Boolean): Boolean {
        val changed = synchronized(this) { change() }
        listeners.forEach { it() }
        return changed
    }

    fun listen(listener: () -> Unit) = listeners.add(listener)

    fun unlisten(listener: () -> Unit) = listeners.remove(listener)
}
