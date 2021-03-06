#-
# Copyright (c) 2014 Robert M. Norton
# Copyright (c) 2012 Robert N. M. Watson
# Copyright (c) 2012 Jonathan Woodruff
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

.include "macros.s"

#
# Test that a very simple TLB handler using the automatically filled
# EntryHi will work as expected with non-zero pcc offset.
#
BEGIN_TEST_WITH_CUSTOM_TRAP_HANDLER
	jal		bev_clear
	nop

	#
	# Set up 'handler' as the RAM exception handler.
	# Note that we set up both common and xtlb handlers
	# because the first miss (with EXL=1) will go to
	# the common handler but subsequent misses (following eret)
	# will go to xtlb miss.
	#
	dla	$a0, bev0_handler
	jal	bev0_handler_install
	nop

	dla	$a0, bev0_handler
	jal	set_bev0_xtlb_handler
	nop

	# Construct virtual address with a length of one page
	dla	$a4, mapped_code
	dli	$a2, 0xFFFFFFFF
	and	$a4, $a2, $a4
	cgetdefault $c1
	cincoffset $c1, $c1, $a4
	dli	$a2, 0x1000
	csetbounds $c1, $c1, $a2

	# Clear registers we'll use when testing results later.
	dli	$a5, 0
	dli	$a6, 0
	dli	$a7, 0
	
	# Jump to new PCC
	cjalr	$c1, $c24
	nop

	dla	$a1, return
	jr	$a1
	nop

	#
	# Instructions to run mapped.
	#
mapped_code:
	# return straight away (after iTLB miss)
	cjr	$c24
	dli	$a5, 0xbeef

return:

END_TEST

#
# Exception handler.  This exception handler sets EPC to the original victim instruction,
# inserts a valid EntryLo for the first physical page of memory, and uses the automatically
# generated EntryHi value to write the TLB.  This is the fast-path, and the general scheme
# used in FreeBSD.
#
.global default_trap_handler
default_trap_handler:
		.ent bev0_handler
bev0_handler:
	li	$a2, 1
tlb_stuff:
	dmfc0	$t0, $8		# Get bad virtual address
	move	$a6, $t0		# Get bad virtual address
	dmfc0	$a7, $14		# Get victim address
	dli 	$t3, 0xFFFFE000	# Mask off the page offset
	and	$t0, $t0, $t3
	dsrl	$a2, $t0, 6             # Put PFN in correct position for EntryLow
	or	$a2, 0x17		# Set valid and uncached bits
	dmtc0   $a2, $2		# TLB EntryLow0 = a2 (Low half of TLB entry for even virtual $
	ori	$a2, 0x1000		# Set the 13th bit for to insert the upper physical address
	dmtc0   $a2, $3		# TLB EntryLow1 = a2 (Upper half of TLB entry for even virtual $
	nop
	nop
	nop
	nop
	tlbwr				# Write Random
	DO_ERET
	.end bev0_handler
