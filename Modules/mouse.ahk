; Mouse callbacks + lock mode hotkeys
; Uses original CapsLockX AccModel (AccModel.ahk) with Chinese method names

DllCall("Shcore.dll\SetProcessDpiAwareness", "UInt", 2)

; ==== Callback functions ====
mouseCallback(dx, dy, state)
{
    if (state == "横中键" || state == "纵中键")
        return
    if (state != "移动")
        return
    if (GetKeyState("Shift", "P")) {
        dx := dx == 0 ? 0 : (dx > 0 ? 1 : -1)
        dy := dy == 0 ? 0 : (dy > 0 ? 1 : -1)
    }
    MouseMove, dx, dy, 0, R
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
g_mouseModel.最大速度 := 200
g_scrollModel.最大速度 := 200

; ==== Mouse lock mode hotkeys ====
#If mouseLock

w::g_mouseModel.上按("w")
w up::g_mouseModel.上放()

a::g_mouseModel.左按("a")
a up::g_mouseModel.左放()

s::g_mouseModel.下按("s")
s up::g_mouseModel.下放()

d::g_mouseModel.右按("d")
d up::g_mouseModel.右放()

q::
Send {LButton Down}
KeyWait q
Send {LButton Up}
return

e::
Send {RButton Down}
KeyWait e
Send {RButton Up}
return

r::g_scrollModel.上按("r")
r up::g_scrollModel.上放()

f::g_scrollModel.下按("f")
f up::g_scrollModel.下放()

#If
