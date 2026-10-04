!Enter::Run, wt.exe -p Arch -d C:\Users\zion\Downloads

!+Enter::
FileRead, workdir, C:\Users\zion\.workdir
Run, wt.exe -p Arch -d "%workdir%"
return

ProcessExist(name) {
    Process, Exist, %name%
    return ErrorLevel
}
