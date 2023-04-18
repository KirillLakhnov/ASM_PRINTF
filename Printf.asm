section	.text
    global _myprintf
	
_myprintf:
		pop r15 ; save return adress

		push r9
    	push r8
    	push rcx    ; Push first six arguments, except rdi
    	push rdx
    	push rsi

		call print

		pop rsi
		pop rdx
		pop rcx
		pop r8
		pop r9

		push r15
		ret

;===========================================
; Printf
;===========================================
; Entry:   	RDI - message, other param lie stack
; Exit:     None
; Expects:  None
; Destroys: 
;===========================================
print:
        push rbp
        mov rbp, rsp
        add rbp, 2*8

		push rax	 ;<--; save registers
		push rdx	 ; 
		push rdi 	 ;
        push rsi ;<--;
        
        mov rsi, buffer

		xor r9, r9 ; r9 = used byte buffer

        print_loop: 
					xor rdx, rdx
                    mov dl, byte [rdi]

                    cmp dl, 0
                    je end_print

                    cmp dl, '%'
                    je specifier
                        
                    mov byte [rsi], dl
                    inc rsi
                    inc rdi

					call cmp_size_buffer
                    jmp print_loop

        specifier:  
                    inc rdi
                    mov dl, byte [rdi] ; char after '%'

                    cmp dl, '%'
                    je percent_print

					mov r14, jump_table
                    mov r8, qword [r14 + 8 * (rdx - 97)] ; 'a' = 97

                    jmp r8  ; go to jmp table

        Spec_a: jmp skip_char
        Spec_b: jmp bin_print
        Spec_c: jmp chr_print
        Spec_d: jmp dec_print
        Spec_e: jmp skip_char
        Spec_f: jmp skip_char
        Spec_g: jmp skip_char
        Spec_h: jmp skip_char
        Spec_i: jmp skip_char
        Spec_j: jmp skip_char
        Spec_k: jmp skip_char
        Spec_l: jmp skip_char
        Spec_m: jmp skip_char
        Spec_n: jmp skip_char
        Spec_o: jmp oct_print
        Spec_p: jmp skip_char
        Spec_q: jmp skip_char
        Spec_r: jmp skip_char
        Spec_s: jmp str_print
        Spec_t: jmp skip_char
        Spec_u: jmp skip_char
        Spec_v: jmp skip_char
        Spec_w: jmp skip_char
        Spec_x: jmp hex_print
      
        percent_print: 
                    mov dl, '%'
                    mov byte [rsi], dl
                    inc rsi
                    inc rdi

					call cmp_size_buffer
                    jmp print_loop

		bin_print:
					mov eax, [rbp] ; rax = current parameter
                    add rbp, 8 ; move to the next parameter

					mov r11, 1 ; r11 = 1
					mov r12, 1
                    call hex_convert

					inc rdi

                    jmp print_loop

        chr_print:
                    mov rdx, [rbp] ; rdx = current parameter
                    add rbp, 8 ; move to the next parameter

                    mov byte [rsi], dl
                    inc rsi
                    inc rdi

					call cmp_size_buffer
                    jmp print_loop

        dec_print:  
                    mov eax, [rbp] ; rax = current parameter
                    add rbp, 8 ; move to the next parameter

					mov r11, 10
                    call dec_convert

					inc rdi

                    jmp print_loop

		hex_print:
					mov eax, [rbp] ; rax = current parameter
                    add rbp, 8 ; move to the next parameter

					mov r11, 1111b ; r11 = 16h
					mov r12, 4
                    call hex_convert

					inc rdi

                    jmp print_loop

		oct_print:
					mov eax, [rbp] ; rax = current parameter
                    add rbp, 8 ; move to the next parameter

					mov r11, 111b ; r11 = 8
					mov r12, 3
                    call hex_convert

					inc rdi

                    jmp print_loop

        str_print:
					mov rax, [rbp] ; rax = current parameter
					add rbp, 8 ; move to the next parameter

					str_print_loop:
							mov dl, [rax]

							cmp dl, 0
							je str_loop_end

							mov byte [rsi], dl
                    		inc rsi
							inc rax

							call cmp_size_buffer
							jmp str_print_loop

					str_loop_end:

					inc rsi
					inc rdi
					call cmp_size_buffer
					jmp print_loop

        skip_char:
                    add rdi, 1
                    jmp print_loop
                    
        end_print:  
					call print_buffer
        			mov rdi, 1
        			mov rsi, buffer
        			mov rdx, size_buff
        			syscall

                    pop rsi
					pop rdi
					pop rdx
					pop rax
                    pop rbp
                    ret

;===========================================
; checks the printf buffer for overflow, outputs its data in case of overflow and clears it
;===========================================
; Entry:    r9 = the number of characters written to the buffer
; Exit:     if printf buffer for overflow, then r9 = 0, else r9 += 1
; Expects:  None
; Destroys: None
;===========================================
cmp_size_buffer:
		inc r9
		cmp r9, size_buff
		jne after_cmp_size
		call print_buffer

after_cmp_size:
		ret

;===========================================
; write printf buffer
;===========================================
; Entry:    None
; Exit:     None
; Expects:  None
; Destroys: None
;===========================================
print_buffer:
		push rax
		push rdx
		push rdi

		mov rax, 0x2000004
        mov rdi, 1
        mov rsi, buffer
        mov rdx, size_buff
        syscall
		
		mov rcx, r9

		clear_buffer:
				mov byte [rsi], 0
				inc rsi
				loop clear_buffer

		mov rsi, buffer
		xor r9, r9

		pop rdi
		pop rdx
		pop rax
		ret
;===========================================
; convert number of our system foundation in string and write to buffer
;===========================================
; Entry:    eax = number
;			r11 = system foundation
;           rsi = pointer to buffer
; Exit:     rsi += the number of digits of a number in a given number system
; Expects:  None
; Destroys: rbx, rcx, rdx
;===========================================
dec_convert:
		call is_negative
		cmp r13, 0
		je dec_count

		mov dl, '-'
		mov byte [rsi], dl   
    	inc rsi

		call cmp_size_buffer

dec_count:		
		mov rbx, 0

		deg:
    			mov rdx, 0
    			div r11
    			push rdx ; rdx = one of the digits of a number in a given number system
    			inc rbx
   
    			cmp eax, 0
    			jne deg

    	mov rcx, rbx ; rcx = the number of digits of a number in a given number system

		jmp print_number
		ret

;===========================================
; convert number of our even system foundation in string and write to buffer
;===========================================
; Entry:    rax = number
;			r11 - byte mask
;       	r12 - byte shift 
;           rsi = pointer to buffer
; Exit:     rsi += the number of digits of a number in a given number system
; Expects:  None
; Destroys: rax, rbx, rcx, rdx, r12
;===========================================
hex_convert:
		mov rcx, r12
		xor r12, r12

		hex: 
    			mov rbx, rax
    			and rbx, r11
    			push rbx

    			shr eax, cl
    			inc r12
    
    			cmp eax, 0
    			jne hex

    	mov rcx, r12

		jmp print_number
		ret

;===========================================
; convert number of our even system foundation in string and write to buffer
;===========================================
; Entry:    number of digits lie on stack
;			rcx = the number of digits in a number
;           rsi = pointer to buffer
; Exit:     rsi += the number of digits of a number in a given number system
; Expects:  None
; Destroys: rcx, rdx
;===========================================
print_number:
		pop rdx
		mov rbx, system
		add rdx, rbx ; rdx = rdx + system
    	mov dl, byte [rdx]

    	mov byte [rsi], dl   
    	inc rsi

		call cmp_size_buffer

    	dec rcx
    	cmp rcx, 0
    	jne print_number

    	ret

;===========================================
; checking a number for negativity
;===========================================
; Entry:    eax = number
; Exit:     r13 = 1 if number < 0; r13 = 0 if number >= 0
;			eax = |eax|
; Expects:  None
; Destroys: None
;===========================================
is_negative:
		push rax
	 	push rdx

		cmp eax, 0
		jl  yes_neg
		jmp not_neg

		not_neg:
				mov r13, 0
				pop rdx
				pop rax
				ret

		yes_neg:
				mov r13, 1
				pop rdx
				pop rax
				sub eax, 1
				not eax
				ret
;===========================================

section .data

size_buff   equ 250
buffer      db size_buff dup (0)

system db '0123456789ABCDEF$'

jump_table  dq Spec_a
        	dq Spec_b
        	dq Spec_c
        	dq Spec_d
       		dq Spec_e
        	dq Spec_f
        	dq Spec_g
        	dq Spec_h
        	dq Spec_i
        	dq Spec_j
        	dq Spec_k
        	dq Spec_l
        	dq Spec_m
        	dq Spec_n
        	dq Spec_o
        	dq Spec_p
        	dq Spec_q
        	dq Spec_r
        	dq Spec_s
        	dq Spec_t
        	dq Spec_u
        	dq Spec_v
        	dq Spec_w
        	dq Spec_x
