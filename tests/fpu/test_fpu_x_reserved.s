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

BEGIN_TEST

		#
		# Set up exception handler
		#

		jal	bev_clear
		nop
		dla	$a0, bev0_handler
		jal	bev0_handler_install
		nop

		li $a0, 0
		li $a2, 0

                # Enable CP1  
                dli $t1, 1 << 29
		mfc0 $t0, $12
                or $t0, $t0, $t1    # Enable CP1
                mtc0 $t0, $12

		nop
		nop
		nop
		nop
		nop
		nop

		#
                # A bit pattern that has caused the pipeline to wedge.
		#
		# This bit pattern looks like c.ult.w $23, $19, except
		# that bit 7 is set. The ".w" format isn't valid for
		# compare instructions anyway, so this is an invalid
		# instruction.
		#
		# The standard MIPS ISA should throw a reserved instruction
		# exception; BERI will just ignore it. Whatever happens,
		# the pipeline should not deadlock.
		#

                 .word 0x4693b8b5
                nop
                nop
                nop
                nop
                 .word 0x4693b8b5
                nop
                nop
                nop
                nop

		li	$a0, 1		# Set $a1 to show we got this far

END_TEST

.ent bev0_handler
bev0_handler:
		li	$a2, 1

		mfc0	$a3, $13
		srl	$a3, $a3, 2
		andi	$a3, $a3, 0x1f	# ExcCode

		mfc0	$a4, $13
		srl	$a4, $a4, 28
		andi	$a4, $a4, 0x3

		dmfc0	$a5, $14	# EPC
		daddiu	$k0, $a5, 4	# EPC += 4 to bump PC forward on ERET
		dmtc0	$k0, $14
		DO_ERET
.end bev0_handler

