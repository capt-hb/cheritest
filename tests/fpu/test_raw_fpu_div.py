from cheritest_tools import BaseCHERITestCase

class test_raw_fpu_div(BaseCHERITestCase):
    def test_div(self):
        '''Test we can divide'''
        self.assertRegisterEqual(self.MIPS.s0, 0xFFF0000000000000, "Failed to divide Inf by 0.0 in double precision");
        self.assertRegisterEqual(self.MIPS.s1, 0x40800000, "Failed to divide 20.0 by 5.0 in single precision");
        self.assertRegisterEqual(self.MIPS.s3, 0x7FF1000000000000, "Failed to echo QNaN");
        self.assertRegisterEqual(self.MIPS.s4, 0x0, "Failed to flush denormalised result");
