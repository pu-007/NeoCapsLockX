; Standalone global hotkeys
; Hyper = Ctrl+Shift+Win+Alt

^+!#c::
if !ProcessExist("Weixin.exe")
    Run, C:\Program Files\Tencent\Weixin\Weixin.exe
else
    Send ^+!{F12}
return

^+!#q::
if !ProcessExist("QQ.exe")
    Run, C:\Program Files\Tencent\QQNT\QQ.exe
else
    Send ^#{F12}
return

^+!#n::Run, wt.exe -p archlinux wsl nvim -c 'read !win32yank.exe -o'

#y::Run, wt.exe -p archlinux wsl zsh -ic 'y /mnt/c/Users/zion/Downloads/'

!Enter::Run, wt.exe -p Arch -d C:\Users\zion\Downloads

!+Enter::
FileRead, workdir, C:\Users\zion\.workdir
Run, wt.exe -p Arch -d "%workdir%"
return

ProcessExist(name) {
    Process, Exist, %name%
    return ErrorLevel
}
