<div align="center">

<img src="https://github.com/SPiceZ21/spz-core-media-kit/raw/main/Banner/Banner%232.png" alt="SPiceZ-Core Banner" width="100%"/>

<br/>

# spz-tunners
> Dynamic Keyboard-Driven Vehicle Tuning & Customization · `v1.0.0`

## Scripts

| Side   | File                | Purpose                                                 |
| ------ | ------------------- | ------------------------------------------------------- |
| Shared | `config.lua`        | Tuner shop locations, camera, and menu configurations   |
| Shared | `shared/colors.lua` | Predefined color palettes, neons, xenons, and wheels    |
| Server | `server/main.lua`   | Statebag persistence and database integration           |
| Client | `client/cam.lua`    | Dynamic cinematic camera positioning for tuning parts   |
| Client | `client/menu.lua`   | Core ox_lib keyboard menu builder & live preview engine |
| Client | `client/main.lua`   | Commands, shop zones, ox_lib prompts, and exports       |

## Features

- **100% Keyboard-Navigated Menu**: Built using `ox_lib`'s `lib.registerMenu` (Up/Down navigation, Left/Right side-scrolling preview, Enter to apply, Backspace to exit).
- **Dynamic Vehicle Inspection**: Automatically queries available mods (`GetNumVehicleMods`), colors, wheel types, extras, and neons.
- **Live Real-Time Preview**: Instant visual preview as options are side-scrolled, with automatic rollback if canceled.
- **Cinematic Camera System**: Smoothly focuses on the component being modified (Engine, Hood, Spoiler, Bumpers, Wheels, Interior, Roof).
- **Standalone & Export Friendly**: Command `/tuner`, garage shop markers, and client/server exports.

## Keyboard Controls

| Key | Action |
| --- | ------ |
| **Up / Down (↑ / ↓)** | Navigate menu items |
| **Left / Right (← / →)** | Side-scroll options / Live preview |
| **ENTER** | Apply & confirm modification |
| **BACKSPACE / ESC** | Go back / Exit menu |

## Exports

```lua
-- Open tuner menu for current vehicle
exports['spz-tunners']:OpenTunerMenu()

-- Capture vehicle mods snapshot
local mods = exports['spz-tunners']:GetVehicleMods(vehicle)

-- Apply vehicle mods preset
exports['spz-tunners']:ApplyVehicleMods(vehicle, mods)
```

## Dependencies
- ox_lib

## CI
Built and released via `.github/workflows/release.yml` on push to `main`.
