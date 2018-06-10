#-
# Copyright (c) 2015 Michael Roe
# All rights reserved.
#
# This software was developed by the University of Cambridge Computer
# Laboratory as part of the Rigorous Engineering of Mainstream Systems (REMS)
# project, funded by EPSRC grant EP/K008528/1.
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

from beritest_tools import attr

from beritest_tools import BaseBERITestCase


class test_raw_fpu_mtc1_ex(BaseBERITestCase):

    @attr('float64')
    @attr('float_mtc_signex')
    def test_raw_fpu_mtc1_ex_1(self):
        '''Test that MTC1 sign-extends the value'''
        self.assertRegisterEqual(self.MIPS.a0, 0xffffffff80000000, "MTC1 did not sign extend the value (this is not required by the MIPS ISA)")

    @attr('float64')
    @attr('float_mtc_signex')
    def test_raw_fpu_mtc1_ex_2(self):
        '''Test that MTC1 sign-extends the value'''
        self.assertRegisterEqual(self.MIPS.a1, 0xffffffff80000000, "MTC1 did not sign extend the value (this is not required by the MIPS ISA)")

