#################
# CS224
# LAB 3
# Furkan Mert Aks1kal
# 222003191
# 24.10.2024
################

.data
endl:   .asciiz "\n"
linkedListSize: .asciiz "Enter linked list size: "
line:   .asciiz "\n--------------------------------------"
reverselist: .asciiz "\nReversed List: "
nodeNumberLabel: .asciiz "\nNode No.: "
addressOfCurrentNodeLabel: .asciiz "\nAddress of Current Node: "
addressOfNextNodeLabel: .asciiz "\nAddress of Next Node: "
dataValueOfCurrentNode: .asciiz "\nData Value of Current Node: "
keyValueOfCurrentNode: .asciiz "\n Key Value of Current Node: "
getKey: .asciiz "\nEnter key value: "
getData: .asciiz "\nEnter data value: "
space: .asciiz " "
openParen: .asciiz "("
closeParen: .asciiz ")"
comma: .asciiz ", "
	
.text	
main:
    	li $v0, 4
    	la $a0, linkedListSize
    	syscall

    	li $v0, 5
    	syscall
    	move $a0, $v0  #size = a0
    	move $a1, $v0 #size = a1
    	
    	move $a0, $a1
	jal	createLinkedList
	
	# $v0=head address of the list
	# $v1=size of list
	move $a0 $v0 
	move $a1 $v1
	jal baseTraverse
	
	move	$a0, $s0	# Pass the linked list address in $a0
	jal 	printLinkedList
    	
baseTraverse:
	addi $sp $sp -8
	sw $a0 4($sp) 
	sw $ra 0($sp)
	
	lw $s1 0($a0) #load address to s1
	bnez $s1 recursiveTraverse #if s1 pointer isnt empty keep looping
	jal printNodeStart #print node
	lw $ra 0($sp)
	addi $sp $sp 8 #restore stack
	jr $ra
	
recursiveTraverse:
		
	lw $a0 0($a0) #update node and call base traverse
	jal baseTraverse  #recursive part
	lw $a0 4($sp)  #update node and call print
	
	move $s3, $a0
	
	la $a0 space
	li $v0 4
	syscall
	
	move $a0, $s3
	
	jal printNode 
	lw $ra 0($sp) #restore ra from stack
	addi $sp $sp 8
	jr $ra
	
printNodeStart: #this subprogram prints the message
	move $s2 $a0 
	
	la $a0 reverselist #print message
	li $v0 4
	syscall
	
	move $a0 $s2 
	
printNode: # This subprogram prints the element in the format (key,data)
    move $s2, $a0
    # Print open parenthesis
    la $a0, openParen
    li $v0, 4
    syscall

    # Print key (4th byte offset)
    lw $a0, 4($s2)
    li $v0, 1
    syscall

    # Print comma
    la $a0, comma
    li $v0, 4
    syscall

    # Print data (8th byte offset)
    lw $a0, 8($s2)
    li $v0, 1
    syscall

    # Print closing parenthesis
    la $a0, closeParen
    li $v0, 4
    syscall

    jr $ra

createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 12
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	li $v0, 4
    	la $a0, getKey
    	syscall
    	# read the size of the array from the user
    	li $v0, 5
    	syscall
    	move $s4, $v0
    	
    	sw	$s4, 4($s2)	# Store the data value.
    	
    	li $v0, 4
    	la $a0, getData
    	syscall
    	# read the size of the array from the user
    	li $v0, 5
    	syscall
    	move $s4, $v0

	sw	$s4, 8($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 12 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	
	li $v0, 4
    	la $a0, getKey
    	syscall
    	# read the size of the array from the user
    	li $v0, 5
    	syscall
    	move $s4, $v0
    	
    	sw	$s4, 4($s2)	# Store the data value.
    	
    	li $v0, 4
    	la $a0, getData
    	syscall
    	# read the size of the array from the user
    	li $v0, 5
    	syscall
    	move $s4, $v0
	
	sw	$s4, 8($s2)	# Store the data value.
	
	j	addNode
	
allDone:
	move	$v0, $s3	# Return the list head.
	move	$v1, $s0	# Return the number of nodes created.
	
	lw	$s0, 20($sp)
	lw	$s1, 16($sp)
	lw	$s2, 12($sp)
	lw	$s3, 8($sp)
	lw	$s4, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 24
	
	jr	$ra

move	$a0, $v0	# Pass the linked list address in $a0
printLinkedList:
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				
	lw	$s1, 0($s0)	
	lw	$s2, 4($s0)	
	addi	$s3, $s3, 1
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

	move	$s0, $s1	
	j	printNextNode
printedAll:

	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20

	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 
	
	move	$s0, $a0	
	li	$s1, 1		

	li	$a0, 8
	li	$v0, 9
	syscall
	move	$s2, $v0
	move	$s3, $v0	
	sll	$s4, $s1, 2	
	sw	$s4, 4($s2)	
	
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	
	li	$a0, 8 		
	li	$v0, 9
	syscall
	
	sw	$v0, 0($s2)
	move	$s2, $v0	
	sll	$s4, $s1, 2	
	sw	$s4, 4($s2)
	
	li $v0, 10
	syscall
