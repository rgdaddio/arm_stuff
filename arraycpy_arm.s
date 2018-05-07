@@@@@@@@;assemble: as --gdwarf-2 arraycpy_arm.s -o arraycpy_arm.o
@@@@@@@@;link: ld -s -o arraycpy_arm arraycpy_arm.o
@@@@@@@@;Using GNU LD and GNU AS
@@@@@@@@;Port from old Openrisc code a simple array copy
@@@@@@@@;ARM comments are '@' and sometimes '#' here we use '@;' and no '#' for comments
@@@@@@@@;'#' hash is reserved for immediate values in instructions in this code


.section                .data

        .type myStr,%object             		@;define an array that hold a string
        .size myStr, 12                 		@;myStr[] = {"hello world"}
myStr:
        .string "hello world"


testgreeting:
        .string "Array copy:\n"
        glen = . - testgreeting


resultstr:
        .string " is in first array\n"
        rlen = . - resultstr


resultcpy:
        .string " is copied to second array\n"
        clen = . - resultcpy

        
.comm myArr2, 16, 1             			@;array with 1 char alignment



.section                .text
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
@; _start()
@; uses data section strings
@; call string_len and lexit
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;	
.global _start
.type _start,%function
_start:
                        mov r0, #1                      @;place stdout fd 1 in r0
                        ldr r1, =testgreeting           @;place address of myStr in r1
                        ldr r2, =glen                   @;place address of len in r2
                        mov r7, #4                      @;put write syscall 4 write in r7
                        @Call write syscall@
                        swi #0                          @;sw interrupt

                        mov r0, #1
			ldr r4, =myStr
                        mov r1, r4
                        mov r2, #0xC
                        mov r7, #4
                        swi #0                          @;print the test string

                        mov r0, #1                      @;place stdout fd 1 in r0
                        ldr r1, =resultstr           	@;place address of myStr in r1
                        ldr r2, =rlen                   @;place address of len in r2
                        mov r7, #4                      @;put write syscall 4 write in r7
                        @Call write syscall@
                        swi #0                          @;sw interrupt
			

			bl arraycpy
			mov r0, #1
			mov r1, r9
			mov r2, #0xc
			mov r7, #4
			swi #0
			
			mov r0, #1
			ldr r1, =resultcpy           	@;place address of myStr in r1
                        ldr r2, =clen                   @;place address of len in r2
                        mov r7, #4                      @;put write syscall 4 write in r7
                        @Call write syscall@
                        swi #0                          @;sw interrupt


			b lexit

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
@; arraycpy()
@; original array in r4
@; returns r6 with ptr to copy
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;	
.global arraycpy 
.type arraycpy,%function
arraycpy:
			mov r11, #0			@;setup counter
			ldr r6, =myArr2                 @;base add into r7
			mov r9, r6
not_done:
			ldrb r8, [r4], #1		@;get byte from r4
			strb r8, [r6], #1
			add r11, #1			@;incr counter
			cmp r11, r2			@;check array len
			blt not_done
			bx lr	

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
@; lexit()
@; no arg
@; returns to os
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
.global lexit
                .type lexit,%function
lexit:
                        mov r7, #1                      @;exit sys call 1
                        swi #0                          @;sw interrupt

