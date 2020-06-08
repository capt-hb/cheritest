.set mips64
.set noreorder
.set nobopt
.include "macros.s"

BEGIN_TEST
	cgetdefault $c1
	dla $t0, data
	csetoffset $c1, $c1, $t0
	csetbounds $c1, $c1, 10
	cincoffset $c1, $c1, 2
	cgetuninit $a0, $c1
	cuninit $c1, $c1
	cgetuninit $a1, $c1
	cdropuninit $c1, $c1 # error, offset == 2
	cgetuninit $a2, $c1
	dli $t0, 42
	ucsb $c1, $t0, -1($c1)
	cdropuninit $c1, $c1 # error, offset == 1
	cgetuninit $a3, $c1
	ucsb $c1, $t0, -1($c1)
	cdropuninit $c1, $c1
	cgetuninit $a4, $c1
	cincoffset $c1, $c1, 8
	# decrementing offset should not throw an error if the cap is NOT uninit
	cincoffset $c1, $c1, -4
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
