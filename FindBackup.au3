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

#include "GetBackupDir.au3"


;  ***** Mainline  ******
; init
; **** Name of command in context menu *****
$context = "Find Backup"
$folders = True

If $CmdLine[0] = 0 Then
	; Called with no parameters, so registry entry doesn't exist. Let's put this program in the registry to run
	If @Compiled Then ; In an executable
		; Concatenate parms into a single string with a space in between, ensuring quotes for paths with spaces
		Local $allParams = '"' & $context & '" "' & $folders & '" "' & @AutoItExe & '"'
		ShellExecute("C:\Util\AutoIT\RegFixup.exe", $allParams)
	Else ; In a script
		$fullScript = @AutoitExe & " " & @ScriptFullPath
		RunWait ("C:\Program Files (x86)\AutoIt3\AutoIt3.exe D:\Documents\AutoIT\RegFixup.au3 " & '"' & $context & '"' & " " & $folders & " " & '"' & $fullScript & '"')
	EndIf
	Exit
EndIf

; Find the mirror
$mirror = GetBackupDir ($CmdLine[1]) ; Get backup dir
;Open new explorer window
Run("explorer.exe /select," & $mirror )