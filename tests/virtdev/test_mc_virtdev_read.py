#-
# Copyright (c) 2018 Jonathan Woodruff
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory (Department of Computer Science and
# Technology) under DARPA contract HR0011-18-C-0016 ("ECATS"), as part of the
# DARPA SSITH research programme.
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

class test_mc_virtdev_read(BaseBERITestCase):

    @attr('multicore')
    @attr('virtdev')
    def test_mc_virtdev_read_1(self):
        '''Test that virtual device returns a zero when not enabled.'''
        self.assertRegisterEqual(self.MIPS.a0, 0, "Load from virtual device did not return zero when not enabled.")

    @attr('multicore')
    @attr('virtdev')
    def test_mc_virtdev_read_2(self):
        '''Test read from virtual device when enabled.'''
        self.assertRegisterEqual(self.MIPS.a1, 0x900000007fb02008, "Did not return the read address.")

