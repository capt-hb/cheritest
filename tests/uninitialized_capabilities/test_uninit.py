from beritest_tools import BaseBERITestCase

class test_uninit(BaseBERITestCase):
    def test_uninit_is_zero_of_default_cap(self):
        '''Test that the default capability has the uninit bit set to 0'''
        assert self.MIPS.c1.uninit == 0

    def test_uninit_non_zero(self):
        '''Test that the uninit bit is non-zero after making a capability uninitialized'''
        assert self.MIPS.c2.uninit == 1
