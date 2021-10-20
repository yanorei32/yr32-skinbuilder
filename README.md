# yr32's osu! skin

![Build](https://img.shields.io/github/workflow/status/yanorei32/yr32-skinbuilder/build?logo=github&style=for-the-badge)
![License](https://img.shields.io/github/license/yanorei32/yr32-skinbuilder.svg?style=for-the-badge&color=blue)
![Top Language](https://img.shields.io/github/languages/top/yanorei32/yr32-skinbuilder.svg?style=for-the-badge)

yr32's osu! skin - A open-source, simple osu! skin

![Demo](https://github.com/yanorei32/yr32-skinbuilder/raw/contents/demo.gif)

## Installation (latest)

Prebuild binaries can be downloaded from this link.

https://github.com/yanorei32/yr32-skinbuilder/releases/download/latest/yr32-skinbuilder.osk

### Officially supported platforms

* osu! (Windows)
* osu!lazer (Windows / Linux / Android)
* McOsu (Windows)

### No longer supported platforms
* opsu! (Windows / Android)

## Recommended settings

### osu!

| Key                                                      | Value   |
|:---------------------------------------------------------|:--------|
| `Graphics/DETAIL SETTINGS/Hit lighting`                  | `false` |
| `GAMEPLAY/GENERAL/Background dim`                        | `90% +` |
| `GAMEPLAY/GENERAL/Dont't change dim level during breaks` | `true`  |
| `SKIN/SKIN/Ignore all beatmap skins`                     | `true`  |
| `SKIN/SKIN/Always use skin cursor`                       | `true`  |

### osu!lazer

| Key                                                            | Value   |
|:---------------------------------------------------------------|:--------|
| `Gameplay/General/Hit lighting`                                | `false` |
| `Gameplay/Beatmap/Beatmap skins`                               | `false` |
| `Gameplay/Beatmap/Beatmap colours`                             | `false` |
| `Gameplay/Beatmap/Beatmap hitsounds`                           | `false` |
| `Gameplay/Background/Background dim`                           | `90% +` |
| `Gameplay/Background/Background blur`                          | `50% +` |
| `Gameplay/Background/Lighten playfield during breaks`          | `false` |
| `Gameplay/Background/Fade playfield to red when health is low` | `false` |

## Self-build .osk file from shellscript

### Officially supported build paltforms

* Arch Linux
* Debian GNU/Linux
* WSL2/Ubuntu (Windows)
* Termux (Android)

### Pre-requirements for build

* ffmpeg
* curl
* zip / unzip
* imagemagick
* bc

### Build

```bash
git clone https://github.com/yanorei32/yr32-skinbuilder
cd yr32-skinbuilder
./build.sh
```

