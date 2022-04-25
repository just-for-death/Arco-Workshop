#include <stdio.h>

typedef long long s64_t;
typedef unsigned long long u64_t;

u64_t reverse_order(u64_t num, int width)
{
	unsigned char swap[8];
	for (int i = 7; i >= 0; --i) {
		if (i >= width) {
			swap[i] = 0;
		} else {
			swap[i] = num;
			num >>= 8;
		}
	}
	return *((u64_t *)swap);
}

int main()
{
	while (1) {
		s64_t dst_addr, src_addr;
		char *mode = "DOWN";

		printf("Inject pos: 0x ");
		if (!scanf("%llx", &src_addr))
			continue;

		printf("Dest addr:  0x ");
		if (!scanf("%llx", &dst_addr))
			continue;

		puts("--------------");
		
		u64_t distance = 0;
		if (dst_addr < src_addr) {
			mode = "UP";
			distance = 0x100000000 - src_addr + dst_addr; // (addr2 - addr1)
		} else {
			distance = dst_addr - src_addr;
		}

		printf(" Distance: %lld (%s)\n", dst_addr - src_addr, mode);

		u64_t rev_41 = reverse_order(distance - 5, 4);
		printf(" JMP : E9 %08llx\n", rev_41);
		printf(" CALL: E8 %08llx\n", rev_41);
		u64_t rev_43 = reverse_order(distance - 7, 4);
		printf(" MOV RAX,PTR: 48 8b 05 %08llx\n", rev_43);
		printf(" LEA RCX,[D]: 48 8d 0d %08llx\n", rev_43);
		if (distance < 0x80) {
			u64_t rev_1 = reverse_order(distance - 2, 1);
			printf("  JZ : 74 %02llx\n", rev_1);
			printf("  JNZ: 75 %02llx\n", rev_1);
		}
		puts("==============");
		puts("");
	}
	return 0;
}
