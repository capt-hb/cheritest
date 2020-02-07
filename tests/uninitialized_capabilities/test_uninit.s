.set mips64
.set noreorder
.set nobopt
.include "macros.s"

BEGIN_TEST
	cgetdefault $c1
	cuninit $c2, $c1
END_TEST
