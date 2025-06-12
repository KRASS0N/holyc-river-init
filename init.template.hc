#include "init.HH"
#define COMMAND_NUM {{ command_num }};

I64 pids[COMMAND_NUM];

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
