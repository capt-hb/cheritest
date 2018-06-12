#-
# Copyright (c) 2011 Robert N. M. Watson
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
# Test csbr (store byte via capability, offset by register) using a privileged
# capability.
#
BEGIN_TEST
		cgetdefault $c1
		dla	$t0, data
		dli	$t2, 0x01
		csb 	$t2, $t0, 0($c1)

		daddiu	$t0, $t0, 1
		dli	$t2, 0x23
		csb 	$t2, $t0, 0($c1)

		daddiu	$t0, $t0, 1
		dli	$t2, 0x45
		csb 	$t2, $t0, 0($c1)

		daddiu	$t0, $t0, 1
		dli	$t2, 0x67
		csb 	$t2, $t0, 0($c1)

		daddiu	$t0, $t0, 1
		dli	$t2, 0x89
		csb 	$t2, $t0, 0($c1)

		daddiu	$t0, $t0, 1
		dli	$t2, 0xab
		csb 	$t2, $t0, 0($c1)

		dli	$t2, 0xcd
		daddiu	$t0, $t0, 1
		csb 	$t2, $t0, 0($c1)

		dli	$t2, 0xef
		daddiu	$t0, $t0, 1
		csb 	$t2, $t0, 0($c1)

		#
		# Load using regular MIPS instructions for checking.
		#
		dla	$t3, underflow
		ld	$a0, 0($t3)
		dla	$t3, data
		ld	$a1, 0($t3)
		dla	$t3, overflow
		ld	$a2, 0($t3)

END_TEST

		.data
		.align 3
underflow:	.dword	0x0000000000000000
data:		.dword	0x0000000000000000
overflow:	.dword	0x0000000000000000
