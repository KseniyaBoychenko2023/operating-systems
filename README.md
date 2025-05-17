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
    
     > g++ -S -O[0123s] -o <>.s <>.c

     &nbsp;

     **Программа [factorial.c](lab1/factorial.c), которая вычисляет факториал:**

     ```c
     #include <stdio.h>
     int factorial(int n) {
     	if (n <= 1) return 1;
     	return n * factorial(n - 1);
     }

     int main() {
     	printf("%d", factorial(7));
     	return 0;
     }
     ```

      &nbsp;

      Транслирую программу в Assembler с разными опциями оптимизации помощью команд:
        + g++ -S -O0 -o factorialO0.s factorial.c
        + g++ -S -O1 -o factorialO1.s factorial.c
        + g++ -S -O2 -o factorialO2.s factorial.c
        + g++ -S -O3 -o factorialO3.s factorial.c
        + g++ -S -Os -o factorialOs.s factorial.c
     
	***

      &nbsp;

   * __Шаг 2.__ Разобраться с одним из вариантов [оптимизации] ассемблерной программой (добавить комментарии в сгенерированный ассемблерный код) - найти циклы, переменные и т.п.

      &nbsp;

      **Ассемблерная программа [factorialO1.s](lab1/factorialO1.s) с уровнем оптимизации 1:**
     
     ```s
      # Ассемблерный код с оптимизацией первого уровня
		.file	"factorial.c"	# Имя исходного файла
		.text	# Начало секции кода
		# Функция factorial(int n)
		.globl	factorial
		.def	factorial;	.scl	2;	.type	32;	.endef
		.seh_proc	factorial	# Начало функции с обработкой SEH (Windows исключения)
     factorial:
		# Пролог функции
		pushq	%rbx	# Сохраняем в стек регистр rbx
		.seh_pushreg	%rbx	# Информируем SEH о сохранении регистра
		subq	$32, %rsp	# Выделяем 32 байта на стеке
		.seh_stackalloc	32	# Информируем SEH о выделении стека
		.seh_endprologue	# Конец пролога SEH
		movl	%ecx, %ebx	# Сохраняем аргумент n (из RCX) в EBX
		movl	$1, %eax	# EAX = 1 (значение по умолчанию для возврата)
		cmpl	$1, %ecx	# Сравниваем n с 1
		jle	.L1	# Если n <= 1, переходим к L1
		# Рекурсивный вызов
		leal	-1(%rcx), %ecx	# Уменьшаем n на 1 (n-1)
		call	factorial	# Рекурсивный вызов factorial(n-1)
		imull	%ebx, %eax	# Умножаем результат (EAX) на исходное n (EBX)
     .L1: 
		addq	$32, %rsp	# Освобождаем стек
		popq	%rbx	# Восстанавливаем RBX
		ret	# Возврат из функции
		.seh_endproc	# Конец функции для SEH
		# Функция main()
		.def	__main;	.scl	2;	.type	32;	.endef
		# Секция read-only данных
		.section .rdata,"dr"
     .LC0:
		.ascii "%d\0"	# Строка формата для printf
		.text
		.globl	main
		.def	main;	.scl	2;	.type	32;	.endef
		.seh_proc	main	# Начало main с обработкой SEH
     main:
		subq	$40, %rsp	# Выделяем 40 байт на стеке
		.seh_stackalloc	40	# Информируем SEH
		.seh_endprologue	# Конец пролога
		call	__main	# Инициализация среды выполнения 
		# Вызов factorial(7)
		movl	$7, %ecx	# Передаем аргумент n = 7 через ECX
		call	factorial	# Вызываем factorial(7)
		# Вывод результата
		movl	%eax, %edx	# Результат (EAX) -> второй аргумент printf (EDX)
		leaq	.LC0(%rip), %rcx	# строка формата "%d" (RCX)
		call	printf	# Вызов printf
		# Завершение программы
		movl	$0, %eax	# Возвращаем 0
		addq	$40, %rsp	# Восстанавливаем стек
		ret	# Выход из main
		.seh_endproc	# Конец функции для SEH
		# Дополнительная информация
		.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0"
		.def	printf;	.scl	2;	.type	32;	.endef
     ```

	***

      &nbsp;

   * __Шаг 3.__ Преобразовать программу в модульную, разработать Makefile.
  
      &nbsp;

	**Структура [проекта](lab1/project1):**
   	```makefile
	CC = gcc

	CFLAGS = -Wall -g
	
	OBJS = main.o factorial.o
	
	TARGET = factorial_program
	
	all: $(TARGET)
	
	$(TARGET): $(OBJS)
		$(CC) $(CFLAGS) -o $@ $^
	
	main.o: main.c factorial.h
		$(CC) $(CFLAGS) -c main.c
	
	factorial.o: factorial.c factorial.h
		$(CC) $(CFLAGS) -c factorial.c
	
	clean:
		rm -f $(OBJS) $(TARGET)
	
	rebuild: clean all
	
	.PHONY: all clean rebuild
	```
    
   &nbsp;
   
1. Программу усовершенствовать: добавить параллельный процесс средствами Linux/Windows. Синхронизация доступа к общему ресурсу (файл, канал, pipe, очередь, mmap, smmem).



&nbsp;

***

&nbsp;

<h2>Лабораторная работа №2.</h2>

Установка Arch Linux: [Видео](https://youtu.be/M_87rLM_UdQ).

***

&nbsp;

<h2>Лабораторная работа №3.</h2>

<h3>Задание:</h3>
Скопировать из папки все изображения в папку резервного хранения.

&nbsp;

**Bash-скрипт [lab3.sh](lab3/lab3.sh) для создания резервной копии фотографий из указанной папки:**
```sh
#!/bin/bash

if [ -z "$1" ]; then
    echo "Ошибка: Укажите путь к папке с фотографиями"
    echo "Пример использования: $0 /путь/к/папке"
    exit 1
fi

SOURCE_DIR="$1"
PARENT_DIR=$(dirname "$SOURCE_DIR")
FOLDER_NAME=$(basename "$SOURCE_DIR")
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_NAME="${FOLDER_NAME}_backup_${TIMESTAMP}"
BACKUP_PATH="${PARENT_DIR}/${BACKUP_NAME}"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Ошибка: Папка $SOURCE_DIR не существует"
    exit 1
fi

echo "Создаю резервную папку: $BACKUP_PATH"
mkdir -p "$BACKUP_PATH" || {
    echo "Ошибка создания папки для резервной копии"
    exit 1
}

echo "Начинаю копирование фотографий..."
COUNTER=0

find "$SOURCE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.heic" \) -exec cp -vp -- "{}" "$BACKUP_PATH" \; | while read -r line; do
    echo "Скопировано: $line"
    ((COUNTER++))
done

if [ $COUNTER -eq 0 ]; then
    echo "Внимание: Не найдено ни одной фотографии для копирования!"
    rmdir "$BACKUP_PATH"
    exit 1
else
    echo "Успешно скопировано файлов: $COUNTER"
    echo "Резервная копия создана в: $BACKUP_PATH"
fi

exit 0
```

&nbsp;

<h3 align="center"> Что делает программа: </h3>
&nbsp;

1. Проверка аргументов:
	* Если не указан путь к папке с фотографиями (первый аргумент), выводит ошибку и пример использования.

2. Подготовка путей:
	* Определяет исходную папку (SOURCE_DIR), родительскую папку (PARENT_DIR) и имя папки (FOLDER_NAME).
	* Создает имя для резервной копии в формате имя_папки_backup_дата-время.
	* Формирует полный путь для резервной копии.

3. Проверка существования исходной папки:
	* Если папка не существует, выводит ошибку и завершает работу.

4. Создание папки для резервной копии:
	* Пытается создать папку для резервной копии, при неудаче выводит ошибку.

5. Копирование файлов:
	* Ищет все файлы с расширениями .jpg, .jpeg, .png, .gif или .heic (регистронезависимо) в исходной папке и её подпапках.
	* Копирует каждый найденный файл в папку резервной копии, выводя информацию о каждом скопированном файле.
	* Считает количество скопированных файлов.

6. Завершение работы:
	* Если не найдено ни одного файла, удаляет пустую папку резервной копии и выходит с ошибкой.
	* В случае успеха выводит количество скопированных файлов и путь к резервной копии.

&nbsp;

Создаст резервную копию всех фотографий из /home/test в папку /home/test_backup_20250511-002508

---

Запуск:
> bash lab3.sh /home/test

&nbsp; 

Результат:
> Создаю резервную папку: /home/test_backup_20250511-002508
> Начинаю копирование фотографий...
> Скопировано: /home/test/5240317622967465208.jpg
> Успешно скопировано файлов: 1
> Резервная копия создана в: /home/test_backup_20250511-002508

---

Ошибка: папка не существует
> bash lab3.sh /nonexistent_folder

&nbsp;

Результат:
> 	Ошибка: Папка /nonexistent_folder не существует

---

Ошибка: нет фотографий
> bash lab3.sh /home/test2

&nbsp;

Результат:
> 	Внимание: Не найдено ни одной фотографии для копирования!

&nbsp;

p. s. папка /home/test2 пустая.
