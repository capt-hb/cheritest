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

.set mips64
.set noreorder
.set nobopt
.set noat
.include "macros.s"
#
# Simple test for add -- not intended to rigorously check arithmetic
# correctness, rather, register behaviour and instruction interpretation.
# Overflow is left to higher-level tests, as exceptions are implied.
#

		.global start
		.ent start
start:
		#
		# add with independent inputs and outputs; preserve inputs
		# for test framework so we can check they weren't improperly
		# modified.
		#
		li	$s3, 1
		li	$s4, 2
		add	$a0, $s3, $s4

		#
		# add with first input as the output
		#
		li	$t0, 1
		li	$a1, 2
		add	$a1, $a1, $t0

		#
		# add with second input as the output
		#
		li	$t0, 1
		li	$a2, 2
		add	$a2, $t0, $a2

		#
		# add with both inputs the same as the output
		#
		li	$a3, 1
		add	$a3, $a3, $a3

		#
		# Feed output of one straight into the input of another.
		#
		li	$t0, 1
		li	$t1, 2
		li	$t2, 3
		add	$t3, $t0, $t1
		add	$a4, $t3, $t2

		#
		# simple exercises for signed arithmetic
		#
		li	$t0, 1
		li	$t1, -1
		add	$a5, $t0, $t1	# to zero

		li	$t0, -1
		li	$t1, -1
		add	$a6, $t0, $t1	# to negative

		li	$t0, -1
		li	$t1, 2
		add	$a7, $t0, $t1	# to positive

		li	$t0, 1
		li	$t1, -2
		add	$s0, $t0, $t1	# to negative

		# Dump registers in the simulator
		mtc0 $v0, $26
		nop
		nop

		# Terminate the simulator
		mtc0 $v0, $23
		.end start
end:
		b end
		nop
