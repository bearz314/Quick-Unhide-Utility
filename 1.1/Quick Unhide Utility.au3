;=======================================================================
;~ QUICK UNHIDE UTILITY
;-----------------------------------------------------------------------
;
;~ Creates a GUI and prompts users to drag hidden files/folders
;~ to an edit box. With the press of a single button, all files/folders
;~ will be restored.
;
;~ MAIN FUNCTION: FileSetAttrib(FILE, "-RASH+N")
;
;-----------------------------------------------------------------------

;~ MIT License

;~ Copyright (c) 2018 Bearz314 - http://www.misc314.com/

;~ Permission is hereby granted, free of charge, to any person obtaining a copy
;~ of this software and associated documentation files (the "Software"), to deal
;~ in the Software without restriction, including without limitation the rights
;~ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;~ copies of the Software, and to permit persons to whom the Software is
;~ furnished to do so, subject to the following conditions:

;~ The above copyright notice and this permission notice shall be included in all
;~ copies or substantial portions of the Software.

;~ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;~ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;~ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;~ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;~ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;~ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;~ SOFTWARE.

;=======================================================================
#pragma compile(UPX, False)
#pragma compile(FileDescription, myProg - a description of the application)
#pragma compile(ProductName, Quick Unhide Utility)
#pragma compile(ProductVersion, 1.1)
#pragma compile(LegalCopyright, © 2018 Bearz314)
#pragma compile(CompanyName, 'Misc314')
#NoTrayIcon

; include necessary files
#include <ButtonConstants.au3> 	; for $BS_ICON
#include <EditConstants.au3> 	; for various GUI Edit options
#include <GUIConstantsEx.au3> 	; for $GUI_DROPACCEPTED
#include <WindowsConstants.au3> ; for $WS_EX_ACCEPTFILES

; unpack icon file
FileInstall("icons.dll", @ScriptDir&"\icons.dll")

; variables
$version = "1.1"
Local $file, $btn_go, $btn_reveal, $btn_conceal, $msg

; create main GUI window
GUICreate("Quick Unhide Utility", 320, 200, @DesktopWidth / 2 - 160, @DesktopHeight / 2 - 45, -1, $WS_EX_ACCEPTFILES)

; create instructions and drag-drop box
GUICtrlCreateLabel("Drag all hidden files or folders into the box below.", 10, 5)
$file = GUICtrlCreateEdit("", 10, 25, 300, 140, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN + $ES_OEMCONVERT)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)

; buttons

$btn_go = GUICtrlCreateButton("Unhide!", 20, 170, 60, 20)
GUICtrlSetTip(-1, "Your files/folders will be set with these attributes:"&@CRLF&"- READONLY"&@CRLF&"-ARCHIVE"&@CRLF&"-SYSTEM"&@CRLF&"-HIDDEN"&@CRLF&"+NORMAL", "Unhide files/folders")

$btn_reveal = GUICtrlCreateButton("Show", 160, 170, 20, 20, $BS_ICON)
GUICtrlSetImage(-1, "icons.dll", 1, 0)
GUICtrlSetTip(-1, "If you cannot drag hidden files because"&@CRLF&"you cannot see them, click this.", "Display hidden files in windows")

$btn_conceal = GUICtrlCreateButton("Hide", 190, 170, 20, 20, $BS_ICON)
GUICtrlSetImage(-1, "icons.dll", 2, 0)
GUICtrlSetTip(-1, "If you do not like hidden files"&@CRLF&"displayed, click this.", "Conceal hidden files in windows")


GUICtrlCreateLabel("Version: "&$version, 235, 173)

GUISetState()

; wait for user action
While 1
   $msg = GUIGetMsg()
   Select
	  ; if user closed window
	  Case $msg = $GUI_EVENT_CLOSE
		 Exit

	  ; if user clicked unhide button
	  Case $msg = $btn_go
		 If Not GUICtrlRead($file) = "" Then
			ExitLoop
		 EndIf

	  ; if user clicked reveal hidden files btn
	  Case $msg = $btn_reveal
		 ; Note: If run with admin priviledges, changes admin's HKCU instead.
		 RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", "REG_DWORD", "1")
		 RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowSuperHidden", "REG_DWORD", "1")
		 If @error Then
			MsgBox(16, "Sorry", "There seems to be an issue!"&@CRLF&"[Dismissing in 5 sec.]",5)
		 Else
			MsgBox(64, "Display hidden files", "Remember to refresh (F5) your window!"&@CRLF&"[Dismissing in 5 sec.]",5)
		 EndIf

	  ; if user clicked conceal hidden files btn
	  Case $msg = $btn_conceal
		 RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", "REG_DWORD", "2")
		 RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowSuperHidden", "REG_DWORD", "0")
		 If @error Then
			MsgBox(16, "Sorry", "There seems to be an issue!"&@CRLF&"[Dismissing in 5 sec.]",5)
		 Else
			MsgBox(64, "Conceal hidden files", "Remember to refresh (F5) your window!"&@CRLF&"[Dismissing in 5 sec.]",5)
		 EndIf
   EndSelect
WEnd

; User has pressed the Unhide button

; read edit box. Split lines into array using @CRLF as delimiters
$read = StringSplit(GUICtrlRead($file), @CRLF)

;For all the files/folders --> $read[0] is the total no. of arrays
For $i = 1 To $read[0]

   ;Need to ignore blanks because @CRLF generates a lot of blank array elements
   If $read[$i] <> "" Then

	  If Not FileSetAttrib($read[$i], "-RASH+N") Then
		 MsgBox(4096,"Error", "Problem setting attributes for"&@CRLF&$read[$i])
	  EndIf

   EndIf

 Next

MsgBox(64+262144, "Quick Unhide Utility", "Thanks for using Quick Unhide Utility!"&@CRLF&"Program has finished and will now exit.")
