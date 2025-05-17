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