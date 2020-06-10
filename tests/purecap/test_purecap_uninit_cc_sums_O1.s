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
	cincoffset $c4, $c3, $1
	ucsw	$c4, $5, 0($c4)
	daddiu	$3, $3, 1
	bne	$2, $3, .LBB0_2
	addiu	$5, $5, 1
.LBB0_3:                                # %for.cond.cleanup
	clearlo 0xffff
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	cincoffset	$c4, $c3, $1
	addiu	$2, $zero, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	clw	$1, $zero, 0($c3)
	cincoffset	$c3, $c3, 4
	cltu	$3, $c3, $c4
	bnez	$3, .LBB1_2
	addu	$2, $1, $2
# %bb.3:                                # %for.cond.cleanup
	sll	$2, $2, 0
	clearlo 0xfffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
.LBB1_4:
	addiu	$2, $zero, 0
	sll	$2, $2, 0
	clearlo 0xfffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	cincoffset	$c4, $c3, $1
	cincoffset	$c4, $c4, -4
	cltu	$1, $c4, $c3
	bnez	$1, .LBB2_3
	addiu	$2, $zero, 0
# %bb.1:                                # %for.body.preheader
	addiu	$2, $zero, 0
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	clw	$1, $zero, 0($c4)
	cincoffset	$c4, $c4, -4
	cltu	$3, $c4, $c3
	beqz	$3, .LBB2_2
	addu	$2, $1, $2
.LBB2_3:                                # %for.cond.cleanup
	sll	$2, $2, 0
	clearlo 0xfffb
	clearhi 0xffff
	cclearlo 0xfff8
	cclearhi 0xffff
	ccall $c1, $c2, 1
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
	.cfi_def_cfa_offset 160
	ucsc	$c11, $c2, -1($c11)   # 32-byte Folded Spill
	ucsc	$c11, $c1, -1($c11)   # 32-byte Folded Spill
	.cfi_offset 16, -8
	.cfi_offset 90, -64
	.cfi_offset 89, -96
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c18, $1
	clcbi	$c12, %capcall20(integers)($c18)
	# Create array
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	csetbounds $c3, $c11, 40
	cdropuninit $c3, $c3
	# make sure next frame address is multiple of 32
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsd $c11, $zero, -1($c11)
	ucsc $c11, $c18, -1($c11)
	daddiu	$4, $zero, 10
	daddiu	$5, $zero, 1

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

	li $t2, 32
	li $t1, 0xfffffffe 
	cgetpccincoffset $c17, $t2 
	candperm $c17, $c17, $t1
	cseal $c1, $c17, $c13

	# Clear registers
	clearlo 0xffcf
	clearhi 0xffff
	cclearlo 0xe7f0
	cclearhi 0xffff

	# Jump to function
	cjr $c12
	nop

	# CC: post call
	cmove $c11, $idc
	clc $c18, $zero, 0($c11)
	clcbi	$c12, %capcall20(sum)($c18)
	cincoffset $c3, $c11, 56
	csetbounds	$c3, $c3, 40
	cdropuninit $c3, $c3
	daddiu	$4, $zero, 10

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

	li $t2, 32
	li $t1, 0xfffffffe 
	cgetpccincoffset $c17, $t2 
	candperm $c17, $c17, $t1
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
	ucsw $c11, $2, 8($c11)
	clc $c18, $zero, 0($c11)
	clcbi	$c12, %capcall20(backwards_sum)($c18)
	cincoffset $c3, $c11, 56
	csetbounds	$c3, $c3, 40
	cdropuninit $c3, $c3
	daddiu	$4, $zero, 10

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

	li $t2, 32
	li $t1, 0xfffffffe 
	cgetpccincoffset $c17, $t2 
	candperm $c17, $c17, $t1
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
	dli $t0, 32
	clw $16, $t0, 0($c11)
	subu	$2, $16, $2
	clc $c1, $zero, 96($c11)
	clc $c2, $zero, 128($c11)
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
	li $t1, 0xfffffffe # permissions to make capability local
	candperm $c11, $c11, $t1 
	cgetdefault $c13 
	candperm $c13, $c13, $t1 
	.cfi_def_cfa_offset 32
	csc	$c17, $zero, 0($c11)    # 32-byte Folded Spill
	.cfi_offset 89, -32
	lui	$1, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
	daddiu	$1, $1, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
	cgetpccincoffset	$c1, $1
	clcbi	$c12, %capcall20(subtract_sums)($c1)

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

	li $t2, 32
	li $t1, 0xfffffffe 
	cgetpccincoffset $c17, $t2 
	candperm $c17, $c17, $t1
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
