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

from beritest_tools import TestClangBase, attr, LOG_DIR, config_options
import os
import re
import pytest

# Parameters from the environment
# Cached or uncached mode.
CACHED = bool(int(os.environ.get("CACHED", "0")))
MULTI = bool(int(os.environ.get("MULTI1", "0")))
# Pass to restrict to only a particular test
ONLY_TEST = os.environ.get("ONLY_TEST", None)

TEST_FILE_RE = re.compile('test_.+\\.(c|cpp)')
TEST_DIR = os.path.dirname(os.path.abspath(__file__))


def check_answer(test_name, test_file):
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
        TestClangBase.verify_clang_test(sim_log, test_name, test_file)


def _get_xfail_reason(test_name):
    if test_name == "test_purecap_stack_cap":
        return "This test needs a much larger stack than we provide here"
    if test_name == "test_purecap_statcounters":
        # L3/SAIL don't implement the statcounters instructions
        if config_options().TEST_MACHINE.lower() in ("l3", "sail"):
            return "Statcounters rdhwr not supported on " + os.getenv("TEST_MACHINE", "")
    return None


def get_all_tests():
    if ONLY_TEST:
        test_files = ONLY_TEST
    else:
        test_files = filter(lambda f: TEST_FILE_RE.match(f), os.listdir(TEST_DIR))
    for test in test_files:
        test_name = os.path.splitext(os.path.basename(test))[0]
        test_file = os.path.join(TEST_DIR, test)
        # Mark some tests as xfail for certain targets:
        param_kwargs = {"id":test}
        xfail_reason = _get_xfail_reason(test_name)
        if xfail_reason:
            param_kwargs["marks"] = pytest.mark.xfail(reason=xfail_reason)
        yield pytest.param(test_name, test_file, **param_kwargs)

# TODO: ids=idfn
@pytest.mark.parametrize(("test_name", "test_file"), get_all_tests())
@attr('clang')
@attr('capabilities')
def test_purecap(test_name, test_file):
    check_answer(test_name, test_file)
