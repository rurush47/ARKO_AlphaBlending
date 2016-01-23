
; Some daa over here
section .data

six: dd 6.0
zero: dd 0.0
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

	mov r11, 0
	mov r12, 0
	;sub r12, 1


color_row:
	;call blending
	;BGR - color send
	;need three registers for saving color

	;---------SINUS-------------------
  ;X
	cvtsi2ss xmm0, r11
	;Xc
	mov eax, clickedX
	cvtsi2ss xmm1, eax
	;Y
	cvtsi2ss xmm2, r12
	;Yc
	mov eax, clickedY
	cvtsi2ss xmm3, eax
	;X- Xc
	subss xmm0, xmm1
	;Y-Yc
	subss xmm2, xmm3
	;power 2
	mulss xmm0, xmm0
	mulss xmm2, xmm2
	;Xw + Yw
	addss xmm0, xmm2
	sqrtss  xmm0, xmm0
	; dividing x by imageWidth
	mov eax, imageWidth
	cvtsi2ss xmm2, eax
	divss xmm0, xmm2

	;---------SINUS-----------------
	;x - x^3/6
	;save x

	movss xmm1, [zero]
	subss xmm1, xmm0
	mulss xmm1, xmm0
	mulss xmm1, xmm0
	divss xmm1, [six]
	addss xmm1, xmm0

	; XMM1 <--- Our sinus !!!!


	mov r8b, [imagePointer]
	mov r9b, [secondImagePointer]
	jmp blendB

endBlendingB:
	;----------B---------------
	mov  bl, [secondImagePointer]
	;write B to image pixel
	mov byte [imagePointer], bl
	;---------G----------------
	inc secondImagePointer
	mov  bl, [secondImagePointer]
	;write G to image pixel
	inc imagePointer
	mov byte [imagePointer], bl

	inc secondImagePointer
	mov  bl, [secondImagePointer]
	;write R to image pixel
	inc imagePointer
	mov byte [imagePointer], bl


	add imagePointer, 2
	add secondImagePointer, 2
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
