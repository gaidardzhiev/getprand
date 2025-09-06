// Copyright (C) 2025 Ivan Gaydardzhiev
// Licensed under the GPL-3.0-only

.section .data
c:
	.ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789():;!+-$#@/*={}|"
c_len = . - c
.section .bss
.lcomm outbuf, 33
.lcomm randbuf, 32
.section .text
.global _start

_start:
	ldr r0, =randbuf
	mov r1, #32
	mov r2, #0
	mov r7, #384
	svc #0
	cmp r0, #0
	blt error_exit
	cmp r0, #32
	bne error_exit
	ldr r3, =c
	mov r4, #c_len
	ldr r5, =outbuf
	ldr r6, =randbuf
	mov r1, #0

convert_loop:
	ldrb r2, [r6, r1]

mod_loop:
	cmp r2, r4
	blt mod_done
	sub r2, r2, r4
	b mod_loop

mod_done:
	add r2, r3, r2
	ldrb r2, [r2]
	strb r2, [r5, r1]
	add r1, r1, #1
	cmp r1, #32
	blt convert_loop
	mov r2, #0
	strb r2, [r5, r1]
	mov r2, #10
	strb r2, [r5, #32]
	mov r0, #1
	ldr r1, =outbuf
	mov r2, #34
	mov r7, #4
	svc #0
	mov r0, #0
	mov r7, #1
	svc #0

error_exit:
	mov r0, #1
	mov r7, #1
	svc #0
