.set mips64
.set noreorder
.set nobopt
.set noat
.include "macros.s"

#
# Test original calling convention gives correct result
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
	cincoffset	$c11, $c11, -96
	.cfi_def_cfa_offset 96
	cincoffset	$c1, $c11, 64
	csetbounds	$c1, $c1, 32
	cincoffset	$c2, $c11, 32
	csetbounds	$c2, $c2, 32
	csc	$c3, $zero, 0($c1)
	csc	$c4, $zero, 0($c2)
	clc	$c1, $zero, 0($c1)
	clw	$1, $zero, 0($c1)
	clc	$c1, $zero, 0($c2)
	clw	$2, $zero, 0($c1)
	addu	$1, $1, $2
                                        # implicit-def: $v1_64
	move	$3, $1
	move	$2, $3
	cincoffset	$c11, $c11, 96
	cjr	$c17
	nop
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
	cincoffset	$c11, $c11, -128
	.cfi_def_cfa_offset 128
	csc	$c17, $zero, 96($c11)   # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
                                        # kill: def $a0 killed $a0 killed $a0_64
	cincoffset	$c2, $c11, 92
	csetbounds	$c2, $c2, 4
	cincoffset	$c3, $c11, 88
	csetbounds	$c3, $c3, 4
	csw	$4, $zero, 0($c2)
	addiu	$2, $zero, 10
	csw	$2, $zero, 0($c3)
	clcbi	$c12, %capcall20(g)($c1)
	csc	$c3, $zero, 32($c11)    # 32-byte Folded Spill
	cmove	$c3, $c2
	clc	$c4, $zero, 32($c11)    # 32-byte Folded Reload
	cgetnull	$c13
	cjalr	$c12, $c17
	nop
	sll	$2, $2, 0
	clc	$c17, $zero, 96($c11)   # 32-byte Folded Reload
	cincoffset	$c11, $c11, 128
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
	.frame	$c11,64,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	cincoffset	$c11, $c11, -64
	.cfi_def_cfa_offset 64
	cld	$1, $zero, 8($c13)
                                        # kill: def $at killed $at killed $at_64
	cld	$2, $zero, 0($c13)
                                        # kill: def $v0 killed $v0 killed $v0_64
                                        # kill: def $t3 killed $t3 killed $t3_64
                                        # kill: def $t2 killed $t2 killed $t2_64
                                        # kill: def $t1 killed $t1 killed $t1_64
                                        # kill: def $t0 killed $t0 killed $t0_64
                                        # kill: def $a3 killed $a3 killed $a3_64
                                        # kill: def $a2 killed $a2 killed $a2_64
                                        # kill: def $a1 killed $a1 killed $a1_64
                                        # kill: def $a0 killed $a0 killed $a0_64
	cincoffset	$c1, $c11, 60
	csetbounds	$c1, $c1, 4
	cincoffset	$c2, $c11, 56
	csetbounds	$c2, $c2, 4
	cincoffset	$c3, $c11, 52
	csetbounds	$c3, $c3, 4
	cincoffset	$c4, $c11, 48
	csetbounds	$c4, $c4, 4
	cincoffset	$c5, $c11, 44
	csetbounds	$c5, $c5, 4
	cincoffset	$c6, $c11, 40
	csetbounds	$c6, $c6, 4
	cincoffset	$c7, $c11, 36
	csetbounds	$c7, $c7, 4
	cincoffset	$c8, $c11, 32
	csetbounds	$c8, $c8, 4
	cincoffset	$c9, $c11, 28
	csetbounds	$c9, $c9, 4
	cincoffset	$c10, $c11, 24
	csetbounds	$c10, $c10, 4
	csw	$4, $zero, 0($c1)
	csw	$5, $zero, 0($c2)
	csw	$6, $zero, 0($c3)
	csw	$7, $zero, 0($c4)
	csw	$8, $zero, 0($c5)
	csw	$9, $zero, 0($c6)
	csw	$10, $zero, 0($c7)
	csw	$11, $zero, 0($c8)
	csw	$2, $zero, 0($c9)
	csw	$1, $zero, 0($c10)
	clw	$1, $zero, 0($c1)
	clw	$2, $zero, 0($c2)
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
	cincoffset	$c11, $c11, 64
	cjr	$c17
	nop
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
	cincoffset	$c11, $c11, -512
	.cfi_def_cfa_offset 512
	csc	$c21, $zero, 480($c11)  # 32-byte Folded Spill
	csc	$c20, $zero, 448($c11)  # 32-byte Folded Spill
	csc	$c19, $zero, 416($c11)  # 32-byte Folded Spill
	csc	$c18, $zero, 384($c11)  # 32-byte Folded Spill
	csc	$c17, $zero, 352($c11)  # 32-byte Folded Spill
	.cfi_offset 93, -32
	.cfi_offset 92, -64
	.cfi_offset 91, -96
	.cfi_offset 90, -128
	.cfi_offset 89, -160
	clc	$c1, $zero, 32($c13)
	clc	$c2, $zero, 0($c13)
	cincoffset	$c12, $c11, 320
	csetbounds	$c12, $c12, 32
	cincoffset	$c13, $c11, 288
	csetbounds	$c13, $c13, 32
	cincoffset	$c14, $c11, 256
	csetbounds	$c14, $c14, 32
	cincoffset	$c15, $c11, 224
	csetbounds	$c15, $c15, 32
	cincoffset	$c16, $c11, 192
	csetbounds	$c16, $c16, 32
	cincoffset	$c17, $c11, 160
	csetbounds	$c17, $c17, 32
	cincoffset	$c18, $c11, 128
	csetbounds	$c18, $c18, 32
	cincoffset	$c19, $c11, 96
	csetbounds	$c19, $c19, 32
	cincoffset	$c20, $c11, 64
	csetbounds	$c20, $c20, 32
	cincoffset	$c21, $c11, 32
	csetbounds	$c21, $c21, 32
	csc	$c3, $zero, 0($c12)
	csc	$c4, $zero, 0($c13)
	csc	$c5, $zero, 0($c14)
	csc	$c6, $zero, 0($c15)
	csc	$c7, $zero, 0($c16)
	csc	$c8, $zero, 0($c17)
	csc	$c9, $zero, 0($c18)
	csc	$c10, $zero, 0($c19)
	csc	$c2, $zero, 0($c20)
	csc	$c1, $zero, 0($c21)
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
	clc	$c17, $zero, 352($c11)  # 32-byte Folded Reload
	clc	$c18, $zero, 384($c11)  # 32-byte Folded Reload
	clc	$c19, $zero, 416($c11)  # 32-byte Folded Reload
	clc	$c20, $zero, 448($c11)  # 32-byte Folded Reload
	clc	$c21, $zero, 480($c11)  # 32-byte Folded Reload
	cincoffset	$c11, $c11, 512
	cjr	$c17
	nop
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
	cincoffset	$c11, $c11, -512
	.cfi_def_cfa_offset 512
	csc	$c19, $zero, 480($c11)  # 32-byte Folded Spill
	csc	$c18, $zero, 448($c11)  # 32-byte Folded Spill
	csc	$c17, $zero, 416($c11)  # 32-byte Folded Spill
	.cfi_offset 91, -32
	.cfi_offset 90, -64
	.cfi_offset 89, -96
                                        # kill: def $t1 killed $t1 killed $t1_64
                                        # kill: def $t0 killed $t0 killed $t0_64
                                        # kill: def $a3 killed $a3 killed $a3_64
                                        # kill: def $a2 killed $a2 killed $a2_64
                                        # kill: def $a1 killed $a1 killed $a1_64
                                        # kill: def $a0 killed $a0 killed $a0_64
	cincoffset	$c1, $c11, 412
	csetbounds	$c1, $c1, 4
	cincoffset	$c2, $c11, 352
	csetbounds	$c2, $c2, 32
	cincoffset	$c9, $c11, 348
	csetbounds	$c9, $c9, 4
	cincoffset	$c10, $c11, 288
	csetbounds	$c10, $c10, 32
	cincoffset	$c12, $c11, 284
	csetbounds	$c12, $c12, 4
	cincoffset	$c13, $c11, 224
	csetbounds	$c13, $c13, 32
	cincoffset	$c14, $c11, 220
	csetbounds	$c14, $c14, 4
	cincoffset	$c15, $c11, 160
	csetbounds	$c15, $c15, 32
	cincoffset	$c16, $c11, 156
	csetbounds	$c16, $c16, 4
	cincoffset	$c17, $c11, 96
	csetbounds	$c17, $c17, 32
	cincoffset	$c18, $c11, 92
	csetbounds	$c18, $c18, 4
	cincoffset	$c19, $c11, 32
	csetbounds	$c19, $c19, 32
	csw	$4, $zero, 0($c1)
	csc	$c3, $zero, 0($c2)
	csw	$5, $zero, 0($c9)
	csc	$c4, $zero, 0($c10)
	csw	$6, $zero, 0($c12)
	csc	$c5, $zero, 0($c13)
	csw	$7, $zero, 0($c14)
	csc	$c6, $zero, 0($c15)
	csw	$8, $zero, 0($c16)
	csc	$c7, $zero, 0($c17)
	csw	$9, $zero, 0($c18)
	csc	$c8, $zero, 0($c19)
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
	clc	$c17, $zero, 416($c11)  # 32-byte Folded Reload
	clc	$c18, $zero, 448($c11)  # 32-byte Folded Reload
	clc	$c19, $zero, 480($c11)  # 32-byte Folded Reload
	cincoffset	$c11, $c11, 512
	cjr	$c17
	nop
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
	csd	$1, $zero, 0($c2)
	csd	$12, $zero, 8($c2)
	csetbounds	$c2, $c2, 16
	ori	$1, $zero, 65495
	candperm	$c2, $c2, $1
	clcbi	$c14, %capcall20(tmp)($c1)
	csc	$c13, $zero, 448($c11)  # 32-byte Folded Spill
	cmove	$c13, $c2
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
	cjalr	$c12, $c17
	nop

	# Test setup: store tmp call result in $13=$t1
	move $13, $2

	cmove	$c1, $c11
	clc	$c2, $zero, 416($c11)   # 32-byte Folded Reload
	csc	$c2, $zero, 0($c1)
	clc	$c3, $zero, 448($c11)   # 32-byte Folded Reload
	csc	$c3, $zero, 32($c1)
	csetbounds	$c1, $c1, 64
	cld	$1, $zero, 112($c11)    # 8-byte Folded Reload
	candperm	$c13, $c1, $1
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
	cjalr	$c12, $c17
	nop

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
	cjalr	$c12, $c17
	nop

	# Test setup: store tmp call result in $15=$t3
	move $15, $2

	clc	$c1, $zero, 384($c11)   # 32-byte Folded Reload
	clcbi	$c12, %capcall20(f)($c1)
	daddiu	$4, $zero, 10
	cgetnull	$c13
	csw	$2, $zero, 100($c11)    # 4-byte Folded Spill
	cjalr	$c12, $c17
	nop
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
