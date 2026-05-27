# CapsLockX

CapsLock enhancement + komorebi window management + mouse control + vim-like editing.

AHK v1. Run: `.\AutoHotkey\AutoHotkeyU64.exe CapsLockX.ahk`

## Layers

| Trigger | Layer |
|----------|-------|
| `CapsLock` hold | Window management |
| `Space` hold | Text editing + Reload |
| `CapsLock+Space` chord | Toggle mouse lock mode |
| `CapsLock` tap | Send Esc (outside mouse lock) |
| `CapsLock` press | Exit mouse lock mode |
| `Esc` | Exit mouse lock / toggle CapsLock indicator |

---

## CapsLock — Window Management

### Focus & Move
| Key | Action |
|-----|--------|
| `Caps+H/J/K/L` | Focus window left/down/up/right |
| `Caps+Shift+H/J/K/L` | Move window |

### Workspace
| Key | Action |
|-----|--------|
| `Caps+1~9` | Switch workspace |
| `Caps+Shift+1~9` | Move window to workspace |

### Monitor
| Key | Action |
|-----|--------|
| `Caps+F1/F2` | Focus monitor 0/1 |
| `Caps+Shift+F1/F2` | Move window to monitor 0/1 |

### Window Ops
| Key | Action |
|-----|--------|
| `Caps+Z` | Close window |
| `Caps+Shift+Z` | Kill process |
| `Caps+T` | Toggle float |
| `Caps+G` | Toggle monocle |
| `Caps+M` | Toggle maximize |
| `Caps+Shift+M` | Minimize |
| `Caps+P` | Promote |
| `Caps+Shift+P` | Toggle pause |
| `Caps+C` | Toggle Chrome visibility |

### Resize
| Key | Action |
|-----|--------|
| `Caps+=/-` | Resize horizontal |
| `Caps+Shift+=/-` | Resize vertical |
| `Caps+Shift+Arrows` | Resize edge |

### Layout
| Key | Action |
|-----|--------|
| `Caps+,/./` | Vertical-stack / bsp / ultrawide |
| `Caps+Shift+,/./` | Right-main / grid / horizontal |
| `Caps+PgUp/PgDn` | Cycle layout |
| `Caps+Shift+X/Y` | Flip layout |

### Stack & Cycle
| Key | Action |
|-----|--------|
| `Caps+;/'` | Cycle stack |
| `Caps+\` | Stack / Unstack (with Shift) |
| `Caps+[/]` | Cycle focus |
| `Caps+Shift+[/]` | Cycle move |

---

## Space — Edit + Reload

### Cursor (Space hold)
| Key | Action |
|-----|--------|
| `Space+H/J/K/L` | Arrow keys (Left/Down/Up/Right) |
| `Space+W/B` | Next/prev word (Ctrl+Right/Left) |
| `Space+Y/O` | PgUp / PgDn |
| `Space+Shift+H` | Home |
| `Space+Shift+L` | End |
| `Space+X` | Delete (forward) |
| `Space+Shift+X` | Delete entire line |

### Vim Operators
After pressing `Space+V` (visual mode) or `Space+D` (delete mode):

| Motion | Visual (select) | Delete |
|--------|-----------------|--------|
| `H` | Select left 1 char | Backspace |
| `L` | Select right 1 char | Delete |
| `Shift+H` | Select to line start | Delete to line start |
| `Shift+L` | Select to line end | Delete to line end |
| `J` / `K` | Select line down/up | — |
| `W` | Select next word | Delete next word |
| `B` | Select prev word | Delete prev word |
| `0` | Select to line start | Delete to line start |
| `$` (Shift+4) | Select to line end | Delete to line end |
| `V` (again) | Select entire line | — |
| `D` (again) | — | Delete entire line |

### Reload komorebi
| Key | Action |
|-----|--------|
| `Space+R` | Restart komorebi |
| `Space+Shift+R` | Restart komorebi + yasb |
| `Space+Ctrl+Shift+R` | Restart komorebi + yasb + explorer |

---

## CapsLock+Space — Mouse Lock

Toggle with `CapsLock+Space`. Press `CapsLock` (or `Esc`) to exit.

While mouse lock is ON:

| Key | Action |
|-----|--------|
| `W/A/S/D` | Mouse move (accelerated, hold for speed) |
| `Q` | Left click (hold-to-drag) |
| `E` | Right click (hold-to-drag) |
| `R` | Scroll up (accelerated) |
| `F` | Scroll down (accelerated) |
| `Shift+WASD` | Slow/precise move (1px per tick) |

No middle click — removed to avoid accidental triggers.

### Speed Tuning
Edit `Modules\mouse.ahk`:
- `g_mouseSpeed` (default 1.0) — mouse cursor speed
- `g_scrollSpeed` (default 1.0) — scroll wheel speed
- Higher = faster; try 0.5 for slower, 2.0 for faster

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
