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
# Test that writing non-capability data to an address clears the tag bit
#

BEGIN_TEST
		dla	$t0, cap1
		cgetdefault $c1
                csc	$c1, $t0, 0($c1)

		#
		# Load the capability back in from memory, and check that
		# it has the right tag.
		#

                clc      $c2, $t0, 0($c1)

		#
		# Load a0 with a value that can't possibly be a tag, so we
		# can check whether the cgettag worked.
		#

		dli	$a0, 2
                cgettag $a0, $c2

		#
		# Overwrite the first dword of the capability, which should
		# clear the tag bit.
		#

		ld	$t1, 0($t0)
                sd      $t1, 0($t0)

                clc      $c2, $t0, 0($ddc)

		#
		# Load a1 with a value that can't possibly be a tag,
		# so we can check that cgettag worked.
		#

		dli	$a1, 2
                cgettag $a1, $c2

END_TEST

		.data
		.align	5                  # Must 256-bit align capabilities
cap1:		.dword	0x0123456789abcdef # uperms/reserved
		.dword	0x0123456789abcdef # otype/eaddr
		.dword	0x0123456789abcdef # base
		.dword	0x0123456789abcdef # length

