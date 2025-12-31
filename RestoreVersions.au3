#include <Array.au3>
#include <File.au3>
#include <FileInfo.au3>
#include <FileConstants.au3>

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>

; Populate the GUI list box with file names and dates from the following directories
; First, the given backup directory
; Next, any versions that may be present in the $SBV$ subdirectory for this file

; $mirror is passed in but we need to consider the name of the version directory
Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
Local $sVerDir = "$SBV$\"
Local $aPathSplit = _PathSplit($mirror, $sDrive, $sDir, $sFileName, $sExtension)
$sInFilePath = $sDrive & $sDir & $sVerDir ; Add the trailing $SBV$ folder as the versions directory like "D:\Temp\TestData\$SBV$\"
$sInFileName = $sFileName & $sExtension ; File name to find


#Region ### START Koda GUI section ### Form=
$Form1_2 = GUICreate("Restore Versions", 1200, 337, -1, -1)
;~ $FileList = GUICtrlCreateList("", 23, 72, 1145, 210)
Local $FileList = GUICtrlCreateListView("Modified Date | Created Date | Versioned Date | Version File Name | Raw Mod Date", 23, 72, 1145, 210) ; **** Changed
_GUICtrlListView_SetColumnWidth($FileList, 0, 150)				; **** Added
_GUICtrlListView_SetColumnWidth($FileList, 1, 150)				; **** Added
_GUICtrlListView_SetColumnWidth($FileList, 2, 150)				; **** Added
_GUICtrlListView_SetColumnWidth($FileList, 3, 800)				; **** Added
_GUICtrlListView_SetColumnWidth($FileList, 4, 0)				; **** Added
;Alternate some colors											; **** Added
; Set the background color for the main ListView control (odd rows)
GUICtrlSetBkColor($FileList, 0xE5F4D4) ; Really light green		; **** Changed
; Enable the alternate coloring flag							; **** Added
GUICtrlSetBkColor($FileList, $GUI_BKCOLOR_LV_ALTERNATE)			; **** Added

GUICtrlSetData(-1, "")
GUICtrlSetFont(-1, 11, 400, 0, "Segoe UI Semibold")
GUICtrlSetColor(-1, 0x000000)
$bSelect = GUICtrlCreateButton("Restore This Version", 528, 304, 147, 25)
GUICtrlSetFont(-1, 10, 800, 0, "Segoe UI Variable Display")
$sLabelMsg = "Versions of: " & $sInFileName                     ; **** Added
$Label1 = GUICtrlCreateLabel($sLabelMsg, 23, 8, 1145, 24)    	; **** Changed
GUICtrlSetFont(-1, 12, 800, 0, "Segoe UI Variable Text")
GUICtrlSetColor(-1, 0x0C3500)
$Label2 = GUICtrlCreateLabel("Choose a version to restore", 23, 40, 448, 20)
GUICtrlSetFont(-1, 12, 400, 0, "Segoe UI Variable Display")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Func InsertListViewItem ($sFilePath)
	; Take in a file name as path and insert into list view
	$dates = getFileTimes($sFilePath)  ; Get an array of dates for the file
	$sColsDelimited = $dates[1] & "|" & $dates[0] & "|" & $dates[2] & "|" & $sFilePath & "|" & $dates[4]
	$listState = GUICtrlCreateListViewItem($sColsDelimited, $FileList)
	GUICtrlSetBkColor(-1, 0xBCE292) ; Light (but darker) green
EndFunc

#BCE292


;~ Get files avaiable to version and populate list view
; First, get the file that was passed in originally
InsertListViewItem($mirror)

; Now get the files in the version directory
Local $aFiles = _FileListToArray($sInFilePath, $sFileName & ".*"& $sExtension, $FLTA_FILES)
;~ _ArrayDisplay($aFiles)
If IsArray($aFiles) Then
	; Loop through the array, get relevant dates, populate GUI list
	For $i = 1 To $aFiles[0]
		InsertListViewItem($sInFilePath & $aFiles[$i])
	Next
EndIf
$bSortSense = True ; Sort Descending
_GUICtrlListView_SimpleSort($FileList, $bSortSense, 4, False)
_GUICtrlListView_SetColumnWidth($FileList, 4, 0)				; Hide raw modification date
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $bSelect
			$rowSelected = GUICtrlRead(GUICtrlRead($FileList))
			if $rowSelected = 0 Then ; Nothing picked
				MsgBox(0+16, "Pick a row, any row", "Row must be selected first")
				ContinueCase
			EndIf

			$sFileToRestore = StringSplit($rowSelected, "|")[4]

			; Save dialog, default to originial file name and put it on the desktop
			$sRestoreFile = FileSaveDialog("Save Version As", @DesktopDir, "|All Files (*.*)", 0, $sInFileName)
			If Not @error Then
				if FileExists($sRestoreFile) Then
					$idOverwrite = MsgBox (4+48, "File Exists", $sRestoreFile & " already exists. Overwrite?")
					if $idOverwrite = $IDNO Then
						MsgBox(0+64, "Save aborted", $sRestoreFile & " discarded")
						Exit
					EndIf
				EndIf
;~ 				MsgBox (0, "Trying to copy", $sFileToRestore & "to" & @CRLF & $sRestoreFile)
				$sFileCopyStatus = FileCopy($sFileToRestore, $sRestoreFile, $FC_OVERWRITE)
				if $sFileCopyStatus = 0 Then
					MsgBox(0, "File Save Failed", "Error is: " & @error)
				EndIf
				Exit
			Else ; User canceled
				; No logic, just leave select window open
			EndIf
	EndSwitch
WEnd
