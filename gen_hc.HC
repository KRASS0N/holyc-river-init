#include "init.HH"

I64 filesize;
U8 *file = FileRead("commands.txt", &filesize);

PtrVec *commands = PtrVecNew();
PtrVec *command = PtrVecNew();

I64 slice_start = 0;
I64 in_quotes = FALSE;
I64 *cmd_size = CAlloc(sizeof(I64));
I64 max_size = 0;

for (I64 i = 0; i < filesize; ++i) {
    U8 char = file[i];
    // keep quotes as one arg
    if (char == '\"') {
        in_quotes = !in_quotes;
    }
    // push arg to command vec
    if (IsSpace(char) && in_quotes == FALSE) {
        // whitespace
        if (file + slice_start == file + i - 1) {
            ++slice_start;
            continue;
        }
        U8 *str = StrNCpy(file+slice_start, i-slice_start);
        I64 new_len = 0;

        StrTrimStart(str, i-slice_start, &new_len);
        StrTrimEnd(str, new_len);
        PtrVecPush(command, str);

        slice_start = i;
        *cmd_size += 1;
    }
    // push command to commands vec and parse next line
    if (char == '\n') {
        PtrVecPush(command, cmd_size);
        PtrVecPush(commands, command);
        if (*cmd_size > max_size) {
            max_size = *cmd_size;
        }
        command = PtrVecNew();
        cmd_size = CAlloc(sizeof(I64));
    }
}

I64 ok = TRUE;

while (ok) {
    PtrVec *cmd = PtrVecPop(commands, &ok);
    // will attempt to free null cmd on last iteration otherwise
    if (!ok) {
        break;
    }
    I64 cmd_ok = TRUE;
    I64 *size = PtrVecPop(cmd, &cmd_ok);
    if (cmd_ok) {
        "CMD SIZE = %d\n", *size;
    }

    // print out the args
    "{ ";
    for (I64 i = 0; i < *size; ++i) {
        U8 *arg = PtrVecGet(cmd, i);
        if (arg[0] == '\"') {
            U64 arg_end = StrLen(arg);
            arg[arg_end-1] = '\0';
            "\"\\%s\\\"\", ", arg; 
        } else {
            "\"%s\", ", arg; 
        }
    }
    // add NULL padding so they are all the same size
    for (I64 i = 0; i < max_size - *size; ++i) {
        "NULL, "; 
    }
    "NULL }\n\n";
    Free(size);
    PtrVecRelease(cmd);
}

Free(file);
PtrVecRelease(commands);

exit(0);
