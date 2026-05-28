; Komorebi window management + mouse control - CapsLock hold + key

Komorebic(cmd) {
    Run, komorebic.exe %cmd%,, Hide
}

#If CapsLock && !mouseLock

;=== Mouse control ===
*w::
g_mouseModel.上按("w")
CapsLock2:=""
return
*w up::
g_mouseModel.上放()
return

*a::
g_mouseModel.左按("a")
CapsLock2:=""
return
*a up::
g_mouseModel.左放()
return

*s::
g_mouseModel.下按("s")
CapsLock2:=""
return
*s up::
g_mouseModel.下放()
return

*d::
g_mouseModel.右按("d")
CapsLock2:=""
return
*d up::
g_mouseModel.右放()
return

*q::
CapsLock2:=""
Send {LButton Down}
KeyWait q
Send {LButton Up}
return

*e::
CapsLock2:=""
Send {RButton Down}
KeyWait e
Send {RButton Up}
return

*r::
g_scrollModel.上按("r")
CapsLock2:=""
return
*r up::
g_scrollModel.上放()
return

*f::
g_scrollModel.下按("f")
CapsLock2:=""
return
*f up::
g_scrollModel.下放()
return

;=== HJKL - each has own body (no stacking) ===
*h::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move left")
else
    Komorebic("focus left")
return

*j::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move down")
else
    Komorebic("focus down")
return

*k::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move up")
else
    Komorebic("focus up")
return

*l::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move right")
else
    Komorebic("focus right")
return

;=== 0-9 workspace - each has own body ===
*1::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 0")
else
    Komorebic("focus-workspace 0")
return

*2::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 1")
else
    Komorebic("focus-workspace 1")
return

*3::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 2")
else
    Komorebic("focus-workspace 2")
return

*4::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 3")
else
    Komorebic("focus-workspace 3")
return

*5::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 4")
else
    Komorebic("focus-workspace 4")
return

*6::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 5")
else
    Komorebic("focus-workspace 5")
return

*7::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 6")
else
    Komorebic("focus-workspace 6")
return

*8::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 7")
else
    Komorebic("focus-workspace 7")
return

*9::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 8")
else
    Komorebic("focus-workspace 8")
return

*0::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace 9")
else
    Komorebic("focus-workspace 9")
return

; Resize
*=::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("resize-axis vertical increase")
else
    Komorebic("resize-axis horizontal increase")
return

*-::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("resize-axis vertical decrease")
else
    Komorebic("resize-axis horizontal decrease")
return

+Left::
Komorebic("resize left decrease")
CapsLock2:=""
return
+Right::
Komorebic("resize left increase")
CapsLock2:=""
return
+Up::
Komorebic("resize up decrease")
CapsLock2:=""
return
+Down::
Komorebic("resize up increase")
CapsLock2:=""
return

; Window ops
*p::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("toggle-pause")
else
    Komorebic("promote")
return

*m::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("minimize")
else
    Komorebic("toggle-maximize")
return

g::
Komorebic("toggle-monocle")
CapsLock2:=""
return

t::
Komorebic("toggle-float")
CapsLock2:=""
return

*z::
CapsLock2:=""
if GetKeyState("Shift", "P")
{
    try {
        WinGet, pid, PID, A
        Process, Close, %pid%
    }
}
else
{
    try WinClose, A
}
return

; Layouts - each has own body
*,::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("change-layout right-main-vertical-stack")
else
    Komorebic("change-layout vertical-stack")
return

*.::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("change-layout grid")
else
    Komorebic("change-layout bsp")
return

*/::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("change-layout horizontal-stack")
else
    Komorebic("change-layout ultrawide-vertical-stack")
return

PgUp::
Komorebic("cycle-layout previous")
CapsLock2:=""
return
PgDn::
Komorebic("cycle-layout next")
CapsLock2:=""
return

*x::
if GetKeyState("Shift", "P")
{
    Komorebic("flip-layout x")
    CapsLock2:=""
}
return

*y::
if GetKeyState("Shift", "P")
{
    Komorebic("flip-layout y")
    CapsLock2:=""
}
return

; Stacks
`;::
Komorebic("cycle-stack previous")
CapsLock2:=""
return
'::
Komorebic("cycle-stack next")
CapsLock2:=""
return

*\::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("unstack")
else
    Komorebic("stack left")
return

; Cycle focus/move
*[::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("cycle-move previous")
else
    Komorebic("cycle-focus previous")
return

*]::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("cycle-move next")
else
    Komorebic("cycle-focus next")
return

; Monitors
*F1::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-monitor 0")
else
    Komorebic("focus-monitor 0")
return

*F2::
CapsLock2:=""
if GetKeyState("Shift", "P")
    Komorebic("move-to-monitor 1")
else
    Komorebic("focus-monitor 1")
return

; Chrome toggle
c::
CapsLock2:=""
SetTitleMatchMode RegEx
DetectHiddenWindows On
targetTitle := " - Google Chrome$ ahk_exe chrome.exe"
WinGet, idList, List, %targetTitle%
if (idList == 0) {
    Run, C:\Program Files\Google\Chrome\Application\chrome.exe
    WinWait, %targetTitle%,, 3
    WinActivate
    return
}
WinGet, firstWinStyle, Style, % "ahk_id " idList1
isVisible := firstWinStyle & 0x10000000
if (isVisible) {
    Loop % idList
        WinHide, % "ahk_id " idList%A_Index%
} else {
    Loop % idList
        WinShow, % "ahk_id " idList%A_Index%
    WinActivate, % "ahk_id " idList1
}
return

#If
