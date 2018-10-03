#-
# Copyright (c) 2014 Michael Roe
# Copyright (c) 2014 Robert M. Norton
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

from beritest_tools import BaseBERITestCase
from beritest_tools import attr

@attr('capabilities')
@attr('tlb')
class test_cp2_csc_tlb(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 1

    def test_cp2_csc_tlb_progress(self):
        '''Test that test finishes at the end of stage 4'''
        self.assertRegisterEqual(self.MIPS.a5, 4, "Test did not finish at the end of stage 4")

    def test_cp2_csc_tlb_base(self):
        '''Test csc stored base when nostorecap set but cap invalid'''
        self.assertRegisterEqual(self.MIPS.a3, 0x40, "csc did not store base when nostorecap set but cap invalid")

    def test_cp2_csc_tlb_len(self):
        '''Test csc stored len when nostorecap set but cap invalid'''
        self.assertRegisterEqual(self.MIPS.a4, 0x40, "csc did not store len when nostorecap set but cap invalid")

    def test_cp2_csc_tlb_tag(self):
        '''Test csc stored tag when nostorecap set but cap invalid'''
        self.assertRegisterEqual(self.MIPS.a6, 0, "csc did not store tag when nostorecap set but cap invalid")

    def test_cp2_csc_tlb_cause(self):
        '''Test that CP0 cause register is set correctly'''
        self.assertRegisterMaskEqual(self.MIPS.a7, 0x1f << 2, 8 << 2, "CP0.Cause.ExcCode was not set correctly when capability store w inhibited in the TLB entry")

    def test_no_trap(self):
        self.assertCompressedTrapInfo(self.MIPS.k1, trap_count=1, mips_cause=self.MIPS.Cause.SYSCALL, msg="test should be terminated by syscall")
