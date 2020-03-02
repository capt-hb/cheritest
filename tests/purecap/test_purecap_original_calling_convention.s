.set mips64
.set noreorder
.set nobopt
.set noat
.include "macros.s"

#
# Test original calling convention gives correct result
#

	.global	test                    # -- Begin function test
	.ent	test
test:                                   # @test

	cincoffset	$c11, $c11, -128
	csc	$c17, $zero, 96($c11)   # 32-byte Folded Spill
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
	cincoffset	$c2, $c11, 92
	csetbounds	$c2, $c2, 4
	cincoffset	$c3, $c11, 88
	csetbounds	$c3, $c3, 4
	daddiu	$4, $zero, 100
	cgetnull	$c13
	csc	$c3, $zero, 32($c11)    # 32-byte Folded Spill
	csw	$2, $zero, 28($c11)     # 4-byte Folded Spill
	nop
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	csw	$2, $zero, 0($c1)
	clw	$2, $zero, 0($c1)
	clc	$c17, $zero, 96($c11)   # 32-byte Folded Reload
	cincoffset	$c11, $c11, 128

	# properly terminates the test
	jr $ra
	nop # branch-delay slot
	.end	test
