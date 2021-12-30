# (c) Liam Egan, 2020

# This program reads an integer from standard input and returns its
# jacobsthal number. The program is implements in MIPS 2000 assembly
# and serves as a assembly translation of a C program. The program
# translates a simple function tagged jacobstahl which contains a
# while loop that calls another function tagged helper. the program
# has 2 global variables named n and result. n stores the integer read
# from standard input and result stores the nth jacobsthal number. The
# function jacobsthal contains three local variables ans, prev, and temp.
# the while loop passes in the ans and prev variables into the helper
# function via the runtime stack. 

		.data
n:		.word 0
result:		.word 0
prev:		.word 0
		.text
	
main:		li	$sp,0x7ffffffc	# set up stack pointer
	
		li	$v0, 5		# scanf() for n 
		syscall
		move	$t0, $v0	# store n in $t0
		sw	$t0, n

		sw	$t0, ($sp)	# push n onto stack
		sub	$sp, $sp, 4
		
		jal	jacobsthal	# call function

		move	$t1, $v0	# let $t1 be the result
		sw	$t1, result

		li	$v0, 1		# print result
		lw	$a0, result
		syscall

		li	$v0, 11		# print newline character with
					#ascii value
		li	$a0, 10
		syscall

		li	$v0, 10		# exit program
		syscall

					# prolouge
jacobsthal:	sub	$sp, $sp, 24	# set up stack ptr
		sw	$ra, 24($sp)	# save ret addr in stack
		sw	$fp, 20($sp)	# save old fram ptr in stack
		add	$fp, $sp, 24	# set new fram ptr

		li	$t2, -1		# ans = -1
		sw	$t2, 16($sp)

		li	$t2, 0		# prev = 0
		sw	$t2, 12($sp)

		li	$t2, 0		# temp = 0
		sw	$t2, 8($sp)

		li	$t2, 2		# i = 2
		sw	$t2, 4($sp)

		bltz 	$t0, return	# if n is negative return -1

if:		bnez 	$t0, else	# if n is 0, else

		sw	$t0, 16($sp)	# n = 0

		j	prep_loop	# jump to preploop

else:		li	$t2, 1		# set ans = 1
		sw	$t2, 16($sp)

prep_loop:	lw	$t3, 4($sp)	# get i 

		lw	$t4, 8($sp)	# get temp

		lw	$t5, 12($sp)	# get prev

		lw	$t6, 16($sp)	# get ans 

loop:		bgt	$t3, $t0, return  # i < n
	
		sw	$t5, ($sp)	# push prev to stack
		sub	$sp, $sp, 4

		sw	$t6, ($sp)	# push ans to stack
		sub	$sp, $sp, 4

		jal	helper		# call helper

		add	$sp, $sp, 8	# pop stack

		move	$t4, $t5	# temp = helper

		move	$t5, $t6	# prev = ans

		move	$t6, $t4	# ans = temp

		add	$t3, $t3, 1	# i++

		j	loop		# jump to tag

					# epilouge
return:		move	$v0, $t6	# return ans
		lw	$ra, 24($sp)	# load ret addr from stack
		lw	$fp, 20($sp)	# restore old frame ptr
		add	$sp, $sp, 24	# reset stack ptr
		jr	$ra		# return address

					# prologue
helper:		sub	$sp, $sp, 8	# set new stack ptr
		sw	$ra, 8($sp)	# save ret addr to stack
		sw	$fp, 4($sp)	# save old fram ptr
		add	$fp, $sp, 8	# set new frame ptr

		mul	$t5, $t5, 2	# 2 * x + y
		add	$t5, $t5, $t6	

					# epilogue
		lw	$ra, 8($sp)	# load ret addr from stack
		lw	$fp, 4($sp)	# restore old fram ptr
		add	$sp, $sp, 8	# reset stack ptr
		jr	$ra		# return address


		
	
