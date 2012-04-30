from cheritest_tools import BaseCHERITestCase
import os
import tools.sim
expected_uncached=[
    0x0,
    0x800000000000000,
    0x20,
    0x2a28,
    0x9000000040000a00,
    0x2000,
    0x40000000,
    0x100001e,
    0x100005e,
    0xfedcba9876543210,
    0x20aa,
    0x1020304050607080,
    0x9800000040000a00,
    0xffffffffffbfffff,
    0xe0e0e0e0e0e0e0e,
    0xf0f0f0f0f0f0f0f,
    0xa00,
    0x2a00,
    0x2a08,
    0x0,
    0x0,
    0x0,
    0x20aa,
    0x2,
    0x1818181818181818,
    0x1919191919191919,
    0x0,
    0x1b1b1b1b1b1b1b1b,
    0x1c1c1c1c1c1c1c1c,
    0x9000000000007fe0,
    0x9000000000008000,
    0x9000000040000338,
  ]
expected_cached=[
    0x0,
    0x800000000000000,
    0x20,
    0x2a48,
    0x9800000040000a20,
    0x2000,
    0x40000000,
    0x100001e,
    0x100005e,
    0xfedcba9876543210,
    0x20aa,
    0x1020304050607080,
    0x9800000040000a20,
    0xffffffffffbfffff,
    0xe0e0e0e0e0e0e0e,
    0xf0f0f0f0f0f0f0f,
    0xa20,
    0x2a20,
    0x2a28,
    0x0,
    0x0,
    0x0,
    0x20aa,
    0x2,
    0x1818181818181818,
    0x1919191919191919,
    0x0,
    0x1b1b1b1b1b1b1b1b,
    0x1c1c1c1c1c1c1c1c,
    0x9800000000007fe0,
    0x9800000000008000,
    0x9800000040000358,
  ]
class test_regfuzz_tlb_00000700(BaseCHERITestCase):
  def test_registers_expected(self):
    cached=bool(int(os.getenv('CACHED',False)))
    expected=expected_cached if cached else expected_uncached
    for reg in xrange(len(tools.sim.MIPS_REG_NUM2NAME)):
      self.assertRegisterExpected(reg, expected[reg])

