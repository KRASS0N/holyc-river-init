public extern "c" I32 system(U8 *__command);
public extern "c" I64 fork(U0);
public extern "c" I32 execvp(U8 *file, U8 *argv[]);
public extern "c" U0 perror(U8 *s);
public extern "c" U0 _exit(I32 status);
public extern "c" U0 exit(I32 status);
public extern "c" I64 waitpid(I64 pid, I32 *wstatus, I32 options);
