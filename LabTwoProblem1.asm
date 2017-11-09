########################################################################
# Student: Eric Schenck						Date: 11/9/17
# Description: LabTwoProblem1.asm - program to process two integer arrays of size 20: 
#		named Raw and Fresh. The Raw array is initialized to given values.
#		The values for Fresh array will be read in from user after correctly 
#		prompted. All elements of Fresh wil be stored in memory. Output the sum
#		of two largest integers and teh sum of two smallest integers of Raw 
#		and store teh sum of two largest integers and the sum of two smallest 
#		integers of Fresh in memory locations right after where the last 
#		element of Fresh is stored. Test the program. 						
#
# Registers Used:
#	$a0: Used for various Arguments
#	$a1: Used for size of array arguments
#	$s0: Used to hold final max and min sums
#	$s1: Used to hold final max and min sums
#	$t0: Used for counters and other temporary uses
#	$t1: Used to hold min/max data in Functions 
#	$v0: Used for return variables and other uses
#
#
########################################################################
		.data
msg:		.asciiz "\nPlease enter a series of integers, each followed by the enter key: "
codeFixer:	.asciiz "For some reason having this here fixes the code????"
LargeOutput:	.asciiz "\nSum of the largest Two values: "
SmallOutput:	.asciiz "\nSum of the smallest Two values: "
Raw:		.word 2, 17, 28, 20, 6, 51, 20, 48, 12, 54, 3, 31, 15, 22, 46, 72, 41, 39, 30, 55
Fresh:		.word 0:20				# int Fresh[20] with all initially value 0



		.text
		.globl main
		
main: 		
		 
		li $v0, 4			# code to print String
		la $a0, msg			# msg for prompt
		syscall
		
		la $a0, Fresh			# loading address of Fresh into $a0
		li $t0, 18			# counter to store 18 integers in an array size 20
						# leaving 2 open spaces to saved

inputLoop:		
		li $v0, 5			# code to read integer
		syscall
		
		sw $v0, 0($a0)			# storing word in Fresh Array 
		addi $a0, $a0, 4		# Offsetting to get to next index
		
		addi $t0, $t0, -1		# Decriment loop counter $t0
		bgtz $t0, inputLoop		# if($t0 > 0){loop}
		
EndOfLoop:		

		la $a0, Raw			# $a0 holding address of Raw
		li $a1, 20			# $a1 holding number of elements in array
		jal FindMaxTwoSum		# calling FindMaxTwoSum on Raw array
		move $s0, $v0			# moving MaxSum into $s0
		
		la $a0, Raw			
		li $a1, 20
		jal FindMinTwoSum		# calling FindMinTwoSum on Raw array
		move $s1, $v0			# moving MinSum into $s1
		
		li $v0, 4			# code to print String
		la $a0, LargeOutput		# msg for big output
		syscall
		
		li $v0, 1			# code to print integer
		move $a0, $s0 			# Print larger sum
		syscall
		
		li $v0, 4			# code to print String
		la $a0, SmallOutput		# msg for small output
		syscall
		
		li $v0, 1			# code to print integer
		move $a0, $s1 			# Print smaller sum
		syscall
				
		la $a0, Fresh			# $a0 holding address of Fresh
		li $a1, 18			# $a1 holding number of elements in array
		jal FindMaxTwoSum		# calling FindMaxTwoSum on Fresh array
		move $s0, $v0			# moving MaxSum into $s0
		
		la $a0, Fresh			# $a0 holding address of Fresh
		li $a1, 18			# $a1 holding number of elements in array
		jal FindMinTwoSum		# calling FindMinTwoSum on Fresh array
		move $s1, $v0			# moving MinSum into $s1
		
		
		la $a0, Fresh			# $a0 holding address of Fresh
		li $t0, 18			# Index in Fresh right after last element
		sll $t0, $t0, 2			# Multiplying Index by 4, for offset
		add $a0, $a0, $t0		
		sw $s0, 0($a0)			# storing MaxSum 
		
		addi $a0, $a0, 4		# accounting for offset, now at last position
		sw $s1, 0($a0)			# storing MinSum
		
						
Exit:		li $v0, 10 			# System code to exit
		syscall				# make system call 

########################################################################
		
		.text
FindMaxTwoSum:	lw $v0, 0($a0)			# loading first term in array into firstMax register
		addi $a0, $a0, 4		# to get next location in array
		lw $t1, 0($a0)			# loading second term in array into secondMax register
		addi $a1, $a1, -2		# decriment my counter variable by two since i store two values
		ble $a1, $zero, Return1		# making sure counter is above zero before entering loop
		
loop1:		addi $a0, $a0, 4		# Offsetting array address to get next value
		lw $t0, 0($a0)			# loading next integer into temp register 
		
chkFirst1:	ble $t0, $v0, chkSecond1		# if ( newInput <= firstMax ) then check secondMax
		move $v0, $t0			# $t0 is now stored as FirstMax value
		j Update1			# skip secondMax check since FirstMax already swapped
		
chkSecond1:	ble $t0, $t1, Update1		# if ( newInput <= secondMax ) then skip to update
		move $t1, $t0			# $t0 is now stored as SecondMax

Update1:	addi $a1, $a1, -1		# decriment counter variable
		bgtz $a1, loop1			# if ($a1 > 0 ) continue to check for max value
		
Return1:	add $v0, $v0, $t1		# sum of two largest values in array
		jr $ra				# sum will be stored in $v0
########################################################################

FindMinTwoSum:	lw $v0, 0($a0)			# loading first term in array into firstMin register
		addi $a0, $a0, 4		# to get next location in array
		lw $t1, 0($a0)			# loading second term in array into secondMin register
		addi $a1, $a1, -2		# decriment my counter variable by two since i store two values
		ble $a1, $zero, Return		# making sure counter is above zero before entering loop
		
loop:		addi $a0, $a0, 4		# Offsetting array address to get next value
		lw $t0, 0($a0)			# loading next integer into temp register 
		
chkFirst:	bge $t0, $v0, chkSecond		# if ( newInput >= firstMin ) then check secondMin
		move $v0, $t0			# $t0 is now stored as FirstMin value
		j Update			# skip secondMin check since FirstMin already swapped
		
chkSecond:	bge $t0, $t1, Update		# if ( newInput >= secondMax ) then skip to update
		move $t1, $t0			# $t0 is now stored as SecondMin

Update:		addi $a1, $a1, -1		# decriment counter variable
		bgtz $a1, loop			# if ($a1 > 0 ) continue to check for min values
		
Return:		add $v0, $v0, $t1		# sum of two smallest values in array
		jr $ra				# sum will be stored in $v0
