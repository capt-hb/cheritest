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
                csetboundsimm $c1, $c1, 15

		# Setup $c1 as uninit cap
		cgetlen $t0, $c1
		csetoffset $c1, $c1, $t0
		cuninit $c1, $c1
		cgetoffset $a0, $c1
                
		# reading underneath cursor should throw an error
                clb $a0, $zero, -2($c1)

		# Store 10 as a byte on cursor
                dli     $t1, 10
                ucsb    $c1, $t1, 0($c1)
		cgetoffset $t2, $c1
		clb $s0, $zero, 0($c1)

		# Store 42 as a half word on cursor
                dli     $t1, 42
                ucsh    $c1, $t1, 0($c1)
		cgetoffset $t3, $c1
		clh $s1, $zero, 0($c1)

		# Store 100 as a word on cursor
                dli     $t1, 100
                ucsw    $c1, $t1, 0($c1)
		cgetoffset $v0, $c1
		clw $s2, $zero, 0($c1)

		# Store 420 as a double word on cursor
                dli     $t1, 420
                ucsd    $c1, $t1, 0($c1)
		cgetoffset $v1, $c1
		cld $s3, $zero, 0($c1)

		# Load values stored into registers
		clb $a1, $zero, 14($c1)
		clh $a2, $zero, 12($c1)
		clw $a3, $zero, 8($c1)
		cld $a4, $zero, 0($c1)
END_TEST

                .data
                .align  5               # 256-bit align
                .dword  0x0
                .dword  0x0
                .dword  0x0
data:           .dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
