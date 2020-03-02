from beritest_tools import BaseBERITestCase

class test_purecap_uninit_calling_convention(BaseBERITestCase):
    def test_first_argument_register_contains_100(self):
        assert self.MIPS.a0 == 100

    def test_result_of_something_is_100(self):
        assert self.MIPS.v0 == 100
