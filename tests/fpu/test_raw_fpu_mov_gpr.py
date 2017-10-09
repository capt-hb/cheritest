#-
# Copyright (c) 2012 Ben Thorner
# Copyright (c) 2013 Colin Rothwell
# All rights reserved.
#
# This software was developed by Ben Thorner as part of his summer internship
# and Colin Rothwell as part of his final year undergraduate project.
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
from nose.plugins.attrib import attr

class test_raw_fpu_mov_gpr(BaseBERITestCase):

    @attr('floatcmove')
    def test_mov_gpr_1(self):
        '''Test MOVN.S (True)'''
        self.assertRegisterEqual(self.MIPS.a0, 0x41000000, "MOVN.S (True) failed")

    @attr('floatcmove')
    def test_mov_gpr_2(self):
        '''Test MOVN.D (True)'''
        self.assertRegisterEqual(self.MIPS.a1, 0x4000000000000000, "MOVN.D (True) failed")

    @attr('floatcmove')
    def test_mov_gpr_3(self):
        '''Test MOVN.S (False)'''
        self.assertRegisterEqual(self.MIPS.a2, 0x0, "MOVN.S (False) failed")

    @attr('floatcmove')
    def test_mov_gpr_4(self):
        '''Test MOVN.D (False)'''
        self.assertRegisterEqual(self.MIPS.a3, 0x0, "MOVN.D (False) failed")

    @attr('floatcmove')
    def test_mov_gpr_5(self):
        '''Test MOVZ.S (True)'''
        self.assertRegisterEqual(self.MIPS.s0, 0x41000000, "MOVZ.S (True) failed")

    @attr('floatcmove')
    def test_mov_gpr_6(self):
        '''Test MOVZ.D (True)'''
        self.assertRegisterEqual(self.MIPS.s1, 0x4000000000000000, "MOVZ.D (True) failed")

    @attr('floatcmove')
    def test_mov_gpr_7(self):
        '''Test MOVZ.S (False)'''
        self.assertRegisterEqual(self.MIPS.s2, 0x0, "MOVZ.S (False) failed")

    @attr('floatcmove')
    def test_mov_gpr_8(self):
        '''Test MOVZ.D (False)'''
        self.assertRegisterEqual(self.MIPS.s3, 0x0, "MOVZ.D (False) failed")
