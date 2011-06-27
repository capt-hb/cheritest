#
# Build system for CHERI regression tests.  Tests fall into two categories:
#
# "raw" -- which run without any prior software initialisation.  This is used
# only for a few very early tests, such as checking default register values on
# reset.  These tests must explicitly dump the register file and terminate the
# simulation.
#
# "test" -- some amount of software setup and tear-down, but running without
# the TLB enabled.  Tests implement a "test" function that accepts neither
# arguments nor returns values.  The framework will dump registers and
# terminate the simulator on completion.  This is suitable for most forms of
# tests, but not those that need to test final values of $ra, for example.
#
# Each test is accompanied by a Nose test case file, which analyses registers
# from the simulator run to decide if the test passed or not.  The Nose test
# framework drives each test, checks results, and summarises the test run on
# completion.
#
# Tests are run in the order listed in TEST_FILES; it is recommended they be
# sorted by rough functional dependence on CPU features.
#
# Note: For the time being, all tests must reside in the tests/ directory
# itself, and not in further sub-directories.
#
# "make" builds all the required parts
# "make test" runs the tests
#

TESTDIR=tests

TEST_FILES=					\
		raw_template.s			\
		raw_reg_init.s			\
		raw_hilo.s			\
		raw_dli.s			\
		raw_dli_sign.s			\
		raw_and.s			\
		raw_andi.s			\
		raw_nor.s			\
		raw_or.s			\
		raw_ori.s			\
		raw_xor.s			\
		raw_xori.s			\
		raw_jump.s			\
		raw_b.s				\
		raw_beq_eq.s			\
		raw_beq_eq_back.s		\
		raw_beq_gt.s			\
		raw_beq_lt.s			\
		raw_beql_eq.s			\
		raw_beql_eq_back.s		\
		raw_beql_gt.s			\
		raw_beql_lt.s			\
		raw_bgez_eq.s			\
		raw_bgez_eq_back.s		\
		raw_bgez_gt.s			\
		raw_bgez_lt.s			\
		raw_bgezal_eq.s			\
		raw_bgezal_eq_back.s		\
		raw_bgezal_gt.s			\
		raw_bgezal_lt.s			\
		raw_bgezall_eq.s		\
		raw_bgezall_eq_back.s		\
		raw_bgezall_gt.s		\
		raw_bgezall_lt.s		\
		raw_bgezl_eq.s			\
		raw_bgezl_eq_back.s		\
		raw_bgezl_gt.s			\
		raw_bgezl_lt.s			\
		raw_bgtz_eq.s			\
		raw_bgtz_gt_back.s		\
		raw_bgtz_gt.s			\
		raw_bgtz_lt.s			\
		raw_bgtzl_eq.s			\
		raw_bgtzl_gt_back.s		\
		raw_bgtzl_gt.s			\
		raw_bgtzl_lt.s			\
		raw_blez_eq_back.s		\
		raw_blez_eq.s			\
		raw_blez_gt.s			\
		raw_blez_lt.s			\
		raw_blezl_eq_back.s		\
		raw_blezl_eq.s			\
		raw_blezl_gt.s			\
		raw_blezl_lt.s			\
		raw_bltz_eq.s			\
		raw_bltz_gt.s			\
		raw_bltz_lt_back.s		\
		raw_bltz_lt.s			\
		raw_bltzal_eq.s			\
		raw_bltzal_gt.s			\
		raw_bltzal_lt_back.s		\
		raw_bltzal_lt.s			\
		raw_bltzall_eq.s		\
		raw_bltzall_gt.s		\
		raw_bltzall_lt_back.s		\
		raw_bltzall_lt.s		\
		raw_bltzl_eq.s			\
		raw_bltzl_gt.s			\
		raw_bltzl_lt.s			\
		raw_bltzl_lt_back.s		\
		raw_bne_eq.s			\
		raw_bne_gt.s			\
		raw_bne_lt_back.s		\
		raw_bne_lt.s			\
		raw_bnel_eq.s			\
		raw_bnel_gt.s			\
		raw_bnel_lt_back.s		\
		raw_bnel_lt.s			\
		raw_jr.s			\
		raw_jal.s			\
		raw_jalr.s			\
		raw_lb.s			\
		raw_lh.s			\
		raw_lw.s			\
		raw_ld.s			\
		raw_load_delay_reg.s		\
		raw_load_delay_store.s		\
		raw_sb.s			\
		raw_sh.s			\
		raw_sw.s			\
		raw_sd.s			\
		test_template.s			\
		test_reg_zero.s			\
		test_dli.s			\
		test_move.s			\
		test_hilo.s			\
		test_cp0_reg_init.s		\
		test_code_rom_relocation.s	\
		test_code_ram_relocation.s	\
		test_eret.s			\
		test_exception_bev1_trap.s	\
		test_exception_bev0_trap.s	\
		test_exception_bev0_trap_bd.s	\
		test_break.s			\
		test_syscall.s			\
		test_teq_eq.s			\
		test_teq_gt.s			\
		test_teq_lt.s			\
		test_teqi_eq.s			\
		test_teqi_gt.s			\
		test_teqi_lt.s			\
		test_teqi_eq_sign.s		\
		test_tge_eq.s			\
		test_tge_gt.s			\
		test_tge_lt.s			\
		test_tgei_eq.s			\
		test_tgei_gt.s			\
		test_tgei_lt.s			\
		test_tgei_eq_sign.s		\
		test_tgei_gt_sign.s		\
		test_tgei_lt_sign.s		\
		test_tgeiu_eq.s			\
		test_tgeiu_gt.s			\
		test_tgeiu_lt.s			\
		test_tgeu_eq.s			\
		test_tgeu_gt.s			\
		test_tgeu_lt.s			\
		test_cp0_compare.s

#
# We unconditionally terminate the simulator after TEST_CYCLE_LIMIT
# instructions to ensure that loops terminate.  This is an arbitrary number.
#
TEST_CYCLE_LIMIT=3000

##############################################################################
# No need to modify anything below this point if you are just adding new
# tests to current categories.
#

OBJDIR=obj
LOGDIR=log

RAW_LDSCRIPT=raw.ld
TEST_LDSCRIPT=test.ld
TEST_INIT_OBJECT=$(OBJDIR)/init.o
TEST_LIB_OBJECT=$(OBJDIR)/lib.o

TEST_OBJECTS := $(TEST_FILES:%.s=$(OBJDIR)/%.o)
TEST_ELFS := $(TEST_FILES:%.s=$(OBJDIR)/%.elf)
TEST_MEMS := $(TEST_FILES:%.s=$(OBJDIR)/%.mem)
TEST_DUMPS := $(TEST_FILES:%.s=$(OBJDIR)/%.dump)
TEST_LOGS := $(TEST_FILES:%.s=$(LOGDIR)/%.log)

MEMCONV=python ../tools/memConv.py

all: $(TEST_MEMS) $(TEST_DUMPS)

test: nosetest

cleantest:
	rm -f $(TEST_LOGS)

clean: cleantest
	rm -f $(TEST_INIT_OBJECT) $(TEST_LIB_OBJECT)
	rm -f $(TEST_OBJECTS) $(TEST_ELFS) $(TEST_MEMS) $(TEST_DUMPS)
	rm -f $(TESTDIR)/*.pyc
	rm -f *.hex mem.bin

.PHONY: all clean cleantest test nosetest failnosetest
.SECONDARY: $(TEST_OBJECTS) $(TEST_ELFS) $(TEST_MEMS) $(TEST_INIT_OBJECT) \
    $(TEST_LIB_OBJECT)

$(OBJDIR)/%.o : %.s
	sde-as -EB -march=mips64 -mabi=64 -G0 -ggdb -o $@ $<

$(OBJDIR)/%.o : $(TESTDIR)/%.s
	sde-as -EB -march=mips64 -mabi=64 -G0 -ggdb -o $@ $<

## TODO: rename these all to test_raw so that we are consistent 
$(OBJDIR)/raw_%.elf : $(OBJDIR)/raw_%.o $(RAW_LDSCRIPT)
	sde-ld -EB -G0 -T$(RAW_LDSCRIPT) $< -o $@ -m elf64btsmip

$(OBJDIR)/test_%.elf : $(OBJDIR)/test_%.o $(TEST_LDSCRIPT) \
	    $(TEST_INIT_OBJECT) $(TEST_LIB_OBJECT)
	sde-ld -EB -G0 -T$(TEST_LDSCRIPT) $(TEST_INIT_OBJECT) \
	    $(TEST_LIB_OBJECT) $< -o $@ -m elf64btsmip

$(OBJDIR)/%.mem : $(OBJDIR)/%.elf
	sde-objcopy -S -O binary $< $@

$(OBJDIR)/%.dump: $(OBJDIR)/%.elf
	sde-objdump -xsSd $< > $@

#
# memConv.py needs fixing so that it accepts explicit sources and
# destinations.  That way concurrent runs can't tread on each other, allowing
# testing with -j, etc.
#
.NOTPARALLEL:
$(LOGDIR)/%.log : $(OBJDIR)/%.mem
	cp $< mem.bin
	$(MEMCONV) bsim
	cp *.hex ..
	../sim -m $(TEST_CYCLE_LIMIT) > $@

# Simulate a failure on all unit tests
failnosetest: cleantest $(TEST_LOGS)
	DEBUG_ALWAYS_FAIL=1 PYTHONPATH=../tools nosetests $(NOSEFLAGS)

print-versions:
	nosetests --version

nosetest: all cleantest $(TEST_LOGS)
	PYTHONPATH=../tools nosetests $(NOSEFLAGS)
