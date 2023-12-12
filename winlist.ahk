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
