#-
# Copyright (c) 2012, 2015 Michael Roe
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
# Test that an exception is raised if you use cbtu to jump outside the bounds
# of PCC. The exception address is the address of the branch target, not
# the addres of the branch instruction.
#

sandbox:
	        dli	$a0, 1
expected_epc:
		cbtu	$c2, L1
		nop			# Branch delay slot
		cjr     $c24
		nop			# Branch delay slot
		nop
		nop
		nop
		nop
		nop
L1:
		dli	$a0, 2		# Exception should be raised here
		cjr	$c24
		nop

BEGIN_TEST
		#
		# Set up exception handler
		#

		jal	bev_clear
		nop
		dla	$a0, bev0_handler
		jal	bev0_handler_install
		nop

		#
		# $a0 will be set to 1 if sandbox is called
		#

		dli     $a0, 0

		#
		# $a2 will be set to 1 if the exception handler is called
		#

		dli	$a2, 0

		#
		# Set the bounds of $c1
		#

		cgetdefault $c1
		dla	$t0, sandbox
		csetoffset $c1, $c1, $t0
		dla	$t0, 28
		csetbounds $c1, $c1, $t0

		#
		# Put the address of the instruction we expect to raise
		# an exception into $a1
		#

		dla	$a1, expected_epc
		dla	$t0, sandbox
		dsubu	$a1, $a1, $t0

		#
		# Make $c2 an untagged capability so we can branch on it.
		#

		cfromptr $c2, $c1, $zero

		cjalr   $c1, $c24
		nop			# Branch delay slot

finally:
END_TEST

		.ent bev0_handler
bev0_handler:
		li	$a2, 1
		cgetcause $a3
		dmfc0	$a5, $14	# EPC
		cgetdefault $c27
		dla	$k0, finally	# Return to here, not the call site
		csetoffset	$c27, $c27, $k0
		csetepcc	$c27
		dmtc0	$k0, $14
		DO_ERET
		.end bev0_handler

		.data
		.align	3
data:		.dword	0x0123456789abcdef
		.dword  0x0123456789abcdef


