#include "init.HH"
#define COMMAND_NUM 2;

I64 pids[COMMAND_NUM];

U8 *commands[COMMAND_NUM][4] = {
    {"lsd", NULL, NULL, NULL},
    {"riverctl", "default-layout", "rivertile", NULL}
};

for (I64 i = 0; i < COMMAND_NUM; ++i) {
    pids[i] = fork;

    if (pids[i] == -1) {
        perror("fork failed!");
        exit(1);
    } else if (pids[i] == 0) {
        execvp(commands[i][0], commands[i]);

        perror("failed to execute command");
        "%s\n", commands[i][0];

        _exit(1);
    } else {
        continue;
    }
}

for (I64 i = 0; i < COMMAND_NUM; ++i) {
    I64 status;
    I64 child_pid = waitpid(pids[i], &status, 0);

    if (child_pid == -1) {
        perror("waitpid failed!");
    }
}

system("rivertile -view-padding 6 -outer-padding 6 &");
