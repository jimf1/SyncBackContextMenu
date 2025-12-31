#include "DTC.au3"

Global $sIn_Date, $sOut_Date

; Basic format
;~ $sIn_Date = "20251228121458"
;~ $sOut_Date = _Date_Time_Convert($sIn_Date, "yyyyMMddHHmmss", "MM/dd/yy h:mm TT")
;~ MsgBox(0, "DTC Conversion", $sIn_Date & @CRLF & $sOut_Date)

;~ $sIn_Date = "20251228121458"
;~ $sOut_Date = _Date_Time_Convert($sIn_Date, "yyyyMMddHHmmss", "yyyy/MM/dd HH:mm:ss")
;~ MsgBox(0, "DTC Conversion", $sIn_Date & @CRLF & $sOut_Date)

;~ $sIn_Date = "2025/12/28 12:14:58"
;~ $sOut_Date = _Date_Time_Convert($sIn_Date, "yyyy/MM/dd HH:mm:ss", "yyyyMMddHHmmss" )
;~ MsgBox(0, "DTC Conversion", $sIn_Date & @CRLF & $sOut_Date)

$sIn_Date = "2025/12/28 14:14:58"
$sOut_Date = _Date_Time_Convert($sIn_Date, "yyyy/MM/dd HH:mm:ss", "MM/dd/yyyy h:mm TT" )
MsgBox(0, "DTC Conversion", $sIn_Date & @CRLF & $sOut_Date)