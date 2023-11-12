#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
 
int
main(int argc, char *argv[])
{
    int p1[2], p2[2];//父->子，子->父
    pipe(p1);
    pipe(p2);
    char buf1[4];
    char buf2[4];
    int pid=fork();
    if(pid==0){//子进程
        // close(p2[0]);
        write(p2[1],"pong",4);
        // close(p2[1]);
        // close(p1[1]);
        read(p1[0],buf2,4);
        // close(p1[0]);
        printf("%d: received %s\n",getpid(),buf2);
    }
    else{//父进程
        // close(p1[0]);
        write(p1[1],"ping",4);
        wait(0);//自己写的时候漏了这行，等待子进程结束，否则子进程和父进程会交替输出
        // close(p1[1]);
        // close(p2[1]);
        read(p2[0],buf1,4);
        // close(p2[0]);
        printf("%d: received %s\n",getpid(),buf1);
    }
    exit(0);
}