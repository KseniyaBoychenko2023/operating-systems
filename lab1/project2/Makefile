CC = gcc
CFLAGS = -Wall -g -pthread
LDFLAGS = -lrt
TARGET = factorial_program
SRC = main.c factorial.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	rm -f $(TARGET)

.PHONY: all clean