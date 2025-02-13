.text
	read_numbers:
		li $v0, 4
		la $a0, read_b
		syscall			# Ask for B
		li $v0, 5
		syscall 		# Read B
		move $s0, $v0		# Save B

		li $v0, 4
		la $a0, read_c
		syscall			# Ask for C
		li $v0, 5
		syscall 		# Read C
		move $s1, $v0		# Save C

		li $v0, 4
		la $a0, read_d
		syscall			# Ask for D
		li $v0, 5
		syscall 		# Read D
		move $s2, $v0		# Save D
		
		j math
	
	division:
		sub $t1, $t1, $s1	# Substract C from B
		addi $t0, $t0, 1	# Increment quotient
		
		bgt $t1, $zero, division	# Keep going until there are no more remainders
			
		jr $ra				# Return back to main

	modulus:	
		sub $s7, $s7, $s0
		
		bgt $s7, $s0, modulus		
		
		jr $ra
	math:
		move $t0 $zero		# Quotient starts as zero
		move $t1 $s0		# Copy B		
		jal division		# Perform division
		move $s7 $t0		# Save the result of B / C division
		
		mul $t0, $s2, $s0	# Perform D * B
		
		add $s7, $s7, $t0	# Sum the results of the multiplication and the division operations
		
		sub $s7, $s7, $s1	# Perform - C
		
		add $s7, $s7, $s0 
		jal modulus		# Take the modulo

		li $v0, 4
		la $a0, comment
		syscall			# Print the explanatory comment
		
		li $v0, 1
		move $a0, $s7
		syscall			# Print the result
		
		li $v0, 10
		syscall			# Exit
.data
	read_b: .asciiz "Please enter B: " 
	read_c: .asciiz "Please enter C: " 
	read_d: .asciiz "Please enter D: " 
	
	comment: .asciiz "A is equal to => "

