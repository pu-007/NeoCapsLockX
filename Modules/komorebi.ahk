; Komorebi window management — CapsLock hold + key
; Adapted from komorebi.ahk (Alt → CapsLock)

Komorebic(cmd) {
    RunWait, komorebic.exe %cmd%,, Hide
}

#If CapsLock && !mouseLock

h::Komorebic("focus left"), CapsLock2:=""
j::Komorebic("focus down"), CapsLock2:=""
k::Komorebic("focus up"), CapsLock2:=""
l::Komorebic("focus right"), CapsLock2:=""

+h::Komorebic("move left"), CapsLock2:=""
+j::Komorebic("move down"), CapsLock2:=""
+k::Komorebic("move up"), CapsLock2:=""
+l::Komorebic("move right"), CapsLock2:=""

1::Komorebic("focus-workspace 0"), CapsLock2:=""
2::Komorebic("focus-workspace 1"), CapsLock2:=""
3::Komorebic("focus-workspace 2"), CapsLock2:=""
4::Komorebic("focus-workspace 3"), CapsLock2:=""
5::Komorebic("focus-workspace 4"), CapsLock2:=""
6::Komorebic("focus-workspace 5"), CapsLock2:=""
7::Komorebic("focus-workspace 6"), CapsLock2:=""
8::Komorebic("focus-workspace 7"), CapsLock2:=""
9::Komorebic("focus-workspace 8"), CapsLock2:=""
0::Komorebic("focus-workspace 9"), CapsLock2:=""

+1::Komorebic("move-to-workspace 0"), CapsLock2:=""
+2::Komorebic("move-to-workspace 1"), CapsLock2:=""
+3::Komorebic("move-to-workspace 2"), CapsLock2:=""
+4::Komorebic("move-to-workspace 3"), CapsLock2:=""
+5::Komorebic("move-to-workspace 4"), CapsLock2:=""
+6::Komorebic("move-to-workspace 5"), CapsLock2:=""
+7::Komorebic("move-to-workspace 6"), CapsLock2:=""
+8::Komorebic("move-to-workspace 7"), CapsLock2:=""
+9::Komorebic("move-to-workspace 8"), CapsLock2:=""
+0::Komorebic("move-to-workspace 9"), CapsLock2:=""

=::Komorebic("resize-axis horizontal increase"), CapsLock2:=""
-::Komorebic("resize-axis horizontal decrease"), CapsLock2:=""
+=::Komorebic("resize-axis vertical increase"), CapsLock2:=""
+-::Komorebic("resize-axis vertical decrease"), CapsLock2:=""
+Left::Komorebic("resize left decrease"), CapsLock2:=""
+Right::Komorebic("resize left increase"), CapsLock2:=""
+Up::Komorebic("resize up decrease"), CapsLock2:=""
+Down::Komorebic("resize up increase"), CapsLock2:=""

p::Komorebic("promote"), CapsLock2:=""
+p::Komorebic("toggle-pause"), CapsLock2:=""
m::Komorebic("toggle-maximize"), CapsLock2:=""
+m::Komorebic("minimize"), CapsLock2:=""
f::Komorebic("toggle-monocle"), CapsLock2:=""
t::Komorebic("toggle-float"), CapsLock2:=""

z::
CapsLock2:=""
try WinClose A
return

+z::
CapsLock2:=""
try {
    WinGet pid, PID, A
    Process Close, %pid%
}
return

,::Komorebic("change-layout vertical-stack"), CapsLock2:=""
+,::Komorebic("change-layout right-main-vertical-stack"), CapsLock2:=""
.::Komorebic("change-layout bsp"), CapsLock2:=""
+.::Komorebic("change-layout grid"), CapsLock2:=""
/::Komorebic("change-layout ultrawide-vertical-stack"), CapsLock2:=""
+/::Komorebic("change-layout horizontal-stack"), CapsLock2:=""
PgUp::Komorebic("cycle-layout previous"), CapsLock2:=""
PgDn::Komorebic("cycle-layout next"), CapsLock2:=""
+x::Komorebic("flip-layout x"), CapsLock2:=""
+y::Komorebic("flip-layout y"), CapsLock2:=""

`;::Komorebic("cycle-stack previous"), CapsLock2:=""
'::Komorebic("cycle-stack next"), CapsLock2:=""
\::Komorebic("stack left"), CapsLock2:=""
+\::Komorebic("unstack"), CapsLock2:=""

[::Komorebic("cycle-focus previous"), CapsLock2:=""
]::Komorebic("cycle-focus next"), CapsLock2:=""
+[::Komorebic("cycle-move previous"), CapsLock2:=""
+]::Komorebic("cycle-move next"), CapsLock2:=""

F1::Komorebic("focus-monitor 0"), CapsLock2:=""
F2::Komorebic("focus-monitor 1"), CapsLock2:=""
+F1::Komorebic("move-to-monitor 0"), CapsLock2:=""
+F2::Komorebic("move-to-monitor 1"), CapsLock2:=""

r::
CapsLock2:=""
RunWait, taskkill /F /IM komorebi.exe,, Hide
Run, komorebic-no-console.exe start
return

+r::
CapsLock2:=""
RunWait, taskkill /F /IM komorebi.exe,, Hide
RunWait, taskkill /F /IM yasb.exe,, Hide
Run, komorebic-no-console.exe start
Run, yasb.exe
return

^+r::
CapsLock2:=""
RunWait, taskkill /F /IM komorebi.exe,, Hide
RunWait, taskkill /F /IM yasb.exe,, Hide
RunWait, taskkill /F /IM explorer.exe,, Hide
Run, explorer.exe
Run, komorebic-no-console.exe start
Run, yasb.exe
return

a::
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
