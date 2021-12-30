# (c) Liam Egan, 2020

# This program reads an integer from standard input and returns its
# jacobsthal number. The program is implemented in MIPS 2000 assembly
# and serves as an assembly translation of a C program. The program
# translates a recursive C function, meaning that the jacobsthal tag
# calls itself multiple times via the jal mips call. The original C
# program defines two global variables n and result, n represents the
# number passed into standard input and result stores the resulting
# jacobsthal number. The jacobsthal function itself stores 3 variables
# ans, temp1, and temp2, meaning that this assembly code implemnets a
# recursive function with both automatic and global storage. 

	.text

main:		li 	$sp, 0x7ffffffc	# set up stack ptr
	
		li	$v0, 5		# Read n and store in $t0
		syscall
		move	$t0, $v0
		sw	$t0, n
		move	$a0, $t0	# store argument 
		move	$v0, $t0	# assign output

		jal	jacobstal	# call function

		move	$t1, $v0	# Store result in $t2
		sw	$t1, result

		move	$a0, $t1	# Print result
		li	$v0, 1
		syscall

		la	$a0, eoln	# Print newline
		li	$v0, 4
		syscall

		li	$v0, 10		# exit program
		syscall

jacobstal:	beqz	$a0, zero	# if n is zero, jump to tag
		beq	$a0, 1, one	# if n is one, jump to tag
		bltz	$a0, error	# if n < 0, jump to tag
	
					# prologue
		sub 	$sp, $sp, 20	# set new stack pointer
		sw	$ra, 16($sp)	# save return address in stack

		li	$t2, -1		# ans local variable
		sw	$t2, 12($sp)

		li	$t2, 0		# temp1 local variable
		sw	$t2, 8($sp)

		li	$t2, 0		# temp2 local variable
		sw	$t2, 4($sp)

		sub	$a0, $a0, 2	# subtract 2 from n
	
		jal 	jacobstal	# call (n-2)
				
		add	$a0, $a0, 2	# pop from stack

		lw	$ra, 16($sp)	# return address
		add	$sp, $sp, 20
					# prologue
		sub	$sp, $sp, 20	# set new stack pointer
		sw	$v0, 16($sp)	# save return address in stack

		sub	$sp, $sp, 20	# push return address to stack
		sw	$ra, 16($sp)
	
		sub	$a0, $a0, 1	# subtract 1 from n (n - 1)
	
		jal	jacobstal	# call (n - 1)
	
		add	$a0, $a0, 1	# pop from stack

		lw	$ra, 16($sp)	# return address
		add	$sp, $sp, 20

		lw	$t3, 8($sp)	# get temp 1 
		lw	$t3, 16($sp)
					
		lw	$t4, 4($sp)	# get temp 2
		add	$t4, $t4, $v0

		lw	$t5, 12($sp)	# get ans
	
		add	$sp, $sp, 20	# reset stack

		mul	$t3, $t3, 2	# 2 * jacobstal(n-2)
	
		add	$t5, $t4, $t3	# calculate ans
	
		move	$v0, $t5	# set output to ans
	
		jr	$ra		# return address

zero:		li 	$v0, 0		# return 0
		jr	$ra

one:		li	$v0, 1		# return 1
		jr	$ra

error:		li	$v0, -1		# return -1
		jr	$ra

	.data
n:	.word 0
result:	.word 0
eoln:	.asciiz "\n"
	

	

	
	
