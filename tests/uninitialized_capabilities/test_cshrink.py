from beritest_tools import BaseBERITestCase

class test_cshrink(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 1

    def test_cshrink_lowers_end(self):
        '''Test that lowering the end of a capability works'''
        assert self.MIPS.a0 == 10
        assert self.MIPS.a1 == 9
        assert self.MIPS.a1 < self.MIPS.a0
        assert self.MIPS.a2 == 1

    def test_cshrink_with_cursor_at_end_does_nothing(self):
        '''Test that using cshrink with a capability for which cursor=end does not change end'''
        assert self.MIPS.a0 == self.MIPS.a3

    def test_cshrink_increases_base(self):
        assert self.MIPS.t0 == self.MIPS.t1
        assert self.MIPS.t0 == self.MIPS.t3
        assert self.MIPS.t0 + 1 == self.MIPS.t2

