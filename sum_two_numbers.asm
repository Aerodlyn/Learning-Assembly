; This is a simple addition calculator that I made in an effort to begin understanding Assembly to bit better.
;	Please note that this code doesn't do any input checking and that is because I was more interested in
;	making a working program in Assembly than a necessarily "right" one.
;
; This file was assembled using NASM (http://www.nasm.us/) and ran using GCC.

extern printf
extern scanf

section .data
	input_format	db	"%d", 0x0
	input_text	db	"Enter a number: ", 0x0
	output_text	db	"The sum of %d and %d is %d.",  0xa, 0x0

	continue_text	db	"Are there more inputs? (y - yes, n - no) ", 0x0
	continue_format	db	" %c", 0x0

section .text
	global	main

; Returns true (1) if the user enter's 'y' or 'Y', otherwise returns false (0).
can_continue:
	push	continue_text
	call	printf

	add	esp, 0x4

	push	ebp
	mov	ebp, esp
	sub	esp, 0x4

	lea	eax, [ebp - 0x4]
	push	eax
	push	continue_format
	call	scanf

	cmp	byte [ebp - 0x4], 0x59
	je	true

	cmp	byte [ebp - 0x4], 0x79
	je	true

	mov	eax, 0x0
	jmp	return 
	
	true:
	mov	eax, 0x1
	
	return:
	add	esp, 0xc
	mov	esp, ebp
	pop	ebp

	ret

; Reads a 32-bit number from the user. This number is stored in a given integer pointer.
read_num:
	push	input_text
	call	printf
	
	add	esp, 0x4	

	push	dword [esp + 0x4]
	push 	input_format
	call	scanf

	add	esp, 0x8
	ret
	
; Returns the sum of the two given 32-bit integers.
sum_of:
	mov	eax, dword [esp + 0x4]
	add	eax, dword [esp + 0x8]

	ret

; The main function of the program. The structure of the function is a do-while loop which repeats as long as
; 	the result of can_continue is "true." The function creates two local variables for holding the user's
;	input and prints the sum of those two (32-bit) numbers. The user is then asked if there are any more inputs.
main:
	push	ebp
	mov	ebp, esp
	sub	esp, 0x8

	repeat:
	lea	eax, [ebp - 0x4]
	push	eax
	call 	read_num

	lea	eax, [ebp - 0x8]
	push	eax
	call	read_num

	push	dword [ebp - 0x8]
	push	dword [ebp - 0x4]
	call	sum_of

	push	eax
	push	dword [ebp - 0x8]
	push	dword [ebp - 0x4]
	push	output_text
	call	printf

	add	esp, 0x20

	call	can_continue
	cmp	eax, 0x1
	je	repeat

	add	esp, 0x8
	mov	esp, ebp
	pop	ebp
	
	mov	eax, 0x0
  	ret

