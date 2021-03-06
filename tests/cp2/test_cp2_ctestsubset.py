#-
# Copyright (c) 2018 Michael Roe
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

from beritest_tools import BaseBERITestCase
from beritest_tools import attr

class test_cp2_ctestsubset(BaseBERITestCase):

    @attr('capabilities')
    def test_cp2_ctestsubset_1(self):
        self.assertRegisterEqual(self.MIPS.a0, 1, "CTestSubset returned incorrect result when bounds were a subset")

    @attr('capabilities')
    def test_cp2_ctestsubset_2(self):
        self.assertRegisterEqual(self.MIPS.a1, 0, "CTestSubset returned incorrect result when bounds were not a subset")

    @attr('capabilities')
    def test_cp2_ctestsubset_3(self): 
        self.assertRegisterEqual(self.MIPS.a2, 1, "CTestSubset returned incorrect result when perms werea subset")

    @attr('capabilities')
    def test_cp2_ctestsubset_4(self):
        self.assertRegisterEqual(self.MIPS.a3, 0, "CTestSubset returned incorrect result when perms were not a subset")

    @attr('capabilities')
    def test_cp2_ctestsubset_5(self):
        self.assertRegisterEqual(self.MIPS.a4, 1, "CTestSubset returned incorrect result when uperms were a subset")

    @attr('capabilities')
    def test_cp2_ctestsubset_6(self):
        self.assertRegisterEqual(self.MIPS.a5, 0, "CTestSubset returned incorrect result when uperms were not a subset")

    @attr('capabilities')
    def test_cp2_ctestsubset_7(self): 
        self.assertRegisterEqual(self.MIPS.a6, 1, "CTestSubset returned incorrect result when zero length was a subset")

    @attr('capabilities')
    def test_cp2_ctestsubset_8(self):
        self.assertRegisterEqual(self.MIPS.a7, 0, "CTestSubset returned incorrect result when zero length was not a subset")
