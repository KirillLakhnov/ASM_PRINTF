print_c: 
	nasm -g -f macho64 Printf.asm  
	g++ -no-pie -g main.cpp Printf.o -o printf_c && ./printf_c

print_asm:
	nasm -f macho64 Printf.asm
	nasm -f macho64 printf-asm.asm
	gcc -no-pie Printf.o printf-asm.o -o printf_asm && ./printf_asm