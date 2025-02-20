.data
	ask_dimension: 	.asciiz "\nPlease enter the dimension of the square matrix: "
	display_menu:    .asciiz "\n\n1) Display element\n2) Row-major summation\n3) Column-major summation\n4) Exit\nYour choice: "
	ask_i:		.asciiz "Row index: "
	ask_j:		.asciiz "Column index: "	
	result:		.asciiz "Result: "
	comma:		.asciiz ", "


.text
# ======================================= Main Program =======================================
	main:
		jal 	initialize_matrix
		move	$s0, $v0		# $s0 holds the dimension of the matrix
		move	$s1, $v1		# $s1 holds the (0,0) index of the matrix
		
		move	$a0, $s0
		move	$a1, $s1
		jal 	fill_matrix
		
		j 	menu
		
	menu:
		li 	$v0, 4
		la 	$a0, display_menu
		syscall
		li 	$v0, 5
		syscall
		
		beq	$v0, 1, option_1
		beq	$v0, 2, option_2
		beq	$v0, 3, option_3
		beq     $v0, 4, exit

				
	option_1:
		li 	$v0, 4
		la 	$a0, ask_i
		syscall
		li 	$v0, 5
		syscall
		
		move	$t0, $v0		# $t0 holds i
		
		li 	$v0, 4
		la 	$a0, ask_j
		syscall
		li 	$v0, 5
		syscall
		
		move	$t1, $v0		# $t1 holds j
		
		move	$a0, $t0
		move	$a1, $t1
		move	$a2, $s0
		jal	calculate_index
		move	$t0, $v0		
	
		add	$t0, $t0, $s1		# $t0 holds the index
		
		li 	$v0, 4
		la 	$a0, result
		syscall
		lh	$a0, 0($t0)
		li	$v0, 1
		syscall
		
		j	menu
	
	
	option_2:
		move	$a0, $s0
		li	$v0, 9
		syscall
		
		move	$a3, $v0
		move	$t7, $v0
		move	$t0, $s0
		li	$t2, 1
		li	$t3, 1
		
		j option_2_loop
		
        
	option_2_loop:
		bgt	$t3, $s0, col_eq_dim
		
		move	$a0, $t2
		move	$a1, $t3
		move	$a2, $s0
		jal	calculate_index
		add	$t1, $s1, $v0
		
		lh	$t4, 0($t1)
		
		subi	$t6, $t2, 1
		mul	$t6, $t6, 4
		add	$t7, $t7, $t6
		
		lw	$t5, 0($t7)
		add	$t5, $t5, $t4
		sw	$t5, 0($t7)
		
		sub	$t7, $t7, $t6
		addi	$t3, $t3, 1	
		
		j 	option_2_loop
	col_eq_dim:
		addi	$t2, $t2, 1
		bgt	$t2, $s0, end_option_2
		li	$t3, 1
		
		j option_2_loop
		
	end_option_2:
        	beq     $t0, $zero, print_newline_2
        
        	lw      $a0, 0($a3)
        	li      $v0, 1
        	syscall
        	li      $v0, 4
        	la      $a0, comma
        	syscall
        
        	subi    $t0, $t0, 1
        	addi    $a3, $a3, 4
        
        	j       end_option_2

	print_newline_2:          
        	j       menu       
		
	
	option_3:
		move	$a0, $s0
		li	$v0, 9
		syscall
		
		move	$a3, $v0
		move	$t7, $v0
		move	$t0, $s0
		li	$t2, 1
		li	$t3, 1
		
		j option_3_loop
		
	option_3_loop:
		bgt	$t2, $s0, row_eq_dim
		
		move	$a0, $t2
		move	$a1, $t3
		move	$a2, $s0
		jal	calculate_index
		add	$t1, $s1, $v0
		
		lh	$t4, 0($t1)
		
		subi	$t6, $t3, 1
		mul	$t6, $t6, 4
		add	$t7, $t7, $t6
		
		lw	$t5, 0($t7)
		add	$t5, $t5, $t4
		sw	$t5, 0($t7)
		
		sub	$t7, $t7, $t6
		addi	$t2, $t2, 1	
		
		j 	option_3_loop
	row_eq_dim:
		addi	$t3, $t3, 1
		bgt	$t3, $s0, end_option_3
		li	$t2, 1
		
		j option_3_loop
		
	end_option_3:
        	beq     $t0, $zero, print_newline_3
        
        	lw      $a0, 0($a3)
        	li      $v0, 1
        	syscall
        	li      $v0, 4
        	la      $a0, comma
        	syscall
        
        	subi    $t0, $t0, 1
        	addi    $a3, $a3, 4
        
        	j       end_option_3

	print_newline_3:           
        	j       menu       


	exit:
		li 	$v0, 10
		syscall
# ============================================================================================
# ======================================= Sub Programs =======================================
	calculate_index:
		subi	$a0, $a0, 1
		mul	$a0, $a0, 2	
		mul	$a0, $a0, $a2
		
		subi	$a1, $a1, 1
		mul	$a1, $a1, 2
		
		add	$v0, $a0, $a1
		
		jr	$ra
	
	initialize_matrix:
		li 	$v0, 4
		la 	$a0, ask_dimension
		syscall
		li 	$v0, 5
		syscall
		
		move	$t0, $v0	# $t0 holds the matrix dimension
		
		mul  	$t1, $t0, $t0	# $t1 now hold the number of elements in the matrix
		mul  	$t1, $t1, 2	# $t1 now holds the number of bytes required for the matrix (number of elements * 2) as 1 halfword = 2 bytes
		
		li 	$v0, 9
		move	$a0, $t1
		syscall
		
		move 	$v1, $v0	# $v1 returns the (0,0) index of the matrix
		move	$v0, $t0	# $v0 returns the dimension
		jr	$ra
		
	fill_matrix:
		move	$t0, $a0
		mul	$t0, $t0, $t0
		move	$t1, $a1
		li	$t2, 1
	
		j 	fill_matrix_loop
	fill_matrix_loop: 	
		beq	$t0, $zero, end_fill_matrix_loop
		sh	$t2, 0($t1)
		addi	$t1, $t1, 2
		addi	$t2, $t2, 1
		addi	$t0, $t0, -1
		
		j fill_matrix_loop
	end_fill_matrix_loop:
		jr	$ra
# ============================================================================================
