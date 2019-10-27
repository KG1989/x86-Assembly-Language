TITLE Lowish-Level I/O design     (LowLevel.asm)

; Author: Kyle Garland
; Last Modified: 3/8/2019
; OSU email address: garlandk@oregonstate.edu
; Course number/section: CS 271-400 winter 2019
; Project Number: Program 6               Due Date: 3/17/2019
; Description: This project requires us to design and implement low-level I/O procedures and implement Macros

INCLUDE Irvine32.inc

displayString MACRO buffer
	push	edx
	mov		edx, OFFSET buffer
	call	WriteString
	pop		edx
ENDM

getString	MACRO	string, sizestr
	push	edx
	push	ecx
	mov		edx, string
	mov		ecx, sizestr  ; minus 1 to leave room for zero byte and also for readVal
	call	readString
	pop		ecx
	pop		edx
ENDM

.data

welcome1	BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures" , 0
welcome2	BYTE	"Written by: Kyle Garland" , 0
intro1		BYTE	"Please provide 10 unsigned decimal integers." , 0
intro2		BYTE	"Each number needs to be small enough to fit inside a 32 bit register." , 0
intro3		BYTE	"After you have finished inputting the raw numbers, I will display a list" , 0
intro4		BYTE	"of the integers, their sum, and their average value." , 0
errorMsg	BYTE	"ERROR: You didn't enter unsigned number or number was too big." , 0
displayNums	BYTE	"You entered the following numbers: " , 0
displaySum	BYTE	"The sum of the entered numbers is: " , 0

myNum		DWORD	?
;testMsg		BYTE	"Here I am." , 0
prompt1		BYTE	"Please enter a string: " , 0
errorPrompt	BYTE	"Please try again: " , 0
myStr		BYTE	255 DUP(?)
myArray		DWORD	10	DUP(0)
tempStr		BYTE	100	DUP(?)
sum			DWORD	?


.code
main PROC

	call	introduction
	mov		edi, OFFSET myArray
	mov		ecx, 10
fillArray:
	push	OFFSET myStr ;pass myStr by reference
	push	SIZEOF myStr
	call	readVal

	mov		eax, myNum
	mov		[edi], eax
	add		edi, 4
	loop	fillArray


	mov		ecx, 10						;10 nums in array
	mov		esi, OFFSET myArray
	mov		ebx, 0					; accumulator

;Display message
	displayString	displayNums
	call			crlf

;Calculate the sum | Print numbers to console
sumNums:
	mov		eax, [esi]
	add		ebx, eax				;add eax to the sum

;Push parameters eax and stringTemp | Call WriteVal
	push	eax
	push	OFFSET tempStr
	call	WriteVal
	add		esi, 4					;increment the array looper
	loop	sumNums

	call crlf

	; too late to finish the rest :(

	;push	OFFSET myArray
	;call	display




	;mov		eax, myNum
	;mov		[edi], eax
	;add		edi, 4
	;loop	fillArray


	;mov ecx, 4
;more:
	;mov		eax, [edi]
	;call WriteDec
	;call crlf
	;add		edi, 4
	;loop more



;test getString MACRO    IT WORKS!
;	displayString	prompt1
;	getString		myStr
;	displayString	myStr
;	call			crlf



	exit	; exit to operating system
main ENDP

introduction	PROC

	push			ebp
	mov				ebp, esp

	displayString	welcome1
	call			crlf
	displayString	welcome2
	call			crlf
	call			crlf
	displayString	intro1
	call			crlf
	displayString	intro2
	call			crlf
	displayString	intro3
	call			crlf
	displayString	intro4
	call			crlf
	call			crlf

	pop ebp
	ret

introduction	ENDP

readVal		PROC

	push			ebp
	mov				ebp, esp    ;stack frame boiiiii
	pushad			;save registers
	;following algorithm from lectures
	;get myStr from stack
	displayString	prompt1
	getString		[ebp+12], [ebp+8] ;string, sizeof string
	mov				esi, [ebp+12]
	mov				ebx, 10 ;for multiplying
	mov				eax, 0 ;clear eax
	mov				ecx, 0
	;string into esi
loadChar:
	lodsb			; loads char by char into eax
	;call			WriteChar  test to see if lodsb works correctly
	cmp				eax, 0		; check for end of string
	je				finished
	;check for number
	cmp				eax, 48
	jl				badInput
	cmp				eax, 57
	jg				badInput
	; go to goodInput label if number
	jmp				goodInput

badInput:
	displayString	errorMsg
	call crlf
	displayString	errorPrompt
	getString		[ebp+12], [ebp+8]
	jmp				loadChar

	;do the conversion here
goodInput:
	;displayString	testMsg			debugging
	sub				eax, 48			; last part of equation
	xchg			eax, ecx		;move ecx to eax to setup multiplication
	mul				ebx
	add				eax, ecx		; add input back to eax
	xchg			ecx, eax		; swap so ecx accumulates valyue
	jmp				loadChar
	

finished:
	;displayString	testMsg			debugging
	mov				eax, ecx		;I did this so call writedec to check if it worked
	;call WriteDec					test
	mov				myNum, eax

	popad							;return registers
	pop				ebp
	ret				8

readVal		ENDP

;WiteVal PROC

writeVal PROC
	push	ebp
	mov		ebp, esp


;Set for looping through the integer
	mov		eax, [ebp+12]	;move integer to convert to string to eax
	mov		edi, [ebp+8]	;move @address to edi to store string
	mov		ebx, 10
	push	0

loadNum:
	mov		edx, 0
	div		ebx
	add		edx, 48
	push	edx				;push next digit onto stack

;Check if at end
	cmp		eax, 0
	jne		loadNum

;Pop numbers off the stack
PopLabel:
	pop		[edi]
	mov		eax, [edi]
	inc		edi
	cmp		eax, 0				;check if the end
	jne		PopLabel

;Write as string using macro
	mov				edx, [ebp+8]
	displayString	OFFSET tempStr
	mov				al, 44
	call WriteChar
	mov				al, 32
	call WriteChar

	pop ebp
	ret 8
writeVal ENDP

; This was for debugging the original array, to make sure I loaded values correctly 
display		PROC
	
	push	ebp
	mov		ebp, esp

	mov		ecx, 3
	mov		edi, [ebp+8]

top:
	mov		eax, [edi]
	call WriteDec
	mov		al, 32
	call WriteChar
	add		edi, 4
	loop top


	ret 4

display		ENDP

END main
