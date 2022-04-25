### Assembly Helper

Ghidra 9.1.2 does not accept arbitrary addresses to jump/load.
This application generates simple x64_86 byte templates for quick byte insertion within Ghidra.


Compiling:

	gcc -o asm_helper -std=c11 -Wall -Wextra main.c

Running:

	chmod +x asm_helper
	./asm_helper
