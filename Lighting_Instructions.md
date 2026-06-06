# Pseudo 2.5D Relight — Usage Guide

## Overview
This shader simulates directional lighting on flat images/video using luminance-based pseudo-depth and edge gradients.

It creates the illusion of 3D form by treating brightness changes as surface structure rather than true geometry.

---

## How it works (simple view)

- Brightness = depth approximation
- Pixel-to-pixel changes = surface slope
- Light position = virtual lamp in 2D space
- Graphite system = tone compression (not depth shaping)

---

## Basic Setup

1. Apply shader to a video source in OBS
2. Start with default settings
3. Adjust **Light X / Light Y** to position the light
4. Adjust **Intensity** for how strong the lighting effect feels

---

## Recommended Tuning Order

### 1. Light Position
- `Light X` → moves light left / right
- `Light Y` → moves light up / down

Think of it as dragging a lamp across the image.

---

### 2. Intensity
Controls how strong the lighting deformation feels.

- Low values → subtle shaping
- High values → strong sculpted lighting

Recommended range: 0.01 – 0.03

---

### 3. Softness
Controls how quickly light fades outward.

- Higher softness → wide, soft lighting falloff
- Lower softness → tight, focused lighting hotspot

---

### 4. Depth Exponent
Controls how strongly brightness is interpreted as depth.

- 1.0 → natural / balanced response
- Higher values → stronger contrast in perceived depth
- Lower values → flatter, smoother surface feel

---

### 5. Mask Controls (Advanced)

These isolate where the lighting effect applies based on brightness structure.

- `Mask Min` → lower bound of affected range
- `Mask Max` → upper bound of affected range
- `Mask Mid` → center pivot for optional mid-focus shaping
- `Mask Feather` → smooth blending between boundaries

### Important behavior note:
Mask Min/Max define a **selection window**, not compression or remapping.
They do not shift brightness globally — they only control *where lighting applies*.

---

### 6. Graphite Response (Luminance Compression)

This is a **tone mapping system**, not a depth system.

It remaps final brightness into a controlled range:

- `Min Lum` → lifts darkest values up
- `Max Lum` → clamps brightest values down
- `Dark Response` → shifts how shadows curve inside that range

### Correct behavior model:

- Darkest pixels → pulled upward toward `Min Lum`
- Brightest pixels → pulled downward toward `Max Lum`
- Midtones → redistributed smoothly between them

⚠️ This is NOT inverted anymore:
It behaves the same direction as the selective color shader.

---

### 7. Highlight Compression

Prevents bright areas from clipping.

- `Highlight Start` → where compression begins
- `Highlight Softening` → strength of rolloff

Recommended:
- Start: 0.70
- Softening: 0.10

---

## Tips

- Use low intensity for faces / humans (prevents over-sculpting)
- Higher intensity works well for landscapes, UI, and game footage
- Slight sharpening enhances perceived depth dramatically
- Graphite controls should be adjusted last (after lighting is tuned)

---

## Limitations

- Not true 3D lighting (no real geometry)
- Based entirely on luminance estimation
- Heavy compression can flatten bright scenes
- Masking does not create depth — only selection regions

---

## Best Use Cases

- Cinematic OBS scenes
- Game capture enhancement
- UI depth stylization
- Subtle “volumetric feel” for flat video
