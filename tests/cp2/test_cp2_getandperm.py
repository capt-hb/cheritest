#-
# Copyright (c) 2011 Robert N. M. Watson
# Copyright (c) 2018 Alex Richardson
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

#
# Check basic behaviour of cgetperm and candperm.
#

@attr('capabilities')
class test_cp2_getandperm(BaseBERITestCase):

    def test_cp2_getperm_full(self):
        '''Test that cgetperm returns correct initial value'''
        self.assertRegisterAllPermissions(self.MIPS.a0, "cgetperm returns incorrect initial value")

    # TODO: this is probably incorrect for CHERI64
    def test_cp2_getperm_without_user_perms(self):
        '''Test that cgetperm returns correct value after candperm'''
        self.assertRegisterMaskEqual(self.MIPS.a0, (1 << 15) - 1, (1 << 12) - 1,
                                     "There are only 12 HW permissions (should not be extended to fill all 15 bits)")

    def test_cp2_getperm_after_mask(self):
        '''Test that cgetperm returns correct value after candperm'''
        self.assertRegisterEqual(self.MIPS.a1, 0xff, "cgetperm returns incorrect value after candperm")
