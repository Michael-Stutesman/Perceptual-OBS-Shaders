# Pseudo 2.5D Relight — Usage Guide

## Overview
This shader simulates directional lighting on flat images/video using luminance-based pseudo-depth and edge gradients.

It creates the illusion of 3D form by treating brightness changes as surface orientation.

---

## How it works (simple view)

- Brightness = height/depth approximation
- Pixel differences = surface slope
- Light position = virtual light source
- Highlight system = controlled rolloff

---

## Basic Setup

1. Apply shader to a video source in OBS
2. Start with default settings
3. Adjust **Light X / Light Y** to move the light
4. Increase or decrease **Intensity** for stronger or softer depth

---

## Recommended Tuning Order

### 1. Light Position
- `Light X` → left/right movement
- `Light Y` → up/down movement

Think of it like dragging a lamp around the scene.

---

### 2. Intensity
Controls how strong the depth illusion feels.

- Low values → subtle shaping
- High values → strong sculpted lighting

Recommended range: 0.01- 0.03

---

### 3. Softness
Controls how quickly light fades outward.

- High softness → wide, soft light
- Low softness → tight, focused light

---

### 4. Depth Exponent
Controls how strongly brightness is interpreted as depth.

- 1.0 → balanced
- Higher → more contrast in depth
- Lower → flatter surface response

---

### 5. Mask Controls (Advanced)

Used to isolate where lighting applies.

- `Mask Min / Max` → depth range selection
- `Mask Mid` → focal depth pivot (Brightens above, Darkens below)
- `Mask Feather` → smooth blending between zones

Leave default unless doing targeted stylization.

---

### 6. Highlight Controls

Prevents bright areas from clipping or blowing out.

- `Highlight Start` → where compression begins
- `Highlight Softening` → how strong the rolloff is

Recommended: Start: 0.70 | Softening: 0.10

Behavior:
- Below threshold → unchanged
- Above threshold → gradually compressed

---

## Tips

- Lower intensity for face cam / human subjects
- Higher intensity works well for landscapes or UI capture
- Combine with slight sharpening for stronger depth illusion

---

## Limitations

- Not true 3D lighting
- Based on luminance, not geometry
- Strong compression can flatten very bright scenes

---

## Best Use Cases

- Game capture enhancement
- Cinematic OBS scenes
- UI depth stylization
- Streaming overlays
