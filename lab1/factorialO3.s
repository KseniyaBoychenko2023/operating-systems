	.file	"factorial.c"
	.text
	.p2align 4,,15
	.globl	_Z9factoriali
	.def	_Z9factoriali;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9factoriali
_Z9factoriali:
.LFB30:
	.seh_endprologue
	movl	$1, %eax
	cmpl	$1, %ecx
	jle	.L1
	leal	-2(%rcx), %eax
	leal	-1(%rcx), %r8d
	cmpl	$6, %eax
	jbe	.L8
	movd	%ecx, %xmm5
	movl	%r8d, %edx
	xorl	%eax, %eax
	movdqa	.LC0(%rip), %xmm0
	pshufd	$0, %xmm5, %xmm2
	movdqa	.LC2(%rip), %xmm4
	paddd	.LC1(%rip), %xmm2
	shrl	$2, %edx
	.p2align 4,,10
.L5:
	movdqa	%xmm2, %xmm3
	movdqa	%xmm2, %xmm1
	addl	$1, %eax
	pmuludq	%xmm0, %xmm3
	cmpl	%edx, %eax
	paddd	%xmm4, %xmm2
	psrlq	$32, %xmm0
	psrlq	$32, %xmm1
	pmuludq	%xmm0, %xmm1
	pshufd	$8, %xmm3, %xmm0
	pshufd	$8, %xmm1, %xmm1
	punpckldq	%xmm1, %xmm0
	jne	.L5
	movdqa	%xmm0, %xmm2
	movdqa	%xmm0, %xmm1
	movl	%r8d, %edx
	psrldq	$8, %xmm2
	andl	$-4, %edx
	pmuludq	%xmm2, %xmm1
	subl	%edx, %ecx
	cmpl	%edx, %r8d
	psrlq	$32, %xmm0
	psrlq	$32, %xmm2
	pmuludq	%xmm2, %xmm0
	pshufd	$8, %xmm1, %xmm1
	pshufd	$8, %xmm0, %xmm0
	punpckldq	%xmm0, %xmm1
	movdqa	%xmm1, %xmm0
	psrldq	$4, %xmm1
	pmuludq	%xmm1, %xmm0
	movd	%xmm0, %eax
	je	.L1
	leal	-1(%rcx), %r8d
.L3:
	imull	%ecx, %eax
	cmpl	$1, %r8d
	je	.L1
	leal	-2(%rcx), %edx
	imull	%r8d, %eax
	cmpl	$1, %edx
	je	.L1
	leal	-3(%rcx), %r8d
	imull	%edx, %eax
	cmpl	$1, %r8d
	je	.L1
	leal	-4(%rcx), %edx
	imull	%r8d, %eax
	cmpl	$1, %edx
	je	.L1
	leal	-5(%rcx), %r8d
	imull	%edx, %eax
	cmpl	$1, %r8d
	je	.L1
	imull	%r8d, %eax
	subl	$6, %ecx
	imull	%ecx, %eax
.L1:
	ret
.L8:
	movl	$1, %eax
	jmp	.L3
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC3:
	.ascii "%d\0"
	.section	.text.startup,"x"
	.p2align 4,,15
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
.LFB31:
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	call	__main
	movl	$5040, %edx
	leaq	.LC3(%rip), %rcx
	call	printf
	xorl	%eax, %eax
	addq	$40, %rsp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 16
.LC0:
	.long	1
	.long	1
	.long	1
	.long	1
	.align 16
.LC1:
	.long	0
	.long	-1
	.long	-2
	.long	-3
	.align 16
.LC2:
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0"
	.def	printf;	.scl	2;	.type	32;	.endef
