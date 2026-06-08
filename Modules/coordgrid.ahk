; CoordGrid — coordinate overlay for mouse positioning via two-letter combos
; Ref: https://raw.githubusercontent.com/GavinPen/AhkCoordGrid/refs/heads/master/AHKCoordGrid.ahk
; Trigger: CapsLock + ` (backtick) in normal mode or capsLockActive mode
;
; When grid is active: press two letter keys → cursor moves to that cell.
; Arrow keys move the grid. Esc / Backspace / ` closes it.
;
; All globals are lazily initialized in CoordGrid_Init() because the
; auto-execute section terminates at the first hotkey in mouse.ahk.

SetStoreCapslockMode, Off

; ==== Trigger: CapsLock (held or latched) + backtick ====
#If (CapsLock || capsLockActive)

*SC029::
    CapsLock2 := ""
    CoordGrid_Toggle()
return

#If

; Pre-warm: build GUI hidden on script start.
; TransColor is applied before any Show to prevent the black-flash on first display.
CoordGrid_StartupWarm:
    CoordGrid_Init()
    CoordGrid_Build()
return

; ==== Lazy global init ====
CoordGrid_Init() {
    global
    static _done := false
    if (_done)
        return
    _done := true

    CoordGrid_Rows := 26
    CoordGrid_Cols := 26
    CoordGrid_Keys := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    CoordGrid_Visible := false
    CoordGrid_Built := false
    CoordGrid_FirstKey := ""
    CoordGrid_SecondKey := ""
    CoordGrid_TapCount := 0
    CoordGrid_GridW := A_ScreenWidth
    CoordGrid_GridH := A_ScreenHeight
    CoordGrid_RowSp := CoordGrid_GridH / CoordGrid_Rows
    CoordGrid_ColSp := CoordGrid_GridW / CoordGrid_Cols
    CoordGrid_CtrlSize := 21   ; default; recalculated in Build
    CoordGrid_BuiltW := 0
    CoordGrid_BuiltH := 0
}

; ==== Grid GUI ====
; +LastFound: allows WinSet to target this GUI before it is shown.
CoordGrid_Build() {
    global
    if (CoordGrid_Built && CoordGrid_GridW = CoordGrid_BuiltW && CoordGrid_GridH = CoordGrid_BuiltH)
        return
    if (CoordGrid_Built) {
        Gui, CoordGrid:Destroy
        CoordGrid_Built := false
    }

    Gui, CoordGrid:New, +AlwaysOnTop -Caption +ToolWindow +LastFound
    Gui, CoordGrid:-DPIScale  ; Disable AHK auto-scaling — mouse.ahk sets per-monitor
                               ; DPI awareness, so controls must use raw physical pixels
                               ; to match MouseMove,Screen coordinate space.

    ; Compute font/control size proportional to cell dimensions.
    ; For 1080p (~42px cells): font≈14, ctrl≈28.  For 4K (~83px): font≈29, ctrl≈58.
    fontSize := Round(CoordGrid_RowSp * 0.35)
    if (fontSize < 9)
        fontSize := 9
    if (fontSize > 36)
        fontSize := 36
    CoordGrid_CtrlSize := fontSize * 2
    if (CoordGrid_CtrlSize < 21)
        CoordGrid_CtrlSize := 21
    Gui, CoordGrid:Font, s%fontSize%, Consolas
    Gui, CoordGrid:Color, 000115

    ; Padding: Progress background extends beyond text to create a border frame.
    ; At 1080p ~3px, at 4K ~6px.  Prevents letters from feeling "cut off" at edges.
    CoordGrid_Pad := Round(CoordGrid_CtrlSize * 0.1)
    if (CoordGrid_Pad < 2)
        CoordGrid_Pad := 2

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

            ; Checkerboard: alternate white and light gray-blue backgrounds.
            ; White = FFFFFF, Light gray-blue = DCE2EC.
            isEven := Mod(colCounter + rowCounter, 2) = 0
            bgColor := isEven ? "FFFFFF" : "DCE2EC"

            ; Progress extends CoordGrid_Pad beyond text on each side for padding.
            progX := (colX - CoordGrid_Pad < 0) ? 0 : colX - CoordGrid_Pad
            progY := (rowY - CoordGrid_Pad < 0) ? 0 : rowY - CoordGrid_Pad
            progW := CoordGrid_CtrlSize + CoordGrid_Pad * 2
            progH := CoordGrid_CtrlSize + CoordGrid_Pad * 2

            Gui, CoordGrid:Add, Progress, % "w" progW " h" progH " x" progX " y" progY " Background" bgColor " disabled vCG_p_" colCounter "_" rowCounter
            Gui, CoordGrid:Add, Text, % "w" CoordGrid_CtrlSize " h" CoordGrid_CtrlSize " x" colX " y" rowY " Border 0x201 ReadOnly BackgroundTrans cBlack vCG_t_" colCounter "_" rowCounter, % colAlpha . rowAlpha
            colCounter += 1
        } Until colCounter = CoordGrid_Cols
        rowCounter += 1
    } Until rowCounter = CoordGrid_Rows

    Gui, CoordGrid:Show, x0 y0 Hide W%CoordGrid_GridW% H%CoordGrid_GridH%, CoordGrid
    Gui, CoordGrid:+LastFound
    WinSet, TransColor, 000115
    CoordGrid_BuiltW := CoordGrid_GridW
    CoordGrid_BuiltH := CoordGrid_GridH
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
    Critical
    global CoordGrid_Visible, coordGridCaptureActive, CapsLock, capsLockActive, CapsLock2
    global CoordGrid_GridW, CoordGrid_GridH, CoordGrid_RowSp, CoordGrid_ColSp, CoordGrid_Rows, CoordGrid_Cols
    ; Refresh dimensions from primary screen each time grid opens.
    ; With -DPIScale on the GUI (set in Build), A_ScreenWidth/Height and
    ; MouseMove,Screen all use the same raw physical pixel coordinate space.
    CoordGrid_GridW := A_ScreenWidth
    CoordGrid_GridH := A_ScreenHeight
    CoordGrid_RowSp := CoordGrid_GridH / CoordGrid_Rows
    CoordGrid_ColSp := CoordGrid_GridW / CoordGrid_Cols
    CoordGrid_Build()
    CapsLock2 := ""
    CapsLock := ""
    capsLockActive := ""
    coordGridCaptureActive := true
    CoordGrid_Visible := true
    CoordGrid_Redraw()
}

CoordGrid_Hide() {
    global CoordGrid_Visible, coordGridCaptureActive, CapsLock, CapsLock2
    global CoordGrid_TapCount
    SetTimer, CoordGrid_ResetTap, Off
    coordGridCaptureActive := false
    CapsLock2 := ""
    CapsLock := ""
    CoordGrid_Visible := false
    CoordGrid_TapCount := 0
    Gui, CoordGrid:Hide
}

; Helper: apply TransColor after GUI has been shown (matching original AHKCoordGrid flow).
CoordGrid_Redraw() {
    CoordGrid_ResetCells()
    Gui, CoordGrid:+LastFound
    WinSet, TransColor, 000115
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
    Gui, CoordGrid:Show, x0 y0 NA
    Gui, CoordGrid:+LastFound
    WinSet, TransColor, 000115
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
    Gui, CoordGrid:Show, x0 y0 NA
    Gui, CoordGrid:+LastFound
    WinSet, TransColor, 000115
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
    global CoordGrid_FirstKey, CoordGrid_SecondKey, CoordGrid_TapCount, coordGridCaptureActive
    if (!coordGridCaptureActive)
        return
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
    if (coordGridCaptureActive)
        CoordGrid_Redraw()
return

CoordGrid_Move(dx, dy) {
    WinGetPos, x, y,,, CoordGrid
    WinMove, CoordGrid,, x + dx, y + dy
}

; ==== Navigation ====
CoordGrid_Navigate() {
    global CoordGrid_Rows, CoordGrid_RowSp, CoordGrid_ColSp, CoordGrid_FirstKey, CoordGrid_SecondKey
    global CoordGrid_CtrlSize
    CoordMode, Mouse, Screen

    xKey := CoordGrid_FirstKey
    yKey := CoordGrid_SecondKey
    xIdx := Floor(Asc(xKey) - 97)                             ; 0–25  (A=left  … Z=right)
    yIdx := CoordGrid_Rows - 1 - Floor(Asc(yKey) - 97)       ; 25–0  (A=bottom … Z=top)

    ; Compute the exact label control position (same Round() logic as Build).
    ; This eliminates the sawtooth rounding-error pattern from fractional ColSp.
    colX := Round(xIdx * CoordGrid_ColSp)
    rowY := Round(yIdx * CoordGrid_RowSp)

    ; Target the center of the control (where the text label is visually centered).
    xCoord := colX + CoordGrid_CtrlSize // 2
    yCoord := rowY + CoordGrid_CtrlSize // 2

    CoordGrid_Hide()
    MouseMove, % xCoord, % yCoord, 0
    DllCall("SystemParametersInfo", "UInt", 0x0057, "UInt", 0, "UInt", 0, "UInt", 0)
    Sleep, 30
    MouseMove, 1, 0, 0, R
    MouseMove, -1, 0, 0, R
}
