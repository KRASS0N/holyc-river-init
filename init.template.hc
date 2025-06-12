// include extern c functions
#include "init.HH"
#define COMMAND_NUM {{ command_num }};

I64 pids[COMMAND_NUM];

// static config commands that can run in any order
// render.py will populate this from commands.txt
U8 *commands[COMMAND_NUM][{{ max_length }}] = {
    {% for command in commands %}
        {%- set rendered_args = [] -%}
        {%- for arg in command -%}
            {%- if arg is none -%}
                {%- set _ = rendered_args.append("NULL") -%}
            {%- else -%}
                {%- set _ = rendered_args.append('"' ~ arg ~ '"') -%}
            {%- endif -%}
        {%- endfor -%}
    { {{ rendered_args | join(', ') }} },
    {% endfor %}
};

// spawn child processes
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

    // Super+[1-9] to focus tag [0-8]
    system(StrPrint(NULL, "riverctl map normal Super %d set-focused-tags %d", i, tags));

    // Super+Shift+[1-9] to tag focused view with tag [0-8]
    system(StrPrint(NULL, "riverctl map normal Super+Shift %d set-view-tags %d", i, tags));

    // Super+Control+[1-9] to toggle focus of tag [0-8]
    system(StrPrint(NULL, "riverctl map normal Super+Control %d toggle-focused-tags %d", i, tags));

    // Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
    system(StrPrint(NULL, "riverctl map normal Super+Shift+Control %d toggle-view-tags %d", i, tags));
}

// Super+0 to focus all tags
// Super+Shift+0 to tag focused view with all tags
U64 all_tags = (1 << 32) - 1;

system(StrPrint(NULL, "riverctl map normal Super 0 set-focused-tags %u", all_tags));
system(StrPrint(NULL, "riverctl map normal Super+Shift 0 set-view-tags %u", all_tags));

// start that mf thang
system("rivertile -view-padding 6 -outer-padding 6 &");
