
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	332080e7          	jalr	818(ra) # 342 <strlen>
  18:	02051793          	sll	a5,a0,0x20
  1c:	9381                	srl	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	add	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	add	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	306080e7          	jalr	774(ra) # 342 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	add	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2e4080e7          	jalr	740(ra) # 342 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	b4298993          	add	s3,s3,-1214 # ba8 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	43e080e7          	jalr	1086(ra) # 4b4 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2c2080e7          	jalr	706(ra) # 342 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2b4080e7          	jalr	692(ra) # 342 <strlen>
  96:	1902                	sll	s2,s2,0x20
  98:	02095913          	srl	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2c4080e7          	jalr	708(ra) # 36c <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <find>:

//上面的程序是直接递归，在递归里判断目录类型和文件类型，相较而言字符串比较开销较大，猜测是这个原因
//下面的程序是先判断目录类型和文件类型，如果是目录类型则递归，文件类型直接字符串比较输出
void
find(char *path,char *name)
{
  b4:	d9010113          	add	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	add	s0,sp,624
  d6:	892a                	mv	s2,a0
  d8:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;
    //path->fd文件描述符句柄->st文件信息
    if((fd = open(path, 0)) < 0){
  da:	4581                	li	a1,0
  dc:	00000097          	auipc	ra,0x0
  e0:	4ca080e7          	jalr	1226(ra) # 5a6 <open>
  e4:	08054f63          	bltz	a0,182 <find+0xce>
  e8:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
  ea:	d9840593          	add	a1,s0,-616
  ee:	00000097          	auipc	ra,0x0
  f2:	4d0080e7          	jalr	1232(ra) # 5be <fstat>
  f6:	0a054163          	bltz	a0,198 <find+0xe4>
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }
    switch(st.type){
  fa:	da041783          	lh	a5,-608(s0)
  fe:	4705                	li	a4,1
 100:	02e78963          	beq	a5,a4,132 <find+0x7e>
 104:	4709                	li	a4,2
 106:	04e79863          	bne	a5,a4,156 <find+0xa2>
        case T_FILE: // path是文件而非文件夹
            printf("%s %d %d %l is a file, not a path.\n", fmtname(path), st.type, st.ino, st.size);
 10a:	854a                	mv	a0,s2
 10c:	00000097          	auipc	ra,0x0
 110:	ef4080e7          	jalr	-268(ra) # 0 <fmtname>
 114:	85aa                	mv	a1,a0
 116:	da843703          	ld	a4,-600(s0)
 11a:	d9c42683          	lw	a3,-612(s0)
 11e:	da041603          	lh	a2,-608(s0)
 122:	00001517          	auipc	a0,0x1
 126:	98e50513          	add	a0,a0,-1650 # ab0 <malloc+0x11a>
 12a:	00000097          	auipc	ra,0x0
 12e:	7b4080e7          	jalr	1972(ra) # 8de <printf>

        case T_DIR:
            if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){//文件夹名长度超过最大文件名长
 132:	854a                	mv	a0,s2
 134:	00000097          	auipc	ra,0x0
 138:	20e080e7          	jalr	526(ra) # 342 <strlen>
 13c:	2541                	addw	a0,a0,16
 13e:	20000793          	li	a5,512
 142:	06a7fb63          	bgeu	a5,a0,1b8 <find+0x104>
                printf("find: path too long\n");
 146:	00001517          	auipc	a0,0x1
 14a:	99250513          	add	a0,a0,-1646 # ad8 <malloc+0x142>
 14e:	00000097          	auipc	ra,0x0
 152:	790080e7          	jalr	1936(ra) # 8de <printf>
                    } 
                }
            }
            break;
    }
    close(fd);
 156:	8526                	mv	a0,s1
 158:	00000097          	auipc	ra,0x0
 15c:	436080e7          	jalr	1078(ra) # 58e <close>
}
 160:	26813083          	ld	ra,616(sp)
 164:	26013403          	ld	s0,608(sp)
 168:	25813483          	ld	s1,600(sp)
 16c:	25013903          	ld	s2,592(sp)
 170:	24813983          	ld	s3,584(sp)
 174:	24013a03          	ld	s4,576(sp)
 178:	23813a83          	ld	s5,568(sp)
 17c:	27010113          	add	sp,sp,624
 180:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
 182:	864a                	mv	a2,s2
 184:	00001597          	auipc	a1,0x1
 188:	8fc58593          	add	a1,a1,-1796 # a80 <malloc+0xea>
 18c:	4509                	li	a0,2
 18e:	00000097          	auipc	ra,0x0
 192:	722080e7          	jalr	1826(ra) # 8b0 <fprintf>
        return;
 196:	b7e9                	j	160 <find+0xac>
        fprintf(2, "find: cannot stat %s\n", path);
 198:	864a                	mv	a2,s2
 19a:	00001597          	auipc	a1,0x1
 19e:	8fe58593          	add	a1,a1,-1794 # a98 <malloc+0x102>
 1a2:	4509                	li	a0,2
 1a4:	00000097          	auipc	ra,0x0
 1a8:	70c080e7          	jalr	1804(ra) # 8b0 <fprintf>
        close(fd);
 1ac:	8526                	mv	a0,s1
 1ae:	00000097          	auipc	ra,0x0
 1b2:	3e0080e7          	jalr	992(ra) # 58e <close>
        return;
 1b6:	b76d                	j	160 <find+0xac>
            strcpy(buf, path);
 1b8:	85ca                	mv	a1,s2
 1ba:	dc040513          	add	a0,s0,-576
 1be:	00000097          	auipc	ra,0x0
 1c2:	13c080e7          	jalr	316(ra) # 2fa <strcpy>
            p = buf+strlen(buf);
 1c6:	dc040513          	add	a0,s0,-576
 1ca:	00000097          	auipc	ra,0x0
 1ce:	178080e7          	jalr	376(ra) # 342 <strlen>
 1d2:	1502                	sll	a0,a0,0x20
 1d4:	9101                	srl	a0,a0,0x20
 1d6:	dc040793          	add	a5,s0,-576
 1da:	00a78933          	add	s2,a5,a0
            *p++ = '/';
 1de:	00190a93          	add	s5,s2,1
 1e2:	02f00793          	li	a5,47
 1e6:	00f90023          	sb	a5,0(s2)
                if(strcmp(de.name,".")&&strcmp(de.name,"..")){
 1ea:	00001a17          	auipc	s4,0x1
 1ee:	906a0a13          	add	s4,s4,-1786 # af0 <malloc+0x15a>
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f2:	4641                	li	a2,16
 1f4:	db040593          	add	a1,s0,-592
 1f8:	8526                	mv	a0,s1
 1fa:	00000097          	auipc	ra,0x0
 1fe:	384080e7          	jalr	900(ra) # 57e <read>
 202:	47c1                	li	a5,16
 204:	f4f519e3          	bne	a0,a5,156 <find+0xa2>
                if(de.inum == 0)
 208:	db045783          	lhu	a5,-592(s0)
 20c:	d3fd                	beqz	a5,1f2 <find+0x13e>
                if(strcmp(de.name,".")&&strcmp(de.name,"..")){
 20e:	85d2                	mv	a1,s4
 210:	db240513          	add	a0,s0,-590
 214:	00000097          	auipc	ra,0x0
 218:	102080e7          	jalr	258(ra) # 316 <strcmp>
 21c:	d979                	beqz	a0,1f2 <find+0x13e>
 21e:	00001597          	auipc	a1,0x1
 222:	8da58593          	add	a1,a1,-1830 # af8 <malloc+0x162>
 226:	db240513          	add	a0,s0,-590
 22a:	00000097          	auipc	ra,0x0
 22e:	0ec080e7          	jalr	236(ra) # 316 <strcmp>
 232:	d161                	beqz	a0,1f2 <find+0x13e>
                    memmove(p, de.name, DIRSIZ);
 234:	4639                	li	a2,14
 236:	db240593          	add	a1,s0,-590
 23a:	8556                	mv	a0,s5
 23c:	00000097          	auipc	ra,0x0
 240:	278080e7          	jalr	632(ra) # 4b4 <memmove>
                    p[DIRSIZ] = 0;
 244:	000907a3          	sb	zero,15(s2)
                    if(stat(buf, &st) < 0){
 248:	d9840593          	add	a1,s0,-616
 24c:	dc040513          	add	a0,s0,-576
 250:	00000097          	auipc	ra,0x0
 254:	1d6080e7          	jalr	470(ra) # 426 <stat>
 258:	02054d63          	bltz	a0,292 <find+0x1de>
                    if (st.type == T_DIR)
 25c:	da041783          	lh	a5,-608(s0)
 260:	4705                	li	a4,1
 262:	04e78363          	beq	a5,a4,2a8 <find+0x1f4>
                    else if (st.type == T_FILE && !strcmp(de.name, name))
 266:	4709                	li	a4,2
 268:	f8e795e3          	bne	a5,a4,1f2 <find+0x13e>
 26c:	85ce                	mv	a1,s3
 26e:	db240513          	add	a0,s0,-590
 272:	00000097          	auipc	ra,0x0
 276:	0a4080e7          	jalr	164(ra) # 316 <strcmp>
 27a:	fd25                	bnez	a0,1f2 <find+0x13e>
                        printf("%s\n", buf);
 27c:	dc040593          	add	a1,s0,-576
 280:	00001517          	auipc	a0,0x1
 284:	88050513          	add	a0,a0,-1920 # b00 <malloc+0x16a>
 288:	00000097          	auipc	ra,0x0
 28c:	656080e7          	jalr	1622(ra) # 8de <printf>
 290:	b78d                	j	1f2 <find+0x13e>
                        printf("find: cannot stat %s\n", buf);
 292:	dc040593          	add	a1,s0,-576
 296:	00001517          	auipc	a0,0x1
 29a:	80250513          	add	a0,a0,-2046 # a98 <malloc+0x102>
 29e:	00000097          	auipc	ra,0x0
 2a2:	640080e7          	jalr	1600(ra) # 8de <printf>
                        continue;
 2a6:	b7b1                	j	1f2 <find+0x13e>
                        find(buf, name);
 2a8:	85ce                	mv	a1,s3
 2aa:	dc040513          	add	a0,s0,-576
 2ae:	00000097          	auipc	ra,0x0
 2b2:	e06080e7          	jalr	-506(ra) # b4 <find>
 2b6:	bf35                	j	1f2 <find+0x13e>

00000000000002b8 <main>:

int
main(int argc, char *argv[])
{
 2b8:	1141                	add	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	add	s0,sp,16
    // 如果参数个数不为 3 则报错
    if (argc != 3)
 2c0:	470d                	li	a4,3
 2c2:	02e50063          	beq	a0,a4,2e2 <main+0x2a>
    {
        // 输出提示
        fprintf(2, "usage: find dirName fileName\n");
 2c6:	00001597          	auipc	a1,0x1
 2ca:	84258593          	add	a1,a1,-1982 # b08 <malloc+0x172>
 2ce:	4509                	li	a0,2
 2d0:	00000097          	auipc	ra,0x0
 2d4:	5e0080e7          	jalr	1504(ra) # 8b0 <fprintf>
        // 异常退出
        exit(1);
 2d8:	4505                	li	a0,1
 2da:	00000097          	auipc	ra,0x0
 2de:	28c080e7          	jalr	652(ra) # 566 <exit>
 2e2:	87ae                	mv	a5,a1
    }
    // 调用 find 函数查找指定目录下的文件
    find(argv[1], argv[2]);
 2e4:	698c                	ld	a1,16(a1)
 2e6:	6788                	ld	a0,8(a5)
 2e8:	00000097          	auipc	ra,0x0
 2ec:	dcc080e7          	jalr	-564(ra) # b4 <find>
    // 正常退出
    exit(0);
 2f0:	4501                	li	a0,0
 2f2:	00000097          	auipc	ra,0x0
 2f6:	274080e7          	jalr	628(ra) # 566 <exit>

00000000000002fa <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2fa:	1141                	add	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 300:	87aa                	mv	a5,a0
 302:	0585                	add	a1,a1,1
 304:	0785                	add	a5,a5,1
 306:	fff5c703          	lbu	a4,-1(a1)
 30a:	fee78fa3          	sb	a4,-1(a5)
 30e:	fb75                	bnez	a4,302 <strcpy+0x8>
    ;
  return os;
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	add	sp,sp,16
 314:	8082                	ret

0000000000000316 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 316:	1141                	add	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 31c:	00054783          	lbu	a5,0(a0)
 320:	cb91                	beqz	a5,334 <strcmp+0x1e>
 322:	0005c703          	lbu	a4,0(a1)
 326:	00f71763          	bne	a4,a5,334 <strcmp+0x1e>
    p++, q++;
 32a:	0505                	add	a0,a0,1
 32c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 32e:	00054783          	lbu	a5,0(a0)
 332:	fbe5                	bnez	a5,322 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 334:	0005c503          	lbu	a0,0(a1)
}
 338:	40a7853b          	subw	a0,a5,a0
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	add	sp,sp,16
 340:	8082                	ret

0000000000000342 <strlen>:

uint
strlen(const char *s)
{
 342:	1141                	add	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 348:	00054783          	lbu	a5,0(a0)
 34c:	cf91                	beqz	a5,368 <strlen+0x26>
 34e:	0505                	add	a0,a0,1
 350:	87aa                	mv	a5,a0
 352:	86be                	mv	a3,a5
 354:	0785                	add	a5,a5,1
 356:	fff7c703          	lbu	a4,-1(a5)
 35a:	ff65                	bnez	a4,352 <strlen+0x10>
 35c:	40a6853b          	subw	a0,a3,a0
 360:	2505                	addw	a0,a0,1
    ;
  return n;
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	add	sp,sp,16
 366:	8082                	ret
  for(n = 0; s[n]; n++)
 368:	4501                	li	a0,0
 36a:	bfe5                	j	362 <strlen+0x20>

000000000000036c <memset>:

void*
memset(void *dst, int c, uint n)
{
 36c:	1141                	add	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 372:	ca19                	beqz	a2,388 <memset+0x1c>
 374:	87aa                	mv	a5,a0
 376:	1602                	sll	a2,a2,0x20
 378:	9201                	srl	a2,a2,0x20
 37a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 37e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 382:	0785                	add	a5,a5,1
 384:	fee79de3          	bne	a5,a4,37e <memset+0x12>
  }
  return dst;
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	add	sp,sp,16
 38c:	8082                	ret

000000000000038e <strchr>:

char*
strchr(const char *s, char c)
{
 38e:	1141                	add	sp,sp,-16
 390:	e422                	sd	s0,8(sp)
 392:	0800                	add	s0,sp,16
  for(; *s; s++)
 394:	00054783          	lbu	a5,0(a0)
 398:	cb99                	beqz	a5,3ae <strchr+0x20>
    if(*s == c)
 39a:	00f58763          	beq	a1,a5,3a8 <strchr+0x1a>
  for(; *s; s++)
 39e:	0505                	add	a0,a0,1
 3a0:	00054783          	lbu	a5,0(a0)
 3a4:	fbfd                	bnez	a5,39a <strchr+0xc>
      return (char*)s;
  return 0;
 3a6:	4501                	li	a0,0
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	add	sp,sp,16
 3ac:	8082                	ret
  return 0;
 3ae:	4501                	li	a0,0
 3b0:	bfe5                	j	3a8 <strchr+0x1a>

00000000000003b2 <gets>:

char*
gets(char *buf, int max)
{
 3b2:	711d                	add	sp,sp,-96
 3b4:	ec86                	sd	ra,88(sp)
 3b6:	e8a2                	sd	s0,80(sp)
 3b8:	e4a6                	sd	s1,72(sp)
 3ba:	e0ca                	sd	s2,64(sp)
 3bc:	fc4e                	sd	s3,56(sp)
 3be:	f852                	sd	s4,48(sp)
 3c0:	f456                	sd	s5,40(sp)
 3c2:	f05a                	sd	s6,32(sp)
 3c4:	ec5e                	sd	s7,24(sp)
 3c6:	1080                	add	s0,sp,96
 3c8:	8baa                	mv	s7,a0
 3ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3cc:	892a                	mv	s2,a0
 3ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3d0:	4aa9                	li	s5,10
 3d2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3d4:	89a6                	mv	s3,s1
 3d6:	2485                	addw	s1,s1,1
 3d8:	0344d863          	bge	s1,s4,408 <gets+0x56>
    cc = read(0, &c, 1);
 3dc:	4605                	li	a2,1
 3de:	faf40593          	add	a1,s0,-81
 3e2:	4501                	li	a0,0
 3e4:	00000097          	auipc	ra,0x0
 3e8:	19a080e7          	jalr	410(ra) # 57e <read>
    if(cc < 1)
 3ec:	00a05e63          	blez	a0,408 <gets+0x56>
    buf[i++] = c;
 3f0:	faf44783          	lbu	a5,-81(s0)
 3f4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3f8:	01578763          	beq	a5,s5,406 <gets+0x54>
 3fc:	0905                	add	s2,s2,1
 3fe:	fd679be3          	bne	a5,s6,3d4 <gets+0x22>
  for(i=0; i+1 < max; ){
 402:	89a6                	mv	s3,s1
 404:	a011                	j	408 <gets+0x56>
 406:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 408:	99de                	add	s3,s3,s7
 40a:	00098023          	sb	zero,0(s3)
  return buf;
}
 40e:	855e                	mv	a0,s7
 410:	60e6                	ld	ra,88(sp)
 412:	6446                	ld	s0,80(sp)
 414:	64a6                	ld	s1,72(sp)
 416:	6906                	ld	s2,64(sp)
 418:	79e2                	ld	s3,56(sp)
 41a:	7a42                	ld	s4,48(sp)
 41c:	7aa2                	ld	s5,40(sp)
 41e:	7b02                	ld	s6,32(sp)
 420:	6be2                	ld	s7,24(sp)
 422:	6125                	add	sp,sp,96
 424:	8082                	ret

0000000000000426 <stat>:

int
stat(const char *n, struct stat *st)
{
 426:	1101                	add	sp,sp,-32
 428:	ec06                	sd	ra,24(sp)
 42a:	e822                	sd	s0,16(sp)
 42c:	e426                	sd	s1,8(sp)
 42e:	e04a                	sd	s2,0(sp)
 430:	1000                	add	s0,sp,32
 432:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 434:	4581                	li	a1,0
 436:	00000097          	auipc	ra,0x0
 43a:	170080e7          	jalr	368(ra) # 5a6 <open>
  if(fd < 0)
 43e:	02054563          	bltz	a0,468 <stat+0x42>
 442:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 444:	85ca                	mv	a1,s2
 446:	00000097          	auipc	ra,0x0
 44a:	178080e7          	jalr	376(ra) # 5be <fstat>
 44e:	892a                	mv	s2,a0
  close(fd);
 450:	8526                	mv	a0,s1
 452:	00000097          	auipc	ra,0x0
 456:	13c080e7          	jalr	316(ra) # 58e <close>
  return r;
}
 45a:	854a                	mv	a0,s2
 45c:	60e2                	ld	ra,24(sp)
 45e:	6442                	ld	s0,16(sp)
 460:	64a2                	ld	s1,8(sp)
 462:	6902                	ld	s2,0(sp)
 464:	6105                	add	sp,sp,32
 466:	8082                	ret
    return -1;
 468:	597d                	li	s2,-1
 46a:	bfc5                	j	45a <stat+0x34>

000000000000046c <atoi>:

int
atoi(const char *s)
{
 46c:	1141                	add	sp,sp,-16
 46e:	e422                	sd	s0,8(sp)
 470:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 472:	00054683          	lbu	a3,0(a0)
 476:	fd06879b          	addw	a5,a3,-48
 47a:	0ff7f793          	zext.b	a5,a5
 47e:	4625                	li	a2,9
 480:	02f66863          	bltu	a2,a5,4b0 <atoi+0x44>
 484:	872a                	mv	a4,a0
  n = 0;
 486:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 488:	0705                	add	a4,a4,1
 48a:	0025179b          	sllw	a5,a0,0x2
 48e:	9fa9                	addw	a5,a5,a0
 490:	0017979b          	sllw	a5,a5,0x1
 494:	9fb5                	addw	a5,a5,a3
 496:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 49a:	00074683          	lbu	a3,0(a4)
 49e:	fd06879b          	addw	a5,a3,-48
 4a2:	0ff7f793          	zext.b	a5,a5
 4a6:	fef671e3          	bgeu	a2,a5,488 <atoi+0x1c>
  return n;
}
 4aa:	6422                	ld	s0,8(sp)
 4ac:	0141                	add	sp,sp,16
 4ae:	8082                	ret
  n = 0;
 4b0:	4501                	li	a0,0
 4b2:	bfe5                	j	4aa <atoi+0x3e>

00000000000004b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b4:	1141                	add	sp,sp,-16
 4b6:	e422                	sd	s0,8(sp)
 4b8:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ba:	02b57463          	bgeu	a0,a1,4e2 <memmove+0x2e>
    while(n-- > 0)
 4be:	00c05f63          	blez	a2,4dc <memmove+0x28>
 4c2:	1602                	sll	a2,a2,0x20
 4c4:	9201                	srl	a2,a2,0x20
 4c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 4cc:	0585                	add	a1,a1,1
 4ce:	0705                	add	a4,a4,1
 4d0:	fff5c683          	lbu	a3,-1(a1)
 4d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4d8:	fee79ae3          	bne	a5,a4,4cc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4dc:	6422                	ld	s0,8(sp)
 4de:	0141                	add	sp,sp,16
 4e0:	8082                	ret
    dst += n;
 4e2:	00c50733          	add	a4,a0,a2
    src += n;
 4e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4e8:	fec05ae3          	blez	a2,4dc <memmove+0x28>
 4ec:	fff6079b          	addw	a5,a2,-1
 4f0:	1782                	sll	a5,a5,0x20
 4f2:	9381                	srl	a5,a5,0x20
 4f4:	fff7c793          	not	a5,a5
 4f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4fa:	15fd                	add	a1,a1,-1
 4fc:	177d                	add	a4,a4,-1
 4fe:	0005c683          	lbu	a3,0(a1)
 502:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 506:	fee79ae3          	bne	a5,a4,4fa <memmove+0x46>
 50a:	bfc9                	j	4dc <memmove+0x28>

000000000000050c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 50c:	1141                	add	sp,sp,-16
 50e:	e422                	sd	s0,8(sp)
 510:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 512:	ca05                	beqz	a2,542 <memcmp+0x36>
 514:	fff6069b          	addw	a3,a2,-1
 518:	1682                	sll	a3,a3,0x20
 51a:	9281                	srl	a3,a3,0x20
 51c:	0685                	add	a3,a3,1
 51e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 520:	00054783          	lbu	a5,0(a0)
 524:	0005c703          	lbu	a4,0(a1)
 528:	00e79863          	bne	a5,a4,538 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 52c:	0505                	add	a0,a0,1
    p2++;
 52e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 530:	fed518e3          	bne	a0,a3,520 <memcmp+0x14>
  }
  return 0;
 534:	4501                	li	a0,0
 536:	a019                	j	53c <memcmp+0x30>
      return *p1 - *p2;
 538:	40e7853b          	subw	a0,a5,a4
}
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	add	sp,sp,16
 540:	8082                	ret
  return 0;
 542:	4501                	li	a0,0
 544:	bfe5                	j	53c <memcmp+0x30>

0000000000000546 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 546:	1141                	add	sp,sp,-16
 548:	e406                	sd	ra,8(sp)
 54a:	e022                	sd	s0,0(sp)
 54c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 54e:	00000097          	auipc	ra,0x0
 552:	f66080e7          	jalr	-154(ra) # 4b4 <memmove>
}
 556:	60a2                	ld	ra,8(sp)
 558:	6402                	ld	s0,0(sp)
 55a:	0141                	add	sp,sp,16
 55c:	8082                	ret

000000000000055e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 55e:	4885                	li	a7,1
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <exit>:
.global exit
exit:
 li a7, SYS_exit
 566:	4889                	li	a7,2
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <wait>:
.global wait
wait:
 li a7, SYS_wait
 56e:	488d                	li	a7,3
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 576:	4891                	li	a7,4
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <read>:
.global read
read:
 li a7, SYS_read
 57e:	4895                	li	a7,5
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <write>:
.global write
write:
 li a7, SYS_write
 586:	48c1                	li	a7,16
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <close>:
.global close
close:
 li a7, SYS_close
 58e:	48d5                	li	a7,21
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <kill>:
.global kill
kill:
 li a7, SYS_kill
 596:	4899                	li	a7,6
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <exec>:
.global exec
exec:
 li a7, SYS_exec
 59e:	489d                	li	a7,7
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <open>:
.global open
open:
 li a7, SYS_open
 5a6:	48bd                	li	a7,15
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ae:	48c5                	li	a7,17
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5b6:	48c9                	li	a7,18
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5be:	48a1                	li	a7,8
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <link>:
.global link
link:
 li a7, SYS_link
 5c6:	48cd                	li	a7,19
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ce:	48d1                	li	a7,20
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5d6:	48a5                	li	a7,9
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <dup>:
.global dup
dup:
 li a7, SYS_dup
 5de:	48a9                	li	a7,10
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5e6:	48ad                	li	a7,11
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ee:	48b1                	li	a7,12
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5f6:	48b5                	li	a7,13
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5fe:	48b9                	li	a7,14
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <trace>:
.global trace
trace:
 li a7, SYS_trace
 606:	48d9                	li	a7,22
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 60e:	48dd                	li	a7,23
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 616:	1101                	add	sp,sp,-32
 618:	ec06                	sd	ra,24(sp)
 61a:	e822                	sd	s0,16(sp)
 61c:	1000                	add	s0,sp,32
 61e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 622:	4605                	li	a2,1
 624:	fef40593          	add	a1,s0,-17
 628:	00000097          	auipc	ra,0x0
 62c:	f5e080e7          	jalr	-162(ra) # 586 <write>
}
 630:	60e2                	ld	ra,24(sp)
 632:	6442                	ld	s0,16(sp)
 634:	6105                	add	sp,sp,32
 636:	8082                	ret

0000000000000638 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 638:	7139                	add	sp,sp,-64
 63a:	fc06                	sd	ra,56(sp)
 63c:	f822                	sd	s0,48(sp)
 63e:	f426                	sd	s1,40(sp)
 640:	f04a                	sd	s2,32(sp)
 642:	ec4e                	sd	s3,24(sp)
 644:	0080                	add	s0,sp,64
 646:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 648:	c299                	beqz	a3,64e <printint+0x16>
 64a:	0805c963          	bltz	a1,6dc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 64e:	2581                	sext.w	a1,a1
  neg = 0;
 650:	4881                	li	a7,0
 652:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 656:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 658:	2601                	sext.w	a2,a2
 65a:	00000517          	auipc	a0,0x0
 65e:	52e50513          	add	a0,a0,1326 # b88 <digits>
 662:	883a                	mv	a6,a4
 664:	2705                	addw	a4,a4,1
 666:	02c5f7bb          	remuw	a5,a1,a2
 66a:	1782                	sll	a5,a5,0x20
 66c:	9381                	srl	a5,a5,0x20
 66e:	97aa                	add	a5,a5,a0
 670:	0007c783          	lbu	a5,0(a5)
 674:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 678:	0005879b          	sext.w	a5,a1
 67c:	02c5d5bb          	divuw	a1,a1,a2
 680:	0685                	add	a3,a3,1
 682:	fec7f0e3          	bgeu	a5,a2,662 <printint+0x2a>
  if(neg)
 686:	00088c63          	beqz	a7,69e <printint+0x66>
    buf[i++] = '-';
 68a:	fd070793          	add	a5,a4,-48
 68e:	00878733          	add	a4,a5,s0
 692:	02d00793          	li	a5,45
 696:	fef70823          	sb	a5,-16(a4)
 69a:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 69e:	02e05863          	blez	a4,6ce <printint+0x96>
 6a2:	fc040793          	add	a5,s0,-64
 6a6:	00e78933          	add	s2,a5,a4
 6aa:	fff78993          	add	s3,a5,-1
 6ae:	99ba                	add	s3,s3,a4
 6b0:	377d                	addw	a4,a4,-1
 6b2:	1702                	sll	a4,a4,0x20
 6b4:	9301                	srl	a4,a4,0x20
 6b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ba:	fff94583          	lbu	a1,-1(s2)
 6be:	8526                	mv	a0,s1
 6c0:	00000097          	auipc	ra,0x0
 6c4:	f56080e7          	jalr	-170(ra) # 616 <putc>
  while(--i >= 0)
 6c8:	197d                	add	s2,s2,-1
 6ca:	ff3918e3          	bne	s2,s3,6ba <printint+0x82>
}
 6ce:	70e2                	ld	ra,56(sp)
 6d0:	7442                	ld	s0,48(sp)
 6d2:	74a2                	ld	s1,40(sp)
 6d4:	7902                	ld	s2,32(sp)
 6d6:	69e2                	ld	s3,24(sp)
 6d8:	6121                	add	sp,sp,64
 6da:	8082                	ret
    x = -xx;
 6dc:	40b005bb          	negw	a1,a1
    neg = 1;
 6e0:	4885                	li	a7,1
    x = -xx;
 6e2:	bf85                	j	652 <printint+0x1a>

00000000000006e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e4:	715d                	add	sp,sp,-80
 6e6:	e486                	sd	ra,72(sp)
 6e8:	e0a2                	sd	s0,64(sp)
 6ea:	fc26                	sd	s1,56(sp)
 6ec:	f84a                	sd	s2,48(sp)
 6ee:	f44e                	sd	s3,40(sp)
 6f0:	f052                	sd	s4,32(sp)
 6f2:	ec56                	sd	s5,24(sp)
 6f4:	e85a                	sd	s6,16(sp)
 6f6:	e45e                	sd	s7,8(sp)
 6f8:	e062                	sd	s8,0(sp)
 6fa:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6fc:	0005c903          	lbu	s2,0(a1)
 700:	18090c63          	beqz	s2,898 <vprintf+0x1b4>
 704:	8aaa                	mv	s5,a0
 706:	8bb2                	mv	s7,a2
 708:	00158493          	add	s1,a1,1
  state = 0;
 70c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 70e:	02500a13          	li	s4,37
 712:	4b55                	li	s6,21
 714:	a839                	j	732 <vprintf+0x4e>
        putc(fd, c);
 716:	85ca                	mv	a1,s2
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	efc080e7          	jalr	-260(ra) # 616 <putc>
 722:	a019                	j	728 <vprintf+0x44>
    } else if(state == '%'){
 724:	01498d63          	beq	s3,s4,73e <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 728:	0485                	add	s1,s1,1
 72a:	fff4c903          	lbu	s2,-1(s1)
 72e:	16090563          	beqz	s2,898 <vprintf+0x1b4>
    if(state == 0){
 732:	fe0999e3          	bnez	s3,724 <vprintf+0x40>
      if(c == '%'){
 736:	ff4910e3          	bne	s2,s4,716 <vprintf+0x32>
        state = '%';
 73a:	89d2                	mv	s3,s4
 73c:	b7f5                	j	728 <vprintf+0x44>
      if(c == 'd'){
 73e:	13490263          	beq	s2,s4,862 <vprintf+0x17e>
 742:	f9d9079b          	addw	a5,s2,-99
 746:	0ff7f793          	zext.b	a5,a5
 74a:	12fb6563          	bltu	s6,a5,874 <vprintf+0x190>
 74e:	f9d9079b          	addw	a5,s2,-99
 752:	0ff7f713          	zext.b	a4,a5
 756:	10eb6f63          	bltu	s6,a4,874 <vprintf+0x190>
 75a:	00271793          	sll	a5,a4,0x2
 75e:	00000717          	auipc	a4,0x0
 762:	3d270713          	add	a4,a4,978 # b30 <malloc+0x19a>
 766:	97ba                	add	a5,a5,a4
 768:	439c                	lw	a5,0(a5)
 76a:	97ba                	add	a5,a5,a4
 76c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 76e:	008b8913          	add	s2,s7,8
 772:	4685                	li	a3,1
 774:	4629                	li	a2,10
 776:	000ba583          	lw	a1,0(s7)
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	ebc080e7          	jalr	-324(ra) # 638 <printint>
 784:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 786:	4981                	li	s3,0
 788:	b745                	j	728 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	008b8913          	add	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4629                	li	a2,10
 792:	000ba583          	lw	a1,0(s7)
 796:	8556                	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	ea0080e7          	jalr	-352(ra) # 638 <printint>
 7a0:	8bca                	mv	s7,s2
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b751                	j	728 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7a6:	008b8913          	add	s2,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4641                	li	a2,16
 7ae:	000ba583          	lw	a1,0(s7)
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e84080e7          	jalr	-380(ra) # 638 <printint>
 7bc:	8bca                	mv	s7,s2
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	b7a5                	j	728 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 7c2:	008b8c13          	add	s8,s7,8
 7c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ca:	03000593          	li	a1,48
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	e46080e7          	jalr	-442(ra) # 616 <putc>
  putc(fd, 'x');
 7d8:	07800593          	li	a1,120
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e38080e7          	jalr	-456(ra) # 616 <putc>
 7e6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e8:	00000b97          	auipc	s7,0x0
 7ec:	3a0b8b93          	add	s7,s7,928 # b88 <digits>
 7f0:	03c9d793          	srl	a5,s3,0x3c
 7f4:	97de                	add	a5,a5,s7
 7f6:	0007c583          	lbu	a1,0(a5)
 7fa:	8556                	mv	a0,s5
 7fc:	00000097          	auipc	ra,0x0
 800:	e1a080e7          	jalr	-486(ra) # 616 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 804:	0992                	sll	s3,s3,0x4
 806:	397d                	addw	s2,s2,-1
 808:	fe0914e3          	bnez	s2,7f0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 80c:	8be2                	mv	s7,s8
      state = 0;
 80e:	4981                	li	s3,0
 810:	bf21                	j	728 <vprintf+0x44>
        s = va_arg(ap, char*);
 812:	008b8993          	add	s3,s7,8
 816:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 81a:	02090163          	beqz	s2,83c <vprintf+0x158>
        while(*s != 0){
 81e:	00094583          	lbu	a1,0(s2)
 822:	c9a5                	beqz	a1,892 <vprintf+0x1ae>
          putc(fd, *s);
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	df0080e7          	jalr	-528(ra) # 616 <putc>
          s++;
 82e:	0905                	add	s2,s2,1
        while(*s != 0){
 830:	00094583          	lbu	a1,0(s2)
 834:	f9e5                	bnez	a1,824 <vprintf+0x140>
        s = va_arg(ap, char*);
 836:	8bce                	mv	s7,s3
      state = 0;
 838:	4981                	li	s3,0
 83a:	b5fd                	j	728 <vprintf+0x44>
          s = "(null)";
 83c:	00000917          	auipc	s2,0x0
 840:	2ec90913          	add	s2,s2,748 # b28 <malloc+0x192>
        while(*s != 0){
 844:	02800593          	li	a1,40
 848:	bff1                	j	824 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 84a:	008b8913          	add	s2,s7,8
 84e:	000bc583          	lbu	a1,0(s7)
 852:	8556                	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	dc2080e7          	jalr	-574(ra) # 616 <putc>
 85c:	8bca                	mv	s7,s2
      state = 0;
 85e:	4981                	li	s3,0
 860:	b5e1                	j	728 <vprintf+0x44>
        putc(fd, c);
 862:	02500593          	li	a1,37
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	dae080e7          	jalr	-594(ra) # 616 <putc>
      state = 0;
 870:	4981                	li	s3,0
 872:	bd5d                	j	728 <vprintf+0x44>
        putc(fd, '%');
 874:	02500593          	li	a1,37
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	d9c080e7          	jalr	-612(ra) # 616 <putc>
        putc(fd, c);
 882:	85ca                	mv	a1,s2
 884:	8556                	mv	a0,s5
 886:	00000097          	auipc	ra,0x0
 88a:	d90080e7          	jalr	-624(ra) # 616 <putc>
      state = 0;
 88e:	4981                	li	s3,0
 890:	bd61                	j	728 <vprintf+0x44>
        s = va_arg(ap, char*);
 892:	8bce                	mv	s7,s3
      state = 0;
 894:	4981                	li	s3,0
 896:	bd49                	j	728 <vprintf+0x44>
    }
  }
}
 898:	60a6                	ld	ra,72(sp)
 89a:	6406                	ld	s0,64(sp)
 89c:	74e2                	ld	s1,56(sp)
 89e:	7942                	ld	s2,48(sp)
 8a0:	79a2                	ld	s3,40(sp)
 8a2:	7a02                	ld	s4,32(sp)
 8a4:	6ae2                	ld	s5,24(sp)
 8a6:	6b42                	ld	s6,16(sp)
 8a8:	6ba2                	ld	s7,8(sp)
 8aa:	6c02                	ld	s8,0(sp)
 8ac:	6161                	add	sp,sp,80
 8ae:	8082                	ret

00000000000008b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b0:	715d                	add	sp,sp,-80
 8b2:	ec06                	sd	ra,24(sp)
 8b4:	e822                	sd	s0,16(sp)
 8b6:	1000                	add	s0,sp,32
 8b8:	e010                	sd	a2,0(s0)
 8ba:	e414                	sd	a3,8(s0)
 8bc:	e818                	sd	a4,16(s0)
 8be:	ec1c                	sd	a5,24(s0)
 8c0:	03043023          	sd	a6,32(s0)
 8c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8cc:	8622                	mv	a2,s0
 8ce:	00000097          	auipc	ra,0x0
 8d2:	e16080e7          	jalr	-490(ra) # 6e4 <vprintf>
}
 8d6:	60e2                	ld	ra,24(sp)
 8d8:	6442                	ld	s0,16(sp)
 8da:	6161                	add	sp,sp,80
 8dc:	8082                	ret

00000000000008de <printf>:

void
printf(const char *fmt, ...)
{
 8de:	711d                	add	sp,sp,-96
 8e0:	ec06                	sd	ra,24(sp)
 8e2:	e822                	sd	s0,16(sp)
 8e4:	1000                	add	s0,sp,32
 8e6:	e40c                	sd	a1,8(s0)
 8e8:	e810                	sd	a2,16(s0)
 8ea:	ec14                	sd	a3,24(s0)
 8ec:	f018                	sd	a4,32(s0)
 8ee:	f41c                	sd	a5,40(s0)
 8f0:	03043823          	sd	a6,48(s0)
 8f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f8:	00840613          	add	a2,s0,8
 8fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 900:	85aa                	mv	a1,a0
 902:	4505                	li	a0,1
 904:	00000097          	auipc	ra,0x0
 908:	de0080e7          	jalr	-544(ra) # 6e4 <vprintf>
}
 90c:	60e2                	ld	ra,24(sp)
 90e:	6442                	ld	s0,16(sp)
 910:	6125                	add	sp,sp,96
 912:	8082                	ret

0000000000000914 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 914:	1141                	add	sp,sp,-16
 916:	e422                	sd	s0,8(sp)
 918:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91e:	00000797          	auipc	a5,0x0
 922:	2827b783          	ld	a5,642(a5) # ba0 <freep>
 926:	a02d                	j	950 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 928:	4618                	lw	a4,8(a2)
 92a:	9f2d                	addw	a4,a4,a1
 92c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 930:	6398                	ld	a4,0(a5)
 932:	6310                	ld	a2,0(a4)
 934:	a83d                	j	972 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 936:	ff852703          	lw	a4,-8(a0)
 93a:	9f31                	addw	a4,a4,a2
 93c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 93e:	ff053683          	ld	a3,-16(a0)
 942:	a091                	j	986 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 944:	6398                	ld	a4,0(a5)
 946:	00e7e463          	bltu	a5,a4,94e <free+0x3a>
 94a:	00e6ea63          	bltu	a3,a4,95e <free+0x4a>
{
 94e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 950:	fed7fae3          	bgeu	a5,a3,944 <free+0x30>
 954:	6398                	ld	a4,0(a5)
 956:	00e6e463          	bltu	a3,a4,95e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	fee7eae3          	bltu	a5,a4,94e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 95e:	ff852583          	lw	a1,-8(a0)
 962:	6390                	ld	a2,0(a5)
 964:	02059813          	sll	a6,a1,0x20
 968:	01c85713          	srl	a4,a6,0x1c
 96c:	9736                	add	a4,a4,a3
 96e:	fae60de3          	beq	a2,a4,928 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 972:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 976:	4790                	lw	a2,8(a5)
 978:	02061593          	sll	a1,a2,0x20
 97c:	01c5d713          	srl	a4,a1,0x1c
 980:	973e                	add	a4,a4,a5
 982:	fae68ae3          	beq	a3,a4,936 <free+0x22>
    p->s.ptr = bp->s.ptr;
 986:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 988:	00000717          	auipc	a4,0x0
 98c:	20f73c23          	sd	a5,536(a4) # ba0 <freep>
}
 990:	6422                	ld	s0,8(sp)
 992:	0141                	add	sp,sp,16
 994:	8082                	ret

0000000000000996 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 996:	7139                	add	sp,sp,-64
 998:	fc06                	sd	ra,56(sp)
 99a:	f822                	sd	s0,48(sp)
 99c:	f426                	sd	s1,40(sp)
 99e:	f04a                	sd	s2,32(sp)
 9a0:	ec4e                	sd	s3,24(sp)
 9a2:	e852                	sd	s4,16(sp)
 9a4:	e456                	sd	s5,8(sp)
 9a6:	e05a                	sd	s6,0(sp)
 9a8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9aa:	02051493          	sll	s1,a0,0x20
 9ae:	9081                	srl	s1,s1,0x20
 9b0:	04bd                	add	s1,s1,15
 9b2:	8091                	srl	s1,s1,0x4
 9b4:	0014899b          	addw	s3,s1,1
 9b8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9ba:	00000517          	auipc	a0,0x0
 9be:	1e653503          	ld	a0,486(a0) # ba0 <freep>
 9c2:	c515                	beqz	a0,9ee <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c6:	4798                	lw	a4,8(a5)
 9c8:	02977f63          	bgeu	a4,s1,a06 <malloc+0x70>
  if(nu < 4096)
 9cc:	8a4e                	mv	s4,s3
 9ce:	0009871b          	sext.w	a4,s3
 9d2:	6685                	lui	a3,0x1
 9d4:	00d77363          	bgeu	a4,a3,9da <malloc+0x44>
 9d8:	6a05                	lui	s4,0x1
 9da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9de:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e2:	00000917          	auipc	s2,0x0
 9e6:	1be90913          	add	s2,s2,446 # ba0 <freep>
  if(p == (char*)-1)
 9ea:	5afd                	li	s5,-1
 9ec:	a895                	j	a60 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9ee:	00000797          	auipc	a5,0x0
 9f2:	1ca78793          	add	a5,a5,458 # bb8 <base>
 9f6:	00000717          	auipc	a4,0x0
 9fa:	1af73523          	sd	a5,426(a4) # ba0 <freep>
 9fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a00:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a04:	b7e1                	j	9cc <malloc+0x36>
      if(p->s.size == nunits)
 a06:	02e48c63          	beq	s1,a4,a3e <malloc+0xa8>
        p->s.size -= nunits;
 a0a:	4137073b          	subw	a4,a4,s3
 a0e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a10:	02071693          	sll	a3,a4,0x20
 a14:	01c6d713          	srl	a4,a3,0x1c
 a18:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a1a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a1e:	00000717          	auipc	a4,0x0
 a22:	18a73123          	sd	a0,386(a4) # ba0 <freep>
      return (void*)(p + 1);
 a26:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a2a:	70e2                	ld	ra,56(sp)
 a2c:	7442                	ld	s0,48(sp)
 a2e:	74a2                	ld	s1,40(sp)
 a30:	7902                	ld	s2,32(sp)
 a32:	69e2                	ld	s3,24(sp)
 a34:	6a42                	ld	s4,16(sp)
 a36:	6aa2                	ld	s5,8(sp)
 a38:	6b02                	ld	s6,0(sp)
 a3a:	6121                	add	sp,sp,64
 a3c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a3e:	6398                	ld	a4,0(a5)
 a40:	e118                	sd	a4,0(a0)
 a42:	bff1                	j	a1e <malloc+0x88>
  hp->s.size = nu;
 a44:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a48:	0541                	add	a0,a0,16
 a4a:	00000097          	auipc	ra,0x0
 a4e:	eca080e7          	jalr	-310(ra) # 914 <free>
  return freep;
 a52:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a56:	d971                	beqz	a0,a2a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a58:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a5a:	4798                	lw	a4,8(a5)
 a5c:	fa9775e3          	bgeu	a4,s1,a06 <malloc+0x70>
    if(p == freep)
 a60:	00093703          	ld	a4,0(s2)
 a64:	853e                	mv	a0,a5
 a66:	fef719e3          	bne	a4,a5,a58 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a6a:	8552                	mv	a0,s4
 a6c:	00000097          	auipc	ra,0x0
 a70:	b82080e7          	jalr	-1150(ra) # 5ee <sbrk>
  if(p == (char*)-1)
 a74:	fd5518e3          	bne	a0,s5,a44 <malloc+0xae>
        return 0;
 a78:	4501                	li	a0,0
 a7a:	bf45                	j	a2a <malloc+0x94>
