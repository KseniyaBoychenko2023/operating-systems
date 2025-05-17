# ������������ ��� � ������������ ������� ������
	.file	"factorial.c" # ��� ��������� �����
	.text # ������ ������ ����
	# ������� factorial(int n)
	.globl	factorial
	.def	factorial;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial # ������ ������� � ���������� SEH (Windows ����������)
factorial:
	# ������ �������
	pushq	%rbx # ��������� � ���� ������� rbx
	.seh_pushreg	%rbx # ����������� SEH � ���������� ��������
	subq	$32, %rsp # �������� 32 ����� �� �����
	.seh_stackalloc	32 # ����������� SEH � ��������� �����
	.seh_endprologue # ����� ������� SEH
	movl	%ecx, %ebx # ��������� �������� n (�� RCX) � EBX
	movl	$1, %eax # EAX = 1 (�������� �� ��������� ��� ��������)
	cmpl	$1, %ecx # ���������� n � 1
	jle	.L1 # ���� n <= 1, ��������� � L1
	# ����������� �����
	leal	-1(%rcx), %ecx # ��������� n �� 1 (n-1)
	call	factorial # ����������� ����� factorial(n-1)
	imull	%ebx, %eax # �������� ��������� (EAX) �� �������� n (EBX)
.L1: 
	addq	$32, %rsp # ����������� ����
	popq	%rbx # ��������������� RBX
	ret # ������� �� �������
	.seh_endproc # ����� ������� ��� SEH
	# ������� main()
	.def	__main;	.scl	2;	.type	32;	.endef
	# ������ read-only ������
	.section .rdata,"dr"
.LC0:
	.ascii "%d\0" # ������ ������� ��� printf
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main # ������ main � ���������� SEH
main:
	subq	$40, %rsp # �������� 40 ���� �� �����
	.seh_stackalloc	40 # ����������� SEH
	.seh_endprologue # ����� �������
	call	__main # ������������� ����� ���������� 
	# ����� factorial(7)
	movl	$7, %ecx # �������� �������� n = 7 ����� ECX
	call	factorial # �������� factorial(7)
	# ����� ����������
	movl	%eax, %edx # ��������� (EAX) -> ������ �������� printf (EDX)
	leaq	.LC0(%rip), %rcx # ������ ������� "%d" (RCX)
	call	printf # ����� printf
	# ���������� ���������
	movl	$0, %eax # ���������� 0
	addq	$40, %rsp # ��������������� ����
	ret # ����� �� main
	.seh_endproc # ����� ������� ��� SEH
	# �������������� ����������
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0"
	.def	printf;	.scl	2;	.type	32;	.endef
