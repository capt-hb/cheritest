#-
# Copyright (c) 2014, 2017 Michael Roe
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-10-C-0237
# ("CTSRD"), as part of the DARPA CRASH research programme.
#
# @BERI_LICENSE_HEADER_START@
#
# Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  BERI licenses this
# file to you under the BERI Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.beri-open-systems.org/legal/license-1-0.txt
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @BERI_LICENSE_HEADER_END@
#

.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test that a 3D instruction in the branch delay slot of JR raises a reserved
# instruction trap.
# 
# This is a regression test for a bug in QEMU.
#
# According to the MIPS ISA, the behavior of this test is UNPREDICTABLE if
# 3D is present and enabled. Although it's UNPREDICTABLE, we would prefer
# if it didn't crash QEMU.
#


.global test
.ent test
test:			
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

		dli	$a2, 0

		dla	$t0, L1

		jr	$t0
		.set	push
		.set	mips3d
		bc1any4f $fcc0, L1	# Should raise reserved instruction
		.set	pop

L1:

		ld	$fp, 16($sp)
		ld	$ra, 24($sp)
		daddu	$sp, $sp, 32
		jr	$ra
		nop
.end test

.ent bev0_handler
bev0_handler:
		li	$a2, 1

		mfc0	$a3, $13
		srl	$a3, $a3, 2
		andi	$a3, $a3, 0x1f	# ExcCode

		mfc0	$a4, $13
		srl	$a4, $a4, 28
		andi	$a4, $a4, 0x3

		dla	$k0, L1
		dmtc0	$k0, $14
		nop
		nop
		nop
		nop
		eret
.end bev0_handler
