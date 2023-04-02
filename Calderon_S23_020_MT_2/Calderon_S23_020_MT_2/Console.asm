; Module:		Console.asm
; Author:		Justin Calderon
; Date:		March 30, 2023	
; Purpose:	Demonstrate the ability to create a Visual Studio console project that supports assembly language.
;			Demonstrate the ability to follow specific programming specifications.
;			Demonstrate the ability to use the hexadecimal numbering system.
;			Demonstrate the ability to create and use a procedure.
;			Demonstrate the ability to call library procedures.
;			Demonstrate the ability to understand and follow library documentation.	
;
;
INCLUDE C:\Irvine\Irvine32.inc				; include library
;
; <DATA SEGMENT>
;.model flat, STDCALL
.data
; <VARIABLES>
;
	randVal	dd ?							; for random generated value
	randCol	dd ?							; for random color generated value (0-15)
	CHAR_MIN	equ 21h						; min char value (21h)
	CHAR_MAX	equ 7Fh						; max char value (7Fh)
	ROW_COUNT equ 24						; row count (24)
;
; <CODE SEGMENT>
.code

;;;;;;;;;;;;;;;;;;;
; MAIN
;;;;;;;;;;;;;;;;;;;
main PROC
;
	call		Randomize						; initialize random seed
	mov		ebx, 0						; counter to compare ROW_COUNT
	mov		ecx, 119						; initialize ecx counter to 119. Max amt of chars printed per line

LOOP1:									; Control loop, decrement ECX with each loop, corresponding to max chars displayed.
										; When counter reaches 0, jump and create newline. Loop until max chars is reached.

	call		generateRandomChar				; generate random char
	cmp		ecx, 0						; compare ECX to 0
	jz		NEWLINE_LOOP					; if zero? jump to NEWLINE
	loop		LOOP1						; back to LOOP1

NEWLINE_LOOP:								; create newline
	call		WAIT_250						; delay 250ms
	call		Crlf							; newline
	cmp		ebx, ROW_COUNT					; compare EBX counter to max row count
	inc		ebx							; increment EBX
	mov		ecx, 119						; restore ECX counter back to 119 characters
	je		NEWLINE_END					; if EBX equals 25, jump to NEWLINE_END
	jb		LOOP1						; if below 25 ROW COUNT, jump to LOOP1 and generate new line of random characters
	
NEWLINE_END:								; end of NEWLINE
	mov		eax, lightgray					; set register to value of light gray
	call		SetTextColor					; set color back to light gray after program terminates

;
ENDPROG:									; end of program
	call		Crlf							; blank line after end of program
	call		Crlf							; 

	ret									; return to console
main ENDP
;
;;;;;;;;;;;;;;;;;;;
; end main
;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;
; PROCEDURES
;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;						
; generateRandomChar					; Generate random char between 21h and 7Fh
;;;;;;;;;;;;;;;;;;;
generateRandomChar	proc					; start of procedure
	pushad							; save registers

	call		RandomRange				; Generate random char between 21h and 7Fh+
	and		al, 7Fh
	add		al, 21h
	call		CHANGE_TXTCOLOR
	call		WriteChar
	call		WAIT_100

	popad							; return registers
	ret								; return to call procedure
generateRandomChar	endp

;;;;;;;;;;;;;;;;;;;
; CHANGE_TXTCOLOR						; Change color of text
;;;;;;;;;;;;;;;;;;;
CHANGE_TXTCOLOR proc
	pushad

	mov		eax, 16
	call		RandomRange
	mov		randCol, eax
	call		SetTextColor

	popad
	ret
CHANGE_TXTCOLOR endp

;;;;;;;;;;;;;;;;;;;
; WAIT_100							; Delay 100ms
;;;;;;;;;;;;;;;;;;;
WAIT_100	proc
	pushad

	mov		eax, 100
	call		Delay

	popad
	ret
WAIT_100	endp

;;;;;;;;;;;;;;;;;;;
; WAIT_250							; Delay 250ms
;;;;;;;;;;;;;;;;;;;
WAIT_250	proc
	pushad

	mov		eax, 250
	call		Delay

	popad
	ret
WAIT_250	endp
;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;
;
END main

