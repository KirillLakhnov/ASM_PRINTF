section .text
    global _main
    extern _printf

_main:  mov rdi, msg

        xor rax, rax 
        
        mov rax, par6
        push rax

		mov r9,  par5
		mov r8,  par4
		mov rcx, par3
        mov rdx, par2
		mov rsi, par1

        call _printf

        mov rax, 0x2000001  ;<--; exit programm
        xor rdi, rdi        ;
        syscall         ;<--;

section .data

msg  db "Hello_wo%cld%% %s!!! %s %d, I love hex %x %b %f sdfdgfhgjhhjfhxdfzxgfhcgjvhhfgxdfzsdxgfchghjfxdfzgfhcgjhkjkgfhcfgxdxfxghjhjkkghfghcgjhdgfgjhfgghghjjhjhhjjhhhjkkkkkkkkkkwddkdskdkskdkdksdsncndc123qwe34", 0

par1 db 'r'
par2 db "I love this life", 0
par3 db "I am", 0
par4 dq 15d
par5 dq -24Fh
par6 dq 101101b
