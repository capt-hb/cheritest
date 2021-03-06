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
# Test rdhwr of register 29 (the user local register) on a multi-core
# CPU.
#

BEGIN_TEST
		#
		# At the beginning, all threads other than thread zero will
		# be spinning on reset_barrier. Thread zero will call
		# other_threads_go to start the other threads running; other
		# threads skip this part.
		#

		dmfc0	$t0, $15, 7		# Thread Id ...
		andi	$t1, $t0, 0xffff	# ... in bottom 16 bits
		bnez	$t1, L1			# If we're not thread zero
		nop	# branch delay slot
		
		dmfc0	$t0, $15, 6		# Core Id ...
		andi	$t1, $t0, 0xffff	# ... in bottom 16 bits
		bnez	$t1, L1			# If we're not core zero
		nop				# Branch delay slot

		jal	other_threads_go
		nop	# branch delay slot

L1:

		dmfc0	$t0, $15, 6		# Core Id (again)
		dmtc0	$t0, $4, 2		# Store in user local register
		nop				# Possible pipeline hazard
		nop
		nop
		nop
		nop

		dla	$a0, start_barrier	# Wait for other threads`
		jal	thread_barrier
		nop	# branch delay slot

		#
		# Read the user local register with rdhwr.
		# rdhwr is a mips32r2 instruction, so need to tell the
		# assembler that this is supported by the CPU.
		#

		.set push
		.set mips32r2
		rdhwr	$t0, $29
		.set pop

		dmfc0	$t1, $15, 6		# Core Id
		beq	$t0, $t1, test_ok	# Should equal user local
		nop	# branch delay slot

		#
		# If we reach here, the test has failed. Write -1 to
		# test_result to indicate failure. Don't bother locking
		# test_result, even though multiple threads might be writing
		# to it, because they're all writing the same thing.
		#
		# XXX: Do we need some kind of sync here?
		#

		dla	$t0, test_result
		dli	$t1, -1
		sd	$t1, 0($t0)
		sync

test_ok:
		#
		# Wait for the other threads to finish. If they fail, they
		# might write -1 to test_result.
		#

		dla	$a0, end_barrier
		jal	thread_barrier
		nop

		#
		# Find out whether any of the other threads failed the test.
		#

		dla	$t0, test_result
		sync
		ld	$a0, 0($t0)

END_TEST

		.data

test_result:
		.align	3
		.dword	0

start_barrier:
		mkBarrier

end_barrier:
		mkBarrier
