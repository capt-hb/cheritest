#-
# Copyright (c) 2011 Robert N. M. Watson
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
# ("CTSRD"), as part of the DARPA CRASH research programme.
#
# @BERI_LICENSE_HEADER_START@
#
# Licensed to BERI Open Systems C.I.C (BERI) under one or more contributor
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

from cheritest_tools import BaseCHERITestCase

class test_raw_dsubu(BaseCHERITestCase):
    def test_independent_inputs(self):
        '''Check that simple dsubu worked, no input modification'''
        self.assertRegisterEqual(self.MIPS.s3, 2, "dsubu modified first input")
        self.assertRegisterEqual(self.MIPS.s4, 1, "dsubu modified second input")
        self.assertRegisterEqual(self.MIPS.a0, 1, "dsubu failed")

    def test_into_first_input(self):
        self.assertRegisterEqual(self.MIPS.a1, 1, "dsubu into first input failed")

    def test_into_second_input(self):
        self.assertRegisterEqual(self.MIPS.a2, 1, "dsubu into second input failed")

    def test_into_both_input(self):
        self.assertRegisterEqual(self.MIPS.a3, 0, "dsubu into both inputs failed")

    def test_pipeline(self):
        self.assertRegisterEqual(self.MIPS.a4, 1, "dsubu-to-dsubu pipeline failed")
