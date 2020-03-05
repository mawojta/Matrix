#######################################################################
#   Program 6
#
#   Name: Michelle Wojta
#   Date: 12/06/2018
#
#   Program Discription:
#		This program will ask the user to input a matrix A. Matrix A will be transposed and
#	stored as new Matrix B. After transpose, this program will process multiplication on 
#	Matrix B (tranposed) and Matrix A (original) storing result as new matrix, Matrix C.
#
#   Program Structure:
#       -main
#           -create_row_matrix
#               -allocate_row_matrix
#           -print_row_matrix: A
#           -transpose_row_matrix: A
#               -allocate_row_matrix: B == transpose(A)
#           -print_row_matrix: B == transpose(A)
#           -mul_row_matrix: A*B == A*[transpose(A)]
#               -allocate_row_matrix: C == A*[transpose(A)]
#           -print_row_matrix: C == A*B == A*[transpose(A)]
#
#	References:
#		Discussion notes, previous labs, previous programs, D2L downloads,  
#			course textbook, TA - Sia, .edu websites such as one below:
#			http://pages.cs.wisc.edu/~markhill/cs354/Fall2008/notes/MAL.instructions.html
#######################################################################
#       Register Usage
#   $t0 matrix base address of matrix A
#   $t1 matrix height of matrix A
#   $t2 matrix width of matrix A
#   $t3 matrix base address of matrix B
#   $t4 matrix height of matrix B
#   $t5 matrix width of matrix B
#######################################################################
        .data
greetings: 			.asciiz	"Hello!\n"
print_Amatrix:		.asciiz	"\nMatrix A:\n"
print_Bmatrix:		.asciiz	"\nMatrix B:\n"
print_Cmatrix:		.asciiz	"\nMatrix C (mul(B, A) = mul(transpose(A), A)):\n"
Amatrix_pointer:    .word   0
Bmatrix_pointer:    .word   0
Cmatrix_pointer:    .word   0
Amatrix_height:     .word   0
Bmatrix_height:     .word   0
Cmatrix_height:     .word   0
Amatrix_width:		.word   0
Bmatrix_width:		.word   0
Cmatrix_width:		.word   0
#######################################################################
    .text
main:
	li $v0, 4
	la $a0, greetings
	syscall	
	
#####create_row_matrix: A
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -12				#$sp <- $sp - 12 (3 words: 0 IN, 3 OUT)
	
	jal create_row_matrix			#goes to subprogram to create matrix
	
	lw $t0, 0($sp)					#$t0 <- base address
	lw $t1, 4($sp)					#$t1 <- matrix height
	lw $t2, 8($sp)					#$t2 <- matrix width
	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
	la $t9, Amatrix_pointer			#load Amatrix_pointer into $t9
	sw $t0, 0($t9)					#stores matrix A base address into static memory
	
	la $t9, Amatrix_height			#load Amatrix_height into $t9
	sw $t1, 0($t9)					#stores matrix A height into static memory
	
	la $t9, Amatrix_width			#load Amatrix_width into $t9
	sw $t2, 0($t9)					#stores matrix A width into static memory

#####print_row_matrix: A
	li $v0, 4
	la $a0, print_Amatrix
	syscall	
	
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -12				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)	
	sw $t2, 8($sp)	
	
	addi $sp, $sp, -12				#$sp <- $sp - 12 (3 words: 3 IN, 0 OUT)
	sw $t0, 0($sp)					#stack[0] <- matrix A base address
	sw $t1, 4($sp)					#stack[4] <- matrix A height
	sw $t2, 8($sp)					#stack[8] <- matrix A width
	
	jal print_row_matrix			#goes to subprogram to print matrix A

	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)
	
	lw $t0, 0($sp)					#$t0 <- matrix A base address (restore)
	lw $t1, 4($sp)					#$t1 <- matrix A height (restore)
	lw $t2, 8($sp)					#$t2 <- matrix A width (restore)
	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)

#####transpose_row_matrix: A --> B
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -12				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)	
	sw $t2, 8($sp)	
	
	addi $sp, $sp, -24				#$sp <- $sp - 24 (6 words: 3 IN, 3 OUT)
	sw $t0, 0($sp)					#stack[0] <- matrix A base address (IN)
	sw $t1, 4($sp)					#stack[4] <- matrix A height (IN)
	sw $t2, 8($sp)					#stack[8] <- matrix A width (IN)
	
	jal transpose_row_matrix		#goes to subprogram to transpose matrix A, create matrix B

	lw $t3, 12($sp)					#$t3 <- matrix B base address (OUT)
	lw $t4, 16($sp)					#$t4 <- matrix B height (OUT)
	lw $t5, 20($sp)					#$t5 <- matrix B width (OUT)
	addi $sp, $sp, 24				#$sp <- $sp + 24 (6 words)
	
	lw $t0, 0($sp)					#$t0 <- matrix A base address (restore)
	lw $t1, 4($sp)					#$t1 <- matrix A height (restore)
	lw $t2, 8($sp)					#$t2 <- matrix A width (restore)
	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)

	la $t9, Bmatrix_pointer			#load Bmatrix_pointer into $t9
	sw $t3, 0($t9)					#stores matrix B base address into static memory
	
	la $t9, Bmatrix_height			#load Bmatrix_height into $t9
	sw $t4, 0($t9)					#stores matrix B height into static memory
	
	la $t9, Bmatrix_width			#load Bmatrix_width into $t9
	sw $t5, 0($t9)					#stores matrix B width into static memory
	
#####print_row_matrix: B
	li $v0, 4
	la $a0, print_Bmatrix
	syscall	
	
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -24				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)	
	sw $t2, 8($sp)
	sw $t3, 12($sp)		
	sw $t4, 16($sp)
	sw $t5, 20($sp)	
	
	addi $sp, $sp, -12				#$sp <- $sp - 12 (3 words: 3 IN, 0 OUT)
	sw $t3, 0($sp)					#stack[0] <- matrix B base address
	sw $t4, 4($sp)					#stack[4] <- matrix B height
	sw $t5, 8($sp)					#stack[8] <- matrix B width
	
	jal print_row_matrix			#goes to subprogram to print matrix B

	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)
	
	lw $t0, 0($sp)					#$t0 <- matrix A base address (restore)
	lw $t1, 4($sp)					#$t1 <- matrix A height (restore)
	lw $t2, 8($sp)					#$t2 <- matrix A width (restore)	
	lw $t3, 12($sp)					#$t3 <- matrix B base address (restore)
	lw $t4, 16($sp)					#$t4 <- matrix B height (restore)
	lw $t5, 20($sp)					#$t5 <- matrix B width (restore)
	addi $sp, $sp, 24				#$sp <- $sp + 24 (6 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
#####mul_row_matrix: A*B == A*[transpose(A)] --> C
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -24				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)	
	sw $t2, 8($sp)
	sw $t3, 12($sp)		
	sw $t4, 16($sp)
	sw $t5, 20($sp)	
	
	addi $sp, $sp, -36				#$sp <- $sp - 36 (9 words: 6 IN, 3 OUT)
	sw $t0, 0($sp)					#stack[0] <- matrix A base address (IN)
	sw $t1, 4($sp)					#stack[4] <- matrix A height (IN)
	sw $t2, 8($sp)					#stack[8] <- matrix A width (IN)
	sw $t3, 12($sp)					#stack[12] <- matrix B base address
	sw $t4, 16($sp)					#stack[16] <- matrix B height
	sw $t5, 20($sp)					#stack[20] <- matrix B width
	
	jal mul_row_matrix				#goes to subprogram to multiply matrix A and matrix B

	lw $t6, 24($sp)					#$t6 <- matrix C base address (OUT)
	lw $t7, 28($sp)					#$t7 <- matrix C height (OUT)
	lw $t8, 32($sp)					#$t8 <- matrix C width (OUT)
	addi $sp, $sp, 36				#$sp <- $sp + 36 (9 words)
	
	lw $t0, 0($sp)					#$t0 <- matrix A base address (restore)
	lw $t1, 4($sp)					#$t1 <- matrix A height (restore)
	lw $t2, 8($sp)					#$t2 <- matrix A width (restore)	
	lw $t3, 12($sp)					#$t3 <- matrix B base address (restore)
	lw $t4, 16($sp)					#$t4 <- matrix B height (restore)
	lw $t5, 20($sp)					#$t5 <- matrix B width (restore)
	addi $sp, $sp, 24				#$sp <- $sp + 24 (6 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)

	la $t9, Cmatrix_pointer			#load Cmatrix_pointer into $t9
	sw $t6, 0($t9)					#stores matrix C base address into static memory
	
	la $t9, Cmatrix_height			#load Cmatrix_height into $t9
	sw $t7, 0($t9)					#stores matrix C height into static memory
	
	la $t9, Cmatrix_width			#load Cmatrix_width into $t9
	sw $t8, 0($t9)					#stores matrix C width into static memory

#####print_row_matrix: C
	li $v0, 4
	la $a0, print_Cmatrix
	syscall	
		
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -36				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)	
	sw $t2, 8($sp)
	sw $t3, 12($sp)		
	sw $t4, 16($sp)
	sw $t5, 20($sp)		
	sw $t6, 24($sp)		
	sw $t7, 28($sp)
	sw $t8, 32($sp)	
	
	addi $sp, $sp, -12				#$sp <- $sp - 12 (3 words: 3 IN, 0 OUT)
	sw $t6, 0($sp)					#stack[0] <- matrix C base address
	sw $t7, 4($sp)					#stack[4] <- matrix C height
	sw $t8, 8($sp)					#stack[8] <- matrix C width
	
	jal print_row_matrix			#goes to subprogram to print matrix C

	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)
	
	lw $t0, 0($sp)					#$t0 <- matrix A base address (restore)
	lw $t1, 4($sp)					#$t1 <- matrix A height (restore)
	lw $t2, 8($sp)					#$t2 <- matrix A width (restore)	
	lw $t3, 12($sp)					#$t3 <- matrix B base address (restore)
	lw $t4, 16($sp)					#$t4 <- matrix B height (restore)
	lw $t5, 20($sp)					#$t5 <- matrix B width (restore)	
	lw $t6, 12($sp)					#$t6 <- matrix c base address (restore)
	lw $t7, 16($sp)					#$t7 <- matrix c height (restore)
	lw $t8, 20($sp)					#$t8 <- matrix c width (restore)
	addi $sp, $sp, 36				#$sp <- $sp + 36 (9 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)

exit:
	li $v0, 10						#End Program
	syscall
	
#######################################################################
#######################################################################
#   create_row_matrix
#
#	This subprogram has 0 arguments IN and 3 arguments OUT:
#		-	matrix base address
#		-	matrix height
#		-	matrix width
#
#	This subprogram will prompt the user for height and width, validating both values to 
#	be greater than zero. When correct values are received, this subprogram will call 
#	allocate_row_matrix to allocate a new matrix. After return, this subprogram will 
#	read user input to fill out the entire matrix in row-major order.
#######################################################################
#       Arguments IN and OUT of subprogram
#   $sp+0   matrix base address  (OUT)
#   $sp+4   matrix height  (OUT)
#   $sp+8   matrix width  (OUT)
#######################################################################
#       Register Usage
#   $t0 Holds matrix base address
#   $t1 Holds matrix height
#   $t2 Holds matrix width
#   $t3 row index
#   $t4 column index
#   $t5 temporary value
#######################################################################
        .data
matrix_height_prompt_p:	.asciiz "Enter matrix height: "
matrix_width_prompt_p:	.asciiz "Enter matrix width: "
matrix_error_p:			.asciiz "Invalid value, matrix dimensions must be greater than zero!\n"
matrix_get_value:		.asciiz	"Enter a double: "
#######################################################################
        .text
create_row_matrix:
	li $v0, 4
	la $a0, matrix_height_prompt_p
	syscall
	
	li $v0, 5
	syscall
	
	blez $v0, create_error
	move $t1, $v0
	
create_row_matrix_width:
	li $v0, 4
	la $a0, matrix_width_prompt_p
	syscall
	
	li $v0, 5
	syscall
	
	blez $v0, create_error_width
	move $t2, $v0
	
	b call_allocate_row_matrix
	
create_error:
	li $v0, 4
	la $a0, matrix_error_p
	syscall
	
	b create_row_matrix
	
create_error_width:
	li $v0, 4
	la $a0, matrix_error_p
	syscall
	
	b create_row_matrix_width
	
call_allocate_row_matrix:
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)
		
	addi $sp, $sp, -8				#Backup
	sw $t1, 0($sp)					
	sw $t2, 4($sp)					

	addi $sp, $sp, -12				#$sp <- $sp - 12 (3 words: 2 IN, 1 OUT)
	sw $t1, 0($sp)					
	sw $t2, 4($sp)
	
	jal allocate_row_matrix			#goes to subprogram to create matrix

	lw $t0, 8($sp)					#$t0 <- matrix A base address
	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)
	
	lw $t1, 0($sp)					#$t1 <- matrix A height (restore)
	lw $t2, 4($sp)					#$t2 <- matrix A width (restore)
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
read_row_matrix:
	li $t3, 0	
	
read_outer:
	beq $t3, $t1, read_row_matrix_end
	li $t4, 0

read_inner:
	beq $t4, $t2, read_inner_end

	mul $t5, $t3, $t2
	add $t5, $t5, $t4
	sll $t5, $t5, 3
	add $t5, $t0, $t5
	
	li $v0, 4
	la $a0, matrix_get_value
	syscall
	
	li $v0, 7
	syscall
	
	s.d $f0, 0($t5)
	
	addi $t4, $t4, 1
	
	b read_inner

read_inner_end:
	addi $t3, $t3, 1
	
	b read_outer
	
read_row_matrix_end:
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	jr $ra							#Return to calling location
	
#######################################################################
#######################################################################
#   allocate_row_matrix
#
#	This subprogram will take 2 arguments IN:
#		-	matrix height
#		-	matrix width
#	 and 1 argument OUT:
#		-	matrix base address
#
#	This subprogram will dynamically allocate precisely enough memory in the heap to 
#	contain the matrix of double precision floating point numbers.
#######################################################################
#       Arguments IN and OUT of subprogram
#   $sp+0   matrix height  (IN)
#   $sp+4   matrix width  (IN)
#   $sp+8   matrix base address  (OUT)
#######################################################################
#       Register Usage
#   $t0 Holds matrix base address
#   $t1 Holds matrix height
#   $t1 Holds matrix width
#######################################################################
        .data
#######################################################################
        .text
allocate_row_matrix:
	lw $t1, 0($sp)					#$t1 <- matrix height
	lw $t2, 4($sp)					#$t2 <- matrix width
	
	li $v0, 9                       #$v0 <- base address of dynamic array
	mul $t1, $t1, $t2
	sll $a0, $t1, 3					#$a0 <- input length * 2^3 (8 bytes (double))
	syscall

allocate_row_matrix_end:
	sw $v0, 8($sp)

	jr $ra							#Return to calling location
	
#######################################################################
#######################################################################
#	print_row_matrix
#
#	This subprogram has 3 arguments IN and 0 arguments OUT:
#		-	matrix base address
#		-	matrix height
#		-	matrix width
#
#	This subprogram will print a row-major ordered matrix, containing double precision floating points,
#	in a rectangular table (separated by horizontal tab and newline characters).
#	NOTE: r x c matrix will print as r rows (#rows = height) and c columns (#columns = width)
#######################################################################
#       Arguments IN and OUT of subprogram
#   $sp+0   matrix base address  (IN)
#   $sp+4   matrix height  (IN)
#   $sp+8   matrix width  (IN)
#######################################################################
#       Register Usage
#   $t0 Holds matrix base address
#   $t1 Holds matrix height
#   $t2 Holds matrix width
#   $t3 row index
#   $t4 column index
#   $t5 temporary value
#######################################################################
		.data
#######################################################################
		.text
print_row_matrix:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	li $t3, 0	
	
print_outer:
	beq $t3, $t1, print_row_matrix_end
	li $t4, 0

print_inner:
	beq $t4, $t2, print_inner_end

	mul $t5, $t3, $t2
	add $t5, $t5, $t4
	sll $t5, $t5, 3
	add $t5, $t0, $t5
	
	li $v0, 3						#double precision value print (Code in $v0 = 3)
	l.d $f12, 0($t5)				#loads element @index $t5
	syscall
	
    li $v0, 11                  	#print horizontal tab character (ASCII code 9)
    li $a0, 9
    syscall
	
	addi $t4, $t4, 1
	
	b print_inner

print_inner_end:
	addi $t3, $t3, 1
	
    li $v0, 11                  	#print newline character (ASCII code 10)
    li $a0, 10
    syscall	
	
	b print_outer
	
print_row_matrix_end:
	jr $ra							#Return to calling location

#######################################################################
#######################################################################
#   transpose_row_matrix
#
#	This subprogram will take 3 arguments IN:
#		-	matrix A base address
#		-	matrix A height
#		-	matrix A width
#	 and 3 argument OUT:
#		-	matrix B base address
#		-	matrix B height
#		-	matrix B width
#
#	This subprogram will call allocate_row_matrix to allocate a new row-major ordered matrix (B).
#	Using the height of A as width of B and the width of A as height of B. This subprogram
#	will then transpose matrix A, storing tranposed matrix A as new matrix, B.
#	Pseudo-code:
#       public void int[][] transpose(int[][] a){
#           int rowsInA = a.length; 		// same as columns in B
#           int columnsInA = a[0].length; 	// same as rows in B
#           int rowsInB = columnsInA;
#           int columnsInB = rowsInA;
#			int[][] b = allocate_row_matrix(rowsInB, columnsInB);
#           for (int j = 0; j < rowsInB (or height of B); j++){
#               for (int k = 0; k < columnsInB (or width of B); k++){
#                   b[j][k] = a[k][j];
#               }
#           }
#       return b;
#   	}
#######################################################################
#       Arguments IN and OUT of subprogram
#   $sp+0   matrix base address of matrix A (IN)
#   $sp+4   matrix height of matrix A (IN)
#   $sp+8   matrix width of matrix A (IN)
#   $sp+12  matrix base address of matrix B (OUT)
#   $sp+16  matrix height of matrix B (OUT)
#   $sp+20  matrix width of matrix B (OUT)
#######################################################################
#       Register Usage
#   $t0 matrix base address of matrix A
#   $t1 matrix height of matrix A
#   $t2 matrix width of matrix A
#   $t3 matrix base address of matrix B
#   $t4 matrix height of matrix B
#   $t5 matrix width of matrix B
#   $t6 row index
#   $t7 column index
#   $t8 holder
#   $f4|$f5 temporary matrix value
#######################################################################
		.data
#######################################################################
		.text
transpose_row_matrix:
	lw $t0, 0($sp)					#$t0 <- matrix A base address
	lw $t1, 4($sp)					#$t1 <- matrix A height 
	lw $t2, 8($sp)					#$t2 <- matrix A width

transpose_allocate_row_matrix:
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -12				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)	
	sw $t2, 8($sp)	
	
	addi $sp, $sp, -12				#$sp <- $sp - 12 (3 words: 2 IN, 1 OUT)
	sw $t2, 0($sp)					#stack[0] <- matrix B height <- $t2 <- matrix A width (IN)
	sw $t1, 4($sp)					#stack[4] <- matrix B width <- $t1 <- matrix A height (IN)
	
	jal allocate_row_matrix			#goes to subprogram to create matrix B

	lw $t3, 8($sp)					#$t3 <- matrix B base address (OUT)
	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)
	
	lw $t0, 0($sp)					#$t0 <- matrix A base address (restore)
	lw $t1, 4($sp)					#$t1 <- matrix A height (restore)
	lw $t2, 8($sp)					#$t2 <- matrix A width (restore)
	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
	move $t4, $t2					#$t4 <- matrix B height <- $t2 <- matrix A width
	move $t5, $t1					#$t5 <- matrix B width <- $t1 <- matrix A height
	
transpose_row_matrix_loop:
	li $t6, 0	
	
transpose_outer:
	beq $t6, $t4, transpose_row_matrix_end
	li $t7, 0

transpose_inner:
	beq $t7, $t5, transpose_inner_end

	mul $t8, $t2, $t7				#matrix A width
	add $t8, $t8, $t6
	sll $t8, $t8, 3
	add $t8, $t8, $t0
	
	l.d $f12, 0($t8)				#loads element @index $t8 from matrix A
	mov.d $f4, $f12
	
	mul $t8, $t6, $t5				#matrix B width
	add $t8, $t8, $t7
	sll $t8, $t8, 3
	add $t8, $t8, $t3

	s.d $f4, 0($t8)					#store in matrix B
	
	addi $t7, $t7, 1
	
	b transpose_inner

transpose_inner_end:
	addi $t6, $t6, 1	
	
	b transpose_outer

transpose_row_matrix_end:
	sw $t3, 12($sp)					#matrix B base address (OUT)
	sw $t4, 16($sp)					#matrix B height (OUT)
	sw $t5, 20($sp)					#matrix B width (OUT)
	
	jr $ra							#Return to calling location
	
#######################################################################
#######################################################################
#	mul_row_matrix
#
#	This subprogram will take 6 arguments IN:
#		-	matrix A base address
#		-	matrix A height
#		-	matrix A width
#		-	matrix B base address
#		-	matrix B height
#		-	matrix B width
#	 and 3 argument OUT:
#		-	matrix C base address
#		-	matrix C height
#		-	matrix C width
#
#	This subprogram will call allocate_row_matrix with the height of the first matrix (B) 
#	and the width of the second matrix (A) to allocate a new matrix, C. Then  this subprogram
#	will multiply the two matrices together, storing the result in new matrix, C.
#	
#	Pseudo-code:
#       public static int[][] multiply(int[][] b, int[][] a){
#           int rowsInB = b.length;
#           int columnsInB = b[0].length; 	// same as rows in A
#           int columnsInA = a[0].length;
#           int[][] c = new int[rowsInB (or height of B)][columnsInA (or width of A)];
#           for (int i = 0; i < rowsInB (or height of B); i++){
#               for (int j = 0; j < columnsInA (or width of A); j++){
#                   for (int k = 0; k < columnsInB (or width of B); k++){
#                       c[i][j] = c[i][j] + a[i][k] * b[k][j];
#                   }
#               }
#           }
#       return c;
#   	}
#######################################################################
#       Arguments IN and OUT of subprogram
#   $sp+0   matrix base address of matrix A (IN)
#   $sp+4   matrix height of matrix A (IN)
#   $sp+8   matrix width of matrix A (IN)
#   $sp+12  matrix base address of matrix B (IN)
#   $sp+16  matrix height of matrix B (IN)
#   $sp+20  matrix width of matrix B (IN)
#   $sp+24  matrix base address of matrix C (OUT)
#   $sp+28  matrix height of matrix C (OUT)
#   $sp+32  matrix width of matrix C (OUT)
#######################################################################
#       Register Usage
#   $t0 matrix base address of matrix A
#   $t1 matrix height of matrix A - 
#   $t2 matrix width of matrix A
#   $t3 matrix base address of matrix B
#   $t4 matrix height of matrix B
#   $t5 matrix width of matrix B
#   $t6 base address of resulting matrix, C
#   $t7 i
#   $t8 j
#   $t9 k
#######################################################################
		.data
#######################################################################
		.text
mul_row_matrix:
	lw $t0, 0($sp)					#$t0 <- matrix A base address
	lw $t1, 4($sp)					#$t1 <- matrix A height 
	lw $t2, 8($sp)					#$t2 <- matrix A width	
	lw $t3, 12($sp)					#$t3 <- matrix B base address
	lw $t4, 16($sp)					#$t4 <- matrix B height 
	lw $t5, 20($sp)					#$t5 <- matrix B width

mul_allocate_row_matrix:
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -24				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)	
	sw $t2, 8($sp)
	sw $t3, 12($sp)		
	sw $t4, 16($sp)
	sw $t5, 20($sp)	
	
	addi $sp, $sp, -12				#$sp <- $sp - 12 (3 words: 2 IN, 1 OUT)
	sw $t4, 0($sp)					#stack[0] <- matrix C height <- $t4 <- matrix B height (IN)
	sw $t2, 4($sp)					#stack[4] <- matrix C width <- $t2 <- matrix A width (IN)
	
	jal allocate_row_matrix			#goes to subprogram to create matrix B

	lw $t6, 8($sp)					#$t6 <- matrix C base address (OUT)
	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)

	lw $t0, 0($sp)					#$t0 <- matrix A base address (restore)
	lw $t1, 4($sp)					#$t1 <- matrix A height (restore)
	lw $t2, 8($sp)					#$t2 <- matrix A width (restore)	
	lw $t3, 12($sp)					#$t3 <- matrix B base address (restore)
	lw $t4, 16($sp)					#$t4 <- matrix B height (restore)
	lw $t5, 20($sp)					#$t5 <- matrix B width (restore)
	addi $sp, $sp, 24				#$sp <- $sp + 24 (6 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
#matrix C height -> $t4 <- matrix B height
#matrix C width -> $t2 <- matrix A width
	li.d $f10, 0.0					#Initialize Temp = 0
	li $t7, 0						#i
	li $t8, 0						#j
	li $t9, 0						#k

mul_row_matrix_i:	
	beq $t7, $t4, mul_row_matrix_end
	
mul_row_matrix_j:
	beq $t8, $t2, j_end

mul_row_matrix_k:
	beq $t9, $t5, k_end

	mul $t1, $t7, $t5				#matrix B/transpose(A)
	add $t1, $t1, $t9
	sll $t1, $t1, 3
	add $t1, $t1, $t3
	
	l.d $f12, 0($t1)				#loads element @index $f12 from matrix B	
	mov.d $f4, $f12
	
	mul $t1, $t9, $t2				#matrix A
	add $t1, $t1, $t8
	sll $t1, $t1, 3
	add $t1, $t1, $t0
	
	l.d $f12, 0($t1)				#loads element @index $t8 from matrix A	
	mov.d $f6, $f12
	
	mul.d $f8, $f6, $f4
	add.d $f10, $f10, $f8
	
	addi $t9, $t9, 1				#k
	
	b mul_row_matrix_k

k_end:
	mul $t1, $t7, $t2				#matrix C width
	add $t1, $t1, $t8
	sll $t1, $t1, 3
	add $t1, $t1, $t6

	s.d $f10, 0($t1)				#store in matrix C
	
	li.d $f10, 0.0					#Initialize Temp = 0
	li $t9, 0						#k
	addi $t8, $t8, 1				#j
	
	b mul_row_matrix_j

j_end:
	li $t8, 0						#j
	addi $t7, $t7, 1	
	
	b mul_row_matrix_i
	
mul_row_matrix_end:
	sw $t6, 24($sp)					#matrix C base address (OUT)
	sw $t4, 28($sp)					#matrix C height (OUT)
	sw $t2, 32($sp)					#matrix C width (OUT)
	
	jr $ra							#Return to calling location

#######################################################################
#######################################################################