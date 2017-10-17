# -
# Copyright (c) 2017 Alex Richardson
# Copyright (c) 2011 Robert M. Norton
# All rights reserved.
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
# A nose test which returns a generator to iterate over clang tests.
# Performs a test for every .c file in the TEST_DIR which matches TEST_FILE_RE.
# Just checks that the test produced the appropriate pass value in v0 to indicate
# that all c asserts passed. Cribbed from tests/fuzz/fuzz.py.

from beritest_tools import TestClangBase
import os
import re
from nose.plugins.attrib import attr

# Parameters from the environment
# Cached or uncached mode.
CACHED = bool(int(os.environ.get("CACHED", "0")))
MULTI = bool(int(os.environ.get("MULTI1", "0")))
# Pass to restrict to only a particular test
ONLY_TEST = os.environ.get("ONLY_TEST", None)

TEST_FILE_RE = re.compile('test_.+\.(c|cpp)')
TEST_DIR = os.path.dirname(os.path.abspath(__file__))

LOG_DIR = os.environ.get("LOGDIR", "log")


def check_answer(test_name):
    if MULTI and CACHED:
        suffix = "_cachedmulti"
    elif MULTI:
        suffix = "_multi"
    elif CACHED:
        suffix = "_cached"
    else:
        suffix = ""
    with open(os.path.join(LOG_DIR, test_name + suffix + ".log"),
              'rt') as sim_log:
        TestClangBase.verify_clang_test(sim_log, TEST_DIR, test_name)


# Not derived from unittest.testcase because we wish test_clang to
# return a generator.
class TestClangPurecap(object):
    @attr('clang')
    @attr('capabilities')
    def test_purecap(self):
        if ONLY_TEST:
            yield (check_answer, ONLY_TEST)
        else:
            for test in filter(lambda f: TEST_FILE_RE.match(f),
                               os.listdir(TEST_DIR)):
                test_name = os.path.splitext(os.path.basename(test))[0]
                yield (check_answer, test_name)
