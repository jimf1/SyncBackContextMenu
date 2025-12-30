Func GetBackupDir ($sourcePath)
	$currentDir = $sourcePath

	; Find the ini file
	$i = StringInStr($currentDir,":") ; Is this a drive letter
	If $i = 0 Then ; This is a UNC
		$i = StringInStr($currentDir,"\",0,4)
	Else ; Was a drive letter, add \
		$i = $i + 1
	EndIf
	$drive = StringLeft($currentDir,$i)

	; Find mirror root definition in root of current Drive
	$inifile = FileOpen($drive & "MirrorRoot.ini",0)
	If $inifile = -1 Then ; Prompt the user for a mirror root and write to the file
		$mirrorRoot = FileSelectFolder("You don't have a definition for the backup root.  Please select a starting point for the backup","",4)
		$inifile = FileOpen("\MirrorRoot.ini",2)
		FileWrite($inifile,$mirrorRoot)
		FileClose($inifile)
	Else
		$mirrorRoot = FileReadLine($inifile)
		FileClose($inifile)
	EndIf

	;Mirror is same, except delete drive letter e.g. d: and replace with UNC of mirror root e.g. \\Anna\Mirror\Jim-Mirror\D-Drive
	$mirror = StringTrimLeft($currentDir, $i)

	;Concat the root with the file for the entire path
	$mirror = $mirrorRoot & "\" & $mirror
	return $mirror
MsgBox(64, "Mirror Directory", $mirror)
EndFunc
