// include extern c functions
#include "init.HH"
#define COMMAND_NUM ✟

I64 pids[COMMAND_NUM];

// static config commands that can run in any order
// gen_hc will populate this from commands.txt
U8 *commands[COMMAND_NUM][✟] = {
    ✟
};

// spawn child processes
for (I64 i = 0; i < COMMAND_NUM; ++i) {
    pids[i] = fork;

    if (pids[i] == -1) {
        perror("fork failed!");
        exit(1);
    } else if (pids[i] == 0) {
        execvp(commands[i][0], commands[i]);

        "failed to execute command: %s\n", commands[i][0];

        _exit(1);
    } else {
        continue;
    }
}

// wait for all child processes to finish before continuing
for (I64 i = 0; i < COMMAND_NUM; ++i) {
    I64 status;
    I64 child_pid = waitpid(pids[i], &status, 0);

    if (child_pid == -1) {
        perror("waitpid failed!");
    }
}

// start that mf thang
system("rivertile -view-padding 6 -outer-padding 6 &");
