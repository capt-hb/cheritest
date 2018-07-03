#
# Copyright (c) 2017 Alex Richardson
# Copyright (c) 2016-2017 Hongyan Xia
# Copyright (c) 2013-2014 Alan A. Mujumdar
# Copyright (c) 2015-2017 Alexandre Joannou
# Copyright (c) 2018 Alex Richardson
# Copyright (c) 2014 SRI International
# Copyright (c) 2012 Benjamin Thorner
# Copyright (c) 2013-2015 Colin Rothwell
# Copyright (c) 2012, 2014 David T. Chisnall
# Copyright (c) 2011-2014 Jonathan Woodruff
# Copyright (c) 2012-2015 Michael Roe
# Copyright (c) 2015 Paul J. Fox
# Copyright (c) 2012 Philip Paeps
# Copyright (c) 2011-2014 Robert M. Norton
# Copyright (c) 2011-2012 Robert N. M. Watson
# Copyright (c) 2011 William M. Morland
# Copyright (c) 2014 Joseph Stoy
# Copyright (c) 2011-2012 Steven J. Murdoch
#
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-10-C-0237
# ("CTSRD"), as part of the DARPA CRASH research programme.
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249
# ("MRC2"), as part of the DARPA MRC research programme.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#


# Build system for CHERI regression tests.  Tests fall into three categories:
#
# "raw" -- which run without any prior software initialisation.  This is used
# only for a few very early tests, such as checking default register values on
# reset.  These tests must explicitly dump the register file and terminate the
# simulation.  Source file names must match the pattern "test_raw_*.s".
#
# "test" -- some amount of software setup and tear-down, but running without
# the TLB enabled.  Tests implement a "test" function that accepts neither
# arguments nor returns values.  The framework will dump registers and
# terminate the simulator on completion.  This is suitable for most forms of
# tests, but not those that need to test final values of $ra, for example.
# Source file names must match the pattern "test_*.s".
#
# "c" -- tests written in the C language; similar to the "test" category, but
# based on a .c input file containing a single function test() with similar
# properties to the "test" case.  Source file names must match the pattern
# "test_*.c".
#
# "fuzz" -- tests generated by the fuzz tester. These have setup and teardown
# similar to the ordinary 'test' but with some differences because they have
# to run on gxemul which currently doesn't support cp2 etc. To generate tests
# run 'make fuzz_generate' then to run them use 'make nose_fuzz[_cached]'.
#
# As a further dimension, each test is run in two forms: at the default start
# address in the uncached xkphys region, and relocated to the cached xkphys
# region.  The latter requires an additional instructions to jump to the
# cached start location when the test begins.  Notice that there are .celf,
# .cmem, etc, indicating the version linked for cached instructions.
#
# Each test is accompanied by a Nose test case file, which analyses registers
# from the simulator run to decide if the test passed or not.  The Nose test
# framework drives each test, checks results, and summarises the test run on
# completion.
#
# Tests are run in the order listed in TEST_FILES; it is recommended they be
# sorted by rough functional dependence on CPU features.
#
# All tests must be in the $(TESTDIR) tree; if you add new sub-directories,
# remember to add them to $(TESTDIRS).  Some tests are annotated with Nose
# attributes so that they will be excluded on gxemul -- see GXEMUL_NOSEFLAGS.
#
# Setting the variable CHERI_SDK will ensure that the testsuite uses binaries
# from $(CHERI_SDK)
#
# "make" builds all the required parts
# "make test" runs the tests through CHERI
# "make gxemul-test" runs the tests through gxemul
#
dollar = $$
TEST_FPU?=0
TEST_CP2?=1
CLANG?=1
PURECAP?=1
MULTI?=0
MT?=0
STATCOUNTERS?=1
DMA?=0
DMA_VIRT?=0
TEST_RMA?=0
ALLOW_UNALIGNED?=0
FUZZ_DMA?=0
FUZZ_DMA_ONLY?=0
# Can be set to 1 on command line to disable fuzz tests, which can be useful at times.
# fuzz tests are currently broken
NOFUZZ?=1
NOFUZZR?=1
CAP_SIZE?=256

# CHECK that CAP_SIZE is a sensible value
ifneq ($(CAP_SIZE),64)
ifneq ($(CAP_SIZE),128)
ifneq ($(CAP_SIZE),256)
$(error "Invalid value for CAP_SIZE: $(CAP_SIZE))
endif
endif
endif

USE_CAP_TABLE?=1
ifeq ($(CAP_SIZE),256)
PERM_SIZE?=31
endif
ifeq ($(CAP_SIZE),128)
PERM_SIZE?=15
endif

ifeq ($(CAP_SIZE),256)
CAP_PRECISE?=1
else
CAP_PRECISE?=0
endif

L3_SIM?=l3mips

# Guess path to sail:
ifneq ($(wildcard ~/cheri/sail),)
# default path if built with cheribuild
SAIL_DIR?=~/cheri/sail
else
ifneq ($(wildcard ~/bitbucket/sail),)
# previous default
SAIL_DIR?=~/bitbucket/sail
else
SAIL_DIR?=/path/to/sail/must/be/set/on/cmdline/using/SAIL_DIR/var
endif
endif
SAIL_MIPS_SIM=$(SAIL_DIR)/mips/mips
SAIL_MIPS_C_SIM=$(SAIL_DIR)/mips/mips_c
SAIL_CHERI_SIM=$(SAIL_DIR)/cheri/cheri
SAIL_CHERI_C_SIM=$(SAIL_DIR)/cheri/cheri_c
SAIL_CHERI128_SIM=$(SAIL_DIR)/cheri/cheri128
SAIL_EMBED=$(SAIL_DIR)/src/run_embed.native
ifeq ($(TIMEOUT),)
TIMEOUT:=$(shell command -v timeout 2> /dev/null)
endif
ifeq ($(TIMEOUT),)
TIMEOUT:=$(shell command -v gtimeout 2> /dev/null)
endif
ifeq ($(TIMEOUT),)
TIMEOUT:=$(error timeout/gtimeout command not found)
endif


CC?=gcc
ifeq ($(CHERI_SDK_USE_GNU_AS),1)
MIPS_AS_ABICALLS=
else
MIPS_AS_ABICALLS=-mno-abicalls
endif
MIPS_ASFLAGS=$(MIPS_AS_ABICALLS) -EB -mabi=64 -G0 -ggdb $(DEFSYM_FLAG)TEST_CP2=$(TEST_CP2) $(DEFSYM_FLAG)CAP_SIZE=$(CAP_SIZE)
CWARNFLAGS?=-Werror -Wall -Wpedantic -Wno-option-ignored -Wno-language-extension-token -Wno-error=unused -Wno-error=pedantic
HYBRID_CFLAGS?=-ffreestanding -g -mno-abicalls -fno-pic -target cheri-unknown-freebsd -G 0 -mabi=n64 -integrated-as -O3 -ffunction-sections -nostdlibinc
PURECAP_CFLAGS?=-ffreestanding -g -fpic -target cheri-unknown-freebsd -G 0 -mabi=purecap -integrated-as -O3 -ffunction-sections -nostdlibinc -Itests/purecap

ifneq ($(CHERI$(CAP_SIZE)_SDK),)
CHERI_SDK:=$(CHERI$(CAP_SIZE)_SDK)
$(info Requested build for $(CAP_SIZE) bits, setting CHERI_SDK to $(dollar)CHERI256_SDK)
endif

# If CHERI_SDK is set use the binaries from the CHERI SDK
ifneq ($(CHERI_SDK),)
$(info Using CHERI SDK: $(CHERI_SDK))

# Append /bin to CHERI_SDK if needed:
ifneq ($(wildcard $(CHERI_SDK)/bin),)
CHERI_SDK_BINDIR:=$(CHERI_SDK)/bin
else
CHERI_SDK_BINDIR:=$(CHERI_SDK)
endif

CLANG_CMD?=$(CHERI_SDK_BINDIR)/clang -integrated-as
OBJDUMP?=$(CHERI_SDK_BINDIR)/llvm-objdump
# FIXME: elftoolchain objcopy is broken, hopefully llvm-objcopy is ready soon
#OBJCOPY?=$(CHERI_SDK_BINDIR)/objcopy

# For now force using the GNU AS since clang doesn't quite work (5 tests broken)
# CHERI_SDK_USE_GNU_AS?=1
# But LLD seems to work fine
# CHERI_SDK_USE_GNU_BINUTILS?=1

ifneq ($(CHERI_SDK_USE_GNU_BINUTILS),)
CHERI_SDK_USE_GNU_AS:=1
CHERI_SDK_USE_GNU_LD:=1
endif

# default to assembling with clang unless CHERI_SDK_USE_GNU_AS is set
ifndef CHERI_SDK_USE_GNU_AS
MIPS_AS=$(CLANG_AS)
# TODO: use llvm-mc?
# MIPS_AS=$(CHERI_SDK_BINDIR)/llvm-mc -filetype=obj -foo
USING_LLVM_ASSEMBLER=1
else # use GNU as otherwise
MIPS_AS=$(CHERI_SDK_BINDIR)/as
endif # CHERI_SDK_USE_GNU_AS

# default to linking with LLD unless CHERI_SDK_USE_GNU_LD is set
ifndef CHERI_SDK_USE_GNU_LD
MIPS_LD=$(CHERI_SDK_BINDIR)/ld.lld --fatal-warnings -process-cap-relocs
CAPSIZEFIX = :
else
MIPS_LD=$(CHERI_SDK_BINDIR)/ld.bfd --fatal-warnings
endif
ifneq ($(wildcard $(CHERI_SDK_BINDIR)/qemu-system-cheri$(CAP_SIZE)),)
ifneq ($(CAP_SIZE),256)
ifeq ($(CAP_PRECISE),1)
QEMU?=$(CHERI_SDK_BINDIR)/qemu-system-cheri$(CAP_SIZE)magic
else
endif # CAP_SIZE
endif # CAP_PRECISE
QEMU?=$(CHERI_SDK_BINDIR)/qemu-system-cheri$(CAP_SIZE)
endif # wildcard
QEMU?=$(CHERI_SDK_BINDIR)/qemu-system-cheri

else
# TODO: make this an error soon
$(info CHERI SDK not found, will try to infer tool defaults)
endif # neq(CHERI_SDK_BINDIR,)

# Use the default names from the ubuntu mips64-binutils if CHERI_SDK is not set
MIPS_AS?=mips64-as
MIPS_LD?=mips-linux-gnu-ld
OBJDUMP?=mips64-objdump
CAPSIZEFIX?= $(CHERI_SDK_BINDIR)/capsizefix --verbose $(1)
# try to find a working objcopy
ifeq ($(OBJCOPY),)
OBJCOPY:=$(shell command -v mips64-unknown-freeebsd-objcopy 2> /dev/null)
endif
ifeq ($(OBJCOPY),)
OBJCOPY:=$(shell command -v mips64-objcopy 2> /dev/null)
endif
ifeq ($(OBJCOPY),)
OBJCOPY:=$(shell command -v mips64-linux-gnuabi64-objcopy 2> /dev/null)
endif

# On Mac also fall back to gobjcopy (which supports mips)
ifeq ($(OBJCOPY),)
ifeq ($(shell uname -s),Darwin)
OBJCOPY:=/usr/local/bin/gobjcopy
endif
endif

CLANG_CMD?=clang
CLANG_CC?=$(CLANG_CMD) -target cheri-unknown-freebsd -mcpu=mips4 -cheri=$(CAP_SIZE)
CLANG_AS=$(CLANG_CC) -fno-pic -c -Wno-unused-command-line-argument -mno-abicalls

RUN_MIPS_LD?=$(MIPS_LD) --fatal-warnings -EB -G0 -L $(CURDIR)

USING_LLVM_ASSEMBLER?=0
ifeq ($(USING_LLVM_ASSEMBLER),1)
DEFSYM_FLAG=-Wa,-defsym,
else
DEFSYM_FLAG=-defsym=
# Without -march=mips4 the movz instruction will be rejected by GNU as
MIPS_AS:=$(MIPS_AS) -march=mips4 -defsym=_GNU_AS_=1
endif

ifeq ($(CAP_SIZE),128)
QEMU?=qemu-system-cheri128
else
QEMU?=qemu-system-cheri
endif


QEMU_ABSPATH:=$(shell command -v $(QEMU) 2>/dev/null)
ifneq ($(QEMU_ABSPATH),)
QEMU_VERSION:=$(shell $(QEMU_ABSPATH) --version)

# Use the weird $(if) syntax to avoid parsing all these values during tab completion
QEMU_UNALIGNED_OKAY_STRING=Built with support for unaligned loads/stores
QEMU_UNALIGNED_OKAY=$(if $(findstring $(QEMU_UNALIGNED_OKAY_STRING),$(QEMU_VERSION)),1,0)

QEMU_C0_IS_NULL_STRING=Built with C0 as NULL register
QEMU_C0_IS_NULL=$(if $(findstring $(QEMU_C0_IS_NULL_STRING),$(QEMU_VERSION)),1,0)

QEMU_CAP_SIZE=$(strip $(if \
    $(findstring Compiled for CHERI256,$(QEMU_VERSION)), 256, \
    $(if $(findstring Compiled for CHERI128,$(QEMU_VERSION)), 128, \
    $(error could not infer QEMU_CAP_SIZE from $(QEMU_ABSPATH): $(QEMU_VERSION)) )))

QEMU_CAP_PRECISE=$(strip $(if \
    $(findstring Compiled for CHERI256,$(QEMU_VERSION)), 1, \
    $(if $(findstring Compiled for CHERI128 (magic),$(QEMU_VERSION)), 1, \
    $(if $(findstring Compiled for CHERI128,$(QEMU_VERSION)), 0, \
    $(error could not infer QEMU_CAP_PRECISE from $(QEMU_ABSPATH): $(QEMU_VERSION)) ))))

#$(info QEMU built with QEMU_CAP_SIZE=$(QEMU_CAP_SIZE))
#$(info QEMU built with QEMU_CAP_PRECISE=$(QEMU_CAP_PRECISE))
#$(info QEMU built with QEMU_UNALIGNED_OKAY=$(QEMU_UNALIGNED_OKAY))
#$(info QEMU built with QEMU_C0_IS_NULL=$(QEMU_C0_IS_NULL))
endif  # ifneq ($(QEMU_ABSPATH),)

QEMU_UNALIGNED_OKAY?=0
QEMU_C0_IS_NULL?=0
QEMU_CAP_SIZE?=-1
QEMU_CAP_PRECISE?=-1

### Include all the TEST_*_FILES variables etc
include Makefile.files.mk

VPATH=$(TESTDIRS)
# The binaries for 128 and 256 are incompatible -> use separate objdirs
OBJDIR=obj/$(CAP_SIZE)

# Include the rules to build all the *.elf files now
include Makefile.build.mk


### Include the test rules:
include Makefile.tests.mk

all: sanity-check-makefile $(TEST_MEMS) $(TEST_CACHED_MEMS) $(TEST_DUMPS) $(TEST_CACHED_DUMPS) $(TEST_HEXS) $(TEST_CACHED_HEXS)

elfs: $(TEST_ELFS) $(TEST_CACHED_ELFS) $(TEST_MULTI_ELFS) $(TEST_CACHEDMULTI_ELFS)

dumps: $(TEST_DUMPS) $(TEST_CACHED_DUMPS) $(TEST_MULTI_DUMPS)

test: nosetest nosetest_cached

.PHONY: FORCE
FORCE:

test_hardware: altera-nosetest altera-nosetest_cached

$(CHERISOCKET):
	TMPDIR=$$(mktemp -d) && \
	cd $$TMPDIR && \
	cp $(CHERI_SW_MEM_BIN) mem.bin && \
	$(MEMCONV) bsim && \
	$(COPY_PISM_CONFS) && \
	LD_LIBRARY_PATH=$(CHERILIBS_ABS)/peripherals \
	PISM_MODULES_PATH=$(PISM_MODULES_PATH) \
	CHERI_CONFIG=$$TMPDIR/simconfig \
	$(SIM) &

# Because fuzz testing deals with lots of small files it is preferable to use
# find | xargs to remove them. For other cleans it is probably better to
# list the files explicitly.
clean_fuzz:
	find $(OBJDIR) $(LOGDIR) $(GXEMUL_LOGDIR) -name 'test_fuzz*' | xargs -r rm
	find $(FUZZ_TEST_DIR) -name 'test_fuzz*.s' | xargs -r rm

cleantest:
	rm -f $(GXEMUL_LOGDIR)/*.log
	rm -f $(ALTERA_LOGDIR)/*.log
	rm -f $(L3_LOGDIR)/*.log
	rm -f $(SAIL_MIPS_LOGDIR)/*.log
	rm -f $(SAIL_MIPS_C_LOGDIR)/*.log
	rm -f $(SAIL_CHERI_LOGDIR)/*.log
	rm -f $(SAIL_CHERI_C_LOGDIR)/*.log
	rm -f $(SAIL_CHERI128_LOGDIR)/*.log
	rm -f $(SAIL_CHERI128_EMBED_LOGDIR)/*.log
	rm -f $(QEMU_LOGDIR)/*.log
	rm -f $(LOGDIR)/*.log
	rm -f $(L3_LOGDIR)/*.err

clean: cleantest
	rm -f $(OBJDIR)/*.mem
	rm -f $(OBJDIR)/*.o
	rm -f $(OBJDIR)/*.elf
	rm -f $(OBJDIR)/*.dump
	rm -f $(TESTDIR)/*/*.pyc
	rm -f $(OBJDIR)/*.hex *.hex mem.bin

distclean:
	$(MAKE) $(MFLAGS) CAP_SIZE=256 clean
	$(MAKE) $(MFLAGS) CAP_SIZE=128 clean
	$(MAKE) $(MFLAGS) CAP_SIZE=64 clean

.PHONY: all clean cleantest clean_fuzz test nosetest nosetest_cached failnosetest

# Completely disable behaviour where make deletes intermediate
# files. It is not useful and prints huge output line at end.
.SECONDARY:

$(TOOLS_DIR_ABS)/debug/cherictl: $(TOOLS_DIR_ABS)/debug/cherictl.c $(TOOLS_DIR_ABS)/debug/cheri_debug.c
	$(MAKE) -C $(TOOLS_DIR_ABS)/debug/ cherictl

print-versions:
	$(NOSETESTS) --version

test_elfs: $(TEST_ELFS)
	@echo "Build all test .elf files"
test_objs: $(TEST_OBJS)
	@echo "Build all test .o files"
qemu_test_logs: $(QEMU_TEST_LOGS)
	@echo "Done running all tests in QEMU"

cleanerror:
	find log -size 0 | xargs -r --verbose rm

sanity-check-makefile: FORCE
	@echo
	@echo
	@echo "cheri source directory: $(CHERIROOT_ABS)"
	@echo "cheri libs directory: $(CHERILIBS_ABS)"
	@echo "cheri tools directory: $(TOOLS_DIR_ABS)"
ifeq ($(wildcard $(CHERILIBS_ABS)),)
	@echo "WARNING: \$(dollar)CHERLIBS not set -> will not be able to run simulator tests"
endif
ifeq ($(wildcard $(CHERIROOT_ABS)),)
	@echo "WARNING: \$(dollar)CHERIROOT not set -> will not be able to run simulator tests"
endif

	@echo Building test suite for $(CAP_SIZE)-bit capabilities
	@echo Permission size is $(PERM_SIZE)
	@echo OBJDIR is $(OBJDIR)
	@echo "Detected QEMU binary: $(QEMU)"
	@echo "    QEMU CHERI capability size: $(QEMU_CAP_SIZE)"
	@echo "    QEMU built with precise capabilities: $(QEMU_CAP_PRECISE)"
	@echo "    QEMU built with support for unaligned loads: $(QEMU_UNALIGNED_OKAY)"
	@echo "    QEMU built with C0 == NULL: $(QEMU_C0_IS_NULL)"
	@echo
	@echo "Sail MIPS: $(SAIL_MIPS_SIM)"
	@echo "Sail CHERI256: $(SAIL_CHERI_SIM)"
	@echo "Sail CHERI128: $(SAIL_CHERI128_SIM)"
	@echo

	@echo "Build tools:"
	@echo "Clang:     $(CLANG_CMD)"
	@echo "Assembler: $(MIPS_AS)"
	@echo "Linker:    $(MIPS_LD)"
	@echo "objdump:   $(OBJDUMP)"
ifeq ($(OBJCOPY),)
	# TODO: $(error) ?
	@echo "WARNING: $(dollar)OBJCOPY not found -> only QEMU tests will work
endif
	@echo "objcopy:   $(OBJCOPY)"
	@echo "cherictl:  $(CHERICTL)"
ifeq ($(wildcard $(CHERICTL)),)
	@echo "WARNING: \$(dollar)CHERICTL not found -> can't run tests on FPGA"
endif
	@echo
