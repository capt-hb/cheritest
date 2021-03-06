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
	csetbounds $c3, $c11, 4
	ucsw	$c11, $5, -1($c11)
	csetbounds $c4, $c11, 4
	clw	$1, $zero, 0($c3)
	clw	$2, $zero, 0($c4)
	mult	$1, $2
	mflo	$1
	sll	$2, $1, 0
	ucsd $c11, $zero, 0($c11)
	clearlo 0xfffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	ucsc	$c11, $c2, -1($c11)  # 32-byte Folded Spill
	ucsc	$c11, $c1, -1($c11)  # 32-byte Folded Spill
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

	# Load seal capability 
	cgetdefault $c13 
	cmove $c4, $c13
	cincoffset $c4, $c4, 1
	cgetlen $t2, $c4
	cgetaddr $t3, $c4
	sub $t2, $t2, $t3
	csetbounds $c4, $c4, $t2
	# Store modified seal capability 
	csetdefault $c4

	# CC: pre call
	cseal $c2, $c11, $c13
	cshrink $c11, $c11, 0
	cuninit $c11, $c11

	li $t2, 28
	cgetpccincoffset $c17, $t2 
	cseal $c1, $c17, $c13

	# Clear registers
	clearlo 0xffcf
	clearhi 0xffff
	cclearlo 0xe7f8
	cclearhi 0xffff

	# Jump to function
	cjr $c12
	nop

	# CC: post call
	cmove $c11, $idc
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
	clc	$c1, $zero, 128($c11)  # 32-byte Folded Reload
	clc	$c2, $zero, 160($c11)  # 32-byte Folded Reload
	ucsd $c11, $zero, 23($c11)
	ucsd $c11, $zero, 22($c11)
	ucsd $c11, $zero, 21($c11)
	ucsd $c11, $zero, 20($c11)
	ucsd $c11, $zero, 19($c11)
	ucsd $c11, $zero, 18($c11)
	ucsd $c11, $zero, 17($c11)
	ucsd $c11, $zero, 16($c11)
	ucsd $c11, $zero, 15($c11)
	ucsd $c11, $zero, 14($c11)
	ucsd $c11, $zero, 13($c11)
	ucsd $c11, $zero, 12($c11)
	ucsd $c11, $zero, 11($c11)
	ucsd $c11, $zero, 10($c11)
	ucsd $c11, $zero, 9($c11)
	ucsd $c11, $zero, 8($c11)
	ucsd $c11, $zero, 7($c11)
	ucsd $c11, $zero, 6($c11)
	ucsd $c11, $zero, 5($c11)
	ucsd $c11, $zero, 4($c11)
	ucsd $c11, $zero, 3($c11)
	ucsd $c11, $zero, 2($c11)
	ucsd $c11, $zero, 1($c11)
	ucsd $c11, $zero, 0($c11)
	clearlo 0xfffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	.frame	$c11,256,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 224
	ucsc $c11, $c2, -1($c11)
	ucsc $c11, $c1, -1($c11)
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
	clc	$c3, $zero, 32($c11)    # 32-byte Folded Reload
	clw	$2, $zero, 0($c3)
	clc $c1, $zero, 192($c11)
	clc $c2, $zero, 224($c11)
	ucsd $c11, $zero, 31($c11)
	ucsd $c11, $zero, 30($c11)
	ucsd $c11, $zero, 29($c11)
	ucsd $c11, $zero, 28($c11)
	ucsd $c11, $zero, 27($c11)
	ucsd $c11, $zero, 26($c11)
	ucsd $c11, $zero, 25($c11)
	ucsd $c11, $zero, 24($c11)
	ucsd $c11, $zero, 23($c11)
	ucsd $c11, $zero, 22($c11)
	ucsd $c11, $zero, 21($c11)
	ucsd $c11, $zero, 20($c11)
	ucsd $c11, $zero, 19($c11)
	ucsd $c11, $zero, 18($c11)
	ucsd $c11, $zero, 17($c11)
	ucsd $c11, $zero, 16($c11)
	ucsd $c11, $zero, 15($c11)
	ucsd $c11, $zero, 14($c11)
	ucsd $c11, $zero, 13($c11)
	ucsd $c11, $zero, 12($c11)
	ucsd $c11, $zero, 11($c11)
	ucsd $c11, $zero, 10($c11)
	ucsd $c11, $zero, 9($c11)
	ucsd $c11, $zero, 8($c11)
	ucsd $c11, $zero, 7($c11)
	ucsd $c11, $zero, 6($c11)
	ucsd $c11, $zero, 5($c11)
	ucsd $c11, $zero, 4($c11)
	ucsd $c11, $zero, 3($c11)
	ucsd $c11, $zero, 2($c11)
	ucsd $c11, $zero, 1($c11)
	ucsd $c11, $zero, 0($c11)
	clearlo 0xfffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	ucsc	$c11, $c2, -1($c11)  # 32-byte Folded Spill
	ucsc	$c11, $c1, -1($c11)  # 32-byte Folded Spill
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

	# Load seal capability 
	cgetdefault $c13 
	cmove $c4, $c13
	cincoffset $c4, $c4, 1
	cgetlen $t2, $c4
	cgetaddr $t3, $c4
	sub $t2, $t2, $t3
	csetbounds $c4, $c4, $t2
	# Store modified seal capability 
	csetdefault $c4

	# CC: pre call
	cseal $c2, $c11, $c13
	cshrink $c11, $c11, 0
	cuninit $c11, $c11

	li $t2, 28
	cgetpccincoffset $c17, $t2 
	cseal $c1, $c17, $c13

	# Clear registers
	clearlo 0xffef
	clearhi 0xffff
	cclearlo 0xe7f8
	cclearhi 0xffff

	# Jump to function
	cjr $c12
	nop

	# CC: post call
	cmove $c11, $idc

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

	# Load seal capability 
	cgetdefault $c13 
	cmove $c4, $c13
	cincoffset $c4, $c4, 1
	cgetlen $t2, $c4
	cgetaddr $t3, $c4
	sub $t2, $t2, $t3
	csetbounds $c4, $c4, $t2
	# Store modified seal capability 
	csetdefault $c4

	# CC: pre call
	cseal $c2, $c11, $c13
	cshrink $c11, $c11, 0
	cuninit $c11, $c11

	li $t2, 28
	cgetpccincoffset $c17, $t2 
	cseal $c1, $c17, $c13

	# Clear registers
	clearlo 0xffef
	clearhi 0xffff
	cclearlo 0xe7f0
	cclearhi 0xffff

	# Jump to function
	cjr $c12
	nop

	# CC: post call
	cmove $c11, $idc

	sll	$2, $2, 0
	clc	$c1, $zero, 160($c11)  # 32-byte Folded Reload
	clc	$c2, $zero, 192($c11)  # 32-byte Folded Reload
	ucsd $c11, $zero, 27($c11)
	ucsd $c11, $zero, 26($c11)
	ucsd $c11, $zero, 25($c11)
	ucsd $c11, $zero, 24($c11)
	ucsd $c11, $zero, 23($c11)
	ucsd $c11, $zero, 22($c11)
	ucsd $c11, $zero, 21($c11)
	ucsd $c11, $zero, 20($c11)
	ucsd $c11, $zero, 19($c11)
	ucsd $c11, $zero, 18($c11)
	ucsd $c11, $zero, 17($c11)
	ucsd $c11, $zero, 16($c11)
	ucsd $c11, $zero, 15($c11)
	ucsd $c11, $zero, 14($c11)
	ucsd $c11, $zero, 13($c11)
	ucsd $c11, $zero, 12($c11)
	ucsd $c11, $zero, 11($c11)
	ucsd $c11, $zero, 10($c11)
	ucsd $c11, $zero, 9($c11)
	ucsd $c11, $zero, 8($c11)
	ucsd $c11, $zero, 7($c11)
	ucsd $c11, $zero, 6($c11)
	ucsd $c11, $zero, 5($c11)
	ucsd $c11, $zero, 4($c11)
	ucsd $c11, $zero, 3($c11)
	ucsd $c11, $zero, 2($c11)
	ucsd $c11, $zero, 1($c11)
	ucsd $c11, $zero, 0($c11)
	clearlo 0xfffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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

	li $t2, 28
	cgetpccincoffset $c17, $t2 
	cseal $c1, $c17, $c13

	# Clear registers
	clearlo 0xffff
	clearhi 0xffff
	cclearlo 0xe7f8
	cclearhi 0xffff

	# Jump to function
	cjr $c12
	nop

	# CC: post call
	cmove $c11, $idc

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
