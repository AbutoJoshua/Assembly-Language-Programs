


.global main
.func main

main: 
	//BL  _prompt             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scanf procedure with return
	MOV R3, R0

	BL _getchar				@branches to _getcar method to get the operation sign
	MOV R4, R0				@moves it from R0 to store it in R4

	BL _scanf				@branches to _scanf to obtain the third operand
	MOV R5, R0				@moves the third operand from R0 to R5

	BL _checkAdd			@branches to start comparing the operation signs

	BL  _printf             @ branch to print procedure with return
    B  _exit               @ branch to exit procedure with no return





_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return

_checkAdd:
	CMP R4, #'+'			@ comparing operand to see if it is a +
	BEQ _add				@ branches to print out sum of the numbers
	BNE _checkSub			@ branches to check if it is a minus


_checkSub:
	CMP R4, #'-'			@ comparing operand to see if it is a -
	BEQ _sub				@ branches to print out differnce of the numbers
	BNE _checkProduct			@ branches to check if it is a multiplication

_checkProduct:
	CMP R4, #'*'			@ comparing operand to see if it is a *
	BEQ _prod				@ branches to print out product of the numbers
	BNE _checkLessThan		@ branches to check if it is a less than comparison


_checkLessThan:
	CMP R4, #'<'			@ comparing operand to see if it is a <
	BEQ _less				@ branches to print out the min of the numbers

_add:
	PUSH {LR}               @ push LR to stack
	ADD R1, R3, R5			@ adds R3 to R5 and stores in R1
	LDR R0, =printf_str     @ R0 contains formatted string address
	BL printf               @ call printf
	POP {PC}                @ pop LR from stack and return

_sub:
	PUSH {LR}               @ push LR to stack
	SUB R1, R3, R5			@ subtracts R3 from R5 and stores in R1
	LDR R0, =printf_str     @ R0 contains formatted string address
	BL printf               @ call printf
	POP {PC}                @ pop LR from stack and return

_prod:
	PUSH {LR}               @ push LR to stack
	MUL R1, R3, R5			@ multiplies R3 to R5 and stores in R1
	LDR R0, =printf_str     @ R0 contains formatted string address
	BL printf               @ call printf
	POP {PC}                @ pop LR from stack and return

_less:
	PUSH {LR}               @ push LR to stack
	CMP R3, R5				@ compares R3 with R5
	BLT _setMin_R3			@ braches if R3 is less than R5
	BGT _setMin_R5			@ branches if R5 is less than R3
	POP {PC}                @ pop LR from stack and return

_setMin_R3:
	PUSH {LR}				@ pushes Link Register to stack
	MOV R1, R3				@ moves R3 to R1 because it is smallest
	LDR R0, =printf_str		@ R0 contains formatted string address
	BL printf               @ call printf
	POP {PC}                @ pop LR from stack and return

_setMin_R5:
	PUSH {LR}				@ pushes Link Register to stack
	MOV R1, R5				@ moves R5 to R1 because it is smallest
	LDR R0, =printf_str		@ R0 contains formatted string address
	BL printf               @ call printf
	POP {PC}                @ pop LR from stack and return



_exit:
	MOV R7, #1
	SWI 0



.data
format_str:     .asciz      "%d"
format_char:    .ascii      " "
printf_str:     .asciz      "%d\n\n"


