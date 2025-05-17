#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/shm.h>
#include <sys/ipc.h>
#include <semaphore.h>
#include <fcntl.h>
#include "factorial.h"

#define SHM_SIZE sizeof(int)
#define SEM_NAME "/fact_sem"

int main() {
    // Создание и подключение разделяемой памяти
    int shm_id = shmget(IPC_PRIVATE, SHM_SIZE, IPC_CREAT | 0666);
    if (shm_id < 0) {
        perror("shmget");
        exit(1);
    }

    int* shared_data = (int*)shmat(shm_id, NULL, 0);
    if (shared_data == (int*)-1) {
        perror("shmat");
        exit(1);
    }

    // Инициализация семафора
    sem_t* sem = sem_open(SEM_NAME, O_CREAT, 0666, 1);
    if (sem == SEM_FAILED) {
        perror("sem_open");
        exit(1);
    }

    // Создание дочернего процесса
    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        exit(1);
    }

    if (pid == 0) { // Дочерний процесс
        sem_wait(sem);
        printf("%d\n", *shared_data);
        sem_post(sem);

        shmdt(shared_data);
        exit(0);
    }
    else { // Родительский процесс
        int result = factorial(7);

        sem_wait(sem);
        *shared_data = result;
        printf("%d\n", result);
        sem_post(sem);

        wait(NULL);

        // Освобождение ресурсов
        shmdt(shared_data);
        shmctl(shm_id, IPC_RMID, NULL);
        sem_close(sem);
        sem_unlink(SEM_NAME);
    }

    return 0;
}