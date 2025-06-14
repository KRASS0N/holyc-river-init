#include "init.HH"

I64 filesize;
U8 *file = FileRead("commands.template.txt", &filesize);
U8 *file_append = MAlloc(filesize*2);
I64 file_i = 0;

for (I64 i = 1; i < 9; ++i) {
    // tag bitmask
    U8 tags = 1 << (i-1);

    // default StrPrint len is 256, malloc more if needed
    // Super+[1-9] to focus tag [0-8]
    U8 *command = StrPrint(NULL, "riverctl map normal Super %d set-focused-tags %u\n", i, tags);
    StrCpy(file_append+file_i, command);
    file_i += StrLen(command);

    // Super+Shift+[1-9] to tag focused view with tag [0-8]
    StrPrint(command, "riverctl map normal Super+Shift %d set-view-tags %u\n", i, tags);
    StrCpy(file_append+file_i, command);
    file_i += StrLen(command);

    // Super+Control+[1-9] to toggle focus of tag [0-8]
    StrPrint(command, "riverctl map normal Super+Control %d toggle-focused-tags %u\n", i, tags);
    StrCpy(file_append+file_i, command);
    file_i += StrLen(command);

    // Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
    StrPrint(command, "riverctl map normal Super+Shift+Control %d toggle-view-tags %u\n", i, tags);
    StrCpy(file_append+file_i, command);
    file_i += StrLen(command);

    Free(command);
}

// Super+0 to focus all tags
// Super+Shift+0 to tag focused view with all tags
U64 all_tags = (1 << 32) - 1;

U8 *command = StrPrint(NULL, "riverctl map normal Super 0 set-focused-tags %u\n", all_tags);
StrCpy(file_append+file_i, command);
file_i += StrLen(command);

StrPrint(command, "riverctl map normal Super+Shift 0 set-view-tags %u\n", all_tags);
StrCpy(file_append+file_i, command);
file_i += StrLen(command);

Free(command);

U8 *newfile = StrMerge(file, file_append);
FileWrite("commands.txt", newfile, StrLen(newfile));

Free(newfile);
Free(file);
Free(file_append);

exit(0);
