# Real-Time Visual Enhancement Shaders/Effects

A lightweight collection of real-time OBS shaders focused on **perceptual lighting**, **luminance shaping**, and **motion continuity**.

These shaders improve perceived visual quality without heavy GPU cost, extra render passes, or offline processing.

---

# 🌍 Overview

This repository contains two core systems:

## 1. Pseudo 2.5D Relight Effect
A screen-space lighting system that simulates directional light using luminance gradients and pseudo-depth.

## 2. Motion Persistence Shader
A temporal smoothing system that blends motion over time to reduce perceived frame gaps (useful for 30 FPS content on higher refresh displays).

---

# 💡 Pseudo 2.5D Relight

## What it does

Simulates directional lighting on flat images/video by:

- estimating pseudo-depth from luminance
- deriving surface direction from pixel gradients
- applying directional lighting + highlight compression
- remapping luminance using a controllable “graphite response curve”

This creates the illusion of **depth, volume, and lighting in 2D content**.

---

## Key Features

- Screen-space pseudo-3D lighting
- Adjustable light position (X/Y)
- Warm/cool key tinting
- Depth-based masking system
- Graphite luminance compression system
- Highlight rolloff (film-style compression)
- Fully real-time (single pass, OBS-safe)

---

## Recommended Settings (General Use)

| Control | Value |
|--------|------|
| Light Softness | 1.0 |
| Intensity | 0.01 – 0.03 |
| Highlight Start | 0.90 – 0.95 |
| Highlight Softening | 0.05 – 0.10 |
| Depth Exponent | 1.0 |
| Graphite Dark Response | ~0.9 – 1.0 |
| Max Luminance | 0.995 |
| Min Luminance | 0.005 |

---

# 🌑 Graphite Luminance System (IMPORTANT)

This replaces simple brightness with a **controlled compression mapping system**.

## What it does

Instead of leaving brightness linear:

- Dark values are gently lifted toward `Min Lum`
- Bright values are gently compressed toward `Max Lum`
- Midtones are preserved unless modified by shadow weighting

---

## Mental Model (IMPORTANT)

Think of it like this:

```
Before:
0.00 → black
1.00 → pure white

After:
0.00 → lifted to MinLum (not pure black)
1.00 → compressed to MaxLum (not pure white)
```

Then the entire range is redistributed smoothly between them.

---

## Graphite Dark Response

Controls how strongly shadows are reshaped.

- Lower values → more linear / natural
- Higher values → stronger “ink / graphite lift”
- Uses a shadow-weighted curve so only darker regions are affected more heavily

---

# 🧠 Mid Pivot System (HINGE EXPLAINED)

## What “Use Mid Pivot” does

The mid pivot acts like a **hinge point in luminance space**.

Imagine a folding door:

```
Dark side  ←───── hinge ─────→ Bright side
```

## Behavior

- Values **below Mid** → pulled darker or suppressed
- Values **above Mid** → lifted or brightened
- The pivot itself stays stable

---

## Simple explanation

- Mid = neutral anchor
- Below mid = “falls into shadow side”
- Above mid = “lifts into highlight side”

---

## When to use it

- Faces (subtle sculpting)
- UI separation
- Cinematic lighting control
- Depth isolation inside flat scenes

---

## Recommended Mid Range

| Use Case | Value |
|----------|------|
| Natural balance | 0.45 – 0.55 |
| Dark-heavy scenes | 0.35 – 0.45 |
| Bright UI / overlays | 0.55 – 0.70 |

---

# 💡 Highlight Controls

Prevents bright areas from clipping or flattening.

- `Highlight Start` → where compression begins
- `Highlight Softening` → how gradual the rolloff is

Recommended:
- Start: 0.90 – 0.95
- Softening: 0.05 – 0.10

---

# 🎞 Motion Persistence Shader

## What it does

Simulates temporal continuity by blending:

- current frame
- previous frame buffer
- motion-direction sampling

This reduces perceived stutter in lower FPS content.

---

## Key Features

- Motion-based temporal blending
- Directional blur along motion vectors
- Depth-aware persistence control
- Adjustable decay (trail length)
- Perceptual motion weighting

---

## Recommended Settings

| Control | Value |
|--------|------|
| Motion Strength | 0.6 – 0.8 |
| Decay Clamp | 0.03 – 0.08 |
| Depth Influence | 0.2 – 0.4 |
| Frame Time | 0 (Raw Mode) or match FPS |

---

## Frame Time Modes

### 🧭 Calibrated Mode (accurate timing)

| FPS | Frame Time |
|-----|-----------|
| 60 | 0.0167 |
| 30 | 0.0333 |
| 24 | 0.0416 |

---

### 🌙 Raw Mode (recommended default)

- Frame Time = 0
- Shader derives behavior from runtime sampling

---

# ⚙️ How to Use (OBS)

1. Install OBS Shader Filter plugin (Exeldro or equivalent)
2. Add filter → “Custom Shader”
3. Load `.shader` / `.effect` file
4. Apply to:
   - Game capture
   - Display capture
   - Media sources

---

# 🧠 Design Philosophy

These shaders prioritize:

- perceptual improvement over physical accuracy  
- real-time performance over simulation fidelity  
- minimal sampling cost  
- controllable aesthetic response  
- OBS pipeline compatibility  

The goal is not realism alone — but **better perceived clarity, depth, and motion stability in live viewing conditions**.

---

# 🔧 Performance Notes

- Single-pass rendering
- No compute shaders
- No external dependencies
- Designed for 30–60 FPS streaming
- Motion shader is heavier due to temporal sampling, but GPU-safe on modern hardware

---

# 🌙 Intended Use Cases

- Live streaming (Twitch / YouTube)
- Game capture enhancement
- Cinematic OBS scenes
- UI depth styling
- Low-FPS → high-refresh perception smoothing

---

# ⚖️ Notes

- Motion persistence requires proper previous-frame buffer support in OBS
- FrameTime accuracy improves motion realism but is optional
- Graphite system is intentionally non-linear for perceptual shaping

---

# 📌 Summary

Two systems working together:

- **Relight Shader → spatial perception (light + depth illusion)**
- **Motion Shader → temporal perception (motion continuity)**

Combined, they enhance perceived realism without increasing resolution or render cost.
