#-
# Copyright (c) 2011 Robert N. M. Watson
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

from beritest_tools import BaseBERITestCase, attr, HexInt


@attr('llsc')
class test_scd_unalign_unmatched(BaseBERITestCase):
    """
    Note: even if the CPU supports unaligned accesses (e.g. QEMU) this
    does not apply to SCD. According MIPS64 spec v6.06:

    The effective address must be naturally-aligned.
    If any of the 3 least-significant bits of the address is non-zero,
    an Address Error exception occurs.
    """

    def test_returned(self):
        self.assertRegisterEqual(self.MIPS.a1, 1, "flow broken by scd instruction")

    def test_value_not_written(self):
        assert self.MIPS.s1 == HexInt(0x5656565656565656), "value before sc wrong"
        assert self.MIPS.s2 == HexInt(0x5656565656565656), "sc stored value!"

    @attr('llscnotmatching')
    def test_epc(self):
        self.assertRegisterEqual(self.MIPS.a0, self.MIPS.a5, "Unexpected EPC")

    @attr('llscnotmatching')
    def test_handled(self):
        self.assertRegisterEqual(self.MIPS.a2, 1, "scd exception handler not run")

    @attr('llscnotmatching')
    def test_exl_in_handler(self):
        self.assertRegisterEqual((self.MIPS.a3 >> 1) & 0x1, 1, "EXL not set in exception handler")

    @attr('llscnotmatching')
    def test_badvaddr(self):
        self.assertRegisterEqual(self.MIPS.a7, self.MIPS.s3, "BadVAddr equal to Unaligned Address")

    @attr('llscnotmatching')
    def test_cause_bd(self):
        self.assertRegisterEqual((self.MIPS.a4 >> 31) & 0x1, 0, "Branch delay (BD) flag improperly set")

    @attr('llscnotmatching')
    def test_cause_code(self):
        self.assertRegisterEqual((self.MIPS.a4 >> 2) & 0x1f, 5, "Code not set to AdES")

    @attr('llscnotmatching')
    def test_not_exl_after_handler(self):
        self.assertRegisterEqual((self.MIPS.a6 >> 1) & 0x1, 0, "EXL still set after ERET")
