global memcpy_func

;rdi - first arg (destination)
;rsi - second arg (source)
;rdx - third arg (number of bytes)

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

;rbx - argument
;rax - answer
get_padding:
	and rbx, 15
	mov rax, 16
	sub rax, rbx
	and rax, 15
	ret

a_bigger_b:
	mov rcx, [rsi + 8]
	movq xmm0, rcx
	mov rcx, [rsi]
	movq xmm1, rcx
	pslldq xmm0, 8
	xorpd xmm0, xmm1
	mov rcx, 16
	sub rcx, rax
	call shift_left
	mov rcx, 16
	sub rcx, rax
	add rcx, rbx
	sub rdx, rax
	jmp continuation

a_less_b:
	movdqa xmm0, [rsi + rax]
	mov rcx, rbx
	sub rcx, rax
	sub rdx, rax
	sub rdx, 16
	add rsi, 16
	jmp continuation

memcpy_func:
	push rbx
	push rcx
	push rax
	mov rax, [rsi]
	mov [rdi], rax
	mov rax, [rsi + 8]
	mov [rdi + 8], rax
	mov rax, [rsi + rdx - 8]
	mov [rdi + rdx - 8], rax
	mov rax, [rsi + rdx - 16]
	mov [rdi + rdx - 16], rax

	push rdi 
	push rsi
	push rdx
	add rdi, rdx
	add rsi, rdx 
	mov rcx, 24
	neg rcx
	mov rdx, [rsi + rcx]
	mov [rdi + rcx], rdx
	sub rcx, 8
	mov rdx, [rsi + rcx]
	mov [rdi + rcx], rdx
	pop rdx
	pop rsi
	pop rdi

	mov rbx, rdi
	call get_padding
	push rax
	mov rbx, rsi
	call get_padding
	pop rbx
	cmp rax, rbx
	jge a_bigger_b
	jmp a_less_b

bin_14_15:
	cmp rcx, 14
	je internal_loop_14
	jmp internal_loop_15

bin_12_13:
	cmp rcx, 12
	je internal_loop_12
	jmp internal_loop_13

bin_10_11:
	cmp rcx, 10
	je internal_loop_10
	jmp internal_loop_11

bin_8_9:
	cmp rcx, 8
	je internal_loop_8
	jmp internal_loop_9

bin_6_7:
	cmp rcx, 6
	je internal_loop_6
	jmp internal_loop_7

bin_4_5:
	cmp rcx, 4
	je internal_loop_4
	jmp internal_loop_5

bin_2_3:
	cmp rcx, 2
	je internal_loop_2
	jmp internal_loop_3

bin_0_1:
	cmp rcx, 0
	je internal_loop_0
	jmp internal_loop_1

bin_4_7:
	cmp rcx, 6
	jge bin_6_7
	jmp bin_4_5

bin_0_3:
	cmp rcx, 2
	jge bin_2_3
	jmp bin_0_1

bin_8_11:
	cmp rcx, 10
	jge bin_10_11
	jmp bin_8_9

bin_12_15:
	cmp rcx, 14
	jge bin_14_15
	jmp bin_12_13

bin_8_15:
	cmp rcx, 12
	jge bin_12_15
	jmp bin_8_11

bin_0_7:
	cmp rcx, 4
	jge bin_4_7
	jmp bin_0_3

continuation:
	push rdx
	mov rdx, rcx
	mov rcx, 16
	sub rcx, rdx
	pop rdx

	add rsi, rax
	add rdi, rbx

	cmp rcx, 8
	jge bin_8_15
	jmp bin_0_7


;rcx - shift
;


internal_loop_0:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 16
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_0

internal_loop_1:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 15
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_1

internal_loop_2:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 14
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_2

internal_loop_3:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 13
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_3

internal_loop_4:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 12
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_4

internal_loop_5:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 11
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_5

internal_loop_6:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 10
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_6

internal_loop_7:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 9
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_7

internal_loop_8:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 8
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_8

internal_loop_9:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 7
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_9

internal_loop_10:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 6
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_10

internal_loop_11:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 5
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_11

internal_loop_12:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 4
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_12

internal_loop_13:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 3
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_13

internal_loop_14:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 2
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_14

internal_loop_15:
	cmp rdx, 16
	jl exit
	movdqa xmm1, [rsi]
	movdqa xmm2, xmm1
	palignr xmm1, xmm0, 1
	movntdq [rdi], xmm1
	lea rdi, [rdi + 16]
	lea rsi, [rsi + 16]
	sub rdx, 16
	movdqa xmm0, xmm2
	jmp internal_loop_15

exit:
	;mov rax, rcx
	pop rax
	pop rcx
	pop rbx
	ret
	