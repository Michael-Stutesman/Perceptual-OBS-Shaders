# Pseudo 2.5D Relight — Usage Guide (Updated Build)

## Overview
This shader simulates directional lighting on flat images/video using luminance-based pseudo-depth and edge gradients.

It creates the illusion of 3D form by interpreting brightness as surface height, then applying virtual lighting across that structure.

Graphite controls handle final tone compression separately from lighting.

---

## How it works (simple view)

- Brightness = pseudo depth
- Pixel differences = surface slope
- Light position = virtual lamp in 2D space
- Graphite system = final luminance tone mapping (NOT depth)

---

## Basic Setup

1. Apply shader to a video source in OBS
2. Start with default settings
3. Move **Light X / Light Y** to position the light
4. Adjust **Intensity** to control sculpt strength

---

## Recommended Tuning Order

### 1. Light Position
- `Light X` → horizontal movement
- `Light Y` → vertical movement

This is your “virtual lamp.”

---

### 2. Intensity
Controls how strongly the surface reacts to light.

- Low values → subtle shaping
- High values → strong sculpted depth

Recommended range: **0.01 – 0.03**

---

### 3. Softness
Controls light falloff radius.

- High → wide, soft illumination
- Low → tight, focused hotspot

---

### 4. Depth Exponent
Controls how strongly brightness becomes “height.”

- 1.0 → balanced / natural
- Higher → stronger contrast in perceived depth
- Lower → flatter surface response

---

## 5. Mask System (Important Behavior Change)

These do NOT change brightness.

They only define **where lighting is allowed to act.**

- `Mask Min` → lower bound of allowed depth region
- `Mask Max` → upper bound of allowed depth region
- `Mask Feather` → smooth transition edges

### Mask behavior summary:
- Inside range → lighting applies
- Outside range → no lighting influence
- This is a spatial filter, not a tone remap

---

## 6. Mid Pivot (IMPORTANT — Directional Behavior)

This is often misunderstood.

### What it actually does:

`Mask Mid` is not a blend point.

It is a **directional bias point** inside the depth space.

### Behavior:

- Values **below Mid** → pushed toward *darker / recessed influence*
- Values **above Mid** → pushed toward *brighter / elevated influence*

### In simple terms:

Think of it like a hinge: dark shadows ←────── MID PIVOT ──────→ bright highlights

### What it affects:
- Below Mid → compresses toward shadow behavior
- Above Mid → expands toward highlight behavior

### What it does NOT do:
- It does NOT average or flatten values
- It does NOT symmetrically blend both sides

---

## 7. Graphite Luminance Compression (FINAL TONE STAGE)

This happens AFTER lighting.

It remaps final brightness into a controlled range.

### Correct behavior:

- `Min Lum` → lifts darkest values upward
- `Max Lum` → compresses brightest values downward
- `Dark Response` → controls how shadows curve inside that range

### Key concept:
This is **tone mapping**, not depth or masking.

---

### Mental model:

Before Graphite:
- Lighting creates shape and contrast

After Graphite:
- Entire image is “re-toned” into a controlled luminance range

---

## 8. Highlight Compression

Prevents clipping in bright regions.

- `Highlight Start` → where compression begins
- `Highlight Softening` → how gradually it rolls off

Recommended:
- Start: 0.95 (your current)
- Softening: 0.05

---

## Tips

- Lower intensity for faces / human subjects
- Higher intensity works well for UI, game footage, and graphics
- Mid Pivot is powerful — small adjustments matter a lot
- Graphite should be tuned LAST (after lighting feels right)

---

## Limitations

- Not true geometry lighting
- Based entirely on luminance approximation
- Strong Graphite compression can reduce contrast detail
- Mask system does not create depth — only controls influence zones

---

## Best Use Cases

- Cinematic OBS scenes
- Game capture enhancement
- UI depth sculpting
- Stylized “2.5D” lighting illusion
