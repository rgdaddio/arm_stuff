@@@@@@@@;assemble: as -o stringlen.o stringlen.S                                                                                
@@@@@@@@;link: ld -s -o stringlen stringlen.o                                                                                   
@@@@@@@@;Using GNU LD and GNU AS                                                                                                
@@@@@@@@;Port from old Openrisc code runs on ARMs like R-Pi
@@@@@@@@;ARM comments are '@' and sometimes '#' here we use '@;' and no '#' for comments
@@@@@@@@;'#' hash is reserved for immediate values in instructions in this code
        
	.arch armv6

        .data
	
testgreeting:
        .string "ARM swap register:\n"
        glen = . - testgreeting

	.comm myArr2, 16, 1             	@;array with 1 char alignment

	.text

_start:
		mov r0, #1                      @;place stdout fd 1 in r0
		ldr r1, =testgreeting           @;place address of myStr in r1
		ldr r2, =glen                   @;place address of len in r2
		mov r7, #4                      @;put write syscall 4 write in r7 per EABI

		ldr r8, =myArr2
		mov r9, r8			@;save the buffer address
		mov r5, #7			@;place literal 7 in r5
		mov r6, #9			@;place literal 9 in r6

		strb r5, [r8], #1
		strb r6, [r8], #1
		mov r0, #1
		mov r1, r8
		mov r2, #0x3
		
