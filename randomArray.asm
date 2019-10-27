TITLE Random numbers, array's, sorting     (randomArray.asm)

; Author: Kyle Garland
; Last Modified: 2/23/2019
; OSU email address: garlandk@oregonstate.edu
; Course number/section: CS 271-400 winter 2019
; Project Number: 5                Due Date: 3/3/2019
; Description: This program asks for input from the user between 10 and 200 (inclusive)
;			   then the program asks to for what range to generate random numbers from between 100 and 999 (inclusive)
;			   and displays however many random numbers the user decided between 100-999
;			   The program then sorts from high to low, calculates the median, and displays the median and numbers after sorting


INCLUDE Irvine32.inc

MIN = 10	;minimum for amount of nums displayed
MAX = 200	;maximum for amount of nums displayed
LO = 100	;minimum for randon number generator range
HI = 999	;maximum for randon number generator range

.data

randomArray		DWORD	MAX	DUP(?)	;max size of array is 200 if someone chooses to display 200 nums
request			DWORD	?			;amount of nums requested by user
welcome			BYTE	"Sorting Random Integers			Programmed by Kyle Garland" , 0
intro1			BYTE	"This program generates random numbers in range [100 .. 999], " , 0
intro2			BYTE	"displays the original list, sorts the list, and calculates the " , 0
intro3			BYTE	"median value. Finally, it displays the list sorted in descending order. " , 0

prompt1			BYTE	"How many numbers should be generated? [10 .. 200]: " , 0
errorMsg		BYTE	"Invalid input, try again. " , 0

displayUnsorted	BYTE	"The unsorted random numbers: " , 0
displayMedian	BYTE	"The median is " , 0
displaySorted	BYTE	"The sorted list: " , 0
byeMsg			BYTE	"Hope you enjoyed the program! See ya later. " , 0

.code
main PROC
	;random num generator called once
	call	Randomize

	;for intro
	push	OFFSET welcome ;pass strings by reference
	push	OFFSET intro1
	push	OFFSET intro2
	push	OFFSET intro3
	call	intro

	;for get data
	push	OFFSET request ;pass request by reference
	push	OFFSET prompt1	;pass strings by reference
	push	OFFSET errorMsg
	call	getData

	;for filling array with random numbers
	push	OFFSET randomArray ; pass array by reference
	push	request				; pass request by value
	call	fillArray

	;for displaying unsorted
	push	OFFSET	randomArray ;pass array by reference
	push	request				; pass request by value
	push	OFFSET displayUnsorted
	call	display

	;for sorting array
	push	OFFSET randomArray
	push	request
	call	sort

	;for calculating and displaying median
	push	OFFSET randomArray
	push	request
	push	OFFSET displayMedian
	call	median
	
	;for displaying sorted
	push	OFFSET	randomArray ;pass array by reference
	push	request				; pass request by value
	push	OFFSET displaySorted
	call	display

	mov		edx, OFFSET byeMsg	;didn't pass on stack cus didn't see the point to do all that for simple bye message
	call WriteString
	call crlf
	

	exit	; exit to operating system
main ENDP

; ************************** Intro *****************************
; Procedure to introduce programmer and instruct the user what to do
; receives: global variables passed by reference
; returns: None
; preconditions: None
; registers changed: edx
; ***************************************************************
intro	PROC
	push	ebp				;setup stack frame stuff
	mov		ebp, esp

	mov		edx, [ebp+20]
	call	WriteString
	call	crlf

	mov		edx, [ebp+16]
	call	WriteString
	call	crlf

	mov		edx, [ebp+12]
	call	WriteString
	call	crlf

	mov		edx, [ebp+8]
	call	WriteString
	call	crlf
	call	crlf

	pop		ebp
	ret		16
intro	ENDP

; ************************** getData ***************************
; Procedure to get and validate user input for amount of nums to display
; receives: request and 2 strings (prompt1, errorMsg) passed by reference
; returns: user's input into request variable
; preconditions: None
; registers changed: eax, ebx, edx
; ***************************************************************
getData	PROC
	push	ebp
	mov		ebp, esp

validate:
	mov		edx, [ebp+12] ;prompt1 lives here
	call	WriteString
	call	ReadInt			;get user input (stored ion eax)

	cmp		eax, MIN		;compare with min
	jl		badInput		;jump to error message if bad
	cmp		eax, max		;compare with max
	jg		badInput		;jump to error message if bad
	jmp goodInput			;jump to end if user entered good data

badInput:
	mov		edx, [ebp+8]	;error message lives here
	call	WriteString
	call	crlf
	jmp	validate

goodInput:
	mov		ebx, [ebp+16]	;address of request variable stored in ebx
	mov		[ebx], eax		; de-reference ebx and store contents of eax in there

	pop		ebp
	ret		12
getData ENDP

; ************************** fillArray **************************
; Procedure to fill array with random numbers
; receives: request and 2 strings (prompt1, errorMsg) passed by reference
; returns: user's input into request variable
; preconditions: None
; registers changed: eax, ebx, edx
; ***************************************************************
fillArray	PROC
	push	ebp
	mov		ebp, esp

	; lots of these ideas taken from demo5.asm which explains filling an array of values
	mov		ecx, [ebp+8] ;this is where request variable lives, which will be our counter
	mov		edi, [ebp+12] ;address of our array into edi

	; more ideas taken from section 8.2.6 of the text
	; need to calculate range first, which goes into ecx and is equal to hi - lo + 1

L1:
	mov		eax, HI	;upper limit into eax
	sub		eax, LO ;subtract lower from upper
	inc		eax		;add one to the end
	;ready to call RandomRange
	call	RandomRange
	add		eax, LO  ;add lo to eax per lecture video 20 to get range of lo-hi-1
	mov		[edi], eax ;put random number value into edi
	add		edi, 4	;add 4 to edi to get next index
	loop L1			;loops until counter is 0, which is request variable

	pop		ebp
	ret		8
fillArray	ENDP

; ************************** display ****************************
; Procedure to fill array with random numbers
; receives: request and 2 strings (prompt1, errorMsg) passed by reference
; returns: user's input into request variable
; preconditions: None
; registers changed: eax, ebx, edx
; ***************************************************************
display		PROC
	push	ebp
	mov		ebp, esp

	call	crlf				;desired spacing 
	mov		edx, [ebp+8]		;display title
	call	WriteString
	call	crlf

	;some logic here taken from demo5.asm example

	mov		edx, [ebp+12]	;count into edx
	mov		esi, [ebp+16]	;address of array
	dec		edx				;scale edx for count-1 to 0 cus array subscript starts at 0-N-1

top:
	mov		eax, [esi]		;de-referenced value in esi starting with index 0
	call	WriteDec
	mov		al, 32
	call	WriteChar
	add		esi, 4
	dec		edx
	cmp		edx, 0
	jge		top

	call	crlf		;spacing
	call	crlf

	pop ebp
	ret 12

display		ENDP

; ************************** sort *******************************
; Procedure to sort the random array
; receives: request and randomArray passed by reference
; returns: sorted array
; preconditions: None
; registers changed: ecx, esi, eax
; ***************************************************************
sort	PROC
	;this was pretty much adopted from the text. I know I know I suck, just pressed for time. 
	push	ebp						
	mov		ebp, esp					
	mov		ecx, [ebp+8]				
	dec		ecx							

L1: 
	push	ecx					
	mov		esi, [ebp+12]			

L2: 
	mov		eax,[esi]				
	cmp		[esi+4],eax				
	jl		L3						
	xchg	eax,[esi+4]			
	mov		[esi],eax	

L3: 
	add		esi,4					
	loop	L2						
	pop		ecx						
	loop	L1						

pop ebp
ret 8

sort	 ENDP

; ************************** median***********************
; Procedure to calculate and display the median of the array
; receives: random array and request of numbers (count basically)
; returns: median value
; preconditions: array has more than 1 element (taken care of by input validation)
;				 and the array is sorted
; registers changed: all of them! just kidding, eax, ebx, ecx, edx, edi
; ***************************************************************
median	PROC
	
	push	ebp
	mov		ebp, esp

	mov		eax, [ebp+12] ;request (amount of numbers) into eax
	mov		edi, [ebp+16] ;address of array into edi
	mov		ebx, 2		  ;our divisor to check for evenness (is that even a word?)
	cdq					  ;setup for division

	div		ebx			  ;divide eax by 2, eax should have request/2
	cmp		edx, 0		  ;see if remainder is 0
	je		isEven		  ;jump if even
	jmp		isOdd		  ;jump if odd

isEven:
	mov		ecx, [edi+eax*4]	;store where middle value of array is into ecx
	add		ecx, [edi+eax*4-4]  ;subtract to ecx middle value - next location
	mov		eax, ecx			;move summation of middle values to eax
	div		ebx				    ;divide by 2 to get average
	mov		edx, [ebp+8]		;where our string lives
	call	WriteString
	call	WriteDec	
	call	crlf
	jmp		finished ;skip over isOdd part


isOdd:						 ;odd is easiest case, take request, divide by 2, add 1 (integer division) to get median
	mov		ecx, [edi+eax*4] ;takes start of array, multiply eax by 4 to get to index we want in array
	mov		eax, ecx
	mov		edx, [ebp+8]		;where our string lives
	call	WriteString
	call	WriteDec
	call	crlf

finished:

	pop ebp
	ret 12

median	ENDP

END main
