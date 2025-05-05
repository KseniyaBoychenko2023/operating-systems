<h1 align="center">Лабораторные работы по курсу "Операционные системы"</h1>

|__Автор:__ | __Бойченко Ксения Романовна__ |
|-----------|-------------------------------|
|__Группа:__|          __2272-ДБ__          |

***

&nbsp;

<h2>Лабораторная работа №1.</h2> 

<h3 align="center"> Ход работы: </h3>

&nbsp;

1. Исследование компилятора gcc, язык ассемблера. Связь процесса и операционной системы. Makefile, git.

   &nbsp;

   * __Шаг 1.__ Нужно написать программу на С++, странслировать его в Assembler с разными опциями оптимизации.
    
     > g++ -S -O[0123s] -o <>.s <>.cpp

     &nbsp;

     **Программа [fib.cpp](fib.cpp), которая выводит последовательность из n чисел Фибоначчи:**
      ```cpp
      #include <iostream>

      using namespace std;

      void printFibonacci(int n) {
         unsigned long long a = 1, b = 1;
         if (n >= 1) cout << a << " ";
         if (n >= 2) cout << b << " ";

         for (int i = 3; i <= n; ++i) {
             unsigned long long c = a + b;
             cout << c << " ";
             a = b;
             b = c;
         }
      }

      int main() {
         int n;
         cin >> n;
         if (n <= 0) {
             cout << "Error: Enter a positive integer" << endl;
             return 1;
         }
         printFibonacci(n);
         cout << endl;
         return 0;
      }
      ```

      &nbsp;

      Транслирую программу в Assembler с разными опциями оптимизации помощью команд:
        + g++ -S -O0 -o fibO0.s fib.cpp
        + g++ -S -O1 -o fibO1.s fib.cpp
        + g++ -S -O2 -o fibO2.s fib.cpp
        + g++ -S -O3 -o fibO3.s fib.cpp
        + g++ -S -Os -o fibOs.s fib.cpp
     

      &nbsp;

   * __Шаг 2.__ Разобраться с одним из вариантов [оптимизации] ассемблерной программой (добавить комментарии в сгенерированный ассемблерный код) - найти циклы, переменные и т.п.

      &nbsp;

      **Ассемблерная программа [fibO3.s](fibO3.s) с уровнем оптимизации 3:**
     
      ```s
         .file	"fib.cpp"
	      .text
	      .p2align 4,,15
	      .def	__tcf_0;	.scl	3;	.type	32;	.endef
	      .seh_proc	__tcf_0
      __tcf_0:
      .LFB2085:
	      .seh_endprologue
	      leaq	_ZStL8__ioinit(%rip), %rcx
	      jmp	_ZNSt8ios_base4InitD1Ev
	      .seh_endproc
	      .section .rdata,"dr"
      .LC0:
	      .ascii " \0"
	      .text
	      .p2align 4,,15
	      .globl	_Z14printFibonaccii
	      .def	_Z14printFibonaccii;	.scl	2;	.type	32;	.endef
	      .seh_proc	_Z14printFibonaccii
      _Z14printFibonaccii:
      .LFB1594:
	      pushq	%r13
	      .seh_pushreg	%r13
	      pushq	%r12
	      .seh_pushreg	%r12
	      pushq	%rbp
	      .seh_pushreg	%rbp
	      pushq	%rdi
	      .seh_pushreg	%rdi
	      pushq	%rsi
	      .seh_pushreg	%rsi
	      pushq	%rbx
	      .seh_pushreg	%rbx
	      subq	$40, %rsp
	      .seh_stackalloc	40
	      .seh_endprologue
	      testl	%ecx, %ecx
	      movl	%ecx, %ebp
	      jg	.L11
      .L5:
	      cmpl	$2, %ebp
	      jle	.L3
	      movq	.refptr._ZSt4cout(%rip), %r13
	      addl	$1, %ebp
	      movl	$3, %esi
	      movl	$1, %ebx
	      leaq	.LC0(%rip), %r12
	      movl	$1, %eax
	      .p2align 4,,10
      .L8:
	      leaq	(%rax,%rbx), %rdi
	      movq	%r13, %rcx
	      addl	$1, %esi
	      movq	%rdi, %rdx
	      call	_ZNSo9_M_insertIyEERSoT_
	      movl	$1, %r8d
	      movq	%r12, %rdx
	      movq	%rax, %rcx
	      call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_x
	      cmpl	%esi, %ebp
	      movq	%rbx, %rax
	      movq	%rdi, %rbx
	      jne	.L8
      .L3:
	      addq	$40, %rsp
	      popq	%rbx
	      popq	%rsi
	      popq	%rdi
	      popq	%rbp
	      popq	%r12
	      popq	%r13
	      ret
	      .p2align 4,,10
      .L11:
	      movq	.refptr._ZSt4cout(%rip), %rcx
	      movl	$1, %edx
	      call	_ZNSo9_M_insertIyEERSoT_
	      movl	$1, %r8d
	      leaq	.LC0(%rip), %rdx
	      movq	%rax, %rcx
	      call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_x
	      cmpl	$1, %ebp
	      je	.L3
	      movq	.refptr._ZSt4cout(%rip), %rcx
	      movl	$1, %edx
	      call	_ZNSo9_M_insertIyEERSoT_
	      movl	$1, %r8d
	      leaq	.LC0(%rip), %rdx
	      movq	%rax, %rcx
	      call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_x
	      jmp	.L5
	      .seh_endproc
	      .def	__main;	.scl	2;	.type	32;	.endef
	      .section .rdata,"dr"
	      .align 8
      .LC1:
	      .ascii "Error: Enter a positive integer\0"
	      .section	.text.startup,"x"
	      .p2align 4,,15
	      .globl	main
	      .def	main;	.scl	2;	.type	32;	.endef
	      .seh_proc	main
      main:
      .LFB1595:
	      subq	$56, %rsp
	      .seh_stackalloc	56
	      .seh_endprologue
	      call	__main
	      movq	.refptr._ZSt3cin(%rip), %rcx
      	leaq	44(%rsp), %rdx
      	call	_ZNSirsERi
      	movl	44(%rsp), %ecx
      	testl	%ecx, %ecx
      	jle	.L15
      	call	_Z14printFibonaccii
      	movq	.refptr._ZSt4cout(%rip), %rcx
      	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_
      	xorl	%eax, %eax
      .L12:
      	addq	$56, %rsp
      	ret
      .L15:
      	movq	.refptr._ZSt4cout(%rip), %rcx
      	movl	$31, %r8d
      	leaq	.LC1(%rip), %rdx
      	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_x
      	movq	.refptr._ZSt4cout(%rip), %rcx
      	call	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_
      	movl	$1, %eax
      	jmp	.L12
      	.seh_endproc
      	.p2align 4,,15
      	.def	_GLOBAL__sub_I__Z14printFibonaccii;	.scl	3;	.type	32;	.endef
      	.seh_proc	_GLOBAL__sub_I__Z14printFibonaccii
      _GLOBAL__sub_I__Z14printFibonaccii:
      .LFB2086:
      	subq	$40, %rsp
      	.seh_stackalloc	40
      	.seh_endprologue
      	leaq	_ZStL8__ioinit(%rip), %rcx
      	call	_ZNSt8ios_base4InitC1Ev
      	leaq	__tcf_0(%rip), %rcx
      	addq	$40, %rsp
      	jmp	atexit
      	.seh_endproc
      	.section	.ctors,"w"
      	.align 8
      	.quad	_GLOBAL__sub_I__Z14printFibonaccii
      .lcomm _ZStL8__ioinit,1,1
      	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0"
      	.def	_ZNSt8ios_base4InitD1Ev;	.scl	2;	.type	32;	.endef
      	.def	_ZNSo9_M_insertIyEERSoT_;	.scl	2;	.type	32;	.endef
      	.def	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_x;	.scl	2;	.type	32;	.endef
      	.def	_ZNSirsERi;	.scl	2;	.type	32;	.endef
      	.def	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_;	.scl	2;	.type	32;	.endef
      	.def	_ZNSt8ios_base4InitC1Ev;	.scl	2;	.type	32;	.endef
      	.def	atexit;	.scl	2;	.type	32;	.endef
      	.section	.rdata$.refptr._ZSt3cin, "dr"
      	.globl	.refptr._ZSt3cin
      	.linkonce	discard
      .refptr._ZSt3cin:
      	.quad	_ZSt3cin
      	.section	.rdata$.refptr._ZSt4cout, "dr"
      	.globl	.refptr._ZSt4cout
      	.linkonce	discard
      .refptr._ZSt4cout:
	      .quad	_ZSt4cout
      ```

      &nbsp;

   * __Шаг 3.__ Преобразовать программу в модульную, разработать Makefile.
  
      &nbsp;
   
1. Программу усовершенствовать: добавить параллельный процесс средствами Linux/Windows. Синхронизация доступа к общему ресурсу (файл, канал, pipe, очередь, mmap, smmem).
