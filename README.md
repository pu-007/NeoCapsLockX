# CapsLockX

CapsLock enhancement + komorebi window management + mouse control + vim-like editing.

AHK v1. Run: `.\AutoHotkey\AutoHotkeyU64.exe CapsLockX.ahk`

## Layers

| Trigger | Layer |
|----------|-------|
| `CapsLock` hold | Window + Mouse (no toggle needed) |
| `CapsLock+Space` | Toggle full mode (mouse + window, no holding required) |
| `CapsLock` tap | Exit full mode / Send Esc |
| `Space` hold | Text editing + Reload |
| `Esc` | Exit full mode / toggle CapsLock indicator |

---

## CapsLock - Window + Mouse

**Two ways to activate:**
- **Toggle ON** (`CapsLock+Space`): All keys below work freely without holding CapsLock. Press `CapsLock` to exit.
- **Hold CapsLock**: Quick access, release CapsLock to exit.

### Mouse
| Key | Action |
|-----|--------|
| `W/A/S/D` | Mouse move (accelerated) |
| `Shift+WASD` | Slow/precise move |
| `Q/E` | Left/right click (hold to drag) |
| `R/F` | Scroll up/down (accelerated) |

### Focus & Move
| Key | Action |
|-----|--------|
| `H/J/K/L` | Focus window left/down/up/right |
| `Shift+H/J/K/L` | Move window |

### Workspace
| Key | Action |
|-----|--------|
| `1~9` | Switch workspace |
| `Shift+1~9` | Move window to workspace |

### Monitor
| Key | Action |
|-----|--------|
| `F1/F2` | Focus monitor 0/1 |
| `Shift+F1/F2` | Move window to monitor 0/1 |

### Window Ops
| Key | Action |
|-----|--------|
| `Z` | Close window |
| `Shift+Z` | Kill process |
| `T` | Toggle float |
| `G` | Toggle monocle |
| `M` | Toggle maximize |
| `Shift+M` | Minimize |
| `P` | Promote |
| `Shift+P` | Toggle pause |
| `C` | Toggle Chrome visibility |

### Resize
| Key | Action |
|-----|--------|
| `=/-` | Resize horizontal |
| `Shift+=/-` | Resize vertical |
| `Shift+Arrows` | Resize edge |

### Layout
| Key | Action |
|-----|--------|
| `,/.//` | Vertical-stack / bsp / ultrawide |
| `Shift+,/./` | Right-main / grid / horizontal |
| `PgUp/PgDn` | Cycle layout |
| `Shift+X/Y` | Flip layout |

### Stack & Cycle
| Key | Action |
|-----|--------|
| `;/'` | Cycle stack |
| `\` | Stack / Unstack (with Shift) |
| `[/]` | Cycle focus |
| `Shift+[/]` | Cycle move |

---

## Space - Edit + Reload

### Cursor (Space hold)
| Key | Action |
|-----|--------|
| `H/J/K/L` | Arrow keys (Left/Down/Up/Right) |
| `W/B` | Next/prev word (Ctrl+Right/Left) |
| `Y/O` | PgUp / PgDn |
| `Shift+H` | Home |
| `Shift+L` | End |
| `X` | Delete (forward) |
| `Shift+X` | Delete entire line |

### Vim Operators
After pressing `V` (visual) or `D` (delete) while Space is held:

| Motion | Visual (select) | Delete |
|--------|-----------------|--------|
| `H` | Select left 1 char | Backspace |
| `L` | Select right 1 char | Delete |
| `Shift+H` | Select to line start | Delete to line start |
| `Shift+L` | Select to line end | Delete to line end |
| `J` / `K` | Select line down/up | - |
| `W` | Select next word | Delete next word |
| `B` | Select prev word | Delete prev word |
| `0` | Select to line start | Delete to line start |
| `Shift+4` ($) | Select to line end | Delete to line end |
| `V` (again) | Select entire line | - |
| `D` (again) | - | Delete entire line |

### Reload komorebi
| Key | Action |
|-----|--------|
| `R` | Restart komorebi |
| `Shift+R` | Restart komorebi + yasb |
| `Ctrl+Shift+R` | Restart komorebi + yasb + explorer |

---

## Speed Tuning
Edit `Modules\mouse.ahk`:
- `g_mouseSpeed` (default 1.0) - mouse cursor speed
- `g_scrollSpeed` (default 1.0) - scroll wheel speed

---

## Standalone (extras.ahk)

| Key | Action |
|-----|--------|
| `Ctrl+Shift+Win+Alt+C` | WeChat toggle |
| `Ctrl+Shift+Win+Alt+Q` | QQ toggle |
| `Ctrl+Shift+Win+Alt+N` | WSL nvim |
| `Win+Y` | WSL yazi |
| `Alt+Enter` | Terminal |
| `Alt+Shift+Enter` | Terminal (workdir) |