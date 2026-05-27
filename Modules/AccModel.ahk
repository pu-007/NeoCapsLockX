; Acceleration model for mouse/key movement
; Ported from CapsLockX v1 AccModel.ahk

class AccModel2D
{
    __New(callback, decayRate := 1, accelRatio := 1, vertAccelRatio := 0)
    {
        this.tickTime := 0
        this.leftTime := 0, this.rightTime := 0
        this.upTime := 0, this.downTime := 0
        this.hSpeed := 0, this.hRemain := 0
        this.vSpeed := 0, this.vRemain := 0
        this.leftWaitKey := "", this.rightWaitKey := ""
        this.upWaitKey := "", this.downWaitKey := ""
        this.timerRunning := false
        this.callback := callback
        this.hAccelRatio := accelRatio
        this.vAccelRatio := vertAccelRatio == 0 ? this.hAccelRatio : vertAccelRatio
        this.decayRate := decayRate
        this.midKeyInterval := 0.1
        this.maxSpeed := 0
        this.timerFunc := ObjBindMethod(this, "_ticker")
    }

    _dt(t, now)
    {
        if (!t)
            return 0
        return (now - t) / this._QPF()
    }

    _ma(_dt)
    {
        sgn := _dt > 0 ? 1 : (_dt < 0 ? -1 : 0)
        abs := Abs(_dt)
        a := 0
        a += 1 * sgn * (Exp(abs) - 1)
        a += 3 * sgn
        a += 4 * sgn * abs
        a += 9 * sgn * abs * abs
        a += 16 * sgn * abs * abs * abs
        return a
    }

    _damping(v, a, dt)
    {
        if (this.maxSpeed) {
            if (v < -this.maxSpeed)
                v := -this.maxSpeed
            if (v > this.maxSpeed)
                v := this.maxSpeed
        }
        if (a * v > 0)
            return v
        v *= Exp(-dt * 20)
        v -= (v > 0 ? 1 : (v < 0 ? -1 : 0)) * dt
        if (Abs(v) < 1)
            v := 0
        return v
    }

    _ticker()
    {
        now := this._QPC()
        dt := this.tickTime == 0 ? 0 : ((now - this.tickTime) / this._QPF())
        this.tickTime := now

        leftDur := this._dt(this.leftTime, now)
        rightDur := this._dt(this.rightTime, now)
        upDur := this._dt(this.upTime, now)
        downDur := this._dt(this.downTime, now)

        if (this.leftTime && this.rightTime && Abs(rightDur - leftDur) < this.midKeyInterval) {
            this.callback.Call(rightDur > leftDur ? 1 : -1, 0, "hMid")
            this.stop()
            return
        }
        if (this.upTime && this.downTime && Abs(downDur - upDur) < this.midKeyInterval) {
            this.callback.Call(0, downDur > upDur ? 1 : -1, "vMid")
            this.stop()
            return
        }

        hAccel := this._ma(rightDur - leftDur) * this.hAccelRatio
        vAccel := this._ma(downDur - upDur) * this.vAccelRatio

        this.hSpeed := this._safeAdd(this.hSpeed, hAccel * dt)
        this.vSpeed := this._safeAdd(this.vSpeed, vAccel * dt)
        this.hSpeed := this._damping(this.hSpeed, hAccel, dt)
        this.vSpeed := this._damping(this.vSpeed, vAccel, dt)

        if (!dt) {
            this.callback.Call(0, 0, "start")
            this.hRemain := hAccel > 0 ? 1 : (hAccel < 0 ? -1 : 0)
            this.vRemain := vAccel > 0 ? 1 : (vAccel < 0 ? -1 : 0)
        }

        this.hRemain := this._safeAdd(this.hRemain, this.hSpeed * dt)
        this.vRemain := this._safeAdd(this.vRemain, this.vSpeed * dt)

        hOut := Round(this.hRemain)
        vOut := Round(this.vRemain)
        this.hRemain -= hOut
        this.vRemain -= vOut

        if (hOut || vOut)
            this.callback.Call(hOut, vOut, "move")

        if (this.leftWaitKey && !GetKeyState(this.leftWaitKey, "P"))
            this.leftWaitKey := "", this.leftTime := 0
        if (this.rightWaitKey && !GetKeyState(this.rightWaitKey, "P"))
            this.rightWaitKey := "", this.rightTime := 0
        if (this.upWaitKey && !GetKeyState(this.upWaitKey, "P"))
            this.upWaitKey := "", this.upTime := 0
        if (this.downWaitKey && !GetKeyState(this.downWaitKey, "P"))
            this.downWaitKey := "", this.downTime := 0

        if (!this.hSpeed && !this.vSpeed && !hOut && !vOut) {
            this.stop()
            return
        }
        timer := this.timerFunc
        SetTimer, % timer, -1
    }

    start()
    {
        this.tickTime := 0
        this.timerRunning := true
        this._ticker()
        timer := this.timerFunc
        SetTimer, % timer, -1
    }

    stop()
    {
        timer := this.timerFunc
        SetTimer, % timer, Off
        this.timerRunning := false
        if (this.tickTime != 0) {
            this.tickTime := 0
            try this.callback.Call(0, 0, "stop")
        }
        this.tickTime := 0
        this.leftTime := 0, this.rightTime := 0
        this.upTime := 0, this.downTime := 0
        this.hSpeed := 0, this.hRemain := 0
        this.vSpeed := 0, this.vRemain := 0
        this.leftWaitKey := "", this.rightWaitKey := ""
        this.upWaitKey := "", this.downWaitKey := ""
    }

    leftDown(keyName := "")
    {
        if (this.leftWaitKey)
            return
        this.leftWaitKey := keyName
        if (!this.leftTime)
            this.leftTime := this._QPC()
        if (!this.timerRunning)
            this.start()
    }
    leftUp() {
        this.leftTime := 0
    }
    rightDown(keyName := "")
    {
        if (this.rightWaitKey)
            return
        this.rightWaitKey := keyName
        if (!this.rightTime)
            this.rightTime := this._QPC()
        if (!this.timerRunning)
            this.start()
    }
    rightUp() {
        this.rightTime := 0
    }
    upDown(keyName := "")
    {
        if (this.upWaitKey)
            return
        this.upWaitKey := keyName
        if (!this.upTime)
            this.upTime := this._QPC()
        if (!this.timerRunning)
            this.start()
    }
    upUp() {
        this.upTime := 0
    }
    downDown(keyName := "")
    {
        if (this.downWaitKey)
            return
        this.downWaitKey := keyName
        if (!this.downTime)
            this.downTime := this._QPC()
        if (!this.timerRunning)
            this.start()
    }
    downUp() {
        this.downTime := 0
    }

    _QPF()
    {
        DllCall("QueryPerformanceFrequency", "Int64*", pf)
        return pf
    }

    _QPC()
    {
        DllCall("QueryPerformanceCounter", "Int64*", pc)
        return pc
    }

    _safeAdd(acc, x)
    {
        c := acc + x
        sgnA := acc > 0 ? 1 : (acc < 0 ? -1 : 0)
        sgnC := c > 0 ? 1 : (c < 0 ? -1 : 0)
        if (sgnA == sgnC)
            return c
        if (acc > 1073741823 && sgnA != sgnC)
            return 2147483647
        if (acc < -1073741824 && sgnA != sgnC)
            return -2147483648
        return c
    }
}
