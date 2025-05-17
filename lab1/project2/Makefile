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
