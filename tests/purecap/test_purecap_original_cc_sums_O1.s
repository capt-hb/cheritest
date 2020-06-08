	.globl	integers                # -- Begin function integers
	.p2align	3
	.type	integers,@function
	.set	nomicromips
	.set	nomips16
	.ent	integers
integers:                               # @integers
	.cfi_startproc
	.frame	$c11,0,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	blez	$4, .LBB0_3
	nop
# %bb.1:                                # %for.body.preheader
	dsll	$1, $4, 32
	dsrl	$2, $1, 32
	daddiu	$3, $zero, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	dsll	$1, $3, 2
	csw	$5, $1, 0($c3)
	daddiu	$3, $3, 1
	bne	$2, $3, .LBB0_2
	addiu	$5, $5, 1
.LBB0_3:                                # %for.cond.cleanup
	cjr	$c17
	nop
	.set	at
	.set	macro
	.set	reorder
	.end	integers
.Lfunc_end0:
	.size	integers, .Lfunc_end0-integers
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
	.frame	$c11,0,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	blez	$4, .LBB1_4
	nop
# %bb.1:                                # %for.body.preheader
	dsll	$1, $4, 2
	cincoffset	$c1, $c3, $1
	addiu	$2, $zero, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	clw	$1, $zero, 0($c3)
	cincoffset	$c3, $c3, 4
	cltu	$3, $c3, $c1
	bnez	$3, .LBB1_2
	addu	$2, $1, $2
# %bb.3:                                # %for.cond.cleanup
	cjr	$c17
	sll	$2, $2, 0
.LBB1_4:
	addiu	$2, $zero, 0
	cjr	$c17
	sll	$2, $2, 0
	.set	at
	.set	macro
	.set	reorder
	.end	sum
.Lfunc_end1:
	.size	sum, .Lfunc_end1-sum
	.cfi_endproc
                                        # -- End function
	.globl	backwards_sum           # -- Begin function backwards_sum
	.p2align	3
	.type	backwards_sum,@function
	.set	nomicromips
	.set	nomips16
	.ent	backwards_sum
backwards_sum:                          # @backwards_sum
	.cfi_startproc
	.frame	$c11,0,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	dsll	$1, $4, 2
	cincoffset	$c1, $c3, $1
	cincoffset	$c1, $c1, -4
	cltu	$1, $c1, $c3
	bnez	$1, .LBB2_3
	addiu	$2, $zero, 0
# %bb.1:                                # %for.body.preheader
	addiu	$2, $zero, 0
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	clw	$1, $zero, 0($c1)
	cincoffset	$c1, $c1, -4
	cltu	$3, $c1, $c3
	beqz	$3, .LBB2_2
	addu	$2, $1, $2
.LBB2_3:                                # %for.cond.cleanup
	cjr	$c17
	sll	$2, $2, 0
	.set	at
	.set	macro
	.set	reorder
	.end	backwards_sum
.Lfunc_end2:
	.size	backwards_sum, .Lfunc_end2-backwards_sum
	.cfi_endproc
                                        # -- End function
	.globl	subtract_sums           # -- Begin function subtract_sums
	.p2align	3
	.type	subtract_sums,@function
	.set	nomicromips
	.set	nomips16
	.ent	subtract_sums
subtract_sums:                          # @subtract_sums
	.cfi_startproc
	.frame	$c11,160,$c17
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# %bb.0:                                # %entry
	cincoffset	$c11, $c11, -160
	.cfi_def_cfa_offset 160
	csd	$16, $zero, 152($c11)   # 8-byte Folded Spill
	csc	$c18, $zero, 96($c11)   # 32-byte Folded Spill
	csc	$c17, $zero, 64($c11)   # 32-byte Folded Spill
	.cfi_offset 16, -8
	.cfi_offset 90, -64
	.cfi_offset 89, -96
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c18, $1
	clcbi	$c12, %capcall20(integers)($c18)
	cincoffset	$c3, $c11, 24
	csetbounds	$c3, $c3, 40
	daddiu	$4, $zero, 10
	daddiu	$5, $zero, 1
	cjalr	$c12, $c17
	cgetnull	$c13
	clcbi	$c12, %capcall20(sum)($c18)
	cincoffset	$c3, $c11, 24
	csetbounds	$c3, $c3, 40
	daddiu	$4, $zero, 10
	cjalr	$c12, $c17
	cgetnull	$c13
	move	$16, $2
	clcbi	$c12, %capcall20(backwards_sum)($c18)
	cincoffset	$c3, $c11, 24
	csetbounds	$c3, $c3, 40
	daddiu	$4, $zero, 10
	cjalr	$c12, $c17
	cgetnull	$c13
	subu	$2, $16, $2
	clc	$c17, $zero, 64($c11)   # 32-byte Folded Reload
	clc	$c18, $zero, 96($c11)   # 32-byte Folded Reload
	cld	$16, $zero, 152($c11)   # 8-byte Folded Reload
	cjr	$c17
	cincoffset	$c11, $c11, 160
	.set	at
	.set	macro
	.set	reorder
	.end	subtract_sums
.Lfunc_end3:
	.size	subtract_sums, .Lfunc_end3-subtract_sums
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
	clcbi	$c12, %capcall20(subtract_sums)($c1)
	cjalr	$c12, $c17
	cgetnull	$c13
	sll	$2, $2, 0
	clc	$c17, $zero, 0($c11)    # 32-byte Folded Reload
	cjr	$c17
	cincoffset	$c11, $c11, 32
	.set	at
	.set	macro
	.set	reorder
	.end	test
.Lfunc_end4:
	.size	test, .Lfunc_end4-test
	.cfi_endproc
                                        # -- End function
