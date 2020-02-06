.set mips64
.set noreorder
.set nobopt
.include "macros.s"

sandbox:
	creturn

BEGIN_TEST
	li	$t0, 0xC0DE
	cgetdefault $c1
	csetoffset $c1, $c1, $t0

	dla $t0, sandbox
	cgetdefault $c2
	csetoffset $c2, $c2, $t0

	cseal $c2, $c2, $c1
	cuninit $c3, $c2

	cunseal $c3, $c2, $c1
	cuninit $c4, $c3
	cgetuninit $a0, $c4
END_TEST
