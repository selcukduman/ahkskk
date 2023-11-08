#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#KeyHistory 0
;SetBatchLines, -1
ListLines, off
SetBatchLines -1
#SingleInstance Force

; Menu, Tray, Icon, pifmgr.dll,13
Menu, Tray, Icon, ddores.dll,26

; $"::Send {@}
; $@::Send "
; >!<^3::Send {#}
; $#::Send {\}
; $~::Send {|}
; $¬::Send {~}
; SC132::Esc
; Rwin::RControl

"::@
@::"
>!<^3::Send {#}
#::\
~::|
¬::~
SC132::Esc
Rwin::RControl