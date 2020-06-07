from beritest_tools import BaseBERITestCase

class test_purecap_original_cc_stack_growth_O1(BaseBERITestCase):
    def test_result_of_test(self):
        assert self.MIPS.v0 == 20
