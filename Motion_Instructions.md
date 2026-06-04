# Motion Persistence Shader — Usage Guide

## Overview
This shader reduces perceived stutter by blending motion over time using a previous frame buffer and motion-aware directional sampling.

It makes 30 FPS content feel smoother on high refresh displays without true frame interpolation.

---

## How it works (simple view)

- Compares current frame vs previous frame
- Detects motion via luminance difference
- Builds motion direction vector
- Blends along motion path

Result: smoother perceived movement without generating fake frames.

---

## Basic Setup

1. Apply shader to your source in OBS
2. Ensure `previous_output` is supported (required)
3. Set `Frame Time` to match your source FPS

---

## Critical Setting: Frame Time

This is extremely important.

| FPS Source | Frame Time |
|-----------|------------|
| 60 FPS | 0.0167 |
| 30 FPS | 0.0333 |
| 24 FPS | 0.0416 |

Incorrect values will break motion accuracy.

---

## Recommended Settings: Motion Strength: 0.7 | Decay Clamp: 0.05 | Depth Influence: 0.3

---

## Controls Explained

### Motion Strength
Controls how much past frames influence the image.

- Low → subtle smoothing
- High → strong motion continuity

---

### Decay Clamp
Controls trail length.

- Low → short, crisp motion
- High → long ghost trails

---

### Depth Influence
Controls how motion behaves based on brightness.

- Dark areas → reduced motion persistence
- Bright areas → more visible trails

This helps preserve perceived sharpness.

---

## Visual Behavior

- Fast motion becomes smoother
- Camera pans feel less choppy
- UI elements glide more naturally
- No frame duplication artifacts

---

## Limitations

- Requires previous frame buffer support
- Can introduce ghosting at very high strength
- Not true interpolation (no new frames are generated)

---

## Best Use Cases

- 30 FPS gameplay streams
- Console capture smoothing
- High refresh display playback
- Motion-heavy scenes (FPS games, camera pans)

---

## Pro Tips

- Lower strength for competitive gameplay (clarity first)
- Increase decay slightly for cinematic feel
- Match frame time exactly for best stability