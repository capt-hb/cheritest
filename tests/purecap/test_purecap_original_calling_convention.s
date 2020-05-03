.set mips64
.set noreorder
.set nobopt
.set noat
.include "macros.s"

#
# Test original calling convention gives correct result
#
	.globl	doSomething             # -- Begin function doSomething
	.p2align	3
	.type	doSomething,@function
	.set	nomicromips
	.set	nomips16
	.ent	doSomething
doSomething:                            # @doSomething
	.cfi_startproc
	.frame	$c11,32,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	cincoffset	$c11, $c11, -32
	.cfi_def_cfa_offset 32
                                        # kill: def $a0 killed $a0 killed $a0_64
	cincoffset	$c1, $c11, 28
	csetbounds	$c1, $c1, 4
	csw	$4, $zero, 0($c1)
	clw	$2, $zero, 0($c1)
	cincoffset	$c11, $c11, 32
	cjr	$c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	doSomething
.Lfunc_end0:
	.size	doSomething, .Lfunc_end0-doSomething
	.cfi_endproc
                                        # -- End function

	.globl	test                    # -- Begin function test
	.p2align	3
	.type	test,@function
	.set	nomicromips
	.set	nomips16
	.ent	test
test:                                   # @test
	.cfi_startproc
	.frame	$c11,128,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	cincoffset	$c11, $c11, -128
	.cfi_def_cfa_offset 128
	csc	$c17, $zero, 96($c11)   # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
	cincoffset	$c2, $c11, 92
	csetbounds	$c2, $c2, 4
	cincoffset	$c3, $c11, 88
	csetbounds	$c3, $c3, 4
	addiu	$2, $zero, 0
	csw	$zero, $zero, 0($c2)
	clcbi	$c12, %capcall20(doSomething)($c1)
	daddiu	$4, $zero, 100
	cgetnull	$c13
	csc	$c3, $zero, 32($c11)    # 32-byte Folded Spill
	csw	$2, $zero, 28($c11)     # 4-byte Folded Spill
	cjalr	$c12, $c17
	nop
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	csw	$2, $zero, 0($c1)
	clw	$2, $zero, 0($c1)
	clc	$c17, $zero, 96($c11)   # 32-byte Folded Reload

	# Read from callee stack frame
	clw $t1, $zero, -4($c11)

	cincoffset	$c11, $c11, 128
	cjr $c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	test
.Lfunc_end1:
	.size	test, .Lfunc_end1-test
	.cfi_endproc
                                        # -- End function
	.global	test                    # -- Begin function test
	.ent	test
