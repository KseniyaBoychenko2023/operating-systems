# Настройки компилятора
CC = gcc
CFLAGS = -Wall -Wextra -Iinclude -O2
TARGET = factorial_program

# Директории
SRC_DIR = src
OBJ_DIR = obj

# Исходные файлы
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

# Основные цели
all: $(OBJ_DIR) $(TARGET)

$(TARGET): $(OBJS)
    $(CC) $(CFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
    $(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
    mkdir -p $@

# Вспомогательные цели
clean:
    rm -rf $(OBJ_DIR) $(TARGET)

rebuild: clean all

.PHONY: all clean rebuild