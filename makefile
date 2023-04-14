print_c: 
	nasm -f macho64 Printf.asm 
	gcc -c main.c 
	gcc -no-pie Printf.o main.o -o main

print_asm:
	nasm -f macho64 Printf.asm
	nasm -f macho64 printf-asm.asm
	gcc -no-pie Printf.o printf-asm.o -o printf_asm && ./printf_asm
	