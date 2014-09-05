#-
# Copyright (c) 2014 Jonathan Woodruff
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
from nose.plugins.attrib import attr

#
# Test capability compare less than or equal to, unsigned.
#

class test_cp2_cleu(BaseBERITestCase):
    @attr('capabilities')
    def test_cp2_cleu_duplicated(self):
        '''Test duplicated capabilities are equal'''
        self.assertRegisterEqual(self.MIPS.a0, 0x1, "Duplicated capabilities did not compare equal")

    @attr('capabilities')
    def test_cp2_cleu_diff_offsets(self):
        '''Test capabilities with different offsets test not equal'''
        self.assertRegisterEqual(self.MIPS.a1, 0x1, "Capabilities with different offsets tested equal")

    @attr('capabilities')
    def test_cp2_cleu_diff_bases(self):
        '''Test capabilities with different bases test not equal'''
        self.assertRegisterEqual(self.MIPS.a2, 0x1, "Capabilities with different bases tested equal")
        
    @attr('capabilities')
    def test_cp2_cleu_both_null(self):
        '''Test different NULL capabilities test equal'''
        self.assertRegisterEqual(self.MIPS.a3, 0x0, "Two NULL capabilities tested not equal")

    @attr('capabilities')
    def test_cp2_cleu_same_base_plus_offset(self):
        '''Test capabilities with complimentary bases and offsets test equal'''
        self.assertRegisterEqual(self.MIPS.a4, 0x1, "Capabilities with equivalent base + offset tested not equal")
        
    @attr('capabilities')
    def test_cp2_cleu_one_null(self):
        '''Test a NULL capability tests not equal to an equivelant non-NULL one'''
        self.assertRegisterEqual(self.MIPS.a5, 0x1, "A NULL capability tested equal to a valid one")