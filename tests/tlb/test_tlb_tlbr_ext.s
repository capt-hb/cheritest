#-
# Copyright (c) 2014, 2015 Michael Roe
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
.include "macros.s"
#
# Test reading from the direct-mapped portion of the BERI1 extended TLB.
#

BEGIN_TEST
		#
		# Check that the CPU supports the BERI extended TLB
		#

		dli	$a0, 0
		mfc0	$t0, $16, 5	# Config5
		andi	$t0, $t0, 0x1	# Extended TLB bit
		beqz	$t0, test_failed
		nop			# branch delay slot

		#
		# Find out how many (normal+extended) TLB entries there are,
		# and enable the extended TLB
		#

		mfc0	$a0, $16, 6
		ori	$a0, $a0, 0x4	# Enable extended TLB
		mtc0	$a0, $16, 6
		srl	$a0, $a0, 16
		addi	$a0, $a0, 1

		#
		# Set the number of wired TLB entries to 1
		#

		dli	$t0, 1
		mtc0	$t0, $6	# TLB Wired

		#
		# Set the page size to 4K
		#

		mtc0	$zero, $5	# TLB Page Mask

		#
		# Loop through the TLB, clearing it
		#

		dmtc0	$zero, $2	# TLB EntryLo0
		dmtc0	$zero, $3	# TLB EntryLo1

		dli	$a3, 1 << 13	# VPN2 field in EntryHi
		ori	$a3, $a3, 1	# ASID to use for page 1
		dli	$a2, 5		# ASID to use when clearing TLB entries

		dli	$a1, 0
loop:
		dmtc0	$a2, $10	# TLB EntryHi
		mtc0	$a1, $0		# TLB Index

		tlbwi

		addi	$a1, $a1, 1
		dadd	$a2, $a2, $a3
		bne	$a1, $a0, loop
		nop			# Branch delay slot

		#
		# Use TLBWR to write a TLB entry for virtual page 1
		#

		dmtc0	$a3, $10	# TLB EntryHi
		tlbwr

		#
		# Find out where it ended up in the TLB
		#

		dmtc0	$a3, $10	# TLB EntryHi
		mtc0	$zero, $0
		tlbp
		mfc0	$a4, $0		# TLB Index


		#
		# Read back the TLB entry
		#

		dmtc0	$zero, $10	# TLB EntryHi
		tlbr
		mfc0	$a5, $10

test_failed:

END_TEST
