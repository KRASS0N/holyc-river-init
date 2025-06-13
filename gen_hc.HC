#include "init.HH"

I64 filesize;
U8 *file = FileRead("commands.txt", &filesize);

PtrVec *commands = PtrVecNew();
PtrVec *command = PtrVecNew();

I64 slice_start = 0;
I64 in_quotes = FALSE;
I64 *cmd_size = CAlloc(sizeof(I64));
I64 max_size = 0;
I64 command_count = 0;

/**************** READING COMMANDS.TXT ****************/

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
        ++command_count;
    }
}
Free(file);


/**************** WRITING INIT.HC ****************/

U8 *init_hc = FileRead("init.template2.HC", &filesize);
U8 *templated_hc;
for (I64 i = 0; i < filesize; ++i) {
    U8 char = init_hc[i];
    I64 var_len = 15;

    if (char == '>' && i - var_len >= 0 && StrNCmp(init_hc + i - var_len, "% command_num %>", var_len) == 0) {
        U8 *hc_top = MAlloc(filesize);
        StrFirstRem(init_hc, "%", hc_top);
        StrFirstRem(init_hc, ">");
        templated_hc = StrPrint(NULL, "%s%d%s", hc_top, command_count, init_hc);
        Free(hc_top);
        Free(init_hc);
        break;
    }
}
filesize = StrLen(templated_hc);
for (I64 i = 0; i < filesize; ++i) {
    U8 char = templated_hc[i];
    I64 var_len = 14;

    if (char == '>' && i - var_len >= 0 && StrNCmp(templated_hc + i - var_len, "% max_length %>", var_len) == 0) {
        U8 *hc_top = MAlloc(filesize);
        StrFirstRem(templated_hc, "%", hc_top);
        StrFirstRem(templated_hc, ">");
        init_hc = StrPrint(NULL, "%s%d%s", hc_top, max_size, templated_hc);
        "%s\n", init_hc;
        Free(hc_top);
        break;
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
    if (!cmd_ok) {
        continue;
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
    "NULL },\n";
    Free(size);
    PtrVecRelease(cmd);
}
PtrVecRelease(commands);

exit(0);
