.set mips64
.set noreorder
.set nobopt
.set noat
.include "macros.s"

#
# Test uninit calling convention gives correct result
#
	.globl	g                       # -- Begin function g
	.p2align	3
	.type	g,@function
	.set	nomicromips
	.set	nomips16
	.ent	g
g:                                      # @g
	.cfi_startproc
	.frame	$c11,96,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 96
	ucsc $c11, $c3, -1($c11)
	csetbounds	$c13, $c11, 32
	ucsc $c11, $c4, -1($c11)
	csetbounds $c14, $c11, 32
	clc	$c13, $zero, 0($c13)
	clw	$1, $zero, 0($c13)
	clc	$c13, $zero, 0($c14)
	clw	$2, $zero, 0($c13)
	addu	$1, $1, $2
                                        # implicit-def: $v1_64
	move	$3, $1
	move	$2, $3
	ucsc $c11, $cnull, 1($c11)
	ucsc $c11, $cnull, 0($c11)
	clearlo 0x1ffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	.frame	$c11,128,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 128
	ucsc	$c11, $c1, -1($c11)   # 32-byte Folded Spill
	ucsc	$c11, $c2, -1($c11)   # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
                                        # kill: def $a0 killed $a0 killed $a0_64
	ucsw $c11, $4, -1($c11)
	csetbounds $c2, $c11, 4

	addiu	$2, $zero, 10

	ucsw	$c11, $2, -1($c11)
	csetbounds $c3, $c11, 4 # $c3 = &x

	clcbi	$c12, %capcall20(g)($c1)
	ucsw $c11, $zero, -1($c11)
	ucsw $c11, $zero, -1($c11)
	ucsw $c11, $zero, -1($c11)
	ucsw $c11, $zero, -1($c11)
	ucsw $c11, $zero, -1($c11)
	ucsw $c11, $zero, -1($c11)
	ucsc $c11, $c3, -1($c11)

	cmove	$c3, $c2 # $c3 = &a
	clc	$c4, $zero, 0($c11)     # $c4 = &x
	cgetnull	$c13

	# Load seal capability 
	cgetdefault $c13 
	cmove $c5, $c13
	cincoffset $c5, $c5, 1
	cgetlen $s1, $c5
	cgetaddr $s2, $c5
	sub $s1, $s1, $s2
	csetbounds $c5, $c5, $s1
	# Store modified seal capability 
	csetdefault $c5

	# CC: pre call
	cseal $c2, $c11, $c13    # Seal old stack capability
	cshrink $c11, $c11, 0
	cuninit $c11, $c11
	dli $s1, 28
	cgetpccincoffset $c17, $s1 
	cseal $c1, $c17, $c13 # Seal return capability
	clearlo 0x1ffb
	clearhi 0xffff
	cclearlo 0xe7e0
	cclearhi 0xffff
	cjr $c12
	nop

	# CC: post call
	cmove $c11, $idc

	sll	$2, $2, 0
	clc	$c1, $zero, 96($c11)   # 32-byte Folded Reload
	clc	$c2, $zero, 64($c11)   # 32-byte Folded Reload

	ucsc $c11, $cnull, 3($c11)
	ucsc $c11, $cnull, 2($c11)
	ucsd $c11, $zero, 7($c11)
	ucsd $c11, $zero, 6($c11)
	ucsd $c11, $zero, 5($c11)
	ucsd $c11, $zero, 4($c11)
	ucsc $c11, $cnull, 0($c11)
	clearlo 0x1ffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	.frame	$c11,64,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 64
	cld	$1, $zero, 8($c11)
                                        # kill: def $at killed $at killed $at_64
	cld	$2, $zero, 0($c11)
                                        # kill: def $v0 killed $v0 killed $v0_64
                                        # kill: def $t3 killed $t3 killed $t3_64
                                        # kill: def $t2 killed $t2 killed $t2_64
                                        # kill: def $t1 killed $t1 killed $t1_64
                                        # kill: def $t0 killed $t0 killed $t0_64
                                        # kill: def $a3 killed $a3 killed $a3_64
                                        # kill: def $a2 killed $a2 killed $a2_64
                                        # kill: def $a1 killed $a1 killed $a1_64
                                        # kill: def $a0 killed $a0 killed $a0_64
	ucsw	$c11, $4, -1($c11)
	csetbounds $c13, $c11, 4
	ucsw	$c11, $5, -1($c11)
	csetbounds $c14, $c11, 4
	ucsw	$c11, $6, -1($c11)
	csetbounds $c3, $c11, 4
	ucsw	$c11, $7, -1($c11)
	csetbounds $c4, $c11, 4
	ucsw	$c11, $8, -1($c11)
	csetbounds $c5, $c11, 4
	ucsw	$c11, $9, -1($c11)
	csetbounds $c6, $c11, 4
	ucsw	$c11, $10, -1($c11)
	csetbounds $c7, $c11, 4
	ucsw	$c11, $11, -1($c11)
	csetbounds $c8, $c11, 4
	ucsw	$c11, $2, -1($c11)
	csetbounds $c9, $c11, 4
	ucsw	$c11, $1, -1($c11)
	csetbounds $c10, $c11, 4

	clw	$1, $zero, 0($c13)
	clw	$2, $zero, 0($c14)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c3)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c4)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c5)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c6)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c7)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c8)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c9)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c10)
	addu	$1, $1, $2
                                        # implicit-def: $v1_64
	move	$3, $1
	move	$2, $3
	cgetnull	$c13
	ucsd $c11, $zero, 6($c11)
	ucsd $c11, $zero, 5($c11)
	ucsd $c11, $zero, 4($c11)
	ucsd $c11, $zero, 3($c11)
	ucsd $c11, $zero, 2($c11)
	ucsd $c11, $zero, 1($c11)
	ucsd $c11, $zero, 0($c11)
	clearlo 0x1ffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	.frame	$c11,512,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 512
	ucsc $c11, $c2, -1($c11)
	ucsc $c11, $c1, -1($c11)
	.cfi_offset 93, -32
	.cfi_offset 92, -64
	.cfi_offset 91, -96
	.cfi_offset 90, -128
	.cfi_offset 89, -160

	clc	$c1, $zero, 64($c11)
	clc	$c2, $zero, 96($c11)

	ucsc	$c11, $c3, -1($c11)
	csetbounds $c12, $c11, 32
	ucsc	$c11, $c4, -1($c11)
	csetbounds $c13, $c11, 32
	ucsc	$c11, $c5, -1($c11)
	csetbounds $c14, $c11, 32
	ucsc	$c11, $c6, -1($c11)
	csetbounds $c15, $c11, 32
	ucsc	$c11, $c7, -1($c11)
	csetbounds $c16, $c11, 32
	ucsc	$c11, $c8, -1($c11)
	csetbounds $c17, $c11, 32
	ucsc	$c11, $c9, -1($c11)
	csetbounds $c18, $c11, 32
	ucsc	$c11, $c10, -1($c11)
	csetbounds $c19, $c11, 32
	ucsc	$c11, $c2, -1($c11)
	csetbounds $c20, $c11, 32
	ucsc	$c11, $c1, -1($c11)
	csetbounds $c21, $c11, 32

	clc	$c1, $zero, 0($c12)
	clw	$1, $zero, 0($c1)
	clc	$c1, $zero, 0($c13)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c14)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c15)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c16)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c17)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c18)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c19)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c20)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c21)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
                                        # implicit-def: $v1_64
	move	$3, $1
	move	$2, $3
	cgetnull	$c13
	clc	$c1, $zero, 320($c11)  # 32-byte Folded Reload
	clc	$c2, $zero, 352($c11)  # 32-byte Folded Reload
	ucsc $c11, $cnull, 11($c11)
	ucsc $c11, $cnull, 10($c11)
	ucsc $c11, $cnull, 9($c11)
	ucsc $c11, $cnull, 8($c11)
	ucsc $c11, $cnull, 7($c11)
	ucsc $c11, $cnull, 6($c11)
	ucsc $c11, $cnull, 5($c11)
	ucsc $c11, $cnull, 4($c11)
	ucsc $c11, $cnull, 3($c11)
	ucsc $c11, $cnull, 2($c11)
	ucsc $c11, $cnull, 1($c11)
	ucsc $c11, $cnull, 0($c11)
	clearlo 0x1ffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	.frame	$c11,512,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	.cfi_def_cfa_offset 512
	ucsc	$c11, $c2, -1($c11)  # 32-byte Folded Spill
	ucsc	$c11, $c1, -1($c11)  # 32-byte Folded Spill
	.cfi_offset 91, -32
	.cfi_offset 90, -64
	.cfi_offset 89, -96
                                        # kill: def $t1 killed $t1 killed $t1_64
                                        # kill: def $t0 killed $t0 killed $t0_64
                                        # kill: def $a3 killed $a3 killed $a3_64
                                        # kill: def $a2 killed $a2 killed $a2_64
                                        # kill: def $a1 killed $a1 killed $a1_64
                                        # kill: def $a0 killed $a0 killed $a0_64
	ucsw	$c11, $4, -1($c11)
	csetbounds $c1, $c11, 4
	ucsw $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)

	ucsc	$c11, $c3, -1($c11)
	csetbounds $c2, $c11, 32
	ucsw	$c11, $5, -1($c11)
	csetbounds $c9, $c11, 4
	ucsw $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)

	ucsc	$c11, $c4, -1($c11)
	csetbounds $c10, $c11, 32
	ucsw	$c11, $6, -1($c11)
	csetbounds $c12, $c11, 4
	ucsw $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)

	ucsc	$c11, $c5, -1($c11)
	csetbounds $c13, $c11, 32
	ucsw	$c11, $7, -1($c11)
	csetbounds $c14, $c11, 4
	ucsw $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)

	ucsc	$c11, $c6, -1($c11)
	csetbounds $c15, $c11, 32
	ucsw	$c11, $8, -1($c11)
	csetbounds $c16, $c11, 4
	ucsw $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)

	ucsc	$c11, $c7, -1($c11)
	csetbounds $c17, $c11, 32
	ucsw	$c11, $9, -1($c11)
	csetbounds $c18, $c11, 4
	ucsw $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)

	ucsc	$c11, $c8, -1($c11)
	csetbounds $c19, $c11, 32

	clw	$1, $zero, 0($c1)
	clc	$c1, $zero, 0($c2)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c9)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c10)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c12)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c13)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c14)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c15)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
	clw	$2, $zero, 0($c16)
	addu	$1, $1, $2
	clc	$c1, $zero, 0($c17)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
                                        # implicit-def: $v1_64
	move	$3, $1
	move	$2, $3
	clc	$c1, $zero, 384($c11)  # 32-byte Folded Reload
	clc	$c2, $zero, 416($c11)  # 32-byte Folded Reload
	ucsd $c11, $zero, 47($c11)
	ucsd $c11, $zero, 46($c11)
	ucsd $c11, $zero, 45($c11)
	ucsd $c11, $zero, 44($c11)
	ucsc $c11, $cnull, 10($c11)
	ucsd $c11, $zero, 39($c11)
	ucsd $c11, $zero, 38($c11)
	ucsd $c11, $zero, 37($c11)
	ucsd $c11, $zero, 36($c11)
	ucsc $c11, $cnull, 8($c11)
	ucsd $c11, $zero, 31($c11)
	ucsd $c11, $zero, 30($c11)
	ucsd $c11, $zero, 29($c11)
	ucsd $c11, $zero, 28($c11)
	ucsc $c11, $cnull, 6($c11)
	ucsd $c11, $zero, 23($c11)
	ucsd $c11, $zero, 22($c11)
	ucsd $c11, $zero, 21($c11)
	ucsd $c11, $zero, 20($c11)
	ucsc $c11, $cnull, 4($c11)
	ucsd $c11, $zero, 15($c11)
	ucsd $c11, $zero, 14($c11)
	ucsd $c11, $zero, 13($c11)
	ucsd $c11, $zero, 12($c11)
	ucsc $c11, $cnull, 2($c11)
	ucsd $c11, $zero, 7($c11)
	ucsd $c11, $zero, 6($c11)
	ucsd $c11, $zero, 5($c11)
	ucsd $c11, $zero, 4($c11)
	ucsc $c11, $cnull, 0($c11)
	clearlo 0x1ffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	.frame	$c11,576,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	cincoffset	$c11, $c11, -576
	li $t1, 0xfffffffe # permissions to make capability local
	candperm $c11, $c11, $t1 
	cgetdefault $c13 
	candperm $c13, $c13, $t1 
	.cfi_def_cfa_offset 576
	csc	$c17, $zero, 544($c11)  # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
	cincoffset	$c2, $c11, 540
	csetbounds	$c2, $c2, 4
	cincoffset	$c3, $c11, 536
	csetbounds	$c3, $c3, 4
	cincoffset	$c4, $c11, 532
	csetbounds	$c4, $c4, 4
	cincoffset	$c5, $c11, 528
	csetbounds	$c5, $c5, 4
	cincoffset	$c6, $c11, 524
	csetbounds	$c6, $c6, 4
	cincoffset	$c7, $c11, 520
	csetbounds	$c7, $c7, 4
	cincoffset	$c8, $c11, 516
	csetbounds	$c8, $c8, 4
	cincoffset	$c9, $c11, 512
	csetbounds	$c9, $c9, 4
	cincoffset	$c10, $c11, 508
	csetbounds	$c10, $c10, 4
	cincoffset	$c12, $c11, 504
	csetbounds	$c12, $c12, 4
	cincoffset	$c13, $c11, 500
	csetbounds	$c13, $c13, 4
	addiu	$2, $zero, 0
	csw	$zero, $zero, 0($c2)
	addiu	$3, $zero, 1
	csw	$3, $zero, 0($c3)
	addiu	$3, $zero, 2
	csw	$3, $zero, 0($c4)
	addiu	$3, $zero, 3
	csw	$3, $zero, 0($c5)
	addiu	$3, $zero, 4
	csw	$3, $zero, 0($c6)
	addiu	$3, $zero, 5
	csw	$3, $zero, 0($c7)
	addiu	$3, $zero, 6
	csw	$3, $zero, 0($c8)
	addiu	$3, $zero, 7
	csw	$3, $zero, 0($c9)
	addiu	$3, $zero, 8
	csw	$3, $zero, 0($c10)
	addiu	$3, $zero, 9
	csw	$3, $zero, 0($c12)
	addiu	$3, $zero, 10
	csw	$3, $zero, 0($c13)
	clw	$4, $zero, 0($c3)
	clw	$5, $zero, 0($c4)
	clw	$6, $zero, 0($c5)
	clw	$7, $zero, 0($c6)
	clw	$8, $zero, 0($c7)
	clw	$9, $zero, 0($c8)
	clw	$10, $zero, 0($c9)
	clw	$11, $zero, 0($c10)
	clw	$1, $zero, 0($c12)
	clw	$12, $zero, 0($c13)
	cmove	$c2, $c11
	clcbi	$c14, %capcall20(tmp)($c1)
	csc	$c13, $zero, 448($c11)  # 32-byte Folded Spill
	csc	$c12, $zero, 416($c11)  # 32-byte Folded Spill
	cmove	$c12, $c14
	csc	$c1, $zero, 384($c11)   # 32-byte Folded Spill
	csc	$c3, $zero, 352($c11)   # 32-byte Folded Spill
	csc	$c4, $zero, 320($c11)   # 32-byte Folded Spill
	csc	$c5, $zero, 288($c11)   # 32-byte Folded Spill
	csc	$c6, $zero, 256($c11)   # 32-byte Folded Spill
	csc	$c7, $zero, 224($c11)   # 32-byte Folded Spill
	csc	$c8, $zero, 192($c11)   # 32-byte Folded Spill
	csc	$c9, $zero, 160($c11)   # 32-byte Folded Spill
	csc	$c10, $zero, 128($c11)  # 32-byte Folded Spill

	csw	$2, $zero, 124($c11)    # 4-byte Folded Spill
	csd	$1, $zero, 112($c11)    # 8-byte Folded Spill

	# CC: pre call
	clc $c14, $zero, 416($c11)
	clc $c15, $zero, 448($c11)

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

	cseal $c2, $c11, $c13    
	cshrink $c11, $c11, 0
	cuninit $c11, $c11

	clw $1, $zero, 0($c14) # $1 = 9  (first arg passed on stack)
	clw $2, $zero, 0($c15) # $2 = 10 (snd arg passed on stack)
	ucsd $c11, $1, -1($c11)
	ucsd $c11, $2, -1($c11)

	dli $s1, 28
	cgetpccincoffset $c17, $s1
	cseal $c1, $c17, $c13 
	clearlo 0xe00f
	clearhi 0xffff
	cclearlo 0xc7f8
	cclearhi 0xffff
	cjr $c12
	nop

	# CC: post call
	cmove $c11, $idc

	# Test setup: store tmp call result in $13=$t1
	move $13, $2

	cld	$1, $zero, 112($c11)    # 8-byte Folded Reload
	clc	$c1, $zero, 384($c11)   # 32-byte Folded Reload
	clcbi	$c12, %capcall20(cap_tmp)($c1)
	clc	$c3, $zero, 352($c11)   # 32-byte Folded Reload
	clc	$c4, $zero, 320($c11)   # 32-byte Folded Reload
	clc	$c5, $zero, 288($c11)   # 32-byte Folded Reload
	clc	$c6, $zero, 256($c11)   # 32-byte Folded Reload
	clc	$c7, $zero, 224($c11)   # 32-byte Folded Reload
	clc	$c8, $zero, 192($c11)   # 32-byte Folded Reload
	clc	$c9, $zero, 160($c11)   # 32-byte Folded Reload
	clc	$c10, $zero, 128($c11)  # 32-byte Folded Reload
	csw	$2, $zero, 108($c11)    # 4-byte Folded Spill

	# CC: pre call
	# Load seal capability 
	cgetdefault $c14
	cmove $c15, $c14
	cincoffset $c15, $c15, 1
	cgetlen $s1, $c15
	cgetaddr $s2, $c15
	sub $s1, $s1, $s2
	csetbounds $c15, $c15, $s1
	# Store modified seal capability 
	csetdefault $c15

	clc	$c15, $zero, 416($c11)   # 32-byte Folded Reload
	clc	$c13, $zero, 448($c11)   # 32-byte Folded Reload
	cseal $c2, $c11, $c14
	cshrink $c11, $c11, 0
	cuninit $c11, $c11
	ucsc	$c11, $c15, -1($c11)
	ucsc	$c11, $c13, -1($c11)
	dli $s1, 28
	cgetpccincoffset $c17, $s1
	cseal $c1, $c17, $c14
	clearlo 0x1fef
	clearhi 0xffff
	cclearlo 0xe000
	cclearhi 0xffff
	cjr $c12
	nop 

	# CC: post call
	cmove $c11, $idc

	# Test setup: store tmp call result in $14=$t2
	move $14, $2

	clc	$c1, $zero, 352($c11)   # 32-byte Folded Reload
	clw	$4, $zero, 0($c1)
	clc	$c2, $zero, 288($c11)   # 32-byte Folded Reload
	clw	$5, $zero, 0($c2)
	clc	$c3, $zero, 224($c11)   # 32-byte Folded Reload
	clw	$6, $zero, 0($c3)
	clc	$c4, $zero, 160($c11)   # 32-byte Folded Reload
	clw	$7, $zero, 0($c4)
	clc	$c5, $zero, 416($c11)   # 32-byte Folded Reload
	clw	$1, $zero, 0($c5)
	clc	$c6, $zero, 384($c11)   # 32-byte Folded Reload
	clcbi	$c12, %capcall20(mixed_tmp)($c6)
	clc	$c3, $zero, 320($c11)   # 32-byte Folded Reload
	clc	$c4, $zero, 256($c11)   # 32-byte Folded Reload
	clc	$c5, $zero, 192($c11)   # 32-byte Folded Reload
	clc	$c6, $zero, 128($c11)   # 32-byte Folded Reload
	move	$8, $1
	clc	$c7, $zero, 448($c11)   # 32-byte Folded Reload
	move	$9, $1
	clc	$c8, $zero, 448($c11)   # 32-byte Folded Reload
	cgetnull	$c13
	csw	$2, $zero, 104($c11)    # 4-byte Folded Spill

	# CC: pre call
	# Load seal capability 
	cgetdefault $c14
	cmove $c15, $c14
	cincoffset $c15, $c15, 1
	cgetlen $s1, $c15
	cgetaddr $s2, $c15
	sub $s1, $s1, $s2
	csetbounds $c15, $c15, $s1
	# Store modified seal capability 
	csetdefault $c15

	cmove $idc, $c11
	cseal $c2, $c11, $c14
	cshrink $c11, $c11, 0
	cuninit $c11, $c11
	dli $s1, 28
	cgetpccincoffset $c17, $s1
	cseal $c1, $c17, $c14
	clearlo 0x1c0f
	clearhi 0xff00
	cclearlo 0xe700
	cclearhi 0xffff

	cjr	$c12
	nop

	# CC: post call
	cmove $c11, $idc

	# Test setup: store tmp call result in $15=$t3
	move $15, $2


	clc	$c1, $zero, 384($c11)   # 32-byte Folded Reload
	clcbi	$c12, %capcall20(f)($c1)
	daddiu	$4, $zero, 10
	cgetnull	$c13
	csw	$2, $zero, 100($c11)    # 4-byte Folded Spill

	# Load seal capability 
	cgetdefault $c13 
	cmove $c3, $c13
	cincoffset $c3, $c3, 1
	cgetlen $s1, $c3
	cgetaddr $s2, $c3
	sub $s1, $s1, $s2
	csetbounds $c3, $c3, $s1
	# Store modified seal capability 
	csetdefault $c3

	# CC: pre call
	cseal $c2, $c11, $c13    
	cshrink $c11, $c11, 0
	cuninit $c11, $c11
	dli $s1, 28
	cgetpccincoffset $c17, $s1
	cseal $c1, $c17, $c13 
	clearlo 0x1fef
	clearhi 0xffff
	cclearlo 0xe7f8
	cclearhi 0xffff
	cjr $c12
	nop 

	# CC: post call
	cmove $c11, $idc
	sll	$2, $2, 0
	clc	$c17, $zero, 544($c11)  # 32-byte Folded Reload
	cincoffset	$c11, $c11, 576
	cjr	$c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	test
.Lfunc_end5:
	.size	test, .Lfunc_end5-test
	.cfi_endproc
                                        # -- End function
	.global	test                    # -- Begin function test
	.ent	test
