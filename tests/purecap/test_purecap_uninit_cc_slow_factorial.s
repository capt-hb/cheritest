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
	cincoffset	$c11, $c11, -32
	.cfi_def_cfa_offset 32
                                        # kill: def $a1 killed $a1 killed $a1_64
                                        # kill: def $a0 killed $a0 killed $a0_64
	cincoffset	$c1, $c11, 28
	csetbounds	$c1, $c1, 4
	cincoffset	$c2, $c11, 24
	csetbounds	$c2, $c2, 4
	csw	$4, $zero, 0($c1)
	csw	$5, $zero, 0($c2)
	clw	$1, $zero, 0($c1)
	clw	$2, $zero, 0($c2)
	mult	$1, $2
	mflo	$1
	sll	$2, $1, 0
	cincoffset	$c11, $c11, 32
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
	cincoffset	$c11, $c11, -192
	.cfi_def_cfa_offset 192
	csc	$c17, $zero, 160($c11)  # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
                                        # kill: def $a0 killed $a0 killed $a0_64
	cincoffset	$c2, $c11, 156
	csetbounds	$c2, $c2, 4
	cincoffset	$c3, $c11, 152
	csetbounds	$c3, $c3, 4
	cincoffset	$c4, $c11, 148
	csetbounds	$c4, $c4, 4
	csw	$4, $zero, 0($c2)
	addiu	$2, $zero, 1
	csw	$2, $zero, 0($c3)
	clw	$2, $zero, 0($c2)
	csw	$2, $zero, 0($c4)
	csc	$c1, $zero, 96($c11)    # 32-byte Folded Spill
	csc	$c3, $zero, 64($c11)    # 32-byte Folded Spill
	csc	$c4, $zero, 32($c11)    # 32-byte Folded Spill
	b	.LBB1_1
	nop
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
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
	clc	$c1, $zero, 64($c11)    # 32-byte Folded Reload
	clw	$4, $zero, 0($c1)
	clc	$c2, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$5, $zero, 0($c2)
	clc	$c3, $zero, 96($c11)    # 32-byte Folded Reload
	clcbi	$c12, %capcall20(product)($c3)
	cgetnull	$c13
	cjalr	$c12, $c17
	nop
	clc	$c1, $zero, 64($c11)    # 32-byte Folded Reload
	csw	$2, $zero, 0($c1)
	b	.LBB1_4
	nop
.LBB1_4:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	addiu	$1, $1, -1
	csw	$1, $zero, 0($c1)
	b	.LBB1_1
	nop
.LBB1_5:                                # %for.end
	clc	$c1, $zero, 64($c11)    # 32-byte Folded Reload
	clw	$2, $zero, 0($c1)
	clc	$c17, $zero, 160($c11)  # 32-byte Folded Reload
	cincoffset	$c11, $c11, 192
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
	cincoffset	$c11, $c11, -224
	.cfi_def_cfa_offset 224
                                        # kill: def $a0 killed $a0 killed $a0_64
	cincoffset	$c1, $c11, 192
	csetbounds	$c1, $c1, 32
	cincoffset	$c2, $c11, 188
	csetbounds	$c2, $c2, 4
	cincoffset	$c4, $c11, 184
	csetbounds	$c4, $c4, 4
	cincoffset	$c5, $c11, 180
	csetbounds	$c5, $c5, 4
	csc	$c3, $zero, 0($c1)
	csw	$4, $zero, 0($c2)
	addiu	$1, $zero, 0
	csw	$zero, $zero, 0($c4)
	csw	$zero, $zero, 0($c5)
	csw	$1, $zero, 176($c11)    # 4-byte Folded Spill
	csc	$c1, $zero, 128($c11)   # 32-byte Folded Spill
	csc	$c2, $zero, 96($c11)    # 32-byte Folded Spill
	csc	$c4, $zero, 64($c11)    # 32-byte Folded Spill
	csc	$c5, $zero, 32($c11)    # 32-byte Folded Spill
	b	.LBB2_1
	nop
.LBB2_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	clc	$c2, $zero, 96($c11)    # 32-byte Folded Reload
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
	clc	$c1, $zero, 128($c11)   # 32-byte Folded Reload
	clc	$c2, $zero, 0($c1)
	clc	$c3, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c3)
	dsll	$1, $1, 2
	clw	$2, $1, 0($c2)
	clc	$c2, $zero, 64($c11)    # 32-byte Folded Reload
	clw	$3, $zero, 0($c2)
	addu	$2, $3, $2
	csw	$2, $zero, 0($c2)
	b	.LBB2_4
	nop
.LBB2_4:                                # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	addiu	$1, $1, 1
	csw	$1, $zero, 0($c1)
	b	.LBB2_1
	nop
.LBB2_5:                                # %for.end
	clc	$c1, $zero, 64($c11)    # 32-byte Folded Reload
	clw	$2, $zero, 0($c1)
	cincoffset	$c11, $c11, 224
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
	cincoffset	$c11, $c11, -224
	.cfi_def_cfa_offset 224
	csc	$c17, $zero, 192($c11)  # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
	cincoffset	$c2, $c11, 188
	csetbounds	$c2, $c2, 4
	cincoffset	$c3, $c11, 172
	csetbounds	$c3, $c3, 16
	cincoffset	$c4, $c11, 168
	csetbounds	$c4, $c4, 4
	addiu	$2, $zero, 4
	csw	$2, $zero, 0($c2)
	addiu	$2, $zero, 1
	csw	$2, $zero, 0($c3)
	csw	$2, $zero, 0($c4)
	csc	$c1, $zero, 128($c11)   # 32-byte Folded Spill
	csc	$c2, $zero, 96($c11)    # 32-byte Folded Spill
	csc	$c3, $zero, 64($c11)    # 32-byte Folded Spill
	csc	$c4, $zero, 32($c11)    # 32-byte Folded Spill
	b	.LBB3_1
	nop
.LBB3_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	clc	$c2, $zero, 96($c11)    # 32-byte Folded Reload
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
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$4, $zero, 0($c1)
	clc	$c2, $zero, 128($c11)   # 32-byte Folded Reload
	clcbi	$c12, %capcall20(factorial)($c2)
	cgetnull	$c13
	cjalr	$c12, $c17
	nop
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	dsll	$1, $1, 2
	clc	$c2, $zero, 64($c11)    # 32-byte Folded Reload
	csw	$2, $1, 0($c2)
	b	.LBB3_4
	nop
.LBB3_4:                                # %for.inc
                                        #   in Loop: Header=BB3_1 Depth=1
	clc	$c1, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$1, $zero, 0($c1)
	addiu	$1, $1, 1
	csw	$1, $zero, 0($c1)
	b	.LBB3_1
	nop
.LBB3_5:                                # %for.end
	clc	$c1, $zero, 96($c11)    # 32-byte Folded Reload
	clw	$4, $zero, 0($c1)
	clc	$c2, $zero, 128($c11)   # 32-byte Folded Reload
	clcbi	$c12, %capcall20(sum)($c2)
	clc	$c3, $zero, 64($c11)    # 32-byte Folded Reload
	cgetnull	$c13
	cjalr	$c12, $c17
	nop
	sll	$2, $2, 0
	clc	$c17, $zero, 192($c11)  # 32-byte Folded Reload
	cincoffset	$c11, $c11, 224
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
	cjalr	$c12, $c17
	nop
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
