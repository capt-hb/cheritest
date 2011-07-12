.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test bgezl (branch on greater than or equal to zero likely, signed), less
# than case.
#

start:
		li	$a0, 1		# before
		li	$t0, -1
		bgezl	$t0, branch_target
		li	$a1, 2		# branch-delay slot; shouldn't run
		li	$a2, 3		# should run
branch_target:

		# Dump registers in the simulator
		mtc0	$v0, $26
		nop
		nop

		# Terminate the simulator
end:
		break
		b end
