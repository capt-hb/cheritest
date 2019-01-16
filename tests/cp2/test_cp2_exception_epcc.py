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

from beritest_tools import BaseBERITestCase
from beritest_tools import attr

#
# Rather complex test to check that EPCC/PCC swapping in exceptions is being
# properly implemented by CP2.  The test runs initially with a privileged PCC,
# then traps, a limited PCC is installed, traps again, and the original PCC is
# restored.  Various bits of evidence are collected along the way, all of
# which we try to check here.
#

@attr("capabilities")
class test_cp2_exception_epcc(BaseBERITestCase):
    #
    # Check that various stages of the test did actually run.
    #
    def test_exception_counter(self):
        self.assertRegisterEqual(self.MIPS.a0, 2, "CP2 exception counter not 2")

    def test_presandbox(self):
        self.assertRegisterEqual(self.MIPS.a1, 1, "pre-sandbox not recorded")

    def test_insandbox(self):
        self.assertRegisterEqual(self.MIPS.a2, 1, "sandbox not recorded")

    def test_postsandbox(self):
        self.assertRegisterEqual(self.MIPS.a4, 1, "post-sandbox not recorded")

    #
    # Check that sandbox was configured roughly as expected
    #
    def test_sandbox_length(self):
        self.assertRegisterEqual(self.MIPS.s0, 24, "sandbox length not 24")

    #
    # Check that we only entered the last exception because of an explicit
    # software trap.
    #
    def test_trap_excode(self):
        self.assertRegisterMaskEqual(self.MIPS.s1, 0x1f << 2, 13 << 2, "last exception not a trap")

    #
    # Check that the exception handler is returning PCC-relative PCs rather
    # than absolute virtual PCs.
    #
    def test_trap_epc(self):
        self.assertRegisterEqual(self.MIPS.s2, 0x14, "incorrect EPC for last trap")

    #
    # Check that in-sandbox $pc is roughly as expected
    #
    def test_sandbox_pc(self):
        self.assertRegisterEqual(self.MIPS.a3, 0x10, "sandbox PC unexpected")

    #
    # Check that post-sandbox, $pc is roughly as expected
    #
    def test_postsandbox_pc(self):
        self.assertRegisterEqual(self.MIPS.a5, self.MIPS.a6, "post-sandbox PC unexpected")

    #
    # Check that the pre-sandbox EPCC is as expected: default on reset.
    #
    def test_presandbox_epcc(self):
        self.assertDefaultCap(self.MIPS.epcc, offset=self.MIPS.s6, msg="pre-sandbox EPCC offset incorrect")

    def test_presandbox_epcc_saved(self):
        self.assertDefaultCap(self.MIPS.c5, offset=self.MIPS.s6, msg="pre-sandbox EPCC offset incorrect")

    def test_presandbox_epc(self):
        assert self.MIPS.s7 == self.MIPS.s6, "final EPC should point to last trap address"

    #
    # Check that the post-sandbox EPCC is as expected: sandboxed.
    #
    def test_sandbox_epcc_unsealed(self):
        self.assertRegisterEqual(self.MIPS.cp2[3].s, 0, "sandbox EPCC unsealed incorrect")

    def test_sandbox_epcc_perms(self):
        self.assertRegisterEqual(self.MIPS.cp2[3].perms, 0x0007, "sandbox EPCC perms incorrect")

    def test_sandbox_epcc_ctype(self):
        self.assertRegisterEqual(self.MIPS.cp2[3].ctype, self.unsealed_otype, "sandbox EPCC ctype incorrect")
        
    def test_sandbox_epcc_offset(self):
        self.assertRegisterEqual(self.MIPS.cp2[3].offset, 0x14, "sandbox EPCC offset incorrect")

    def test_sandbox_epcc_base(self):
        self.assertRegisterEqual(self.MIPS.cp2[3].base, self.MIPS.a7, "sandbox EPCC base incorrect")

    def test_sandbox_epcc_length(self):
        self.assertRegisterEqual(self.MIPS.cp2[3].length, self.MIPS.s0, "sandbox EPCC length incorrect")
