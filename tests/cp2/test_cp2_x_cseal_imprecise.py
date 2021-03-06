#-
# Copyright (c) 2016 Michael Roe
# Copyright (c) 2018 Alex Richardson
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

from beritest_tools import BaseBERITestCase, is_feature_supported, attr
import os


@attr('capabilities')
@attr('cap_imprecise')
class test_cp2_x_cseal_imprecise(BaseBERITestCase):

    def test_maybe_unrep(self):
        # New QEMU implementation can actually represent this:
        if is_feature_supported('improved_cheri_cc'):
            self.assertNullCap(self.MIPS.c4, "Should not have caused a trap")
            assert self.MIPS.c3.ctype == 0x11
            assert self.MIPS.c3.base == 0x101
            assert self.MIPS.c3.length == 0x101
            assert self.MIPS.c3.offset == 0
            assert self.MIPS.c3.t
            assert self.MIPS.c3.s
        else:
            self.assertNullCap(self.MIPS.c3, "Should not have changed capreg")
            self.assertCp2Fault(self.MIPS.s0, cap_reg=1, cap_cause=self.MIPS.CapCause.Bounds_Not_Exactly_Representable, trap_count=1)

    def test_used_to_be_unrepresenatable(self):
        if os.getenv("CAP_PRECISION_BITS") and int(os.getenv("CAP_PRECISION_BITS")) == 23:
            # The old cheri_cc implementation could not represent this:
            trap_count = 1 if is_feature_supported('improved_cheri_cc') else 2
            self.assertCp2Fault(self.MIPS.s1, cap_reg=1, cap_cause=self.MIPS.CapCause.Bounds_Not_Exactly_Representable, trap_count=trap_count)
            self.assertNullCap(self.MIPS.c6, "Should not have changed capreg")
            return
        # latest cheri_cc can seal all caps so will succeed here where used to fail
        assert self.MIPS.c6.ctype == 0x12
        # exact values of base, length, offest will depend on format
        # due to imprecise bounds so just assert they are same as input
        assert self.MIPS.c6.base == self.MIPS.c1.base
        assert self.MIPS.c6.length == self.MIPS.c1.length
        assert self.MIPS.c6.offset == self.MIPS.c1.offset
        assert self.MIPS.c6.t
        assert self.MIPS.c6.s

