#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/shm.h>
#include <sys/ipc.h>
#include <semaphore.h>
#include <fcntl.h>
#include "factorial.h"

// Размер разделяемой памяти
#define SHM_SIZE sizeof(int)
// Имя семафора
#define SEM_NAME "/fact_sem"

int main() {
    // 1. Создание разделяемой памяти
    key_t key = ftok(".", 'F');
    if (key == -1) {
        perror("ftok");
        exit(1);
    }
    
    int shm_id = shmget(key, SHM_SIZE, IPC_CREAT | 0666);
    if (shm_id == -1) {
        perror("shmget");
        exit(1);
    }
    
    // 2. Подключение разделяемой памяти
    int* shared_data = (int*)shmat(shm_id, NULL, 0);
    if (shared_data == (int*)-1) {
        perror("shmat");
        exit(1);
    }
    
    // 3. Инициализация семафора
    sem_t* sem = sem_open(SEM_NAME, O_CREAT | O_EXCL, 0666, 1);
    if (sem == SEM_FAILED) {
        if (errno == EEXIST) {
            sem = sem_open(SEM_NAME, 0);
            if (sem == SEM_FAILED) {
                perror("sem_open existing");
                exit(1);
            }
        } else {
            perror("sem_open new");
            exit(1);
        }
    }
    
    // 4. Создание дочернего процесса
    pid_t pid = fork();
    if (pid == -1) {
        perror("fork");
        exit(1);
    }
    
    if (pid == 0) { // Дочерний процесс
        // 5.1 Чтение из разделяемой памяти
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
        // 5.2 Запись в разделяемую память
        int result = factorial(7); // Вычисление факториала
        
        sem_wait(sem); // Захват семафора
        *shared_data = result; // Запись результата
        printf("Parent wrote: %d\n", result);
        sem_post(sem); // Освобождение семафора
        
        // Ожидание завершения дочернего процесса
        wait(NULL);
        
        // Отсоединение памяти
        if (shmdt(shared_data) == -1) {
            perror("parent shmdt");
        }
    }
    
    return 0;
}
