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

   * __Шаг 1.__ Нужно написать программу на С, странслировать его в Assembler с разными опциями оптимизации.
    
     > gcc -S -O[0123s] -o <>.s <>.c

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
        + gcc -S -O0 -o factorialO0.s factorial.c &nbsp; &nbsp;	-Без оптимизации
        + gcc -S -O1 -o factorialO1.s factorial.c &nbsp; &nbsp;	-Базовая оптимизация
        + gcc -S -O2 -o factorialO2.s factorial.c &nbsp; &nbsp;	-Средняя оптимизация
        + gcc -S -O3 -o factorialO3.s factorial.c &nbsp; &nbsp;	-Агрессивная оптимизация
        + gcc -S -Os -o factorialOs.s factorial.c &nbsp; &nbsp;	 -Оптимизация по размеру кода
     
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
   		```
		project1/
		├── include/
		│   └── factorial.h     # Заголовочный файл
		├── src/
		│   ├── factorial.c     # Реализация функции
		│   └── main.c         # Главная программа
		├── obj/               # Для объектных файлов
		│   ├── factorial.o
		│   └── main.o
		├── factorial_program 
		└── Makefile           # Система сборки
		```
		&nbsp;

		Модульная структура:
		
		* Папка include/ содержит заголовочный файл factorial.h с прототипом функции factorial.
			
		* Папка src/ включает файлы factorial.c (реализация функции) и main.c (основная программа).
			
		* Папка obj/ используется для хранения объектных файлов, генерируемых при компиляции.
		
		* Исполняемый файл factorial_program создаётся в корневой папке проекта.

		&nbsp;
		&nbsp;
	
	   [include/factorial.h](lab1/project1/include/factorial.h)
	   
	   ```h
		#ifndef FACTORIAL_H
		#define FACTORIAL_H
		
		int factorial(int n); // Объявление метода
		
		#endif
	   ```
	
		&nbsp;
	
	   [src/main.c](lab1/project1/src/main.c)
	   
	   ```c
		#include <stdio.h>
		#include "factorial.h" // Подключение заголовка
		
		int main() {
		    printf("%d", factorial(7));
		    return 0;
		}
	   ```
	
	   &nbsp;
	
	   [src/factorial.c](lab1/project1/src/factorial.c)
	   
	   ```c
		#include "factorial.h" 
	
		int factorial(int n) {
	    		if (n <= 1) return 1;
	    		return n * factorial(n - 1);
		}
	   ```
	
	   &nbsp;
	
	   [Makefile](lab1/project1/Makefile)
	   
	   ```makefile
		# Настройки компилятора
		CC = gcc	# Используемый компилятор (GNU C Compiler)
		CFLAGS = -Wall -Wextra -Iinclude	# Флаги компиляции:
    						# -Wall: вывод всех предупреждений
						# -Wextra: дополнительные предупреждения
						# -Iinclude: путь к заголовочным файлам (папка include)
    
		TARGET = factorial_program	# Имя итогового исполняемого файла
		
		# Директории
		SRC_DIR = src	# Папка с исходным кодом (.c файлы)
		OBJ_DIR = obj	# Папка для объектных файлов (.o)
		
		# Исходные файлы
		SRCS = $(wildcard $(SRC_DIR)/*.c)	# Находит ВСЕ .c файлы в src/
		OBJS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))	# Преобразует имена .c в .o (например, src/main.c → obj/main.o)
		
		# Основные цели
		all: $(OBJ_DIR) $(TARGET)	# Проверяет, существует ли obj/ (если нет — создаёт) и собирает $(TARGET) (исполняемый файл)
		
		$(TARGET): $(OBJS)	# Сборка итогового бинарника
		    $(CC) $(CFLAGS) -o $@ $^	# $@ = имя цели (TARGET), $^ = все зависимости (OBJS)
		
		$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c	# Правило для каждого .o файла
		    $(CC) $(CFLAGS) -c $< -o $@	# $< = исходный .c файл
		
		$(OBJ_DIR):	# Создание папки obj/
		    mkdir -p $@
		
		# Вспомогательные цели
		clean:	# Удаление всех сгенерированных файлов
		    rm -rf $(OBJ_DIR) $(TARGET)
		
		rebuild: clean all	# Полная пересборка: clean → all
		
		.PHONY: all clean rebuild	# Указывает, что это не файлы
	   ```
	
	   &nbsp;
   
2. Программу усовершенствовать: добавить параллельный процесс средствами Linux/Windows. Синхронизация доступа к общему ресурсу (файл, канал, pipe, очередь, mmap, smmem).
	
	&nbsp;

	* Основная цель — вычислить факториал в родительском процессе, записать результат в разделяемую память и передать его дочернему процессу для чтения, обеспечивая синхронизацию доступа к общему ресурсу.

		&nbsp;

		
		**Структура [проекта](lab1/project2):**
		```
			project2/
			├── include/
			│   └── factorial.h     # Заголовочный файл
			├── src/
			│   ├── factorial.c     # Реализация функции
			│   └── main.c         # Главная программа
			├── factorial_program 
			└── Makefile           # Система сборки
		```
		
		&nbsp;
	
		[include/factorial.h](lab1/project2/include/factorial.h)
			   
		```h
			#ifndef FACTORIAL_H
			#define FACTORIAL_H
				
			int factorial(int n);
				
			#endif
		```
		  
		&nbsp;
		
		[src/main.c](lab1/project2/src/main.c)
			   
		```c
			#include <stdio.h>
			#include <stdlib.h>
			#include <unistd.h>
			#include <sys/wait.h>
			#include <sys/shm.h>
			#include <sys/ipc.h>
			#include <semaphore.h>
			#include <fcntl.h>
			#include <signal.h>
			#include "factorial.h"
			
			// Размер разделяемой памяти
			#define SHM_SIZE sizeof(int)
			// Имя семафора
			#define SEM_NAME "/fact_sem"
			
			// Глобальные переменные для обработки сигналов
			int shm_id;
			int* shared_data;
			sem_t* sem;
			
			// Функция очистки ресурсов
			void cleanup(int sig) {
			    // Отсоединение разделяемой памяти
			    if (shmdt(shared_data) == -1) {
			        perror("shmdt");
			    }
			    
			    // Удаление разделяемой памяти
			    if (shmctl(shm_id, IPC_RMID, NULL) == -1) {
			        perror("shmctl");
			    }
			    
			    // Закрытие семафора
			    if (sem != SEM_FAILED) {
			        sem_close(sem);
			        sem_unlink(SEM_NAME);
			    }
			    
			    exit(sig == SIGINT ? 0 : 1);
			}
			
			int main() {
			    // Регистрация обработчиков сигналов
			    signal(SIGINT, cleanup);
			    signal(SIGTERM, cleanup);
			
			    /* 1. Создание разделяемой памяти */
			    // Генерация ключа для разделяемой памяти
			    key_t key = ftok(".", 'F');
			    if (key == -1) {
			        perror("ftok");
			        exit(1);
			    }
			    
			    // Создание сегмента разделяемой памяти
			    shm_id = shmget(key, SHM_SIZE, IPC_CREAT | 0666);
			    if (shm_id == -1) {
			        perror("shmget");
			        exit(1);
			    }
			    
			    /* 2. Подключение разделяемой памяти */
			    shared_data = (int*)shmat(shm_id, NULL, 0);
			    if (shared_data == (int*)-1) {
			        perror("shmat");
			        cleanup(SIGTERM);
			    }
			    
			    /* 3. Инициализация семафора */
			    // Создание/открытие именованного семафора
			    sem = sem_open(SEM_NAME, O_CREAT | O_EXCL, 0666, 1);
			    if (sem == SEM_FAILED) {
			        // Если семафор уже существует
			        if (errno == EEXIST) {
			            sem = sem_open(SEM_NAME, 0);
			            if (sem == SEM_FAILED) {
			                perror("sem_open existing");
			                cleanup(SIGTERM);
			            }
			        } else {
			            perror("sem_open new");
			            cleanup(SIGTERM);
			        }
			    }
			    
			    /* 4. Создание дочернего процесса */
			    pid_t pid = fork();
			    if (pid == -1) {
			        perror("fork");
			        cleanup(SIGTERM);
			    }
			    
			    if (pid == 0) { // Дочерний процесс
			        /* 5.1 Чтение из разделяемой памяти */
			        sem_wait(sem); // Захват семафора
			        printf("Child read: %d\n", *shared_data);
			        sem_post(sem); // Освобождение семафора
			        
			        // Отсоединение памяти
			        if (shmdt(shared_data) == -1) {
			            perror("child shmdt");
			        }
			        exit(0);
			    }
			    else { // Родительский процесс
			        /* 5.2 Запись в разделяемую память */
			        int result = factorial(7); // Вычисление факториала
			        
			        sem_wait(sem); // Захват семафора
			        *shared_data = result; // Запись результата
			        printf("Parent wrote: %d\n", result);
			        sem_post(sem); // Освобождение семафора
			        
			        // Ожидание завершения дочернего процесса
			        wait(NULL);
			        
			        /* 6. Освобождение ресурсов */
			        cleanup(0);
			    }
			    
			    return 0;
			}
		```
			
		&nbsp;
			
		[src/factorial.c](lab1/project2/src/factorial.c)
			   
		```c
			#include "factorial.h"
		
			int factorial(int n) {
				if (n <= 1) return 1;
				return n * factorial(n - 1);
			}
		```
		
	   	&nbsp;
		
		[Makefile](lab1/project2/Makefile)
		   
		```makefile
			# Настройки компилятора
			CC = gcc  # Используемый компилятор
			CFLAGS = -Wall -Wextra -Iinclude -O2 -pthread  # Флаги компиляции:
			               # -Wall: все стандартные предупреждения
			               # -Wextra: дополнительные предупреждения
			               # -Iinclude: путь к заголовочным файлам
			               # -O2: уровень оптимизации
			               # -pthread: поддержка потоков
			LDFLAGS = -lrt -lpthread  # Флаги линковки:
			               # -lrt: для разделяемой памяти
			               # -lpthread: для семафоров POSIX
			
			# Структура проекта
			SRC_DIR = src    # Директория с исходными файлами
			OBJ_DIR = obj    # Директория для объектных файлов
			TARGET = factorial_program  # Имя исполняемого файла
			
			# Автоматический поиск исходных файлов
			SRCS = $(wildcard $(SRC_DIR)/*.c)  # Найти все .c файлы
			OBJS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))  # Преобразовать в .o
			
			# Основная цель сборки
			all: $(OBJ_DIR) $(TARGET)
			
			# Сборка исполняемого файла
			$(TARGET): $(OBJS)
				$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
			
			# Компиляция каждого .c файла в .o
			$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
				$(CC) $(CFLAGS) -c $< -o $@
			
			# Создание директории для объектных файлов
			$(OBJ_DIR):
				mkdir -p $@
			
			# Очистка проекта
			clean:
				rm -rf $(OBJ_DIR) $(TARGET)
			
			# Фиктивные цели (не связаны с файлами)
			.PHONY: all clean
		```
		
		* Параллельный процесс:
			- Используется системный вызов fork() для создания дочернего процесса.
		 	- Родительский процесс вычисляет факториал числа (например, 7) и записывает результат в разделяемую память.
		  	- Дочерний процесс читает результат из разделяемой памяти и выводит его.
		
		* Разделяемая память:
			- Создаётся сегмент разделяемой памяти с помощью shmget и подключается через shmat.
		 	- Размер памяти равен sizeof(int) для хранения результата факториала.
		  	- Ключ для памяти генерируется с помощью ftok на основе текущей директории.
		
		* Синхронизация:
			- Для предотвращения одновременного доступа к разделяемой памяти используется именованный POSIX-семафор (sem_open, sem_wait, sem_post).
			- Семафор инициализируется со значением 1, обеспечивая взаимоисключающий доступ (mutex).
			- Родительский процесс захватывает семафор перед записью, а дочерний — перед чтением.
		
		* Обработка сигналов и очистка:
		  	- Регистрируются обработчики сигналов (SIGINT, SIGTERM) для корректного освобождения ресурсов (разделяемой памяти и семафора) при прерывании программы.
			- Функция cleanup отсоединяет и удаляет разделяемую память, закрывает и удаляет семафор.

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
