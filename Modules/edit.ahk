; Text editing — Space hold + vim-like keys
; HJKL cursor, YO PgUp/PgDn, 0/$ Home/End, WB word jump
; d/v operators, Shift+V select line, Shift+X delete line
; Esc handled by main script (cancels operator, toggles CapsLock)

; ==== Operator-pending mode (after d/v pressed) — MUST come FIRST ====
#If spaceMode && !mouseLock && opMode

h::
spaceUsed:=1
if (opMode == "delete")
    Send {Backspace}
else if (opMode == "visual")
    Send +{Left}
opMode:=""
return

l::
spaceUsed:=1
if (opMode == "delete")
    Send {Delete}
else if (opMode == "visual")
    Send +{Right}
opMode:=""
return

j::
spaceUsed:=1
if (opMode == "visual")
    Send +{Down}
opMode:=""
return

k::
spaceUsed:=1
if (opMode == "visual")
    Send +{Up}
opMode:=""
return

w::
spaceUsed:=1
if (opMode == "delete")
    Send +^{Right}{Delete}
else if (opMode == "visual")
    Send +^{Right}
opMode:=""
return

b::
spaceUsed:=1
if (opMode == "delete")
    Send +^{Left}{Backspace}
else if (opMode == "visual")
    Send +^{Left}
opMode:=""
return

0::
spaceUsed:=1
if (opMode == "delete")
    Send +{Home}{Delete}
else if (opMode == "visual")
    Send +{Home}
opMode:=""
return

+4::
spaceUsed:=1
if (opMode == "delete")
    Send +{End}{Delete}
else if (opMode == "visual")
    Send +{End}
opMode:=""
return

#If

; ==== Normal edit mode ====
#If spaceMode && !mouseLock

h::
spaceUsed:=1
Send {Blind}{Left}
return

j::
spaceUsed:=1
Send {Blind}{Down}
return

k::
spaceUsed:=1
Send {Blind}{Up}
return

l::
spaceUsed:=1
Send {Blind}{Right}
return

w::
spaceUsed:=1
Send ^{Right}
return

b::
spaceUsed:=1
Send ^{Left}
return

y::
spaceUsed:=1
Send {Blind}{PgUp}
return

o::
spaceUsed:=1
Send {Blind}{PgDn}
return

0::
spaceUsed:=1
Send {Blind}{Home}
return

+4::
spaceUsed:=1
Send {Blind}{End}
return

x::
spaceUsed:=1
Send {Blind}{Delete}
return

+v::
spaceUsed:=1
Send {Home}+{End}
return

+x::
spaceUsed:=1
Send {Home}+{End}{Delete}
return

v::
spaceUsed:=1
if (opMode == "visual") {
    Send {Home}+{End}
    opMode:=""
} else {
    opMode:="visual"
}
return

d::
spaceUsed:=1
if (opMode == "delete") {
    Send {Home}+{End}{Delete}
    opMode:=""
} else {
    opMode:="delete"
}
return

#If
