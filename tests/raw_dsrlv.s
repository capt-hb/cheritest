.set mips64
.set noreorder
.set nobopt
.set noat

#
# Tests the Doubleword Shift Right Logical Variable instruction which is a 64-bit instruction
# Any extra padding added on the left should be zero rather than sign extended
#

start:
		dli	$a0, 0xfedcba9876543210

		li	$a1, 0
		dsrlv	$a1, $a0, $a1

		li	$a2, 1
		dsrlv	$a2, $a0, $a2

		li	$a3, 16
		dsrlv	$a3, $a0, $a3

		li	$a4, 31
		dsrlv	$a4, $a0, $a4

		# Dump registers in the simulator
		mtc0 $v0, $26
		nop
		nop

		# Terminate the simulator
	        mtc0 $v0, $23
end:
		b end
