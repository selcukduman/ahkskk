; REMOVED: #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
KeyHistory(0)
;SetBatchLines, -1
ListLines(false)
; REMOVED: SetBatchLines -1
#SingleInstance Force

#Include "Lyt_newV2.ahk"
Loop Lyt.GetList().MaxIndex()
	str .= A_Index ": " Lyt.GetList()[A_Index].LocFullName " - " Lyt.GetList()[A_Index].DisplayName	. "`n" Format("{:#010x}", Lyt.GetList()[A_Index].hkl) "`n"
MsgBox(str, "Your system loaded layout list", "")