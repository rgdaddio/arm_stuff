@@@@@@@@;assemble: as -o stringlen.o stringlen.S                                                                                
@@@@@@@@;link: ld -s -o stringlen stringlen.o                                                                                   
@@@@@@@@;Using GNU LD and GNU AS                                                                                                
@@@@@@@@;Port from old Openrisc code runs on ARMs like R-Pi
@@@@@@@@;ARM comments are '@' and sometimes '#' here we use @; and avoid # 
        
				.arch armv6

                                .data
testgreeting:
             	.string "Basic string length:\n"
		glen = . - testgreeting

basicteststr:
             	.string "mytest\0"
		len = .- basicteststr

resultstr:
          	.string " is the length of mytest\n"
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
		mov r3, #0                      @;zero out r3
		ldr r1, =testgreeting           @;place address of myStr in r1
		ldr r2, =glen                   @;place address of len in r2
		mov r7, #4                      @;put write syscall 4 write in r7
	        
		@@@@@@@@;Call write syscall@@@@@@@@;
	        swi #0                          @;sw interrupt
        	
        	ldr r4,	=basicteststr           @;The memory address of str in r4
        	bl string_len

		mov r0, #1			@;same steps as above for write syscall
		mov r1, r4 			@;r4 has been modified in string_len call
		mov r2, #1
		mov r7, #4
		swi #0
		
		ldr r1, =resultstr		@;reload r1 with address fo resultstr
		ldr r2, =rlen			@;same steps as above
		mov r7, #4
		swi #0
	
		#mov r7, #1
		#swi #0
		b lexit
	

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
@; string_len()
@; string for len in r4
@; returns r4 memory with length 
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
.global string_len
	.type string_len,%function
string_len:
        	mov r12, r4                     @;jpreserve r4
		mov r11, #0                     @;set up counter

not_done:
		ldrb r9,[r12],#1		@;copy byte into r17
		teq r9, #0			@;test for null term
		beq done_loop			
		add r11, #1			@;increment counter
		b not_done
done_loop:
		add r11, #0x30			@;make it ascii
		str r11, [r4]			@;store r11 in memory of r4
        	bx lr				@;return to caller 


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
@; lexit()
@; no arg
@; returns to os
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
.global lexit
        .type lexit,%function
lexit:
                mov r7, #1			@exit sys call 1
                swi #0				@sw interrupt

