#NoEnv
#SingleInstance force
#Persistent
#MaxThreadsPerHotkey,1 ; no re-entrant hotkey handling
#InstallKeybdHook
SetCapsLockState, AlwaysOff 
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
SetTitleMatchMode, RegEx ; Find window titles by regex
DetectHiddenWindows,On
SetWinDelay, -1
SetKeyDelay, -1
SetTitleMatchMode, 2


CustomColor = 080808
Gui main:new
Gui, Color, %CustomColor%

IniRead, sects, buttons.ini
sectionsArray := StrSplit(sects, "`n")
; --- get ini Data and put it into global variables
;gui 
Menu Tray, Icon, shell32.dll, 97
not_avail:="Not_Avail.jpg"

Gui Add, StatusBar,, Status Bar
Gui Add, Button, x16 y672 w130 h50 vPrev gButton, Prev
Gui Add, Button, x824 y672 w130 h50 vNext gButton, Next
Gui Add, Button, x420 y672 w130 h50 gSendBack, Send Back
Guicontrol, Hide, Prev
counter=0
global commands:=[]
global names:=[]
global horiz:=[16,336,656]
global vert:=[16,240,456]
global width:=300
global height:=200
global currentPage:=0
global numPages:=0
global maxElements:=0
Loop % sectionsArray.MaxIndex()
    {
        
        this_section := sectionsArray[a_index]
        names[counter]:=this_section
        IniRead, keys, buttons.ini, %this_section%
        keysArray := StrSplit(keys, "`n")
        Loop % keysArray.MaxIndex()
            {
                keyvalue := keysArray[a_index]

                this_key := StrSplit(keyvalue,"=")[1]
                this_value:= StrSplit(keyvalue,"=")[2]
                if (this_key = "link")
                {
                    commands[counter]:=this_value
                }
            }
        c:=counter//9
        c:=counter - c*9
        posX:=horiz[Mod(c,3)+1]
        
        posY:=vert[(c//3)+1]
        Gui, Add, Picture, x%posX% y%posY% w%width% h%height% gStart v%counter%, buttons/%this_section%.png   
        GuiControl, Hide, %counter% 
        counter:=counter+1
    }
maxElements:=counter-1
numPages:=counter//9
if (numPages = 0)
     {
        Guicontrol, Hide, Next
     }

print_page(currentPage)
Gui Show, w975 h761, Launcher
OnMessage(0x0003, "GuiMoved")

return 




MainGuiEscape:
MainGuiClose:
    return

    clear_page(_currentPage)
    {    
        first:=_currentPage * 9
        last := first + 8 > maxElements ? maxElements : first+8
        numElems:=last - first + 1
        loop % numElems
            {
                elem:=first + A_Index - 1
                GuiControl, Hide, %elem%
            }
    }

print_page(_currentPage)
{
    SB_SetText("Status Bar" A_Tab A_Tab "Page:" _currentPage)
    first:=_currentPage * 9
    last := first + 8 > maxElements ? maxElements : first+8
    numElems:=last - first + 1
    loop % numElems
        {
            elem:=first + A_Index - 1
            GuiControl, Show, %elem%  
        }
    return
}    


DeclareGlobal(angelic) {
    global           ; Makes the entire function global
    (%angelic%)      ; Dereference. Parethesis make this a valid statement.
    return           ; A reference i.e. %angelic% cannot be returned. 
 }
 

 start:
    ;gui,2:submit,nohide
    Mousegetpos,,,,Ctrl       ;- Button1
    r:= a_guicontrol          ;- vVar ( Buttonname )
    elem:=a_guicontrol ;+ 9*currentPage
    stringtrimleft,ct,ctrl,6  ;- Button-(1)
    url:= commands[elem]
    name:=names[elem]
    SplashTextOn, 800, 200, Start, Startin program:`n%url%
    Run, %url%
    Sleep 2000
    SplashTextOff
    WinSet, Bottom
    return

Button:
    cl:=A_GuiControl
    clear_page(currentPage)
    if (cl = "Next")
        {
            Guicontrol, Show, Prev
            currentPage:=currentPage + 1
            if (currentPage>=maxPages) 
                {
                    Guicontrol, Hide, Next          
                } 
        }
    Else
        {
            Guicontrol, Show, Next
            currentPage:=currentPage - 1
            if (currentPage=0) 
                {
                    Guicontrol, Hide, Prev          
                } 
        }
    print_page(currentPage)

    return

SendBack:
    WinSet, Bottom
    return

GuiMoved(wParam, lParam) 
{
    SetTimer, MoveCenter, 1000
    Return
}

MoveCenter()
{
    SetTimer, MoveCenter, off
    Gui main:Show, Center 
    Return
}

;; WinList is a listbox control with delim set to newline
WinList()
{
    WinGet,WinList,List,,,Program Manager
    List=
    loop,%WinList%{
        Current:=WinList%A_Index%
        WinGetTitle,WinTitle,ahk_id %Current%
        WinGet,PID,PID,ahk_id %Current%

        Cont=1
        loop,parse,TempPID,`n
            Cont:=(A_LoopField=PID) ? 0 : Cont

        TempPID.=PID "`n"

        If WinTitle && Cont
            List.="`n" WinTitle
    }
    TempPID=
    Return List
}
