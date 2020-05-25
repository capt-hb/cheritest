from beritest_tools import BaseBERITestCase

class test_purecap_uninit_cc_stack_growth(BaseBERITestCase):
    def test_result_of_test(self):
        assert self.MIPS.v0 == 20

    def test_result_of_tmp(self):
        assert self.MIPS.t1 == 55

    def test_result_of_cap_tmp(self):
        assert self.MIPS.t2 == 55

    def test_result_of_mixed_tmp(self):
        assert self.MIPS.t3 == 55
