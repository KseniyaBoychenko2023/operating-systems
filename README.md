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

   * __Шаг 3.__ Преобразовать программу в модульную, разработать Makefile.
  
      &nbsp;
   
1. Программу усовершенствовать: добавить параллельный процесс средствами Linux/Windows. Синхронизация доступа к общему ресурсу (файл, канал, pipe, очередь, mmap, smmem).
