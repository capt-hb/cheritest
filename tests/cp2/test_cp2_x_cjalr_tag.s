#-
# Copyright (c) 2012 Michael Roe
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
# Test that cjalr raises an exception if tag bit is not set on the capability
# register (i.e. it doesn't contain a capability).
#

sandbox:
		dli	$a0, 1
		cjr	$c24
		nop			# Branch delay slot

BEGIN_TEST
		#
		# Set up exception handler
		#

		jal	bev_clear
		nop
		dla	$a0, bev0_handler
		jal	bev0_handler_install
		nop

		# $a2 will be set to 1 if the exception handler is called
		dli	$a2, 0

		dla     $t0, sandbox
		cgetdefault $c1
		csetoffset $c1, $c1, $t0

		#
		# Write $c1 to memory, overwrite its otype field in memory,
		# and load it back in to $c2. The write to the otype field
		# should clear the tag bit.
		#

		dla	$t0, cap1
		csc 	$c1, $t0, 0($ddc)
		dli	$t1, 5
		sw	$t1, 0($t0)
		clc 	$c2, $t0, 0($ddc)

		dli	$a0, 0
		cjalr   $c2, $c24 # This should raise a C2E exception
		nop	# Branch delay slot

END_TEST

		.ent bev0_handler
bev0_handler:
		li	$a2, 1
		cgetcause $a3
		dmfc0	$a5, $14	# EPC
		daddiu	$k0, $a5, 4	# EPC += 4 to bump PC forward on ERET
		dmtc0	$k0, $14
		DO_ERET
		.end bev0_handler

		.data

		.align 5
cap1:		.dword	0x0123456789abcdef	# uperms/reserved
		.dword	0x0123456789abcdef	# otype/eaddr
		.dword	0x0123456789abcdef	# base
		.dword	0x0123456789abcdef	# length

		.align	3
data:		.dword	0x0123456789abcdef
		.dword  0x0123456789abcdef

