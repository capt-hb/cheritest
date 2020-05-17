from beritest_tools import BaseBERITestCase

class test_cshrink(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 1

    def test_cshrink_lowers_end(self):
        '''Test that lowering the end of a capability works'''
        assert self.MIPS.a0 == 10
        assert self.MIPS.a1 == 8
        assert self.MIPS.a1 < self.MIPS.a0

    def test_cshrink_with_cursor_at_end_does_nothing(self):
        '''Test that using cshrink with a capability for which cursor=end does not change end'''
        assert self.MIPS.a0 == self.MIPS.a2
