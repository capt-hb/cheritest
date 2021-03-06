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
#

.include "macros.s"
#
# Check that the badinstr register is implemented
#

BEGIN_TEST_WITH_CUSTOM_TRAP_HANDLER
		#
		# Clear registers we'll use when testing results later.
		dli	$a1, -1
		dli	$s1, -2


		teq	$zero, $zero
		move	$s1, $a1
		move	$s2, $a2

		# load config3 register
		dmfc0	$a3, $16, 3

return:
END_TEST

BEGIN_CUSTOM_TRAP_HANDLER
		dmfc0	$a1, $8, 1	# BadInstr register
		collect_compressed_trap_info compressed_info_reg=$a2

		dmfc0	$a5, $14	# EPC
		daddiu	$k0, $a5, 4	# EPC += 4 to bump PC forward on ERET
		dmtc0	$k0, $14
		DO_ERET
END_CUSTOM_TRAP_HANDLER

