.set mips64
.set noreorder
.set nobopt
.include "macros.s"

#
# Test setting offset of uninit cap
#

BEGIN_TEST
	cgetdefault $c1
	dla $t0, data
	csetoffset $c1, $c1, $t0
	dli $t0, 2
	csetbounds $c1, $c1, $t0

	cuninit $c1, $c1

	# setting cursor higher should result in error
	dli $t1, 10
	csetaddr $c1, $c1, $t1

	dli $t1, 42
	ucsb $c1, $t1, 0($c1)

	dli $t1, 0
	csetaddr $c1, $c1, $t1
	cgetaddr $a0, $c1
END_TEST

	.data
	.align 5

data:	.dword  0x0123456789abcdef
