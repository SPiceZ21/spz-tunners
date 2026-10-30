# spz-tunners

> Keyboard-driven tuning and customisation menu.

![version](https://img.shields.io/badge/version-1.2.3-ff6200) ![SPiceZ-Core](https://img.shields.io/badge/SPiceZ--Core-beta-18181b)

## Overview

A full tuning menu built on ox_lib: performance parts, body parts, paint (incl. chameleon), wheels, neon, liveries. Used in freeroam, in race warmup (`Y`) and by Hot Pursuit's car setup.

## Features

- Performance and cosmetic parts
- Chameleon paints
- Saved and re-applied by spz-vehicles

## Requirements

| Resource | Type |
|---|---|
| `ox_lib` | third-party |

## Installation

Included in the [txAdmin recipe](https://github.com/SPiceZ21/spz-txrecipe). Manual install:

1. Download `spz-tunners` from GitHub (latest release, or the repository) into your `resources` folder.
2. Add to `server.cfg`, after its requirements:

```cfg
ensure spz-tunners
```

## Configuration

- `config.lua`

See the file for every option.

## Commands

| Command | Who | Description |
|---|---|---|
| `/customs` | player | Open customs |
| `/save_customs` | player | Save the current setup |
| `/tune` | player | Open the tuner |

## Exports

| Export | Side |
|---|---|
| `ApplyVehicleMods` | client |
| `GetVehicleMods` | client |
| `OpenTunerMenu` | client |

```lua
exports["spz-tunners"]:ApplyVehicleMods(...)
```

---

Part of **SPiceZ-Core** — [documentation](https://github.com/SPiceZ21/Docs) · [all modules](https://github.com/SPiceZ21/Docs/blob/main/modules/README.md)
