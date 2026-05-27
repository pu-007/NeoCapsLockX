# CapsLockX

CapsLock 增强工具 — 窗口管理 (komorebi) + vim-like 文本编辑 + 鼠标控制。

纯 AHK v2，零配置，单文件启动。

## 快速开始

```powershell
# 安装 AutoHotkey v2
winget install AutoHotkey.AutoHotkey

# 运行
& "C:\Program Files\AutoHotkey\AutoHotkey64.exe" CapsLockX.ahk
```

要求：[komorebi](https://github.com/LGUG2Z/komorebi) 已安装并在 PATH 中。

> **注意**：使用前请确保 CapsLock 灯处于**关闭**状态。按 `Esc` 可切换指示灯状态。

## 目录结构

```
CapsLockX/
├── CapsLockX.ahk          # 主入口
├── README.md
└── modules/
    ├── komorebi.ahk       # CapsLock 窗口管理
    ├── edit.ahk           # Space vim 文本编辑
    ├── mouse.ahk          # CapsLock+Space 鼠标锁定模式
    ├── extras.ahk         # 独立快捷键
    └── AccModel.ahk       # 加速度模型
```

## Keymap

### 全局键

| 按键 | 行为 |
|------|------|
| `Esc` | 切换 CapsLock 指示灯 |
| `CapsLock` 点按 | 发送 Esc |
| `CapsLock` 按住 | 进入窗口管理模式 |
| `Space` 点按 | 发送空格 |
| `Space` 按住 | 进入文本编辑模式 |
| `CapsLock+Space` 同时按 | 切换鼠标锁定模式 |

---

### CapsLock — 窗口管理 (komorebi)

#### 焦点 & 移动

| 按键 | 命令 |
|------|------|
| `Caps+H` / `J` / `K` / `L` | focus left / down / up / right |
| `Caps+Shift+H` / `J` / `K` / `L` | move left / down / up / right |

#### 工作区

| 按键 | 命令 |
|------|------|
| `Caps+0` ~ `9` | focus-workspace |
| `Caps+Shift+0` ~ `9` | move-to-workspace |

#### 显示器

| 按键 | 命令 |
|------|------|
| `Caps+F1` / `F2` | focus-monitor 0 / 1 |
| `Caps+Shift+F1` / `F2` | move-to-monitor 0 / 1 |

#### 窗口操作

| 按键 | 命令 |
|------|------|
| `Caps+Z` | 关闭窗口 |
| `Caps+Shift+Z` | 强制结束进程 |
| `Caps+F` | toggle-monocle |
| `Caps+T` | toggle-float |
| `Caps+M` | toggle-maximize |
| `Caps+Shift+M` | minimize |
| `Caps+P` | promote |
| `Caps+Shift+P` | toggle-pause |
| `Caps+A` | 切换 Chrome 窗口 显示/隐藏 |

#### 窗口大小

| 按键 | 命令 |
|------|------|
| `Caps+=` / `-` | resize-axis horizontal increase / decrease |
| `Caps+Shift+=` / `-` | resize-axis vertical increase / decrease |
| `Caps+Shift+方向键` | resize-edge |

#### 布局

| 按键 | 命令 |
|------|------|
| `Caps+,` / `<` / `.` / `>` / `/` / `?` | 切换布局 (bsp, grid, vertical-stack 等) |
| `Caps+PgUp` / `PgDn` | cycle-layout |
| `Caps+Shift+X` / `Y` | flip-layout |

#### 堆叠 & 循环

| 按键 | 命令 |
|------|------|
| `Caps+;` / `'` | cycle-stack previous / next |
| `Caps+\` / `Shift+\` | stack / unstack |
| `Caps+[` / `]` | cycle-focus previous / next |
| `Caps+Shift+[` / `]` | cycle-move previous / next |

#### 重载

| 按键 | 行为 |
|------|------|
| `Caps+R` | 重载 komorebi |
| `Caps+Shift+R` | 重载 komorebi + yasb |
| `Caps+Ctrl+Shift+R` | 重载 komorebi + yasb + explorer |

---

### Space — vim 文本编辑

Space 按住时进入编辑模式，使用 vim 操作符体系。

#### 光标移动

| 按键 | 发送 |
|------|------|
| `Space+H` / `J` / `K` / `L` | ← ↓ ↑ → |
| `Space+W` / `B` | Ctrl+→ / Ctrl+← (跳词) |
| `Space+0` / `$` | Home / End |
| `Space+Y` / `O` | PgUp / PgDn |

#### 单键操作

| 按键 | 发送 |
|------|------|
| `Space+X` | Delete (vim x) |
| `Space+Shift+V` | 选中整行 |
| `Space+Shift+X` | 删除整行 |

#### 操作符

按下 `d`（删除）或 `v`（选择）后，再按 motion 键确定范围：

| 序列 | 效果 |
|------|------|
| `d` `h` / `l` | 删前一字符 / 后一字符 |
| `d` `w` / `b` | 删后一词 / 前一词 |
| `d` `0` / `$` | 删到行首 / 行尾 |
| `d` `d` | 删整行 |
| `v` `h` / `l` | 选左 / 选右 |
| `v` `j` / `k` | 向下选 / 向上选 |
| `v` `w` / `b` | 选后一词 / 前一词 |
| `v` `0` / `$` | 选到行首 / 行尾 |
| `v` `v` | 选中整行 |

操作符待决时按 `Esc` 取消。

---

### CapsLock+Space — 鼠标锁定模式

| 按键 | 行为 |
|------|------|
| `W` / `A` / `S` / `D` | 鼠标移动 (含加速度) |
| `Shift+W/A/S/D` | 鼠标慢速移动 |
| `Q` | 左键点击 |
| `E` | 右键点击 |
| `R` / `F` | 滚轮上 / 下 |
| `R+F` 同时按 | 鼠标中键 |
| `Esc` | 退出锁定模式 |

---

### 独立快捷键

| 按键 | 功能 |
|------|------|
| `Ctrl+Shift+Win+Alt+C` | 启动/切换微信 |
| `Ctrl+Shift+Win+Alt+Q` | 启动/切换 QQ |
| `Ctrl+Shift+Win+Alt+N` | WSL nvim (win32yank 粘贴) |
| `Win+Y` | WSL yazi 文件管理器 |
| `Alt+Enter` | 终端 (wt.exe) |
| `Alt+Shift+Enter` | 终端到 workdir |

## 实现

- **加速度模型**：AccModel2D — 基于物理模拟的时基微分加速度模型，实现平滑的鼠标/光标移动
- **操作符系统**：vim 风格 `d`/`v` 操作符，在 Space 模式内实现状态机
- **双用途键**：CapsLock 和 Space 均支持 tap（发送原始按键）和 hold（修饰模式）
