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
	dli $t0, 15 # capability to store a byte, halfword, word and double word
	csetbounds $c1, $c1, $t0

	# place cursor at the end of the capability
	cgetlen $t0, $c1
	csetoffset $c1, $c1, $t0
	cuninit $c1, $c1

	dli $t0, -10
	cincoffset $c1, $c1, $t0 # inc offset lower than cursor should throw an error

	# store 10 as a byte on the cursor of the uninit cap
	dli     $t1, 10 
	cgetoffset $s0, $c1 # store the offset 
	ucsb    $c1, $t1, 0($c1)
	cgetoffset $s1, $c1
	sub $a1, $s0, $s1 # a byte was written so $a1 should contain 1 (decr of cursor after writing)

	# store 42 as a halfword on the cursor of the uninit cap
	dli     $t1, 42
	cgetoffset $s0, $c1 # store the offset 
	ucsh $c1, $t1, 0($c1)
	cgetoffset $s1, $c1
	sub $a2, $s0, $s1 # halfword was written, so $a2 should contain 2

	# store 100 as a word on the cursor of the uninit cap
	dli $t1, 100
	cgetoffset $s0, $c1 # store the offset 
	ucsw $c1, $t1, 0($c1)
	cgetoffset $s1, $c1
	sub $a3, $s0, $s1 # halfword was written, so $a2 should contain 4

	# store 420 as a double word on the cursor of the uninit cap
	dli     $t1, 420
	cgetoffset $s0, $c1 # store the offset 
	ucsd $c1, $t1, 0($c1)
	cgetoffset $s1, $c1
	sub $a4, $s0, $s1 # halfword was written, so $a2 should contain 4

	cgetlen $t0, $c1
	csetoffset $c1, $c1, $t0
	cgetoffset $a5, $c1
	cincoffsetimm $c1, $c1, 100
	cgetoffset $a6, $c1
END_TEST
	.data
	.align 5

data:	.dword  0x0123456789abcdef
	.dword  0x0123456789abcdef
