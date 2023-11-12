struct stat;
struct rtcdate;
struct sysinfo;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int trace(int);
int sysinfo(struct sysinfo *);

// ulib.c
int stat(const char*, struct stat*);//打开文件 n，获取文件的状态信息，并将信息存储在 st 指向的 struct stat 结构中。如果文件打开失败，它返回 -1。否则，它返回 fstat 的结果。
char* strcpy(char*, const char*);//复制字符串
void *memmove(void*, const void*, int);//将 vsrc 指向的内存的前 n 个字节复制到 vdst 指向的内存，比memcpy在区域有重叠的情况下更安全
char* strchr(const char*, char c);//查找第一次出现字符 c 的位置。如果找到，它返回一个指向该位置的指针。如果没有找到，它返回 0。
int strcmp(const char*, const char*);//字符串比较
void fprintf(int, const char*, ...);//0	stdin 标准输入 1	stdout 标准输出   2	stderr 标准错误
void printf(const char*, ...);//fprintf(1,,)
char* gets(char*, int max);//read(0, &c, 1)读取文件流，从标准输入读取字符并存储在 buf 指向的内存中，直到遇到换行符、回车符或达到最大字符数 max。
uint strlen(const char*);//字符串长度
void* memset(void*, int, uint);//初始化数组，将指定的值 c 设置到 dst 指向的内存的前 n 个字节。这个函数的返回值是指向 dst 的指针。
void* malloc(uint);//它尝试在自由内存列表中找到一个足够大的块来满足请求的内存大小 nbytes。如果找到了足够大的块，它就将这个块分割（如果需要的话），并将剩余的部分（如果有的话）留在自由列表中。
void free(void*);//释放由 malloc 分配的内存。这个函数将内存块 ap 放回到自由内存列表中。
int atoi(const char*);//string->int
int memcmp(const void *, const void *, uint);//比较内存
void *memcpy(void *, const void *, uint);//将 vsrc 指向的内存的前 n 个字节复制到 vdst 指向的内存=memmove
