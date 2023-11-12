
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <prime>:
    }
    wait(0);
    exit(0);
}

void prime(int rp){
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	add	s0,sp,64
   a:	84aa                	mv	s1,a0
    //读取第一个数
    int f;
    if(!read(rp,&f,4))exit(0);
   c:	4611                	li	a2,4
   e:	fdc40593          	add	a1,s0,-36
  12:	00000097          	auipc	ra,0x0
  16:	3b6080e7          	jalr	950(ra) # 3c8 <read>
  1a:	c125                	beqz	a0,7a <prime+0x7a>
    printf("prime %d\n",f);
  1c:	fdc42583          	lw	a1,-36(s0)
  20:	00001517          	auipc	a0,0x1
  24:	8a850513          	add	a0,a0,-1880 # 8c8 <malloc+0xe8>
  28:	00000097          	auipc	ra,0x0
  2c:	700080e7          	jalr	1792(ra) # 728 <printf>
    //将剩下的数传给下一个管道
    int p[2];
    pipe(p);
  30:	fd040513          	add	a0,s0,-48
  34:	00000097          	auipc	ra,0x0
  38:	38c080e7          	jalr	908(ra) # 3c0 <pipe>
    int pid=fork();
  3c:	00000097          	auipc	ra,0x0
  40:	36c080e7          	jalr	876(ra) # 3a8 <fork>
    if(pid==0){//子进程
  44:	cd1d                	beqz	a0,82 <prime+0x82>
        close(p[1]);//这句不能注释
        prime(p[0]);
    }
    else{//父进程
        int rd;
        while(read(rp,&rd,4)){
  46:	4611                	li	a2,4
  48:	fcc40593          	add	a1,s0,-52
  4c:	8526                	mv	a0,s1
  4e:	00000097          	auipc	ra,0x0
  52:	37a080e7          	jalr	890(ra) # 3c8 <read>
  56:	c139                	beqz	a0,9c <prime+0x9c>
            if(rd%f!=0){
  58:	fcc42783          	lw	a5,-52(s0)
  5c:	fdc42703          	lw	a4,-36(s0)
  60:	02e7e7bb          	remw	a5,a5,a4
  64:	d3ed                	beqz	a5,46 <prime+0x46>
                write(p[1],&rd,4);
  66:	4611                	li	a2,4
  68:	fcc40593          	add	a1,s0,-52
  6c:	fd442503          	lw	a0,-44(s0)
  70:	00000097          	auipc	ra,0x0
  74:	360080e7          	jalr	864(ra) # 3d0 <write>
  78:	b7f9                	j	46 <prime+0x46>
    if(!read(rp,&f,4))exit(0);
  7a:	00000097          	auipc	ra,0x0
  7e:	336080e7          	jalr	822(ra) # 3b0 <exit>
        close(p[1]);//这句不能注释
  82:	fd442503          	lw	a0,-44(s0)
  86:	00000097          	auipc	ra,0x0
  8a:	352080e7          	jalr	850(ra) # 3d8 <close>
        prime(p[0]);
  8e:	fd042503          	lw	a0,-48(s0)
  92:	00000097          	auipc	ra,0x0
  96:	f6e080e7          	jalr	-146(ra) # 0 <prime>
  9a:	a821                	j	b2 <prime+0xb2>
            }
        }      
        close(rp);  
  9c:	8526                	mv	a0,s1
  9e:	00000097          	auipc	ra,0x0
  a2:	33a080e7          	jalr	826(ra) # 3d8 <close>
        close(p[1]);//这句可以注释
  a6:	fd442503          	lw	a0,-44(s0)
  aa:	00000097          	auipc	ra,0x0
  ae:	32e080e7          	jalr	814(ra) # 3d8 <close>
    }
  b2:	70e2                	ld	ra,56(sp)
  b4:	7442                	ld	s0,48(sp)
  b6:	74a2                	ld	s1,40(sp)
  b8:	6121                	add	sp,sp,64
  ba:	8082                	ret

00000000000000bc <main>:
{
  bc:	7179                	add	sp,sp,-48
  be:	f406                	sd	ra,40(sp)
  c0:	f022                	sd	s0,32(sp)
  c2:	ec26                	sd	s1,24(sp)
  c4:	1800                	add	s0,sp,48
    pipe(p);
  c6:	fd840513          	add	a0,s0,-40
  ca:	00000097          	auipc	ra,0x0
  ce:	2f6080e7          	jalr	758(ra) # 3c0 <pipe>
    int pid=fork();
  d2:	00000097          	auipc	ra,0x0
  d6:	2d6080e7          	jalr	726(ra) # 3a8 <fork>
    if(pid==0){//子进程
  da:	c921                	beqz	a0,12a <main+0x6e>
        for(int i=2;i<=35;i++){
  dc:	4789                	li	a5,2
  de:	fcf42a23          	sw	a5,-44(s0)
  e2:	02300493          	li	s1,35
            write(p[1],&i,4);
  e6:	4611                	li	a2,4
  e8:	fd440593          	add	a1,s0,-44
  ec:	fdc42503          	lw	a0,-36(s0)
  f0:	00000097          	auipc	ra,0x0
  f4:	2e0080e7          	jalr	736(ra) # 3d0 <write>
        for(int i=2;i<=35;i++){
  f8:	fd442783          	lw	a5,-44(s0)
  fc:	2785                	addw	a5,a5,1
  fe:	0007871b          	sext.w	a4,a5
 102:	fcf42a23          	sw	a5,-44(s0)
 106:	fee4d0e3          	bge	s1,a4,e6 <main+0x2a>
        close(p[1]);
 10a:	fdc42503          	lw	a0,-36(s0)
 10e:	00000097          	auipc	ra,0x0
 112:	2ca080e7          	jalr	714(ra) # 3d8 <close>
    wait(0);
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	2a0080e7          	jalr	672(ra) # 3b8 <wait>
    exit(0);
 120:	4501                	li	a0,0
 122:	00000097          	auipc	ra,0x0
 126:	28e080e7          	jalr	654(ra) # 3b0 <exit>
        close(p[1]);
 12a:	fdc42503          	lw	a0,-36(s0)
 12e:	00000097          	auipc	ra,0x0
 132:	2aa080e7          	jalr	682(ra) # 3d8 <close>
        prime(p[0]);
 136:	fd842503          	lw	a0,-40(s0)
 13a:	00000097          	auipc	ra,0x0
 13e:	ec6080e7          	jalr	-314(ra) # 0 <prime>
 142:	bfd1                	j	116 <main+0x5a>

0000000000000144 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 144:	1141                	add	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14a:	87aa                	mv	a5,a0
 14c:	0585                	add	a1,a1,1
 14e:	0785                	add	a5,a5,1
 150:	fff5c703          	lbu	a4,-1(a1)
 154:	fee78fa3          	sb	a4,-1(a5)
 158:	fb75                	bnez	a4,14c <strcpy+0x8>
    ;
  return os;
}
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	add	sp,sp,16
 15e:	8082                	ret

0000000000000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	1141                	add	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 166:	00054783          	lbu	a5,0(a0)
 16a:	cb91                	beqz	a5,17e <strcmp+0x1e>
 16c:	0005c703          	lbu	a4,0(a1)
 170:	00f71763          	bne	a4,a5,17e <strcmp+0x1e>
    p++, q++;
 174:	0505                	add	a0,a0,1
 176:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 178:	00054783          	lbu	a5,0(a0)
 17c:	fbe5                	bnez	a5,16c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 17e:	0005c503          	lbu	a0,0(a1)
}
 182:	40a7853b          	subw	a0,a5,a0
 186:	6422                	ld	s0,8(sp)
 188:	0141                	add	sp,sp,16
 18a:	8082                	ret

000000000000018c <strlen>:

uint
strlen(const char *s)
{
 18c:	1141                	add	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cf91                	beqz	a5,1b2 <strlen+0x26>
 198:	0505                	add	a0,a0,1
 19a:	87aa                	mv	a5,a0
 19c:	86be                	mv	a3,a5
 19e:	0785                	add	a5,a5,1
 1a0:	fff7c703          	lbu	a4,-1(a5)
 1a4:	ff65                	bnez	a4,19c <strlen+0x10>
 1a6:	40a6853b          	subw	a0,a3,a0
 1aa:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	add	sp,sp,16
 1b0:	8082                	ret
  for(n = 0; s[n]; n++)
 1b2:	4501                	li	a0,0
 1b4:	bfe5                	j	1ac <strlen+0x20>

00000000000001b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b6:	1141                	add	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1bc:	ca19                	beqz	a2,1d2 <memset+0x1c>
 1be:	87aa                	mv	a5,a0
 1c0:	1602                	sll	a2,a2,0x20
 1c2:	9201                	srl	a2,a2,0x20
 1c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1cc:	0785                	add	a5,a5,1
 1ce:	fee79de3          	bne	a5,a4,1c8 <memset+0x12>
  }
  return dst;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	add	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <strchr>:

char*
strchr(const char *s, char c)
{
 1d8:	1141                	add	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	add	s0,sp,16
  for(; *s; s++)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	cb99                	beqz	a5,1f8 <strchr+0x20>
    if(*s == c)
 1e4:	00f58763          	beq	a1,a5,1f2 <strchr+0x1a>
  for(; *s; s++)
 1e8:	0505                	add	a0,a0,1
 1ea:	00054783          	lbu	a5,0(a0)
 1ee:	fbfd                	bnez	a5,1e4 <strchr+0xc>
      return (char*)s;
  return 0;
 1f0:	4501                	li	a0,0
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	add	sp,sp,16
 1f6:	8082                	ret
  return 0;
 1f8:	4501                	li	a0,0
 1fa:	bfe5                	j	1f2 <strchr+0x1a>

00000000000001fc <gets>:

char*
gets(char *buf, int max)
{
 1fc:	711d                	add	sp,sp,-96
 1fe:	ec86                	sd	ra,88(sp)
 200:	e8a2                	sd	s0,80(sp)
 202:	e4a6                	sd	s1,72(sp)
 204:	e0ca                	sd	s2,64(sp)
 206:	fc4e                	sd	s3,56(sp)
 208:	f852                	sd	s4,48(sp)
 20a:	f456                	sd	s5,40(sp)
 20c:	f05a                	sd	s6,32(sp)
 20e:	ec5e                	sd	s7,24(sp)
 210:	1080                	add	s0,sp,96
 212:	8baa                	mv	s7,a0
 214:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 216:	892a                	mv	s2,a0
 218:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 21a:	4aa9                	li	s5,10
 21c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 21e:	89a6                	mv	s3,s1
 220:	2485                	addw	s1,s1,1
 222:	0344d863          	bge	s1,s4,252 <gets+0x56>
    cc = read(0, &c, 1);
 226:	4605                	li	a2,1
 228:	faf40593          	add	a1,s0,-81
 22c:	4501                	li	a0,0
 22e:	00000097          	auipc	ra,0x0
 232:	19a080e7          	jalr	410(ra) # 3c8 <read>
    if(cc < 1)
 236:	00a05e63          	blez	a0,252 <gets+0x56>
    buf[i++] = c;
 23a:	faf44783          	lbu	a5,-81(s0)
 23e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 242:	01578763          	beq	a5,s5,250 <gets+0x54>
 246:	0905                	add	s2,s2,1
 248:	fd679be3          	bne	a5,s6,21e <gets+0x22>
  for(i=0; i+1 < max; ){
 24c:	89a6                	mv	s3,s1
 24e:	a011                	j	252 <gets+0x56>
 250:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 252:	99de                	add	s3,s3,s7
 254:	00098023          	sb	zero,0(s3)
  return buf;
}
 258:	855e                	mv	a0,s7
 25a:	60e6                	ld	ra,88(sp)
 25c:	6446                	ld	s0,80(sp)
 25e:	64a6                	ld	s1,72(sp)
 260:	6906                	ld	s2,64(sp)
 262:	79e2                	ld	s3,56(sp)
 264:	7a42                	ld	s4,48(sp)
 266:	7aa2                	ld	s5,40(sp)
 268:	7b02                	ld	s6,32(sp)
 26a:	6be2                	ld	s7,24(sp)
 26c:	6125                	add	sp,sp,96
 26e:	8082                	ret

0000000000000270 <stat>:

int
stat(const char *n, struct stat *st)
{
 270:	1101                	add	sp,sp,-32
 272:	ec06                	sd	ra,24(sp)
 274:	e822                	sd	s0,16(sp)
 276:	e426                	sd	s1,8(sp)
 278:	e04a                	sd	s2,0(sp)
 27a:	1000                	add	s0,sp,32
 27c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27e:	4581                	li	a1,0
 280:	00000097          	auipc	ra,0x0
 284:	170080e7          	jalr	368(ra) # 3f0 <open>
  if(fd < 0)
 288:	02054563          	bltz	a0,2b2 <stat+0x42>
 28c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 28e:	85ca                	mv	a1,s2
 290:	00000097          	auipc	ra,0x0
 294:	178080e7          	jalr	376(ra) # 408 <fstat>
 298:	892a                	mv	s2,a0
  close(fd);
 29a:	8526                	mv	a0,s1
 29c:	00000097          	auipc	ra,0x0
 2a0:	13c080e7          	jalr	316(ra) # 3d8 <close>
  return r;
}
 2a4:	854a                	mv	a0,s2
 2a6:	60e2                	ld	ra,24(sp)
 2a8:	6442                	ld	s0,16(sp)
 2aa:	64a2                	ld	s1,8(sp)
 2ac:	6902                	ld	s2,0(sp)
 2ae:	6105                	add	sp,sp,32
 2b0:	8082                	ret
    return -1;
 2b2:	597d                	li	s2,-1
 2b4:	bfc5                	j	2a4 <stat+0x34>

00000000000002b6 <atoi>:

int
atoi(const char *s)
{
 2b6:	1141                	add	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bc:	00054683          	lbu	a3,0(a0)
 2c0:	fd06879b          	addw	a5,a3,-48
 2c4:	0ff7f793          	zext.b	a5,a5
 2c8:	4625                	li	a2,9
 2ca:	02f66863          	bltu	a2,a5,2fa <atoi+0x44>
 2ce:	872a                	mv	a4,a0
  n = 0;
 2d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2d2:	0705                	add	a4,a4,1
 2d4:	0025179b          	sllw	a5,a0,0x2
 2d8:	9fa9                	addw	a5,a5,a0
 2da:	0017979b          	sllw	a5,a5,0x1
 2de:	9fb5                	addw	a5,a5,a3
 2e0:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e4:	00074683          	lbu	a3,0(a4)
 2e8:	fd06879b          	addw	a5,a3,-48
 2ec:	0ff7f793          	zext.b	a5,a5
 2f0:	fef671e3          	bgeu	a2,a5,2d2 <atoi+0x1c>
  return n;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	add	sp,sp,16
 2f8:	8082                	ret
  n = 0;
 2fa:	4501                	li	a0,0
 2fc:	bfe5                	j	2f4 <atoi+0x3e>

00000000000002fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2fe:	1141                	add	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 304:	02b57463          	bgeu	a0,a1,32c <memmove+0x2e>
    while(n-- > 0)
 308:	00c05f63          	blez	a2,326 <memmove+0x28>
 30c:	1602                	sll	a2,a2,0x20
 30e:	9201                	srl	a2,a2,0x20
 310:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 314:	872a                	mv	a4,a0
      *dst++ = *src++;
 316:	0585                	add	a1,a1,1
 318:	0705                	add	a4,a4,1
 31a:	fff5c683          	lbu	a3,-1(a1)
 31e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 322:	fee79ae3          	bne	a5,a4,316 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	add	sp,sp,16
 32a:	8082                	ret
    dst += n;
 32c:	00c50733          	add	a4,a0,a2
    src += n;
 330:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 332:	fec05ae3          	blez	a2,326 <memmove+0x28>
 336:	fff6079b          	addw	a5,a2,-1
 33a:	1782                	sll	a5,a5,0x20
 33c:	9381                	srl	a5,a5,0x20
 33e:	fff7c793          	not	a5,a5
 342:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 344:	15fd                	add	a1,a1,-1
 346:	177d                	add	a4,a4,-1
 348:	0005c683          	lbu	a3,0(a1)
 34c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 350:	fee79ae3          	bne	a5,a4,344 <memmove+0x46>
 354:	bfc9                	j	326 <memmove+0x28>

0000000000000356 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 356:	1141                	add	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 35c:	ca05                	beqz	a2,38c <memcmp+0x36>
 35e:	fff6069b          	addw	a3,a2,-1
 362:	1682                	sll	a3,a3,0x20
 364:	9281                	srl	a3,a3,0x20
 366:	0685                	add	a3,a3,1
 368:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 36a:	00054783          	lbu	a5,0(a0)
 36e:	0005c703          	lbu	a4,0(a1)
 372:	00e79863          	bne	a5,a4,382 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 376:	0505                	add	a0,a0,1
    p2++;
 378:	0585                	add	a1,a1,1
  while (n-- > 0) {
 37a:	fed518e3          	bne	a0,a3,36a <memcmp+0x14>
  }
  return 0;
 37e:	4501                	li	a0,0
 380:	a019                	j	386 <memcmp+0x30>
      return *p1 - *p2;
 382:	40e7853b          	subw	a0,a5,a4
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	add	sp,sp,16
 38a:	8082                	ret
  return 0;
 38c:	4501                	li	a0,0
 38e:	bfe5                	j	386 <memcmp+0x30>

0000000000000390 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 390:	1141                	add	sp,sp,-16
 392:	e406                	sd	ra,8(sp)
 394:	e022                	sd	s0,0(sp)
 396:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 398:	00000097          	auipc	ra,0x0
 39c:	f66080e7          	jalr	-154(ra) # 2fe <memmove>
}
 3a0:	60a2                	ld	ra,8(sp)
 3a2:	6402                	ld	s0,0(sp)
 3a4:	0141                	add	sp,sp,16
 3a6:	8082                	ret

00000000000003a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a8:	4885                	li	a7,1
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b0:	4889                	li	a7,2
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b8:	488d                	li	a7,3
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c0:	4891                	li	a7,4
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <read>:
.global read
read:
 li a7, SYS_read
 3c8:	4895                	li	a7,5
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <write>:
.global write
write:
 li a7, SYS_write
 3d0:	48c1                	li	a7,16
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <close>:
.global close
close:
 li a7, SYS_close
 3d8:	48d5                	li	a7,21
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e0:	4899                	li	a7,6
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e8:	489d                	li	a7,7
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <open>:
.global open
open:
 li a7, SYS_open
 3f0:	48bd                	li	a7,15
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f8:	48c5                	li	a7,17
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 400:	48c9                	li	a7,18
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 408:	48a1                	li	a7,8
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <link>:
.global link
link:
 li a7, SYS_link
 410:	48cd                	li	a7,19
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 418:	48d1                	li	a7,20
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 420:	48a5                	li	a7,9
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <dup>:
.global dup
dup:
 li a7, SYS_dup
 428:	48a9                	li	a7,10
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 430:	48ad                	li	a7,11
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 438:	48b1                	li	a7,12
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 440:	48b5                	li	a7,13
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 448:	48b9                	li	a7,14
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <trace>:
.global trace
trace:
 li a7, SYS_trace
 450:	48d9                	li	a7,22
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 458:	48dd                	li	a7,23
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 460:	1101                	add	sp,sp,-32
 462:	ec06                	sd	ra,24(sp)
 464:	e822                	sd	s0,16(sp)
 466:	1000                	add	s0,sp,32
 468:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46c:	4605                	li	a2,1
 46e:	fef40593          	add	a1,s0,-17
 472:	00000097          	auipc	ra,0x0
 476:	f5e080e7          	jalr	-162(ra) # 3d0 <write>
}
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	6105                	add	sp,sp,32
 480:	8082                	ret

0000000000000482 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 482:	7139                	add	sp,sp,-64
 484:	fc06                	sd	ra,56(sp)
 486:	f822                	sd	s0,48(sp)
 488:	f426                	sd	s1,40(sp)
 48a:	f04a                	sd	s2,32(sp)
 48c:	ec4e                	sd	s3,24(sp)
 48e:	0080                	add	s0,sp,64
 490:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 492:	c299                	beqz	a3,498 <printint+0x16>
 494:	0805c963          	bltz	a1,526 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 498:	2581                	sext.w	a1,a1
  neg = 0;
 49a:	4881                	li	a7,0
 49c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a2:	2601                	sext.w	a2,a2
 4a4:	00000517          	auipc	a0,0x0
 4a8:	49450513          	add	a0,a0,1172 # 938 <digits>
 4ac:	883a                	mv	a6,a4
 4ae:	2705                	addw	a4,a4,1
 4b0:	02c5f7bb          	remuw	a5,a1,a2
 4b4:	1782                	sll	a5,a5,0x20
 4b6:	9381                	srl	a5,a5,0x20
 4b8:	97aa                	add	a5,a5,a0
 4ba:	0007c783          	lbu	a5,0(a5)
 4be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c2:	0005879b          	sext.w	a5,a1
 4c6:	02c5d5bb          	divuw	a1,a1,a2
 4ca:	0685                	add	a3,a3,1
 4cc:	fec7f0e3          	bgeu	a5,a2,4ac <printint+0x2a>
  if(neg)
 4d0:	00088c63          	beqz	a7,4e8 <printint+0x66>
    buf[i++] = '-';
 4d4:	fd070793          	add	a5,a4,-48
 4d8:	00878733          	add	a4,a5,s0
 4dc:	02d00793          	li	a5,45
 4e0:	fef70823          	sb	a5,-16(a4)
 4e4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4e8:	02e05863          	blez	a4,518 <printint+0x96>
 4ec:	fc040793          	add	a5,s0,-64
 4f0:	00e78933          	add	s2,a5,a4
 4f4:	fff78993          	add	s3,a5,-1
 4f8:	99ba                	add	s3,s3,a4
 4fa:	377d                	addw	a4,a4,-1
 4fc:	1702                	sll	a4,a4,0x20
 4fe:	9301                	srl	a4,a4,0x20
 500:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 504:	fff94583          	lbu	a1,-1(s2)
 508:	8526                	mv	a0,s1
 50a:	00000097          	auipc	ra,0x0
 50e:	f56080e7          	jalr	-170(ra) # 460 <putc>
  while(--i >= 0)
 512:	197d                	add	s2,s2,-1
 514:	ff3918e3          	bne	s2,s3,504 <printint+0x82>
}
 518:	70e2                	ld	ra,56(sp)
 51a:	7442                	ld	s0,48(sp)
 51c:	74a2                	ld	s1,40(sp)
 51e:	7902                	ld	s2,32(sp)
 520:	69e2                	ld	s3,24(sp)
 522:	6121                	add	sp,sp,64
 524:	8082                	ret
    x = -xx;
 526:	40b005bb          	negw	a1,a1
    neg = 1;
 52a:	4885                	li	a7,1
    x = -xx;
 52c:	bf85                	j	49c <printint+0x1a>

000000000000052e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52e:	715d                	add	sp,sp,-80
 530:	e486                	sd	ra,72(sp)
 532:	e0a2                	sd	s0,64(sp)
 534:	fc26                	sd	s1,56(sp)
 536:	f84a                	sd	s2,48(sp)
 538:	f44e                	sd	s3,40(sp)
 53a:	f052                	sd	s4,32(sp)
 53c:	ec56                	sd	s5,24(sp)
 53e:	e85a                	sd	s6,16(sp)
 540:	e45e                	sd	s7,8(sp)
 542:	e062                	sd	s8,0(sp)
 544:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 546:	0005c903          	lbu	s2,0(a1)
 54a:	18090c63          	beqz	s2,6e2 <vprintf+0x1b4>
 54e:	8aaa                	mv	s5,a0
 550:	8bb2                	mv	s7,a2
 552:	00158493          	add	s1,a1,1
  state = 0;
 556:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 558:	02500a13          	li	s4,37
 55c:	4b55                	li	s6,21
 55e:	a839                	j	57c <vprintf+0x4e>
        putc(fd, c);
 560:	85ca                	mv	a1,s2
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	efc080e7          	jalr	-260(ra) # 460 <putc>
 56c:	a019                	j	572 <vprintf+0x44>
    } else if(state == '%'){
 56e:	01498d63          	beq	s3,s4,588 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 572:	0485                	add	s1,s1,1
 574:	fff4c903          	lbu	s2,-1(s1)
 578:	16090563          	beqz	s2,6e2 <vprintf+0x1b4>
    if(state == 0){
 57c:	fe0999e3          	bnez	s3,56e <vprintf+0x40>
      if(c == '%'){
 580:	ff4910e3          	bne	s2,s4,560 <vprintf+0x32>
        state = '%';
 584:	89d2                	mv	s3,s4
 586:	b7f5                	j	572 <vprintf+0x44>
      if(c == 'd'){
 588:	13490263          	beq	s2,s4,6ac <vprintf+0x17e>
 58c:	f9d9079b          	addw	a5,s2,-99
 590:	0ff7f793          	zext.b	a5,a5
 594:	12fb6563          	bltu	s6,a5,6be <vprintf+0x190>
 598:	f9d9079b          	addw	a5,s2,-99
 59c:	0ff7f713          	zext.b	a4,a5
 5a0:	10eb6f63          	bltu	s6,a4,6be <vprintf+0x190>
 5a4:	00271793          	sll	a5,a4,0x2
 5a8:	00000717          	auipc	a4,0x0
 5ac:	33870713          	add	a4,a4,824 # 8e0 <malloc+0x100>
 5b0:	97ba                	add	a5,a5,a4
 5b2:	439c                	lw	a5,0(a5)
 5b4:	97ba                	add	a5,a5,a4
 5b6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5b8:	008b8913          	add	s2,s7,8
 5bc:	4685                	li	a3,1
 5be:	4629                	li	a2,10
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	ebc080e7          	jalr	-324(ra) # 482 <printint>
 5ce:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b745                	j	572 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d4:	008b8913          	add	s2,s7,8
 5d8:	4681                	li	a3,0
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	ea0080e7          	jalr	-352(ra) # 482 <printint>
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b751                	j	572 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5f0:	008b8913          	add	s2,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000ba583          	lw	a1,0(s7)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e84080e7          	jalr	-380(ra) # 482 <printint>
 606:	8bca                	mv	s7,s2
      state = 0;
 608:	4981                	li	s3,0
 60a:	b7a5                	j	572 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 60c:	008b8c13          	add	s8,s7,8
 610:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 614:	03000593          	li	a1,48
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e46080e7          	jalr	-442(ra) # 460 <putc>
  putc(fd, 'x');
 622:	07800593          	li	a1,120
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e38080e7          	jalr	-456(ra) # 460 <putc>
 630:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 632:	00000b97          	auipc	s7,0x0
 636:	306b8b93          	add	s7,s7,774 # 938 <digits>
 63a:	03c9d793          	srl	a5,s3,0x3c
 63e:	97de                	add	a5,a5,s7
 640:	0007c583          	lbu	a1,0(a5)
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e1a080e7          	jalr	-486(ra) # 460 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64e:	0992                	sll	s3,s3,0x4
 650:	397d                	addw	s2,s2,-1
 652:	fe0914e3          	bnez	s2,63a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 656:	8be2                	mv	s7,s8
      state = 0;
 658:	4981                	li	s3,0
 65a:	bf21                	j	572 <vprintf+0x44>
        s = va_arg(ap, char*);
 65c:	008b8993          	add	s3,s7,8
 660:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 664:	02090163          	beqz	s2,686 <vprintf+0x158>
        while(*s != 0){
 668:	00094583          	lbu	a1,0(s2)
 66c:	c9a5                	beqz	a1,6dc <vprintf+0x1ae>
          putc(fd, *s);
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	df0080e7          	jalr	-528(ra) # 460 <putc>
          s++;
 678:	0905                	add	s2,s2,1
        while(*s != 0){
 67a:	00094583          	lbu	a1,0(s2)
 67e:	f9e5                	bnez	a1,66e <vprintf+0x140>
        s = va_arg(ap, char*);
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	b5fd                	j	572 <vprintf+0x44>
          s = "(null)";
 686:	00000917          	auipc	s2,0x0
 68a:	25290913          	add	s2,s2,594 # 8d8 <malloc+0xf8>
        while(*s != 0){
 68e:	02800593          	li	a1,40
 692:	bff1                	j	66e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 694:	008b8913          	add	s2,s7,8
 698:	000bc583          	lbu	a1,0(s7)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	dc2080e7          	jalr	-574(ra) # 460 <putc>
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b5e1                	j	572 <vprintf+0x44>
        putc(fd, c);
 6ac:	02500593          	li	a1,37
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	dae080e7          	jalr	-594(ra) # 460 <putc>
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bd5d                	j	572 <vprintf+0x44>
        putc(fd, '%');
 6be:	02500593          	li	a1,37
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	d9c080e7          	jalr	-612(ra) # 460 <putc>
        putc(fd, c);
 6cc:	85ca                	mv	a1,s2
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	d90080e7          	jalr	-624(ra) # 460 <putc>
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bd61                	j	572 <vprintf+0x44>
        s = va_arg(ap, char*);
 6dc:	8bce                	mv	s7,s3
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bd49                	j	572 <vprintf+0x44>
    }
  }
}
 6e2:	60a6                	ld	ra,72(sp)
 6e4:	6406                	ld	s0,64(sp)
 6e6:	74e2                	ld	s1,56(sp)
 6e8:	7942                	ld	s2,48(sp)
 6ea:	79a2                	ld	s3,40(sp)
 6ec:	7a02                	ld	s4,32(sp)
 6ee:	6ae2                	ld	s5,24(sp)
 6f0:	6b42                	ld	s6,16(sp)
 6f2:	6ba2                	ld	s7,8(sp)
 6f4:	6c02                	ld	s8,0(sp)
 6f6:	6161                	add	sp,sp,80
 6f8:	8082                	ret

00000000000006fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6fa:	715d                	add	sp,sp,-80
 6fc:	ec06                	sd	ra,24(sp)
 6fe:	e822                	sd	s0,16(sp)
 700:	1000                	add	s0,sp,32
 702:	e010                	sd	a2,0(s0)
 704:	e414                	sd	a3,8(s0)
 706:	e818                	sd	a4,16(s0)
 708:	ec1c                	sd	a5,24(s0)
 70a:	03043023          	sd	a6,32(s0)
 70e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 712:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 716:	8622                	mv	a2,s0
 718:	00000097          	auipc	ra,0x0
 71c:	e16080e7          	jalr	-490(ra) # 52e <vprintf>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6161                	add	sp,sp,80
 726:	8082                	ret

0000000000000728 <printf>:

void
printf(const char *fmt, ...)
{
 728:	711d                	add	sp,sp,-96
 72a:	ec06                	sd	ra,24(sp)
 72c:	e822                	sd	s0,16(sp)
 72e:	1000                	add	s0,sp,32
 730:	e40c                	sd	a1,8(s0)
 732:	e810                	sd	a2,16(s0)
 734:	ec14                	sd	a3,24(s0)
 736:	f018                	sd	a4,32(s0)
 738:	f41c                	sd	a5,40(s0)
 73a:	03043823          	sd	a6,48(s0)
 73e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 742:	00840613          	add	a2,s0,8
 746:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74a:	85aa                	mv	a1,a0
 74c:	4505                	li	a0,1
 74e:	00000097          	auipc	ra,0x0
 752:	de0080e7          	jalr	-544(ra) # 52e <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6125                	add	sp,sp,96
 75c:	8082                	ret

000000000000075e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75e:	1141                	add	sp,sp,-16
 760:	e422                	sd	s0,8(sp)
 762:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 764:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	00000797          	auipc	a5,0x0
 76c:	1e87b783          	ld	a5,488(a5) # 950 <freep>
 770:	a02d                	j	79a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 772:	4618                	lw	a4,8(a2)
 774:	9f2d                	addw	a4,a4,a1
 776:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77a:	6398                	ld	a4,0(a5)
 77c:	6310                	ld	a2,0(a4)
 77e:	a83d                	j	7bc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 780:	ff852703          	lw	a4,-8(a0)
 784:	9f31                	addw	a4,a4,a2
 786:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 788:	ff053683          	ld	a3,-16(a0)
 78c:	a091                	j	7d0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78e:	6398                	ld	a4,0(a5)
 790:	00e7e463          	bltu	a5,a4,798 <free+0x3a>
 794:	00e6ea63          	bltu	a3,a4,7a8 <free+0x4a>
{
 798:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79a:	fed7fae3          	bgeu	a5,a3,78e <free+0x30>
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e6e463          	bltu	a3,a4,7a8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	fee7eae3          	bltu	a5,a4,798 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7a8:	ff852583          	lw	a1,-8(a0)
 7ac:	6390                	ld	a2,0(a5)
 7ae:	02059813          	sll	a6,a1,0x20
 7b2:	01c85713          	srl	a4,a6,0x1c
 7b6:	9736                	add	a4,a4,a3
 7b8:	fae60de3          	beq	a2,a4,772 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7bc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c0:	4790                	lw	a2,8(a5)
 7c2:	02061593          	sll	a1,a2,0x20
 7c6:	01c5d713          	srl	a4,a1,0x1c
 7ca:	973e                	add	a4,a4,a5
 7cc:	fae68ae3          	beq	a3,a4,780 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d2:	00000717          	auipc	a4,0x0
 7d6:	16f73f23          	sd	a5,382(a4) # 950 <freep>
}
 7da:	6422                	ld	s0,8(sp)
 7dc:	0141                	add	sp,sp,16
 7de:	8082                	ret

00000000000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	7139                	add	sp,sp,-64
 7e2:	fc06                	sd	ra,56(sp)
 7e4:	f822                	sd	s0,48(sp)
 7e6:	f426                	sd	s1,40(sp)
 7e8:	f04a                	sd	s2,32(sp)
 7ea:	ec4e                	sd	s3,24(sp)
 7ec:	e852                	sd	s4,16(sp)
 7ee:	e456                	sd	s5,8(sp)
 7f0:	e05a                	sd	s6,0(sp)
 7f2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f4:	02051493          	sll	s1,a0,0x20
 7f8:	9081                	srl	s1,s1,0x20
 7fa:	04bd                	add	s1,s1,15
 7fc:	8091                	srl	s1,s1,0x4
 7fe:	0014899b          	addw	s3,s1,1
 802:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 804:	00000517          	auipc	a0,0x0
 808:	14c53503          	ld	a0,332(a0) # 950 <freep>
 80c:	c515                	beqz	a0,838 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 810:	4798                	lw	a4,8(a5)
 812:	02977f63          	bgeu	a4,s1,850 <malloc+0x70>
  if(nu < 4096)
 816:	8a4e                	mv	s4,s3
 818:	0009871b          	sext.w	a4,s3
 81c:	6685                	lui	a3,0x1
 81e:	00d77363          	bgeu	a4,a3,824 <malloc+0x44>
 822:	6a05                	lui	s4,0x1
 824:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 828:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82c:	00000917          	auipc	s2,0x0
 830:	12490913          	add	s2,s2,292 # 950 <freep>
  if(p == (char*)-1)
 834:	5afd                	li	s5,-1
 836:	a895                	j	8aa <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 838:	00000797          	auipc	a5,0x0
 83c:	12078793          	add	a5,a5,288 # 958 <base>
 840:	00000717          	auipc	a4,0x0
 844:	10f73823          	sd	a5,272(a4) # 950 <freep>
 848:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 84a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84e:	b7e1                	j	816 <malloc+0x36>
      if(p->s.size == nunits)
 850:	02e48c63          	beq	s1,a4,888 <malloc+0xa8>
        p->s.size -= nunits;
 854:	4137073b          	subw	a4,a4,s3
 858:	c798                	sw	a4,8(a5)
        p += p->s.size;
 85a:	02071693          	sll	a3,a4,0x20
 85e:	01c6d713          	srl	a4,a3,0x1c
 862:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 864:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 868:	00000717          	auipc	a4,0x0
 86c:	0ea73423          	sd	a0,232(a4) # 950 <freep>
      return (void*)(p + 1);
 870:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 874:	70e2                	ld	ra,56(sp)
 876:	7442                	ld	s0,48(sp)
 878:	74a2                	ld	s1,40(sp)
 87a:	7902                	ld	s2,32(sp)
 87c:	69e2                	ld	s3,24(sp)
 87e:	6a42                	ld	s4,16(sp)
 880:	6aa2                	ld	s5,8(sp)
 882:	6b02                	ld	s6,0(sp)
 884:	6121                	add	sp,sp,64
 886:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 888:	6398                	ld	a4,0(a5)
 88a:	e118                	sd	a4,0(a0)
 88c:	bff1                	j	868 <malloc+0x88>
  hp->s.size = nu;
 88e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 892:	0541                	add	a0,a0,16
 894:	00000097          	auipc	ra,0x0
 898:	eca080e7          	jalr	-310(ra) # 75e <free>
  return freep;
 89c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a0:	d971                	beqz	a0,874 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a4:	4798                	lw	a4,8(a5)
 8a6:	fa9775e3          	bgeu	a4,s1,850 <malloc+0x70>
    if(p == freep)
 8aa:	00093703          	ld	a4,0(s2)
 8ae:	853e                	mv	a0,a5
 8b0:	fef719e3          	bne	a4,a5,8a2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8b4:	8552                	mv	a0,s4
 8b6:	00000097          	auipc	ra,0x0
 8ba:	b82080e7          	jalr	-1150(ra) # 438 <sbrk>
  if(p == (char*)-1)
 8be:	fd5518e3          	bne	a0,s5,88e <malloc+0xae>
        return 0;
 8c2:	4501                	li	a0,0
 8c4:	bf45                	j	874 <malloc+0x94>
