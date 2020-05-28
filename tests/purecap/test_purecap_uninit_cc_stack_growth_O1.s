.set mips64
.set noreorder
.set nobopt
.set noat
.include "macros.s"

	.globl	g                       # -- Begin function g
	.p2align	3
	.type	g,@function
	.set	nomicromips
	.set	nomips16
	.ent	g
g:                                      # @g
	.cfi_startproc
	.frame	$c11,0,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	clw	$1, $zero, 0($c3)
	clw	$2, $zero, 0($c4)
	cjr	$c17
	addu	$2, $2, $1
	.set	at
	.set	macro
	.set	reorder
	.end	g
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
	.cfi_endproc
                                        # -- End function
	.globl	f                       # -- Begin function f
	.p2align	3
	.type	f,@function
	.set	nomicromips
	.set	nomips16
	.ent	f
f:                                      # @f
	.cfi_startproc
	.frame	$c11,64,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	#cincoffset	$c11, $c11, -64
	.cfi_def_cfa_offset 64
	cgetuninit $t0, $c11
	ucsc	$c11, $c17, 0($c11)   # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
	ucsw $c11, $4, 0($c11)
	addiu	$1, $zero, 10
	ucsw	$c11, $1, 0($c11)
	clcbi	$c12, %capcall20(g)($c1)
	cincoffset	$c3, $c11, 4
	csetbounds	$c3, $c3, 4
	csetbounds	$c4, $c11, 4

	# CC: pre call
	cmove $c19, $c11
	cshrink $c11, $c11, 0
	cuninit $c11, $c11

	cjalr	$c12, $c17
	cgetnull	$c13

	# CC: post call
	cmove $c11, $c19

	sll	$2, $2, 0
	cincoffset $c11, $c11, 8
	clc	$c17, $zero, 0($c11)   # 32-byte Folded Reload
	cjr	$c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	f
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
	.cfi_endproc
                                        # -- End function
	.globl	tmp                     # -- Begin function tmp
	.p2align	3
	.type	tmp,@function
	.set	nomicromips
	.set	nomips16
	.ent	tmp
tmp:                                    # @tmp
	.cfi_startproc
	.frame	$c11,0,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	cld	$1, $zero, 8($c11)
	cld	$2, $zero, 0($c11)
	addu	$3, $5, $4
	addu	$3, $3, $6
	addu	$3, $3, $7
	addu	$3, $3, $8
	addu	$3, $3, $9
	addu	$3, $3, $10
	addu	$3, $3, $11
	addu	$2, $3, $2
	addu	$2, $2, $1
	cjr	$c17
	cgetnull	$c13
	.set	at
	.set	macro
	.set	reorder
	.end	tmp
.Lfunc_end2:
	.size	tmp, .Lfunc_end2-tmp
	.cfi_endproc
                                        # -- End function
	.globl	cap_tmp                 # -- Begin function cap_tmp
	.p2align	3
	.type	cap_tmp,@function
	.set	nomicromips
	.set	nomips16
	.ent	cap_tmp
cap_tmp:                                # @cap_tmp
	.cfi_startproc
	.frame	$c11,0,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	clc	$c1, $zero, 32($c11)
	clc	$c2, $zero, 0($c11)
	clw	$1, $zero, 0($c3)
	clw	$2, $zero, 0($c4)
	clw	$3, $zero, 0($c5)
	clw	$4, $zero, 0($c6)
	addu	$1, $2, $1
	addu	$1, $1, $3
	addu	$1, $1, $4
	clw	$2, $zero, 0($c7)
	clw	$3, $zero, 0($c8)
	clw	$4, $zero, 0($c9)
	addu	$1, $1, $2
	addu	$1, $1, $3
	addu	$1, $1, $4
	clw	$2, $zero, 0($c10)
	clw	$3, $zero, 0($c2)
	clw	$4, $zero, 0($c1)
	addu	$1, $1, $2
	addu	$1, $1, $3
	addu	$2, $1, $4
	cjr	$c17
	cgetnull	$c13
	.set	at
	.set	macro
	.set	reorder
	.end	cap_tmp
.Lfunc_end3:
	.size	cap_tmp, .Lfunc_end3-cap_tmp
	.cfi_endproc
                                        # -- End function
	.globl	mixed_tmp               # -- Begin function mixed_tmp
	.p2align	3
	.type	mixed_tmp,@function
	.set	nomicromips
	.set	nomips16
	.ent	mixed_tmp
mixed_tmp:                              # @mixed_tmp
	.cfi_startproc
	.frame	$c11,0,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	clw	$1, $zero, 0($c3)
	clw	$2, $zero, 0($c4)
	clw	$3, $zero, 0($c5)
	clw	$9, $zero, 0($c6)
	clw	$10, $zero, 0($c7)
	addu	$4, $5, $4
	addu	$4, $4, $6
	addu	$4, $4, $7
	addu	$4, $4, $8
	addu	$1, $4, $1
	addu	$1, $1, $2
	addu	$1, $1, $3
	addu	$1, $1, $9
	cjr	$c17
	addu	$2, $1, $10
	.set	at
	.set	macro
	.set	reorder
	.end	mixed_tmp
.Lfunc_end4:
	.size	mixed_tmp, .Lfunc_end4-mixed_tmp
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
	.frame	$c11,32,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	cincoffset	$c11, $c11, -32
	.cfi_def_cfa_offset 32
	csc	$c17, $zero, 0($c11)    # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
	clcbi	$c12, %capcall20(f)($c1)
	daddiu	$4, $zero, 10
	
	# CC: pre call
	cmove $c18, $c11
	cshrink $c11, $c11, 0
	cuninit $c11, $c11
	cgetuninit $t1, $c11

	cjalr	$c12, $c17
	cgetnull	$c13

	# CC: post call
	cmove $c11, $c18

	sll	$2, $2, 0
	clc	$c17, $zero, 0($c11)    # 32-byte Folded Reload
	cjr	$c17
	cincoffset	$c11, $c11, 32
	.set	at
	.set	macro
	.set	reorder
	.end	test
.Lfunc_end5:
	.size	test, .Lfunc_end5-test
	.cfi_endproc
                                        # -- End function