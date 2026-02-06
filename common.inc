; ------------------------------------------------------------
; common.inc -- Shared definitions and prototypes
; ------------------------------------------------------------

; Windows API (still EXTRN because we never define them)
extrn GetStdHandle       : proc
extrn WriteConsoleA      : proc
extrn ExitProcess        : proc
extrn GetCommandLineW    : proc  ; Changed from A to W
extrn CommandLineToArgvW : proc

; Constants
STD_OUTPUT_HANDLE equ -11

; Procedures - Use EXTERNDEF for symbols defined in our project
externdef EasterDate    : proc
externdef Weekday       : proc
externdef AppendLiteral : proc
externdef AppendAscii   : proc
externdef WideToInt     : proc

; Data Tables
externdef MonthNameTable   : qword
externdef WeekdayNameTable : qword
externdef WeekdayOffsetTable : dword
