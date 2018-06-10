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
# Test that CReadHwr raises an exception if the destination register is not accessible.
#

BEGIN_TEST_WITH_COUNTING_TRAP_HANDLER

	# Set the offset field in the special registers so that we can verify
	# they didn't change
	# Note: we can't just clear them, since KCC is needed in the exception
	# handler to derive PCC
	SetCapHwrOffset kr1c, 22
	SetCapHwrOffset kr2c, 23
	SetCapHwrOffset kcc, 29
	SetCapHwrOffset kdc, 30
	SetCapHwrOffset epcc, 31
	cgetnull $c27	# clear $c27 to check that it is not mirrored to hwr 22
	cgetnull $c28	# clear $c28 to check that it is not mirrored to hwr 23

	# The base MIPS trap handler relies on a zero-vaddr $ddc
	SetCapHwrOffset ddc, 0x0

	# remove Access_System_Registers
	dla $t9, without_access_sys_regs
	cgetpccsetoffset $c12, $t9
	dli $t0, ~__CHERI_CAP_PERMISSION_ACCESS_SYSTEM_REGISTERS__
	candperm $c12, $c12, $t0
	cgetpcc $c13 	# store old pcc in $c12
	cjr $c12
	csetoffset $c13, $c13, $zero	# set offset to 0 to simplify checks
without_access_sys_regs:
	cgetpcc $c14	# Check that $pcc doesn't have access system registers
	csetoffset $c14, $c14, $zero	# set offset to 0 to simplify checks

	CFromIntImm $c1, 0xbad1	# Writing value from kernel mode without access sysregs


# Verify that we check for Access_sysregs on the GPR
.macro try_read_hwr0_into_cap_gpr gpr, cause_capreg
	clear_counting_exception_handler_regs
	CReadHwr \gpr, $0
	# Save exception details in cause_capreg
	save_counting_exception_handler_cause \cause_capreg
.endm
	# C31 can no longer be accessed directly -> skip this test for now
	# since we will reuse $c31 as the $cnull. Once that change has been
	# made we should check that writing to c31 is non-trapping
.ifdef CAN_USE_C31_AS_CAP_GPR_EPCC
	try_read_hwr0_into_cap_gpr $c31, $c2
.else
	clear_counting_exception_handler_regs
	teq $zero, $zero	# trap #1
	save_counting_exception_handler_cause $c2
.endif
	# Try to read KDC (should fail - trap #2). Save exception details in $c3
	try_read_hwr0_into_cap_gpr $c30, $c3
	# Try to read KCC (should fail - trap #3). Save exception details in $c4
	try_read_hwr0_into_cap_gpr $c29, $c4
	# KR1C and KR2C should also not be permitted work
	try_read_hwr0_into_cap_gpr $c28, $c5	# Read into KR2C (trap #4)
	try_read_hwr0_into_cap_gpr $c27, $c6	# Read into KR1C (trap #5)

	# But reading into $c26 is fine
	try_read_hwr0_into_cap_gpr $c26, $c7
	# same with $c1
	try_read_hwr0_into_cap_gpr $c1, $c8
	csetdefault $c1

last_trap:
	teq $zero, $zero	# trap #6
	dla $a7, last_trap	# load the address of the last trap inst to verify EPCC
END_TEST
