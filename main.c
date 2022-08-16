//Itamar Bachar 318781630
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <stdint-gcc.h>

pid_t pidHistory[100];
char commandHistory[100][100];
int counter;

void addPath(int arg, char *argv[]) {
    int i;
    for (i= 0; i < arg; i++) {
        char *z = getenv("PATH");
        strcat(z, ":/");
        strcat(z, argv[i]);
        setenv("PATH", z, 0);
    }
}

void myMemCpy(void *dest, void *src, size_t n) {
    // Typecast src and dest addresses to (char *)
    char *csrc = (char *) src;
    char *cdest = (char *) dest;
    // Copy contents of src[] to dest[]
    int i;
    for (i= 0; i < n; i++)
        cdest[i] = csrc[i];
}

void showHistory() {
    int i;
    for (i = 0; i < counter; i++) {
        printf("%d", (int) pidHistory[i]);
        printf(" %s\n", commandHistory[i]);

    }
}

int changeDir(char *arguments[100]) {
    if (!strcmp(arguments[1], "..")) {
        chdir("..");
    } else {
        char currentPath[100];
        getcwd(currentPath, sizeof(currentPath));
        strcat( currentPath ,"/");
        strcat( currentPath ,arguments[1]);
        if (chdir(currentPath) != 0) {
            perror("chdir failed");
            return -1;
        }
        return 0;
    }
}


int main(int arg, char *argv[]) {
    addPath(arg, argv);
    int flag = 0;
    counter = 0;
    while (1) {
        int stat, waited;
        pid_t pid;
        int i = 0;
        char nextStep[100];
        char *arguments[100];
        char copy[100];
        printf("$ ");
        fflush(stdout);
        scanf(" %[^\n]s" , nextStep);
        myMemCpy(copy, nextStep, sizeof(nextStep));
        if (!strcmp(nextStep, "exit")) {
            break;
        }
        if (strstr(nextStep, "history")) {
            pidHistory[counter] = getpid();
            myMemCpy(commandHistory[counter], "history", sizeof("history"));
            counter++;
            showHistory(counter);
            continue;
        }
        char s[2] = " ";
        char *token;
        token = strtok(nextStep, s);
        if (!strcmp(token, "cd")) {
            flag = 1;
        }
        char *n = token;
        while (token != NULL) {
            arguments[i] = token;
            token = strtok(NULL, s);
            i++;
        }
        arguments[i] = NULL;
        if (flag == 1) {
            int check = changeDir(arguments);
            flag = 0;
            if(check == -1){
                continue;
            }
            myMemCpy(commandHistory[counter], copy, sizeof(copy));
            pidHistory[counter] = getpid();
            counter++;
            continue;
        }
        pid = fork();
        if (pid == -1) {
            perror("fork failed");
        }
        if (pid == 0) {
            if (execvp(n, arguments)) {
                perror("execvp failed");
                myMemCpy(commandHistory[counter], copy, sizeof(copy));
                pidHistory[counter] = pid;
                counter++;
                flag = 0;
                exit(0);

            }

        } else {
            waited = wait(&stat);
            myMemCpy(commandHistory[counter], copy, sizeof(copy));
            pidHistory[counter] = pid;
            counter++;
            flag = 0;
        }
    }
    return 0;
}