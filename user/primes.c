#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void prime(int);
/*
父进程将2-35传给第一个子进程
第一个子进程将2（接受到的第一个数）的倍数剔除，将剩下的数传给第二个子进程
以此类推
*/
int
main(int argc, char *argv[])
{
    int p[2];
    pipe(p);
    int pid=fork();
    if(pid==0){//子进程
        close(p[1]);
        prime(p[0]);
    }
    else{//父进程
        for(int i=2;i<=35;i++){
            write(p[1],&i,4);
        }
        close(p[1]);
    }
    wait(0);
    exit(0);
}

void prime(int rp){
    //读取第一个数
    int f;
    if(!read(rp,&f,4))exit(0);
    printf("prime %d\n",f);
    //将剩下的数传给下一个管道
    int p[2];
    pipe(p);
    int pid=fork();
    if(pid==0){//子进程
        close(p[1]);//这句不能注释
        prime(p[0]);
    }
    else{//父进程
        int rd;
        while(read(rp,&rd,4)){
            if(rd%f!=0){
                write(p[1],&rd,4);
            }
        }      
        close(rp);  
        close(p[1]);//这句可以注释
    }
}