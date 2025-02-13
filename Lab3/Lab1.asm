#################
# CS224
# LAB 3
# Furkan Mert Aks1kal
# 222003191
# 24.10.2024
################
 
.data
	ask_dividend: 		.asciiz	"Please enter the dividend: "
	ask_divisor:		.asciiz	"Please enter the divisor: "
	display_quotient:	.asciiz "The quotient is -> "
	next_line:		.asciiz "\n"
	error_message:		.asciiz "Divide by zero error!\n"
.text
	main:
		# Ask for the dividend
		la 	$a0, ask_dividend
		li	$v0, 4
		syscall
		
		li	$v0, 5        # Read integer
		syscall
		
		move	$a1, $v0     # Move dividend to $a1
		
		# Check if dividend is zero
		beq	$a1, $zero, stop_program

		# Ask for the divisor
		la 	$a0, ask_divisor
		li	$v0, 4
		syscall
		
		li	$v0, 5        # Read integer
		syscall
		
		move	$a2, $v0     # Move divisor to $a2
		
		# Check if divisor is zero
		beq	$a2, $zero, stop_program

		# Call division subroutine
		jal division
		
		# Display the quotient
		la 	$a0, display_quotient
		li	$v0, 4
		syscall
		
		# Move quotient to $a0 for display
		move	$a0, $v1
		li	$v0, 1        # Print integer
		syscall
		
		# Print newline
		la 	$a0, next_line
		li	$v0, 4
		syscall
		
		j main  # Go back to main for continuous input
				
	division:
		beq 	$a2, $zero, divide_by_zero_error  # Already checked, but kept for safety
		
		# Save $s0 and $ra on the stack
		subi 	$sp, $sp, 8
		sw	$s0, 0($sp)
		sw	$ra, 4($sp)
		
		move	$s0, $zero   # Initialize quotient
		
		jal 	divide_recursive
		move	$v1, $s0     # Move quotient to $v1
		
		# Restore $s0 and $ra
		lw	$ra, 4($sp)
		lw	$s0, 0($sp)
		addi	$sp, $sp, 8
		
		jr	$ra            # Return to caller
		
	divide_recursive:
		# Save $ra on the stack
		subi 	$sp, $sp, 4
		sw	$ra, 0($sp)
		
		# Base case: if dividend < divisor, return
		blt	$a1, $a2, done
		
		# Subtract divisor from dividend and recurse
		sub	$a1, $a1, $a2
		jal	divide_recursive
		
		# Increment quotient
		addi	$s0, $s0, 1
		
		# Restore $ra and return from recursion
		lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		jr	$ra

	done:
		# Restore $ra and return
		lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		jr 	$ra

	# Error handling for division by zero
	divide_by_zero_error:
		# Print the error message
		la 	$a0, error_message
		li	$v0, 4
		syscall
		
		j stop_program    # Exit the program on division by zero

	# Stop program execution
	stop_program:
		li	$v0, 10       # System call for exit
		syscall
