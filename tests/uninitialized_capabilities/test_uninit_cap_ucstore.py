from beritest_tools import BaseBERITestCase

class test_uninit_cap_ucstore(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 1

    def test_offset_is_incremented_after_ucstore(self):
        '''Offset after writing gets incremented'''
        assert self.MIPS.a0 == 15
        assert self.MIPS.a1 == 10
        assert self.MIPS.a2 == 42
        assert self.MIPS.a3 == 100
        assert self.MIPS.a4 == 420 
        assert self.MIPS.s0 == 10
        assert self.MIPS.s1 == 42
        assert self.MIPS.s2 == 100
        assert self.MIPS.s3 == 420 
