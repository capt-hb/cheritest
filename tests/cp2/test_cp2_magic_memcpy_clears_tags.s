#-
# Copyright (c) 2018 Alex Richardson
# All rights reserved.
#
# This software was developed by the University of Cambridge Computer
# Laboratory as part of the Rigorous Engineering of Mainstream Systems (REMS)
# project, funded by EPSRC grant EP/K008528/1.
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

.macro CALL_MAGIC_NOP begin, end
	# call qemu_memset()
	dli	$v1, 3		# selector for QEMU magic function
	dli	$v0, 0		# to check return value
	dla	$a0, \begin	# dest = begin_data
	dla	$a1, zerobuffer	# src = 4k of 0x11
	dla	$a2, \end - \begin	# whole buffer
	ori	$zero, $zero, 0xC0DE	# call the magic helper
.endm

.include "tests/cp2/common_code_qemu_magic_nop_clears_tag.s"


.data
.balign 4096
zerobuffer:
.fill 4096, 1, 0x11
