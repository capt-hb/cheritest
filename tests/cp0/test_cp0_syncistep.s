#-
# Copyright (c) 2013-2014 Michael Roe
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
# Test that the rdhwr instruction can be used to read the synci step size.
#

BEGIN_TEST
		dli $a0, -1

		# SYNCI_step is readable as hardware register 1

		#
		# Try to set bit 1 in CP0.HWREna to enable access to SYNCI_step
		# If the CPU doesn't support it, the bit won't be set.
		#

		li $t0, 2
		mtc0 $t0, $7
		nop		# Pipeline hazard for CP0 update
		nop
		nop
		nop
		nop
		mfc0 $a1, $7
		beqz $a1, L1
		nop		# Branch delay slot

		# The rdhwr instruction is from MIP32r2, so this test is not
		# expected to work on earlier MIPS revisions.

		.set push
		.set mips32r2
		rdhwr	$a0, $1
		.set pop

L1:
END_TEST
