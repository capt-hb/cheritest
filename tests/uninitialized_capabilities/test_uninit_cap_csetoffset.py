from beritest_tools import BaseBERITestCase

class test_uninit_cap_csetoffset(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 1

    def test_offset_correctly_updated_after_store(self):
        '''test that the cursor has been decremented with the correct size'''
        assert self.MIPS.a1 == 1
        assert self.MIPS.a2 == 2
        assert self.MIPS.a3 == 4
        assert self.MIPS.a4 == 8
        assert self.MIPS.a5 == 15

    def test_set_offset_outside_of_bounds(self):
        '''Should be possible to set offset outside of bounds'''
        assert self.MIPS.a6 == 115
