from beritest_tools import BaseBERITestCase

class test_purecap_original_calling_convention(BaseBERITestCase):
    def test_first_argument_register_contains_100(self):
        assert self.MIPS.a0 == 100
