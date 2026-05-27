; Mouse callbacks + lock mode hotkeys
; Uses original CapsLockX AccModel (AccModel.ahk) with Chinese method names
; v2026.05.27: Added * wildcard prefix to all hotkeys (matches original CLX-Mouse.ahk)
;             Added CapsLock guard in callback, SendInput API for mouse move

DllCall("Shcore.dll\SetProcessDpiAwareness", "UInt", 2)

; ---- debug flag: set to 1 to show execution diagnostics ----
global g_mouseDebug := 0

; ==== Callback functions ====
mouseCallback(dx, dy, state)
{
    global g_mouseDebug
    ; Guard: stop simulation if CapsLock is released (matching original behavior)
    if (!CapsLock) {
        g_mouseModel.止动()
        return
    }
    if (state == "横中键" || state == "纵中键")
        return
    if (state != "移动")
        return
    if (GetKeyState("Shift", "P")) {
        dx := dx == 0 ? 0 : (dx > 0 ? 1 : -1)
        dy := dy == 0 ? 0 : (dy > 0 ? 1 : -1)
    }
    ; diagnostic: show every 30th call to avoid tooltip spam
    static _diagCount := 0
    _diagCount++
    if (g_mouseDebug && Mod(_diagCount, 30) == 0) {
        ToolTip % "[mouseCallback] dx=" dx ", dy=" dy ", 横速=" g_mouseModel.横速 ", 纵速=" g_mouseModel.纵速
        SetTimer HideMouseDiag, -1000
    }
    ; Use Windows SendInput API (matches original CLX-Mouse.ahk, 64-bit safe)
    SendInput_MouseMove(dx, dy)
}

scrollCallback(dx, dy, state)
{
    if (state == "横中键" || state == "纵中键") {
        SendEvent {Blind}{MButton Down}
        KeyWait r
        KeyWait f
        SendEvent {Blind}{MButton Up}
        g_scrollModel.止动()
        return
    }
    if (state != "移动")
        return
    ScrollMouse(dx, dy)
}

; Windows SendInput API mouse move (from original CLX-Mouse.ahk)
; More reliable than AHK's built-in MouseMove in keyboard hook contexts,
; and handles 64-bit AHK correctly.
SendInput_MouseMove(dx, dy)
{
    ; INPUT structure size: type(4) + MOUSEINPUT on 64-bit = A_PtrSize + 4*4 + A_PtrSize*2
    size := A_PtrSize + 4*4 + A_PtrSize*2
    VarSetCapacity(mi, size, 0)
    NumPut(dx, mi, A_PtrSize, "Int")              ; LONG dx
    NumPut(dy, mi, A_PtrSize + 4, "Int")           ; LONG dy
    NumPut(0x0001, mi, A_PtrSize + 4 + 4 + 4, "UInt") ; MOUSEEVENTF_MOVE
    DllCall("SendInput", "UInt", 1, "Ptr", &mi, "Int", size)
}

ScrollMouse(dx, dy)
{
    WM_MOUSEWHEEL := 0x020A
    WM_MOUSEWHEELH := 0x020E
    if (dy) {
        CoordMode, Mouse, Screen
        MouseGetPos, mx, my
        wParam := (-dy * 120) << 16
        wParam |= GetKeyState("Shift", "P") ? 0x4 : 0
        wParam |= GetKeyState("Ctrl", "P") ? 0x8 : 0
        lParam := mx | (my << 16)
        ctrl := A_Is64bitOS ? DllCall("WindowFromPoint", "Int64", mx | (my << 32), "Ptr") : DllCall("WindowFromPoint", "Int", mx, "Int", my)
        DllCall("PostMessage", "Ptr", ctrl, "UInt", WM_MOUSEWHEEL, "UPtr", wParam, "UPtr", lParam)
    }
    if (dx) {
        CoordMode, Mouse, Screen
        MouseGetPos, mx, my
        wParam := (dx * 120) << 16
        lParam := mx | (my << 16)
        ctrl := A_Is64bitOS ? DllCall("WindowFromPoint", "Int64", mx | (my << 32), "Ptr") : DllCall("WindowFromPoint", "Int", mx, "Int", my)
        DllCall("PostMessage", "Ptr", ctrl, "UInt", WM_MOUSEWHEELH, "UPtr", wParam, "UPtr", lParam)
    }
}

; ==== Models (using original AccModel) ====
global g_dpiRatio := A_ScreenDPI / 96
global g_mouseSpeed := 1.0
global g_mouseModel := new AccModel2D(Func("mouseCallback"), 0.1, g_dpiRatio * 120 * 2 * g_mouseSpeed)
global g_scrollModel := new AccModel2D(Func("scrollCallback"), 0.1, g_dpiRatio * 120 * 4 * 1.0)
; NOTE: No maxSpeed cap — matches original CLX-Mouse.ahk behavior.
; The AccModel's _ma() produces exponential acceleration, and velocity
; grows continuously. Capping it kills the acceleration feel.
; To limit max speed, set a higher value e.g.:
; g_mouseModel.最大速度 := 2000

; ==== Mouse lock mode hotkeys ====
; NOTE: * prefix (wildcard) is essential — it allows the hotkey to fire even when
; CapsLock is physically held and intercepted by the keyboard hook.
; Without *, the hook may treat the held CapsLock as a "modifier" and suppress
; plain hotkey matching. This matches the original CLX-Mouse.ahk behavior.
#If mouseLock

*w::
    if (g_mouseDebug)
        ToolTip % "[HOTKEY] *w pressed — CapsLock=" CapsLock ", mouseLock=" mouseLock
    g_mouseModel.上按("w")
return
*w up::g_mouseModel.上放()

*a::
    if (g_mouseDebug)
        ToolTip % "[HOTKEY] *a pressed"
    g_mouseModel.左按("a")
return
*a up::g_mouseModel.左放()

*s::
    if (g_mouseDebug)
        ToolTip % "[HOTKEY] *s pressed"
    g_mouseModel.下按("s")
return
*s up::g_mouseModel.下放()

*d::
    if (g_mouseDebug)
        ToolTip % "[HOTKEY] *d pressed"
    g_mouseModel.右按("d")
return
*d up::g_mouseModel.右放()

*q::
    Send {LButton Down}
    KeyWait q
    Send {LButton Up}
return

*e::
    Send {RButton Down}
    KeyWait e
    Send {RButton Up}
return

*r::
    if (g_mouseDebug)
        ToolTip % "[HOTKEY] *r pressed"
    g_scrollModel.上按("r")
return
*r up::g_scrollModel.上放()

*f::
    if (g_mouseDebug)
        ToolTip % "[HOTKEY] *f pressed"
    g_scrollModel.下按("f")
return
*f up::g_scrollModel.下放()

#If

; ---- timer helpers (must be outside #If context) ----
HideMouseDiag:
    ToolTip
return
