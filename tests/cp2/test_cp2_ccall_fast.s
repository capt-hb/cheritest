#-
# Copyright (c) 2016-2017 Alexandre Joannou
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
BEGIN_TEST

                #
                # Remove the permission to access reserved registers from
                # PCC. (CCall should work even if the caller does not have
                # permission to access reserved registers).
                #

                cgetpcc     $c1
                dli         $t0, 0x1ff
                candperm    $c1, $c1, $t0
                dla         $t0, L1
                csetoffset  $c1, $c1, $t0
                cjr         $c1
                nop                         # branch delay slot
L1:
                #
                # Make $c4 a template capability for user-defined type
                # number 0x1234.
                #

                dli         $t0, 0x1234
                cgetdefault $c4
                csetoffset $c4, $c4, $t0

                #
                # Make $c3 a data capability for the array at address data
                #

                dla         $t0, data
                cgetdefault $c3
                cincoffset $c3, $c3, $t0
                dli         $t0, 0x1000
                csetbounds  $c3, $c3, $t0
                # Permissions Non_Ephemeral, Permit_Load, Permit_Store,
                # Permit_Store Permit_CCall.
                # NB: Permit_Execute must not be included in the set of
                # permissions used here.
                dli         $t0, 0x10d
                candperm    $c3, $c3, $t0

                #
                # Seal data capability $c3 to the offset of $c4, and store
                # result in $c2.
                #

                cseal       $c2, $c3, $c4

                #
                # Make $c1 a code capability for sandbox
                # $c1 already has restricted permissions so the sandboxed
                # code can't escape the sandbox using reserved registers.
                #

                dla         $t0, sandbox
                csetoffset  $c1, $c1, $t0
                cseal       $c1, $c1, $c4

                # populate $a4 with a non zero value for the end test
                dli         $a4, 42

                # invoke the sandbox
                dla         $t0, invoke
                jalr        $t0
                nop

                # end the test
                # landing here...
                ##############################################################
                cld         $sp, $zero, 0($c26)
                csetoffset  $c26, $c26, $zero
                csetdefault $c26
                ##############################################################
                # for the test...
                # check that we reached that point
                li          $a1, 0x900d
                # check that the memory array has been changed correctly
                dla         $t0, data
                lb          $a2, 0($t0) # was 0x01, should now be 0x08
                lb          $a3, 8($t0) # was 0xff, should now be 0x00
                # check that the memory array has been changed correctly in the location handled by $a4
                lb          $a5, 12($t0) # was 0xff, should now be 0x00
                # check that register $a4 has been cleared on return from the sandbox
                # nothing to actually do, just inspect the value of a4 in the test framework
                # terminate the test

END_TEST

sandbox:        .ent sandbox
                # landing here... setup new DDC from received IDC
                ##############################################################
                csetdefault $c26
                ##############################################################
                # store what should have been zeroed into the all fs array
                sb          $a0, 8($zero)
                sb          $a1, 9($zero)
                sb          $a2, 10($zero)
                sb          $a3, 11($zero)
                sb          $a4, 12($zero)
                sb          $a5, 13($zero)
                sb          $a6, 14($zero)
                sb          $a7, 15($zero)
                # reorder the array or smthg
                lb          $a0, 0($zero)
                lb          $a1, 1($zero)
                lb          $a2, 2($zero)
                lb          $a3, 3($zero)
                lb          $a4, 4($zero)
                lb          $a5, 5($zero)
                lb          $a6, 6($zero)
                lb          $a7, 7($zero)
                sb          $a0, 7($zero)
                sb          $a1, 6($zero)
                sb          $a2, 5($zero)
                sb          $a3, 4($zero)
                sb          $a4, 3($zero)
                sb          $a5, 2($zero)
                sb          $a6, 1($zero)
                sb          $a7, 0($zero)
                # trash $a4 for the test
                dli         $a4, 0x1337
                # go back to caller domain
                cmove       $c1, $c23
                cmove       $c2, $c24
                dla         $t0, uninvoke
                jalr        $t0
                nop
                .end sandbox

invoke:         .ent invoke
                # backup all relevant general purpose registers
                sd          $sp, 0($sp)
                #TODO more stuff ?
                # backup all relevant capability registers
                #TODO more stuff ?
                # prepare backup of first domain's code and data capabilities in c23 and c24
                dli         $t0, 0x4321
                cgetdefault $c4
                csetoffset $c4, $c4, $t0

                # prepare code capability
                cgetpcc     $c23
                csetoffset  $c23, $c23, $ra
                cseal       $c23, $c23, $c4

                # prepare the data capability, this time just use default which is aligned.
                cgetdefault $c24
                dli         $t0, -3      # clear perm execute
                candperm    $c24, $c24, $t0
                csetoffset  $c24, $c24, $sp
                cseal       $c24, $c24, $c4
                # clear all general purpose registers not passed to the sandbox
                #li          $0 # no need, it's zero already !
                li          $1, 0
                li          $2, 0
                li          $3, 0
                li          $4, 0
                li          $5, 0
                li          $6, 0
                li          $7, 0
                li          $8, 0
                li          $9, 0
                li          $10, 0
                li          $11, 0
                li          $12, 0
                li          $13, 0
                li          $14, 0
                li          $15, 0
                li          $16, 0
                li          $17, 0
                li          $18, 0
                li          $19, 0
                li          $20, 0
                li          $21, 0
                li          $22, 0
                li          $23, 0
                li          $24, 0
                li          $25, 0
                li          $26, 0
                li          $27, 0
                li          $28, 0
                li          $29, 0
                li          $30, 0
                li          $31, 0
                # clear all capability registers not passed to the sandbox
                #cgetnull	$c1 # code cap to invoke
                #cgetnull	$c2 # data cap to invoke
                cgetnull	$c3
                cgetnull	$cnull
                csetdefault	$c3
                cgetnull	$c4
                cgetnull	$c5
                cgetnull	$c6
                cgetnull	$c7
                cgetnull	$c8
                cgetnull	$c9
                cgetnull	$c10
                cgetnull	$c11
                cgetnull	$c12
                cgetnull	$c13
                cgetnull	$c14
                cgetnull	$c15
                cgetnull	$c16
                cgetnull	$c17
                cgetnull	$c18
                cgetnull	$c19
                cgetnull	$c20
                cgetnull	$c21
                cgetnull	$c22
                #cgetnull	$c23 # code cap to return to
                #cgetnull	$c24 # data cap to return to
                cgetnull	$c25
                cgetnull	$c26
                #cgetnull	$c27
                #cgetnull	$c28
                #cgetnull	$c29
                #cgetnull	$c30
                #cgetnull	$c31
                # call new domain
                ccall   $c1, $c2, 1
                nop
                .end invoke

uninvoke:       .ent uninvoke
                # clear all general purpose registers not passed to the sandbox
                #li          $0 # no need, it's zero already !
                li          $1, 0
                li          $2, 0
                li          $3, 0
                li          $4, 0
                li          $5, 0
                li          $6, 0
                li          $7, 0
                li          $8, 0
                li          $9, 0
                li          $10, 0
                li          $11, 0
                li          $12, 0
                li          $13, 0
                li          $14, 0
                li          $15, 0
                li          $16, 0
                li          $17, 0
                li          $18, 0
                li          $19, 0
                li          $20, 0
                li          $21, 0
                li          $22, 0
                li          $23, 0
                li          $24, 0
                li          $25, 0
                li          $26, 0
                li          $27, 0
                li          $28, 0
                li          $29, 0
                li          $30, 0
                li          $31, 0
                # clear all capability registers not passed to the sandbox
                cgetnull    $c3
                csetdefault $c3
                #cgetnull	$c1 # code cap to invoke
                #cgetnull	$c2 # data cap to invoke
                cgetnull	$c3
                cgetnull	$c4
                cgetnull	$c5
                cgetnull	$c6
                cgetnull	$c7
                cgetnull	$c8
                cgetnull	$c9
                cgetnull	$c10
                cgetnull	$c11
                cgetnull	$c12
                cgetnull	$c13
                cgetnull	$c14
                cgetnull	$c15
                cgetnull	$c16
                cgetnull	$c17
                cgetnull	$c18
                cgetnull	$c19
                cgetnull	$c20
                cgetnull	$c21
                cgetnull	$c22
                cgetnull	$c23 # code cap to return to
                cgetnull	$c24 # data cap to return to
                cgetnull	$c25
                cgetnull	$c26
                #cgetnull	$c27
                #cgetnull	$c28
                #cgetnull	$c29
                #cgetnull	$c30
                #cgetnull	$c31
                # call new domain
                ccall   $c1, $c2, 1
                nop
                .end uninvoke

                .data
                .align  12
data:           .dword  0x0102030405060708
                .dword  0xffffffffffffffff
