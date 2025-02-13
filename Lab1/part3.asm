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
		
		j math

	modulus:
		sub $t1, $t1, $s0	# Subtract B from C
		bge $t1, $s0, modulus # Repeat until result is less than B
		
		move $s7, $t1        # The remainder is stored in $s7 (C mod B)
		jr $ra				# Return to main

	math:
		# Calculate C mod B
		move $t1, $s1		# Copy C into $t1 to calculate C mod B
		jal modulus		# Call modulus function to compute C % B

		# Calculate C - B
		sub $t0, $s1, $s0	# C - B

		# Multiply (C - B) * (C mod B)
		mul $s7, $t0, $s7	# (C - B) * (C mod B)

		# Print result
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
	
	comment: .asciiz "A is equal to =>: "
