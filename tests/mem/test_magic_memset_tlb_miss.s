#-
# Copyright (c) 2012 Robert M. Norton
# All rights reserved.
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

# TLB test which configures a TLB entry and attempts a store via it,
# but without setting the valid bit. This should result in a TLB
# Invalid exception which differs from a TLB Refill exception
# in the vector user.

# Register usage:
# a0: paddr of testdata
# a1: PFN of testdata
# a2: EntryLo0 value
# a3: EntryLo1 value
# a4: Vaddr of testdata
# a5: Result of load 
# a6: Expected PC of faulting instruction
# a7: Final value of testdata

# s0: BadVAddr
# s1: Context
# s2: XContext
# s3: EntryHi
# s4: Status
# s5: Cause
# s6: EPC

.include "macros.s"

page=0xafa # A randomly chosen (even) page
BEGIN_TEST_WITH_CUSTOM_TRAP_HANDLER
		#
		# Save the desired EPC value for this exception so we can
		# check it later.
		#
		dla	$a6, desired_epc

	
 		dmtc0	$zero, $5               # Write 0 to page mask i.e. 4k pages
		dmtc0	$zero, $0		# TLB index
		li      $t0, (page<<12)
		dmtc0	$t0, $10		# TLB HI address
	
		dla     $a0, testdata		# Load address of testdata in bram
		and     $a1, $a0, 0xffffffe000	# Get physical page (PFN) of testdata (40 bits less 13 low order bits)
		dsrl    $a2, $a1, 6		# Put PFN in correct position for EntryLow
		or      $a2, 0x11   		# Set valid and global bits, uncached
		dmtc0	$a2, $2			# TLB EntryLow0 = k0 (Low half of TLB entry for even virtual address (VPN))
		daddu 	$a3, $a2, 0x40		# Add one to PFN for EntryLow1
		dmtc0	$a3, $3			# TLB EntryLow1 = k0 (Low half of TLB entry for odd virtual address (VPN))
		tlbwi				# Write Indexed TLB Entry

		nop
		nop
		nop
		and     $a4, $a0, 0xfff		# Get offset of testdata within page.
		add     $a4, (page<<12)	        # Add page number
		# prepare magic memset args
		move	$t2, $a0	# save paddr $a0 for later
		move	$a0, $a4	# unmapped vaddr
		dli	$a1, 0xab	# value
		dli	$a2, 1		# one byte
		dli	$v1, 1		# memset selector
		dli	$v0, 0		# needed for memset
desired_epc:
		#sd      $a5, 0($a4)		# Store to virtual address
		check_instruction_traps $s5, ori $zero, $zero, 0xc0de	# call memset
		nop
		ld      $a7, 0($t2)		# Check that the store didn't work...
return:
END_TEST

#
# Exception handler.  
BEGIN_CUSTOM_TRAP_HANDLER
		collect_compressed_trap_info compressed_info_reg=$k1, tmp_reg=$k0, trap_count_reg=$s7
		dmfc0   $s6, $14		# EPC
		daddu   $t0, $s6, 4		# Increment EPC
		dmtc0   $t0, $14		# and store it back
		dmfc0	$s0, $8			# BadVAddr
		dmfc0	$s1, $4			# Context
		dmfc0	$s2, $20		# XContext
		dmfc0	$s3, $10		# EntryHi
		dmfc0   $s4, $12	      	# Status
		DO_ERET
END_CUSTOM_TRAP_HANDLER

	.data
	.align 7
testdata:
	.dword 0xfedcba9876543210
