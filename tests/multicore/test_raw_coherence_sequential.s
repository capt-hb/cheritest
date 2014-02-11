#-
# Copyright (c) 2013 Alan A. Mujumdar
# Copyright (c) 2011 Robert N. M. Watson
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
# ("CTSRD"), as part of the DARPA CRASH research programme.
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
#

.set mips64
.set noreorder
.set nobopt
.set noat

#
# Exercise cache instructions
#
# Execute a series of cache instructions that are found in the kernel.  We
# currently don't check if they are correct, but merely check that they don't
# lock up the processor.  Since we have a write-through L1 cache, the only 
# function of the cache instructions is to synchronize L1 instruction and data
# caches.  We don't currently support cache instructions to the L2.
# 
#

		.global start
start:
		#
		# Setup Stack
		#
		mfc0    $k0, $12
		li      $k1, 0xF0000000 
		or      $k0, $k0, $k1 
		mtc0    $k0, $12 
		dla     $sp, __sp
		mfc0    $t0, $15, 1
		andi    $t0, $t0, 0xFFFF
		dli     $k0, 0x400  
		mul     $k0, $k0, $t0    
		daddu   $sp, $sp, $k0
		daddu   $sp, $sp, -64 
		
		bnez    $t0, core_1_corr1
		nop
		j       core_0_corr1 
		nop   

# CoRR1 Test 
# Core 0 sets initial values (zero's) in two memory location (x and y)
# Each memory location is then changed to 1's in the order x then y
core_0_corr1:
                # setup test address
                dla     $gp, dword
                dli     $t0, 0x00ffffffffffffff
                and     $gp, $gp, $t0 
                dli     $t0, 0x9800000000000000
                daddu   $t0, $gp, $t0
                addi    $t1, $zero, 1
                sd      $t1, 8($t0)
               
                # store test variables 
                addi    $t1, $zero, 1
                sd      $t1, 0($t0)
                addi    $t1, $t1, 1
                sd      $t1, 0($t0)

                ld      $a2, 0($t0)
                ld      $a3, 0($t0)
	
		j       core_0_coww
		nop		

# CoRR1 Test
# Core 1 checks memory location y to see if its init value has been changed
# If it has then memory location x is read
# If x is still zero then this is a serious coherence failure
core_1_corr1:		
                # setup test address
                dla     $gp, dword
                dli     $t0, 0x00ffffffffffffff
                and     $gp, $gp, $t0 
                dli     $t0, 0x9800000000000000
                daddu   $t0, $gp, $t0
                j       core_1_loads
                nop

core_1_loads:
                ld      $t2, 8($t0)
                addi    $t3, $zero, 1
                bne     $t2, $t3, core_1_loads
                nop
                ld      $a0, 0($t0)
                ld      $a1, 0($t0)
		j       core_1_coww
		nop

#CoWW Test
core_0_coww:
                addi    $t1, $zero, 7
                addi    $t2, $zero, 9
                sw      $t1, 0($t0)
                sw      $t2, 0($t0)
                j       core_0_corw 
                nop

core_1_coww:
                ld      $a2, 0($t0)
                j       core_1_corw
                nop

#CoRW1 Test
core_0_corw:
                addi    $t1, $zero, 3
                lw      $a0, 16($t0)  
                sw      $t1, 16($t0)
                j       finish
                nop

core_1_corw:
                addi    $t1, $zero, 6
                lw      $a3, 24($t0)  
                sw      $t1, 24($t0)
                j       finish
                nop
               
# End all tests
finish:
		# Dump registers in the simulator
		mtc0    $v0, $26 
		nop
		nop                

                # Terminate the simulator 
                # many nop's are needed to ensure that both cores have enough
                # time to dump the register file. From experiments its clear
                # that even when cores in sync, one of them will kill the 
                # simulator before the second one has had a chance to finish
                # the dump 
                nop
                nop 
                nop
                nop 
                nop
                nop 
                nop
                nop 
                nop
                nop 
                nop
                nop 
                nop
                nop 
                nop
                nop 
                nop
                nop 
                nop
                nop 
                nop
                nop 
                nop
                nop 

                mtc0    $v0, $23 

end:
		b       end
		nop

dword:          .dword  0x0123456789abcdef
