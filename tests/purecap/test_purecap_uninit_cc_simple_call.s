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
	cgetuninit $t0, $c11
	.cfi_def_cfa_offset 32
                                        # kill: def $a0 killed $a0 killed $a0_64
	ucsw	$c11, $4, -1($c11)
	csetbounds	$c3, $c11, 4
	clw	$2, $zero, 0($c3)

	# Clear stack frame 
	ucsw $c11, $zero, 0($c11)

	# Clear registers
	clearlo 0b1110111111101011
	clearhi 0xffff
	cclearlo 0b1111111111111000
	cclearhi 0xffff

	ccall $c1, $c2, 1
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
	
	li $t1, 0xfffffffe # permissions to make capability local
	candperm $c11, $c11, $t1 
	cgetdefault $c13 
	candperm $c13, $c13, $t1 

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


	# Load seal capability 
	cgetdefault $c13 
	cmove $c3, $c13
	cincoffset $c3, $c3, 1
	cgetlen $t2, $c3
	cgetaddr $t3, $c3
	sub $t2, $t2, $t3
	csetbounds $c3, $c3, $t2
	# Store modified seal capability 
	csetdefault $c3

	# CC: pre call
	cseal $c2, $c11, $c13
	cshrink $c11, $c11, 0
	cuninit $c11, $c11

	li $t2, 32
	li $t1, 0xfffffffe 
	cgetpccincoffset $c17, $t2 
	candperm $c17, $c17, $t1
	cseal $c1, $c17, $c13

	# Clear registers
	clearlo 0b1111111111101111
	clearhi 0xffff
	cclearlo 0b1110011111111000
	cclearhi 0xffff

	# Jump to function
	cjr $c12
	nop

	# CC: post call
	cmove $c11, $idc

	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	csw	$2, $zero, 0($c1)
	clw	$2, $zero, 0($c1)
	clc	$c17, $zero, 96($c11)   # 32-byte Folded Reload
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
