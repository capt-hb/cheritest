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
# "make" builds all the required parts
# "make test" runs the tests through CHERI
# "make gxemul-test" runs the tests through gxemul
#

TEST_CP2?=1
CLANG?=1
MULTI?=0

#
# List of directories in which to find test source and .py files.
#
TESTDIR=tests
TESTDIRS=					\
		$(TESTDIR)/framework		\
		$(TESTDIR)/alu			\
		$(TESTDIR)/branch		\
		$(TESTDIR)/tlb			\
		$(TESTDIR)/mem			\
		$(TESTDIR)/cache		\
		$(TESTDIR)/cp0                  \
		$(TESTDIR)/cp2                  \
		$(TESTDIR)/fuzz_regressions     \
		$(TESTDIR)/c                    \
		$(TESTDIR)/mt			

ifeq ($(MULTI),1)
TESTDIRS += $(TESTDIR)/multicore
endif

ifneq ($(NOFUZZ),1)
TESTDIRS += $(TESTDIR)/fuzz
endif

ifeq ($(BRIEF_GXEMUL),1)
GXEMUL_LOG_FILTER=grep -A100 'cpu0:    pc = '
else
GXEMUL_LOG_FILTER=cat
endif

ifdef COP1
		TESTDIRS += $(TESTDIR)/fpu
endif

ifdef COP1_ONLY
		TESTDIRS = $(TESTDIR)/fpu
endif

ifdef TEST_TRACE
		TESTDIRS += $(TESTDIR)/trace
endif

ifdef TEST_TRACE_ONLY
		TESTDIRS = $(TESTDIR)/trace
endif

RAW_FRAMEWORK_FILES=				\
		test_raw_template.s		\
		test_raw_reg_init.s		\
		test_raw_hilo.s			\
		test_raw_dli.s			\
		test_raw_dli_sign.s		\
		test_raw_reg_name.s		\
		test_raw_nop.s			\
		test_raw_ssnop.s		\
		test_raw_lui.s			\
		test_raw_counterdev.s

RAW_ALU_FILES=					\
		test_raw_add.s			\
		test_raw_addi.s			\
		test_raw_addiu.s		\
		test_raw_addu.s			\
		test_raw_and.s			\
		test_raw_arithmetic_combo.s	\
		test_raw_sub.s			\
		test_raw_subu.s			\
		test_raw_dadd.s			\
		test_raw_daddi.s		\
		test_raw_daddiu.s		\
		test_raw_daddu.s		\
		test_raw_dsub.s			\
		test_raw_dsubu.s		\
		test_raw_andi.s			\
		test_raw_nor.s			\
		test_raw_or.s			\
		test_raw_ori.s			\
		test_raw_xor.s			\
		test_raw_xori.s			\
		test_raw_sll.s			\
		test_raw_sllv.s			\
		test_raw_srl.s			\
		test_raw_srlv.s			\
		test_raw_sra.s			\
		test_raw_srav.s			\
		test_raw_dsll.s			\
		test_raw_dsllv.s		\
		test_raw_dsll32.s		\
		test_raw_dsrl.s			\
		test_raw_dsrlv.s		\
		test_raw_dsrl32.s		\
		test_raw_dsra.s			\
		test_raw_dsrav.s		\
		test_raw_dsra32.s

RAW_BRANCH_FILES=				\
		test_raw_jump.s			\
		test_raw_b.s			\
		test_raw_b_maxoffset.s		\
		test_raw_beq_eq.s		\
		test_raw_beq_eq_back.s		\
		test_raw_beq_gt.s		\
		test_raw_beq_lt.s		\
		test_raw_beql_eq.s		\
		test_raw_beql_eq_back.s		\
		test_raw_beql_gt.s		\
		test_raw_beql_lt.s		\
		test_raw_bgez_eq.s		\
		test_raw_bgez_eq_back.s		\
		test_raw_bgez_gt.s		\
		test_raw_bgez_lt.s		\
		test_raw_bgezal_eq.s		\
		test_raw_bgezal_eq_back.s	\
		test_raw_bgezal_gt.s		\
		test_raw_bgezal_lt.s		\
		test_raw_bgezall_eq.s		\
		test_raw_bgezall_eq_back.s	\
		test_raw_bgezall_gt.s		\
		test_raw_bgezall_lt.s		\
		test_raw_bgezl_eq.s		\
		test_raw_bgezl_eq_back.s	\
		test_raw_bgezl_gt.s		\
		test_raw_bgezl_lt.s		\
		test_raw_bgtz_eq.s		\
		test_raw_bgtz_gt_back.s		\
		test_raw_bgtz_gt.s		\
		test_raw_bgtz_lt.s		\
		test_raw_bgtzl_eq.s		\
		test_raw_bgtzl_gt_back.s	\
		test_raw_bgtzl_gt.s		\
		test_raw_bgtzl_lt.s		\
		test_raw_blez_eq_back.s		\
		test_raw_blez_eq.s		\
		test_raw_blez_gt.s		\
		test_raw_blez_lt.s		\
		test_raw_blezl_eq_back.s	\
		test_raw_blezl_eq.s		\
		test_raw_blezl_gt.s		\
		test_raw_blezl_lt.s		\
		test_raw_bltz_eq.s		\
		test_raw_bltz_gt.s		\
		test_raw_bltz_lt_back.s		\
		test_raw_bltz_lt.s		\
		test_raw_bltzal_eq.s		\
		test_raw_bltzal_gt.s		\
		test_raw_bltzal_lt_back.s	\
		test_raw_bltzal_lt.s		\
		test_raw_bltzall_eq.s		\
		test_raw_bltzall_gt.s		\
		test_raw_bltzall_lt_back.s	\
		test_raw_bltzall_lt.s		\
		test_raw_bltzl_eq.s		\
		test_raw_bltzl_gt.s		\
		test_raw_bltzl_lt.s		\
		test_raw_bltzl_lt_back.s	\
		test_raw_bne_eq.s		\
		test_raw_bne_gt.s		\
		test_raw_bne_lt_back.s		\
		test_raw_bne_lt.s		\
		test_raw_bnel_eq.s		\
		test_raw_bnel_gt.s		\
		test_raw_bnel_lt_back.s		\
		test_raw_bnel_lt.s		\
		test_raw_jr.s			\
		test_raw_jal.s			\
		test_raw_jalr.s                 \
		test_raw_tlb_j.s

RAW_MEM_FILES=					\
		test_raw_lb.s			\
		test_raw_lh.s			\
		test_raw_lw.s			\
		test_raw_ld.s			\
		test_raw_ld_beq_gt_pipeline.s	\
		test_raw_load_delay_reg.s	\
		test_raw_load_delay_store.s	\
		test_raw_cache_write_to_use.s \
		test_raw_sb.s			\
		test_raw_sh.s			\
		test_raw_sw.s			\
		test_raw_sd.s			\
		test_raw_ldl.s			\
		test_raw_ldr.s			\
		test_raw_lwl.s			\
		test_raw_lwr.s			\
		test_raw_sdl.s			\
		test_raw_sdr.s			\
		test_raw_swl.s			\
		test_raw_swr.s

RAW_LLSC_FILES=					\
		test_raw_ll.s			\
		test_raw_lld.s			\
		test_raw_sc.s			\
		test_raw_scd.s

RAW_CP0_FILES=					\
		test_raw_mfc0_dmfc0.s		\
		test_raw_mtc0_sign_extend.s

RAW_CP2_FILES=					\
		test_raw_capinstructions.s

RAW_FPU_FILES =                \
        test_raw_fpu_cntrl.s    \
        test_raw_fpu_abs.s      \
        test_raw_fpu_add.s      \
        test_raw_fpu_sub.s      \
        test_raw_fpu_mul.s      \
        test_raw_fpu_div.s      \
        test_raw_fpu_neg.s      \
        test_raw_fpu_recip.s    \
        test_raw_fpu_sqrt.s     \
        test_raw_fpu_rsqrt.s    \
        test_raw_fpu_cf.s       \
        test_raw_fpu_cun.s      \
        test_raw_fpu_ceq.s      \
        test_raw_fpu_cueq.s     \
        test_raw_fpu_colt.s     \
        test_raw_fpu_cult.s     \
        test_raw_fpu_cole.s     \
        test_raw_fpu_cule.s     \
        test_raw_fpu_branch.s   \
        test_raw_fpu_mov_gpr.s  \
        test_raw_fpu_mov_cc.s   \
        test_raw_fpu_pair.s	\
	test_raw_fpu_cvt_paired.s \
	test_raw_fpu_add_d32.s \
	test_raw_fpu_sub_d32.s \
	test_raw_fpu_mul_d32.s \
	test_raw_fpu_div_d32.s \
	test_raw_fpu_sqrt_d32.s \
	test_raw_fpu_cvt_d32.s \
	test_raw_fpu_cole_single.s \
	test_raw_fpu_colt_single.s \
	test_raw_fpu_cule_single.s \
	test_raw_fpu_cult_single.s \
	test_raw_fpu_cueq_single.s \
	test_raw_fpu_ceq_single.s \
	test_raw_fpu_cun_single.s \
	test_raw_fpu_colt_d64.s \
	test_raw_fpu_cole_d64.s \
	test_raw_fpu_ceq_d64.s \
	test_raw_fpu_cun_d64.s \
	test_raw_fpu_cueq_d64.s \
	test_raw_fpu_cule_d64.s \
	test_raw_fpu_cult_d64.s \
	test_raw_fpu_round_single.s \
	test_raw_fpu_ceil_single.s \
	test_raw_fpu_floor_single.s \
	test_raw_fpu_trunc_single.s \
	test_raw_fpu_qnan_single.s \
	test_raw_fpu_underflow.s \
	test_raw_fpu_div_small.s \
	test_raw_fpu_denorm.s \
	test_raw_fpu_trunc_d64.s \
	test_raw_fpu_floor_d64.s \
	test_raw_fpu_ceil_d64.s \
	test_raw_fpu_round_d64.s \
	test_raw_fpu_cvt_s_w.s \
	test_raw_fpu_cvt_s_l_d64.s \
	test_raw_fpu_cvt_w_d_d64.s \
	test_raw_fpu_cvt_d_w_d64.s \
	test_raw_fpu_cvt_d_l_d64.s \
	test_fpu_exception_pipeline.s \
	test_fpu_x_disabled.s \
	test_fpu_x_ldc1_disabled.s \
	test_fpu_x_mthc1.s \
	test_raw_fpu_bc1t_pipeline.s \
		test_raw_fpu_cvt.log	\
		test_raw_fpu_cvtw.log	\
		test_raw_fpu_movci.log	\
		test_raw_fpu_sd_ld.log	\
		test_raw_fpu_sw_lw.log	\
		test_raw_fpu_xc1.log	\

TEST_FRAMEWORK_FILES=				\
		test_template.s			\
		test_reg_zero.s			\
		test_dli.s			\
		test_move.s			\
		test_movz_movn_pipeline.s	\
		test_code_rom_relocation.s	\
		test_code_ram_relocation.s	\
		test_ctemplate.c		\
		test_casmgp.c			\
		test_cretval.c			\
		test_crecurse.c			\
		test_cglobals.c                 \
		test_raw_jr_cachd.s             \

TEST_ALU_FILES=					\
		test_hilo.s			\
		test_div.s			\
		test_divu.s			\
		test_ddiv.s			\
		test_ddivu.s			\
		test_mult.s			\
		test_multu.s			\
		test_dmult.s			\
		test_dmultu.s			\
		test_madd.s			\
		test_msub.s			\
		test_mul_div_loop.s		\
		test_mult_exception.s		\
		test_slt.s			\
		test_slti.s			\
		test_sltiu.s			\
		test_sltu.s

TEST_MEM_FILES=					\
		test_hardware_mappings.s	\
		test_hardware_mappings_write.s	\
		test_ld_cancelled.s			\
		test_memory_flush		\
		test_sd_burst.s			\
		test_storeload.s		\
		test_sync.s                     \
		test_mem_alias_data.s

TEST_LLSC_FILES=				\
		test_ll_unalign.s		\
		test_lld_unalign.s		\
		test_sc_unalign.s		\
		test_scd_unalign.s		\
		test_llsc.s			\
		test_lldscd.s			\
		test_cp0_lladdr.s

TEST_CACHE_FILES=				\
		test_hardware_mapping_cached_read.s \
		test_cache_instruction_data.s   \
		test_cache_instruction_instruction.s \
		test_cache_instruction_L2.s     

TEST_CP0_FILES=					\
		test_cp0_reg_init.s		\
		test_cp0_config1		\
		test_cp0_config3		\
		test_eret.s			\
		test_exception_bev0_trap.s	\
		test_exception_bev0_trap_bd.s	\
		test_break.s			\
		test_syscall.s			\
		test_syscall2.s			\
		test_syscall50.s		\
		test_syscall_cache_store.s	\
		test_teq_eq.s			\
		test_teq_gt.s			\
		test_teq_lt.s			\
		test_tge_eq.s			\
		test_tge_gt.s			\
		test_tge_lt.s			\
		test_tgeu_eq.s			\
		test_tgeu_gt.s			\
		test_tgeu_lt.s			\
		test_tlt_eq.s			\
		test_tlt_gt.s			\
		test_tlt_lt.s			\
		test_tltu_eq.s			\
		test_tltu_gt_sign.s		\
		test_tltu_gt.s			\
		test_tltu_lt.s			\
		test_tne_eq.s			\
		test_tne_gt.s			\
		test_tne_lt.s			\
		test_cp0_compare.s              \
		test_cp0_watch_instr.s          \
		test_cp0_watch_load.s           \
		test_cp0_watch_store.s          \
		test_cp0_user.s                 \
		test_cp0_ri.s			\
		test_cp0_counter.s		\
		test_cp0_userlocal.s		\
		test_cp0_rdhwr_user.s

TEST_FPU_FILES=					\
		test_fpu_exception_pipeline.s	\
		test_fpu_x_div.s		\
		test_fpu_x_underflow.s		\
		test_fpu_x_overflow.s		\
		test_fpu_x_c_nan.s

ifeq ($(TEST_CP2),1)
TEST_CP2_FILES=					\
		test_cp2_reg_init.s		\
		test_cp2_reg_name.s		\
		test_cp2_getsettype.s		\
		test_cp2_getincbase.s		\
		test_cp2_getsetleng.s		\
		test_cp2_getandperm.s		\
		test_cp2_getcleartag.s		\
		test_cp2_getunsealed.s		\
		test_cp2_getpcc.s		\
		test_cp2_cmove.s		\
		test_cp2_ccleartag_base.s	\
		test_cp2_cscr.s			\
		test_cp2_clcr.s			\
		test_cp2_clcr_tag.s		\
		test_cp2_csci.s			\
		test_cp2_csc_neg.s		\
		test_cp2_cjr.s			\
		test_cp2_cjalr_rcc.s		\
		test_cp2_cjalr_pcc.s		\
		test_cp2_cjalr.s		\
		test_cp2_cjalr_loop.s		\
		test_cp2_kcc.s			\
		test_cp2_kr1c.s			\
		test_cp2_kr2c.s			\
		test_cp2_kdc.s			\
		test_cp2_tagmem.s		\
		test_cp2_tagstore.s		\
		test_cp2_tagstorec0.s		\
		test_cp2_cmove_tag.s		\
		test_cp2_cmove_sealed.s		\
		test_cp2_cswitch.s		\
		test_cp2_cswitch_clr.s		\
		test_cp2_cswitch_clr_20.s	\
		test_cp2_alu_mod_pipeline.s	\
		test_cp2_mem_mod_pipeline.s	\
		test_cp2_get_alu_pipeline.s	\
		test_cp2_get_mem_pipeline.s	\
		test_cp2_mod_mod_pipeline.s	\
		test_cp2_load_pipeline.s	\
		test_cp2_cldr_priv.s		\
		test_cp2_clwr_priv.s		\
		test_cp2_clhr_priv.s		\
		test_cp2_clbr_priv.s		\
		test_cp2_cldr_unpriv.s		\
		test_cp2_clwr_unpriv.s		\
		test_cp2_clhr_unpriv.s		\
		test_cp2_clbr_unpriv.s		\
		test_cp2_cld_unpriv.s		\
		test_cp2_clw_unpriv.s		\
		test_cp2_clh_unpriv.s		\
		test_cp2_clb_unpriv.s		\
		test_cp2_clbu_priv.s		\
		test_cp2_clbu_unpriv.s		\
		test_cp2_clhu_priv.s		\
		test_cp2_clhu_unpriv.s		\
		test_cp2_clwu_priv.s		\
		test_cp2_clwu_unpriv.s		\
		test_cp2_zeroex.s		\
		test_cp2_signex.s		\
		test_cp2_csealcode.s		\
		test_cp2_csealunsealcode.s	\
		test_cp2_csealdata.s		\
		test_cp2_c0_ld.s		\
		test_cp2_c0_lwu.s		\
		test_cp2_c0_lhu.s		\
		test_cp2_c0_lbu.s		\
		test_cp2_csd_unpriv.s		\
		test_cp2_csw_unpriv.s		\
		test_cp2_csh_unpriv.s		\
		test_cp2_csb_unpriv.s		\
		test_cp2_csdr_unpriv.s		\
		test_cp2_cswr_unpriv.s		\
		test_cp2_cshr_unpriv.s		\
		test_cp2_csbr_unpriv.s		\
		test_cp2_csdr_priv.s		\
		test_cp2_cswr_priv.s		\
		test_cp2_cshr_priv.s		\
		test_cp2_csbr_priv.s		\
		test_cp2_c0_sd.s		\
		test_cp2_c0_sw.s		\
		test_cp2_c0_sh.s		\
		test_cp2_c0_sb.s		\
		test_cp2_exception_epcc.s       \
		test_cp2_exception_pipeline.s   \
                test_cp2_tlb_exception_fill.s   \
		test_cp2_cmove_j.s		\
		test_cp2_c0_notag.s		\
		test_cp2_c0_perm.s		\
		test_cp2_c0_sealed.s		\
		test_cp2_clld.s			\
		test_cp2_ccall.s		\
		test_cp2_creturn_trap.s		\
		test_cp2_ccall2.s		\
		test_cp2_cbtu.s			\
		test_cp2_cbts.s			\
		test_cp2_branchtag.s		\
		test_cp2_floatstore.s		\
		test_cp2_csb_neg.s		\
		test_cp2_csetcause.s		\
		test_cp2_sbx_j.s		\
		test_cp2_sandbox_jal.s		\
		test_cp2_x_bounds.s		\
		test_cp2_x_clbu_tag.s		\
		test_cp2_x_clbu_reg.s		\
		test_cp2_x_clbu_perm.s		\
		test_cp2_x_clbu_sealed.s	\
		test_cp2_x_csb_perm.s		\
		test_cp2_x_csc_align.s		\
		test_cp2_x_csc_vaddr.s		\
		test_cp2_x_csc_ephemeral.s	\
		test_cp2_x_csc_perm.s		\
		test_cp2_x_csc_underflow.s	\
		test_cp2_x_clc_perm.s		\
		test_cp2_x_clc_align.s		\
		test_cp2_x_clc_vaddr.s		\
		test_cp2_x_clc_priority.s	\
		test_cp2_x_clc_bounds.s		\
		test_cp2_x_cunseal_otype.s	\
		test_cp2_x_csealdata_tag.s	\
		test_cp2_x_csealdata_reg.s	\
		test_cp2_x_csealdata_perm.s	\
		test_cp2_x_csealdata_pri.s	\
		test_cp2_x_csealcode_priority.s \
		test_cp2_x_cgetbase_reg.s	\
		test_cp2_x_cgetlen_reg.s	\
		test_cp2_x_cgettag_reg.s	\
		test_cp2_x_cgetunsealed_reg.s	\
		test_cp2_x_cgetperm_reg.s	\
		test_cp2_x_cgettype_reg.s	\
		test_cp2_x_cgetpcc_reg.s	\
		test_cp2_x_cgetcause_perm.s	\
		test_cp2_x_csetcause_perm.s	\
		test_cp2_x_cincbase_tag.s	\
		test_cp2_x_csetlen_tag.s	\
		test_cp2_x_candperm_tag.s	\
		test_cp2_x_cjalr_tag.s		\
		test_cp2_cunseal_ephemeral.s	\
		test_cp2_x_cunseal_unsealed.s	\
		test_cp2_x_cld_priority.s	\
		test_cp2_x_cld_pri2.s		\
		test_cp2_x_fetch.s		\
		test_cp2_x_cjalr_perm.s		\
		test_cp2_x_cjr_ephemeral.s	\
		test_cp2_x_cjalr_ephemeral.s	\
		test_cp2_x_sb_perm.s		\
		test_cp2_x_lb_perm.s		\
		test_cp2_x_lb_tag.s		\
		test_cp2_x_lb_sealed.s		\
		test_cp2_x_cincbase_delay.s	\
		test_cp2_x_cincbase_delay2.s	\
		test_cp2_x_cbtu_reg.s		\
		test_cp2_x_cbts_reg.s		\
		test_cp2_x_csettype_perm.s	\
		test_cp2_x_csettype_bounds.s	\
		test_cp2_x_swc1_perm.s		\
		test_cp2_x_sdc1_perm.s          \
		test_cp2_disabled_exception.s
endif

TEST_ALU_OVERFLOW_FILES=			\
		test_add_overflow.s		\
		test_add_overflow_wrong_sign.s  \
		test_addi_overflow.s		\
		test_addiu_overflow.s		\
		test_addu_overflow.s		\
		test_dadd_overflow.s		\
		test_daddi_overflow.s		\
		test_daddiu_overflow.s		\
		test_daddu_overflow.s		\
		test_dsub_overflow.s		\
		test_dsub_overflow_minint.s	\
		test_dsubu_overflow.s		\
		test_sub_overflow.s		\
		test_sub_overflow_minint.s	\
		test_subu_overflow.s		\
		test_madd_lo_overflow.s

TEST_MEM_UNALIGN_FILES=				\
		test_lh_unalign.s		\
		test_lw_unalign.s		\
		test_ld_unalign.s		\
		test_sh_unalign.s		\
		test_sw_unalign.s		\
		test_sd_unalign.s               \
		test_beq_lb.s

TEST_BEV1_FILES=				\
		test_exception_bev1_trap.s


TEST_TLB_FILES=                                 \
		test_tlb_load_0.s		\
		test_tlb_load_1.s		\
		test_tlb_load_1_large_page.s	\
		test_tlb_probe.s		\
		test_tlb_exception_fill.s	\
		test_tlb_instruction_miss.s	\
		test_tlb_load_max.s             \
		test_tlb_load_asid.s		\
		test_tlb_read.s			\
		test_tlb_store_0.s		\
		test_tlb_store_protected.s	\
		test_tlb_user_mode.s		\
		test_tlb_invalid_load.s		\
		test_tlb_invalid_store.s        \
		test_tlb_addrerr_load.s         \
		test_tlb_addrerr_store.s

TEST_TRAPI_FILES=				\
		test_teqi_eq.s			\
		test_teqi_gt.s			\
		test_teqi_lt.s			\
		test_teqi_eq_sign.s		\
		test_tgei_eq.s			\
		test_tgei_gt.s			\
		test_tgei_lt.s			\
		test_tgei_eq_sign.s		\
		test_tgei_gt_sign.s		\
		test_tgei_lt_sign.s		\
		test_tgeiu_eq.s			\
		test_tgeiu_gt.s			\
		test_tgeiu_lt.s			\
		test_tlti_eq.s			\
		test_tlti_gt.s			\
		test_tlti_lt.s			\
		test_tlti_eq_sign.s		\
		test_tlti_gt_sign.s		\
		test_tlti_lt_sign.s		\
		test_tltiu_eq.s			\
		test_tltiu_gt_sign.s		\
		test_tltiu_gt.s			\
		test_tltiu_lt.s			\
		test_tnei_eq_sign.s		\
		test_tnei_eq.s			\
		test_tnei_gt_sign.s		\
		test_tnei_gt.s			\
		test_tnei_lt_sign.s		\
		test_tnei_lt.s

RAW_TRACE_FILES=test_raw_trace.s

# Don't attempt to build clang tests unless CLANG is set to 1, because clang might not be available
# This will cause clang tests to fail but that is better than make falling over.
ifeq ($(CLANG),1)
TEST_CLANG_FILES=\
		test_clang_cast.c		\
		test_clang_toy.c		\
		test_clang_memcpy.c		\
		test_clang_load_data.c		\
		test_clang_store_data.c		\
		test_clang_struct.c		\
		test_clang_opaque.c		\
		test_clang_load_float.c
else
TEST_CLANG_FILES=
endif

# Don't attempt multicore tests as the processor under test might be a single core.
ifeq ($(MULTI),1)
TEST_MULTICORE_FILES=\
		test_raw_coherence_setup.s      \
		test_raw_coherent_sync.s        \
                test_raw_pic_default.s
else
TEST_MULTICORE_FILES=
endif

FUZZ_SCRIPT:=fuzzing/fuzz.py
FUZZ_SCRIPT_OPTS?=
FUZZ_TEST_DIR:=tests/fuzz
ifneq ($(NOFUZZ),1)
FUZZ_TEST_FILES:=$(notdir $(wildcard $(FUZZ_TEST_DIR)/*.s))
endif
FUZZ_REGRESSION_TEST_DIR:=tests/fuzz_regressions/
FUZZ_REGRESSION_TEST_FILES:=$(notdir $(wildcard $(FUZZ_REGRESSION_TEST_DIR)/*.s))
#
# All unit tests.  Implicitly, these will all be run for CHERI, but subsets
# may be used for other targets.
#
TEST_FILES=					\
		$(RAW_FRAMEWORK_FILES)		\
		$(RAW_ALU_FILES)		\
		$(RAW_BRANCH_FILES)		\
		$(RAW_MEM_FILES)		\
		$(RAW_LLSC_FILES)		\
		$(RAW_CP0_FILES)		\
		$(TEST_FRAMEWORK_FILES)		\
		$(TEST_ALU_FILES)		\
		$(TEST_MEM_FILES)		\
		$(TEST_LLSC_FILES)		\
		$(TEST_CACHE_FILES)		\
		$(TEST_CP0_FILES)		\
		$(TEST_CP2_FILES)		\
		$(TEST_BEV1_FILES)		\
		$(TEST_TLB_FILES)		\
		$(TEST_ALU_OVERFLOW_FILES)	\
		$(TEST_MEM_UNALIGN_FILES)	\
		$(TEST_TRAPI_FILES)             \
		$(FUZZ_TEST_FILES)              \
		$(FUZZ_REGRESSION_TEST_FILES)   \
		$(TEST_CLANG_FILES)		\
		$(TEST_MULTICORE_FILES)


ifdef COP1
    TEST_FILES += $(RAW_FPU_FILES) $(TEST_FPU_FILES)
endif

ifdef COP1_ONLY
	TEST_FILES = $(RAW_FPU_FILES) $(TEST_FPU_FILES)
endif

ifdef TEST_TRACE
	TEST_FILES += $(RAW_TRACE_FILES)
else
ifdef TEST_TRACE_ONLY
	TEST_FILES = $(RAW_TRACE_FILES)
endif
endif
#
# Omit certain categories of tests due to gxemul functional omissions:
#
# llsc - gxemul terminates the simulator on load linked, store conditional
# cache - gxemul does not simulate a cache
# bev1 - gxemul does not support early boot exception vectors
# trapi - gxemul does not implement trap instructions with immediate
#         arguments
#
# Some tests are omitted as CHERI-specific:
#
# counterdev - gxemul does not provide the "counter" device used to test
#              cache semantics.
# cheri - gxemul is simply not CHERI
#
GXEMUL_NOSEFLAGS=-A "not llsc and not cache and not bev1 and not trapi and not counterdev and not watch and not capabilities and not clang and not cheri and not nofloat and not floatpaired and not floatindexed and not floatcmove and not floatfcsr and not floatfenr and not floatfexr and not floatrecip and not floatrsqrt and not float64 and not floatexception and not smalltlb and not bigtlb and not enablelargetlb and not invalidateL2 and not rdhwr and not config3 and not userlocal"

#
# We unconditionally terminate the simulator after TEST_CYCLE_LIMIT
# instructions to ensure that loops terminate.  This is an arbitrary number.
#
TEST_CYCLE_LIMIT=1000000

##############################################################################
# No need to modify anything below this point if you are just adding new
# tests to current categories.
#

# Set CHERI_VER to 2 to test cheri2
CHERI_VER?=
# Set to 0 to disable capability tests
CHERIROOT?=../../cheri$(CHERI_VER)/trunk
CHERIROOT_ABS:=$(realpath $(CHERIROOT))
CHERILIBS?=../../cherilibs/trunk
CHERILIBS_ABS:=$(realpath $(CHERILIBS))
CHERICONF?=$(CHERIROOT_ABS)/simconfig
TRACECONF?=$(CHERIROOT_ABS)/traceconfig
TOOLS_DIR = ${CHERILIBS_ABS}/tools
TOOLS_DIR_ABS:=$(realpath $(TOOLS_DIR))
CHERICTL=$(TOOLS_DIR_ABS)/debug/cherictl
SYSTEM_CONSOLE_DIR_ABS:= /usr/groups/ecad/altera/current/quartus/sopc_builder/bin
CHERISOCKET:= /tmp/cheri_debug_listen_socket
SIM        := ${CHERIROOT_ABS}/sim
# Can be set to 1 on command line to disable fuzz tests, which can be useful at times.
NOFUZZ?=0
# Can be set to a custom value to customise tracing, which is useful to avoid filling up disks when fuzz testing.
ifdef DEBUG
	SIM_TRACE_OPTS?= +trace +cTrace +showTranslations +instructionBasedCycleCounter +debug
else
ifdef TRACE
	SIM_TRACE_OPTS?=+trace +cTrace +showTranslations +instructionBasedCycleCounter
else
	SIM_TRACE_OPTS=
endif
endif
NOSEPRED=not false
ifeq ($(CHERI_VER),2)
NOSEPRED+=and not invalidateL2
NOSEPRED+=and not lladdr
NOSEPRED+=and not bigtlb
NOSEPRED+=and not gxemultlb
NOSEPRED+=and not largepage
NOSEPRED+=and not dumpicache
else
NOSEPRED+=and not smalltlb
NOSEPRED+=and not gxemultlb
endif
ifdef COP1
NOSEPRED+=and not nofloat and not float32 and not floatexception and not floatflags
else
NOSEPRED+=and not float
endif
ifneq ($(TEST_CP2),1)
NOSEPRED+=and not capabilities and not clang
endif
ifneq ($(CLANG),1)
NOSEPRED+=and not clang
endif
ifneq ($(MULTI),1)
NOSEPRED+=and not multicore
endif
ifdef CHERI_MICRO
NOSEPRED+=and not tlb and not cache and not invalidateL2
endif
ifneq ($(NOSEPRED),)
NOSEFLAGS?=-A "$(NOSEPRED)"
NOSEFLAGS_UNCACHED?=-A "$(NOSEPRED) and not cached"
endif

VPATH=$(TESTDIRS)
OBJDIR=obj
LOGDIR=log
ALTERA_LOGDIR=altera_log
HWSIM_LOGDIR=hwsim_log
GXEMUL_LOGDIR=gxemul_log
GXEMUL_BINDIR?=/usr/groups/ctsrd/gxemul/CTSRD-CHERI-gxemul-testversion
GXEMUL_TRACE_OPTS?=-i
GXEMUL_OPTS=-V -E oldtestmips -M 3072 $(GXEMUL_TRACE_OPTS) -p "end"

RAW_LDSCRIPT=raw.ld
RAW_CACHED_LDSCRIPT=raw_cached.ld
TEST_LDSCRIPT=test.ld
TEST_CACHED_LDSCRIPT=test_cached.ld

TEST_INIT_OBJECT=$(OBJDIR)/init.o
# Fuzz tests have a slightly different init which doesn't dump
# capability registers and has more interesting initial register values.
TEST_INIT_CACHED_OBJECT=$(OBJDIR)/init_cached.o
TEST_LIB_OBJECT=$(OBJDIR)/lib.o

TESTS := $(basename $(TEST_FILES))
TEST_OBJS := $(addsuffix .o,$(addprefix $(OBJDIR)/,$(TESTS)))
TEST_ELFS := $(addsuffix .elf,$(addprefix $(OBJDIR)/,$(TESTS)))
TEST_CACHED_ELFS := $(addsuffix _cached.elf,$(addprefix $(OBJDIR)/,$(TESTS)))
TEST_MEMS := $(addsuffix .mem,$(addprefix $(OBJDIR)/,$(TESTS)))
TEST_CACHED_MEMS := $(addsuffix _cached.mem,$(addprefix $(OBJDIR)/,$(TESTS)))
TEST_HEXS := $(addsuffix .hex,$(addprefix $(OBJDIR)/,$(TESTS)))
TEST_CACHED_HEXS := $(addsuffix _cached.hex,$(addprefix $(OBJDIR)/,$(TESTS)))
TEST_DUMPS := $(addsuffix .dump,$(addprefix $(OBJDIR)/,$(TESTS)))
TEST_CACHED_DUMPS := $(addsuffix _cached.dump,$(addprefix $(OBJDIR)/,$(TESTS)))

CHERI_TEST_LOGS := $(addsuffix .log,$(addprefix $(LOGDIR)/,$(TESTS)))
CHERI_TEST_CACHED_LOGS := $(addsuffix _cached.log,$(addprefix \
	$(LOGDIR)/,$(TESTS)))
ALTERA_TEST_LOGS := $(addsuffix .log,$(addprefix $(ALTERA_LOGDIR)/,$(TESTS)))
ALTERA_TEST_CACHED_LOGS := $(addsuffix _cached.log,$(addprefix \
	$(ALTERA_LOGDIR)/,$(TESTS)))
HWSIM_TEST_LOGS := $(addsuffix .log,$(addprefix $(HWSIM_LOGDIR)/,$(TESTS)))
HWSIM_TEST_CACHED_LOGS := $(addsuffix _cached.log,$(addprefix \
	$(HWSIM_LOGDIR)/,$(TESTS)))
GXEMUL_TEST_LOGS := $(addsuffix _gxemul.log,$(addprefix \
	$(GXEMUL_LOGDIR)/,$(TESTS)))
GXEMUL_TEST_CACHED_LOGS := $(addsuffix _gxemul_cached.log,$(addprefix \
	$(GXEMUL_LOGDIR)/,$(TESTS)))

SIM_FUZZ_TEST_LOGS := $(filter $(LOGDIR)/test_fuzz_%, $(CHERI_TEST_LOGS))
SIM_FUZZ_TEST_CACHED_LOGS := $(filter $(LOGDIR)/test_fuzz_%, $(CHERI_TEST_CACHED_LOGS))
GXEMUL_FUZZ_TEST_LOGS := $(filter $(GXEMUL_LOGDIR)/test_fuzz_%, $(GXEMUL_TEST_LOGS))
GXEMUL_FUZZ_TEST_CACHED_LOGS := $(filter $(GXEMUL_LOGDIR)/test_fuzz_%, $(GXEMUL_TEST_CACHED_LOGS))

REWRITE_PISM_CONF = sed -e 's,../../cherilibs/trunk,$(CHERILIBS_ABS),' < $(1) > $(2)
COPY_PISM_CONFS = $(call REWRITE_PISM_CONF,$(CHERICONF),$$TMPDIR/simconfig) && \
	$(call REWRITE_PISM_CONF,$(TRACECONF),$$TMPDIR/traceconfig)

PREPARE_TEST = \
	TMPDIR=$$(mktemp -d) && \
	cd $$TMPDIR && \
	cp $(PWD)/$(1) mem.bin && \
	$(MEMCONV) bsim && \
	$(MEMCONV) bsimc2 && \
	$(COPY_PISM_CONFS)

RUN_TEST = \
	LD_LIBRARY_PATH=$(CHERILIBS_ABS)/peripherals \
	CHERI_CONFIG=$$TMPDIR/simconfig \
	$(SIM) -w +regDump $(SIM_TRACE_OPTS) -m $(TEST_CYCLE_LIMIT) > \
	    $(PWD)/$@

CLEAN_TEST = rm -r $$TMPDIR

WAIT_FOR_SOCKET = while ! test -e $(1); do sleep 0.1; done

MEMCONV=python ${TOOLS_DIR_ABS}/memConv.py
AS=mips64-as

all: $(TEST_MEMS) $(TEST_CACHED_MEMS) $(TEST_DUMPS) $(TEST_CACHED_DUMPS) $(TEST_HEXS) $(TEST_CACHED_HEXS)

test: nosetest nosetest_cached

hardware-setup:
	- killall -9 altera_socket_tunnel.py
	- killall -9 system-console
	- rm /tmp/cheri_debug_listen_socket
	$(TOOLS_DIR_ABS)/debug/altera_socket_tunnel.py > /local/scratch/output.txt &

hardware-cleanup:
	- killall -9 altera_socket_tunnel.py
	- killall -9 system-console
	- rm /tmp/cheri_debug_listen_socket

test_hardware: altera-nosetest altera-nosetest_cached

$(CHERISOCKET):	
	TMPDIR=$$(mktemp -d) && \
	cd $$TMPDIR && \
	cp ${CHERIROOT_ABS}/sw/mem.bin mem.bin && \
	$(MEMCONV) bsim && \
	$(COPY_PISM_CONFS) && \
	LD_LIBRARY_PATH=$(CHERILIBS_ABS)/peripherals \
	CHERI_CONFIG=$$TMPDIR/simconfig \
	$(SIM) &

# Because fuzz testing deals with lots of small files it is preferable to use
# find | xargs to remove them. For other cleans it is probably better to 
# list the files explicitly.
clean_fuzz:
	find $(OBJDIR) $(LOGDIR) $(GXEMUL_LOGDIR) -name 'test_fuzz*' | xargs -r rm
	find $(FUZZ_TEST_DIR) -name 'test_fuzz*.s' | xargs -r rm

cleantest:
	rm -f $(CHERI_TEST_LOGS) $(CHERI_TEST_CACHED_LOGS)
	rm -f $(GXEMUL_TEST_LOGS) $(GXEMUL_TEST_CACHED_LOGS)
	rm -f $(ALTERA_TEST_LOGS) $(ALTERA_TEST_CACHED_LOGS)

clean: cleantest
	rm -f $(TEST_INIT_OBJECT) $(TEST_INIT_CACHED_OBJECT) $(TEST_LIB_OBJECT)
	rm -f $(TEST_OBJS) $(TEST_ELFS) $(TEST_MEMS) $(TEST_DUMPS)
	rm -f $(TEST_CACHED_ELFS) $(TEST_CACHED_MEMS) $(TEST_CACHED_DUMPS)
	rm -f $(TESTDIR)/*/*.pyc
	rm -f $(OBJDIR)/*.hex *.hex mem.bin

.PHONY: all clean cleantest clean_fuzz test nosetest nosetest_cached failnosetest
.SECONDARY: $(TEST_OBJS) $(TEST_ELFS) $(TEST_CACHED_ELFS) $(TEST_MEMS) $(TEST_INIT_OBJECT) \
    $(TEST_INIT_CACHED_OBJECT) $(TEST_LIB_OBJECT)

$(TOOLS_DIR_ABS)/debug/cherictl: $(TOOLS_DIR_ABS)/debug/cherictl.c $(TOOLS_DIR_ABS)/debug/cheri_debug.c
	$(MAKE) -C $(TOOLS_DIR_ABS)/debug/ cherictl

#
# Targets for unlinked .o files.  The same .o files can be used for both
# uncached and cached runs of the suite, so we just build them once.
#
$(OBJDIR)/test_%.o : test_%.s
	#clang  -c -fno-pic -target cheri-unknown-freebsd -integrated-as -o $@ $< 
	$(AS) -EB -march=mips64 -mabi=64 -G0 -ggdb -o $@ $<

# Once the assembler works, we can try this version too:
#clang  -S -fno-pic -target cheri-unknown-freebsd -o - $<  | $(AS) -EB -march=mips64 -mabi=64 -G0 -ggdb -o $@ -
$(OBJDIR)/test_clang%.o : test_clang%.c
	clang  -c -fno-pic -target cheri-unknown-freebsd -integrated-as -o $@ $<  -O3 -ffunction-sections

$(OBJDIR)/test_%.o : test_%.c
	sde-gcc -c -EB -march=mips64 -mabi=64 -G0 -ggdb -o $@ $<

$(OBJDIR)/%.o: %.s
	$(AS) -EB -march=mips64 -mabi=64 -G0 -ggdb --defsym CHERI_VER=$(CHERI_VER) --defsym  TEST_CP2=$(TEST_CP2) -o $@ $<
	#clang  -c -fno-pic -target cheri-unknown-freebsd -integrated-as -o $@ $< 

#
# Targets for ELF images of tests running out of uncached memory.
#

$(OBJDIR)/test_raw_%.elf : $(OBJDIR)/test_raw_%.o $(RAW_LDSCRIPT)
	sde-ld -EB -G0 -T$(RAW_LDSCRIPT) $< -o $@ -m elf64btsmip

$(OBJDIR)/test_%.elf : $(OBJDIR)/test_%.o $(TEST_LDSCRIPT) \
	    $(TEST_INIT_OBJECT) $(TEST_LIB_OBJECT)
	sde-ld -EB -G0 -T$(TEST_LDSCRIPT) $(TEST_INIT_OBJECT) \
	    $(TEST_LIB_OBJECT) $< -o $@ -m elf64btsmip

#
# Targets for ELF images of tests running out of cached memory.
#

$(OBJDIR)/test_raw_%_cached.elf : $(OBJDIR)/test_raw_%.o \
	    $(TEST_INIT_CACHED_OBJECT) $(RAW_CACHED_LDSCRIPT)
	sde-ld -EB -G0 -T$(RAW_CACHED_LDSCRIPT) $(TEST_INIT_CACHED_OBJECT) \
	    $< -o $@ -m elf64btsmip

$(OBJDIR)/test_%_cached.elf : $(OBJDIR)/test_%.o \
	    $(TEST_CACHED_LDSCRIPT) $(TEST_INIT_CACHED_OBJECT) \
	    $(TEST_INIT_OBJECT) $(TEST_LIB_OBJECT)
	sde-ld -EB -G0 -T$(TEST_CACHED_LDSCRIPT) $(TEST_INIT_CACHED_OBJECT) \
	    $(TEST_INIT_OBJECT) $(TEST_LIB_OBJECT) $< -o $@ -m elf64btsmip

#
# Convert ELF images to raw memory images that can be loaded into simulators
# or hardware.
#
$(OBJDIR)/%.mem : $(OBJDIR)/%.elf
	sde-objcopy -S -O binary $< $@

#
# Convert ELF images to raw memory images that can be loaded into simulators
# or hardware.
#
$(OBJDIR)/%.hex : $(OBJDIR)/%.mem
	TMPDIR=$$(mktemp -d) && \
	cd $$TMPDIR && \
	cp $(CURDIR)/$< mem.bin && \
	$(MEMCONV) verilog && \
	cp initial.hex $(CURDIR)/$@ && \
	rm -r $$TMPDIR

#
# Provide an annotated disassembly for the ELF image to be used in diagnosis.
#
$(OBJDIR)/%.dump: $(OBJDIR)/%.elf
	mips64-objdump -xsSD $< > $@

$(LOGDIR)/test_raw_trace.log: CHERI_TRACE_FILE=$(PWD)/log/test_raw_trace.trace
$(LOGDIR)/test_raw_trace_cached.log: CHERI_TRACE_FILE=$(PWD)/log/test_raw_trace_cached.trace

# The trace files need interaction from cherictl
# We fork the test, and use cherictl
# test_raw_trac, because % must be non-empty...
#
$(LOGDIR)/test_raw_trac%.log: $(OBJDIR)/test_raw_trac%.mem $(SIM) $(CHERICTL)
	rm -f $$CHERI_TRACE_FILE
	$(call PREPARE_TEST,$<) && \
	((CHERI_DEBUG_SOCKET_PATH=$$TMPDIR/sock \
	CHERI_TRACE_FILE=$(CHERI_TRACE_FILE) \
	$(RUN_TEST); \
	$(CLEAN_TEST)) &) && \
	$(call WAIT_FOR_SOCKET,$$TMPDIR/sock) && \
	$(CHERICTL) setreg -r 12 -v 1 -p $$TMPDIR/sock && \
	$(CHERICTL) memtrace -v 6 -p $$TMPDIR/sock

#
# Target to execute a Bluespec simulation of the test suite; memConv.py needs
# fixing so that it accepts explicit sources and destinations but for now we
# can use a temporary directory so that parallel builds work.
$(LOGDIR)/%.log : $(OBJDIR)/%.mem $(SIM)
	$(call PREPARE_TEST,$<) && $(RUN_TEST); $(CLEAN_TEST)

#
# Target to do a run of the test suite on hardware.
$(ALTERA_LOGDIR)/%.log : $(OBJDIR)/%.hex $(TOOLS_DIR_ABS)/debug/cherictl
	nios2-download -r
	while ! test -e /tmp/cheri_debug_listen_socket; do sleep 0.1; done
	TMPDIR=$$(mktemp -d) && \
	cd $$TMPDIR && \
	cp $(CURDIR)/$< mem.hex && \
	$(TOOLS_DIR_ABS)/debug/cherictl test -f mem.hex > $(CURDIR)/$@ && \
	rm -r $$TMPDIR
	sleep .1

#
# Target to run the hardware test suite on the simulator.
$(HWSIM_LOGDIR)/%.log : $(OBJDIR)/%.hex $(TOOLS_DIR_ABS)/debug/cherictl
	sleep 2
	while ! test -e /tmp/cheri_debug_listen_socket; do sleep 0.1; done
	TMPDIR=$$(mktemp -d) && \
	cd $$TMPDIR && \
	cp $(CURDIR)/$< mem.hex && \
	$(TOOLS_DIR_ABS)/debug/cherictl test -f mem.hex > $(CURDIR)/$@ && \
	rm -r $$TMPDIR
	killall -9 bluetcl
	rm /tmp/cheri_debug_listen_socket
	sleep 1

#
# Target to execute a gxemul simulation.  Gxemul is focused on running
# interactively which causes two problems: firstly there is no way to
# say on the command line that we want to run for only
# TEST_CYCLE_LIMIT cycles, and secondly gxemul assumes that there is
# an interactive terminal and hangs if stdin goes away. We get around
# this with the following glorious hackery to 1) feed gxemul commands
# to step TEST_CYCLE_LIMIT times then exit and 2) wait until gxemul
# closes stdin before exiting the pipeline.
#
$(GXEMUL_LOGDIR)/%_gxemul.log : $(OBJDIR)/%.elf
	(printf "step $(TEST_CYCLE_LIMIT)\nquit\n"; while echo > /dev/stdout; do sleep 0.01; done ) | \
	$(GXEMUL_BINDIR)/gxemul $(GXEMUL_OPTS) $< 2>&1 | \
        $(GXEMUL_LOG_FILTER) >$@ || true


$(GXEMUL_LOGDIR)/%_gxemul_cached.log : $(OBJDIR)/%_cached.elf
	(printf "step $(TEST_CYCLE_LIMIT)\nquit\n"; while echo > /dev/stdout; do sleep 0.01; done ) | \
	$(GXEMUL_BINDIR)/gxemul $(GXEMUL_OPTS) $< 2>&1 | \
        $(GXEMUL_LOG_FILTER) >$@ || true

# Simulate a failure on all unit tests
failnosetest: cleantest $(CHERI_TEST_LOGS)
	DEBUG_ALWAYS_FAIL=1 PYTHONPATH=tools nosetests $(NOSEFLAGS) $(TESTDIRS)

print-versions:
	nosetests --version

foo: $(CHERI_TEST_LOGS)

.PHONY: fuzz_run_tests fuzz_run_tests_cached fuzz_generate nose_fuzz nose_fuzz_cached
fuzz_run_tests: $(GXEMUL_FUZZ_TEST_LOGS) $(SIM_FUZZ_TEST_LOGS)

fuzz_run_tests_cached: $(GXEMUL_FUZZ_TEST_CACHED_LOGS) $(SIM_FUZZ_TEST_CACHED_LOGS)

fuzz_generate: $(FUZZ_SCRIPT)
	python $(FUZZ_SCRIPT) $(FUZZ_SCRIPT_OPTS) -d $(FUZZ_TEST_DIR)

# The rather unpleasant side-effect of snorting too much candy floss...
nose_fuzz: $(SIM) fuzz_run_tests
	PYTHONPATH=tools/sim CACHED=0 nosetests --with-xunit \
	    --xunit-file=nosetests_fuzz.xml $(NOSEFLAGS_UNCACHED) tests/fuzz || true

nose_fuzz_cached: $(SIM) fuzz_run_tests_cached
	PYTHONPATH=tools/sim CACHED=1 nosetests --with-xunit \
            --xunit-file=nosetests_fuzz_cached.xml $(NOSEFLAGS) tests/fuzz || true


# Run unit tests using nose (http://somethingaboutorange.com/mrl/projects/nose/)
nosetest: nosetests_uncached.xml

nosetest_cached: nosetests_cached.xml

nosetests_combined.xml: nosetests_uncached.xml nosetests_cached.xml xmlcat
	./xmlcat nosetests_uncached.xml nosetests_cached.xml > nosetests_combined.xml

nosetests_uncached.xml: all $(CHERI_TEST_LOGS)
	PYTHONPATH=tools/sim CACHED=0 nosetests --with-xunit --xunit-file=nosetests_uncached.xml \
		$(NOSEFLAGS_UNCACHED) $(TESTDIRS) || true

nosetests_cached.xml: all $(CHERI_TEST_CACHED_LOGS)
	PYTHONPATH=tools/sim CACHED=1 nosetests --with-xunit --xunit-file=nosetests_cached.xml \
               $(NOSEFLAGS) $(TESTDIRS) || true

altera-nosetest: hardware-setup all $(ALTERA_TEST_LOGS) hardware-cleanup
	PYTHONPATH=tools/sim CACHED=0 LOGDIR=$(ALTERA_LOGDIR) nosetests $(NOSEFLAGS_UNCACHED) $(ALTERA_NOSEFLAGS) \
	    $(TESTDIRS) || true

altera-nosetest_cached: hardware-setup all $(ALTERA_TEST_CACHED_LOGS) hardware-cleanup
	PYTHONPATH=tools/sim CACHED=1 LOGDIR=$(ALTERA_LOGDIR) nosetests $(NOSEFLAGS) $(ALTERA_NOSEFLAGS) \
	    $(TESTDIRS) || true

hwsim-nosetest: $(CHERISOCKET) all $(HWSIM_TEST_LOGS)
	PYTHONPATH=tools/sim CACHED=0 LOGDIR=$(HWSIM_LOGDIR) nosetests $(NOSEFLAGS_UNCACHED) $(HWSIM_NOSEFLAGS) \
	    $(TESTDIRS) || true

hwsim-nosetest_cached: $(CHERISOCKET) all $(HWSIM_TEST_CACHED_LOGS)
	PYTHONPATH=tools/sim CACHED=1 LOGDIR=$(HWSIM_LOGDIR) nosetests $(NOSEFLAGS) $(HWSIM_NOSEFLAGS) \
	    $(TESTDIRS) || true

gxemul-nosetest: all $(GXEMUL_TEST_LOGS)
	PYTHONPATH=tools/gxemul CACHED=0 nosetests --with-xunit --xunit-file=nosetests_gxemul_uncached.xml $(GXEMUL_NOSEFLAGS) \
	    $(TESTDIRS) || true

gxemul-nosetest_cached: all $(GXEMUL_TEST_CACHED_LOGS)
	PYTHONPATH=tools/gxemul CACHED=1 nosetests --with-xunit --xunit-file=nosetests_gxemul_cached.xml $(GXEMUL_NOSEFLAGS) \
	    $(TESTDIRS) || true

gxemul-build:
	rm -f -r $(GXEMUL_BINDIR)
	wget https://github.com/CTSRD-CHERI/gxemul/zipball/8d92b42a6ccdb7d94a2ad43f7e5e70d17bb7839c -O tools/gxemul/gxemul-testversion.zip --no-check-certificate
	unzip tools/gxemul/gxemul-testversion.zip -d tools/gxemul/
	cd $(GXEMUL_BINDIR) && ./configure && $(MAKE)

xmlcat: xmlcat.c
	gcc -o xmlcat xmlcat.c -I/usr/include/libxml2 -lxml2 -lz -lm

cleanerror:
	find log -size 0 | xargs -r --verbose rm 
