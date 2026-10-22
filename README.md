# Metal Gear Collection (MetalGearLegends)

Native macOS SwiftUI shell for the Metal Gear catalog — CODEC-inspired UI, Xbox controller navigation, menu audio hook. Emulators (RetroArch / PCSX2) land in later phases.

**Phase 1:** visual prototype only. Selecting a game shows a coming-soon stub; no ROM/BIOS required.

## Requirements

- macOS 14+ (Apple Silicon)
- **Xcode 15+** (full app from the Mac App Store or [developer.apple.com](https://developer.apple.com/xcode/) — Command Line Tools alone are not enough)
- Optional: Xbox controller; keyboard arrows / Return / Esc work for debugging
- Optional menu audio: place `menu_ambient.mp3` (or `.m4a` / `.wav`) in  
  `~/Library/Application Support/MetalGearCollection/Audio/`  
  or `~/Documents/MetalGearCollection/Audio/`

## Open & run

```bash
cd /path/to/MetalGearLegends
open MetalGearCollection.xcodeproj
```

Scheme / target: **MetalGearCollection**. Product → Run (⌘R).

CLI (after Xcode is selected as the active developer directory):

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcodebuild -scheme MetalGearCollection -project MetalGearCollection.xcodeproj -configuration Debug build
```

## Layout

| Path | Role |
| --- | --- |
| `MetalGearCollection/` | App sources |
| `…/Models/CatalogGame.swift` | Phase 1–4 catalog |
| `…/Services/GameControllerNavigator.swift` | GameController + KB fallback |
| `…/Services/MenuAudioPlayer.swift` | Ambient audio (graceful skip) |
| `…/Services/EmulatorLauncher.swift` | Stub for RetroArch/PCSX2 |
| `…/Views/` | Library, briefing, coming-soon UI |

## Catalog (Phase markers)

Metal Gear MSX2/NES, MG2, MGS, VR Missions, MGS2, MGS3 — covers are placeholders until user assets are added.
