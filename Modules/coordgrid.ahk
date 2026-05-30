; CoordGrid — coordinate overlay for mouse positioning via two-letter combos
; Ref: https://raw.githubusercontent.com/GavinPen/AhkCoordGrid/refs/heads/master/AHKCoordGrid.ahk
; Trigger: CapsLock + ` (backtick) in normal mode or capsLockActive mode
;
; When grid is active: press two letter keys → cursor moves to that cell.
; Arrow keys move the grid. Esc / Backspace / ` closes it.
;
; All globals are lazily initialized in CoordGrid_Init() because the
; auto-execute section terminates at the first hotkey in mouse.ahk.

; ==== Trigger: CapsLock (held or latched) + backtick ====
#If (CapsLock || capsLockActive)

*SC029::
    CapsLock2 := ""
    CoordGrid_Toggle()
return

#If

; ==== Lazy global init ====
CoordGrid_Init() {
    global
    static _done := false
    if (_done)
        return
    _done := true

    CoordGrid_GridH := A_ScreenHeight
    CoordGrid_GridW := A_ScreenWidth
    CoordGrid_Rows := 26
    CoordGrid_Cols := 26
    CoordGrid_RowSp := CoordGrid_GridH / CoordGrid_Rows
    CoordGrid_ColSp := CoordGrid_GridW / CoordGrid_Cols
    CoordGrid_Keys := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    CoordGrid_Visible := false
    CoordGrid_Built := false
    CoordGrid_FirstKey := ""
    CoordGrid_SecondKey := ""
    CoordGrid_TapCount := 0
}

; ==== Grid GUI ====
CoordGrid_Build() {
    global
    if (CoordGrid_Built)
        return

    Gui, CoordGrid:New, +AlwaysOnTop -Caption +ToolWindow
    Gui, CoordGrid:Color, 000115

    rowCounter := 0
    Loop {
        rowY := Round((CoordGrid_Rows - 1 - rowCounter) * CoordGrid_RowSp)
        rowAlpha := CoordGrid_Keys[rowCounter + 1]
        StringUpper, rowAlpha, rowAlpha
        colCounter := 0
        Loop {
            colX := Round(colCounter * CoordGrid_ColSp)
            colAlpha := CoordGrid_Keys[colCounter + 1]
            StringUpper, colAlpha, colAlpha
            Gui, CoordGrid:Add, Progress, % "w21 h21 x" . colX . " y" . rowY . " BackgroundFFFFFF disabled vCG_p_" . colCounter . "_" . rowCounter
            Gui, CoordGrid:Add, Text, % "w21 h21 x" . colX . " y" . rowY . " Border 0x201 ReadOnly BackgroundTrans cBlack vCG_t_" . colCounter . "_" . rowCounter, % colAlpha . rowAlpha
            colCounter += 1
        } Until colCounter = CoordGrid_Cols
        rowCounter += 1
    } Until rowCounter = CoordGrid_Rows

    Gui, CoordGrid:Show, Hide W%CoordGrid_GridW% H%CoordGrid_GridH%, CoordGrid
    CoordGrid_Built := true
}

; ==== Toggle / Show / Hide ====
CoordGrid_Toggle() {
    CoordGrid_Init()
    global CoordGrid_Visible
    if (CoordGrid_Visible)
        CoordGrid_Hide()
    else
        CoordGrid_Show()
}

CoordGrid_Show() {
    global CoordGrid_Visible, coordGridCaptureActive, CapsLock, capsLockActive
    CoordGrid_Build()
    CoordGrid_ResetCells()
    CapsLock := ""
    capsLockActive := ""
    coordGridCaptureActive := true
    CoordGrid_Visible := true
    Gui, CoordGrid:Show
    WinSet, TransColor, 000115, CoordGrid
}

CoordGrid_Hide() {
    global CoordGrid_Visible, coordGridCaptureActive, CapsLock
    coordGridCaptureActive := false
    CapsLock := ""
    CoordGrid_Visible := false
    Gui, CoordGrid:Hide
}

CoordGrid_ResetCells() {
    global CoordGrid_Cols, CoordGrid_Rows, CoordGrid_Keys
    Gui, CoordGrid:Hide
    r := 0
    Loop, %CoordGrid_Rows% {
        rowLetter := CoordGrid_Keys[r + 1]
        StringUpper, rowLetter, rowLetter
        c := 0
        Loop, %CoordGrid_Cols% {
            colLetter := CoordGrid_Keys[c + 1]
            StringUpper, colLetter, colLetter
            GuiControl, CoordGrid:Show, % "CG_p_" c "_" r
            GuiControl, CoordGrid:Text, % "CG_t_" c "_" r, % colLetter . rowLetter
            GuiControl, CoordGrid:Show, % "CG_t_" c "_" r
            c += 1
        }
        r += 1
    }
    Gui, CoordGrid:Show, NA
}

CoordGrid_HighlightColumn(colKey) {
    global CoordGrid_Cols, CoordGrid_Rows, CoordGrid_Keys
    Gui, CoordGrid:Hide
    colIdx := Asc(colKey) - 97
    r := 0
    Loop, %CoordGrid_Rows% {
        rowLetter := CoordGrid_Keys[r + 1]
        StringUpper, rowLetter, rowLetter
        c := 0
        Loop, %CoordGrid_Cols% {
            if (c = colIdx) {
                GuiControl, CoordGrid:Show, % "CG_p_" c "_" r
                GuiControl, CoordGrid:Text, % "CG_t_" c "_" r, % rowLetter
                GuiControl, CoordGrid:Show, % "CG_t_" c "_" r
            } else {
                GuiControl, CoordGrid:Hide, % "CG_p_" c "_" r
                GuiControl, CoordGrid:Hide, % "CG_t_" c "_" r
            }
            c += 1
        }
        r += 1
    }
    Gui, CoordGrid:Show, NA
}

; ==== Grid-active hotkeys (gated by coordGridCaptureActive flag) ====
#If coordGridCaptureActive

    ; Close keys
    Esc::
    Backspace::
    SC029::
        CoordGrid_Hide()
    return

    ; Arrow keys move the grid
    Left::
        CoordGrid_Move(-10, 0)
    return
    Right::
        CoordGrid_Move(10, 0)
    return
    Up::
        CoordGrid_Move(0, -10)
    return
    Down::
        CoordGrid_Move(0, 10)
    return

    ; A-Z: capture two letters then navigate (keys are blocked, no ~ prefix)
    a::
    b::
    c::
    d::
    e::
    f::
    g::
    h::
    i::
    j::
    k::
    l::
    m::
    n::
    o::
    p::
    q::
    r::
    s::
    t::
    u::
    v::
    w::
    x::
    y::
    z::
        CoordGrid_HandleKey(A_ThisHotkey)
    return

#If

CoordGrid_HandleKey(key) {
    global CoordGrid_FirstKey, CoordGrid_SecondKey, CoordGrid_TapCount
    SetTimer, CoordGrid_ResetTap, Off
    if (CoordGrid_TapCount = 0) {
        CoordGrid_TapCount := 1
        CoordGrid_FirstKey := key
        CoordGrid_HighlightColumn(key)
        SetTimer, CoordGrid_ResetTap, -3000
        return
    }
    CoordGrid_TapCount := 0
    CoordGrid_SecondKey := key
    CoordGrid_Navigate()
}

CoordGrid_ResetTap:
    CoordGrid_TapCount := 0
    CoordGrid_ResetCells()
return

CoordGrid_Move(dx, dy) {
    WinGetPos, x, y,,, CoordGrid
    WinMove, CoordGrid,, x + dx, y + dy
}

; ==== Navigation ====
CoordGrid_Navigate() {
    global CoordGrid_Rows, CoordGrid_RowSp, CoordGrid_ColSp, CoordGrid_FirstKey, CoordGrid_SecondKey
    CoordMode, Mouse, Screen

    xKey := CoordGrid_FirstKey
    yKey := CoordGrid_SecondKey
    xIdx := Floor(Asc(xKey) - 97)
    yIdx := CoordGrid_Rows - Floor(Asc(yKey) - 97)

    xCoord := (xIdx + 0.2) * CoordGrid_ColSp
    yCoord := (yIdx - 0.7) * CoordGrid_RowSp

    CoordGrid_Hide()
    MouseMove, % xCoord, % yCoord, 0
    DllCall("SystemParametersInfo", "UInt", 0x0057, "UInt", 0, "UInt", 0, "UInt", 0)
}
