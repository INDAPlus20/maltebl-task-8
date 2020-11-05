##
# Pop value from application stack.
# PARAM: Registry which to save value from.
##
.macro	PUSH (%reg)
	add	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

##
# Pop value from application stack.
# PARAM: Registry which to save value to.
##
.macro	POP (%reg)
	lw	%reg,0($sp)             
	addi	$sp,$sp,4
.end_macro

### Data Declaration Section ###

.data
MULTI:     .asciiz "\n Enter two numbers to multiply \n"
FACTORIAL:     .asciiz "\n Enter a number to take the factorial of \n"

### Executable Code Section ###
.text
.globl	multiply                  # define label main as externally accessable 
.globl	faculty


#execute code
main:
#multiplication
li	$v0,4
la	$a0,MULTI
syscall

li	$v0,5		#load a and store to a0
syscall
move	$a0,$v0		

li	$v0,5		#load b and store to a1
syscall
move	$a1,$v0

jal	multiply
nop

move	$a0,$v0		#print multiplication result
li	$v0,1
syscall

#factorial
li	$v0,4
la	$a0,FACTORIAL
syscall

li	$v0,5		#load n and store to a0
syscall			
move	$a0,$v0

jal	faculty
nop

move	$a0,$v0		#print factorial result
li	$v0,1
syscall

li	$v0,10		
syscall			#terminate program


#multiply two numbers
multiply:
PUSH	$ra		#save ra for possible use as inner funciton

li	$t0,0		#set i then sum to 0
li	$v0,0		

ble	$a0,$t0,mult_end#Check condition at least once, return if !(i<a)
nop

mult_loop:
add	$v0,$v0,$a1	#increment sum by b
addi	$t0,$t0,1		#increment loop
bne	$t0,$a0,mult_loop	#check loop conditions
nop

mult_end:
POP	$ra		#load original ra

jr	$ra			#return
nop

#get factorial		#9 and above is sloooooow
faculty:
PUSH	$ra		#save ra, s0&1 for possible use as inner funciton
PUSH	$s0
PUSH	$s1

li	$s0,1		#set i to 1
li	$s1,1		#set fac to 1

move	$s0,$a0		#set i to n
ble	$s0,1,fac_end	#Check condition at least once, return if !(i>1)
nop

fac_loop:
move	$a0,$s1		#for performance's sake a0 and a1 should be flipped, but that's not how it is originaly
move	$a1,$s0

jal	multiply	#multiply and put result in v0
nop

move	$s1, $v0	#put result in s1
sub	$s0,$s0,1		
bne	$s0,1,fac_loop	#loop if i is not 1
nop

fac_end:
move	$v0,$s1

POP	$s1		#load original ra & s0&1
POP	$s0
POP	$ra
nop
jr	$ra
nop
