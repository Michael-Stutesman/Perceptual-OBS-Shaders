# Motion Persistence Shader — Usage Guide

## Overview
This shader reduces perceived stutter by blending motion over time using a previous frame buffer and motion-aware directional sampling.

It makes 30 FPS content feel smoother on high refresh displays without true frame interpolation.

---

## How it works (simple view)

- Compares current frame vs previous frame
- Detects motion via luminance difference
- Builds motion direction vector
- Blends along motion path using stabilized temporal feedback

Result: smoother perceived movement without generating fake frames.

---

## Basic Setup

1. Apply shader to your source in OBS
2. Ensure `previous_output` is supported (required)
3. Set `Frame Time` to match your source FPS

---

## Critical Setting: Frame Time

This controls motion scaling consistency.

| FPS Source | Frame Time |
|-----------|------------|
| 60 FPS | 0.0167 |
| 30 FPS | 0.0333 |
| 24 FPS | 0.0416 |

Incorrect values may affect motion intensity and pacing, but the shader will remain stable due to built-in normalization and stabilization logic.

---

## 🌙 Recommended Mode (Default in this repo)

Set:

Frame Time = 0

This enables the shader’s internal stabilized timing mode.

In this mode:
- motion is normalized internally
- frame pacing differences are smoothed
- behavior remains consistent across sources

This is the recommended configuration for most users in this repository.

---

## Recommended Settings (Default Preset)

Motion Strength: 0.7  
Decay Clamp: 0.05  
Depth Influence: 0.0  
Frame Time: 0 (Recommended Mode)

---

## Controls Explained

### Motion Strength
Controls how much past frames influence the image.

- Low → subtle smoothing
- High → strong motion continuity

---

### Decay Clamp
Controls trail length and persistence cutoff.

- Low → short, crisp motion
- High → long ghost trails

---

### Depth Influence
Controls brightness-based motion behavior.

- Dark areas → reduced persistence
- Bright areas → increased visibility of motion trails

Helps maintain perceived sharpness in mixed lighting scenes.

---

## Visual Behavior

- Fast motion becomes smoother and more continuous
- Camera pans feel less choppy
- UI elements glide more naturally
- Motion trails are stabilized (reduced jitter compared to raw frame-diff methods)

---

## Limitations

- Requires previous frame buffer support
- Can introduce ghosting at very high strength values
- Not true interpolation (no new frames are generated)
- Still approximates motion (no explicit velocity buffer used)

---

## Best Use Cases

- 30 FPS gameplay streams
- Console capture smoothing
- High refresh display playback
- Motion-heavy scenes (FPS games, camera pans, scrolling content)

---

## Pro Tips

- Lower strength for competitive gameplay (clarity first)
- Increase decay slightly for cinematic feel
- Keep Frame Time at 0 (Recommended Mode) unless troubleshooting timing issues
- If motion feels too heavy, reduce Motion Strength before touching other settings

---

## Design Note (Important)

This shader is intentionally designed as a single-pass temporal coherence system, not a true motion vector renderer.

It prioritizes:
- stability
- simplicity
- low overhead
- consistent visual smoothing across varied sources

over physically accurate motion reconstruction.
