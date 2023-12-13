#NoEnv
#Persistent
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode 2         ; For the PostMessage
DetectHiddenWindows on      ; Same

Auto = AutoStart.txt
IconFile = OneIcon.ico

If FileExist(IconFile)
  Menu Tray, Icon, %IconFile%

Menu Tray, NoStandard
Menu Tray, add, Exit, ExitApp
Menu Tray, add
Menu Tray, add, Add an AutoStart`, Optionally run, AutoEdit
Menu Tray, add, AutoStart OneIcon, ToggleMeAutoStart
Menu Tray, add
Menu Tray, add, Run new script without Autostart, RunNew
Menu Tray, add

If FileExist(A_Startup "\OneIcon.lnk")
   Menu Tray, Check, AutoStart OneIcon

If FileExist(Auto)
   Loop READ, %Auto%
      If FileExist(A_LoopReadLine)
      {
         NewAHK := A_LoopReadLine
         GoSub RunNew
      }
return


RunNew:                            ; allows the user to run a new script managed by this tray icon.
   If InStr(A_ThisMenuItem, "Run new")
      FileSelectFile NewAHK, 3, %A_WorkingDir%,, AutoHotkey Scripts (*.ahk)
   If NewAHK=
      return                       ; Exit because they clicked cancel

   FileRead Text, %NewAHK%
   If !RegExMatch(Text, "i)#NoTrayIcon"){
      FileDelete %NewAHK%
      FileAppend #NoTrayIcon`r`n%Text%, %NewAHK%
   }

   SplitPath NewAHK, FileName
   Menu Tray, Add, %FileName%, ShowMenu
   Run %NewAHK%
   RunningList .= NewAHK "|"
   NewAHK =
return


ShowMenu:                         ; Shows the tray menu for the selected script
   If WinExist(A_ThisMenuItem)    ; Thanks to [VxE] for this cryptic SendMessage:
      SendMessage, 0x404, 0, 0x205,,%A_ThisMenuItem%
   Else{
      Menu tray, delete, %A_ThisMenuItem%
      StringReplace RunningList, RunningList, %A_ThisMenuItem%|
   }
return

AutoEdit:                         ; Edits the autostart text file
   Gui Destroy
   Gui add, Text,, The following programs AutoStart with OneIcon (Click to remove):
   Gui add, Text
   If FileExist(Auto)
   {
      Loop READ, %Auto%
      {
         If (A_LoopReadLine = "")
            Continue
         Else If !FileExist(A_LoopReadLine)
            Gui add, text, cRed gRemoveAutoStart vT%A_Index%, %A_LoopReadLine%
         Else
            Gui add, text, gRemoveAutoStart vT%A_Index%, %A_LoopReadLine%
      }
      Gui add, Text
   }
   Else
      Gui add, text,, (None)

   ; Thanks to tidbit for this code to horizontally center a control:
   Gui add, Button, vBtn, Add New
   Gui Show
   Gui +LastFound
   WinGetPos,,,ww
   GuiControlGet Btn, pos, Btn
   center:=(ww/2)-(BtnW/2)
   GuiControl Move, btn, x%center%

return

ButtonAddNew:				; Adds a new autostart; accessed from AutoEdit GUI
   FileRead, Whole, %Auto%
   FileSelectFile, New, 3, %A_WorkingDir%,, AutoHotkey Scripts (*.ahk)
   If Errorlevel ; user dismissed
      Return
   If !InStr(Whole, New)
   {
      FileAppend %New%`n, %Auto%
      GoSub AutoEdit			; Re-Show the AutoEdit Gui
      MsgBox 4, OneIcon, Run Now?
      IfMsgBox Yes
      {
         NewAHK := New
         GoSub RunNew
      }
   }Else
      MsgBox Already in list
return

RemoveAutoStart:
   GuiControlGet file,, %A_GuiControl%
   FileRead Whole, %Auto%
   StringReplace Whole, Whole, %File%

   ; Remove all blank lines:
   While Instr(Whole, "`r`n`r`n")
     StringReplace, Whole, Whole, `r`n`r`n, `r`n

   FileDelete %Auto%
   FileAppend %Whole%, %Auto%
   GoSub AutoEdit
return

ToggleMeAutoStart:
   If FileExist(A_Startup . "\OneIcon.lnk"){
      Menu Tray, Uncheck, AutoStart OneIcon
      FileDelete %A_Startup%\OneIcon.lnk
   }Else{
      Menu Tray, Check, AutoStart OneIcon
      FileCreateShortcut %A_ScriptFullPath%, %A_StartUp%\OneIcon.lnk,WD,Arg,Manages multiple AutoHotkey scripts, % ((FileExist(IconFile)) ? (A_WorkingDir "" IconFile) : (""))
   }
return

ExitApp:
   MsgBox 1, OneIcon, this will exit all scripts managed by OneIcon. Continue?
   IfMsgBox No
      Return
   Loop PARSE, RunningList,|
   {
      WinClose %A_LoopField%
      ToolTip Closed %A_LoopField%
   }
   ExitApp