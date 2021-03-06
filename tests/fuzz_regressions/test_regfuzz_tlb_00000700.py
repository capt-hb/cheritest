from beritest_tools import BaseBERITestCase
from beritest_tools import attr
import os
import tools.sim
expected_uncached=[
    0x0,
    0x800000000000000,
    0x20,
    0x2da8,
    0x9000000040000d80,
    0x2000,
    0x40000000,
    0x100001e,
    0x100005e,
    0xfedcba9876543210,
    0x20aa,
    0x1020304050607080,
    0x9800000040000d80,
    0xffffffffffbfffff,
    0xe0e0e0e0e0e0e0e,
    0xf0f0f0f0f0f0f0f,
    0xd80,
    0x2d80,
    0x2d88,
    0x0,
    0x0,
    0x0,
    0x20aa,
    0x2,
    0x1818181818181818,
    0x9000000040000ba0,
    0x0,
    0x1b1b1b1b1b1b1b1b,
    0x1c1c1c1c1c1c1c1c,
    0x9000000000007fe0,
    0x9000000000008000,
    0x900000004000038c,
  ]
expected_cached=[
    0x0,
    0x800000000000000,
    0x20,
    0x2de8,
    0x9800000040000dc0,
    0x2000,
    0x40000000,
    0x100001e,
    0x100005e,
    0xfedcba9876543210,
    0x20aa,
    0x1020304050607080,
    0x9800000040000dc0,
    0xffffffffffbfffff,
    0xe0e0e0e0e0e0e0e,
    0xf0f0f0f0f0f0f0f,
    0xdc0,
    0x2dc0,
    0x2dc8,
    0x0,
    0x0,
    0x0,
    0x20aa,
    0x2,
    0x1818181818181818,
    0x9800000040000bc0,
    0x0,
    0x1b1b1b1b1b1b1b1b,
    0x1c1c1c1c1c1c1c1c,
    0x9800000000007fe0,
    0x9800000000008000,
    0x98000000400003ac,
  ]
@attr('fuzz_test_regression')
class test_regfuzz_tlb_00000700(BaseBERITestCase):
  @attr('tlb')
  def test_registers_expected(self):
    cached=bool(int(os.getenv('CACHED',False)))
    expected=expected_cached if cached else expected_uncached
    for reg in range(len(tools.sim.MIPS_REG_NUM2NAME)):
      self.assertRegisterExpected(reg, expected[reg])

