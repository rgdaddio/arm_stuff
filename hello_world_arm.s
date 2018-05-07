@@@@@@@@;as --gdwarf-2 hello_world_arm.s -o hello_world_arm.o
@@@@@@@@;ld -s -o hello_world hello_world.o
@@@@@@@@;Using GNU LD and GNU AS
@@@@@@@@;Port from old Openrisc code the old hello world standby 
@@@@@@@@;ARM comments are '@' and sometimes '#' here we use '@;' and no '#' for comments
@@@@@@@@;'#' hash is reserved for immediate values in instructions in this code

	
	.arch armv6
	
	.data

myStr:
	.string "hello arm new world!!\n" @;basic string data

	len = . - myStr                 @;get the length via intrinsic

	.text

	.global _start                  ;@set up a start routine
	.type _start, %function

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
@; _start()
@; uses data section strings
@; 
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;	
_start:
	mov r0, #1                      @;place stdout fd 1 in r0
	mov r3, #0                      @;zero out r3
	ldr r1, =myStr                  @;place address of myStr in r1
	ldr r2, =len                    @;place address of len in r2
	mov r7, #4                      @;put write syscall 4 write in r7
	@;Call write syscall;@
	swi #0                          @;sw interrupt
	@;Call exit syscall;@
	mov r7,#1                       @;put write syscall 1 exit in r7
	swi #0                          @;sw interrupt

