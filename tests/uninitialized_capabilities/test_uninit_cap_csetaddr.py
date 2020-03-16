from beritest_tools import BaseBERITestCase

class test_uninit_cap_csetaddr(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 1

    def test_setting_address(self):
        assert self.MIPS.a0 == 2
