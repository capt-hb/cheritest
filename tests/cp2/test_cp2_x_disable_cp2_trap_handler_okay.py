#-
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

from beritest_tools import BaseBERITestCase, xfail_gnu_binutils
from beritest_tools import attr
import copy


#
# Test that the trap handle and finish() can deal with CP2 being disabled
#
@attr('capabilities')
class test_cp2_x_disable_cp2_trap_handler_okay(BaseBERITestCase):
    def test_total_exception_count(self):
        self.assertRegisterEqual(self.MIPS.v0, 1, "Expected only one exception")

    def test_error_is_cop_unusable(self):
        self.assertCompressedTrapInfo(self.MIPS.s1, trap_count=1, mips_cause=self.MIPS.Cause.COP_Unusable)

    def test_t0_unchanged(self):
        self.assertRegisterEqual(self.MIPS.t0, 12345678, "cgetcause should not have been executed!")
