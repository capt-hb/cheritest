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
	dli $t0, 10
	cincoffset $c1, $c1, $t0 # inc offset higher than cursor should throw an error

	dli     $t1, 42
	ucsb    $c1, $t1, 0($c1)
	dli $t1, 0
	cgetoffset $a1, $c1
	csetoffset $c1, $c1, $t1
	cgetoffset $a2, $c1

	dli     $t1, 42
	ucsb    $c1, $t1, 0($c1)
	dli $t1, -1
	cgetoffset $a3, $c1
	cincoffset $c1, $c1, $t1
	cgetoffset $a4, $c1

	dli     $t1, 42
	ucsb    $c1, $t1, 0($c1)
	cgetoffset $a5, $c1
	cincoffsetimm $c1, $c1, -1
	cgetoffset $a6, $c1

	# completely write capability
	dli     $t1, 42
	ucsb    $c1, $t1, 0($c1)
	ucsb    $c1, $t1, 0($c1)
	cincoffsetimm $c1, $c1, 2 # set offset higher than cap bounds
	cgetoffset $a7, $c1
END_TEST
	.data
	.align 5

data:	.dword  0x0123456789abcdef
