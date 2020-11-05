#line break macro to make console output look nicer
.macro	LN_BRK (%original_v0)
	move 	$a1, $a0		
    	li	$v0, 4
    	la	$a0,ln_brk
    	syscall
    	li	$v0, %original_v0
    	move	$a0,$a1
.end_macro

### Data Declaration Section ###

.data

primes:		.space  1000            # reserves a block of 1000 bytes in application memory
err_msg:	.asciiz "Invalid input! Expected integer n, where 1 < n < 1001.\n"
ln_brk:		.asciiz	"\n"

### Executable Code Section ###

.text

main:
    # get input
    li		$v0,5                   # set system call code to "read integer"
    syscall                         # read integer from standard input stream to $v0

    # validate input
    li 	    	$t0,1001                # $t0 = 1001
    slt	    	$t1,$v0,$t0		        # $t1 = input < 1001
    beq     	$t1,$zero,invalid_input # if !(input < 1001), jump to invalid_input
    nop
    
    li	    	$t0,1                   # $t0 = 1
    slt		$t1,$t0,$v0		        # $t1 = 1 < input
    beq		$t1,$zero,invalid_input # if !(1 < input), jump to invalid_input
    nop	
    
    # initialise primes array
    la	    	$t0,primes              # $s1 = address of the first element in the array
    move	$t1,$v0
    li 	   	$t2,0
    li	    	$t3,1
init_loop:
    sb	    	$t3, ($t0)              # primes[i] = 1
    addi    	$t0, $t0, 1             # increment pointer
    addi    	$t2, $t2, 1             # increment counter
    bne	    	$t2, $t1, init_loop     # loop if counter <= $t1
    nop
    
    ### Continue implementation of Sieve of Eratosthenes ###
la		$t0,primes		#t0 current adress, t1 = current number, t2 = highest num
li		$t1,1
move		$t2,$v0			
sieve_outer:
    addi	$t0,$t0,1		#increment counter & pointer
    addi	$t1,$t1,1
 
    lb		$t3,($t0)		#check if this number was not a prime, go to next
    nop
    beqz	$t3,sieve_outer		
    nop

    add		$t4,$t0,$t1		#go t1 steps from t1
    add		$t5,$t1,$t1
    sieve_inner:	
    	sb		$0,($t4)	#set value to zero => is_prime=false
    	add		$t4,$t4,$t1
    	add		$t5,$t5,$t1
    	ble		$t5,$t2,sieve_inner	#loop if not greater than highest num
    	nop
    mul		$t6,$t1,$t1
    blt		$t6,$t2,sieve_outer	#loop if current number < sqrt(highest_num)
    nop
    ### Print nicely to output stream ###
    la		$t0,primes
    li		$a0,1			#set current number to 1
    li		$v0,1			#handle 1 initially
    syscall
    LN_BRK	1
    print_loop:
    	add		$t0,$t0,1	#increment current_num&pointer
    	add		$a0,$a0,1
    	bgt		$a0,$t2,exit	#exit if current_num>highest_num (t2)
    	nop
    	
    	lb		$t1,($t0)	
    	nop
    	
    	beqz		$t1,print_loop	#if not_prime go to next
    	nop
    	
    	syscall				#otherwise print!
    	LN_BRK		1

    	
    j	print_loop
    nop
    
    # exit program
    exit:
    j       	exit_program
    nop

invalid_input:
    # print error message
    li      	$v0, 4                  # set system call code "print string"
    la      	$a0, err_msg            # load address of string err_msg into the system call argument registry
    syscall                         # print the message to standard output stream

exit_program:
    # exit program
    li 		$v0, 10                      # set system call code to "terminate program"
    syscall                         # exit program
