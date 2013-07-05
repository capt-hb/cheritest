#-
# Copyright (c) 2013-2013 Ben Thorner, Colin Rothwell
# All rights reserved.
#
# This software was developed by Ben Thorner as part of his summer internship
# and Colin Rothwell as part of his final year undergraduate project.
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

class test_raw_fpu_cvt(BaseCHERITestCase):
    def test_convert_word_to_single(self):
        '''Test we can convert words to single floating point'''
        self.assertRegisterEqual(self.MIPS.t0, 0x3F800000, "Didn't convert 1 to FP")
        self.assertRegisterEqual(self.MIPS.t1, 0x4C00041A, "Didn't convert non exact to FP")
        self.assertRegisterEqual(self.MIPS.t2, 0xFFFFFFFFC1B80000, "Didn't convert -23 to FP")

    def test_convert_double_to_single(self):
        '''Test we can convert doubles to singles'''
        self.assertRegisterEqual(self.MIPS.s0, 0x3F800000, "Didn't convert 1 from double.")
        self.assertRegisterEqual(self.MIPS.s1, 0x3e2aaaaa, "Didn't convert 1/6 from double.")
        self.assertRegisterEqual(self.MIPS.s2, 0xffffffffc36aa188, "Didn't convert -234.6311 from double")
        self.assertRegisterEqual(self.MIPS.s3, 0x4f0c0473, "Didn't convert large number from double.")

    def test_convert_singles_to_doubles(self):
        '''Test we can convert singles to doubles'''
        self.assertRegisterEqual(self.MIPS.s4, 0x3FF0000000000000, "Didn't convert 1 to double.")
        self.assertRegisterEqual(self.MIPS.s5, 0x3FC99999A0000000, "Didn't conver 0.2 to double.")
        self.assertRegisterEqual(self.MIPS.s6, 0xC0D1DCE8C0000000, "Didn't convert -18291.636 to double")

    def test_convert_ps_to_s(self):
        '''Test we can convert paired single to single'''
        self.assertRegisterEqual(self.MIPS.a0, 0x33333333, "Didn't extract lower single.")
        self.assertRegisterEqual(self.MIPS.a1, 0xDDDDDDDD, "Didn't extract upper single.")
