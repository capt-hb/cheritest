#-
# Copyright (c) 2012 Robert M. Norton
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

# Test for conditional branches taking one argument. Tests different
# offsets covering the whole 16-bit range as well as various argument
# values and branch types. The test is centered around the instruction
# labelled 'branch', which targets the one labelled 'target' (except
# for some small offsets). Padding is added before or after the branch
# to acheive the correct spacing. s0-s5 are used to keep track of the
# path taken.

# arg_val: 0x80000000
# offset: -131072==0xfffffffffffe0000
# op: BLTZALL

.set mips64
.set noreorder
.set nobopt
.set noat

.global test
test:   .ent    test
	daddu   $sp, -16
	sd	$ra, 0($sp)
	sd      $fp, 8($sp)
	daddu   $fp, $sp, 16
	dla     $a0, 0x80000000
	li      $s0, 0
	li      $s1, 0
	li      $s2, 0
	li      $s3, 0
	li      $s4, 0
	li      $s5, 0

.if -131072 < 0
    	j       branch			# Skip over the padding to save time
	add     $s0, 1			# Branch delay
	add     $s1, 1			# Not executed
target:	add     $s2, 1			# should land here (offset<0)
	j	out   			# Skip to end of test
	add     $s3, 1			# Branch delay
.rept   -4-(-131072)/4			# Might be < 0 for some offsets i.e. no padding
	j	.			# Padding (minefield, not executed)
.endr
.endif # -131072 < 0
branch:	BLTZALL     $a0, .+-131072+4	# Add 4 because AS offset is relative to . but MIPS is relative to .+4
	add     $s4, 1  		# Delay slot, executed twice if offset==0!
	add     $s5, 1  		# Might not be executed if branch taken
.if -131072 > 0
	j       target			# Skip over the padding to save time
	add	$s0, 1			# Branch delay
.rept  (-131072)/4 - 5			# Might be < 0 for some offsets i.e. no padding
	j	.      	 	    	# Padding (minefield, not executed)
.endr
	add     $s1, 1			# Not executed except when offset is 3 or 4
target:	add     $s2, 1			# should land here (offset>0)
.endif # -131072 > 0
out:	move    $a1, $ra		# Hide away the value of ra from the branch
	ld      $ra, 0($sp)
	ld      $fp, 8($sp)
	jr      $ra
	daddu   $sp, 16
.end    test
