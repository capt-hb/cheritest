from beritest_tools import BaseBERITestCase

class test_purecap_original_cc_slow_factorial(BaseBERITestCase):
    def test_result_is_as_expected(self):
        assert self.MIPS.v0 == 10
