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

# Simple TLB test which configures a TLB entry for the lowest virtual
# page in the xuseg and attempts a load via it.

.set mips64
.set noreorder
.set nobopt

.global test
test:   .ent    test
 		dmtc0	$zero, $5               # Write 0 to page mask i.e. 4k pages
		dmtc0	$zero, $0		# TLB index 
		dmtc0	$zero, $10		# TLB HI address
	
		dla     $a0, testdata		# Load address of testdata in bram
		and     $a1, $a0, 0xffffffe000	# Get physical page (PFN) of testdata (40 bits less 13 low order bits)
		dsrl    $a2, $a1, 6		# Put PFN in correct position for EntryLow
		or      $a2, 0x13   		# Set valid and global bits, uncached
		dmtc0	$a2, $2			# TLB EntryLow0 = k0 (Low half of TLB entry for even virtual address (VPN))
		daddu 	$a3, $a2, 0x40		# Add one to PFN for EntryLow1
		dmtc0	$a3, $3			# TLB EntryLow1 = k0 (Low half of TLB entry for odd virtual address (VPN))
		tlbwi				# Write Indexed TLB Entry

		and     $a4, $a0, 0xfff		# Get offset of testdata within page.
		ld      $a5, 0($a4)		# Load from virtual address

		jr      $ra
		nop
.end    test
	
	.data
	.align 5
testdata:
	.dword 0xfedcba9876543210
