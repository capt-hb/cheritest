from bsim_utils import BaseBsimTestCase

class raw_sb(BaseBsimTestCase):
    def test_a0(self):
        '''Test unsigned load of stored byte from double word'''
        self.assertRegisterEqual(self.MIPS.a0, 0xfe, "Store and load of byte from double word failed")

    def test_a1(self):
        '''Test signed load of stored positive byte'''
        self.assertRegisterEqual(self.MIPS.a1, 1, "Store and signed load of positive byte failed")

    def test_a2(self):
        '''Test signed load of stored negative byte'''
        self.assertRegisterEqual(self.MIPS.a2, 0xffffffffffffffff, "Store and signed load of negative byte failed")

    def test_a3(self):
        '''Test unsigned load of stored positive byte'''
        self.assertRegisterEqual(self.MIPS.a3, 1, "Store and unsigned load of postive byte failed")

    def test_a4(self):
        '''Test unsigned load of stored negative byte'''
        self.assertRegisterEqual(self.MIPS.a4, 0xff, "Store and unsigned load of negative byte failed")

    def test_pos_offset(self):
        '''Test byte store, load at positive offset'''
        self.assertRegisterEqual(self.MIPS.a5, 2, "Byte store, load at positive offset failed")

    def test_neg_offset(self):
        '''Test byte store, load at negative offset'''
        self.assertRegisterEqual(self.MIPS.a6, 1, "Byte store, load at negative offset failed")

