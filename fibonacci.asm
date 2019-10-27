TITLE Fibonacci Numbers    (fibonacci.asm)

; Author: Kyle Garland
; Last Modified: 1/26/2019
; OSU email address: garlandk@oregonstate.edu
; Course number/section: CS 271 Winter 2019
; Project Number: 2                Due Date: 1/27/2019
; Description: This program gets input from the user, validates their input, and then displays the results
;			   of the Fibonacci sequence up to the highets number they entered. This is sovled iteratively.

INCLUDE Irvine32.inc

LOWER_LIM = 1
UPPER_LIM = 46

.data

intro_1		BYTE	"Fibonacci Numbers" , 0 ; from example input
intro_2		BYTE	"Programmed by Kyle Garland" , 0 ; from example input
userPrompt	BYTE	"What is your name? " , 0 ;ask for users name
userName	BYTE	40	DUP(0)	; store users name entered by user
welcome		BYTE	"Greetings, " , 0

numPrompt	BYTE	"Enter the number of Fibonacci terms to be displayed." , 0
validPrompt	BYTE	"Give the number as an integer in the range of [1 .. 46]." , 0
getNum		BYTE	"How many Fibonacci terms do you want? " , 0
errorMsg	BYTE	"Number out of range. Enter number in the range of [1 .. 46]." , 0

counter		DWORD	?			; number entered from user goes here and will be stored in ecx for counter

spaces		BYTE	"     " , 0	; 5 spaces bebtween numbers
firstFib	DWORD	1			; 1st fib number is 1
secondFib	DWORD	1			; 2nd fib number is 1
fibNum		DWORD	?			; stores the current fib num
checkCrlf	DWORD	2			; variable to hold if we need a new line
; checkCrlf starts at 2 because when the user enters 3, we have already printed the 1st 2 values so we want
; them to line up correctly.

resultMsg	BYTE	"Results certified by Kyle Garland." , 0
byeMsg		BYTE	"Goodbye, " , 0



.code
main PROC

; Display the program title and the programmer's name
	mov		edx, OFFSET intro_1
	call WriteString
	call crlf

	mov		edx, OFFSET intro_2
	call WriteString
	call crlf

; Get the user's name and greet the user
	mov		edx, OFFSET userPrompt
	call WriteString
	mov		edx, OFFSET userName
	mov		ecx, 39
	call ReadString

	mov		edx, OFFSET welcome
	call WriteString
	mov		edx, OFFSET userName
	call WriteString
	call crlf

; Prompt user to enter the number of Fibonacci terms to be displayed in range of 1-46
	mov		edx, OFFSET numPrompt
	call WriteString
	call crlf

	mov		edx, OFFSET validPrompt
	call WriteString
	call crlf
	call crlf

	jmp		getInput			;jumps over error section

; This is basically just looping practice 
;sumLoop:
;	add		eax, ebx
;	inc		ebx
;	mov		fibNum, eax
;	call WriteDec
;	mov		edx, OFFSET spaces
;	call WriteString
;	LOOP	sumLoop

; This section displays the error message if numbers are out of range
error:
	mov		edx, OFFSET errorMsg
	call WriteString
	call crlf
; Get and validate the input (post-test (do-while) loop)

getInput:
	mov		edx, OFFSET getNum
	call WriteString
	call ReadInt					; automatically stored in eax
	mov		counter, eax			; move this to counter variable to be stored in ecx later

	cmp		eax, LOWER_LIM
	jb		error					; jump if below 1
	cmp		eax, UPPER_LIM
	ja		error					; jump if above 46

	mov		ecx, counter		; store loop counter into ecx

	jmp calculations
; Calculate Fibonacci numbers (Using MASM LOOP instruction) and display

; If user enters 1, we know the first fib num is 1 so we can just display that and end program
userEntered1:
	mov		eax, 1
	call WriteDec
	call crlf
	jmp quit


; if user enters 2, the first 2 fib nums are 1 so we can just print 1	1 and end program
userEntered2:
	mov		eax, 1
	call WriteDec
	mov		edx, OFFSET spaces
	call WriteString
	call WriteDec
	call crlf
	jmp quit

; first things first, first 2 numbers of fib sequence are 1, so check for those first
; if not 1 or 2, move into the loop calculation
calculations:
	cmp		eax, 1				;eax still holds user input
	je		userEntered1
	cmp		eax, 2
	je		userEntered2

; if neither 1 or 2 is entered, go into the main calc loop
;display first 2 fib numbers first
	mov		eax, 1
	call WriteDec
	mov		edx, OFFSET spaces
	call WriteString
	call WriteDec
	call WriteString

	sub		ecx, 2 ; ecx needs to be 2 less because we already printed the 1st 2 fib numbers.
				   ; hopefully this is cool, couldn't figure anything else out.
loopStart:
	mov		eax, firstFib		; 1 into eax
	mov		ebx, secondFib		; 1 into ebx
	add		eax, ebx			; sum these to get next fib num
	mov		fibNum, eax			; move into variable for fibNum
	
	call WriteDec
	mov		edx, OFFSET spaces
	call WriteString

	mov		firstFib, ebx	;update first fib with new value
	mov		secondFib, eax	;update second fib with new value
	
	inc		checkCrlf
	mov		ebp, checkCrlf
	cmp		ebp, 5
	je		newline
	jne		noNewline

newline:
	call crlf
	sub		checkCrlf, 5   ;reset back to orignal value so I can check if there are 5 values on the line

noNewline:
	loop loopStart

	call crlf

; parting message including user's name
quit:
	mov		edx, OFFSET resultMsg
	call WriteString
	call crlf
	mov		edx, OFFSET byeMsg
	call WriteString
	mov		edx, OFFSET userName
	call WriteString
	call crlf
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
