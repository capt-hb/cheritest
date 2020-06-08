from beritest_tools import BaseBERITestCase

class test_purecap_uninit_cc_sums_O1(BaseBERITestCase):
    def test_result_of_test(self):
        assert self.MIPS.v0 == 0
