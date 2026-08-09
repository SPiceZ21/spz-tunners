# spz-tunners

> Keyboard-driven vehicle tuning and customization · `v1.0.0`

## Overview

`spz-tunners` is a tuning menu built entirely on `ox_lib`'s keyboard menu — no mouse, no
NUI. It inspects the vehicle for available mods, colours, wheels, extras and neons,
previews each option live as you scroll, and moves a cinematic camera to the part being
changed. Standalone apart from `ox_lib`.

## Features

- **Keyboard-only menu** via `lib.registerMenu` — navigate, side-scroll, apply, back.
- **Dynamic inspection** — queries `GetNumVehicleMods`, colours, wheel types, extras, neons.
- **Live preview** — options apply as you scroll, with rollback on cancel.
- **Cinematic camera** — focuses engine, hood, spoiler, bumpers, wheels, interior, roof.
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
