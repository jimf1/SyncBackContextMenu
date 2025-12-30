#include "Date.au3"
#include "DTC.au3"

Func getFileTimes ($filePath)
; Author: - Jim Fortune
; Date: 12/20/2025

; This function gets formatted times of the following dates for a file specifed
; Input:
;   filePath - String that is the file name of interest
; Output
;   4 Element array as follows
;		0 - Created date
;       1 - Modified dat3
;       2 - Date versioned by Syncback Pro
;		3 - File name but without timestamp (for the GUI to replace a file if needed)
;		4 - Unformatted date for the GUI sort
; If the file doesn't exist, a message box will be displayed
; If the file does exist, but a timestamp cannot be found, false is returned

	Local $iFileExists = FileExists($filePath)
    ; Display a message and abort if file doesn't exist
    If Not $iFileExists Then
		MsgBox(0, "File Not Found", "Cannot find " & $filePath & ", aborting")
		Exit
	EndIf

	;Get OS Create and Modified Times
	Local $sFileCreateDate = FileGetTime($filePath, 1, 1) ; Get Created Timestamp
	Local $sFileModDate = FileGetTime($filePath, 0, 1) ; Get Modified Timestamp

	;Format dates
;~ 	msgbox(0,0,$sFileCreateDate)

	Local $sFileCreateFormatDate = _Date_Time_Convert($sFileCreateDate, "yyyyMMddHHmmss", "MM/dd/yyyy h:mm TT")
	Local $sFileModFormatDate = _Date_Time_Convert($sFileModDate, "yyyyMMddHHmmss", "MM/dd/yyyy h:mm TT")

	;Get Time version than was made by Syncback
	; It's in the file name like my.document.251215120101.docx
	Local $sFileVersionDate = 0
	Local $timestampPos = 0
	$filenameElements = StringSplit($filePath, ".")
	for $j = 1 to $filenameElements[0]
		If StringLen($filenameElements[$j] = 12) And StringIsDigit($filenameElements[$j]) Then
			$sFileVersionDate = $fileNameElements[$j]
			$timestampPos = $j
			EndIf
		Next
	; The timestamp must be in either the last position of the file name or the one immediately prior
	If $timestampPos < ($filenameElements[0] - 1) Then
		$sFileVersionDate = 0
	EndIf

	If $sFileVersionDate = 0 Then
;~ 		return False
	EndIf

	; Format the version date
	Local $sFileVersionFormatDate = _Date_Time_Convert($sFileVersionDate, "yyMMddHHmmss", "yyyy/MM/dd HH:mm:ss")
	; The file version date is in UTC, let's make it a local Time
	Local $gmtinfo = _Date_Time_GetTimeZoneInformation()
	Local $gmtoffset = $gmtinfo[1] ;Add these minutes to arrive at UTC from local time
	$sFileVersionFormatDate = _DateAdd('n', -$gmtoffset, $sFileVersionFormatDate)
	$sFileVersionFormatDate = _Date_Time_Convert($sFileVersionFormatDate, "yyyy/MM/dd HH:mm:ss", "MM/dd/yyyy h:mm TT")

	; Return the file name without the timestamp
	Local $plainFileName
	for $j = 1 to $filenameElements[0]
		If $j <> $timestampPos Then ; Not at the timestamp, add this one
			$plainFileName &= $filenameElements[$j]
			if $j <> $filenameElements[0] Then ;Add a period unless we are at the end of the name
				$plainFileName &= "."
			EndIf
		EndIf
	Next

	;Make an array with the answer
	Local $ans[5]
	$ans[0] = $sFileCreateFormatDate
	$ans[1] = $sFileModFormatDate
	$ans[2] = $sFileVersionFormatDate
	$ans[3] = $plainFileName
	$ans[4] = $sFileModDate
	return $ans
EndFunc ;==>getFileTimes

;Test
;~ Local $dates[3]
;~ Local $versionedFileName = "D:\Temp\testfunc.251220161425.au3"
;~ ;Local $versionedFileName = "D:\Temp\testfunc.au3"
;~ ;Local $versionedFileName = "D:\Temp\testfunc.251220161425.copy.au3"

;~ $dates = getFileTimes ($versionedFileName)

;~ if $dates <> False Then
;~ 	ConsoleWrite("Calling proc" & @CRLF)
;~ 	ConsoleWrite("Input file name: " & @TAB & @TAB & $versionedFileName & @CRLF)
;~ 	ConsoleWrite("File name no timestamp: " & @TAB & $dates[3] & @CRLF)
;~ 	ConsoleWrite("Create Date: " & @TAB & @TAB & @TAB & $dates[0] & @CRLF)
;~ 	ConsoleWrite("Modified Date: " & @TAB & @TAB & @TAB & $dates[1] & @CRLF)
;~ 	ConsoleWrite("Versioned Date: " & @TAB & @TAB & $dates[2] & @CRLF)

;~ Else
;~ 	ConsoleWrite("Boo.. no timestamp found for " & $versionedFileName & @CRLF)
;~ EndIf
