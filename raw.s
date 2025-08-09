.section .bss
.lcomm randbuf, 32
.section .text
.global _start

_start:
	ldr r0, =randbuf
	mov r1, #32
	mov r2, #0
	mov r7, #384
	svc #0
	cmp r0, #32
	bne error_exit
	mov r0, #1
	ldr r1, =randbuf
	mov r2, #32
	mov r7, #4
	svc #0
	mov r0, #0
	mov r7, #1
	svc #0

error_exit:
	mov r0, #1
	mov r7, #1
	svc #0
