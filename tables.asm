; ------------------------------------------------------------
; tables.asm -- Static lookup tables for EasterDate and Weekday
; ------------------------------------------------------------

; We use PUBLIC here or let EXTERNDEF in common.inc handle it?
; If common.inc has EXTERNDEF, we don't strictly need PUBLIC, 
; but it's good practice. But to avoid any conflict with EXTERNDEF...
; Actually, EXTERNDEF does the job of PUBLIC.
; I will include common.inc here too, so the symbols match.

include common.inc

.data

; ------------------------------------------------------------
; Month names (index: 0 = March, 1 = April)
; ------------------------------------------------------------
MonthNameTable dq MarchStr, AprilStr

MarchStr    db "March",0
AprilStr    db "April",0


; ------------------------------------------------------------
; Weekday names (index: 0 = Sunday ... 6 = Saturday)
; ------------------------------------------------------------
WeekdayNameTable dq SunStr, MonStr, TueStr, WedStr, ThuStr, FriStr, SatStr

SunStr      db "Sunday",0
MonStr      db "Monday",0
TueStr      db "Tuesday",0
WedStr      db "Wednesday",0
ThuStr      db "Thursday",0
FriStr      db "Friday",0
SatStr      db "Saturday",0


; ------------------------------------------------------------
; Sakamoto weekday offset table (t[m-1])
; Used by weekday.asm
; ------------------------------------------------------------
WeekdayOffsetTable dd 0,3,2,5,0,3,5,1,4,6,2,4

end
