#-
# Copyright (c) 2012 Robert M. Norton
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

# Template for TLB tests. The idea is to program a TLB entry for a given 
# page, segment and asid and then switch to a given mode and:
# 1) Jump to code in the mapped virtual page (this is necessary because 
#    in user mode it is only possible to access virtual addresses).
# 2) Perform a load and a store via a virtual address in that segment, 
#    corresponding to testdata.
# 3) Perform a syscall to get back into kernel mode
# 4) Verify that the store worked by doing a load from the physical address
# At the end we loop forever if either of the memory accesses did not achieve
# the required result because otherwise the test could pass if gxemul and 
# cheri both fail to perform the accesses in the same way (because of a badly
# programmed TLB).

# index: 0==0x0
# cached: 2==0x2
# asid: 255==0xff
# valid: 0==0x0
# mode: 2==0x2
# segment: 0==0x0
# page: 0==0x0
# dirty: 1==0x1

.set mips64
.set noreorder
.set nobopt
#.set noat yesat

# Register allocation:
# a0: address of testdata
# a1: virtual address of mapped page
# a2: PFN of testdata
# a3: Value of entryLow0
# a4: Value of entryLow1
# a5: Result of test load from virtual address
# a6: Value of entryHi
# a7: Result of test load from physical address following store to virtual address
# t0: temporary value
# s0: offset of testdata within page
# s1: virtual address of testdata
# s2: virtual address of testcode
# s3: BadVAddr
# s4: Context
# s5: XContext
# s6: EntryHi
# s7: Status
# v0: Cause
# v1: EPC

# Test parameters:
# mode:	   2
# page:    0
# segment: 0
# asid:    255
# index:   0
# valid:   0
# dirty:   1
# cached:  2

.global test
test:   .ent    test
		daddu   $sp, -16
		sd	$ra, 0($sp)
		sd      $fp, 8($sp)
		daddu   $fp, $sp, 16

.if 2 == 2 && 0 != 0
    	        # TODO User mode is incompatible with non-user segment.
    	       	j      exit
		nop
.endif

		jal    bev_clear
		nop

		# Install exception handler
		dla	$a0, exception_handler
		jal 	bev0_handler_install
		nop		

		dli     $t0, 0x0
 		dmtc0	$t0, $5                       # Write 0 to page mask i.e. 4k pages

		dla     $a0, testdata			# Load address of testdata in bram

		dli 	$t0, 0			# TLB index
		dmtc0	$t0, $0			# TLB index = t0

		dli     $a1, ((0 << 62)|(0 << 13))		# TLB HI address (BRAM) Virtual address 63:62 == 00 means kernel user segment
		or      $a6, $a1, 255               # Or in the asid
		dmtc0	$a6, $10			# TLB HI address

		and     $a2, $a0, 0xffffffe000	# Get physical page (PFN) of testdata (40 bits less 13 low order bits)
		dsrl    $a3, $a2, (12-6)		# Put PFN in correct position for EntryLow
		or      $a3, ((0<<1)|(1<<2)) # Set valid, dirty bits
.if 2 
		or      $a3, 0x10   			# uncached
.else
		or      $a3, 0x18   			# cacheable
.endif
.if 255 == 0
		or      $a3, 0x1   			# Set global bit
.endif
		dmtc0	$a3, $2			# TLB EntryLow0 = k0 (Low half of TLB entry for even virtual address (VPN))
		daddu 	$a4, $a3, 0x40		# Add one to PFN for EntryLow1
		dmtc0	$a4, $3			# TLB EntryLow1 = k0 (Low half of TLB entry for odd virtual address (VPN))

		and     $s0, $a0, 0xfff 		# Get offset of testdata within page.
		daddu   $s1, $s0, $a1		# Construct an address

		tlbwi					# Write Indexed TLB Entry

		mfc0  $t0, $12                        # Read status reg
		or    $t0, (2 << 3)		# Set the mode
		
		daddu $s2, $s1, 8
		jr    $s2				# Jump to virtual address because we might be switching to user mode.
		mtc0  $t0, $12      			# Set status reg -- switch mode in branch delay.
		
after_test:		
		or      $t0, $a0, 0x0800000000000000  # Set the cachable bit in address so that we are sure to get a fresh value.
		ld      $a7, 0($t0)			# Load testdata unmapped, cached to check store worked.
exit:
		ld      $ra, 0($sp)
		ld      $fp, 8($sp)
		jr      $ra
		daddu   $sp, 16
.end    test
	
	.data
	.align 5
testdata:
		.dword 0xfedcba9876543210
testcode:
		ld      $a5, 0($s1)			# Test read from virtual address.

		dli     $t0, 0x1020304050607080
		sd      $t0, 0($s1)			# Test store to virtual address.
		syscall

exception_handler:
		dmfc0	$s3, $8	# BadVAddr
		dmfc0	$s4, $4	# Context
		dmfc0	$s5, $20	# XContext
		dmfc0	$s6, $10	# EntryHi
		dmfc0   $s7, $12      # Status
		and     $s7, 2		# Extract EXL bit
		dmfc0	$v0, $13	# Cause
		and     $v0, 0x7c	# Extract ExcCode
		dmfc0   $v1, $14      # EPC
		dla	$t0, after_test
		jr	$t0
		nop
