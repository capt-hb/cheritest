#-
# Copyright (c) 2011 Robert N. M. Watson
# Copyright (c) 2013 Michael Roe
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

from beritest_tools import BaseBERITestCase, attr

@attr('llsc')
@attr('cached')
@attr('capabilities')
class test_cp2_cllh_span(BaseBERITestCase):

    def test_cp2_cllh_3(self):
        '''That an uninterrupted cllh+cld+csch succeeds'''
        self.assertRegisterEqual(self.MIPS.a0, 1, "Uninterrupted cllh+cld+csch failed")

    @attr('llscspan')
    def test_cp2_cllh_7(self):
        '''That an cllh+csch spanning a store to the line does not store'''
        self.assertRegisterNotEqual(self.MIPS.a2, 1, "Interrupted cllh+csh+csch stored value")

    @attr('llscspan')
    def test_cp2_cllh_6(self):
        '''That an cllh+csh+csch spanning fails'''
        self.assertRegisterEqual(self.MIPS.t0, 0, "Interrupted cllh+csh+csch succeeded")
