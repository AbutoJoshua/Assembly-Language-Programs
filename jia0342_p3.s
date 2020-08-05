/******************************************************************************
* @file Program 3 - jia0342.s
* @author Joshua Abuto 1001530342
******************************************************************************/

.global main

.func main

main:
	BL _scanf						@Takes input of n
	MOV R4, R0						@Move n to R4
	
	BL _scanf						@Take input of m
	MOV R5, R0						@Move m to R5
	PUSH {R4}						@Push R4 to stack
	PUSH {R5}						@Push R5 to stack
	
	BL _count_partitions
	POP {R5}
	POP {R4}
	MOV R1, R0
	MOV R2, R4
	MOV R3, R5

	BL _printf
	BL _exit


_count_partitions:
	PUSH {LR}						@store the return address
	CMP R4, #0						@ compare the input argument to 0
	MOVEQ R0, #1					@ set return value to 1 if equal
	POPEQ {PC}						@ restore stack pointer and return if equal

	CMP R4, #0						@ compare the input argument to 0
	MOVLT R0, #0					
	POPLT {PC}
	CMP R5, #0
	MOVEQ R0, #0
	POPEQ {PC}						@ restore stack pointer and return if equal
	PUSH {R4}
	PUSH {R5}
	SUB R4, R4, R5
	BL _count_partitions

	POP {R5}
	POP {R4}						@Restore register value
	MOV R1, R0						@Pass n to factorial procedure
	PUSH {R1}						@Pushes the first operation to the stack in R1
	SUB R5, R5, #1					@Decrement the input argument

	BL _count_partitions
	POP {R1}						@ restore input argument
	ADD R0, R0, R1					@Output of the second operations stored in R0 and then added to first one
	POP {PC}						@ restore the stack pointer and return


_scanf:
	PUSH {LR}						@ store LR since scanf call overwrites
	SUB SP, SP, #4					@ make room on stack
	LDR R0, =format_str				@ R0 contains address of format string
	MOV R1, SP						@ move SP to R1 to store entry on stack
	BL scanf						@ call scanf
	LDR R0, [SP]					@ load value at SP into R1
	ADD SP, SP, #4					@ restore the stack pointer
	POP {PC}						@ return

_printf:
	PUSH {LR}						@ store the return address
	LDR R0, =printf_str				@ R0 contains formatted string address
	BL printf						@ call printf
	POP {PC}						@ restore the stack pointer and return

_exit:
	MOV R7, #1
	SWI 0


.data

format_str:     	.asciz      "%d"
printf_str:			.asciz		"There are %d partitions of %d using integers up to %d\n"
