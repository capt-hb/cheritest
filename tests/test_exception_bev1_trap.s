.set mips64
.set noreorder
.set nobopt
.set noat

#
# Exercise an unconditional trap instruction and validate a variety of
# assumptions about the exception handling environment.  This version of the
# test runs in the early boot environment (BEV=1), and we specifically check
# for the case where the (BEV=0) handler is exercised.
#

		.global test
test:		.ent test
		daddu 	$sp, $sp, -32
		sd	$ra, 24($sp)
		sd	$fp, 16($sp)
		daddu	$fp, $sp, 32

		#
		# Install a dummy handler, which should not be invoked, in the
		# RAM exception handler.
		#
		dli	$a0, 0xffffffff80000180
		dla	$a1, bev0_handler
		dli	$a2, 3		# 32-bit instructions
		dsll	$a2, $a2, 2	# Convert to bytes
		jal	memcpy
		nop

		#
		# Set up 'handler' as the ROM exception handler.
		#
		dli	$a0, 0xffffffffbfc00380
		dla	$a1, bev1_handler
		jal	handler_install
		nop

		#
		# Clear registers we'll use when testing results later.
		#
		dli	$a0, 0
		dli	$a1, 0
		dli	$a2, 0
		dli	$a3, 0
		dli	$a4, 0
		dli	$a5, 0
		dli	$a6, 0
		dli	$a7, 0

		#
		# Save the desired EPC value for this exception so we can
		# check it later.
		#
		dla	$a0, desired_epc

		#
		# Trigger exception.
		#
		teqi	$zero, 0

		#
		# Exception return.
		#
desired_epc:
		li	$a1, 1
		mfc0	$a7, $12	# Status register after ERET

return:
		ld	$fp, 16($sp)
		ld	$ra, 24($sp)
		daddu	$sp, $sp, 32
		jr	$ra
		nop			# branch-delay slot
		.end	test

#
# Our actual exception handler, which tests various properties.
#
		.ent bev1_handler
bev1_handler:
		li	$a2, 1
		mfc0	$a3, $12	# Status register
		mfc0	$a4, $13	# Cause register
		mfc0	$a5, $14	# EPC
		eret
		.end bev1_handler

#
# If the wrong handler is invoked, escape quickly, leaving behind a calling
# card.
#
# XXXRW: Should have the linker calculate the length for us.
#
		.ent bev0_handler
bev0_handler:
		li	$a6, 1
		b	return
		nop
		.end bev0_handler
