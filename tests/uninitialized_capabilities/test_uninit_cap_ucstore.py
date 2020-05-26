from beritest_tools import BaseBERITestCase

class test_uninit_cap_ucstore(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 1

    def test_offset_is_decremented_after_ucstore(self):
        '''Offset after writing gets decremented'''
        assert self.MIPS.a0 == 15
        assert self.MIPS.a0 - self.MIPS.t2 == 1
        assert self.MIPS.t2 - self.MIPS.t3 == 2
        assert self.MIPS.t3 - self.MIPS.v0 == 4
        assert self.MIPS.v0 - self.MIPS.v1 == 8

    def test_stored_values_are_correct(self):
        '''test stored values can be loaded and have the same value'''
        assert self.MIPS.a1 == 10
        assert self.MIPS.a2 == 42
        assert self.MIPS.a3 == 100
        assert self.MIPS.a4 == 420 
        assert self.MIPS.s0 == 10
        assert self.MIPS.s1 == 42
        assert self.MIPS.s2 == 100
        assert self.MIPS.s3 == 420 
