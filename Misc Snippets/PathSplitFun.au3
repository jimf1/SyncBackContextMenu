#include "file.au3"
$fullPath = '"\\CAVU\Backup-Drive\Backups\Jim\D-Drive\Documents\AutoIT\$SBV$\junk.txt"'
$fullPath = StringRegExpReplace($fullPath, '(^"|^''|"$|''$)', "") ; Get rid of leading/trailing quotes
Local $sDrive, $sDir, $sfileName, $sExtension
_PathSplit($fullPath, $sDrive, $sDir, $sfileName, $sExtension)
ConsoleWrite ("Full path is: " & $fullPath & @CRLF)
ConsoleWrite ("sDrive is: " & $sDrive & @CRLF)
ConsoleWrite ("sDir is: " & $sDir & @CRLF)
ConsoleWrite ("sFileName is: " & $sfileName & @CRLF)
ConsoleWrite ("sExtension is: " & $sExtension & @CRLF)
