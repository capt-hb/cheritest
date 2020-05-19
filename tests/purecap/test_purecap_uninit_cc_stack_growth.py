from beritest_tools import BaseBERITestCase

class test_purecap_uninit_cc_stack_growth(BaseBERITestCase):
    def test_result_of_test(self):
        assert self.MIPS.v0 == 20
