#################
# CS224
# LAB 3
# Furkan Mert Aks1kal
# 222003191
# 23.10.2024
################

.text
.globl	main
	
main:
	la	$a0, registerPrompt
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	
	move	$a0, $v0
	
	blt	$a0,  1, terminate
	bgt	$a0, 31, terminate
	
	jal	registerCounter
	
	move	$s0, $v0
	
	la	$a0, resultPrompt
	li	$v0, 4
	syscall
	
	move	$a0, $s0
	
	la	$v0, 1
	syscall
	
	la	$a0, newLine
	li	$v0, 4
	syscall
	
	j	main
	
terminate:
	li	$v0, 10
	syscall
	
registerCounter:

	addi	$sp, $sp, -36	
	
	sw	$s0, 32($sp)
	sw	$s1, 28($sp)
	sw	$s2, 24($sp)
	sw	$s3, 20($sp)
	sw	$s4, 16($sp)
	sw	$s5, 12($sp)
	sw	$s6,  8($sp)
	sw	$s7,  4($sp)
	sw	$ra,  0($sp)	
	
	la	$s0, registerCounter	
	la	$s1, end		
	
	move	$s2, $a0		
	li	$s6, 0
	
next:
	bgt	$s0, $s1, exit
	
	lw	$s3, 0($s0)		
	srl	$s4, $s3, 26		
	
	beq	$s4, 2, JTypeIns
	beq	$s4, 3, JTypeIns
	
	sll	$s5, $s3,  6
	srl	$s5, $s5, 27		

	beq	$s5, $s2, incrementCountRS
	j	passRS
	
incrementCountRS:
	addi	$s6, $s6, 1
	
passRS:
	
	sll	$s5, $s3, 11
	srl	$s5, $s5, 27
	
	beq	$s5, $s2, incrementCountRT
	j	passRT
	
incrementCountRT:	
	addi	$s6, $s6, 1
	
passRT:
	beq	$s4, 0, RTypeIns
	j	JTypeIns

RTypeIns:
	sll	$s5, $s3, 16
	srl	$s5, $s5, 27
	
	beq	$s5, $s2, incrementCountRD
	j	JTypeIns
	
incrementCountRD:
	addi	$s6, $s6, 1
	
JTypeIns:
	addi	$s0, $s0, 4
	j	next
	
exit:
	move	$v0, $s6


	lw	$ra,  0($sp)	
	lw	$s7,  4($sp)
	lw	$s6,  8($sp)
	lw	$s5, 12($sp)
	lw	$s4, 16($sp)
	lw	$s3, 20($sp)
	lw	$s2, 24($sp)
	lw	$s1, 28($sp)
	lw	$s0, 32($sp)
	
	addi	$sp, $sp, +36	
	
end:
	jr	$ra
	
	.data
newLine:
	.asciiz	"\n"
registerPrompt:
	.asciiz	"Register to be found the #of occurences (0-31): "
resultPrompt:
	.asciiz	"Number of times the register appears is\t"
