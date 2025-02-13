.text
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Initializers	
	initialization:
		la $s0, array		# Load array's address
		la $t0, array		# Copy array's address to $t0
		
		li $v0, 4
		la $a0, ask_for_array_size
		syscall			# Ask for array size
		
		li $v0, 5
		syscall			# Read array size
		
		move $s1, $v0		# Move the array size information to register $s1
		move $t1, $s1		# Copy array size to register $t1
		
		beq $s1, $zero, exit	# Exit if array size is 0
		
		j read_elements
		
	read_elements:
		li $v0, 4
		la $a0, ask_for_array_element
		syscall			# Ask for an element
		
		li $v0, 5
		syscall			# Read an element
		
		sw $v0, ($t0)		# Write the element into the array
		
		addi $t1, $t1, -1	# Decrement the array size by one to keep track of the number of elements
		
		ble $t1, $zero, menu		# Jump to display section if tracker hits 0
		
		addi $t0, $t0, 4		# Else increment the index
		j read_elements			# Else execute read_elements again
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Menu		
	menu:
		move $t0, $s0		# Copy array adress to $t0
		move $t1, $s1		# Copy array size to $t1
		move $s6, $zero		# Zero $s6 (result) register before starting the operation 
		move $s7, $zero		# Zero $s7 (result) register before starting the operation 
		
		li $v0, 4
		la $a0, menu_message
		syscall			# Display the menu
		
		li $v0, 5
		syscall			# Ask for the user's choice
		
		beq $v0, 1, option_1
		beq $v0, 2, option_2
		beq $v0, 3, option_3
		beq $v0, 4, exit	# Branch to the desired operation
		
		j exit
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Common Functions		
	read_input:
		li $v0, 4
		la $a0, ask_for_the_input
		syscall				# Ask for the input
		
		li $v0, 5
		syscall				# Read the input
		
		move $s2, $v0			# Inputs will be stored in register $s2
		
		jr $ra	
		
	display_result:
		li $v0, 4
		la $a0, result_message
		syscall
		
		li $v0, 1
		move $a0, $s7
		syscall
		
		li $v0, 4
		la $a0, endl
		syscall
		
		j menu
	
	
# Option 1: Find the maximum number stored in the array and display that number
	option_1:
		# Initialize registers for iteration and max tracking
		move $t0, $s0		# Reset array address to $t0
		move $t1, $s1		# Reset array size to $t1
		lw $s3, ($t0)		# Load the first element into $s3 (max)
		
		max_search:
			lw $t2, ($t0)		# Load current element
			ble $t2, $s3, skip_max_update	# If current element <= max, skip
			move $s3, $t2		# Otherwise, update max
			
		skip_max_update:
			addi $t1, $t1, -1	# Decrement array size tracker
			addi $t0, $t0, 4	# Increment the array index
			bgt $t1, $zero, max_search	# If more elements remain, continue
		
		move $s7, $s3		# Store max in $s7 for display
		j display_result	# Display the max result
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Option 2: Find the number of times the maximum number appears in the array
	option_2:
		# Ensure max is already calculated in $s3
		move $t0, $s0        # Reset array address to $t0 (start of array)
		move $t1, $s1        # Reset array size to $t1 (number of elements)
		move $s6, $zero      # Reset the counter to 0
		
		count_max:
			lw $t2, ($t0)    # Load current element
			beq $t2, $s3, increment_count  # If current element == max, increment count
			j skip_increment               # Else skip incrementing the count
			
		increment_count:
			addi $s6, $s6, 1  # Increment the counter
		
		skip_increment:
			addi $t0, $t0, 4   # Move to next element (increment the array index)
			addi $t1, $t1, -1  # Decrement array size tracker
			bgt $t1, $zero, count_max  # Continue looping if elements remain
		
		move $s7, $s6    # Store count in $s7 for display
		j display_result # Display the count result
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Option 3: Find how many numbers in the array can divide the max number without a remainder (excluding the max itself)
	option_3:
		# Ensure max is already calculated in $s3
		move $t0, $s0        # Reset array address to $t0 (start of array)
		move $t1, $s1        # Reset array size to $t1 (number of elements)
		move $s6, $zero      # Reset the counter to 0
		
		divisible_check:
			lw $t2, ($t0)    # Load current element
			beq $t2, $zero, skip_div_check  # Skip division if element is 0 to avoid division by zero
			beq $t2, $s3, skip_div_check    # Skip counting the max number itself
			
			rem $t3, $s3, $t2  # Calculate remainder of (max / current element)
			bne $t3, $zero, skip_div_check  # If remainder != 0, skip incrementing
			
			addi $s6, $s6, 1   # If divisible, increment the counter
		
		skip_div_check:
			addi $t0, $t0, 4   # Move to next element (increment array index)
			addi $t1, $t1, -1  # Decrement array size tracker
			bgt $t1, $zero, divisible_check  # Continue looping if elements remain
		
		move $s7, $s6    # Store count in $s7 for display
		j display_result # Display the result

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Exit	
	exit:
		li $v0, 4
		la $a0, exit_message
		syscall
		
		li $v0,10		# system call to exit
		syscall			# bye bye

.data
	array: .space 400
	ask_for_array_size: .asciiz "Please enter the array size: "
	ask_for_array_element: .asciiz "Please enter a number: "
	menu_message: .asciiz "\n1) Find the maximum number stored in the array and display that number\n2) Find the number of times the maximum number appears in the array\n3) Find how many numbers we have that we can divide the max number without a reminder \n4) Quit\nEnter your choice: "
	ask_for_the_input: .asciiz "Please enter the input: "
	result_message: .asciiz "The result is: "
	exit_message: .asciiz "Bye Bye... "
	endl: .asciiz "\n"