	.globl	product                 # -- Begin function product
	.p2align	3
	.type	product,@function
	.set	nomicromips
	.set	nomips16
	.ent	product
product:                                # @product
	.cfi_startproc
	.frame	$c11,32,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 32
                                        # kill: def $a1 killed $a1 killed $a1_64
                                        # kill: def $a0 killed $a0 killed $a0_64
	ucsw	$c11, $4, -1($c11)
	csetbounds $c1, $c11, 4
	ucsw	$c11, $5, -1($c11)
	csetbounds $c2, $c11, 4
	clw	$1, $zero, 0($c1)
	clw	$2, $zero, 0($c2)
	mult	$1, $2
	mflo	$1
	sll	$2, $1, 0
	cjr	$c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	product
.Lfunc_end0:
	.size	product, .Lfunc_end0-product
	.cfi_endproc
                                        # -- End function
	.globl	factorial               # -- Begin function factorial
	.p2align	3
	.type	factorial,@function
	.set	nomicromips
	.set	nomips16
	.ent	factorial
factorial:                              # @factorial
	.cfi_startproc
	.frame	$c11,192,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 192
	ucsc	$c11, $c17, -1($c11)  # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
                                        # kill: def $a0 killed $a0 killed $a0_64
	ucsw	$c11, $4, -1($c11)
	csetbounds	$c2, $c11, 4
	addiu	$2, $zero, 1
	ucsw	$c11, $2, -1($c11)
	csetbounds	$c3, $c11, 4
	clw	$2, $zero, 0($c2)
	ucsw	$c11, $2, -1($c11)
	csetbounds	$c4, $c11, 4

	ucsw	$c11, $zero, -1($c11)
	ucsd	$c11, $zero, -1($c11)
	ucsd	$c11, $zero, -1($c11)

	ucsc	$c11, $c1, -1($c11)    # 32-byte Folded Spill
	ucsc	$c11, $c3, -1($c11)    # 32-byte Folded Spill
	ucsc	$c11, $c4, -1($c11)    # 32-byte Folded Spill
	b	.LBB1_1
	nop
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	clc	$c1, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	slti	$1, $1, 2
	bnez	$1, .LBB1_5
	nop
# %bb.2:                                # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	b	.LBB1_3
	nop
.LBB1_3:                                # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$4, $zero, 0($c1)
	clc	$c2, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$5, $zero, 0($c2)
	clc	$c3, $zero, 64($c11)    # 32-byte Folded Reload
	clcbi	$c12, %capcall20(product)($c3)
	cgetnull	$c13
	# CC: pre call
	cmove $c21, $c11
	cshrink $c11, $c11, 0
	cuninit $c11, $c11
	cjalr	$c12, $c17
	nop
	# CC: post call
	cmove $c11, $c21
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	ucsw	$c1, $2, 0($c1)
	b	.LBB1_4
	nop
.LBB1_4:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	clc	$c1, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	addiu	$1, $1, -1
	ucsw	$c1, $1, 0($c1)
	b	.LBB1_1
	nop
.LBB1_5:                                # %for.end
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$2, $zero, 0($c1)
	clc	$c17, $zero, 128($c11)  # 32-byte Folded Reload
	cjr	$c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	factorial
.Lfunc_end1:
	.size	factorial, .Lfunc_end1-factorial
	.cfi_endproc
                                        # -- End function
	.globl	sum                     # -- Begin function sum
	.p2align	3
	.type	sum,@function
	.set	nomicromips
	.set	nomips16
	.ent	sum
sum:                                    # @sum
	.cfi_startproc
	.frame	$c11,224,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 224
                                        # kill: def $a0 killed $a0 killed $a0_64
	ucsc	$c11, $c3, -1($c11)
	csetbounds $c1, $c11, 32
	ucsw	$c11, $4, -1($c11)
	csetbounds $c2, $c11, 4
	addiu	$1, $zero, 0
	ucsw	$c11, $zero, -1($c11)
	csetbounds $c4, $c11, 4
	ucsw	$c11, $zero, -1($c11)
	csetbounds $c5, $c11, 4
	ucsw	$c11, $1, -1($c11)    # 4-byte Folded Spill

	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)

	ucsc	$c11, $c1, -1($c11)   # 32-byte Folded Spill
	ucsc	$c11, $c2, -1($c11)    # 32-byte Folded Spill
	ucsc	$c11, $c4, -1($c11)    # 32-byte Folded Spill
	ucsc	$c11, $c5, -1($c11)    # 32-byte Folded Spill
	b	.LBB2_1
	nop
.LBB2_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	clc	$c1, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	clc	$c2, $zero, 64($c11)    # 32-byte Folded Reload
	clw	$2, $zero, 0($c2)
	slt	$1, $1, $2
	beqz	$1, .LBB2_5
	nop
# %bb.2:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	b	.LBB2_3
	nop
.LBB2_3:                                # %for.body
                                        #   in Loop: Header=BB2_1 Depth=1
	clc	$c1, $zero, 96($c11)   # 32-byte Folded Reload
	clc	$c2, $zero, 0($c1)
	clc	$c3, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c3)
	dsll	$1, $1, 2
	clw	$2, $1, 0($c2)
	clc	$c2, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$3, $zero, 0($c2)
	addu	$2, $3, $2
	ucsw	$c2, $2, 0($c2)
	b	.LBB2_4
	nop
.LBB2_4:                                # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	clc	$c1, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	addiu	$1, $1, 1
	ucsw	$c1, $1, 0($c1)
	b	.LBB2_1
	nop
.LBB2_5:                                # %for.end
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$2, $zero, 0($c1)
	cjr	$c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	sum
.Lfunc_end2:
	.size	sum, .Lfunc_end2-sum
	.cfi_endproc
                                        # -- End function
	.globl	sumFactorials           # -- Begin function sumFactorials
	.p2align	3
	.type	sumFactorials,@function
	.set	nomicromips
	.set	nomips16
	.ent	sumFactorials
sumFactorials:                          # @sumFactorials
	.cfi_startproc
	.frame	$c11,224,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 224
	ucsc	$c11, $c17, -1($c11)  # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
	addiu	$2, $zero, 4
	ucsw $c11, $2, -1($c11)
	csetbounds $c2, $c11, 4
	addiu	$2, $zero, 1

	# Create array of 4 words
	ucsw $c11, $zero, -1($c11)
	ucsw $c11, $zero, -1($c11)
	ucsw $c11, $zero, -1($c11)
	ucsw $c11, $2, -1($c11)
	csetbounds $c3, $c11, 16

	ucsw $c11, $2, -1($c11)
	csetbounds $c4, $c11, 4

	ucsd $c11, $zero, -1($c11)

	ucsc	$c11, $c1, -1($c11)   # 32-byte Folded Spill
	ucsc	$c11, $c2, -1($c11)    # 32-byte Folded Spill
	ucsc	$c11, $c3, -1($c11)    # 32-byte Folded Spill
	ucsc	$c11, $c4, -1($c11)    # 32-byte Folded Spill
	b	.LBB3_1
	nop
.LBB3_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	clc	$c1, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	clc	$c2, $zero, 64($c11)    # 32-byte Folded Reload
	clw	$2, $zero, 0($c2)
	slt	$1, $1, $2
	beqz	$1, .LBB3_5
	nop
# %bb.2:                                # %for.cond
                                        #   in Loop: Header=BB3_1 Depth=1
	b	.LBB3_3
	nop
.LBB3_3:                                # %for.body
                                        #   in Loop: Header=BB3_1 Depth=1
	clc	$c1, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$4, $zero, 0($c1)
	clc	$c2, $zero, 96($c11)   # 32-byte Folded Reload
	clcbi	$c12, %capcall20(factorial)($c2)
	cgetnull	$c13
	# CC: pre call
	cmove $c19, $c11
	cshrink $c11, $c11, 0
	cuninit $c11, $c11
	cjalr	$c12, $c17
	nop
	# CC: post call
	cmove $c11, $c19
	clc	$c1, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	dsll	$1, $1, 2
	clc	$c2, $zero, 32($c11)    # 32-byte Folded Reload
	cincoffset $c2, $c2, $1
	ucsw	$c2, $2, 0($c2)
	b	.LBB3_4
	nop
.LBB3_4:                                # %for.inc
                                        #   in Loop: Header=BB3_1 Depth=1
	clc	$c1, $zero, 0($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	addiu	$1, $1, 1
	ucsw	$c1, $1, 0($c1)
	b	.LBB3_1
	nop
.LBB3_5:                                # %for.end
	clc	$c1, $zero, 64($c11)    # 32-byte Folded Reload
	clw	$4, $zero, 0($c1)
	clc	$c2, $zero, 96($c11)   # 32-byte Folded Reload
	clcbi	$c12, %capcall20(sum)($c2)
	clc	$c3, $zero, 32($c11)    # 32-byte Folded Reload
	cgetnull	$c13
	# CC: pre call
	cmove $c20, $c11
	cshrink $c11, $c11, 0
	cuninit $c11, $c11
	cjalr	$c12, $c17
	nop
	# CC: post call
	cmove $c11, $c20
	sll	$2, $2, 0
	clc	$c17, $zero, 160($c11)  # 32-byte Folded Reload
	cjr	$c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	sumFactorials
.Lfunc_end3:
	.size	sumFactorials, .Lfunc_end3-sumFactorials
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
	.frame	$c11,64,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	cincoffset	$c11, $c11, -64
	.cfi_def_cfa_offset 64
	csc	$c17, $zero, 32($c11)   # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
	cincoffset	$c2, $c11, 28
	csetbounds	$c2, $c2, 4
	addiu	$2, $zero, 0
	csw	$zero, $zero, 0($c2)
	clcbi	$c12, %capcall20(sumFactorials)($c1)
	cgetnull	$c13
	csw	$2, $zero, 24($c11)     # 4-byte Folded Spill

	# CC: pre call
	cmove $c18, $c11
	cshrink $c11, $c11, 0
	cuninit $c11, $c11
	
	cjalr	$c12, $c17
	nop

	# CC: post call
	cmove $c11, $c18

	sll	$2, $2, 0
	clc	$c17, $zero, 32($c11)   # 32-byte Folded Reload
	cincoffset	$c11, $c11, 64
	cjr	$c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	test
.Lfunc_end4:
	.size	test, .Lfunc_end4-test
	.cfi_endproc
                                        # -- End function
