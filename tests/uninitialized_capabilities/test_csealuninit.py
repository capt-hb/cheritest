from beritest_tools import BaseBERITestCase

class test_csealuninit(BaseBERITestCase):
    EXPECTED_EXCEPTIONS = 1

    def test_uninit_after_unsealing(self):
        '''Test that uninit bit is 1 after unsealing and making uninit'''
        assert self.MIPS.a0 == 1
