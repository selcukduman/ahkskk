#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#KeyHistory 0
;SetBatchLines, -1
ListLines, off
SetBatchLines -1
#SingleInstance Force


; Menu, Tray, Icon, imageres.dll,251
Menu, Tray, Icon, ddores.dll,29 ; ddores.dll,108 is another alternative
SetTitleMatchMode, 2 ; 2 = a partial match on the title
;#MaxHotkeysPerInterval, 300


;Change the mouse wheel direction
;WheelUp::WheelDown
;WheelDown::WheelUp

;Fn F4
;NumpadAdd::Send SC163

; #y::
; Sleep 1000  ; Give user a chance to release keys (in case their release would wake up the monitor again).
; ; Turn Monitor Off:
; SendMessage, 0x112, 0xF170, 2,, Program Manager  ; 0x112 is WM_SYSCOMMAND, 0xF170 is SC_MONITORPOWER.
; ; Note for the above: Use -1 in place of 2 to turn the monitor on.
; ; Use 1 in place of 2 to activate the monitor's low-power mode.
; return

;Remove line breaks from markdown files
;\::Send {End}{Delete}{Space}{End}

; Dell Keyboard HAcks
dell := 0
#!k::
    dell:=!dell ;not! toggle
return

#If dell ; All hotkeys below this line will only work if dell is TRUE
  F11::Home
  F12::End
  Home::F11
  End::F12
#If

; OMOTON Keyboard Hacks
; omoton := 0
; #!k::
;     omoton:=!dell ;not! toggle
; return

; #If omoton ; All hotkeys below this line will only work if omoton is TRUE
;   "::@
;   @::"
;   >!<^3::Send {#}
;   #::\
;   ~::|
;   ¬::~
;   SC132::Esc
;   Rwin::RControl
; #If
;End of Keyboard hacks

; TipGuiEscape:
; ExitApp

; TipOff:
; Gui, Tip:Hide
; Return

; tip(text := "", x := 10, y := 10, duration := 0, wait := False) {
;  Static tipSetup := False, tipWidth := 230, tipText
;  If !tipSetup {
;   Gui, Tip:New, -Caption Border +AlwaysOnTop
;   Gui, Font, s22
;   Gui, Color, FFFFA2
;   Gui, Add, Text, w%tipWidth% vtipText, Tooltip
;   tipSetup := True
;  }
;  If text {
;   GuiControl, Text, tipText, %text%
;   WinGetActiveTitle, title
;   Gui, Tip:Show, x%x% y%y% w%tipWidth%
;   WinActivate, %title%
;   If duration
;    If wait
;     Sleep, %duration%
;    Else SetTimer, TipOff, % -1 * duration
;  }
;  If !text || duration && wait
;   Gosub, TipOff
; }

; #c::
;   tip("This kinda looks like a tooltip, but it's bigger.", 20, 20, 3600)
;   MsgBox, Done.
;   Return


; Paste text and emulate typing (CTRL+SHIFT+V)
; https://gist.github.com/JamoCA/1d6d4a14b3ccfd9b3a0bf94db0c447ed
#o:: 
AutoTrim,On
string = %clipboard%
Sleep, 1000
Gosub,ONLYTYPINGCHARS
StringSplit, charArray, string
Loop %charArray0%
{
	this_char := charArray%a_index%
	SendInput, {Raw}%this_char%
	; Random, typeSlow, 1, 3
	; typeMin = 50
	; typeMax = 150
	; if (typeSlow >= 3){
	; 	typeMin = 150
	; 	typeMax = 350
	; }
	; Random, t, typeMin, typeMax
	; Sleep, %t%
	Sleep, 51
}
Return

ONLYTYPINGCHARS:
AutoTrim,Off
StringCaseSense,On
StringReplace,string,string,–,-,All	;emdash
StringReplace,string,string,´,',All
StringReplace,string,string,’,',All
StringReplace,string,string,©,(C),All
StringReplace,string,string,“,",All	;left quote
StringReplace,string,string,”,",All	;right quote
StringReplace,string,string,®,(R),All
StringReplace,string,string,¼,1/4,All
StringReplace,string,string,½,1/2,All
StringReplace,string,string,¾,3/4,All
StringReplace,string,string,™,TM,All
StringReplace,string,string,«,<<,All
StringReplace,string,string,»,>>,All
StringReplace,string,string,„,',All
StringReplace,string,string,•,-,All	;bullet
StringReplace,string,string,…,...,All
StringReplace,string,string,`r`n,`n,All ;replace newlines
StringReplace,string,string,chr(0),A_Space,All ;NULL
StringReplace,string,string,chr(9),A_Space,All ;Horizontal Tab
StringReplace,string,string,chr(10),A_Space,All ;Line Feed
StringReplace,string,string,chr(11),A_Space,All ;Vertical Tab
StringReplace,string,string,chr(14),A_Space,All ;Column Break
StringReplace,string,string,chr(160),A_Space,All ;Non-breaking space
Return


;Disabled keys
Insert::return
F15::return
Numlock::SetNumLockState, AlwaysOn

;Associations
!^Numpad4::Send selcukduman@gmail.com
!^Numpad2::Send selcuk.duman1@vodafone.com
!^Numpad5::Send selcuk.duman@vodafone.com
!^Numpad6::Send V0dafone{!}{Return}
;!^Numpad3::Send vodafone{Tab}
;!^Numpad9::Send DellBMO1{!}{Return}
>!4::Send £
>!>+4::Send €

;Paste Raw Clipboard
#+o::
Sleep, 1000
Send {Raw}%Clipboard%
Return

;On-top and Transparency
^#F8::
  WinSet, AlwaysOnTop, toggle, A
  WinGet, ExStyle, ExStyle, A
  Tooltip,  % (ExStyle & 0x8 = 0) ? "Always-On-Top OFF" : "Always-On-Top ON"
  Sleep, 1500
  ToolTip
Return

^#F9::WinSet, Transparent, 100, A
^#F10::WinSet, Transparent, 255, A
^#F11::
  Menu, Transparency, Add, 255, SetTrans
  Menu, Transparency, Add, 190, SetTrans
  Menu, Transparency, Add, 125, SetTrans
  Menu, Transparency, Add, 65, SetTrans
  Menu, Transparency, Show
Return

SetTrans:
  Sleep 100
  WinSet, Transparent, %A_ThisMenuItem%, A
Return



#+\::
 {
  if WinExist("MicManager.ahk")
  {
    WinClose ; use the window found above
    return
  }
  else
  {
    Run, % *RunAs A_ScriptDir "\AHK\Mic-Manager\MicManager.ahk"
    return
  }
 }

#+c::
 {
  if WinExist("Calculator")
  {
    WinClose ; use the window found above
    return
  }
  else
  {
    Run c:\windows\system32\calc.exe
    return
  }
 }


; Google Search::
#g::
OpenHighlighted()
return

OpenHighlighted()
{
	MyClipboard := "" ; Clears variable
  clipboard =	; Clears the clipboard
	Send, {ctrl down}c{ctrl up} ; More secure way to Copy things
	sleep, 300 ; Delay
	MyClipboard := RegexReplace( clipboard, "^\s+|\s+$" ) ; Trim additional spaces and line return
	sleep, 50
	MyStripped := StrReplace(MyClipboard, " ", "") ; Removes every spaces in the string.

	StringLeft, OutputVarUrl, MyStripped, 8 ; Takes the 8 firsts characters
	StringLeft, OutputVarLocal, MyStripped, 3 ; Takes the 3 first characters
	sleep, 50

	if (OutputVarUrl == "http://" || OutputVarUrl == "https://")
		Desc := "URL", Target := MyStripped
	else if (OutputVarLocal == "C:/" || OutputVarLocal == "C:\" || OutputVarLocal == "Z:/" || OutputVarLocal == "Z:\" || OutputVarLocal == "R:/" || OutputVarLocal == "R:\" ||)
		Desc := "Windows", Target := MyClipboard
	else
		Desc := "GoogleSearch", Target := "http://www.google.com/search?q=" MyClipboard

	; TrayTip,, %Desc%: "%MyClipboard%" ;
  ; ToolTip, %Desc%: "%MyClipboard%";
	Sleep,50
	Run, %Target%
  ; Sleep, 1500
  ; ToolTip
	Return
}

;-------------------------------

; XButton1::
;     timeHasElapsed := 0
;     SetTimer, OpenTaskView, -300 ;if the key was pressed down for more than 200ms send > (negative value to make the timer run only once)
;     KeyWait, XButton1, U ;wait for the key to be released
;     if (timeHasElapsed == 0) ;if the timer didn't go off disable the timer and send x
;     {
;         SetTimer, OpenTaskView, OFF
;         SendInput, {LCtrl down}{LWin down}{Left}{LCtrl up}{LWin up}
;     }
; return
;
; XButton2::
;     timeHasElapsed := 0
;     SetTimer, OpenTaskView, -300
;     KeyWait, XButton2, U
;     if (timeHasElapsed == 0)
;     {
;         SetTimer, OpenTaskView, OFF
;         SendInput, {LCtrl down}{LWin down}{Right}{LCtrl up}{LWin up}
;     }
; return
;
;
; OpenTaskView:
;     SendInput, {LWin down}{Tab}{LWin up}
; return

;-------------------------------

; Switches between windows of the same app
; https://superuser.com/questions/1604626/easy-way-to-switch-between-two-windows-of-the-same-app-in-windows-10
!\::
WinGetClass, OldClass, A
WinGet, ActiveProcessName, ProcessName, A
WinGet, WinClassCount, Count, ahk_exe %ActiveProcessName%
IF WinClassCount = 1
    Return
loop, 2 {
  WinSet, Bottom,, A
  WinActivate, ahk_exe %ActiveProcessName%
  WinGetClass, NewClass, A
  if (OldClass <> "CabinetWClass" or NewClass = "CabinetWClass")
    break
}

; -------------------------------
;If win/process exist statements

; Match process like AHK v2
ProcessExist(Name){
Process,Exist,%Name%
return Errorlevel
}

;This is problematic, if placed at the top, disables the parts until the next #if statement is 
#If ProcessExist("MicSwitch.exe")
{
RControl::!+^NumpadMult
return
}

;This is to save the script and reload it after change
#IfWinActive, ShortcutKeys.ahk
{
$^s::
   SendInput, ^s
   Sleep 100
   Reload
return
}

;-------------------------------------
;  ;Teams
;  ; MICROSOFT TEAMS - Toggle Mute
;  ^#F8::
;  WinGet, winid, ID, A	; Save the current window ID
;  WinGet TID, ID,ahk_exe Teams.exe
;  ;MsgBox %winid%
;  if WinExist(eeting) ;Yes, every Teams meeting has that in the title bar - even if it's not visible to you
;  {
;    MsgBox %TID%
;  	WinActivate ahk_id %TID% ; Without any parameters this activates the previously retrieved window - in this case your meeting
;  	Sleep 2000
;    SendInput, ^+E   ; Teams' native Mute shortcut
;    WinActivate ahk_id %winid% ; Restore previous window focus
;  	return
;  }
;
