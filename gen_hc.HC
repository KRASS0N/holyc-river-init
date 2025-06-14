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

U8 *init_hc = FileRead("init.template.HC", &filesize);
U8 *hc_top = MAlloc(filesize);
StrFirstRem(init_hc, "✟", hc_top);

U8 *templated_hc = StrPrint(NULL, "%s%d%s", hc_top, command_count, init_hc+2);
Free(hc_top);
Free(init_hc);

hc_top = MAlloc(filesize);
StrFirstRem(templated_hc, "✟", hc_top);

// add 1 to max_size for NULL
init_hc = StrPrint(NULL, "%s%d%s", hc_top, max_size+1, templated_hc+2);
Free(hc_top);
Free(templated_hc);

hc_top = MAlloc(filesize);
StrFirstRem(init_hc, "✟", hc_top);

U8 *cmd_str = MAlloc(3*filesize);
I64 str_i = 0;

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
    StrCpy(cmd_str+str_i, "{ ");
    str_i += 2;
    for (I64 i = 0; i < *size; ++i) {
        U8 *arg = PtrVecGet(cmd, i);
        U8 *arg_str;
        if (arg[0] == '\"') {
            arg_str = StrPrint(NULL, "%s, ", arg); 
        } else {
            arg_str = StrPrint(NULL, "\"%s\", ", arg); 
        }
        StrCpy(cmd_str+str_i, arg_str);
        str_i += StrLen(arg_str);
        Free(arg_str);
    }
    // add NULL padding so they are all the same size
    for (I64 i = 0; i < max_size - *size; ++i) {
        StrCpy(cmd_str+str_i, "NULL, ");
        str_i += 6;
    }
    StrCpy(cmd_str+str_i, "NULL },\n");
    str_i += 8;
    Free(size);
    PtrVecRelease(cmd);
}

templated_hc = StrMerge(hc_top, cmd_str, init_hc+2);
Free(hc_top);
Free(init_hc);
Free(cmd_str);
PtrVecRelease(commands);

Rm("init.HC");
FileWrite("init.HC", templated_hc, StrLen(templated_hc));
Free(templated_hc);

exit(0);
