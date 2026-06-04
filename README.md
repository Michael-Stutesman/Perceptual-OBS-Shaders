# Real-Time Visual Enhancement Shaders/Effects

A lightweight collection of real-time OBS shaders focused on **perceptual lighting** and **motion continuity**.

These shaders are designed to improve the perceived quality of live video without heavy GPU cost, extra passes, or offline rendering.

---

# 🌍 Overview

This repository contains two core systems:

## 1. Pseudo 2.5D Relight Effect
A screen-space lighting system that simulates directional light using luminance gradients and pseudo-depth.

## 2. Motion Persistence Shader
A temporal smoothing system that blends motion over time to reduce perceived frame gaps (especially useful for 30 FPS streams - Look as if they are displayed at higher refresh rates).

---

# 💡 Pseudo 2.5D Relight

## What it does
Simulates a controllable light source across flat video by:
- estimating pseudo-depth from luminance
- deriving surface direction from pixel gradients
- applying directional shading + highlight control

This creates the illusion of **depth and volume in 2D content**.

---

## Key Features
- Screen-space pseudo-3D lighting
- Adjustable light position (X/Y)
- Warm/cool key tinting
- Depth-based masking system
- Highlight rolloff (film-style compression)
- Fully real-time (no extra passes)

---

## Recommended Settings (General Use)

| Control | Value |
|--------|------|
| Light Softness | 1.0 |
| Intensity | 0.01 – 0.02 |
| Highlight Start | 0.70 |
| Highlight Softening | 0.10 |
| Depth Exponent | 1.0 |

---

## Visual Effect Summary
- Darker areas gain directional shading
- Bright areas gently roll off instead of clipping
- Midtones gain subtle “form”

---

# 🎞 Motion Persistence Shader

## What it does
Simulates temporal motion continuity by blending:
- current frame
- previous frame buffer
- motion-direction sampling

This reduces the “stuttered” feel of lower FPS content when displayed in higher refresh environments.

---

## Key Features
- Motion-based temporal blending
- Directional blur along motion vectors
- Depth-aware persistence control
- Adjustable decay (trail length)
- Perceptual motion weighting

---

## Recommended Settings (General Use)

| Control | Value |
|--------|------|
| Motion Strength | 0.6 – 0.8 |
| Decay Clamp | 0.03 – 0.08 |
| Depth Influence | 0.2 – 0.4 |
| Frame Time | 0 (Recommended Default/Raw Mode) or match stream FPS (e.g. 0.0167 for 60fps, 0.0333 for 30fps) |

---

## Visual Effect Summary
- Reduces perceived judder in motion
- Smooths transitions between frames
- Preserves sharpness while improving continuity
- Creates a subtle “higher FPS feel” without interpolation artifacts

---

## ⚠️ Frame Time Behavior (Important)

This shader supports **two valid operating modes**:

### 🧭 1. Calibrated Mode (recommended for accuracy)
Set Frame Time to match your source FPS:

| FPS | Frame Time |
|-----|-----------|
| 60 FPS | 0.0167 |
| 30 FPS | 0.0333 |
| 24 FPS | 0.0416 |

This produces consistent motion scaling across different content sources.

---

### 🌙 2. Raw Mode (current recommended default)
Frame Time is set to: 0

---

# ⚙️ How to Use (OBS)

1. Install OBS Shader Filter plugin (Exeldro or equivalent)
2. Add filter → “Custom Shader”
3.Load `.shader` or `.effect` file
4. Apply to:
   - Game capture
   - Display capture
   - Media sources

---

# 🧠 Design Philosophy

These shaders prioritize:

- real-time performance over physical accuracy  
- perceptual improvement over raw simulation  
- minimal texture sampling  
- controllable aesthetic response  
- compatibility with OBS pipeline constraints  

The goal is not to “fake reality,” but to **enhance perception in live viewing conditions**.

---

# 🔧 Performance Notes

- Both shaders are single-pass
- No compute shaders
- No external dependencies
- Designed for 30–240 FPS streaming pipelines
- Motion shader is heavier due to 7-sample temporal blur, but still real-time safe on modern GPUs

---

# 🌙 Intended Use Cases

- Live streaming (Twitch / YouTube)
- Game capture enhancement
- Cinematic OBS scenes
- UI / motion design overlays
- Low-FPS → high-refresh perception smoothing

---

# ⚖️ Notes

- Motion persistence depends on correct `previous_output` buffer support in OBS shader pipeline
- FrameTime should be set manually for best accuracy
- Highlight compression is intentionally subtle to avoid “washed” highlights

---

# 📌 Summary

Two systems working together:

- **Relight Shader → adds spatial depth**
- **Motion Shader → adds temporal continuity**

Combined, they create a more stable and visually rich real-time image without increasing render resolution or GPU load significantly.
