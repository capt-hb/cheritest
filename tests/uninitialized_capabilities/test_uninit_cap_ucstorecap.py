import os
from beritest_tools import BaseBERITestCase

class test_uninit_cap_ucstorecap(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 0

    def test_offset_is_decremented_after_ucstorecap(self):
        '''Offset after writing gets incremented'''
        assert self.MIPS.a0 == 80
        assert self.MIPS.a1 == 76
        assert self.MIPS.a2 == 80 
        assert self.MIPS.a3 == 80 
        assert self.MIPS.a4 == 80 
        assert self.MIPS.s1 == int(os.environ['CAP_SIZE']) / 8
