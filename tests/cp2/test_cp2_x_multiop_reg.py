#-
# Copyright (c) 2015 Michael Roe
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

@attr('capabilities')
class test_cp2_x_multiop_reg(BaseBERITestCase):
    def test_cp2_x_multiop_reg(self):
        if self.MIPS.CHERI_C27_TO_31_INACESSIBLE:
            assert self.MIPS.v0 == 72, "An unexpected number of exceptions was raised during the test of capability operations on a reserved register without the required permission in PCC"
        else:
            assert self.MIPS.v0 == 0, "Registers c27-c31 are no longer special and should be accessible"

