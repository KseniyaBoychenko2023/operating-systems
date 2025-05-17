	.file	"factorial.c"
	.text
	.globl	_Z9factoriali
	.def	_Z9factoriali;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9factoriali
_Z9factoriali:
.LFB30:
	.seh_endprologue
	movl	$1, %eax
.L3:
	cmpl	$1, %ecx
	jle	.L4
	imull	%ecx, %eax
	decl	%ecx
	jmp	.L3
.L4:
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC0:
	.ascii "%d\0"
	.section	.text.startup,"x"
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
.LFB31:
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	call	__main
	movl	$7, %ecx
	call	_Z9factoriali
	leaq	.LC0(%rip), %rcx
	movl	%eax, %edx
	call	printf
	xorl	%eax, %eax
	addq	$40, %rsp
	ret
	.seh_endproc
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0"
	.def	printf;	.scl	2;	.type	32;	.endef
