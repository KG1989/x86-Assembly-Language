TITLE Composite Numbers     (Composite.asm)

; Author: Kyle Garland
; Last Modified: 2/19/2019
; OSU email address: garlandk@oregonstate.edu
; Course number/section: CS 271-400 winter 2019
; Project Number: Program 4                Due Date: 2/17/2019
; Description: This program introduces us to procedures and displays composite numbers

INCLUDE Irvine32.inc

LOWER_LIM = 1
UPPER_LIM = 400

.data

intro1			BYTE	"Composite Numbers		Programmed by Kyle Garland" , 0
prompt1			BYTE	"Enter the numbers of composite numbers you would like to see, " , 0
prompt2			BYTE	"I'll accept orders for up to 400 composites. " , 0
enterNums		BYTE	"Enter the number of composites to display [1 .. 400]: " , 0
space			BYTE	" ", 0
errorMsg		BYTE	"Out of range. Try again. " , 0
byeMsg			BYTE	"Results certified by Kyle Garland. Goodbye. " , 0

userNum			DWORD	?
checkNum		DWORD	2
compositeNum	DWORD	0
totalNums		DWORD	0
perLine			DWORD	0

.code
main PROC

	call introduction
	call getUserData
	call showComposites
	call farewell

	exit	; exit to operating system
main ENDP

;----------------- introduction ---------------

introduction PROC
	
	mov		edx, OFFSET intro1
	call WriteString
	call crlf

	mov		edx, OFFSET prompt1
	call WriteString
	call crlf

	mov		edx, OFFSET prompt2
	call WriteString
	call crlf

	ret

introduction ENDP

;-------------- getUserData ----------------------

getUserData PROC

	mov		edx, OFFSET enterNums
	call WriteString
	call ReadInt
	mov		userNum, eax
	call validate

	ret

getUserData ENDP

validate PROC

	cmp eax, LOWER_LIM
	jl badInput

	cmp eax, UPPER_LIM
	jg badInput

	jmp goodInput

badInput:
	mov		edx, OFFSET errorMsg
	call WriteString
	call getUserData

goodInput:
	ret

validate ENDP


showComposites PROC
	
		mov eax, userNum

	compositeSearch:
		mov compositeNum, 0		
		call isComposite
		cmp compositeNum, 1		
		je print				
		inc checkNum			
		mov eax, totalNums
		cmp eax, userNum
		jl compositeSearch			
		jmp finished				

	print:
		mov eax, checkNum
		call WriteDec				
		mov edx, OFFSET space		
		call WriteString

		inc checkNum
		inc perLine
		cmp perLine, 10				
		je newLine
		jmp compositeSearch			

	newLine:
		call CrLf
		mov perLine, 0				
		jmp compositeSearch			

	finished:
		ret

showComposites ENDP

;---------------- isComposite ---------------------

isComposite PROC
	
	mov ecx, checkNum
	dec ecx							

	checkComposite:
		cmp ecx, 1					
		je finished					

		mov edx, 0					
		mov eax, checkNum		
		div ecx						
		cmp edx, 0					
		je found					
					
		loop checkComposite			

	found:
		mov compositeNum, 1		
		inc totalNums		

	finished:
	ret

isComposite ENDP

farewell PROC
	
	mov		edx, OFFSET byeMsg
	call WriteString
	call crlf

	ret
farewell ENDP

END main
