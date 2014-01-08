#-
# Copyright (c) 2014 Robert M. Norton
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
# ("CTSRD"), as part of the DARPA CRASH research programme.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
from cheritest_tools import BaseCHERITestCase
from nose.plugins.attrib import attr

@attr('mt')
class test_ipc(BaseCHERITestCase):
    def test_cause_t0(self):
        self.assertRegisterEqual(self.MIPS.threads[0].s0 & 0xffff, 0x800, "Thread 0 cause register not interrupt on IP3")

    def test_epc_t0(self):
        expected_epc=self.MIPS.threads[0].s2
        self.assertRegisterInRange(self.MIPS.threads[0].s1, expected_epc, expected_epc + 4, "Thread 0 epc register not expected_epc")

    def test_cause_t1(self):
        self.assertRegisterEqual(self.MIPS.threads[1].s0 & 0xffff, 0x400, "Thread 1 cause register not interrupt on IP2")

    def test_epc_t1(self):
        expected_epc=self.MIPS.threads[0].s3
        self.assertRegisterInRange(self.MIPS.threads[1].s1, expected_epc, expected_epc + 4, "Thread 1 epc register not expected_epc")
