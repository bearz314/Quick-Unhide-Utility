;=======================================================================
;QUICK UNHIDE UTILITY
;Copyright (C) Wong (Bearz314 -- http://misc314.com)
;-----------------------------------------------------------------------
;Creates a GUI and prompts users to drag hidden files/folders
;to an edit box. With the press of a single button, all files/folders
;will be restored.
;MAIN FUNCTION: FileSetAttrib(FILE, "-RASH+N")
;=======================================================================

#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
$version = "1.0.1"
    Local $file, $btn, $msg

    GUICreate("Quick Unhide Utility by Wong", 320, 200, @DesktopWidth / 2 - 160, @DesktopHeight / 2 - 45, -1, 0x00000018); WS_EX_ACCEPTFILES
    GUICtrlCreateLabel("Drag all hidden files or folders into the box below.", 10, 5)
	$file = GUICtrlCreateEdit("", 10, 25, 300, 140, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN + $ES_OEMCONVERT)
;~ 	GUICtrlSetStyle(-1, $ES_MULTILINE)
    GUICtrlSetState(-1, $GUI_DROPACCEPTED)
;~ 	GUICtrlSetState(-1, $CBS_DISABLENOSCROLL)
;~ 	GUICtrlSetState(-1, $ES_OEMCONVERT)
	
    $btn = GUICtrlCreateButton("Ok", 20, 170, 60, 20)
	$cancelbtn = GUICtrlCreateButton("Exit", 100, 170, 60, 20)
	GUICtrlCreateLabel("Version: "&$version, 235, 173)

    GUISetState()

    $msg = 0
    While 1 ;$msg <> $GUI_EVENT_CLOSE
        $msg = GUIGetMsg()
        Select
            Case $msg = $btn
                ExitLoop
			Case $msg = $cancelbtn
                Exit
			Case $msg = $GUI_EVENT_CLOSE
                Exit
        EndSelect
    WEnd

;If press OK with empty edit box --> Exit
If GUICtrlRead($file) = "" Then Exit
;Read the edit box and split different lines into arrays
$read=StringSplit(GUICtrlRead($file), @CRLF) ;Split into arrays using @CRLF as delimiters
;For all the files/folders --> $read[0] is the total no. of arrays
For $i = 1 To $read[0]
	;Need to ignore blanks because @CRLF generates a lot of blank arrays
	If $read[$i] <> "" Then
		If Not FileSetAttrib($read[$i], "-RASH+N") Then
			MsgBox(4096,"Error", "Problem setting attributes for"&@CRLF&$read[$i])
		EndIf
	EndIf
;~ 	If Not FileSetAttrib($read[$i], "-R", 1) Then
;~ 		MsgBox(4096,"Error", "Problem setting attributes for"&@CRLF&$read[$i])
;~ 	EndIf
Next
MsgBox(64+262144, "Quick Unhide Utility by Wong", "Script has ended!"&@CRLF&"Program will now terminate.")
;~ MsgBox(4096, "drag drop file", )

