from beritest_tools import BaseBERITestCase

class test_uninit_cap_csetoffset(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 1

    def test_setting_offset_lower_than_cursor(self):
        '''Setting the offset lower than the offset is currently at should succeed'''
        assert self.MIPS.a1 == 1
        assert self.MIPS.a2 == 0
        assert self.MIPS.a3 == 1
        assert self.MIPS.a4 == 0
        assert self.MIPS.a5 == 1
        assert self.MIPS.a6 == 0

    def test_set_offset_higher_once_cap_is_completely_written_to(self):
        '''Should be possible to set offset outside of bounds when cap is completely written to'''
        assert self.MIPS.a7 == 4
