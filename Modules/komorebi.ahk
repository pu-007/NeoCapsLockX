; Komorebi window management + mouse control — CapsLock hold + key

Komorebic(cmd) {
    Run, komorebic.exe %cmd%,, Hide
}

#If CapsLock && !mouseLock

;=== Mouse control ===
w::g_mouseModel.upDown("w"), CapsLock2:=""
w up::g_mouseModel.upUp()

a::g_mouseModel.leftDown("a"), CapsLock2:=""
a up::g_mouseModel.leftUp()

s::g_mouseModel.downDown("s"), CapsLock2:=""
s up::g_mouseModel.downUp()

d::g_mouseModel.rightDown("d"), CapsLock2:=""
d up::g_mouseModel.rightUp()

q::
CapsLock2:=""
Send {LButton Down}
KeyWait q
Send {LButton Up}
return

e::
CapsLock2:=""
Send {RButton Down}
KeyWait e
Send {RButton Up}
return

r::g_scrollModel.upDown("r"), CapsLock2:=""
r up::g_scrollModel.upUp()

f::g_scrollModel.downDown("f"), CapsLock2:=""
f up::g_scrollModel.downUp()

;=== Komorebi window management ===
; hjkl: focus / move
h::
j::
k::
l::
if GetKeyState("Shift", "P")
    Komorebic("move " (A_ThisHotkey="h"?"left":A_ThisHotkey="j"?"down":A_ThisHotkey="k"?"up":"right"))
else
    Komorebic("focus " (A_ThisHotkey="h"?"left":A_ThisHotkey="j"?"down":A_ThisHotkey="k"?"up":"right"))
CapsLock2:=""
return

; 0-9: workspace
1::
2::
3::
4::
5::
6::
7::
8::
9::
0::
idx := A_ThisHotkey
if GetKeyState("Shift", "P")
    Komorebic("move-to-workspace " idx)
else
    Komorebic("focus-workspace " idx)
CapsLock2:=""
return

; Resize
=::
-::
if GetKeyState("Shift", "P")
    Komorebic("resize-axis vertical " (A_ThisHotkey="="?"increase":"decrease"))
else
    Komorebic("resize-axis horizontal " (A_ThisHotkey="="?"increase":"decrease"))
CapsLock2:=""
return

+Left::Komorebic("resize left decrease"), CapsLock2:=""
+Right::Komorebic("resize left increase"), CapsLock2:=""
+Up::Komorebic("resize up decrease"), CapsLock2:=""
+Down::Komorebic("resize up increase"), CapsLock2:=""

; Window ops
p::
if GetKeyState("Shift", "P")
    Komorebic("toggle-pause")
else
    Komorebic("promote")
CapsLock2:=""
return

m::
if GetKeyState("Shift", "P")
    Komorebic("minimize")
else
    Komorebic("toggle-maximize")
CapsLock2:=""
return

g::Komorebic("toggle-monocle"), CapsLock2:=""
t::Komorebic("toggle-float"), CapsLock2:=""

z::
if GetKeyState("Shift", "P") {
    CapsLock2:=""
    try {
        WinGet, pid, PID, A
        Process, Close, %pid%
    }
} else {
    CapsLock2:=""
    try WinClose, A
}
return

; Layouts
,::
.::
/::
layout := A_ThisHotkey="," ? "vertical-stack" : (A_ThisHotkey="." ? "bsp" : "ultrawide-vertical-stack")
if GetKeyState("Shift", "P")
    layout := A_ThisHotkey="," ? "right-main-vertical-stack" : (A_ThisHotkey="." ? "grid" : "horizontal-stack")
Komorebic("change-layout " layout)
CapsLock2:=""
return

PgUp::Komorebic("cycle-layout previous"), CapsLock2:=""
PgDn::Komorebic("cycle-layout next"), CapsLock2:=""

x::
if GetKeyState("Shift", "P")
    Komorebic("flip-layout x"), CapsLock2:=""
return

y::
if GetKeyState("Shift", "P")
    Komorebic("flip-layout y"), CapsLock2:=""
return

; Stacks
`;::Komorebic("cycle-stack previous"), CapsLock2:=""
'::Komorebic("cycle-stack next"), CapsLock2:=""
\::Komorebic("stack left"), CapsLock2:=""
+\::Komorebic("unstack"), CapsLock2:=""

; Cycle focus/move
[::
]::
if GetKeyState("Shift", "P")
    Komorebic("cycle-move " (A_ThisHotkey="["?"previous":"next"))
else
    Komorebic("cycle-focus " (A_ThisHotkey="["?"previous":"next"))
CapsLock2:=""
return

; Monitors
F1::
F2::
idx := A_ThisHotkey="F1" ? "0" : "1"
if GetKeyState("Shift", "P")
    Komorebic("move-to-monitor " idx)
else
    Komorebic("focus-monitor " idx)
CapsLock2:=""
return

; Chrome toggle (moved from Caps+A to Caps+C)
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
