#-
# Copyright (c) 2013 Michael Roe
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
.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test that writing from the floating point unit to an address clears the tag
# bit
#

BEGIN_TEST
		# If the floating point unit is not present, skip the test
		dmfc0	$t0, $16, 1
		andi	$t0, $t0, 0x1
		beq	$t0, $zero, no_fpu
		nop	# Branch delay slot

		#
		# Enable the floating point unit
		#

		mfc0 $t0, $12		# Status Register
		li $t1, 1 << 29		# CP1 Usable
		or $t0, $t0, $t1
		mtc0 $t0, $12
		nop			# Potential pipeline hazard
		nop
		nop
		nop

		# Store a capability into cap1

		dla	$t0, cap1
		cgetdefault $c1
                csc     $c1, $t0, 0($c1)


		# Overwrite the first field of cap1 with a float

		dla	$t1, v1
		lw	$a0, 0($t1)
		mtc1	$a0, $f1
		swc1	$f1, 0($t0)

		# Clear $a0 so we can tell if it gets reloaded by mfc1

		dli	$a0, 0

		# Reload the stored value with a floating point instruction

		lwc1    $f2, 0($t0)
		mfc1    $a0, $f2

		# Reload the stored value as a 32-bit word

		clw	$a1, $t0, 0($ddc)

		# Reload the stored value as a capability

		clc 	$c1, $t0, 0($ddc)

		# The tag bit should have been cleared by the FP store

		cgettag  $a2, $c1

no_fpu:
END_TEST

		.data
		.align 3
v1:		.word 0x01234567

		.align	5                  # Must 256-bit align capabilities
cap1:		.dword	0x0123456789abcdef # uperms/reserved
		.dword	0x0123456789abcdef # otype/eaddr
		.dword	0x0123456789abcdef # base
		.dword	0x0123456789abcdef # length

