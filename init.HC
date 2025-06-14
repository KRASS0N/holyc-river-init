// include extern c functions
#include "init.HH"
#define COMMAND_NUM 62

I64 pids[COMMAND_NUM];

// static config commands that can run in any order
// gen_hc will populate this from commands.txt
U8 *commands[COMMAND_NUM][10] = {
    { "riverctl", "map", "normal", "Super+Shift+Control", "8", "toggle-view-tags", "128", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Control", "8", "toggle-focused-tags", "128", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "8", "set-view-tags", "128", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "8", "set-focused-tags", "128", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift+Control", "7", "toggle-view-tags", "64", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Control", "7", "toggle-focused-tags", "64", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "7", "set-view-tags", "64", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "7", "set-focused-tags", "64", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift+Control", "6", "toggle-view-tags", "32", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Control", "6", "toggle-focused-tags", "32", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "6", "set-view-tags", "32", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "6", "set-focused-tags", "32", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift+Control", "5", "toggle-view-tags", "16", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Control", "5", "toggle-focused-tags", "16", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "5", "set-view-tags", "16", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "5", "set-focused-tags", "16", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift+Control", "4", "toggle-view-tags", "8", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Control", "4", "toggle-focused-tags", "8", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "4", "set-view-tags", "8", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "4", "set-focused-tags", "8", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift+Control", "3", "toggle-view-tags", "4", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Control", "3", "toggle-focused-tags", "4", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "3", "set-view-tags", "4", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "3", "set-focused-tags", "4", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift+Control", "2", "toggle-view-tags", "2", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Control", "2", "toggle-focused-tags", "2", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "2", "set-view-tags", "2", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "2", "set-focused-tags", "2", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift+Control", "1", "toggle-view-tags", "1", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Control", "1", "toggle-focused-tags", "1", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "1", "set-view-tags", "1", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "1", "set-focused-tags", "1", NULL, NULL, NULL },
{ "riverctl", "default-layout", "rivertile", NULL, NULL, NULL, NULL, NULL, NULL, NULL },
{ "riverctl", "map-pointer", "normal", "Super", "BTN_MIDDLE", "toggle-float", NULL, NULL, NULL, NULL },
{ "riverctl", "map-pointer", "normal", "Super", "BTN_RIGHT", "resize-view", NULL, NULL, NULL, NULL },
{ "riverctl", "map-pointer", "normal", "Super", "BTN_LEFT", "move-view", NULL, NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt+Shift", "L", "resize", "horizontal", "100", NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt+Shift", "K", "resize", "vertical", "-100", NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt+Shift", "J", "resize", "vertical", "100", NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt+Shift", "H", "resize", "horizontal", "-100", NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt+Control", "L", "snap", "right", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt+Control", "K", "snap", "up", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt+Control", "J", "snap", "down", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt+Control", "H", "snap", "left", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt", "L", "move", "right", "100", NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt", "K", "move", "up", "100", NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt", "J", "move", "down", "100", NULL, NULL },
{ "riverctl", "map", "normal", "Super+Alt", "H", "move", "left", "100", NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "L", "send-layout-cmd", "rivertile", "main-count", "-1", NULL },
{ "riverctl", "map", "normal", "Super+Shift", "H", "send-layout-cmd", "rivertile", "main-count", "+1", NULL },
{ "riverctl", "map", "normal", "Super", "L", "send-layout-cmd", "rivertile", "main-ratio", "+0.05", NULL },
{ "riverctl", "map", "normal", "Super", "H", "send-layout-cmd", "rivertile", "main-ratio", "-0.05", NULL },
{ "riverctl", "map", "normal", "Super", "Return", "zoom", NULL, NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "Comma", "send-to-output", "previous", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "Period", "send-to-output", "next", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "K", "swap", "previous", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "J", "swap", "next", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "K", "focus-view", "previous", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super", "J", "focus-view", "next", NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "E", "exit", NULL, NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "C", "close", NULL, NULL, NULL, NULL },
{ "riverctl", "map", "normal", "Super+Shift", "Return", "spawn", "kitty --single-instance", NULL, NULL, NULL },

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

for (I64 i = 1; i < 9; ++i) {
    // tag bitmask
    U8 tags = 1 << (i-1);

    // default StrPrint len is 256, malloc more if needed
    // Super+[1-9] to focus tag [0-8]
    U8 *buf = StrPrint(NULL, "riverctl map normal Super %d set-focused-tags %u", i, tags);
    system(buf);

    // Super+Shift+[1-9] to tag focused view with tag [0-8]
    StrPrint(buf, "riverctl map normal Super+Shift %d set-view-tags %u", i, tags);
    system(buf);

    // Super+Control+[1-9] to toggle focus of tag [0-8]
    StrPrint(buf, "riverctl map normal Super+Control %d toggle-focused-tags %u", i, tags);
    system(buf);

    // Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
    StrPrint(buf, "riverctl map normal Super+Shift+Control %d toggle-view-tags %u", i, tags);
    system(buf);

    Free(buf);
}

// Super+0 to focus all tags
// Super+Shift+0 to tag focused view with all tags
U64 all_tags = (1 << 32) - 1;

U8 *buf = StrPrint(NULL, "riverctl map normal Super 0 set-focused-tags %u", all_tags);
system(buf);

StrPrint(buf, "riverctl map normal Super+Shift 0 set-view-tags %u", all_tags);
system(buf);

Free(buf);

// start that mf thang
system("rivertile -view-padding 6 -outer-padding 6 &");
