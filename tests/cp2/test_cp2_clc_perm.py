#-
# Copyright (c) 2017 Michael Roe
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

from beritest_tools import BaseBERITestCase
from beritest_tools import attr

@attr('capabilities')
class test_cp2_clc_perm(BaseBERITestCase):
    def test_cp2_clc_perm_1(self):
        self.assertRegisterEqual(self.MIPS.a0, 0x123456789abcdef0, "CLC did not load a capability when cb.perms.Permit_Load_Capability was not set")

    def test_cp2_clc_load_store_untagged(self):
        self.assertCapabilitiesEqual(self.MIPS.c4, self.MIPS.c3, "CLC did not load back the same untagged value that was stored")

    def test_cp2_clc_untagged_memory_bits_unchanged(self):
        self.assertRegisterEqual(self.MIPS.a2, 0xffffffffffffffff, "CSC changed the in-memory bits")
        self.assertRegisterEqual(self.MIPS.a3, 0xffffffffffffffff, "CSC changed the in-memory bits")
        self.assertRegisterEqual(self.MIPS.a4, 0xffffffffffffffff, "CSC changed the in-memory bits")
        self.assertRegisterEqual(self.MIPS.a5, 0xffffffffffffffff, "CSC changed the in-memory bits")
