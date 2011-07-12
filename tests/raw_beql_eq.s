.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test beql (branch on equal, likely), equal case and forward jump.
#

start:
		li	$a0, 1		# before
		beql	$zero, $zero, branch_target
		li	$a1, 2		# branch-delay slot
		li	$a2, 3		# shouldn't run
branch_target:
		li	$a3, 4		# should run

		# Dump registers in the simulator
		mtc0	$v0, $26
		nop
		nop

		# Terminate the simulator
end:
		break
		b end
