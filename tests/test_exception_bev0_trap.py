from bsim_utils import BaseBsimTestCase

class test_exception_bev0_trap(BaseBsimTestCase):
    def test_epc(self):
        self.assertRegisterEqual(self.MIPS.a0, self.MIPS.a5, "EPC not set properly")

    def test_returned(self):
        self.assertRegisterEqual(self.MIPS.a1, 1, "flow broken by trap instruction")

    def test_bev1_handled(self):
        self.assertRegisterEqual(self.MIPS.a2, 1, "ROM exception handler not run")

    def test_bev0_not_handled(self):
        self.assertRegisterNotEqual(self.MIPS.a6, 1, "RAM exception handler run")

    def test_exl_in_handler(self):
        self.assertRegisterEqual((self.MIPS.a3 >> 1) & 0x1, 1, "EXL not set in exception handler")

    def test_cause_bd(self):
        self.assertRegisterEqual((self.MIPS.a4 >> 31) & 0x1, 0, "Branch delay (BD) flag improperly set")

    def test_cause_code(self):
        self.assertRegisterEqual((self.MIPS.a4 >> 2) & 0x1f, 13, "Code not set to Tr")

    def test_not_exl_after_handler(self):
        self.assertRegisterEqual((self.MIPS.a7 >> 1) & 0x1, 0, "EXL still set after ERET")
