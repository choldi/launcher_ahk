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
SetTitleMatchMode 2
runwait, taskkill /f /im kodi.exe,,hide
runwait, taskkill /f /im chrome.exe,,hide
runwait, taskkill /f /im msedge.exe,,hide
;MsgBox ,,"Kodi", "Starting Seren",5
name_win:="YouTube - Google Chrome"
run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"  https://www.youtube.com -start-fullscreen
WinWaitActive, %name_win%,, 5
if ErrorLevel
    {
        WinShow,%name_win% ;First to front
        WinActivate, %name_win%       ; MsgBox, WinWait timed out.
    }
WinGet, ExStyle, ExStyle, %name_win% ;"Style" and "ahk_class" could not detect properly fullscreen or windowed mode of Kodi
if (ExStyle & 0x00000100)  ;0x00000100 is WS_EX_WINDOWEDGE
    {
        SendInput, {F11}
    }
sleep 1000
Winkill, Quieres restaurar
ExitApp