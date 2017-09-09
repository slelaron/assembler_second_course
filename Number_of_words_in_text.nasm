global count_words_internal

;rdi - start
;rsi - length
;rdx - current answer
;rax - count of words

;count_words:
;	movntdq xmm1, [rdi]

shift_right:
	cmp rcx, 16
	jl r_8
	sub rcx, 16
	psrldq xmm0, 16
r_8:
	cmp rcx, 8
	jl r_4
	sub rcx, 8
	psrldq xmm0, 8
r_4:
	cmp rcx, 4
	jl r_2
	sub rcx, 4
	psrldq xmm0, 4
r_2:
	cmp rcx, 2
	jl r_1
	sub rcx, 2
	psrldq xmm0, 2
r_1:
	cmp rcx, 1
	jl r_0
	sub rcx, 1
	psrldq xmm0, 1
r_0:
	ret

shift_left:
	cmp rcx, 16
	jl l_8
	sub rcx, 16
	pslldq xmm0, 16
l_8:
	cmp rcx, 8
	jl l_4
	sub rcx, 8
	pslldq xmm0, 8
l_4:
	cmp rcx, 4
	jl l_2
	sub rcx, 4
	pslldq xmm0, 4
l_2:
	cmp rcx, 2
	jl l_1
	sub rcx, 2
	pslldq xmm0, 2
l_1:
	cmp rcx, 1
	jl l_0
	sub rcx, 1
	pslldq xmm0, 1
l_0:
	ret

count_bits:
	movq rax, xmm0
	popcnt rbx, rax
	add rdx, rbx
	psrldq xmm0, 8
	movq rax, xmm0
	popcnt rbx, rax
	add rdx, rbx
	ret

preparing:
	mov rax, 0x00000000000000F
	mov rbx, rdi
	mov rcx, 16
	and rbx, rax
	sub rcx, rbx
	and rcx, 15

	mov rax, [rdi + 8] ; correct!
	movq xmm0, rax
	pslldq xmm0, 8
	mov rax, [rdi]
	movq xmm1, rax
	xorpd xmm0, xmm1

	mov rax, 0x2020202020202020
	movq xmm1, rax
	movdqa xmm2, xmm1
	pslldq xmm1, 8
	xorpd xmm1, xmm2 ; fill xmm with spaces

	pcmpeqb xmm0, xmm1
	movdqa xmm3, xmm0
	xorpd xmm2, xmm2 ; make null
	pcmpeqb xmm0, xmm2 ; bit reverse

	add rdi, rcx
	sub rsi, rcx

	mov rdx, 16
	sub rdx, rcx
	mov rcx, rdx
	xor rdx, rdx
	call shift_left
	movdqa xmm2, xmm0
	pslldq xmm2, 1
	xorpd xmm0, xmm2

	xor rdx, rdx

	call count_bits
	ret

count_words_internal:
	push rbx
	push rcx
	push rdx

	dec rsi

	call preparing

	cmp rsi, 16
	jl ending

first_loop:
	movdqa xmm2, xmm3
	movntdqa xmm0, [rdi]
	pcmpeqb xmm0, xmm1
	movdqa xmm3, xmm0
	palignr xmm0, xmm2, 15
	
	xorpd xmm0, xmm3
	call count_bits
	add rdi, 16
	sub rsi, 16
	cmp rsi, 16
	jge first_loop

ending:
	movdqa xmm2, xmm3
	add rdi, rsi
	sub rdi, 16
	mov rax, [rdi + 8]
	movq xmm0, rax
	mov rax, [rdi]
	movq xmm3, rax
	pslldq xmm0, 8
	xorpd xmm0, xmm3
	pcmpeqb xmm0, xmm1
	;psrldq xmm0, 8
	;movq rdx, xmm0
	xorpd xmm3, xmm3
	pcmpeqb xmm0, xmm3
	pcmpeqb xmm2, xmm3
	mov rcx, 16
	sub rcx, rsi
	call shift_right
	movdqa xmm3, xmm0
	palignr xmm0, xmm2, 15

	xorpd xmm0, xmm3

	call count_bits

testing:
	mov rax, rdx
	shr rax, 3
	inc rax
	shr rax, 1
	pop rdx
	pop rcx
	pop rbx
	ret
