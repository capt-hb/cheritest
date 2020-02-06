.set mips64
.set noreorder
.set nobopt
.include "macros.s"

BEGIN_TEST
	cgetdefault $c1
	cgetuninit $a0, $c1
	cuninit $c2, $c1
	cgetuninit $a1, $c2
END_TEST
