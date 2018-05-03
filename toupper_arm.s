@@@@@@@@;assemble: as -o stringlen.o stringlen.S
@@@@@@@@;link: ld -s -o stringlen stringlen.o
@@@@@@@@;Using GNU LD and GNU AS
@@@@@@@@;Port from old Openrisc code super dumb toupper
@@@@@@@@;ARM comments are '@' and sometimes '#' here we use '@;' and no '#' for comments
@@@@@@@@;'#' hash is reserved for immediate values in instructions in this code



					.arch armv6

	                                .data
testgreeting:
	                .string "Basic toupper:\n"
	                glen = . - testgreeting

basicteststr:
	                .string "@Rte|st\n"
	                len = .- basicteststr

resultstr:
	                .string " is the upper version\n"
	                rlen = . - resultstr



	                               .text
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
@; _start()
@; uses data section strings
@; call string_len and lexit
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;	
	                .global _start                  @;set up a start routine
	                .type _start, %function

_start:
        		mov r0, #1                      @;place stdout fd 1 in r0
	                ldr r1, =testgreeting           @;place address of myStr in r1
	                ldr r2, =glen                   @;place address of len in r2
	                mov r7, #4                      @;put write syscall 4 write in r7
	                @Call write syscall@
	                swi #0                          @;sw interrupt

			mov r0, #1
			ldr r4, =basicteststr           @;The memory address of str in r4
			mov r1, r4
			ldr r2, =len
			mov r7, #4
			swi #0				@;print the test string

			ldr r4, =basicteststr
			
			bl to_upper                     @;upperize the test string
			
			mov r0, #1	
			mov r1, r4
                        ldr r2, =len
                        mov r7, #4
                        swi #0				@;print upperized version
 

			mov r0, #1
			ldr r1, =resultstr		@;reload r1 with address fo resultstr
			ldr r2, =rlen			@;same steps as above
			mov r7, #4
			swi #0

			b lexit



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
@; to_upper()
@; string for len in r4
@; returns r4 with upper case letters
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
.global to_upper
	.type to_upper,%function
to_upper:

			mov r12, r4                     @;preserve r4
top_of_loop:
			ldrb r9,[r12],#1		@;copy byte into r9
			cmp r9, #0xA			@;check for \n
			beq range_exit
			mov r6, #0x61
			cmp r9, r6			@;check lower bound of lower case r9<r6
			blt top_of_loop
                        mov r6, #0x7a
			cmp r9, r6			@;check upper bound of lower case r9>r6
			bgt top_of_loop

			sub r9, r9, #0x20		@;make it upper case
			sub r7, r12, #1
			strb r9, [r7]
			b top_of_loop

range_exit:	
			bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
@; string_len()
@;string for len in r4
@;returns r4 memory with length
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
.global lexit
	        .type lexit,%function
lexit:
	                mov r7, #1			@;exit sys call 1
	                swi #0				@;sw interrupt
	
