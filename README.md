# spz-tunners

> Keyboard-driven vehicle tuning and customization · `v1.0.0`

## Overview

`spz-tunners` is a tuning menu built entirely on `ox_lib`'s keyboard menu (the mouse only drives the camera), no
NUI. It inspects the vehicle for available mods, colours, wheels, extras and neons,
previews each option live as you scroll, and moves a cinematic camera to the part being
changed. Standalone apart from `ox_lib`.

## Features

- **qbx_customs-style menu** via `lib.registerMenu`:
  - ←/→ previews on the car; Enter installs ("Installed" + chime), or says "Already installed".
  - Backspace leaves a menu and puts back anything you previewed but didn't install.
  - Backing out returns to the row you came from; a damaged car gets a Repair-only menu.
  - Tree: Performance · Parts (body + interior mods, plate style/text, Wheels) · Cosmetics &
    Colors (Primary/Secondary paint, Neon, xenon, pearlescent, wheel colour, tint, tyre
    smoke, interior, livery) · Extras.
- **Dynamic inspection** — only shows the mods, wheels, liveries and extras the car actually has.
- **Drag camera** (same behaviour as qbx_customs) — one camera for the whole session; the
  cursor stays on screen, hold left mouse and drag to orbit, scroll to zoom, Space toggles
  the doors, V switches to first person. The car can't be driven while the tuner is open.
- **Chameleon paints** — all 82 named chameleons (161–242), for the whole car, primary,
  secondary or pearlescent. 223–242 (Fubuki-jo specials) come from `data/*.meta`, registered
  with `data_file`, plus `stream/vehicle_paint_ramps.ytd`. Needs game build 2944+.
- **Shop zones** — garage markers plus `/tune` anywhere, and exports for other resources.

## Structure

| Side | File | Purpose |
|---|---|---|
| Shared | `config.lua` | Shop locations, camera and menu configuration |
| Shared | `shared/colors.lua` | Colour palettes, neons, xenons, wheels |
| Client | `client/main.lua` | Commands, shop zones, prompts, exports |
| Client | `client/menu.lua` | Menu builder and live preview engine |
| Client | `client/cam.lua` | Cinematic camera positioning |
| Server | `server/main.lua` | Statebag persistence and database writes |

## Controls

| Key | Action |
|---|---|
| ↑ / ↓ | Navigate menu items |
| ← / → | Side-scroll options with live preview |
| `ENTER` | Apply and confirm |
| `BACKSPACE` / `ESC` | Back / exit |

## Exports

```lua
exports['spz-tunners']:OpenTunerMenu()
local mods = exports['spz-tunners']:GetVehicleMods(vehicle)
exports['spz-tunners']:ApplyVehicleMods(vehicle, mods)
exports['spz-tunners']:SaveTunerPreset(vehicle)
```

## Commands

`/tune` · `/customs`

## Dependencies

`ox_lib`

---

Part of [SPiceZ-Core](../README.md) · GPL-3.0
