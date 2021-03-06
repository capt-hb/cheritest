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
# Test that clc raises an exception if the address is not aligned.
#

BEGIN_TEST
		# $a2 will be set to 1 if the exception handler is called
		dli	$a2, 0

		#
		# Make $c1 a data capability for the array 'data'
		#

		cgetdefault $c1
		dla     $t0, data
		csetoffset $c1, $c1, $t0
		dli     $t0, 8
                csetbounds $c1, $c1, $t0
		dli     $t0, 0x7f
		candperm $c1, $c1, $t0
		dli	$t0, 1
		csetoffset $c1, $c1, $t0

		#
		# Store $c1 to padding (aligned)
		#

		dla     $t0, padding
		csc     $c1, $t0, 0($ddc)

		#
		# Clear $c1 so we can tell if the load happened
		#

		cgetnull $c1

		#
		# Reload from an unaligned address
		#

		dla     $t0, cap1
		check_instruction_traps $s1, clc $c1, $t0, 0($ddc) # This should raise an exception

		#
		# Check that the load didn't happen.
		#

		cgettag $a0, $c1
		cgetoffset $a1, $c1

END_TEST

		.data
		.align	3
data:		.dword	0x0123456789abcdef
		.dword  0x0123456789abcdef

		.align 5
padding:	.dword 0x0 # Padding to make cap1 unaligned

cap1:		.dword 0x0123456789abcdef # This is not 32-byte aligned, so a
		.dword 0x0123456789abcdef # capability load from here will 
		.dword 0x0123456789abcdef # raise an exception.
		.dword 0x0123456789abcdef

