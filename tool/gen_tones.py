#!/usr/bin/env python3
"""Generates Klar's bundled alarm tones into android/app/src/main/res/raw.

Soft additive bells with exponential decay, mono 16-bit 22.05 kHz WAV. Each file is one loop:
the engine loops it while ringing and fades the volume in.

    python3 tool/gen_tones.py
"""
import math
import os
import random
import struct
import wave

RATE = 22050
OUT = os.path.join(os.path.dirname(__file__), '..', 'android', 'app', 'src', 'main', 'res', 'raw')


def bell(freq, start, duration, length, gain=0.5, partials=((1, 1.0), (2.0, 0.35), (3.01, 0.12)), decay=2.6):
    """Returns (start sample, samples) of a struck bell."""
    n = int(duration * RATE)
    out = [0.0] * n
    for ratio, amp in partials:
        f = freq * ratio
        d = decay * (1 + ratio * 0.6)
        for i in range(n):
            t = i / RATE
            attack = min(1.0, t / 0.006)
            out[i] += gain * amp * attack * math.exp(-d * t) * math.sin(2 * math.pi * f * t)
    return int(start * RATE), out


def render(name, length, notes):
    total = int(length * RATE)
    mix = [0.0] * total
    for start, samples in notes:
        for i, value in enumerate(samples):
            j = start + i
            if j < total:
                mix[j] += value
    peak = max(abs(v) for v in mix) or 1.0
    scale = 0.85 / peak
    # Short fade at the loop point avoids clicks.
    fade = int(0.02 * RATE)
    for i in range(fade):
        mix[total - 1 - i] *= i / fade
    path = os.path.join(OUT, name + '.wav')
    with wave.open(path, 'wb') as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(RATE)
        f.writeframes(b''.join(struct.pack('<h', int(v * scale * 32767)) for v in mix))
    print('wrote', os.path.relpath(path))


def fjord():
    """Two warm marimba-like notes, a falling fifth, then a pause."""
    marimba = ((1, 1.0), (3.99, 0.18), (9.8, 0.04))
    notes = [
        bell(659.25, 0.0, 1.6, 4.0, partials=marimba, decay=3.2),  # E5
        bell(493.88, 0.42, 1.8, 4.0, partials=marimba, decay=3.0),  # B4
        bell(659.25, 1.6, 1.6, 4.0, partials=marimba, decay=3.2, gain=0.35),
        bell(493.88, 2.02, 1.9, 4.0, partials=marimba, decay=2.8, gain=0.35),
    ]
    render('klar_fjord', 4.0, notes)


def bjork():
    """Sparse wind chimes on a pentatonic scale."""
    rng = random.Random(7)
    scale = [783.99, 880.0, 1046.5, 1174.66, 1318.51, 1567.98]
    chime = ((1, 1.0), (2.76, 0.25), (5.4, 0.08))
    notes = []
    t = 0.0
    while t < 5.2:
        notes.append(bell(rng.choice(scale), t, 2.0, 6.0, gain=rng.uniform(0.25, 0.5), partials=chime, decay=1.8))
        t += rng.uniform(0.28, 0.75)
    render('klar_bjork', 6.0, notes)


def frost():
    """A single glassy bell with a soft shimmer, struck every three seconds."""
    glass = ((1, 1.0), (2.76, 0.4), (5.4, 0.2), (8.93, 0.08))
    notes = [
        bell(1046.5, 0.0, 2.9, 3.0, partials=glass, decay=1.4),
        bell(1052.0, 0.0, 2.9, 3.0, partials=((1, 0.4),), decay=1.6, gain=0.3),
    ]
    render('klar_frost', 3.0, notes)


if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    fjord()
    bjork()
    frost()
