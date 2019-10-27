TITLE Integer Accumulator     (Program3.asm)

; Author: Kyle Garland
; Last Modified: 2/3/2019
; OSU email address: Garlandk@oregonstate.edu
; Course number/section: CS 271 Winter 2019
; Project Number: 3                 Due Date: 2/10/2019
; Description: This program repeatedly gets negative integers from the user, counts how many
;			   integers were entered, sums the integers, then averages the integers and
;			   displays to the screen

INCLUDE Irvine32.inc

LOWER_LIM = -100
UPPER_LIM = -1

.data

intro1			BYTE	"Welcome to the Integer Accumulator by Kyle Garland" , 0
userPrompt		BYTE	"What is your name? " , 0
username		BYTE	40	DUP(0)
greeting		BYTE	"Hello, " , 0
infoPrompt1		BYTE	"Please enter numbers in range [-100, -1]. " , 0
infoPrompt2		BYTE	"Enter a non-negative number when you are finished to see results. " , 0

getNum			BYTE	"Enter a number: " , 0
userNum			SDWORD	? ;this will be entered by the user
sum				SDWORD	0 ;sum starts at 0
numCount		DWORD	0 ;count starts at 0
average			DWORD	0 ;average

numInfo1		BYTE	"You entered " , 0
numInfo2		BYTE	" valid numbers. " , 0
sumInfo			BYTE	"The sum of your valid numbers is " , 0
roundInfo		BYTE	"The rounded average is " , 0
exitMsg			BYTE	"Thank you for playing the Integer Accumulator! It's been a pleasure to meet you, " , 0

.code
main PROC

; Display the program title and programmers name
	mov		edx, OFFSET intro1
	call WriteString
	call crlf
; Get the user's name and greet the user
	mov		edx, OFFSET userPrompt
	call WriteString
	mov		edx, OFFSET userName
	mov		ecx, 39
	call ReadString

	mov		edx, OFFSET greeting
	call WriteString
	mov		edx, OFFSET userName
	call WriteString
	call crlf
; Display the instructors to the user
	mov		edx, OFFSET infoPrompt1
	call WriteString
	call crlf

	mov		edx, OFFSET infoPrompt2
	call WriteString
	call crlf
; Repeatedly prompt the user to enter a number
; Validate user input and accumulate valid numbers into a final sum
	mov		ebx, 0
top:
	mov		edx, OFFSET getNum
	call WriteString
	call ReadInt
	cmp		eax, LOWER_LIM
	jl		top
	cmp		eax, UPPER_LIM
	jnl		endWhile

	add		ebx, eax
	mov		sum, ebx
	inc		numCount
	jmp		top
endWhile:
; Calculate the average and display the numbers
	mov		edx, OFFSET numInfo1
	call WriteString
	mov		eax, numCount
	call WriteDec
	mov		edx, OFFSET numInfo2
	call WriteString
	call crlf

	mov		edx, OFFSET sumInfo
	call WriteString
	mov		eax, sum
	call WriteInt
	call crlf
	;finally, print the average rounded number
	mov		eax, sum
	cdq
	mov		ebx, numCount
	idiv	ebx
	mov		average, eax

	mov		edx, OFFSET roundInfo
	call WriteString
	mov		eax, average
	call WriteInt
	call crlf


; Good-bye message
	mov		edx, OFFSET exitMsg
	call WriteString
	call crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
