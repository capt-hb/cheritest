#-
# Copyright (c) 2018 Alex Richardson
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

# Test that an exception is raised if an unconditional branch goes
# outside the range of PCC (before the delay slot).
.macro branch_out_of_bounds bad_addr_gpr

		dmfc0 $at, $12
		dli $t1, (1 << 29) | (1 << 26)	# Enable CP1 and put FPU into 64 bit mode
		or $at, $at, $t1
		mtc0 $at, $12

		dli $at, 0
		dmtc1	$zero, $f0
		dmtc1	$zero, $f2
		c.eq.d	$fcc1, $f0, $f2

		bc1f	$fcc1, out_of_bounds	# branch should not be taken -> no trap
		nop
		bc1t	$fcc1, out_of_bounds	# taken -> trap
.endm

.include "tests/cp2/common_code_mips_branch_out_of_bounds.s"
