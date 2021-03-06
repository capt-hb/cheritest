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

.include "macros.s"
.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test cfromptr when the pointer is not NULL.
#

BEGIN_TEST
		dli	$a0, 2
		dli	$a1, 2

		#
		# Make $c1 a capability for 'data1', length 8, offset 2
		# 

		cgetdefault $c1
		dla	$t0, data1
		csetoffset $c1, $c1, $t0
		dli	$t0, 8
		csetbounds $c1, $c1, $t0
		dli	$t0, 2
		csetoffset $c1, $c1, $t0	
		dli	$t0, 0x3
		candperm $c1, $c1, $t0
		
		#
		# Make $c2 a capability for 'data2', length 16, offset 3
		# (fields different from $c1)
		#

		cgetdefault $c2
		dla	$t0, data2
		csetoffset $c2, $c2, $t0
		dli	$t0, 16
		csetbounds $c2, $c2, $t0
		dli	$t0, 3
		csetoffset $c2, $c2, $t0

		dli	$t0, 4
		cfromptr $c1, $c2, $t0

		#
		# Check the fields have been copied from $c2
		#

		cgetperm $a0, $c1
		cgetbase $a1, $c1
		dla	 $t0, data2
		dsubu	 $a1, $t0
		cgetlen  $a2, $c1
		cgetoffset $a3, $c1
		cgettag  $a4, $c1
		cgetsealed $a5, $c1

END_TEST

		.data
		.align 5
data1:		.dword 0
data2:		.dword 0
		.dword 0

