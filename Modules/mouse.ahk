; Mouse lock mode - CapsLock+Space toggle
; WASD = move, Q = left click, E = right click, R/F = scroll

DllCall("Shcore.dll\SetProcessDpiAwareness", "UInt", 2)

global g_dpiRatio := A_ScreenDPI / 96
global g_mouseSpeed := 1.0

g_mouseModel := new AccModel2D(Func("mouseCallback"), 0.1, g_dpiRatio * 120 * 2 * g_mouseSpeed)
g_scrollModel := new AccModel2D(Func("scrollCallback"), 0.1, g_dpiRatio * 120 * 4 * 1.0)
g_mouseModel.maxSpeed := 200
g_scrollModel.maxSpeed := 200

mouseCallback(dx, dy, state)
{
    global
    if (state == "hMid" || state == "vMid")
        return
    if (state != "move")
        return
    if (GetKeyState("Shift", "P")) {
        dx := dx == 0 ? 0 : (dx > 0 ? 1 : -1)
        dy := dy == 0 ? 0 : (dy > 0 ? 1 : -1)
    }
    SendInput_MouseMove(dx, dy)
}

scrollCallback(dx, dy, state)
{
    global
    if (state == "hMid" || state == "vMid") {
        SendEvent {Blind}{MButton Down}
        KeyWait r
        KeyWait f
        SendEvent {Blind}{MButton Up}
        g_scrollModel.stop()
        return
    }
    if (state != "move")
        return
    ScrollMouse(dx, dy)
}

SendInput_MouseMove(dx, dy)
{
    size := A_PtrSize + 4*4 + A_PtrSize*2
    VarSetCapacity(buf, size, 0)
    NumPut(dx, buf, A_PtrSize, "Int")
    NumPut(dy, buf, A_PtrSize + 4, "Int")
    NumPut(0x0001, buf, A_PtrSize + 4 + 4 + 4, "UInt")
    DllCall("SendInput", "UInt", 1, "Ptr", &buf, "Int", size)
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

#If mouseLock

w::g_mouseModel.upDown("w")
w up::g_mouseModel.upUp()

a::g_mouseModel.leftDown("a")
a up::g_mouseModel.leftUp()

s::g_mouseModel.downDown("s")
s up::g_mouseModel.downUp()

d::g_mouseModel.rightDown("d")
d up::g_mouseModel.rightUp()

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

r::g_scrollModel.upDown("r")
r up::g_scrollModel.upUp()

f::g_scrollModel.downDown("f")
f up::g_scrollModel.downUp()

#If
