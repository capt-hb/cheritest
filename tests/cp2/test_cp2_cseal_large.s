#-
# Copyright (c) 2017 Michael Roe
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

.set mips64
.set noreorder
.set nobopt
.set noat
.include "macros.s"
#
# Test CSeal with a large value for the otype
#

BEGIN_TEST
		dli	$a0, 0

		cgetdefault $c2
		dli	$t0, 0x10000
		csetoffset $c2, $c2, $t0
		dli	$t0, 1
		csetbounds $c2, $c2, $t0
		dli	$t0, 0x81
		candperm $c2, $c2, $t0

		cgetdefault $c3
		dli	$t0, 0x10000000000
		csetbounds $c3, $c3, $t0
		dli	$t0, 0x68017
		candperm $c3, $c3, $t0

		cseal	$c3, $c3, $c2

		cgetsealed $a0, $c3

END_TEST
