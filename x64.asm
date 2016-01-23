
; Some daa over here
section .data

one: dd 1.0
maxByte: dd 256.0

clickedXd dq 0
clickedYd dq 0
imSized dq 0



; Here start code section
section .text

; Export functino fo C/C++ code
global xd
global _xd

; And ofc main function of this project
xd:
_xd:
	push rbp
	mov rbp, rsp

	; rcx -> *source
	; rdx -> clicked vec
	; r8d -> size vec


	; define arguments size on stack

	%define LOCAL_WARS_SIZE  32

	sub rbp, LOCAL_WARS_SIZE

	;define variables on stack
	%define imageWidth 			[rbp]
	%define clickedX 				[rbp + 4]
	%define clickedY 				[rbp + 8]
	;define variables
	;%define nativePointer	rcx
	;%define nativeSecondPointer		rdx
	;--------------------------------
	%define imagePointer 					rcx
	%define secondImagePointer 		rdx

	; Begin
	; Load argumants on stack


	;incialize vars
	mov imageWidth, r9
	mov eax, [r8]
	mov clickedX, eax
	mov eax, [r8 + 4]
	mov clickedY, eax

	;inicialize pointers
	mov imagePointer, rcx
	mov secondImagePointer, rdx
	;inicialize image pointer


	;prepare registers
	;used registers RCX, RDX, R11, R12

	mov r11d, 0
	mov r12d, 0
	sub r12, 1


color_row:
	;call blending
	;BGR - color send
	;need three registers for saving color
	jmp blendB

endBlendingB:
	;----------B---------------
	mov  bl, [secondImagePointer]
	;write B to image pixel
	mov byte [imagePointer], bl
	;---------G----------------
	mov  bl, [secondImagePointer + 1]
	;write G to image pixel
	mov byte [imagePointer + 1], bl
	mov  bl, [secondImagePointer + 2]
	;write R to image pixel
	mov byte [imagePointer +2 ], bl


	add imagePointer, 4
	add secondImagePointer, 4
	inc r11
	;--------
	mov eax, imageWidth
	dec eax
	;--------
	cmp r11, rax
	jle color_row
	jmp next_row


next_row:
	mov r11d, 0
	inc r12
	;--------
	mov eax, imageWidth
	sub eax, 2
	;--------
	cmp r12, rax
	jle color_row
	jmp endl

;-------------------
;BLEND
blendB:

	jmp endBlendingB


endl:
	add rbp, LOCAL_WARS_SIZE
	mov rsp, rbp
	pop rbp
	ret
	end
