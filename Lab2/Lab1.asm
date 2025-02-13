.text
main:
    loop_start:
        # Get user input for registers in hexadecimal
        la $a0, prompt1         # Load first prompt
        jal display_message      # Display first prompt
        jal get_hex_input        # Get hexadecimal input for register 1
        move $s0, $v0            # Store input for register 1 in $s0

        la $a0, prompt2          # Load second prompt
        jal display_message       # Display second prompt
        jal get_hex_input        # Get hexadecimal input for register 2
        move $s1, $v0            # Store input for register 2 in $s1

        # Display register values in hexadecimal
        la $a0, register_prompt   # Load register values prompt
        jal display_message        # Display register values prompt
        
        move $a0, $s0             # Move first register value to $a0
        jal display_hex            # Display register 1 in hex

        move $a0, $s1             # Move second register value to $a0
        jal display_hex            # Display register 2 in hex

        # Call hamming distance subprogram
        move $a0, $s0             # Move first input to $a0
        move $a1, $s1             # Move second input to $a1
        jal hamming_distance       # Calculate Hamming distance

        # Display result message
        la $a0, result_prompt      # Load result prompt
        jal display_message         # Display result prompt

        move $a0, $s2             # Move result (stored in $s2) to $a0 for display
        jal display_int            # Display the calculated Hamming distance

        # Ask if the user wants to continue
        la $a0, continue_prompt    # Load continue prompt
        jal display_message         # Display continue prompt

        jal get_char_input         # Read user input for 'yn'
        li $s3, 'n'                # Compare input with 'n'
        beq $v0, $s3, exit         # Exit if 'n' is entered

        j loop_start               # Repeat if 'y' is entered

    exit:
        li $v0, 10                 # Exit program
        syscall

# Subprogram to get hexadecimal input (reads multiple characters)
get_hex_input:
    li $s4, 0                     # Clear register to accumulate the result

    read_next_char:
        li $v0, 12                # Read character (hex digit)
        syscall

        # Check if it's a newline or enter (end of input)
        li $s5, 10                # ASCII value for newline
        beq $v0, $s5, finish_input

        # Convert character to number
        li $s6, 48                # ASCII '0'
        li $s7, 57                # ASCII '9'
        blt $v0, $s6, check_alpha # Check if it's a number first
        bgt $v0, $s7, check_alpha
        sub $v0, $v0, $s6         # If it's a number ('0'-'9'), convert to int
        j shift_and_add           # Jump to shifting and adding

    check_alpha:
        # Handle uppercase letters 'A'-'F'
        li $s6, 65                # ASCII 'A'
        li $s7, 70                # ASCII 'F'
        blt $v0, $s6, check_lower  # Check if it's less than 'A'
        bgt $v0, $s7, check_lower
        sub $v0, $v0, 55          # Convert 'A'-'F' to hex (A=10, B=11, ..., F=15)
        j shift_and_add           # Jump to shifting and adding

    check_lower:
        # Handle lowercase letters 'a'-'f'
        li $s6, 97                # ASCII 'a'
        li $s7, 102               # ASCII 'f'
        blt $v0, $s6, invalid_input  # Check if it's less than 'a'
        bgt $v0, $s7, invalid_input
        sub $v0, $v0, 87          # Convert 'a'-'f' to hex (a=10, b=11, ..., f=15)

    shift_and_add:
        sll $s4, $s4, 4           # Shift accumulated value left by 4 bits (multiply by 16)
        add $s4, $s4, $v0         # Add the new digit to the accumulated value
        j read_next_char          # Read next character

    invalid_input:
        la $a0, error_msg         # Load error message
        jal display_message        # Display error message
        j exit                     # Jump to exit the program

    finish_input:
        move $v0, $s4             # Store the final result in $v0
        jr $ra                     # Return to the caller

# Subprogram to get a character input (for 'yn' choice)
get_char_input:
    li $v0, 12                    # Read character
    syscall
    jr $ra

# Subprogram for calculating Hamming distance
hamming_distance:
    xor $s3, $a0, $a1             # XOR the two registers to find differing bits, store result in $s3
    li $s2, 0                     # Initialize distance count (stored in $s2)

loop:
    beqz $s3, end_loop            # If no more bits, end loop

    andi $s4, $s3, 1              # Isolate the lowest bit (use $s4 for temporary storage)
    add $s2, $s2, $s4             # Add to distance count if bit is 1

    srl $s3, $s3, 1               # Shift right to process next bit
    j loop                        # Repeat

end_loop:
    jr $ra

# Subprogram for displaying message
display_message:
    li $v0, 4                     # Print string
    syscall
    jr $ra

# Subprogram for displaying integer
display_int:
    li $v0, 1                     # Print integer
    syscall
    jr $ra

# Subprogram for displaying hexadecimal value
display_hex:
    # Convert integer to hex and display
    li $t0, 0x10                  # Set base to 16
    li $t1, 0                     # Clear the index for storing hex characters
    li $t2, 0                     # Clear the output buffer

    # Convert the number to hexadecimal
convert_loop:
    move $a0, $a0                 # Move the number to $a0 for processing
    divu $a0, $t0                 # Divide by 16
    mfhi $t3                      # Get the remainder (hex digit)
    mflo $a0                      # Get the quotient
    # Convert the remainder to ASCII character
    blt $t3, 10, convert_to_char  # Check if it's less than 10
    addi $t3, $t3, 55             # Convert 'A'-'F'
    j store_char

convert_to_char:
    addi $t3, $t3, 48             # Convert '0'-'9'

store_char:
    sb $t3, hex_buffer($t1)       # Store the character in the buffer
    addi $t1, $t1, 1               # Increment the index
    bnez $a0, convert_loop        # Repeat if the quotient is not zero

    # Print hex characters in reverse order
    li $t4, 0                     # Set loop counter for printing
    move $t5, $t1                 # Move the index to $t5 for reversing

print_loop:
    beqz $t5, end_display_hex      # If index is zero, end loop
    addi $t5, $t5, -1              # Decrement the index
    lb $a0, hex_buffer($t5)        # Load the character from the buffer
    li $v0, 11                    # Print character
    syscall
    j print_loop                  # Repeat for next character

end_display_hex:
    li $a0, 10                    # Print newline
    li $v0, 11                    # Print character
    syscall
    jr $ra                        # Return to caller

.data
    prompt1: .asciiz "\nEnter value for register 1 (in hexadecimal): "
    prompt2: .asciiz "\nEnter value for register 2 (in hexadecimal): "
    register_prompt: .asciiz "Register values:\n"
    result_prompt: .asciiz "Hamming Distance: " 
    continue_prompt: .asciiz "\nDo you want to continue?(y/n): " 
    error_msg: .asciiz "\nInvalid input! Bye Bye!."
    hex_buffer: .space 16         # Buffer to store hex characters (16 bytes for 8 hex digits)
