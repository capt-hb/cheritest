#-
# Copyright (c) 2013 Robert M. Norton
# All rights reserved.
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

# Test memory access to regions of address space with no valid mapping, such
# as physical addresses larger than the physical address space (PABITS) and
# virtual addresses higher than the virtual segment size (SEGBITS).        

# Register assignment:
# a0 - desired epc 1
# a1 - actual epc 1
# a2 - desired badvaddr 1
# a3 - actual badvaddr 1
# a4 - cause 1
# a5 - desired epc 2
# a6 - actual  epc 2
# a7 - desired badvaddr 2
# s0 - actual  badvaddr 2
# s1 - cause 2

.include "macros.s"

BEGIN_TEST

		#
		# Set up 'handler' as the RAM exception handler.
		#
		jal	bev_clear
		nop

		dla	$a0, bev0_handler
		jal	bev0_handler_install
		nop

		dla	$a0, bev0_handler
		jal	set_bev0_xtlb_handler
		nop


		dli	$s0, 0
		dli	$s1, 0
		dli	$s2, 0

                dla     $a0, desired_epc1
                dla     $a2, 0x0001000000100000
desired_epc1:	ld      $a5, 0($a2)		# Load from bad user space virtual address (virtual address too large)
                move    $a1, $s0                # stash EPC
                move    $a3, $s1                # stash bad addr
                move    $a4, $s2                # stash cause

		dli	$s0, 0
		dli	$s1, 0
		dli	$s2, 0

                dla     $a5, desired_epc2
                dla     $a7, 0x9801000000100000
desired_epc2:	ld      $a7, 0($a7)		# Load from bad kernel space address (too large for physical address space)
                move    $a6, $s0                # stash EPC  
                move    $s0, $s1                # stash bad addr
                move    $s1, $s2                # stash cause

return:
END_TEST

#
# Exception handler.  
#
		.ent bev0_handler
bev0_handler:
		dmfc0   $s0, $14      		# EPC
		daddu   $t0, $s0, 4		# Increment EPC
		dmtc0   $t0, $14		# and store it back
		dmfc0	$s1, $8			# BadVAddr
		dmfc0	$s2, $13		# Cause
		DO_ERET
		.end bev0_handler

