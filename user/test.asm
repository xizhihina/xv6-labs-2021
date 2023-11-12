
user/_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/fs.h"

int
main(int argc, char *argv[])
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
   8:	87ae                	mv	a5,a1
    exec(argv[1],&argv[1]);
   a:	05a1                	add	a1,a1,8
   c:	6788                	ld	a0,8(a5)
   e:	00000097          	auipc	ra,0x0
  12:	2b6080e7          	jalr	694(ra) # 2c4 <exec>
    exit(0);
  16:	4501                	li	a0,0
  18:	00000097          	auipc	ra,0x0
  1c:	274080e7          	jalr	628(ra) # 28c <exit>

0000000000000020 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  20:	1141                	add	sp,sp,-16
  22:	e422                	sd	s0,8(sp)
  24:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  26:	87aa                	mv	a5,a0
  28:	0585                	add	a1,a1,1
  2a:	0785                	add	a5,a5,1
  2c:	fff5c703          	lbu	a4,-1(a1)
  30:	fee78fa3          	sb	a4,-1(a5)
  34:	fb75                	bnez	a4,28 <strcpy+0x8>
    ;
  return os;
}
  36:	6422                	ld	s0,8(sp)
  38:	0141                	add	sp,sp,16
  3a:	8082                	ret

000000000000003c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3c:	1141                	add	sp,sp,-16
  3e:	e422                	sd	s0,8(sp)
  40:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  42:	00054783          	lbu	a5,0(a0)
  46:	cb91                	beqz	a5,5a <strcmp+0x1e>
  48:	0005c703          	lbu	a4,0(a1)
  4c:	00f71763          	bne	a4,a5,5a <strcmp+0x1e>
    p++, q++;
  50:	0505                	add	a0,a0,1
  52:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  54:	00054783          	lbu	a5,0(a0)
  58:	fbe5                	bnez	a5,48 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  5a:	0005c503          	lbu	a0,0(a1)
}
  5e:	40a7853b          	subw	a0,a5,a0
  62:	6422                	ld	s0,8(sp)
  64:	0141                	add	sp,sp,16
  66:	8082                	ret

0000000000000068 <strlen>:

uint
strlen(const char *s)
{
  68:	1141                	add	sp,sp,-16
  6a:	e422                	sd	s0,8(sp)
  6c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  6e:	00054783          	lbu	a5,0(a0)
  72:	cf91                	beqz	a5,8e <strlen+0x26>
  74:	0505                	add	a0,a0,1
  76:	87aa                	mv	a5,a0
  78:	86be                	mv	a3,a5
  7a:	0785                	add	a5,a5,1
  7c:	fff7c703          	lbu	a4,-1(a5)
  80:	ff65                	bnez	a4,78 <strlen+0x10>
  82:	40a6853b          	subw	a0,a3,a0
  86:	2505                	addw	a0,a0,1
    ;
  return n;
}
  88:	6422                	ld	s0,8(sp)
  8a:	0141                	add	sp,sp,16
  8c:	8082                	ret
  for(n = 0; s[n]; n++)
  8e:	4501                	li	a0,0
  90:	bfe5                	j	88 <strlen+0x20>

0000000000000092 <memset>:

void*
memset(void *dst, int c, uint n)
{
  92:	1141                	add	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  98:	ca19                	beqz	a2,ae <memset+0x1c>
  9a:	87aa                	mv	a5,a0
  9c:	1602                	sll	a2,a2,0x20
  9e:	9201                	srl	a2,a2,0x20
  a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  a8:	0785                	add	a5,a5,1
  aa:	fee79de3          	bne	a5,a4,a4 <memset+0x12>
  }
  return dst;
}
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	add	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strchr>:

char*
strchr(const char *s, char c)
{
  b4:	1141                	add	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	add	s0,sp,16
  for(; *s; s++)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cb99                	beqz	a5,d4 <strchr+0x20>
    if(*s == c)
  c0:	00f58763          	beq	a1,a5,ce <strchr+0x1a>
  for(; *s; s++)
  c4:	0505                	add	a0,a0,1
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbfd                	bnez	a5,c0 <strchr+0xc>
      return (char*)s;
  return 0;
  cc:	4501                	li	a0,0
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	add	sp,sp,16
  d2:	8082                	ret
  return 0;
  d4:	4501                	li	a0,0
  d6:	bfe5                	j	ce <strchr+0x1a>

00000000000000d8 <gets>:

char*
gets(char *buf, int max)
{
  d8:	711d                	add	sp,sp,-96
  da:	ec86                	sd	ra,88(sp)
  dc:	e8a2                	sd	s0,80(sp)
  de:	e4a6                	sd	s1,72(sp)
  e0:	e0ca                	sd	s2,64(sp)
  e2:	fc4e                	sd	s3,56(sp)
  e4:	f852                	sd	s4,48(sp)
  e6:	f456                	sd	s5,40(sp)
  e8:	f05a                	sd	s6,32(sp)
  ea:	ec5e                	sd	s7,24(sp)
  ec:	1080                	add	s0,sp,96
  ee:	8baa                	mv	s7,a0
  f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f2:	892a                	mv	s2,a0
  f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  f6:	4aa9                	li	s5,10
  f8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  fa:	89a6                	mv	s3,s1
  fc:	2485                	addw	s1,s1,1
  fe:	0344d863          	bge	s1,s4,12e <gets+0x56>
    cc = read(0, &c, 1);
 102:	4605                	li	a2,1
 104:	faf40593          	add	a1,s0,-81
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	19a080e7          	jalr	410(ra) # 2a4 <read>
    if(cc < 1)
 112:	00a05e63          	blez	a0,12e <gets+0x56>
    buf[i++] = c;
 116:	faf44783          	lbu	a5,-81(s0)
 11a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 11e:	01578763          	beq	a5,s5,12c <gets+0x54>
 122:	0905                	add	s2,s2,1
 124:	fd679be3          	bne	a5,s6,fa <gets+0x22>
  for(i=0; i+1 < max; ){
 128:	89a6                	mv	s3,s1
 12a:	a011                	j	12e <gets+0x56>
 12c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 12e:	99de                	add	s3,s3,s7
 130:	00098023          	sb	zero,0(s3)
  return buf;
}
 134:	855e                	mv	a0,s7
 136:	60e6                	ld	ra,88(sp)
 138:	6446                	ld	s0,80(sp)
 13a:	64a6                	ld	s1,72(sp)
 13c:	6906                	ld	s2,64(sp)
 13e:	79e2                	ld	s3,56(sp)
 140:	7a42                	ld	s4,48(sp)
 142:	7aa2                	ld	s5,40(sp)
 144:	7b02                	ld	s6,32(sp)
 146:	6be2                	ld	s7,24(sp)
 148:	6125                	add	sp,sp,96
 14a:	8082                	ret

000000000000014c <stat>:

int
stat(const char *n, struct stat *st)
{
 14c:	1101                	add	sp,sp,-32
 14e:	ec06                	sd	ra,24(sp)
 150:	e822                	sd	s0,16(sp)
 152:	e426                	sd	s1,8(sp)
 154:	e04a                	sd	s2,0(sp)
 156:	1000                	add	s0,sp,32
 158:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15a:	4581                	li	a1,0
 15c:	00000097          	auipc	ra,0x0
 160:	170080e7          	jalr	368(ra) # 2cc <open>
  if(fd < 0)
 164:	02054563          	bltz	a0,18e <stat+0x42>
 168:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 16a:	85ca                	mv	a1,s2
 16c:	00000097          	auipc	ra,0x0
 170:	178080e7          	jalr	376(ra) # 2e4 <fstat>
 174:	892a                	mv	s2,a0
  close(fd);
 176:	8526                	mv	a0,s1
 178:	00000097          	auipc	ra,0x0
 17c:	13c080e7          	jalr	316(ra) # 2b4 <close>
  return r;
}
 180:	854a                	mv	a0,s2
 182:	60e2                	ld	ra,24(sp)
 184:	6442                	ld	s0,16(sp)
 186:	64a2                	ld	s1,8(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	add	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfc5                	j	180 <stat+0x34>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	add	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054683          	lbu	a3,0(a0)
 19c:	fd06879b          	addw	a5,a3,-48
 1a0:	0ff7f793          	zext.b	a5,a5
 1a4:	4625                	li	a2,9
 1a6:	02f66863          	bltu	a2,a5,1d6 <atoi+0x44>
 1aa:	872a                	mv	a4,a0
  n = 0;
 1ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ae:	0705                	add	a4,a4,1
 1b0:	0025179b          	sllw	a5,a0,0x2
 1b4:	9fa9                	addw	a5,a5,a0
 1b6:	0017979b          	sllw	a5,a5,0x1
 1ba:	9fb5                	addw	a5,a5,a3
 1bc:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c0:	00074683          	lbu	a3,0(a4)
 1c4:	fd06879b          	addw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	fef671e3          	bgeu	a2,a5,1ae <atoi+0x1c>
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	add	sp,sp,16
 1d4:	8082                	ret
  n = 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <atoi+0x3e>

00000000000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	1141                	add	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e0:	02b57463          	bgeu	a0,a1,208 <memmove+0x2e>
    while(n-- > 0)
 1e4:	00c05f63          	blez	a2,202 <memmove+0x28>
 1e8:	1602                	sll	a2,a2,0x20
 1ea:	9201                	srl	a2,a2,0x20
 1ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f2:	0585                	add	a1,a1,1
 1f4:	0705                	add	a4,a4,1
 1f6:	fff5c683          	lbu	a3,-1(a1)
 1fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fe:	fee79ae3          	bne	a5,a4,1f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	add	sp,sp,16
 206:	8082                	ret
    dst += n;
 208:	00c50733          	add	a4,a0,a2
    src += n;
 20c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20e:	fec05ae3          	blez	a2,202 <memmove+0x28>
 212:	fff6079b          	addw	a5,a2,-1
 216:	1782                	sll	a5,a5,0x20
 218:	9381                	srl	a5,a5,0x20
 21a:	fff7c793          	not	a5,a5
 21e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 220:	15fd                	add	a1,a1,-1
 222:	177d                	add	a4,a4,-1
 224:	0005c683          	lbu	a3,0(a1)
 228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x46>
 230:	bfc9                	j	202 <memmove+0x28>

0000000000000232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 232:	1141                	add	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 238:	ca05                	beqz	a2,268 <memcmp+0x36>
 23a:	fff6069b          	addw	a3,a2,-1
 23e:	1682                	sll	a3,a3,0x20
 240:	9281                	srl	a3,a3,0x20
 242:	0685                	add	a3,a3,1
 244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 246:	00054783          	lbu	a5,0(a0)
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00e79863          	bne	a5,a4,25e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 252:	0505                	add	a0,a0,1
    p2++;
 254:	0585                	add	a1,a1,1
  while (n-- > 0) {
 256:	fed518e3          	bne	a0,a3,246 <memcmp+0x14>
  }
  return 0;
 25a:	4501                	li	a0,0
 25c:	a019                	j	262 <memcmp+0x30>
      return *p1 - *p2;
 25e:	40e7853b          	subw	a0,a5,a4
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	add	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <memcmp+0x30>

000000000000026c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26c:	1141                	add	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 274:	00000097          	auipc	ra,0x0
 278:	f66080e7          	jalr	-154(ra) # 1da <memmove>
}
 27c:	60a2                	ld	ra,8(sp)
 27e:	6402                	ld	s0,0(sp)
 280:	0141                	add	sp,sp,16
 282:	8082                	ret

0000000000000284 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 284:	4885                	li	a7,1
 ecall
 286:	00000073          	ecall
 ret
 28a:	8082                	ret

000000000000028c <exit>:
.global exit
exit:
 li a7, SYS_exit
 28c:	4889                	li	a7,2
 ecall
 28e:	00000073          	ecall
 ret
 292:	8082                	ret

0000000000000294 <wait>:
.global wait
wait:
 li a7, SYS_wait
 294:	488d                	li	a7,3
 ecall
 296:	00000073          	ecall
 ret
 29a:	8082                	ret

000000000000029c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 29c:	4891                	li	a7,4
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <read>:
.global read
read:
 li a7, SYS_read
 2a4:	4895                	li	a7,5
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <write>:
.global write
write:
 li a7, SYS_write
 2ac:	48c1                	li	a7,16
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <close>:
.global close
close:
 li a7, SYS_close
 2b4:	48d5                	li	a7,21
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2bc:	4899                	li	a7,6
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c4:	489d                	li	a7,7
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <open>:
.global open
open:
 li a7, SYS_open
 2cc:	48bd                	li	a7,15
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d4:	48c5                	li	a7,17
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2dc:	48c9                	li	a7,18
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e4:	48a1                	li	a7,8
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <link>:
.global link
link:
 li a7, SYS_link
 2ec:	48cd                	li	a7,19
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f4:	48d1                	li	a7,20
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2fc:	48a5                	li	a7,9
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <dup>:
.global dup
dup:
 li a7, SYS_dup
 304:	48a9                	li	a7,10
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 30c:	48ad                	li	a7,11
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 314:	48b1                	li	a7,12
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 31c:	48b5                	li	a7,13
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 324:	48b9                	li	a7,14
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <trace>:
.global trace
trace:
 li a7, SYS_trace
 32c:	48d9                	li	a7,22
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 334:	48dd                	li	a7,23
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 33c:	1101                	add	sp,sp,-32
 33e:	ec06                	sd	ra,24(sp)
 340:	e822                	sd	s0,16(sp)
 342:	1000                	add	s0,sp,32
 344:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 348:	4605                	li	a2,1
 34a:	fef40593          	add	a1,s0,-17
 34e:	00000097          	auipc	ra,0x0
 352:	f5e080e7          	jalr	-162(ra) # 2ac <write>
}
 356:	60e2                	ld	ra,24(sp)
 358:	6442                	ld	s0,16(sp)
 35a:	6105                	add	sp,sp,32
 35c:	8082                	ret

000000000000035e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35e:	7139                	add	sp,sp,-64
 360:	fc06                	sd	ra,56(sp)
 362:	f822                	sd	s0,48(sp)
 364:	f426                	sd	s1,40(sp)
 366:	f04a                	sd	s2,32(sp)
 368:	ec4e                	sd	s3,24(sp)
 36a:	0080                	add	s0,sp,64
 36c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36e:	c299                	beqz	a3,374 <printint+0x16>
 370:	0805c963          	bltz	a1,402 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 374:	2581                	sext.w	a1,a1
  neg = 0;
 376:	4881                	li	a7,0
 378:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 37c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 37e:	2601                	sext.w	a2,a2
 380:	00000517          	auipc	a0,0x0
 384:	48850513          	add	a0,a0,1160 # 808 <digits>
 388:	883a                	mv	a6,a4
 38a:	2705                	addw	a4,a4,1
 38c:	02c5f7bb          	remuw	a5,a1,a2
 390:	1782                	sll	a5,a5,0x20
 392:	9381                	srl	a5,a5,0x20
 394:	97aa                	add	a5,a5,a0
 396:	0007c783          	lbu	a5,0(a5)
 39a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 39e:	0005879b          	sext.w	a5,a1
 3a2:	02c5d5bb          	divuw	a1,a1,a2
 3a6:	0685                	add	a3,a3,1
 3a8:	fec7f0e3          	bgeu	a5,a2,388 <printint+0x2a>
  if(neg)
 3ac:	00088c63          	beqz	a7,3c4 <printint+0x66>
    buf[i++] = '-';
 3b0:	fd070793          	add	a5,a4,-48
 3b4:	00878733          	add	a4,a5,s0
 3b8:	02d00793          	li	a5,45
 3bc:	fef70823          	sb	a5,-16(a4)
 3c0:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3c4:	02e05863          	blez	a4,3f4 <printint+0x96>
 3c8:	fc040793          	add	a5,s0,-64
 3cc:	00e78933          	add	s2,a5,a4
 3d0:	fff78993          	add	s3,a5,-1
 3d4:	99ba                	add	s3,s3,a4
 3d6:	377d                	addw	a4,a4,-1
 3d8:	1702                	sll	a4,a4,0x20
 3da:	9301                	srl	a4,a4,0x20
 3dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3e0:	fff94583          	lbu	a1,-1(s2)
 3e4:	8526                	mv	a0,s1
 3e6:	00000097          	auipc	ra,0x0
 3ea:	f56080e7          	jalr	-170(ra) # 33c <putc>
  while(--i >= 0)
 3ee:	197d                	add	s2,s2,-1
 3f0:	ff3918e3          	bne	s2,s3,3e0 <printint+0x82>
}
 3f4:	70e2                	ld	ra,56(sp)
 3f6:	7442                	ld	s0,48(sp)
 3f8:	74a2                	ld	s1,40(sp)
 3fa:	7902                	ld	s2,32(sp)
 3fc:	69e2                	ld	s3,24(sp)
 3fe:	6121                	add	sp,sp,64
 400:	8082                	ret
    x = -xx;
 402:	40b005bb          	negw	a1,a1
    neg = 1;
 406:	4885                	li	a7,1
    x = -xx;
 408:	bf85                	j	378 <printint+0x1a>

000000000000040a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 40a:	715d                	add	sp,sp,-80
 40c:	e486                	sd	ra,72(sp)
 40e:	e0a2                	sd	s0,64(sp)
 410:	fc26                	sd	s1,56(sp)
 412:	f84a                	sd	s2,48(sp)
 414:	f44e                	sd	s3,40(sp)
 416:	f052                	sd	s4,32(sp)
 418:	ec56                	sd	s5,24(sp)
 41a:	e85a                	sd	s6,16(sp)
 41c:	e45e                	sd	s7,8(sp)
 41e:	e062                	sd	s8,0(sp)
 420:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 422:	0005c903          	lbu	s2,0(a1)
 426:	18090c63          	beqz	s2,5be <vprintf+0x1b4>
 42a:	8aaa                	mv	s5,a0
 42c:	8bb2                	mv	s7,a2
 42e:	00158493          	add	s1,a1,1
  state = 0;
 432:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 434:	02500a13          	li	s4,37
 438:	4b55                	li	s6,21
 43a:	a839                	j	458 <vprintf+0x4e>
        putc(fd, c);
 43c:	85ca                	mv	a1,s2
 43e:	8556                	mv	a0,s5
 440:	00000097          	auipc	ra,0x0
 444:	efc080e7          	jalr	-260(ra) # 33c <putc>
 448:	a019                	j	44e <vprintf+0x44>
    } else if(state == '%'){
 44a:	01498d63          	beq	s3,s4,464 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 44e:	0485                	add	s1,s1,1
 450:	fff4c903          	lbu	s2,-1(s1)
 454:	16090563          	beqz	s2,5be <vprintf+0x1b4>
    if(state == 0){
 458:	fe0999e3          	bnez	s3,44a <vprintf+0x40>
      if(c == '%'){
 45c:	ff4910e3          	bne	s2,s4,43c <vprintf+0x32>
        state = '%';
 460:	89d2                	mv	s3,s4
 462:	b7f5                	j	44e <vprintf+0x44>
      if(c == 'd'){
 464:	13490263          	beq	s2,s4,588 <vprintf+0x17e>
 468:	f9d9079b          	addw	a5,s2,-99
 46c:	0ff7f793          	zext.b	a5,a5
 470:	12fb6563          	bltu	s6,a5,59a <vprintf+0x190>
 474:	f9d9079b          	addw	a5,s2,-99
 478:	0ff7f713          	zext.b	a4,a5
 47c:	10eb6f63          	bltu	s6,a4,59a <vprintf+0x190>
 480:	00271793          	sll	a5,a4,0x2
 484:	00000717          	auipc	a4,0x0
 488:	32c70713          	add	a4,a4,812 # 7b0 <malloc+0xf4>
 48c:	97ba                	add	a5,a5,a4
 48e:	439c                	lw	a5,0(a5)
 490:	97ba                	add	a5,a5,a4
 492:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 494:	008b8913          	add	s2,s7,8
 498:	4685                	li	a3,1
 49a:	4629                	li	a2,10
 49c:	000ba583          	lw	a1,0(s7)
 4a0:	8556                	mv	a0,s5
 4a2:	00000097          	auipc	ra,0x0
 4a6:	ebc080e7          	jalr	-324(ra) # 35e <printint>
 4aa:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ac:	4981                	li	s3,0
 4ae:	b745                	j	44e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4b0:	008b8913          	add	s2,s7,8
 4b4:	4681                	li	a3,0
 4b6:	4629                	li	a2,10
 4b8:	000ba583          	lw	a1,0(s7)
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	ea0080e7          	jalr	-352(ra) # 35e <printint>
 4c6:	8bca                	mv	s7,s2
      state = 0;
 4c8:	4981                	li	s3,0
 4ca:	b751                	j	44e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 4cc:	008b8913          	add	s2,s7,8
 4d0:	4681                	li	a3,0
 4d2:	4641                	li	a2,16
 4d4:	000ba583          	lw	a1,0(s7)
 4d8:	8556                	mv	a0,s5
 4da:	00000097          	auipc	ra,0x0
 4de:	e84080e7          	jalr	-380(ra) # 35e <printint>
 4e2:	8bca                	mv	s7,s2
      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	b7a5                	j	44e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 4e8:	008b8c13          	add	s8,s7,8
 4ec:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4f0:	03000593          	li	a1,48
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	e46080e7          	jalr	-442(ra) # 33c <putc>
  putc(fd, 'x');
 4fe:	07800593          	li	a1,120
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	e38080e7          	jalr	-456(ra) # 33c <putc>
 50c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 50e:	00000b97          	auipc	s7,0x0
 512:	2fab8b93          	add	s7,s7,762 # 808 <digits>
 516:	03c9d793          	srl	a5,s3,0x3c
 51a:	97de                	add	a5,a5,s7
 51c:	0007c583          	lbu	a1,0(a5)
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	e1a080e7          	jalr	-486(ra) # 33c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 52a:	0992                	sll	s3,s3,0x4
 52c:	397d                	addw	s2,s2,-1
 52e:	fe0914e3          	bnez	s2,516 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 532:	8be2                	mv	s7,s8
      state = 0;
 534:	4981                	li	s3,0
 536:	bf21                	j	44e <vprintf+0x44>
        s = va_arg(ap, char*);
 538:	008b8993          	add	s3,s7,8
 53c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 540:	02090163          	beqz	s2,562 <vprintf+0x158>
        while(*s != 0){
 544:	00094583          	lbu	a1,0(s2)
 548:	c9a5                	beqz	a1,5b8 <vprintf+0x1ae>
          putc(fd, *s);
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	df0080e7          	jalr	-528(ra) # 33c <putc>
          s++;
 554:	0905                	add	s2,s2,1
        while(*s != 0){
 556:	00094583          	lbu	a1,0(s2)
 55a:	f9e5                	bnez	a1,54a <vprintf+0x140>
        s = va_arg(ap, char*);
 55c:	8bce                	mv	s7,s3
      state = 0;
 55e:	4981                	li	s3,0
 560:	b5fd                	j	44e <vprintf+0x44>
          s = "(null)";
 562:	00000917          	auipc	s2,0x0
 566:	24690913          	add	s2,s2,582 # 7a8 <malloc+0xec>
        while(*s != 0){
 56a:	02800593          	li	a1,40
 56e:	bff1                	j	54a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 570:	008b8913          	add	s2,s7,8
 574:	000bc583          	lbu	a1,0(s7)
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	dc2080e7          	jalr	-574(ra) # 33c <putc>
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
 586:	b5e1                	j	44e <vprintf+0x44>
        putc(fd, c);
 588:	02500593          	li	a1,37
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	dae080e7          	jalr	-594(ra) # 33c <putc>
      state = 0;
 596:	4981                	li	s3,0
 598:	bd5d                	j	44e <vprintf+0x44>
        putc(fd, '%');
 59a:	02500593          	li	a1,37
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	d9c080e7          	jalr	-612(ra) # 33c <putc>
        putc(fd, c);
 5a8:	85ca                	mv	a1,s2
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	d90080e7          	jalr	-624(ra) # 33c <putc>
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bd61                	j	44e <vprintf+0x44>
        s = va_arg(ap, char*);
 5b8:	8bce                	mv	s7,s3
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bd49                	j	44e <vprintf+0x44>
    }
  }
}
 5be:	60a6                	ld	ra,72(sp)
 5c0:	6406                	ld	s0,64(sp)
 5c2:	74e2                	ld	s1,56(sp)
 5c4:	7942                	ld	s2,48(sp)
 5c6:	79a2                	ld	s3,40(sp)
 5c8:	7a02                	ld	s4,32(sp)
 5ca:	6ae2                	ld	s5,24(sp)
 5cc:	6b42                	ld	s6,16(sp)
 5ce:	6ba2                	ld	s7,8(sp)
 5d0:	6c02                	ld	s8,0(sp)
 5d2:	6161                	add	sp,sp,80
 5d4:	8082                	ret

00000000000005d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5d6:	715d                	add	sp,sp,-80
 5d8:	ec06                	sd	ra,24(sp)
 5da:	e822                	sd	s0,16(sp)
 5dc:	1000                	add	s0,sp,32
 5de:	e010                	sd	a2,0(s0)
 5e0:	e414                	sd	a3,8(s0)
 5e2:	e818                	sd	a4,16(s0)
 5e4:	ec1c                	sd	a5,24(s0)
 5e6:	03043023          	sd	a6,32(s0)
 5ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5f2:	8622                	mv	a2,s0
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e16080e7          	jalr	-490(ra) # 40a <vprintf>
}
 5fc:	60e2                	ld	ra,24(sp)
 5fe:	6442                	ld	s0,16(sp)
 600:	6161                	add	sp,sp,80
 602:	8082                	ret

0000000000000604 <printf>:

void
printf(const char *fmt, ...)
{
 604:	711d                	add	sp,sp,-96
 606:	ec06                	sd	ra,24(sp)
 608:	e822                	sd	s0,16(sp)
 60a:	1000                	add	s0,sp,32
 60c:	e40c                	sd	a1,8(s0)
 60e:	e810                	sd	a2,16(s0)
 610:	ec14                	sd	a3,24(s0)
 612:	f018                	sd	a4,32(s0)
 614:	f41c                	sd	a5,40(s0)
 616:	03043823          	sd	a6,48(s0)
 61a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 61e:	00840613          	add	a2,s0,8
 622:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 626:	85aa                	mv	a1,a0
 628:	4505                	li	a0,1
 62a:	00000097          	auipc	ra,0x0
 62e:	de0080e7          	jalr	-544(ra) # 40a <vprintf>
}
 632:	60e2                	ld	ra,24(sp)
 634:	6442                	ld	s0,16(sp)
 636:	6125                	add	sp,sp,96
 638:	8082                	ret

000000000000063a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 63a:	1141                	add	sp,sp,-16
 63c:	e422                	sd	s0,8(sp)
 63e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 640:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 644:	00000797          	auipc	a5,0x0
 648:	1dc7b783          	ld	a5,476(a5) # 820 <freep>
 64c:	a02d                	j	676 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 64e:	4618                	lw	a4,8(a2)
 650:	9f2d                	addw	a4,a4,a1
 652:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 656:	6398                	ld	a4,0(a5)
 658:	6310                	ld	a2,0(a4)
 65a:	a83d                	j	698 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 65c:	ff852703          	lw	a4,-8(a0)
 660:	9f31                	addw	a4,a4,a2
 662:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 664:	ff053683          	ld	a3,-16(a0)
 668:	a091                	j	6ac <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66a:	6398                	ld	a4,0(a5)
 66c:	00e7e463          	bltu	a5,a4,674 <free+0x3a>
 670:	00e6ea63          	bltu	a3,a4,684 <free+0x4a>
{
 674:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 676:	fed7fae3          	bgeu	a5,a3,66a <free+0x30>
 67a:	6398                	ld	a4,0(a5)
 67c:	00e6e463          	bltu	a3,a4,684 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 680:	fee7eae3          	bltu	a5,a4,674 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 684:	ff852583          	lw	a1,-8(a0)
 688:	6390                	ld	a2,0(a5)
 68a:	02059813          	sll	a6,a1,0x20
 68e:	01c85713          	srl	a4,a6,0x1c
 692:	9736                	add	a4,a4,a3
 694:	fae60de3          	beq	a2,a4,64e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 698:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 69c:	4790                	lw	a2,8(a5)
 69e:	02061593          	sll	a1,a2,0x20
 6a2:	01c5d713          	srl	a4,a1,0x1c
 6a6:	973e                	add	a4,a4,a5
 6a8:	fae68ae3          	beq	a3,a4,65c <free+0x22>
    p->s.ptr = bp->s.ptr;
 6ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6ae:	00000717          	auipc	a4,0x0
 6b2:	16f73923          	sd	a5,370(a4) # 820 <freep>
}
 6b6:	6422                	ld	s0,8(sp)
 6b8:	0141                	add	sp,sp,16
 6ba:	8082                	ret

00000000000006bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6bc:	7139                	add	sp,sp,-64
 6be:	fc06                	sd	ra,56(sp)
 6c0:	f822                	sd	s0,48(sp)
 6c2:	f426                	sd	s1,40(sp)
 6c4:	f04a                	sd	s2,32(sp)
 6c6:	ec4e                	sd	s3,24(sp)
 6c8:	e852                	sd	s4,16(sp)
 6ca:	e456                	sd	s5,8(sp)
 6cc:	e05a                	sd	s6,0(sp)
 6ce:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d0:	02051493          	sll	s1,a0,0x20
 6d4:	9081                	srl	s1,s1,0x20
 6d6:	04bd                	add	s1,s1,15
 6d8:	8091                	srl	s1,s1,0x4
 6da:	0014899b          	addw	s3,s1,1
 6de:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 6e0:	00000517          	auipc	a0,0x0
 6e4:	14053503          	ld	a0,320(a0) # 820 <freep>
 6e8:	c515                	beqz	a0,714 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6ec:	4798                	lw	a4,8(a5)
 6ee:	02977f63          	bgeu	a4,s1,72c <malloc+0x70>
  if(nu < 4096)
 6f2:	8a4e                	mv	s4,s3
 6f4:	0009871b          	sext.w	a4,s3
 6f8:	6685                	lui	a3,0x1
 6fa:	00d77363          	bgeu	a4,a3,700 <malloc+0x44>
 6fe:	6a05                	lui	s4,0x1
 700:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 704:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 708:	00000917          	auipc	s2,0x0
 70c:	11890913          	add	s2,s2,280 # 820 <freep>
  if(p == (char*)-1)
 710:	5afd                	li	s5,-1
 712:	a895                	j	786 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 714:	00000797          	auipc	a5,0x0
 718:	11478793          	add	a5,a5,276 # 828 <base>
 71c:	00000717          	auipc	a4,0x0
 720:	10f73223          	sd	a5,260(a4) # 820 <freep>
 724:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 726:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 72a:	b7e1                	j	6f2 <malloc+0x36>
      if(p->s.size == nunits)
 72c:	02e48c63          	beq	s1,a4,764 <malloc+0xa8>
        p->s.size -= nunits;
 730:	4137073b          	subw	a4,a4,s3
 734:	c798                	sw	a4,8(a5)
        p += p->s.size;
 736:	02071693          	sll	a3,a4,0x20
 73a:	01c6d713          	srl	a4,a3,0x1c
 73e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 740:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 744:	00000717          	auipc	a4,0x0
 748:	0ca73e23          	sd	a0,220(a4) # 820 <freep>
      return (void*)(p + 1);
 74c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 750:	70e2                	ld	ra,56(sp)
 752:	7442                	ld	s0,48(sp)
 754:	74a2                	ld	s1,40(sp)
 756:	7902                	ld	s2,32(sp)
 758:	69e2                	ld	s3,24(sp)
 75a:	6a42                	ld	s4,16(sp)
 75c:	6aa2                	ld	s5,8(sp)
 75e:	6b02                	ld	s6,0(sp)
 760:	6121                	add	sp,sp,64
 762:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 764:	6398                	ld	a4,0(a5)
 766:	e118                	sd	a4,0(a0)
 768:	bff1                	j	744 <malloc+0x88>
  hp->s.size = nu;
 76a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 76e:	0541                	add	a0,a0,16
 770:	00000097          	auipc	ra,0x0
 774:	eca080e7          	jalr	-310(ra) # 63a <free>
  return freep;
 778:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 77c:	d971                	beqz	a0,750 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 780:	4798                	lw	a4,8(a5)
 782:	fa9775e3          	bgeu	a4,s1,72c <malloc+0x70>
    if(p == freep)
 786:	00093703          	ld	a4,0(s2)
 78a:	853e                	mv	a0,a5
 78c:	fef719e3          	bne	a4,a5,77e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 790:	8552                	mv	a0,s4
 792:	00000097          	auipc	ra,0x0
 796:	b82080e7          	jalr	-1150(ra) # 314 <sbrk>
  if(p == (char*)-1)
 79a:	fd5518e3          	bne	a0,s5,76a <malloc+0xae>
        return 0;
 79e:	4501                	li	a0,0
 7a0:	bf45                	j	750 <malloc+0x94>
