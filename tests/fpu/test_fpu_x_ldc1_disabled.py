#-
# Copyright (c) 2013 Michael Roe
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

#
# Test floating point division of a small number by itself
#

from cheritest_tools import BaseCHERITestCase
from nose.plugins.attrib import attr

class test_fpu_x_ldc1_disabled(BaseCHERITestCase):

    def test_fpu_x_ldc1_disabled_1(self):
        '''Test that ldc1 raises an exception if the FPU is disabled'''
	self.assertRegisterEqual(self.MIPS.a2, 1, "ldc1 with the FPU disabled did not raise an exception")

    def test_fpu_x_ldc1_disabled_2(self):
        '''Test that CP0.cause.ExcCode is set when FPU is disabled'''
	self.assertRegisterEqual(self.MIPS.a3, 11, "CP0.cause.exccode was not set to coprocessor unusable when the FPU was disabled")

    def test_fpu_x_ldc1_disabled_3(self):
        '''Test that CP0.cause.ce is set when FPU is disabled'''
	self.assertRegisterEqual(self.MIPS.a4, 1, "CP0.cause.ce was not set to 1 when the FPU was disabled")
