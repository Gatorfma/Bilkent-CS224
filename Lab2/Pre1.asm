.text
	main:
		li $v0, 4
		la $a0, ask_size
		syscall
	
		li $v0, 5
		syscall
		jal CreateArray
		
		
	CreateArray:

		move $s1, $v0			
	
		mul $t0, $s1, 4
	
		li $v0, 9
		move $a0, $t0
		syscall
	
		move $s0, $v0			
		
		move $a0, $s0
		move $a1, $s1
		jal InitializeArray
		
		move $a0, $s0
		move $a1, $s1

		
		move $a0, $s0
		move $a1, $s1

		
		move $s2, $v0
		move $s3, $v1
		
		j display
		
		
	end_init:
		lw $s0, ($sp)	
		lw $s1, 4($sp)			
		jr $ra				
	Initialize_loop:
		beq $s1, $zero, end_init
		 
		li $v0, 4
		la $a0, ask_element
		syscall
		
		li $v0, 5
		syscall
		
		sw $v0, ($s0)
		
		add $s0, $s0, 4
		sub $s1, $s1, 1
		
		j Initialize_loop
	InitializeArray:
		move $s0, $a0
		move $s1, $a1
		
		addi $sp, $sp, -8
		sw $s0, ($sp)
		sw $s1, 4($sp)			
		
		j Initialize_loop
	
	
	display:
        	li $v0, 1          
        	lw $a0, ($s0)     
        	syscall            
        
        	sub $s1, $s1, 1 
        	beq $s1, $zero, end_display 

        	li $v0, 4          
        	la $a0, comma      
        	syscall

        	add $s0, $s0, 4    
        	j display          

	end_display:

        	li $v0, 10         
        	syscall
		
.data
	ask_size:	.asciiz "Please enter the array size: "
	ask_element:	.asciiz "Please enter an element: "
	comma:		.asciiz ", "
