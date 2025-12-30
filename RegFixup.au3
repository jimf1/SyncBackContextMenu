#RequireAdmin

If $CmdLine[0] = 3 Then
	RegFixUp($CmdLine[1], $CmdLine[2], $CmdLine[3])
Else

	MsgBox(0, "Parameter Help", "Need 3 parameters: " & @CRLF & "First is What shell command to run" & @CRLF & "Second is whether to include folders" _
			& "Third is the name of the calling script")
	EndIf

Func RegFixUp ($shellCommand, $includeFolder, $caller)
	; Fixup the registry entry when no parameters are passed.
	; This is when the program is invoked directly because the user wants to add or delete from the registry.
	; Parms are:
	;    shellCommand: What shell command is to show up in the context menu (e.g. Find Backup)
	;    includeFolder: Boolean.  Whether or not to show a context menu for folders
	;	 caller Name of calling script
;~ MsgBox(0, "RegFixup Parms", "Shell :" & $shellCommand & @CRLF & "Folder Include " & $includeFolder & @CRLF & "Caller: " & $caller)
	Global $iconFile = "C:\Program Files\2BrightSparks\SyncBackPro\SyncBackPro.exe" ; File name to generate icon (we'll use Syncback Pro)
	Global $sequence

	; Decide which sequence number to use
	If StringInStr($shellCommand, "Backup") Then
		$sequence = "01"
	ElseIf StringInStr($shellCommand, "Versions") Then
		$sequence = "02"
	EndIf

	$installation = RegRead("HKEY_CLASSES_ROOT\*\shell\" & $sequence & "-" & $shellCommand & "\command", "")
	If $installation <> "" Then
		; See if the user wants to deinstall
		$removal = MsgBox(4+32, "Mirror shell extension", "Would you like to remove the Mirror file and folder associations for " & $shellCommand & "?")
		If $removal = 6 Then
			$iRegDelete = RegDelete("HKEY_CLASSES_ROOT\*\shell\" & $sequence & "-" & $shellCommand)
			if ($iRegDelete And $includeFolder = 'True') Then
				$iRegDelete = RegDelete("HKEY_CLASSES_ROOT\Folder\shell\" & $sequence & "-" & $shellCommand)
			EndIf
			If ($iRegDelete) Then
				MsgBox (0+64, "Success", $shellCommand & " Registry Entries Deleted")
			EndIf
		EndIf
		Else
		; Registry entries not present.  See if the user wants to install
			$install = MsgBox(4+32, "Mirror shell extension", "Would you like to install the Mirror file and folder associations for " & $shellCommand & "?")
			If $install = 6 Then
				$iRegWrite = RegInstall("file", $shellCommand, $caller)
				If ($iRegWrite And $includeFolder = 'True') Then
					$iRegWrite = RegInstall("folder", $shellCommand, $caller)
				EndIf
				If ($iRegWrite) Then
					MsgBox(0+64, "Success!", "Registry has been fixed, please repeat " & $shellCommand & _
						" from the right-click menu of Windows Explorer to find the Backup File(s)")
				EndIf
			EndIf
	EndIf
EndFunc

Func RegInstall ($shellType, $command, $caller)
	; Install a registry entry
	; Parms:
	; $shellType: The registry key to operate on ("file" or "folder")
	; $command: The command (e.g. "Find Backup")
	; $sequence: The internal sequence for the registry to determine grouping (e.g. 01, 02)
	; Returns True if successful, false otherwise

	if ($shellType = "file") Then
		$shellPrefix = "HKEY_CLASSES_ROOT\*\shell\"
	ElseIf ($shellType = "folder") Then
		$shellPrefix = "HKEY_CLASSES_ROOT\Folder\shell\"
	Else
		MsgBox (0, "Error", "Shell type must be file or folder: " & $shellType & " in RegInstall")
		return False
	EndIf
; Write out values for parent key
; First, default name
	$sShellKey = $shellPrefix & $sequence & "-" & $command
	$sShellName = ""
	$sShellType = "REG_SZ"
	$sShellValue = $command
	$iRegWrite = RegWrite($sShellKey,$sShellName, $sShellType, $sShellValue)
; Second, icon
	$sShellName = "Icon"
	$sShellValue = $iconFile
	$iRegWrite = RegWrite($sShellKey,$sShellName, $sShellType, $sShellValue)
; Write out the values for the \command sub-key
	$sShellKey &= "\command"
	$sShellName = ""
	$sShellValue = $caller & ' "%1"'
	$iRegWrite = RegWrite($sShellKey,$sShellName, $sShellType, $sShellValue)
return $iRegWrite
EndFunc
