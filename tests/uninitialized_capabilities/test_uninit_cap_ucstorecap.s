.set mips64
.set noreorder
.set nobopt
.include "macros.s"

#
# Test ucstorecap instruction on uninit cap
#

BEGIN_TEST
                cgetdefault $c1
                dla $t0, data
                csetoffset $c1, $c1, $t0
		dli $t1, 80
                csetbounds $c1, $c1, $t1

		# Setup $c1 as uninit cap
		csetoffset $c1, $c1, $t1
		cgetnull $c13
		cuninit $c1, $c1
		cgetoffset $a0, $c1

		ucsw $c1, $t1, -1($c1)
		cgetoffset $a1, $c1
		clw $a2, $zero, 0($c1)

		# Create capability pointing to word containing contents of $t1
		csetbounds $c2, $c1, 4

		# store $c2
		ucsw $c1, $t1, -1($c1) # needed for 32-bit alignment of caps
		cgetoffset $s0, $c1
		ucsc $c1, $c2, -1($c1)
		cgetoffset $s1, $c1
		sub $s1, $s0, $s1

		clc $c3, $zero, 0($c1)
		clw $a3, $zero, 0($c2)
		clw $a4, $zero, 0($c3)
END_TEST

                .data
                .align  5               # 256-bit align
                .dword  0x0
                .dword  0x0
                .dword  0x0
data:           .dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
