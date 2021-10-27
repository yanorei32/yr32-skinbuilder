# yr32's osu! skin

![Build](https://img.shields.io/github/workflow/status/yanorei32/yr32-skinbuilder/release?logo=github&style=for-the-badge)
![License](https://img.shields.io/github/license/yanorei32/yr32-skinbuilder.svg?style=for-the-badge&color=blue)
![Top Language](https://img.shields.io/github/languages/top/yanorei32/yr32-skinbuilder.svg?style=for-the-badge)

## A simple, lightweight, open-source osu! skin

![Demo](https://github.com/yanorei32/yr32-skinbuilder/raw/contents/demo.gif)

## Installation (latest)

Prebuild binaries can be downloaded from this link.

https://github.com/yanorei32/yr32-skinbuilder/releases

### Officially supported platforms

* **osu! (Windows) (complete)**
* **osu!lazer (Windows / Linux / Android) (complete)**
* McOsu (Windows) (partially)

### No longer supported platforms
* opsu! (Windows / Android)

## Recommended settings

### osu!

| Key                                                    | Value |
|:-------------------------------------------------------|:------|
| Graphics/DETAIL SETTINGS/Hit lighting                  | false |
| Gameplay/GENERAL/Background dim                        | 90% + |
| Gameplay/GENERAL/Dont't change dim level during breaks | true  |
| Skin/SKIN/Ignore all beatmap skins                     | true  |
| Skin/SKIN/Always use skin cursor                       | true  |

### osu!lazer

| Key                                                          | Value |
|:-------------------------------------------------------------|:------|
| Gameplay/General/Hit lighting                                | false |
| Gameplay/Beatmap/Beatmap skins                               | false |
| Gameplay/Beatmap/Beatmap colours                             | false |
| Gameplay/Beatmap/Beatmap hitsounds                           | false |
| Gameplay/Background/Background dim                           | 90% + |
| Gameplay/Background/Background blur                          | 50% + |
| Gameplay/Background/Lighten playfield during breaks          | false |
| Gameplay/Background/Fade playfield to red when health is low | false |

## Self-build .osk file from shellscript

### Officially supported build paltforms

* Arch Linux
* Debian GNU/Linux
* WSL2 (Windows / Ubuntu)
* Termux (Android)

### Pre-requirements for build

* ffmpeg
* curl
* zip / unzip
* imagemagick
* bc

### Build .osk file

```bash
git clone https://github.com/yanorei32/yr32-skinbuilder
cd yr32-skinbuilder

./build.sh
```

