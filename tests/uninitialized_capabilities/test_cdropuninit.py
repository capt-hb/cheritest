from beritest_tools import BaseBERITestCase

class test_cdropuninit(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 2

    def test_uninit_bit_of_capability(self):
        '''Test that the uninit bit of the capability is updated correctly'''
        assert self.MIPS.a0 == 0
        assert self.MIPS.a1 == 1
        assert self.MIPS.a2 == 1
        assert self.MIPS.a3 == 1
        assert self.MIPS.a4 == 0
