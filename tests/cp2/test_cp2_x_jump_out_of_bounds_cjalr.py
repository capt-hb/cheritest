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

from beritest_baseclasses import BERITestBaseClasses


class test_cp2_x_jump_out_of_bounds_cjalr(BERITestBaseClasses.BranchOutOfBoundsTestCase):
    msg = " CJALR with out of bounds cap"
    branch_offset = 4 * 4  # 4 instructions to setup jump cap

    def test_link_cap_unchanged(self):
        # CJALR should not change the return register if the jump fails
        self.assertIntCap(self.MIPS.c18, int_value=0x100000000, msg="should not set the return register if the jump fails due to" + self.msg)
