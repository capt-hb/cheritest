from beritest_tools import BaseBERITestCase

class test_purecap_uninit_cc_stack_growth_O1(BaseBERITestCase):
    def test_result_of_test(self):
        assert self.MIPS.t1 == 1
        assert self.MIPS.t0 == 1
        assert self.MIPS.v0 == 20
