# CapsLockX

CapsLock enhancement + komorebi window management + mouse control + vim-like editing.

AHK v1. Run: `.\AutoHotkey\AutoHotkeyU64.exe CapsLockX.ahk`

## Layers

| Trigger | Layer |
|----------|-------|
| `CapsLock` hold | Window management + Mouse |
| `Space` hold | Text editing + Reload |
| `CapsLock+Space` chord | Toggle mouse lock mode |
| `Esc` | Toggle CapsLock indicator |
| `CapsLock` tap | Send Esc |

---

## CapsLock — Window + Mouse

### Mouse
| Key | Action |
|-----|--------|
| `Caps+W/A/S/D` | Mouse move (accelerated) |
| `Caps+Q` | Left click |
| `Caps+E` | Right click |
| `Caps+R/F` | Scroll up/down |
| `Caps+R+F` | Middle click |

### Focus & Move
| Key | Action |
|-----|--------|
| `Caps+H/J/K/L` | Focus window left/down/up/right |
| `Caps+Shift+H/J/K/L` | Move window |

### Workspace
| Key | Action |
|-----|--------|
| `Caps+0~9` | Switch workspace |
| `Caps+Shift+0~9` | Move window to workspace |

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

### Cursor
| Key | Action |
|-----|--------|
| `Space+H/J/K/L` | Arrow keys |
| `Space+W/B` | Next/prev word |
| `Space+Y/O` | PgUp/PgDn |
| `Space+0` | Home |
| `Space+$` (Shift+4) | End |

### Vim Operators
| Sequence | Action |
|----------|--------|
| `Space+X` | Delete forward |
| `Space+Shift+X` | Delete line |
| `Space+Shift+V` | Select line |
| `Space+V` | Enter visual mode |
| `Space+V` + `V` again | Select line |
| `Space+V` + `W` | Select next word |
| `Space+V` + `B` | Select prev word |
| `Space+V` + `H/J/K/L` | Select char/line |
| `Space+D` | Enter delete mode |
| `Space+D` + `D` | Delete line |
| `Space+D` + `W` | Delete next word |
| `Space+D` + `B` | Delete prev word |

### Reload
| Key | Action |
|-----|--------|
| `Space+R` | Reload komorebi |
| `Space+Shift+R` | Reload komorebi + yasb |
| `Space+Ctrl+Shift+R` | Reload komorebi + yasb + explorer |

---

## CapsLock+Space — Mouse Lock

Toggle with CapsLock+Space chord. Esc exits.

| Key | Action |
|-----|--------|
| `W/A/S/D` | Mouse move |
| `Q/E` | Left/right click |
| `R/F` | Scroll up/down |
| `Shift+WASD` | Slow move |

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
