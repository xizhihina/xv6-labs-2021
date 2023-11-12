
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define MAXN 1024
#define MAXARG 1024
int
main(int argc, char *argv[])
{
   0:	7119                	add	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	add	s0,sp,128
  1e:	72f9                	lui	t0,0xffffe
  20:	81028293          	add	t0,t0,-2032 # ffffffffffffd810 <__global_pointer$+0xffffffffffffc6af>
  24:	9116                	add	sp,sp,t0
    // 如果参数个数小于 2
    if (argc < 2) {
  26:	4785                	li	a5,1
  28:	0aa7df63          	bge	a5,a0,e6 <main+0xe6>
  2c:	8d2e                	mv	s10,a1
  2e:	00858713          	add	a4,a1,8
  32:	77f9                	lui	a5,0xffffe
  34:	f9078793          	add	a5,a5,-112 # ffffffffffffdf90 <__global_pointer$+0xffffffffffffce2f>
  38:	97a2                	add	a5,a5,s0
  3a:	0005049b          	sext.w	s1,a0
  3e:	ffe5069b          	addw	a3,a0,-2
  42:	02069613          	sll	a2,a3,0x20
  46:	01d65693          	srl	a3,a2,0x1d
  4a:	00878613          	add	a2,a5,8
  4e:	96b2                	add	a3,a3,a2
    char * argvs[MAXARG];
    // 索引
    int index = 0;
    // 略去 xargs ，用来保存命令行参数
    for (int i = 1; i < argc; ++i) {
        argvs[index++] = argv[i];
  50:	6310                	ld	a2,0(a4)
  52:	e390                	sd	a2,0(a5)
    for (int i = 1; i < argc; ++i) {
  54:	0721                	add	a4,a4,8
  56:	07a1                	add	a5,a5,8
  58:	fed79ce3          	bne	a5,a3,50 <main+0x50>
        argvs[index++] = argv[i];
  5c:	34fd                	addw	s1,s1,-1
    }
    // 缓冲区存放从管道读出的数据
    char buf[MAXN] = {"\0"};
  5e:	7579                	lui	a0,0xffffe
  60:	f9050793          	add	a5,a0,-112 # ffffffffffffdf90 <__global_pointer$+0xffffffffffffce2f>
  64:	00878533          	add	a0,a5,s0
  68:	c0053023          	sd	zero,-1024(a0)
  6c:	3f800613          	li	a2,1016
  70:	4581                	li	a1,0
  72:	c0850513          	add	a0,a0,-1016
  76:	00000097          	auipc	ra,0x0
  7a:	150080e7          	jalr	336(ra) # 1c6 <memset>
    
    int n;
	// 0 代表的是管道的 0，也就是从管道循环读取数据
    while((n = read(0, buf, MAXN)) > 0 ) {
  7e:	77f9                	lui	a5,0xffffe
  80:	c0078c93          	add	s9,a5,-1024 # ffffffffffffdc00 <__global_pointer$+0xffffffffffffca9f>
  84:	f90c8713          	add	a4,s9,-112
  88:	00870a33          	add	s4,a4,s0
        // 临时缓冲区存放追加的参数
		char temp[MAXN] = {"\0"};
  8c:	f9078713          	add	a4,a5,-112
  90:	00870bb3          	add	s7,a4,s0
  94:	808b8d93          	add	s11,s7,-2040
        // xargs 命令的参数后面再追加参数
        argvs[index] = temp;
  98:	048e                	sll	s1,s1,0x3
  9a:	009b8c33          	add	s8,s7,s1
  9e:	80078793          	add	a5,a5,-2048
  a2:	f9078793          	add	a5,a5,-112
  a6:	00878b33          	add	s6,a5,s0
    while((n = read(0, buf, MAXN)) > 0 ) {
  aa:	40000613          	li	a2,1024
  ae:	85d2                	mv	a1,s4
  b0:	4501                	li	a0,0
  b2:	00000097          	auipc	ra,0x0
  b6:	326080e7          	jalr	806(ra) # 3d8 <read>
  ba:	08a05863          	blez	a0,14a <main+0x14a>
		char temp[MAXN] = {"\0"};
  be:	800bb023          	sd	zero,-2048(s7)
  c2:	3f800613          	li	a2,1016
  c6:	4581                	li	a1,0
  c8:	856e                	mv	a0,s11
  ca:	00000097          	auipc	ra,0x0
  ce:	0fc080e7          	jalr	252(ra) # 1c6 <memset>
        argvs[index] = temp;
  d2:	016c3023          	sd	s6,0(s8)
        // 内循环获取追加的参数并创建子进程执行命令
        for(int i = 0; i < strlen(buf); ++i) {
  d6:	89da                	mv	s3,s6
  d8:	f90c8793          	add	a5,s9,-112
  dc:	00878933          	add	s2,a5,s0
  e0:	4481                	li	s1,0
            // 读取单个输入行，当遇到换行符时，创建子线程
            if(buf[i] == '\n') {
  e2:	4aa9                	li	s5,10
        for(int i = 0; i < strlen(buf); ++i) {
  e4:	a825                	j	11c <main+0x11c>
        fprintf(2, "usage: xargs command\n");
  e6:	00000597          	auipc	a1,0x0
  ea:	7f258593          	add	a1,a1,2034 # 8d8 <malloc+0xe8>
  ee:	4509                	li	a0,2
  f0:	00000097          	auipc	ra,0x0
  f4:	61a080e7          	jalr	1562(ra) # 70a <fprintf>
        exit(1);
  f8:	4505                	li	a0,1
  fa:	00000097          	auipc	ra,0x0
  fe:	2c6080e7          	jalr	710(ra) # 3c0 <exit>
                // 创建子线程执行命令
                if (fork() == 0) {
 102:	00000097          	auipc	ra,0x0
 106:	2b6080e7          	jalr	694(ra) # 3b8 <fork>
 10a:	c905                	beqz	a0,13a <main+0x13a>
                    exec(argv[1], argvs);
                }
                // 等待子线程执行完毕
                wait(0);
 10c:	4501                	li	a0,0
 10e:	00000097          	auipc	ra,0x0
 112:	2ba080e7          	jalr	698(ra) # 3c8 <wait>
        for(int i = 0; i < strlen(buf); ++i) {
 116:	2485                	addw	s1,s1,1
 118:	0985                	add	s3,s3,1
 11a:	0905                	add	s2,s2,1
 11c:	8552                	mv	a0,s4
 11e:	00000097          	auipc	ra,0x0
 122:	07e080e7          	jalr	126(ra) # 19c <strlen>
 126:	2501                	sext.w	a0,a0
 128:	f8a4f1e3          	bgeu	s1,a0,aa <main+0xaa>
            if(buf[i] == '\n') {
 12c:	00094783          	lbu	a5,0(s2)
 130:	fd5789e3          	beq	a5,s5,102 <main+0x102>
            } else {
                // 否则，读取管道的输出作为输入
                temp[i] = buf[i];
 134:	00f98023          	sb	a5,0(s3)
 138:	bff9                	j	116 <main+0x116>
                    exec(argv[1], argvs);
 13a:	85de                	mv	a1,s7
 13c:	008d3503          	ld	a0,8(s10)
 140:	00000097          	auipc	ra,0x0
 144:	2b8080e7          	jalr	696(ra) # 3f8 <exec>
 148:	b7d1                	j	10c <main+0x10c>
            }
        }
    }
    // 正常退出
    exit(0);
 14a:	4501                	li	a0,0
 14c:	00000097          	auipc	ra,0x0
 150:	274080e7          	jalr	628(ra) # 3c0 <exit>

0000000000000154 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 154:	1141                	add	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15a:	87aa                	mv	a5,a0
 15c:	0585                	add	a1,a1,1
 15e:	0785                	add	a5,a5,1
 160:	fff5c703          	lbu	a4,-1(a1)
 164:	fee78fa3          	sb	a4,-1(a5)
 168:	fb75                	bnez	a4,15c <strcpy+0x8>
    ;
  return os;
}
 16a:	6422                	ld	s0,8(sp)
 16c:	0141                	add	sp,sp,16
 16e:	8082                	ret

0000000000000170 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 170:	1141                	add	sp,sp,-16
 172:	e422                	sd	s0,8(sp)
 174:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 176:	00054783          	lbu	a5,0(a0)
 17a:	cb91                	beqz	a5,18e <strcmp+0x1e>
 17c:	0005c703          	lbu	a4,0(a1)
 180:	00f71763          	bne	a4,a5,18e <strcmp+0x1e>
    p++, q++;
 184:	0505                	add	a0,a0,1
 186:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 188:	00054783          	lbu	a5,0(a0)
 18c:	fbe5                	bnez	a5,17c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 18e:	0005c503          	lbu	a0,0(a1)
}
 192:	40a7853b          	subw	a0,a5,a0
 196:	6422                	ld	s0,8(sp)
 198:	0141                	add	sp,sp,16
 19a:	8082                	ret

000000000000019c <strlen>:

uint
strlen(const char *s)
{
 19c:	1141                	add	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cf91                	beqz	a5,1c2 <strlen+0x26>
 1a8:	0505                	add	a0,a0,1
 1aa:	87aa                	mv	a5,a0
 1ac:	86be                	mv	a3,a5
 1ae:	0785                	add	a5,a5,1
 1b0:	fff7c703          	lbu	a4,-1(a5)
 1b4:	ff65                	bnez	a4,1ac <strlen+0x10>
 1b6:	40a6853b          	subw	a0,a3,a0
 1ba:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1bc:	6422                	ld	s0,8(sp)
 1be:	0141                	add	sp,sp,16
 1c0:	8082                	ret
  for(n = 0; s[n]; n++)
 1c2:	4501                	li	a0,0
 1c4:	bfe5                	j	1bc <strlen+0x20>

00000000000001c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c6:	1141                	add	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1cc:	ca19                	beqz	a2,1e2 <memset+0x1c>
 1ce:	87aa                	mv	a5,a0
 1d0:	1602                	sll	a2,a2,0x20
 1d2:	9201                	srl	a2,a2,0x20
 1d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1dc:	0785                	add	a5,a5,1
 1de:	fee79de3          	bne	a5,a4,1d8 <memset+0x12>
  }
  return dst;
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	add	sp,sp,16
 1e6:	8082                	ret

00000000000001e8 <strchr>:

char*
strchr(const char *s, char c)
{
 1e8:	1141                	add	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	add	s0,sp,16
  for(; *s; s++)
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	cb99                	beqz	a5,208 <strchr+0x20>
    if(*s == c)
 1f4:	00f58763          	beq	a1,a5,202 <strchr+0x1a>
  for(; *s; s++)
 1f8:	0505                	add	a0,a0,1
 1fa:	00054783          	lbu	a5,0(a0)
 1fe:	fbfd                	bnez	a5,1f4 <strchr+0xc>
      return (char*)s;
  return 0;
 200:	4501                	li	a0,0
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	add	sp,sp,16
 206:	8082                	ret
  return 0;
 208:	4501                	li	a0,0
 20a:	bfe5                	j	202 <strchr+0x1a>

000000000000020c <gets>:

char*
gets(char *buf, int max)
{
 20c:	711d                	add	sp,sp,-96
 20e:	ec86                	sd	ra,88(sp)
 210:	e8a2                	sd	s0,80(sp)
 212:	e4a6                	sd	s1,72(sp)
 214:	e0ca                	sd	s2,64(sp)
 216:	fc4e                	sd	s3,56(sp)
 218:	f852                	sd	s4,48(sp)
 21a:	f456                	sd	s5,40(sp)
 21c:	f05a                	sd	s6,32(sp)
 21e:	ec5e                	sd	s7,24(sp)
 220:	1080                	add	s0,sp,96
 222:	8baa                	mv	s7,a0
 224:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 226:	892a                	mv	s2,a0
 228:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 22a:	4aa9                	li	s5,10
 22c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 22e:	89a6                	mv	s3,s1
 230:	2485                	addw	s1,s1,1
 232:	0344d863          	bge	s1,s4,262 <gets+0x56>
    cc = read(0, &c, 1);
 236:	4605                	li	a2,1
 238:	faf40593          	add	a1,s0,-81
 23c:	4501                	li	a0,0
 23e:	00000097          	auipc	ra,0x0
 242:	19a080e7          	jalr	410(ra) # 3d8 <read>
    if(cc < 1)
 246:	00a05e63          	blez	a0,262 <gets+0x56>
    buf[i++] = c;
 24a:	faf44783          	lbu	a5,-81(s0)
 24e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 252:	01578763          	beq	a5,s5,260 <gets+0x54>
 256:	0905                	add	s2,s2,1
 258:	fd679be3          	bne	a5,s6,22e <gets+0x22>
  for(i=0; i+1 < max; ){
 25c:	89a6                	mv	s3,s1
 25e:	a011                	j	262 <gets+0x56>
 260:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 262:	99de                	add	s3,s3,s7
 264:	00098023          	sb	zero,0(s3)
  return buf;
}
 268:	855e                	mv	a0,s7
 26a:	60e6                	ld	ra,88(sp)
 26c:	6446                	ld	s0,80(sp)
 26e:	64a6                	ld	s1,72(sp)
 270:	6906                	ld	s2,64(sp)
 272:	79e2                	ld	s3,56(sp)
 274:	7a42                	ld	s4,48(sp)
 276:	7aa2                	ld	s5,40(sp)
 278:	7b02                	ld	s6,32(sp)
 27a:	6be2                	ld	s7,24(sp)
 27c:	6125                	add	sp,sp,96
 27e:	8082                	ret

0000000000000280 <stat>:

int
stat(const char *n, struct stat *st)
{
 280:	1101                	add	sp,sp,-32
 282:	ec06                	sd	ra,24(sp)
 284:	e822                	sd	s0,16(sp)
 286:	e426                	sd	s1,8(sp)
 288:	e04a                	sd	s2,0(sp)
 28a:	1000                	add	s0,sp,32
 28c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28e:	4581                	li	a1,0
 290:	00000097          	auipc	ra,0x0
 294:	170080e7          	jalr	368(ra) # 400 <open>
  if(fd < 0)
 298:	02054563          	bltz	a0,2c2 <stat+0x42>
 29c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 29e:	85ca                	mv	a1,s2
 2a0:	00000097          	auipc	ra,0x0
 2a4:	178080e7          	jalr	376(ra) # 418 <fstat>
 2a8:	892a                	mv	s2,a0
  close(fd);
 2aa:	8526                	mv	a0,s1
 2ac:	00000097          	auipc	ra,0x0
 2b0:	13c080e7          	jalr	316(ra) # 3e8 <close>
  return r;
}
 2b4:	854a                	mv	a0,s2
 2b6:	60e2                	ld	ra,24(sp)
 2b8:	6442                	ld	s0,16(sp)
 2ba:	64a2                	ld	s1,8(sp)
 2bc:	6902                	ld	s2,0(sp)
 2be:	6105                	add	sp,sp,32
 2c0:	8082                	ret
    return -1;
 2c2:	597d                	li	s2,-1
 2c4:	bfc5                	j	2b4 <stat+0x34>

00000000000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	1141                	add	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cc:	00054683          	lbu	a3,0(a0)
 2d0:	fd06879b          	addw	a5,a3,-48
 2d4:	0ff7f793          	zext.b	a5,a5
 2d8:	4625                	li	a2,9
 2da:	02f66863          	bltu	a2,a5,30a <atoi+0x44>
 2de:	872a                	mv	a4,a0
  n = 0;
 2e0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2e2:	0705                	add	a4,a4,1
 2e4:	0025179b          	sllw	a5,a0,0x2
 2e8:	9fa9                	addw	a5,a5,a0
 2ea:	0017979b          	sllw	a5,a5,0x1
 2ee:	9fb5                	addw	a5,a5,a3
 2f0:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f4:	00074683          	lbu	a3,0(a4)
 2f8:	fd06879b          	addw	a5,a3,-48
 2fc:	0ff7f793          	zext.b	a5,a5
 300:	fef671e3          	bgeu	a2,a5,2e2 <atoi+0x1c>
  return n;
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	add	sp,sp,16
 308:	8082                	ret
  n = 0;
 30a:	4501                	li	a0,0
 30c:	bfe5                	j	304 <atoi+0x3e>

000000000000030e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 30e:	1141                	add	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 314:	02b57463          	bgeu	a0,a1,33c <memmove+0x2e>
    while(n-- > 0)
 318:	00c05f63          	blez	a2,336 <memmove+0x28>
 31c:	1602                	sll	a2,a2,0x20
 31e:	9201                	srl	a2,a2,0x20
 320:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 324:	872a                	mv	a4,a0
      *dst++ = *src++;
 326:	0585                	add	a1,a1,1
 328:	0705                	add	a4,a4,1
 32a:	fff5c683          	lbu	a3,-1(a1)
 32e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	add	sp,sp,16
 33a:	8082                	ret
    dst += n;
 33c:	00c50733          	add	a4,a0,a2
    src += n;
 340:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 342:	fec05ae3          	blez	a2,336 <memmove+0x28>
 346:	fff6079b          	addw	a5,a2,-1
 34a:	1782                	sll	a5,a5,0x20
 34c:	9381                	srl	a5,a5,0x20
 34e:	fff7c793          	not	a5,a5
 352:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 354:	15fd                	add	a1,a1,-1
 356:	177d                	add	a4,a4,-1
 358:	0005c683          	lbu	a3,0(a1)
 35c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 360:	fee79ae3          	bne	a5,a4,354 <memmove+0x46>
 364:	bfc9                	j	336 <memmove+0x28>

0000000000000366 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 366:	1141                	add	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 36c:	ca05                	beqz	a2,39c <memcmp+0x36>
 36e:	fff6069b          	addw	a3,a2,-1
 372:	1682                	sll	a3,a3,0x20
 374:	9281                	srl	a3,a3,0x20
 376:	0685                	add	a3,a3,1
 378:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 37a:	00054783          	lbu	a5,0(a0)
 37e:	0005c703          	lbu	a4,0(a1)
 382:	00e79863          	bne	a5,a4,392 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 386:	0505                	add	a0,a0,1
    p2++;
 388:	0585                	add	a1,a1,1
  while (n-- > 0) {
 38a:	fed518e3          	bne	a0,a3,37a <memcmp+0x14>
  }
  return 0;
 38e:	4501                	li	a0,0
 390:	a019                	j	396 <memcmp+0x30>
      return *p1 - *p2;
 392:	40e7853b          	subw	a0,a5,a4
}
 396:	6422                	ld	s0,8(sp)
 398:	0141                	add	sp,sp,16
 39a:	8082                	ret
  return 0;
 39c:	4501                	li	a0,0
 39e:	bfe5                	j	396 <memcmp+0x30>

00000000000003a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a0:	1141                	add	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 3a8:	00000097          	auipc	ra,0x0
 3ac:	f66080e7          	jalr	-154(ra) # 30e <memmove>
}
 3b0:	60a2                	ld	ra,8(sp)
 3b2:	6402                	ld	s0,0(sp)
 3b4:	0141                	add	sp,sp,16
 3b6:	8082                	ret

00000000000003b8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b8:	4885                	li	a7,1
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c0:	4889                	li	a7,2
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c8:	488d                	li	a7,3
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d0:	4891                	li	a7,4
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <read>:
.global read
read:
 li a7, SYS_read
 3d8:	4895                	li	a7,5
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <write>:
.global write
write:
 li a7, SYS_write
 3e0:	48c1                	li	a7,16
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <close>:
.global close
close:
 li a7, SYS_close
 3e8:	48d5                	li	a7,21
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f0:	4899                	li	a7,6
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f8:	489d                	li	a7,7
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <open>:
.global open
open:
 li a7, SYS_open
 400:	48bd                	li	a7,15
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 408:	48c5                	li	a7,17
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 410:	48c9                	li	a7,18
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 418:	48a1                	li	a7,8
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <link>:
.global link
link:
 li a7, SYS_link
 420:	48cd                	li	a7,19
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 428:	48d1                	li	a7,20
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 430:	48a5                	li	a7,9
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <dup>:
.global dup
dup:
 li a7, SYS_dup
 438:	48a9                	li	a7,10
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 440:	48ad                	li	a7,11
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 448:	48b1                	li	a7,12
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 450:	48b5                	li	a7,13
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 458:	48b9                	li	a7,14
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <trace>:
.global trace
trace:
 li a7, SYS_trace
 460:	48d9                	li	a7,22
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 468:	48dd                	li	a7,23
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 470:	1101                	add	sp,sp,-32
 472:	ec06                	sd	ra,24(sp)
 474:	e822                	sd	s0,16(sp)
 476:	1000                	add	s0,sp,32
 478:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47c:	4605                	li	a2,1
 47e:	fef40593          	add	a1,s0,-17
 482:	00000097          	auipc	ra,0x0
 486:	f5e080e7          	jalr	-162(ra) # 3e0 <write>
}
 48a:	60e2                	ld	ra,24(sp)
 48c:	6442                	ld	s0,16(sp)
 48e:	6105                	add	sp,sp,32
 490:	8082                	ret

0000000000000492 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 492:	7139                	add	sp,sp,-64
 494:	fc06                	sd	ra,56(sp)
 496:	f822                	sd	s0,48(sp)
 498:	f426                	sd	s1,40(sp)
 49a:	f04a                	sd	s2,32(sp)
 49c:	ec4e                	sd	s3,24(sp)
 49e:	0080                	add	s0,sp,64
 4a0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a2:	c299                	beqz	a3,4a8 <printint+0x16>
 4a4:	0805c963          	bltz	a1,536 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a8:	2581                	sext.w	a1,a1
  neg = 0;
 4aa:	4881                	li	a7,0
 4ac:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b2:	2601                	sext.w	a2,a2
 4b4:	00000517          	auipc	a0,0x0
 4b8:	49c50513          	add	a0,a0,1180 # 950 <digits>
 4bc:	883a                	mv	a6,a4
 4be:	2705                	addw	a4,a4,1
 4c0:	02c5f7bb          	remuw	a5,a1,a2
 4c4:	1782                	sll	a5,a5,0x20
 4c6:	9381                	srl	a5,a5,0x20
 4c8:	97aa                	add	a5,a5,a0
 4ca:	0007c783          	lbu	a5,0(a5)
 4ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d2:	0005879b          	sext.w	a5,a1
 4d6:	02c5d5bb          	divuw	a1,a1,a2
 4da:	0685                	add	a3,a3,1
 4dc:	fec7f0e3          	bgeu	a5,a2,4bc <printint+0x2a>
  if(neg)
 4e0:	00088c63          	beqz	a7,4f8 <printint+0x66>
    buf[i++] = '-';
 4e4:	fd070793          	add	a5,a4,-48
 4e8:	00878733          	add	a4,a5,s0
 4ec:	02d00793          	li	a5,45
 4f0:	fef70823          	sb	a5,-16(a4)
 4f4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4f8:	02e05863          	blez	a4,528 <printint+0x96>
 4fc:	fc040793          	add	a5,s0,-64
 500:	00e78933          	add	s2,a5,a4
 504:	fff78993          	add	s3,a5,-1
 508:	99ba                	add	s3,s3,a4
 50a:	377d                	addw	a4,a4,-1
 50c:	1702                	sll	a4,a4,0x20
 50e:	9301                	srl	a4,a4,0x20
 510:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 514:	fff94583          	lbu	a1,-1(s2)
 518:	8526                	mv	a0,s1
 51a:	00000097          	auipc	ra,0x0
 51e:	f56080e7          	jalr	-170(ra) # 470 <putc>
  while(--i >= 0)
 522:	197d                	add	s2,s2,-1
 524:	ff3918e3          	bne	s2,s3,514 <printint+0x82>
}
 528:	70e2                	ld	ra,56(sp)
 52a:	7442                	ld	s0,48(sp)
 52c:	74a2                	ld	s1,40(sp)
 52e:	7902                	ld	s2,32(sp)
 530:	69e2                	ld	s3,24(sp)
 532:	6121                	add	sp,sp,64
 534:	8082                	ret
    x = -xx;
 536:	40b005bb          	negw	a1,a1
    neg = 1;
 53a:	4885                	li	a7,1
    x = -xx;
 53c:	bf85                	j	4ac <printint+0x1a>

000000000000053e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53e:	715d                	add	sp,sp,-80
 540:	e486                	sd	ra,72(sp)
 542:	e0a2                	sd	s0,64(sp)
 544:	fc26                	sd	s1,56(sp)
 546:	f84a                	sd	s2,48(sp)
 548:	f44e                	sd	s3,40(sp)
 54a:	f052                	sd	s4,32(sp)
 54c:	ec56                	sd	s5,24(sp)
 54e:	e85a                	sd	s6,16(sp)
 550:	e45e                	sd	s7,8(sp)
 552:	e062                	sd	s8,0(sp)
 554:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 556:	0005c903          	lbu	s2,0(a1)
 55a:	18090c63          	beqz	s2,6f2 <vprintf+0x1b4>
 55e:	8aaa                	mv	s5,a0
 560:	8bb2                	mv	s7,a2
 562:	00158493          	add	s1,a1,1
  state = 0;
 566:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 568:	02500a13          	li	s4,37
 56c:	4b55                	li	s6,21
 56e:	a839                	j	58c <vprintf+0x4e>
        putc(fd, c);
 570:	85ca                	mv	a1,s2
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	efc080e7          	jalr	-260(ra) # 470 <putc>
 57c:	a019                	j	582 <vprintf+0x44>
    } else if(state == '%'){
 57e:	01498d63          	beq	s3,s4,598 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 582:	0485                	add	s1,s1,1
 584:	fff4c903          	lbu	s2,-1(s1)
 588:	16090563          	beqz	s2,6f2 <vprintf+0x1b4>
    if(state == 0){
 58c:	fe0999e3          	bnez	s3,57e <vprintf+0x40>
      if(c == '%'){
 590:	ff4910e3          	bne	s2,s4,570 <vprintf+0x32>
        state = '%';
 594:	89d2                	mv	s3,s4
 596:	b7f5                	j	582 <vprintf+0x44>
      if(c == 'd'){
 598:	13490263          	beq	s2,s4,6bc <vprintf+0x17e>
 59c:	f9d9079b          	addw	a5,s2,-99
 5a0:	0ff7f793          	zext.b	a5,a5
 5a4:	12fb6563          	bltu	s6,a5,6ce <vprintf+0x190>
 5a8:	f9d9079b          	addw	a5,s2,-99
 5ac:	0ff7f713          	zext.b	a4,a5
 5b0:	10eb6f63          	bltu	s6,a4,6ce <vprintf+0x190>
 5b4:	00271793          	sll	a5,a4,0x2
 5b8:	00000717          	auipc	a4,0x0
 5bc:	34070713          	add	a4,a4,832 # 8f8 <malloc+0x108>
 5c0:	97ba                	add	a5,a5,a4
 5c2:	439c                	lw	a5,0(a5)
 5c4:	97ba                	add	a5,a5,a4
 5c6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5c8:	008b8913          	add	s2,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	ebc080e7          	jalr	-324(ra) # 492 <printint>
 5de:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b745                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	008b8913          	add	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4629                	li	a2,10
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	ea0080e7          	jalr	-352(ra) # 492 <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b751                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 600:	008b8913          	add	s2,s7,8
 604:	4681                	li	a3,0
 606:	4641                	li	a2,16
 608:	000ba583          	lw	a1,0(s7)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e84080e7          	jalr	-380(ra) # 492 <printint>
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
 61a:	b7a5                	j	582 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 61c:	008b8c13          	add	s8,s7,8
 620:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 624:	03000593          	li	a1,48
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	e46080e7          	jalr	-442(ra) # 470 <putc>
  putc(fd, 'x');
 632:	07800593          	li	a1,120
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e38080e7          	jalr	-456(ra) # 470 <putc>
 640:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 642:	00000b97          	auipc	s7,0x0
 646:	30eb8b93          	add	s7,s7,782 # 950 <digits>
 64a:	03c9d793          	srl	a5,s3,0x3c
 64e:	97de                	add	a5,a5,s7
 650:	0007c583          	lbu	a1,0(a5)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e1a080e7          	jalr	-486(ra) # 470 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65e:	0992                	sll	s3,s3,0x4
 660:	397d                	addw	s2,s2,-1
 662:	fe0914e3          	bnez	s2,64a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 666:	8be2                	mv	s7,s8
      state = 0;
 668:	4981                	li	s3,0
 66a:	bf21                	j	582 <vprintf+0x44>
        s = va_arg(ap, char*);
 66c:	008b8993          	add	s3,s7,8
 670:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 674:	02090163          	beqz	s2,696 <vprintf+0x158>
        while(*s != 0){
 678:	00094583          	lbu	a1,0(s2)
 67c:	c9a5                	beqz	a1,6ec <vprintf+0x1ae>
          putc(fd, *s);
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	df0080e7          	jalr	-528(ra) # 470 <putc>
          s++;
 688:	0905                	add	s2,s2,1
        while(*s != 0){
 68a:	00094583          	lbu	a1,0(s2)
 68e:	f9e5                	bnez	a1,67e <vprintf+0x140>
        s = va_arg(ap, char*);
 690:	8bce                	mv	s7,s3
      state = 0;
 692:	4981                	li	s3,0
 694:	b5fd                	j	582 <vprintf+0x44>
          s = "(null)";
 696:	00000917          	auipc	s2,0x0
 69a:	25a90913          	add	s2,s2,602 # 8f0 <malloc+0x100>
        while(*s != 0){
 69e:	02800593          	li	a1,40
 6a2:	bff1                	j	67e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6a4:	008b8913          	add	s2,s7,8
 6a8:	000bc583          	lbu	a1,0(s7)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	dc2080e7          	jalr	-574(ra) # 470 <putc>
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b5e1                	j	582 <vprintf+0x44>
        putc(fd, c);
 6bc:	02500593          	li	a1,37
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	dae080e7          	jalr	-594(ra) # 470 <putc>
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bd5d                	j	582 <vprintf+0x44>
        putc(fd, '%');
 6ce:	02500593          	li	a1,37
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	d9c080e7          	jalr	-612(ra) # 470 <putc>
        putc(fd, c);
 6dc:	85ca                	mv	a1,s2
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	d90080e7          	jalr	-624(ra) # 470 <putc>
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd61                	j	582 <vprintf+0x44>
        s = va_arg(ap, char*);
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bd49                	j	582 <vprintf+0x44>
    }
  }
}
 6f2:	60a6                	ld	ra,72(sp)
 6f4:	6406                	ld	s0,64(sp)
 6f6:	74e2                	ld	s1,56(sp)
 6f8:	7942                	ld	s2,48(sp)
 6fa:	79a2                	ld	s3,40(sp)
 6fc:	7a02                	ld	s4,32(sp)
 6fe:	6ae2                	ld	s5,24(sp)
 700:	6b42                	ld	s6,16(sp)
 702:	6ba2                	ld	s7,8(sp)
 704:	6c02                	ld	s8,0(sp)
 706:	6161                	add	sp,sp,80
 708:	8082                	ret

000000000000070a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70a:	715d                	add	sp,sp,-80
 70c:	ec06                	sd	ra,24(sp)
 70e:	e822                	sd	s0,16(sp)
 710:	1000                	add	s0,sp,32
 712:	e010                	sd	a2,0(s0)
 714:	e414                	sd	a3,8(s0)
 716:	e818                	sd	a4,16(s0)
 718:	ec1c                	sd	a5,24(s0)
 71a:	03043023          	sd	a6,32(s0)
 71e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 722:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 726:	8622                	mv	a2,s0
 728:	00000097          	auipc	ra,0x0
 72c:	e16080e7          	jalr	-490(ra) # 53e <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6161                	add	sp,sp,80
 736:	8082                	ret

0000000000000738 <printf>:

void
printf(const char *fmt, ...)
{
 738:	711d                	add	sp,sp,-96
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	add	s0,sp,32
 740:	e40c                	sd	a1,8(s0)
 742:	e810                	sd	a2,16(s0)
 744:	ec14                	sd	a3,24(s0)
 746:	f018                	sd	a4,32(s0)
 748:	f41c                	sd	a5,40(s0)
 74a:	03043823          	sd	a6,48(s0)
 74e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	00840613          	add	a2,s0,8
 756:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75a:	85aa                	mv	a1,a0
 75c:	4505                	li	a0,1
 75e:	00000097          	auipc	ra,0x0
 762:	de0080e7          	jalr	-544(ra) # 53e <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6125                	add	sp,sp,96
 76c:	8082                	ret

000000000000076e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76e:	1141                	add	sp,sp,-16
 770:	e422                	sd	s0,8(sp)
 772:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 774:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	00000797          	auipc	a5,0x0
 77c:	1f07b783          	ld	a5,496(a5) # 968 <freep>
 780:	a02d                	j	7aa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 782:	4618                	lw	a4,8(a2)
 784:	9f2d                	addw	a4,a4,a1
 786:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	6310                	ld	a2,0(a4)
 78e:	a83d                	j	7cc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 790:	ff852703          	lw	a4,-8(a0)
 794:	9f31                	addw	a4,a4,a2
 796:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 798:	ff053683          	ld	a3,-16(a0)
 79c:	a091                	j	7e0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e7e463          	bltu	a5,a4,7a8 <free+0x3a>
 7a4:	00e6ea63          	bltu	a3,a4,7b8 <free+0x4a>
{
 7a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	fed7fae3          	bgeu	a5,a3,79e <free+0x30>
 7ae:	6398                	ld	a4,0(a5)
 7b0:	00e6e463          	bltu	a3,a4,7b8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	fee7eae3          	bltu	a5,a4,7a8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b8:	ff852583          	lw	a1,-8(a0)
 7bc:	6390                	ld	a2,0(a5)
 7be:	02059813          	sll	a6,a1,0x20
 7c2:	01c85713          	srl	a4,a6,0x1c
 7c6:	9736                	add	a4,a4,a3
 7c8:	fae60de3          	beq	a2,a4,782 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d0:	4790                	lw	a2,8(a5)
 7d2:	02061593          	sll	a1,a2,0x20
 7d6:	01c5d713          	srl	a4,a1,0x1c
 7da:	973e                	add	a4,a4,a5
 7dc:	fae68ae3          	beq	a3,a4,790 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e2:	00000717          	auipc	a4,0x0
 7e6:	18f73323          	sd	a5,390(a4) # 968 <freep>
}
 7ea:	6422                	ld	s0,8(sp)
 7ec:	0141                	add	sp,sp,16
 7ee:	8082                	ret

00000000000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	7139                	add	sp,sp,-64
 7f2:	fc06                	sd	ra,56(sp)
 7f4:	f822                	sd	s0,48(sp)
 7f6:	f426                	sd	s1,40(sp)
 7f8:	f04a                	sd	s2,32(sp)
 7fa:	ec4e                	sd	s3,24(sp)
 7fc:	e852                	sd	s4,16(sp)
 7fe:	e456                	sd	s5,8(sp)
 800:	e05a                	sd	s6,0(sp)
 802:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 804:	02051493          	sll	s1,a0,0x20
 808:	9081                	srl	s1,s1,0x20
 80a:	04bd                	add	s1,s1,15
 80c:	8091                	srl	s1,s1,0x4
 80e:	0014899b          	addw	s3,s1,1
 812:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 814:	00000517          	auipc	a0,0x0
 818:	15453503          	ld	a0,340(a0) # 968 <freep>
 81c:	c515                	beqz	a0,848 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	02977f63          	bgeu	a4,s1,860 <malloc+0x70>
  if(nu < 4096)
 826:	8a4e                	mv	s4,s3
 828:	0009871b          	sext.w	a4,s3
 82c:	6685                	lui	a3,0x1
 82e:	00d77363          	bgeu	a4,a3,834 <malloc+0x44>
 832:	6a05                	lui	s4,0x1
 834:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 838:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83c:	00000917          	auipc	s2,0x0
 840:	12c90913          	add	s2,s2,300 # 968 <freep>
  if(p == (char*)-1)
 844:	5afd                	li	s5,-1
 846:	a895                	j	8ba <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 848:	00000797          	auipc	a5,0x0
 84c:	12878793          	add	a5,a5,296 # 970 <base>
 850:	00000717          	auipc	a4,0x0
 854:	10f73c23          	sd	a5,280(a4) # 968 <freep>
 858:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85e:	b7e1                	j	826 <malloc+0x36>
      if(p->s.size == nunits)
 860:	02e48c63          	beq	s1,a4,898 <malloc+0xa8>
        p->s.size -= nunits;
 864:	4137073b          	subw	a4,a4,s3
 868:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86a:	02071693          	sll	a3,a4,0x20
 86e:	01c6d713          	srl	a4,a3,0x1c
 872:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 874:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 878:	00000717          	auipc	a4,0x0
 87c:	0ea73823          	sd	a0,240(a4) # 968 <freep>
      return (void*)(p + 1);
 880:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 884:	70e2                	ld	ra,56(sp)
 886:	7442                	ld	s0,48(sp)
 888:	74a2                	ld	s1,40(sp)
 88a:	7902                	ld	s2,32(sp)
 88c:	69e2                	ld	s3,24(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	6121                	add	sp,sp,64
 896:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	e118                	sd	a4,0(a0)
 89c:	bff1                	j	878 <malloc+0x88>
  hp->s.size = nu;
 89e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a2:	0541                	add	a0,a0,16
 8a4:	00000097          	auipc	ra,0x0
 8a8:	eca080e7          	jalr	-310(ra) # 76e <free>
  return freep;
 8ac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b0:	d971                	beqz	a0,884 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b4:	4798                	lw	a4,8(a5)
 8b6:	fa9775e3          	bgeu	a4,s1,860 <malloc+0x70>
    if(p == freep)
 8ba:	00093703          	ld	a4,0(s2)
 8be:	853e                	mv	a0,a5
 8c0:	fef719e3          	bne	a4,a5,8b2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8c4:	8552                	mv	a0,s4
 8c6:	00000097          	auipc	ra,0x0
 8ca:	b82080e7          	jalr	-1150(ra) # 448 <sbrk>
  if(p == (char*)-1)
 8ce:	fd5518e3          	bne	a0,s5,89e <malloc+0xae>
        return 0;
 8d2:	4501                	li	a0,0
 8d4:	bf45                	j	884 <malloc+0x94>
