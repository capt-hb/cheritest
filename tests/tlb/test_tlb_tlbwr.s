#-
# Copyright (c) 2014 Michael Roe
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
# Test the pseudo-random number generator used by TLBWR.
# In BERI1, it's not very random (intentionally, to make trace comparison
# easy): it decrements by 1 every time TLBWR is called.
#

BEGIN_TEST
		#
		# Find out how many TLB entries there are
		#

		mfc0	$a0, $16, 1	# Config1
		srl	$a0, $a0, 25
		andi	$a0, $a0, 0x3f
		addi	$a0, $a0, 1

		#
		# Set the number of wired TLB entries to 0
		#

		mtc0	$zero, $6	# TLB Wired

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
		dli	$a2, 5		# ASID to use for TLB entries

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
		# Use TLBR to write a TLB entry for virtual page 1
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
		# Clear the entry for page 1
		#

		dmtc0	$a2, $10	# TLB EntryHi
		dadd	$a2, $a2, $a3
		tlbwi

		#
		# Use TLBWR to write page 1 again
		#

		dmtc0	$a3, $10	# TLB EntryHi
		tlbwr

		#
		# See where it ended up this time
		#

		dmtc0	$a3, $10	# TLB EntryHi
		mtc0	$zero, $0
		tlbp
		mfc0	$a5, $0		# TLB Index

		mfc0	$a6, $1		# TLB Random

END_TEST
