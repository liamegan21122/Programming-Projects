# (c) Liam Egan, 2020

# This program translates a C function to MIPS 2000 assembly.
# The program is executed solely in main and calculates the
# area of a prism. The program gets length, height, and width
# from standard input and computes the area. When the values
# read the area is calculated via the formula:
# 2 * (width * length + length * height + width * height)
# NOTE: The program does this exact calculation, however it does
# move its values between registers for simplicity reasons.

	.text
main:	li	$t3, -1		# ans = -1
	sw	$t3, ans

	li	$v0, 5		# scanf(length)
	syscall
	move	$t0, $v0	# store in $t0
	sw	$t0, length

	li	$v0, 5		# scanf(width)
	syscall
	move	$t1, $v0	# store in $t1
	sw	$t1, width

	li	$v0, 5		# scanf(height)
	syscall
	move	$t2, $v0	# store in $t2
	sw	$t2, height

if:	bltz	$t0, else	# if (length < 0)
	bltz	$t1, else	# if (width < 0)
	bltz	$t2, else	# if (height < 0)
	li	$t3, 0
	sw	$t3, ans	# ans = 0
	mul	$t3, $t1, $t0	# $t3 = width * length
	sw	$t3, ans	# ans = $t3
	mul	$t0, $t0, $t2	# $t0 = length * height
	sw	$t0, length	# length = $t0
	mul	$t1, $t1, $t2	# $t1 = width * height
	sw	$t1, width	# width = $t1
	add	$t3, $t3, $t0	# width * length + length * height
	sw	$t3, ans	# ans = $t3
	add	$t3, $t3, $t1	# width * length + length * height
				# + width * height
	sw	$t3, ans	# ans = t3
	mul	$t3, $t3, 2	# 2 * (calculation above)
	sw	$t3, ans	# ans = t3 

else:	move	$a0, $t3	# print ans 
	li	$v0, 1
	syscall

	la	$a0, eoln	# print new line
	li	$v0, 4
	syscall

	li	$v0, 10		# exit program
	syscall

	.data
length:	.word 0
width:	.word 0
height:	.word 0
ans:	.word 0
eoln:	.asciiz "\n"
	
