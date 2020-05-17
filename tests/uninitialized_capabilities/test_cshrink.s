.set mips64
.set noreorder
.set nobopt
.include "macros.s"

BEGIN_TEST
	cgetdefault $c1
	dla $t0, data
	csetoffset $c1, $c1, $t0
	csetboundsimm $c1, $c1, 10
	cincoffsetimm $c1, $c1, 8
	cshrink $c2, $c1
	cgetlen $a0, $c1
	cgetlen $a1, $c2

	csetoffset $c1, $c1, $a0
	cshrink $c3, $c1
	cgetlen $a2, $c3

	cincoffsetimm $c4, $c1, 1 	# set cursor just outside bounds
	cshrink $c4, $c4		# should throw error, cursor > end!
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
