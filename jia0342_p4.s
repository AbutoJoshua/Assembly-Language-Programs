
/*****************************************
* Program 4
* Joshua Abuto
* To compile: gcc -o p4 jia0342_p4.s 
* ./p4
******************************************/

.global main
.func main

main:
	BL _scanf   //prompt input
	MOV R4, R0  // R4 stores n

	BL _scanf   //prompt input
	MOV R5, R0	// R5 stores d

	MOV R1, R4  //R1 will now store n
	MOV R2, R5  //R2 will now store d

	//Calling methods to compute the operation
	BL _printfOperation    
	BL _divide      
	BL _printfResult

	BL main			//loop

//	BL _exit       //Commented out to allow for the loop

_scanf:
	PUSH {LR}               @ store LR since scanf call overwrites
	SUB SP, SP, #4          @ make room on stack
	LDR R0, =format_str     @ R0 contains address of format string
	MOV R1, SP              @ move SP to R1 to store entry on stack

	BL scanf                @ call scanf
	LDR R0, [SP]            @ load value at SP into R1
	ADD SP, SP, #4          @ restore the stack pointer
	POP {PC}                @ return

_divide:
	PUSH {LR}               @ store LR since scanf call overwrites
	VMOV S0, R4             @ move the numerator to floating point register
	VMOV S1, R5             @ move the denominator to floating point register

	VCVT.F32.U32 S0, S0     @ convert unsigned bit representation to single float
	VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float

	VDIV.F32 S2, S0, S1     @ compute S2 = S0 * S
	VCVT.F64.F32 D4, S2     @ convert the result to double precision for printing
	VMOV R1, R2, D4         @ split the double VFP register into two ARM registers

	POP {PC}                @ return

_printfResult:
	PUSH {LR}                       @ store the return address
	LDR R0, =printf_str_result      @ R0 contains formatted string address
	BL printf                       @ call printf
	POP {PC}                        @ restore the stack pointer and return 

_printfOperation:
	PUSH {LR}               @ store the return address
	LDR R0, =printf_str     @ R0 contains formatted string address
	BL printf               @ call printf
	POP {PC}                @ restore the stack pointer and return


_exit:
	MOV R7, #1
	SWI 0


.data

format_str:     	.asciz      "%d"
printf_str:			.asciz		"%d / %d = "
printf_str_result:	.asciz		"%f\n\n"
