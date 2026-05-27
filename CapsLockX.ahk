; CapsLockX - CapsLock Enhancement + Komorebi Window Management
; AHK v1, based on CapsLock+ / CapsLockX patterns
#SingleInstance Force
#NoEnv
#MaxHotkeysPerInterval 500
SendMode Input
SetWorkingDir %A_ScriptDir%
Process Priority,, High
SetTitleMatchMode RegEx
SetStoreCapslockMode, Off

; Global state
global CapsLock := ""      ; CapsLock hold flag ("" = released, 1 = held)
global CapsLock2 := ""     ; tap detection: set on press, cleared by timer or hotkey
global spaceMode := ""     ; Space hold flag
global spaceUsed := ""     ; was an edit key used during Space hold
global mouseLock := ""     ; CapsLock+Space toggle mouse lock
global opMode := ""        ; vim operator: "delete" or "visual"

; ==== CapsLock: hold = komorebi modifier ====
Capslock::
CapsLock:=1, CapsLock2:=1
SetTimer setCapsLock2, -300
KeyWait, Capslock
CapsLock:=""
if CapsLock2
    Send {Esc}
return

setCapsLock2:
CapsLock2:=""
return

; ==== Space: hold = edit modifier, tap = Space ====
; Bypass: if Ctrl/Alt/Win held when Space is pressed, pass through
$Space::
if GetKeyState("Ctrl", "P") || GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
{
    Send {Blind}{Space Down}
    KeyWait, Space
    Send {Blind}{Space Up}
    return
}
spaceMode:=1, spaceUsed:="", opMode:=""
SetTimer, spaceHoldRepeat, -200
KeyWait, Space
SetTimer, spaceHoldRepeat, Off
spaceMode:=""
if !spaceUsed
    Send {Blind}{Space}
return

spaceHoldRepeat:
; Space held >200ms with no edit key: auto-repeat spaces (mimics native key-repeat)
if spaceMode && !spaceUsed {
    Send {Blind}{Space}
    SetTimer, spaceHoldRepeat, -50
}
return

; ==== Esc: toggle CapsLock indicator ($ prevents synthetic triggers) ====
$Esc::
if mouseLock
{
    mouseLock:=""
    ToolTip Mouse Lock OFF
    SetTimer HideToolTip, -1000
    return
}
opMode:=""
SetCapsLockState % GetKeyState("CapsLock","T") ? "Off" : "On"
return

HideToolTip:
ToolTip
return

; ==== CapsLock+Space = toggle mouse lock mode ====
#If CapsLock && !mouseLock
Space::
mouseLock:=1, CapsLock2:=""
ToolTip Mouse Lock ON
SetTimer HideToolTip, -1000
KeyWait, Space
return
#If

#If CapsLock && mouseLock
Space::
mouseLock:="", CapsLock2:=""
ToolTip Mouse Lock OFF
SetTimer HideToolTip, -1000
KeyWait, Space
return
#If

; ==== Include modules ====
#Include %A_ScriptDir%\Modules\AccModel.ahk
#Include %A_ScriptDir%\Modules\mouse.ahk
#Include %A_ScriptDir%\Modules\edit.ahk
#Include %A_ScriptDir%\Modules\komorebi.ahk
#Include %A_ScriptDir%\Modules\extras.ahk
