TITLE Elementary Arithmetic     (Program1.asm)

; Author: Kyle Garland
; Last Modified: 1/12/2019 - 12:30 PM
; OSU email address: garlandk@oregonstate.edu
; Course number/section: CS 271 section 400 winter 2019
; Project Number: 1                Due Date: January 20th, 2019
; Description: This program introduces the programmer and then asks the user to enter 2 numbers.
;			   The program then performs some elementary arithmetic on the 2 numbers and displays them
;			   to the screen. There is also some extra credit options listed below:
;			   1. Loops until the user wants to quit.
;			   2. Validates the 2nd number to be less than the first. e.g. num1 = 10, num2 = 5
;			   3. displays the quotient as a floating point number instead of remainder notation. e.g. 9/5 = 1.8 instead of 1 R 4

INCLUDE Irvine32.inc

; (insert constant definitions here)
; No constant definitions in this program

.data
programTitle	BYTE	"Elementary Arithmetic		By Kyle J. Garland" , 0
intro_1			BYTE	"Enter two numbers and I will show you the " , 0
intro_2			BYTE	"sum, difference, product, quotient, and remainder. " , 0
prompt_1		BYTE	"Enter the first number: " , 0
prompt_2		BYTE	"Enter the second number: " , 0
byeMessage		BYTE	"Impressed? Bye!" , 0
EC1Message		BYTE	"**EC Program repeat. " , 0
againPrompt		BYTE	"Would you like to go again? Enter 'y' to go again or any other key to exit. " , 0

num1			DWORD	?	; first integer to be entered by the user
num2			DWORD	?	; second integer to be entered by the user
sum				DWORD	?	; sum of the 2 integers
diff			DWORD	?	; difference of the 2 integers
prod			DWORD	?	; product of the 2 integers
quotient		DWORD	?	; quotient of the 2 integers
remainder		DWORD	?	; remainder of the 2 integers

plus			WORD	2Bh ; ascii hex value for plus sign
minus			WORD	2Dh	; ascii hex value for minus sign
mult			WORD	2Ah	; ascii hex value for asterisk (multiplication)
divi			WORD	246	; ascii decimal value for division symbol
equals			WORD	3Dh ; ascii hex value for equals sign
rem				BYTE	" remainder " , 0

playAgain		BYTE	"y" , 0

.code
main PROC

start:
; Display name and program title to the screen
	mov		edx, OFFSET programTitle
	call WriteString
	call crlf
; Display instructions for the user
	mov		edx, OFFSET intro_1
	call WriteString
	mov		edx, OFFSET intro_2
	call WriteString
	call crlf
; Prompt the user to enter 2 integers
	mov		edx, OFFSET prompt_1
	call WriteString
	call ReadInt
	mov		num1, eax

	mov		edx, OFFSET prompt_2
	call WriteString
	call ReadInt
	mov		num2, eax
	call crlf
; Calculate sum, store in sum variable
	mov		eax, num1
	mov		ebx, num2
	add		eax, ebx
	mov		sum, eax

; Calculate difference, store in diff variable
	mov		eax, num1
	mov		ebx, num2
	sub		eax, ebx
	mov		diff, eax

; Calculate product, store in product variable
	mov		eax, num1
	mov		ebx, num2
	mul		ebx
	mov		prod, eax

; Calculate quotient and remainder, store in quotient and remainder variables
	mov		eax, num1
	mov		ebx, num2
	div		ebx
	mov		quotient, eax
	mov		remainder, edx ; automatically stored in edx

; Display the output arithmetic

; Output for sum
	mov		eax, num1
	call WriteDec
	mov		edx, OFFSET plus
	call WriteString
	mov		eax, num2
	call WriteDec
	mov		edx, OFFSET equals
	call WriteString
	mov		eax, sum
	call WriteDec
	call crlf

	; Output for difference
	mov		eax, num1
	call WriteDec
	mov		edx, OFFSET minus
	call WriteString
	mov		eax, num2
	call WriteDec
	mov		edx, OFFSET equals
	call WriteString
	mov		eax, diff
	call WriteInt			; used WriteInt here because I got garbage value when using WriteDec
	call crlf

	; Output for product
	mov		eax, num1
	call WriteDec
	mov		edx, OFFSET mult
	call WriteString
	mov		eax, num2
	call WriteDec
	mov		edx, OFFSET equals
	call WriteString
	mov		eax, prod
	call WriteDec
	call crlf

	; Output for quotient and remainder
	mov		eax, num1
	call WriteDec
	mov		edx, OFFSET divi
	call WriteString
	mov		eax, num2
	call WriteDec
	mov		edx, OFFSET equals
	call WriteString
	mov		eax, quotient
	call WriteDec
	mov		edx, OFFSET rem
	call WriteString
	mov		eax, remainder
	call WriteDec
	call crlf
	call crlf

	; Repeat program extra credit option
	mov		edx, OFFSET againPrompt
	call WriteString
	call crlf
	call ReadChar			; stored in al from the text
	
	mov		bl, playAgain
	cmp		al, bl			; compare what was entered into al form ReadChar to 'y'
	
	jne		quit			; if something else, go to end
	je		start			; if equal, go to start

quit: 
; Goodbye message
	mov		edx, OFFSET byeMessage
	call WriteString
	call crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
