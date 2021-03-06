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

.if CAP_SIZE==128
		cap_width = 16
.else
		cap_width = 32
.endif

#
# Perform a few basic tests involving capability register length: query the
# starting length of $c2, reduce the length, and query it again.
#

BEGIN_TEST
		dla	$t0, cap1
		cgetdefault	$c1
		csc 	$c1, $t0, 0($ddc)
		clc 	$c2, $t0, 0($ddc)
		cgettag $a0, $c2
		cgetdefault $c1
		ccleartag $c1, $c1
		csc 	$c1, $t0, 0($ddc)
		clc 	$c2, $t0, 0($ddc)
		cgettag $a1, $c2
		
		# Exercise a potential victim buffer in the tag cache.
		dla	$t1, cap1-0x4000000	# A conflicting address
		dla	$t2, cap1+0x1000	# A different address
		cgetdefault	$c1
		# Store a valid cap to an address that conflicts with one in the cache.
		csc 	$c1, $t1, 0($ddc)
		# Load data from the old address, swapping with the victim buffer.
		clc 	$c2, $t0, 0($ddc)
		# Load another address, evicting the victim buffer
		clc 	$c3, $t2, 0($ddc)
		# Load the evicted address to see if it has the tag set
		clc 	$c1, $t1, 0($ddc)
		cgettag	$a2, $c1
		
		# Store data on either side of capability to ensure the tag is preserved. 
		cgetdefault	$c1
		# Store a valid cap
		csc 	$c1, $t1, 0($ddc)
		# Store general-purpose data just before the capability
		sd	$t0, -8($t0)
		# Store general-purpose data just after the capability
		sd	$t0, cap_width($t0)
		# Load the evicted address to see if it has the tag set
		clc 	$c1, $t1, 0($ddc)
		cgettag	$a3, $c1

END_TEST

		.data
		.align	5		# Must 256-bit align capabilities
buffer:		.dword	0x0123456789abcdef # uperms/reserved
		.dword	0x0123456789abcdef # otype/eaddr
		.dword	0x0123456789abcdef # base
		.dword	0x0123456789abcdef # length
.if CAP_SIZE==128			   # More interesting alignment for 128 case.
		.dword	0x0123456789abcdef
		.dword	0x0123456789abcdef
.endif
cap1:		.dword	0x0123456789abcdef # uperms/reserved
		.dword	0x0123456789abcdef # otype/eaddr
		.dword	0x0123456789abcdef # base
		.dword	0x0123456789abcdef # length

