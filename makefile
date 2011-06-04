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
# Each test is accompanied by a predicate file, which implements a perl
# fragment that analyses registers from a simulator run to decide if the test
# passed or not.  Successful tests return "OK", and unsuccessul ones some
# other useful diagnostic string.
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
		raw_reg_load_immediate.s	\
		raw_branch_unconditional.s	\
		raw_jump_and_link.s		\
		raw_load_byte.s			\
		raw_load_hword.s		\
		raw_load_word.s			\
		raw_load_dword.s		\
		raw_store_byte.s		\
		raw_store_hword.s		\
		raw_store_word.s		\
		raw_store_dword.s		\
		test_template.s			\
		test_reg_zero.s			\
		test_reg_load_immediate.s	\
		test_reg_assignment.s		\
		test_cp0_reg_init.s

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
TEST_INIT=init.s
TEST_INIT_OBJECT=init.o

TEST_PREDS := $(TEST_FILES:%.s=$(LOGDIR)/%.pred)

TEST_OBJECTS := $(TEST_FILES:%.s=$(OBJDIR)/%.o)
TEST_ELFS := $(TEST_FILES:%.s=$(OBJDIR)/%.elf)
TEST_MEMS := $(TEST_FILES:%.s=$(OBJDIR)/%.mem)
TEST_LOGS := $(TEST_FILES:%.s=$(LOGDIR)/%.log)
TEST_RESULTS := $(TEST_FILES:%.s=$(LOGDIR)/%.result)

MEMCONV=python ../tools/memConv.py
TESTPREDICATE=perl ../tools/testPredicate.pl

all: $(TEST_MEMS)

test: cleantest $(TEST_LOGS) $(TEST_RESULTS)

cleantest:
	rm -f $(TEST_LOGS) $(TEST_RESULTS)

clean: cleantest
	rm -f $(TEST_INIT_OBJECT)
	rm -f $(TEST_OBJECTS) $(TEST_ELFS) $(TEST_MEMS)
	rm -f *.hex mem.bin

.PHONY: all clean cleantest test
.SECONDARY: $(TEST_OBJECTS) $(TEST_ELFS) $(TEST_MEMS)

init.o: init.s
	sde-as -EB -march=mips64 -mabi=64 -G0 -ggdb -o init.o init.s

$(OBJDIR)/%.o : $(TESTDIR)/%.s
	sde-as -EB -march=mips64 -mabi=64 -G0 -ggdb -o $@ $<

## TODO: rename these all to test_raw so that we are consistent 
$(OBJDIR)/raw_%.elf : $(OBJDIR)/raw_%.o $(RAW_LDSCRIPT)
	sde-ld -EB -G0 -T$(RAW_LDSCRIPT) $< -o $@ -m elf64btsmip

$(OBJDIR)/test_%.elf : $(OBJDIR)/test_%.o $(TEST_LDSCRIPT) $(TEST_INIT_OBJECT)
	sde-ld -EB -G0 -T$(TEST_LDSCRIPT) $(TEST_INIT_OBJECT) \
	    $< -o $@ -m elf64btsmip

$(OBJDIR)/%.mem : $(OBJDIR)/%.elf
	sde-objcopy -S -O binary $< $@

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

$(LOGDIR)/%.result : $(TESTDIR)/%.pred $(LOGDIR)/%.log
	-$(TESTPREDICATE) $(LOGDIR)/$(basename $(notdir $@)).log \
	    $(TESTDIR)/$(basename $(notdir $@)).pred $@

nosetest: cleantest $(TEST_LOGS)
	PYTHONPATH=../tools nosetests

