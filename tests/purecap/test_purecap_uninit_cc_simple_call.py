from beritest_tools import BaseBERITestCase

class test_purecap_uninit_cc_simple_call(BaseBERITestCase):
    def test_first_argument_register_contains_100(self):
        assert self.MIPS.a0 == 100

    def test_result_of_something_is_100(self):
        assert self.MIPS.v0 == 100

    def test_stack_capability_is_uninit_in_doSomething(self):
        assert self.MIPS.t0 == 1
