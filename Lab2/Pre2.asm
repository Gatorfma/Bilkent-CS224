.data
ask_size:      .asciiz "Please enter the array size: "
ask_element:   .asciiz "Please enter an element: "
comma:         .asciiz ", "
colon_space:   .asciiz ": "
other_label:   .asciiz "Other: "
newline:       .asciiz "\n"
FreqTable:     .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0    # Frequency table for 0-9 and "other"

.text
main:
    li $v0, 4
    la $a0, ask_size
    syscall

    li $v0, 5            
    syscall
    move $s1, $v0        

    mul $t0, $s1, 4      
    li $v0, 9            
    move $a0, $t0    
    syscall
    move $s0, $v0       
    move $a0, $s0        
    move $a1, $s1        
    jal InitializeArray  
    
    # Call FindFreq to calculate frequencies
    move $a0, $s0        
    move $a1, $s1        
    la $a2, FreqTable   
    jal FindFreq         

    # Print the frequency table
    la $a0, FreqTable    
    jal PrintFreqTable   

    li $v0, 10          
    syscall

# Subroutine to initialize the array
InitializeArray:
    move $t0, $a0        
    move $t1, $a1       

Initialize_loop:
    beq $t1, $zero, end_init  

    li $v0, 4
    la $a0, ask_element  
    syscall

    li $v0, 5            
    syscall

    sw $v0, ($t0)       
    addi $t0, $t0, 4    
    subi $t1, $t1, 1     
    j Initialize_loop    

end_init:
    jr $ra               
# Subroutine to find the frequency of numbers in the array
FindFreq:
    move $t0, $a0        
    move $t1, $a1        
    move $t2, $a2        

FreqLoop:
    beq $t1, $zero, endFindFreq 

    lw $t3, ($t0)      
    blt $t3, 0, storeOther  
    bgt $t3, 9, storeOther 

    # Increment the count for the number between 0-9
    sll $t4, $t3, 2      
    add $t5, $t2, $t4    
    lw $t6, ($t5)        
    addi $t6, $t6, 1    
    sw $t6, ($t5)      
    j updateLoop

storeOther:
    # Increment the count for "other" numbers
    add $t5, $t2, 40   
    lw $t6, ($t5)        
    addi $t6, $t6, 1     
    sw $t6, ($t5)        

updateLoop:
    addi $t0, $t0, 4  
    subi $t1, $t1, 1   
    j FreqLoop           

endFindFreq:
    jr $ra          

# Subroutine to print the frequency table
PrintFreqTable:
    move $t0, $a0      
    li $t1, 0           

PrintLoop:
    beq $t1, 10, printOther 

    # Print the current number
    li $v0, 1          
    move $a0, $t1       
    syscall

    # Print ": " separator
    li $v0, 4            
    la $a0, colon_space  
    syscall

    # Print the frequency
    sll $t2, $t1, 2      
    add $t3, $t0, $t2    
    lw $a0, ($t3)        
    li $v0, 1           
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    addi $t1, $t1, 1     
    j PrintLoop          

printOther:
    # Print "Other: "
    li $v0, 4
    la $a0, other_label  
    syscall

    # Print the count for "other" numbers
    lw $a0, 40($t0)      
    li $v0, 1           
    syscall

    # Print newline and finish
    li $v0, 4
    la $a0, newline
    syscall

    jr $ra               # Return from subroutine
