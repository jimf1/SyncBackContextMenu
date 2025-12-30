#NoTrayIcon

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.18.1
 Author:         Jim Fortune

 Script Function:
	Open the corresponding backup directory

Updates:
	12/2025
		1. 	Update script to be aware of whether or not to run as admin.
			This involves splitting the script to only run as admin if the registry is updated
			so the RegFixup.au3 script was added and its run requires admin.
		2.  Restructured so other programs could use and change slightly.
			Example is "Versions".  It only works on files and needs a $SBV$ directory.

#ce ----------------------------------------------------------------------------

; Notes
;   1. A file called "MirrorRoot.ini" exists in each drive in the directory root.  If not, user is prompted to make one.
;   2. The directory structure of the mirror below the mirror root is the same as the fully-qualified structure being mirrored.
;   3. If the program is run without parameters (as in the command line), it will either install or uninstall itself.
;      This first run should occur when the program is in its own directory (or in the system32 directory)

; A source input file was given, so this function will get the backup directory

#include "GetBackupDir.au3"
#include "File.au3"

;  ***** Mainline  ******
; init
; **** Name of command in context menu *****
$context = "Versions"
$folders = "False" ; Doesn't apply to folders

If $CmdLine[0] = 0 Then
	; Called with no parameters, so registry entry doesn't exist. Let's put this program in the registry to run
	If @Compiled Then ; In an executable
		; Concatenate parms into a single string with a space in between, ensuring quotes for paths with spaces
		Local $allParams = '"' & $context & '" "' & $folders & '" "' & @AutoItExe & '"'
		ShellExecute("C:\Util\AutoIT\RegFixup.exe", $allParams)
	Else ; In a script
		$fullScript = @AutoItExe & " " & @ScriptFullPath
		RunWait("C:\Program Files (x86)\AutoIt3\AutoIt3.exe D:\Documents\AutoIT\RegFixup.au3 " & '"' & $context & '"' & " " & $folders & " " & '"' & $fullScript & '"')
	EndIf
	Exit
EndIf

; Find the mirror
;~ msgbox(0, "mirror is", $CmdLine[1])

Local $sourcePath = $CmdLine[1]
;~ msgbox(0, "Orig sourcepath is", $sourcePath)
; Determine if source path is a backup directory with a version subdirectory
$sourcePath = StringRegExpReplace($sourcePath, '(^"|^''|"$|''$)', "") ; Get rid of leading/trailing quotes
Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
Local $aPathSplit = _PathSplit($sourcePath, $sDrive, $sDir, $sFileName, $sExtension)
Local $sourceDir = $sDrive & $sDir;
;~ msgbox(0, "sourcedir", $sourceDir)
If FileExists($sourceDir & "$SBV$\") Then ; Source path is a backup directory with versions, so use that
;~  MsgBox(0, "File Exists", $sourceDir & "$SBV$\")
	$mirror = $sourcePath
Else
	$mirror = GetBackupDir($sourcePath)  ; Get backup dir from Mirror.ini file
EndIf
;~ msgbox (0, "Mirror", $mirror)


; Find the versions directory and open the GUI
#include "RestoreVersions.au3"