﻿/********************************************************************************

Hotkeys:
  Win-S: Open Snipping Tool
  Win-Shift-D: Open My Documents
  Win-J: Open Downloads
  Win-J: Open Downloads


Modifiers:
  ^ : Ctrl
  ! : Alt
  + : Shift
  # : Win

Docs:
  https://autohotkey.com/docs/KeyList.htm
  https://autohotkey.com/docs/Hotkeys.htm


*/

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode 1
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;===============================================================================
; INCLUDES
;

#Include %A_ScriptDir%\Hotstrings.ahk
#Include %A_ScriptDir%\HTMLHotstrings.ahk
#Include %A_ScriptDir%\ExplorerPathLib.ahk


;===============================================================================
; SHORTCUTS
;

#S:: Run, "C:\WINDOWS\system32\SnippingTool.exe"
#D:: Run, %A_MyDocuments%
#J:: Run, "C:\Users\Ethan\Downloads"
#N:: Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
+#N:: Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --incognito
#C:: Run, "C:\Users\Ethan\Desktop\Calendar.lnk"

#K:: Run, % "cmd /K @cd " . Explorer_GetPath() . " && cmd"
#B:: Run, "C:\Users\Ethan\Desktop\Ubuntu.lnk"

;==SUBLIME==
; Open selected file or folder in new window
#T::
#Insert::
	Run, % "subl.exe -n " . Explorer_GetSelectedOrPath()
return
; Add selected file to existing window
+#T::
#+Insert::
	Run, % "subl.exe " . Explorer_GetSelected()
return
; Create new window
^#T::
#^Insert::
	Run, % "subl.exe -n"
return

;==MEDIA==
#F7::
Launch_Media::
	RunSingleInstance("C:\Users\Ethan\AppData\Roaming\Spotify\Spotify.exe", "ahk_exe Spotify.exe")
return


;===============================================================================
; KEY REMAPPINGS
;

;==MEDIA KEYS==
$F1:: Send, {Volume_Mute}
$#F1:: Send, {F1}
; #F10:: Send, {Media_Prev}
; #F11:: Send, {Media_Play_Pause}
; #F12:: Send, {Media_Next}


;==WINDOWS==
; Disable Win-M (Show desktop)
#M:: return

; Shift-Win-Up to Maximize
+#Up:: WinMaximize, A

; Shift-Win-Down to Minimize
+#Down:: WinMinimize, A


;===============================================================================
; UTILITIES
;

;==ALT CLIPBOARD==
^!C::
	tempClipboard := clipboardAll
	clipboard := altClipboard
	altClipboard := tempClipboard
	ShowToolTip("Clipboard Swapped")
return

;==CLEAR CLIPBOARDS==
^!#C::
	altClipboard =
	clipboard =
	ShowToolTip("Clipboards Cleared")
return

;==AUTOCLICK==
#MaxThreadsPerHotkey 2

!F7::AutoClickHotkey("Auto Click", "AutoClick", 100)
!+F7::AutoClickHotkey("Fast Auto Click", "AutoClick", 1)
^!F7::AutoClickHotkey("Slow Auto Click", "AutoClick", 300)
^!+F7::AutoClickHotkey("Auto Right Click", "AutoClickRight", 100)

#MaxThreadsPerHotkey 1


;==Ctrl-Alt-PgUp to show On-Screen Colemak==*
^!PgUp:: Run, "On-Screen Colemak.ahk"


;===============================================================================
; APPLICATION SPECIFIC
;


;===============================================================================
; CHROME
;
#IfWinActive ahk_exe chrome.exe

;==Disable close all==
^+Q:: return


;===============================================================================
; WINDOWS EXPLORER
;
#IfWinActive, ahk_class CabinetWClass

;==Middle mouse for Alt-Up (move up one level)==
~MButton:: Send !{Up} 

;==Always Shift-RightClick==
RButton::
   SendInput, {Shift down}{RButton down}
   KeyWait, RButton
   SendInput, {RButton up}{Shift up}
return


#IfWinActive


;===============================================================================
; UTILITY FUNCTIONS
;

RunAndFocus(Command, WinSelector) {
	Run, %Command%

	WinWait, %WinSelector%
	WinActivate
}

RunSingleInstance(Command, WinSelector, DetectHidden:="Off") {
	DetectHiddenWindows, %DetectHidden%
	if WinExist(WinSelector) {
		WinActivate
	} else {
		RunAndFocus(Command, WinSelector)
	}
}


ShowToolTip(Text, Duration:=3000) {
	ToolTip, %Text%
	SetTimer, RemoveToolTip, %Duration%
}

RemoveToolTip:
	SetTimer,, Off
	ToolTip
return


AutoClickHotkey(Name, ClickType, Delay) {
	global autoClick
	if autoClick {
		ShowToolTip("Auto Click Off")
		autoClick := false
	} else {
		ShowToolTip(Name . " On")
		autoClick := true
		SetTimer, %ClickType%, %Delay%
	}
}

AutoClick:
	Click
	if not autoClick {
		SetTimer,, Off
	}
return

AutoClickRight:
	Click right
	if not autoClick {
		SetTimer,, Off
	}
return


;==ABORT==
; !F12:: pause, toggle

;==Anti-Anti-Idle==
; moveMouseTimerOn = false;
; !F9::
; 	if moveMouseTimerOn {
; 		SetTimer, MoveMouse, Off
; 		ShowToolTip("MoveMouse timer off.")
; 	} else {
; 		SetTimer, MoveMouse, 1000 ; Run MoveMouse every 1 second
; 		ShowToolTip("MoveMouse timer on.")
; 	}
; 	moveMouseTimerOn := !moveMouseTimerOn
; return 

; MoveMouse:
;     MouseMove, 2, 0, 2, R  ; Move the mouse two pixels to the right
;     MouseMove, -2, 0, 2, R ; Move the mouse back two pixels
; return

;==TILDE FOR BACKSPACE==
; $`:: Backspace
; $+`:: send {~}
; $!`:: send ``
