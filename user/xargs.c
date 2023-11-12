#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

//自己写的，有问题，不会
// int
// main(int argc, char *argv[])
// {
//     char buf[64],*argvs[64];//接受前一个命令的输出，传给下一个命令的参数
//     printf("%d",argc);
//     for(int i=1;i<argc;i++)argvs[i-1]=argv[i];
//     while (read(0,buf,64))//前一个命令的输出保存到buf("xxx\n")
//     {
//         // printf("%s\n",buf);
//         argvs[argc-1]=buf;
//         printf("%s %s %s %s\n",argvs[0],argvs[1],argvs[2],argvs[3]);
//         for(int i=0;i<strlen(buf);i++){
//             if(buf[i]=='\n')
//                 if(fork()==0)
//                     exec(argvs[0],argvs);
//             wait(0);
//         }
//     }
//     exit(0);
// }

#define MAXN 1024
#define MAXARG 1024
int
main(int argc, char *argv[])
{
    // 如果参数个数小于 2
    if (argc < 2) {
        // 打印参数错误提示
        fprintf(2, "usage: xargs command\n");
        // 异常退出
        exit(1);
    }
    // 存放子进程 exec 的参数
    char * argvs[MAXARG];
    // 索引
    int index = 0;
    // 略去 xargs ，用来保存命令行参数
    for (int i = 1; i < argc; ++i) {
        argvs[index++] = argv[i];
    }
    // 缓冲区存放从管道读出的数据
    char buf[MAXN] = {"\0"};
    
    int n;
	// 0 代表的是管道的 0，也就是从管道循环读取数据
    while((n = read(0, buf, MAXN)) > 0 ) {
        // 临时缓冲区存放追加的参数
		char temp[MAXN] = {"\0"};
        // xargs 命令的参数后面再追加参数
        argvs[index] = temp;
        // 内循环获取追加的参数并创建子进程执行命令
        for(int i = 0; i < strlen(buf); ++i) {
            // 读取单个输入行，当遇到换行符时，创建子线程
            if(buf[i] == '\n') {
                // 创建子线程执行命令
                if (fork() == 0) {
                    exec(argv[1], argvs);
                }
                // 等待子线程执行完毕
                wait(0);
            } else {
                // 否则，读取管道的输出作为输入
                temp[i] = buf[i];
            }
        }
    }
    // 正常退出
    exit(0);
}
//下面的程序无法实现
    // $ echo "1\n2" | xargs -n 1 echo line
    // line 1
    // line 2
    // $