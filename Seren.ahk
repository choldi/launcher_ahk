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
runwait, taskkill /f /im kodi.exe,,hide
runwait, taskkill /f /im chrome.exe,,hide
runwait, taskkill /f /im msedge.exe,,hide
;MsgBox ,,"Kodi", "Starting Seren",5
run g:\kodi\kodi.exe -p
WinWaitActive, ahk_class Kodi,, 5
if ErrorLevel
{
    MsgBox, WinWait timed out.
}
WinShow, ahk_class Kodi ;First to front
WinActivate, ahk_class Kodi
WinGet, ExStyle, ExStyle, ahk_class Kodi ;"Style" and "ahk_class" could not detect properly fullscreen or windowed mode of Kodi
if (ExStyle & 0x00000100)  ;0x00000100 is WS_EX_WINDOWEDGE
    {
        SendInput, !{Enter}
    }
sendInput, !s
ExitApp