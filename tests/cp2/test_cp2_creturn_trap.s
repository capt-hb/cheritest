#-
# Copyright (c) 2013 Michael Roe
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
# ("CTSRD"), as part of the DARPA CRASH research programme.
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
#

.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test CReturn
#

sandbox:

		# $a2 will be set to 1 if the normal trap handler is called,
		# 2 if the ccall/creturn trap handler is called.
		dli	$a2, 0

		creturn
		nop 		# branch delay slot
		j	L1
		nop

		.global test
test:		.ent test
		daddu 	$sp, $sp, -32
		sd	$ra, 24($sp)
		sd	$fp, 16($sp)
		daddu	$fp, $sp, 32

		#
		# Set up exception handler
		#

		jal	bev_clear
		nop
		dla	$a0, bev0_handler
		jal	bev0_handler_install
		nop

		#
		# Set up trap handler for CCall/CReturn
		#

		dli	$a0, 0xffffffff80000280
		dla	$a1, bev0_ccall_handler_stub
		dli	$a2, 9 		# 32-bit instruction count
		dsll	$a2, 2		# Convert to byte count
		jal memcpy
		nop			# branch-delay slot

		#
		# Create a capability for the trusted system stack
		#

		dla	$t0, trusted_system_stack
		cincbase $c1, $c0, $t0
		dli     $t0, 96
		csetlen $c1, $c1, $t0
		dla	$t0, tsscap
		cscr    $c1, $t0($c0)

		#
		# Initialize the pointer into the trusted system stack
		#

		dla	$t0, tssptr
		dli	$t1, 0
		csdr	$t1, $t0($c0)

		#
		# Fake the effect of having done a CCall without using
		# the CCall instruction
		#

		dla	$t1, L1
		csdi    $t1, 0($c1)
		csci    $c0, 32($c1)
		csci	$c0, 64($c1)

		#
		# Discard the permissions to access the reserved registers
		#

		dli     $t0, 0x1ff
		candperm $c1, $c0, $t0

		#
		# Run 'sandbox' with restricted permissions
		#

		dla     $t0, sandbox
		cjr     $t0($c1)
		nop	# branch delay slot

L1:

		# The creturn should have restored all privileges to $pcc.
		# Check that it has.
		cgetpcc $t0($c1)
		cgetperm $a6, $c1
		
		
		ld	$fp, 16($sp)
		ld	$ra, 24($sp)
		daddu	$sp, $sp, 32
		jr	$ra
		nop			# branch-delay slot
		.end	test

		.ent bev0_handler
bev0_handler:
		li	$a2, 1
		cgetcause $a3
		dmfc0	$a5, $14	# EPC
		daddiu	$k0, $a5, 4	# EPC += 4 to bump PC forward on ERET
		dmtc0	$k0, $14
		nop
		nop
		nop
		nop
		eret
		.end bev0_handler

		.ent bev0_ccall_handler
bev0_ccall_handler:
		li      $a2, 2
		cgetcause $a3
		# When the exception happened, $kcc should have been copied
		# to $pcc.
		cgetpcc $k0($c28)
		cgetperm $a4, $c28

		#
		# Load a capability for the trusted system stack into
		# kernel reserved capability register 2 ($c28)
		#
		# $c27 should already be a capability for the kernel's
		# data segment
		#

		dla     $k0, tsscap
		clcr	$c28, $k0($c27)

		#
		# Pop the EPCC off the trusted system stack, so it will
		# restored to the user's PCC when this exception handler
		# returns to user space.
		#

		dla	$k0, tssptr
		cldr	$k0, $k0($c27)
		clc	$c31, $k0, 32($c28)

		#
		# Pop the return address off the trusted system stack into
		# EPC, so it will be returned to when this exception handler
		# returns to user space.
		#

		dla	$k0, tssptr
		cldr	$k0, $k0($c27)
		cldr	$k0, $k0($c28)
		dmtc0	$k0, $14

		# cmove $c31, $c1
		# dmfc0   $a5, $14
		# daddiu  $k0, $a5, 4 # Bump EPC forward one instruction
		# dmtc0   $k0, $14
		nop
		nop
		nop
		nop
		eret
		.end bev0_ccall_handler

		.ent bev0_ccall_handler_stub
bev0_ccall_handler_stub:
		dla     $k0, bev0_ccall_handler
		jr      $k0
		nop
		.end bev0_ccall_handler_stub

		.data

		.align 3
tssptr:
		.dword 0

		.align 5
tsscap:
		.dword 0
		.dword 0
		.dword 0
		.dword 0

		.align 5
trusted_system_stack:
		.dword 0
		.dword 0
		.dword 0
		.dword 0
		.dword 0
		.dword 0
		.dword 0
		.dword 0
		.dword 0
		.dword 0
		.dword 0
		.dword 0
