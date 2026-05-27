; CapsLockX - CapsLock Enhancement + Komorebi Window Management
; AHK v1, based on CapsLock+ / CapsLockX patterns
#SingleInstance Force
#NoEnv
#Persistent
#MaxHotkeysPerInterval 500
SendMode Input
SetWorkingDir %A_ScriptDir%
Process Priority,, High
SetTitleMatchMode RegEx
SetStoreCapslockMode, Off

; ==== DIAGNOSTIC: confirm script loaded ====
ToolTip % "[CLX STARTUP] CapsLockX loaded"
SetTimer DiagStartupClear, -2000

; Global state
global CapsLock := ""      ; CapsLock hold flag ("" = released, 1 = held)
global CapsLock2 := ""     ; tap detection: set on press, cleared by timer or hotkey
global spaceMode := ""     ; Space hold flag
global spaceUsed := ""     ; was an edit key used during Space hold
global mouseLock := ""     ; CapsLock+Space toggle mouse lock
global opMode := ""        ; vim operator: "delete" or "visual"

; ==== Include modules (must be before first hotkey so auto-execute runs them) ====
#Include %A_ScriptDir%\Modules\AccModel.ahk
#Include %A_ScriptDir%\Modules\mouse.ahk
#Include %A_ScriptDir%\Modules\edit.ahk
#Include %A_ScriptDir%\Modules\komorebi.ahk
#Include %A_ScriptDir%\Modules\extras.ahk

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
$Space::
; Ctrl/Alt/Win+Space → pass through (IME, etc.)
if GetKeyState("Ctrl", "P") || GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
{
    Send {Blind}{Space Down}
    KeyWait, Space
    Send {Blind}{Space Up}
    return
}
spaceMode:=1, spaceUsed:="", opMode:="", spTap:=1
SetTimer, spTapTimeout, -250
KeyWait, Space
SetTimer, spTapTimeout, Off
spaceMode:=""
if !spaceUsed && spTap
    Send {Blind}{Space}
return

spTapTimeout:
spTap:=""
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

; ---- timer helpers ----
DiagStartupClear:
    ToolTip
return
