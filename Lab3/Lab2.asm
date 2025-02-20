#################
# CS224
# LAB 3
# Furkan Mert Aks1kal
# 222003191
# 24.10.2024
################
.data
	display_menu:		.asciiz	"\n1) Enter a new element to the linked list\n2) Display the linked list\n3) Display the linked list in reverse order\n4) Exit\nEnter your choice: "
	ask_key:		.asciiz	"Please enter the key for the new element: "
	ask_data:		.asciiz "Please enter the data for the new element: "
	new_line:		.asciiz "\n"
	linked_list:		.asciiz "Linked List -> "
	reverse_linked_list:	.asciiz "Reversed Linked List -> "
	comma:			.asciiz	", "
	open_paren:		.asciiz	"("
	close_paren:		.asciiz	") "
	arrow:			.asciiz	"-> "

.text
	main:
		# Display the menu once
		la 	$a0, display_menu
		li	$v0, 4
		syscall
		
		li	$v0, 5         # Get user input (choice)
		syscall
		
		beq	$v0, 1, option_1
		beq	$v0, 2, option_2
		beq	$v0, 3, option_3
		beq	$v0, 4, exit_program  # Option 4 to exit the program
		
		j main            # If invalid choice, show menu again
	
	option_1:
		# Insert a new element
		la 	$a0, ask_key
		li	$v0, 4
		syscall
		
		li	$v0, 5
		syscall
		move	$a1, $v0		# Key to be inserted

		la 	$a0, ask_data
		li	$v0, 4
		syscall
		
		li	$v0, 5
		syscall
		move	$a2, $v0		# Data to be inserted
		
		beqz	$s1, init_linked_list
		move	$a0, $s0		# Linked List's head
		j 	populate_list	

		j main             # Return to the menu after insertion
	
	# Initialize the linked list
	init_linked_list:
		li	$a0, 12			# Allocate 12 bytes for key, data, and next pointer
		li	$v0, 9
		syscall
		
		move	$s0, $v0		# Save the new node address in $s0 (head)
		sw	$a1, 0($s0)		# Store the key in the new node
		sw	$a2, 4($s0)		# Store the data in the new node
		sw	$zero, 8($s0)		# Set the next pointer to NULL (end of the list)
		addi	$s1, $s1, 1		# Increment the node count
		
		j main
	
	populate_list:
		move    $s2, $s0        # Start from the head of the list
    
    # Traverse to the end of the list
	iterate_over_list:
		lw      $s3, 8($s2)    # Load next pointer (use $s3 instead of $t1)
		beqz    $s3, add_node  # If next pointer is null, we've reached the end of the list
		move    $s2, $s3       # Move to the next node
		j       iterate_over_list
    
    # Add the new node at the end
	add_node:
		li      $a0, 12        # Allocate 12 bytes for key, data, and next pointer
		li      $v0, 9         # Memory allocation syscall
		syscall
        
		sw      $v0, 8($s2)    # Set the next pointer of the last node to the new node
		move    $s2, $v0       # Move to the new node (use $s2 for the new node)
		sw      $a1, 0($s2)    # Store the key in the new node
		sw      $a2, 4($s2)    # Store the data in the new node
		sw      $zero, 8($s2)  # Set the next pointer to NULL (end of the list)
        
		j main                 # Return to the menu after insertion

	option_2:
		# Display the linked list
		la 	$a0, linked_list
		li	$v0, 4
		syscall
		
		move	$s2, $s0         # Start from the head of the list
		jal	traverse_and_print

		la 	$a0, new_line
		li	$v0, 4
		syscall
		
		j main             # Return to the menu after displaying the list

traverse_and_print:
		move    $s2, $s0         # Start from the head of the list
    
    # Traverse the list and print each node
	print_loop:
		beqz    $s2, done_printing  # If $s2 is null, we're done
        
        # Print (key, data)
		la      $a0, open_paren
		li      $v0, 4
		syscall
        
		lw      $a0, 0($s2)   # Load key
		li      $v0, 1
		syscall
        
		la      $a0, comma
		li      $v0, 4
		syscall
        
		lw      $a0, 4($s2)   # Load data
		li      $v0, 1
		syscall
        
		la      $a0, close_paren
		li      $v0, 4
		syscall

        # Check if this is the last node, only print arrow if not last
		lw      $s3, 8($s2)   # Load the next pointer (use $s3)
		beqz    $s3, done_with_current_node  # If next is null, do not print arrow

        # Print arrow between nodes
		la      $a0, arrow
		li      $v0, 4
		syscall

	done_with_current_node:
		lw      $s2, 8($s2)   # Move to the next node
		j       print_loop
    
	done_printing:
		jr      $ra

	# Display the linked list in reverse
	option_3:
		la 	$a0, reverse_linked_list
		li	$v0, 4
		syscall
		
		move	$s1, $s0		# Save the head of the list
		jal 	recursive_traverse
		
		la 	$a0, new_line
		li	$v0, 4
		syscall
		
		j main             # Return to the menu after reverse printing

	# Recursive reverse traversal
	recursive_traverse:
		# Save current node and return address
		subi	$sp, $sp, 8
		sw	$s1, 0($sp)
		sw	$ra, 4($sp)
		
		lw	$s2, 8($s1)		# Load the next pointer
		beqz	$s2, base_case		# If next is null, this is the last node
		
		move	$s1, $s2		# Move to the next node
		jal	recursive_traverse	# Recursive call
		
		# Print (key, data) after returning from recursion
		la 	$a0, open_paren
		li	$v0, 4
		syscall
		
		lw	$a0, 0($s1)		# Load key from current node
		li	$v0, 1
		syscall
		
		la 	$a0, comma
		li	$v0, 4
		syscall
		
		lw	$a0, 4($s1)		# Load data from current node
		li	$v0, 1
		syscall
		
		# Only print arrow if not the first node
		bne	$s1, $s0, not_last_node
		
		j	skip_arrow

	not_last_node:
		la 	$a0, arrow
		li	$v0, 4
		syscall

	skip_arrow:
		# Restore saved node and return address
		lw	$s1, 0($sp)
		lw	$ra, 4($sp)
		addi	$sp, $sp, 8		# Adjust the stack pointer back
		
		jr	$ra                 # Return to caller

	# Base case for recursive reverse
	base_case:
		# Print the last node (key, data)
		la 	$a0, open_paren
		li	$v0, 4
		syscall
		
		lw	$a0, 0($s1)		# Load key from last node
		li	$v0, 1
		syscall
		
		la 	$a0, comma
		li	$v0, 4
		syscall
		
		lw	$a0, 4($s1)		# Load data from last node
		li	$v0, 1
		syscall
		
		# Do not print arrow after the last node
		
		# Restore node and return address
		lw	$s1, 0($sp)
		lw	$ra, 4($sp)
		addi	$sp, $sp, 8		# Adjust the stack pointer back
		
		jr	$ra

	# Exit program when option 4 is selected
	exit_program:
		li 	$v0, 10       # System call code for exit
		syscall          # Exit the program
