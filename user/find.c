#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

// //查找所有子项，如果是
// void
// find(char *path,char *name)
// {
//     printf("0000");
//     char buf[512], *p, namecpy[512];
//     int fd;
//     struct dirent de;
//     struct stat st;
//     //path->fd文件描述符句柄->st文件信息
//     printf("1111");
//     if((fd = open(path, 0)) < 0){
//         fprintf(2, "find: cannot open %s\n", path);
//         return;
//     }

//     if(fstat(fd, &st) < 0){
//         fprintf(2, "find: cannot stat %s\n", path);
//         close(fd);
//         return;
//     }
//     printf("2222");
//     switch(st.type){
//         case T_FILE: // path是文件而非文件夹
//             // printf("%s %d %d %l is a file, not a path.\n", fmtname(path), st.type, st.ino, st.size);
//             //此时path已经是文件的路径，de.name=LF
//             if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){//文件夹名长度超过最大文件名长
//                 printf("find: path too long\n");
//                 break;
//             }
//             strcpy(namecpy,fmtname(name));
//             // printf("%s %s %s %s\n",fmtname(path),namecpy,path,buf);
//             if(!strcmp(fmtname(path),namecpy))printf("file:%s\n",path);
//             break;

//         case T_DIR:
//             if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){//文件夹名长度超过最大文件名长
//                 printf("find: path too long\n");
//                 break;
//             }
//             //将文件路径名存到buf中
//             strcpy(buf, path);
//             p = buf+strlen(buf);
//             *p++ = '/';
//             while(read(fd, &de, sizeof(de)) == sizeof(de)){
//                 if(de.inum == 0)
//                     continue;
//                 memmove(p, de.name, DIRSIZ);
//                 p[DIRSIZ] = 0;
//                 if(stat(buf, &st) < 0){
//                     printf("find: cannot stat %s\n", buf);
//                     continue;
//                 }
//                 // printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);// 不能直接比较fmtname(buf)和name，因为前者被扩展到了DIRSIZ+1长度
//                 // if(strcmp(fmtname(buf),fmtname(name)))//也不能这么写，fmtname的buf是静态指针
//                 // if(!strcmp(de.name,name))
//                 if(strcmp(de.name,".")&&strcmp(de.name,"..")){
//                     printf("%s\n",buf);
//                     printf("3333");
//                     find(buf,name);
//                 }
//             }
//             break;
//     }
//     close(fd);
// }

//上面的程序是直接递归，在递归里判断目录类型和文件类型，相较而言字符串比较开销较大，猜测是这个原因
//下面的程序是先判断目录类型和文件类型，如果是目录类型则递归，文件类型直接字符串比较输出
void
find(char *path,char *name)
{
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;
    //path->fd文件描述符句柄->st文件信息
    if((fd = open(path, 0)) < 0){
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }
    switch(st.type){
        case T_FILE: // path是文件而非文件夹
            printf("%s %d %d %l is a file, not a path.\n", fmtname(path), st.type, st.ino, st.size);

        case T_DIR:
            if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){//文件夹名长度超过最大文件名长
                printf("find: path too long\n");
                break;
            }
            //将文件路径名存到buf中
            strcpy(buf, path);
            p = buf+strlen(buf);
            *p++ = '/';
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
                if(de.inum == 0)
                    continue;
                if(strcmp(de.name,".")&&strcmp(de.name,"..")){
                    memmove(p, de.name, DIRSIZ);
                    p[DIRSIZ] = 0;
                    if(stat(buf, &st) < 0){
                        printf("find: cannot stat %s\n", buf);
                        continue;
                    }
                    // 如果是目录类型，递归查找
                    if (st.type == T_DIR)
                    {
                        find(buf, name);
                    }
                    // 如果是文件类型 并且 名称与要查找的文件名相同
                    else if (st.type == T_FILE && !strcmp(de.name, name))
                    {
                        // 打印缓冲区存放的路径
                        printf("%s\n", buf);
                    } 
                }
            }
            break;
    }
    close(fd);
}

int
main(int argc, char *argv[])
{
    // 如果参数个数不为 3 则报错
    if (argc != 3)
    {
        // 输出提示
        fprintf(2, "usage: find dirName fileName\n");
        // 异常退出
        exit(1);
    }
    // 调用 find 函数查找指定目录下的文件
    find(argv[1], argv[2]);
    // 正常退出
    exit(0);
}