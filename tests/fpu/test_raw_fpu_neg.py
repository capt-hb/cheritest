#-
# Copyright (c) 2012 Ben Thorner
# Copyright (c) 2013 Colin Rothwell
# All rights reserved.
#
# This software was developed by Ben Thorner as part of his summer internship
# and Colin Rothwell as part of his final year undergraduate project.
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

from beritest_tools import attr

from beritest_tools import BaseBERITestCase


class test_raw_fpu_neg(BaseBERITestCase):

    def test_neg_single(self):
        '''Test we can negate in single precision'''
        self.assertRegisterMaskEqual(self.MIPS.s0, 0xffffffff, 0x85300000, "Failed to negate a single")

    @attr('float64')
    def test_neg_double(self):
        '''Test we can negate in double precision'''
        self.assertRegisterEqual(self.MIPS.s1, 0x0220555500000000, "Failed to negate a double")

    @attr('floatlegacyabs')
    def test_neg_single_denorm(self):
        '''Test that NEG.S flushes a denormalized result to zero'''
        # We ignore the sign
        self.assertRegisterMaskEqual(self.MIPS.s4, 0x7FFFFFFF, 0x0, "NEG.S failed to flush denormalised result")
