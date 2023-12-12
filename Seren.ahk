#NoEnv
#SingleInstance force
#Persistent
#MaxThreadsPerHotkey,1 ; no re-entrant hotkey handling
#InstallKeybdHook
SetCapsLockState, AlwaysOff 
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
SetWinDelay, -1
SetKeyDelay, -1
runwait, taskkill /f /im kodi.exe
;MsgBox ,,"Kodi", "Starting Seren",5
run c:\programas\kodi-19\kodi.exe -p
;curs:=[]
;cur:=A_Cursor
;curs.push(cur)
;Loop 50
;    { 
;    if (cur!=A_Cursor)
;        {
;            curs.push(A_Cursor)
;            cur:=A_Cursor
;        }
;    Sleep, 100
;    }
WinWaitActive, ahk_class Kodi,, 5
if ErrorLevel
{
    MsgBox, WinWait timed out.
    return
}
WinShow, ahk_class Kodi ;First to front
WinActivate, ahk_class Kodi
WinGet, ExStyle, ExStyle, ahk_class Kodi ;"Style" and "ahk_class" could not detect properly fullscreen or windowed mode of Kodi
if (ExStyle & 0x00000100)  ;0x00000100 is WS_EX_WINDOWEDGE
    {
        SendInput, !{Enter}
    }
sendInput, ^m
ExitApp