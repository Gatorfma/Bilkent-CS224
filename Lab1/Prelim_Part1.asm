.text
	init_array:
		la $s0, array		# Load array's address
		la $s1, array
	
		li $v0, 4
		la $a0, ask_size
		syscall			# Ask for array size
		
		li $v0, 5
		syscall			# Read array size
		
		move $t0, $v0		# Move the array size information to register $t0
		
		beq $t0, $zero, exit	# Exit if array size is 0
		
		j read_elements
		
	read_elements:
		li $v0, 4
		la $a0, ask_element
		syscall			# Ask for an element
		
		li $v0, 5
		syscall			# Read an element
		
		sw $v0, ($s0)		# Write the element into the array
		
		addi $t0, $t0, -1	# Decrement the array size by one to keep track of the number of elements
		
		ble $t0, $zero, display		# Jump to display section if tracker hits 0
		
		addi $s0, $s0, 4		# Else increment the index
		j read_elements			# Else execute read_elements again
		
	display:
		li $v0, 1
		lw $a0, ($s0)		# Read and pass the element at the index to the arguments
		syscall			# Print the element at the index
		
		ble $s0, $s1, exit	# Exit the program if all elements are printed
		
		li $v0, 4
		la $a0, coma
		syscall			# Print the coma
		
		addi $s0, $s0, -4	# Else decrement the index
		j display		# Else execute the display section again
		
	exit:
		li $v0,10		# system call to exit
		syscall			# bye bye
		
.data
	array: .space 80
	ask_size: .asciiz "Please enter the array size: "
	ask_element: .asciiz "Please enter a number: "
	coma: .asciiz ", "
