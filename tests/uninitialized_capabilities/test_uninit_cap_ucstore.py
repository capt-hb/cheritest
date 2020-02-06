from beritest_tools import BaseBERITestCase

class test_uninit_cap_ucstore(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 2

    def test_writing_then_reading_succeeds(self):
        '''Writing on cursor with ucstore works and then reading on offset -1 results
           in the same value'''
        assert self.MIPS.a5 == 42

    def test_offset_is_incremented_after_ucstore(self):
        '''Offset after writing gets incremented'''
        assert self.MIPS.a0 == 0
        assert self.MIPS.a1 == 1
        assert self.MIPS.a2 == 2
        assert self.MIPS.a3 == 3 
        assert self.MIPS.a4 == 3 
        assert self.MIPS.a6 == 50
