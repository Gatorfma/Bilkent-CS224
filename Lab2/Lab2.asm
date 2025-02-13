.data
    prompt: .asciiz "\nEnter a hexadecimal number: "
    newline: .asciiz "\n"
    buffer: .space  9
    bin_str: .space  33
    rev_bin_str: .space  33
    hexFormat: .asciiz "Reversed Hexadecimal: "
    continuePrompt: .asciiz "Do you want to continue? (y/n): "
    continueBuffer: .space  2

.text
.globl main

main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 8
    la $a0, buffer
    li $a1, 9
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    la $s0, bin_str
    li $s1, 32

clear_bin_str:
    sb $zero, 0($s0)
    addi $s0, $s0, 1
    subi $s1, $s1, 1
    bnez $s1, clear_bin_str

    sb $zero, 0($s0)  # null terminate bin_str
    la $s0, bin_str  # pointer reset to start of bin_str

    la $s2, buffer
    li $s3, 8

hex_to_bin_loop:
    lb $s4, 0($s2)
    beqz $s4, end_loop

    jal hex_to_bin

    addi $s2, $s2, 1
    sub $s3, $s3, 1
    bnez $s3, hex_to_bin_loop

end_loop:
    la $s0, bin_str
    la $s1, rev_bin_str
    addi $v1, $s0, 31

reverse_loop:
    lb $s4, 0($v1)  # Load the last character from bin_str
    sb $s4, 0($s1)  # Store it at the start of rev_bin_str
    addi $s1, $s1, 1  # Move to the next position in rev_bin_str
    subi $v1, $v1, 1  # Move to the previous position in bin_str
    blt $v1, $s0, reverse_done  # Stop when the start of bin_str is reached
    j reverse_loop

reverse_done:
    sb $zero, 0($s1)

    la $s0, rev_bin_str
    li $s1, 0
    li $s2, 0

convert_loop:
    lb $s3, 0($s0)
    beqz $s3, print_hex

    # Convert '0' or '1' to integer
    subu $s3, $s3, '0'  # Convert ASCII '0' or '1' to integer (0 or 1)

    # Shift left hex value by 1 to make room for the new bit
    sll $s1, $s1, 1

    # Add the current bit to the hex value
    or $s1, $s1, $s3

    addiu $s0, $s0, 1
    j convert_loop

print_hex:
    li $v0, 4
    la $a0, hexFormat
    syscall

    li $v0, 34
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Ask if the user wants to continue
    li $v0, 4
    la $a0, continuePrompt
    syscall

    li $v0, 8
    la $a0, continueBuffer
    li $a1, 2
    syscall

    # Check if the user entered 'n'
    lb $t0, 0($a0)
    li $t1, 'n'
    beq $t0, $t1, exit_program

    # Otherwise, repeat the program
    j main

exit_program:
    li $v0, 10
    syscall


# Hex to binary conversion function
hex_to_bin:
    li $s5, 0

    li $s6, 48  # ASCII 0
    li $s7, 57  # ASCII 9
    blt $s4, $s6, check_uppercase
    bgt $s4, $s7, check_uppercase
    sub $s5, $s4, $s6
    j bin_conversion

check_uppercase:
    li $s6, 65  # ASCII A
    li $s7, 70  # ASCII F
    blt $s4, $s6, check_lowercase
    bgt $s4, $s7, check_lowercase
    sub $s5, $s4, 55
    j bin_conversion

check_lowercase:
    li $s6, 97  # ASCII a
    li $s7, 102  # ASCII f
    blt $s4, $s6, end_conversion
    bgt $s4, $s7, end_conversion
    sub $s5, $s4, 87

bin_conversion:
    # Convert the integer value ($s5) to a binary string
    li $s6, 4  # Number of bits to process (4 bits per hex digit)

bit_loop:
    andi $s7, $s5, 8  # Take leftmost bit
    beqz $s7, zero_bit
    li $v0, '1'  # Use $v0 to store '1'
    sb $v0, 0($s0)
    j next_bit

zero_bit:
    li $v0, '0'  # Use $v0 to store '0'
    sb $v0, 0($s0)

next_bit:
    addi $s0, $s0, 1
    sll $s5, $s5, 1
    subi $s6, $s6, 1
    bnez $s6, bit_loop

    j end_conversion

end_conversion:
    jr $ra
