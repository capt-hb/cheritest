.set mips64
.set noreorder
.set nobopt
.include "macros.s"

#
# Test ucstore instructions on uninit cap
#

BEGIN_TEST
                #
                # Make $c1 a capability for the variable 'data'
                #

                cgetdefault $c1
                dla $t0, data
                csetoffset $c1, $c1, $t0
                dli $t0, 8
                csetbounds $c1, $c1, $t0

		# Make $c1 uninitialized
		cuninit $c1, $c1
		cgetoffset $a0, $c1
                

		# Store 42 on cursor, store offset and value at offset -1 of cap into registers
		dla $t0, data
                dli     $t1, 42
                ucsb    $c1, $t1, 0($c1)
		cgetoffset $a1, $c1
                clb     $a5, $zero, -1($c1)

                dli     $t1, 99
                ucsb    $c1, $t1, 0($c1)
		cgetoffset $a2, $c1
                dli     $t1, 10
		ucsb $c1, $t1, 0($c1)
		cgetoffset $a3, $c1

                dli     $t1, 50
		ucsb $c1, $t1, -2($c1)
		cgetoffset $a4, $c1

		# will throw an exception, reading on cursor before writing!
                clb     $a6, $zero, 0($c1)
		# will throw an exception, reading above cursor!
                clb     $a6, $zero, 1($c1)

                clb     $a6, $zero, -2($c1)
END_TEST

                .data
                .align  5               # 256-bit align
                .dword  0x0
                .dword  0x0
                .dword  0x0
underflow:      .dword  0x0123456789abcdef
data:           .dword  0x0123456789abcdef
overflow:       .dword  0x0123456789abcdef      # check for overflow
                .dword  0x0
                .dword  0x0
