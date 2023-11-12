
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
 
int
main(int argc, char *argv[])
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d063          	bge	a5,a0,2a <main+0x2a>
    fprintf(2, "Usage:time outs\n");
    exit(1);
  }
 
  int time = atoi(argv[1]);
   e:	6588                	ld	a0,8(a1)
  10:	00000097          	auipc	ra,0x0
  14:	1a8080e7          	jalr	424(ra) # 1b8 <atoi>
  sleep(time);
  18:	00000097          	auipc	ra,0x0
  1c:	32a080e7          	jalr	810(ra) # 342 <sleep>
  exit(0);
  20:	4501                	li	a0,0
  22:	00000097          	auipc	ra,0x0
  26:	290080e7          	jalr	656(ra) # 2b2 <exit>
    fprintf(2, "Usage:time outs\n");
  2a:	00000597          	auipc	a1,0x0
  2e:	79e58593          	add	a1,a1,1950 # 7c8 <malloc+0xe6>
  32:	4509                	li	a0,2
  34:	00000097          	auipc	ra,0x0
  38:	5c8080e7          	jalr	1480(ra) # 5fc <fprintf>
    exit(1);
  3c:	4505                	li	a0,1
  3e:	00000097          	auipc	ra,0x0
  42:	274080e7          	jalr	628(ra) # 2b2 <exit>

0000000000000046 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  46:	1141                	add	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4c:	87aa                	mv	a5,a0
  4e:	0585                	add	a1,a1,1
  50:	0785                	add	a5,a5,1
  52:	fff5c703          	lbu	a4,-1(a1)
  56:	fee78fa3          	sb	a4,-1(a5)
  5a:	fb75                	bnez	a4,4e <strcpy+0x8>
    ;
  return os;
}
  5c:	6422                	ld	s0,8(sp)
  5e:	0141                	add	sp,sp,16
  60:	8082                	ret

0000000000000062 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  62:	1141                	add	sp,sp,-16
  64:	e422                	sd	s0,8(sp)
  66:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	cb91                	beqz	a5,80 <strcmp+0x1e>
  6e:	0005c703          	lbu	a4,0(a1)
  72:	00f71763          	bne	a4,a5,80 <strcmp+0x1e>
    p++, q++;
  76:	0505                	add	a0,a0,1
  78:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	fbe5                	bnez	a5,6e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  80:	0005c503          	lbu	a0,0(a1)
}
  84:	40a7853b          	subw	a0,a5,a0
  88:	6422                	ld	s0,8(sp)
  8a:	0141                	add	sp,sp,16
  8c:	8082                	ret

000000000000008e <strlen>:

uint
strlen(const char *s)
{
  8e:	1141                	add	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  94:	00054783          	lbu	a5,0(a0)
  98:	cf91                	beqz	a5,b4 <strlen+0x26>
  9a:	0505                	add	a0,a0,1
  9c:	87aa                	mv	a5,a0
  9e:	86be                	mv	a3,a5
  a0:	0785                	add	a5,a5,1
  a2:	fff7c703          	lbu	a4,-1(a5)
  a6:	ff65                	bnez	a4,9e <strlen+0x10>
  a8:	40a6853b          	subw	a0,a3,a0
  ac:	2505                	addw	a0,a0,1
    ;
  return n;
}
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	add	sp,sp,16
  b2:	8082                	ret
  for(n = 0; s[n]; n++)
  b4:	4501                	li	a0,0
  b6:	bfe5                	j	ae <strlen+0x20>

00000000000000b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b8:	1141                	add	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  be:	ca19                	beqz	a2,d4 <memset+0x1c>
  c0:	87aa                	mv	a5,a0
  c2:	1602                	sll	a2,a2,0x20
  c4:	9201                	srl	a2,a2,0x20
  c6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ca:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ce:	0785                	add	a5,a5,1
  d0:	fee79de3          	bne	a5,a4,ca <memset+0x12>
  }
  return dst;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	add	sp,sp,16
  d8:	8082                	ret

00000000000000da <strchr>:

char*
strchr(const char *s, char c)
{
  da:	1141                	add	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	add	s0,sp,16
  for(; *s; s++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cb99                	beqz	a5,fa <strchr+0x20>
    if(*s == c)
  e6:	00f58763          	beq	a1,a5,f4 <strchr+0x1a>
  for(; *s; s++)
  ea:	0505                	add	a0,a0,1
  ec:	00054783          	lbu	a5,0(a0)
  f0:	fbfd                	bnez	a5,e6 <strchr+0xc>
      return (char*)s;
  return 0;
  f2:	4501                	li	a0,0
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	add	sp,sp,16
  f8:	8082                	ret
  return 0;
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strchr+0x1a>

00000000000000fe <gets>:

char*
gets(char *buf, int max)
{
  fe:	711d                	add	sp,sp,-96
 100:	ec86                	sd	ra,88(sp)
 102:	e8a2                	sd	s0,80(sp)
 104:	e4a6                	sd	s1,72(sp)
 106:	e0ca                	sd	s2,64(sp)
 108:	fc4e                	sd	s3,56(sp)
 10a:	f852                	sd	s4,48(sp)
 10c:	f456                	sd	s5,40(sp)
 10e:	f05a                	sd	s6,32(sp)
 110:	ec5e                	sd	s7,24(sp)
 112:	1080                	add	s0,sp,96
 114:	8baa                	mv	s7,a0
 116:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 118:	892a                	mv	s2,a0
 11a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11c:	4aa9                	li	s5,10
 11e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 120:	89a6                	mv	s3,s1
 122:	2485                	addw	s1,s1,1
 124:	0344d863          	bge	s1,s4,154 <gets+0x56>
    cc = read(0, &c, 1);
 128:	4605                	li	a2,1
 12a:	faf40593          	add	a1,s0,-81
 12e:	4501                	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	19a080e7          	jalr	410(ra) # 2ca <read>
    if(cc < 1)
 138:	00a05e63          	blez	a0,154 <gets+0x56>
    buf[i++] = c;
 13c:	faf44783          	lbu	a5,-81(s0)
 140:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 144:	01578763          	beq	a5,s5,152 <gets+0x54>
 148:	0905                	add	s2,s2,1
 14a:	fd679be3          	bne	a5,s6,120 <gets+0x22>
  for(i=0; i+1 < max; ){
 14e:	89a6                	mv	s3,s1
 150:	a011                	j	154 <gets+0x56>
 152:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 154:	99de                	add	s3,s3,s7
 156:	00098023          	sb	zero,0(s3)
  return buf;
}
 15a:	855e                	mv	a0,s7
 15c:	60e6                	ld	ra,88(sp)
 15e:	6446                	ld	s0,80(sp)
 160:	64a6                	ld	s1,72(sp)
 162:	6906                	ld	s2,64(sp)
 164:	79e2                	ld	s3,56(sp)
 166:	7a42                	ld	s4,48(sp)
 168:	7aa2                	ld	s5,40(sp)
 16a:	7b02                	ld	s6,32(sp)
 16c:	6be2                	ld	s7,24(sp)
 16e:	6125                	add	sp,sp,96
 170:	8082                	ret

0000000000000172 <stat>:

int
stat(const char *n, struct stat *st)
{
 172:	1101                	add	sp,sp,-32
 174:	ec06                	sd	ra,24(sp)
 176:	e822                	sd	s0,16(sp)
 178:	e426                	sd	s1,8(sp)
 17a:	e04a                	sd	s2,0(sp)
 17c:	1000                	add	s0,sp,32
 17e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 180:	4581                	li	a1,0
 182:	00000097          	auipc	ra,0x0
 186:	170080e7          	jalr	368(ra) # 2f2 <open>
  if(fd < 0)
 18a:	02054563          	bltz	a0,1b4 <stat+0x42>
 18e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 190:	85ca                	mv	a1,s2
 192:	00000097          	auipc	ra,0x0
 196:	178080e7          	jalr	376(ra) # 30a <fstat>
 19a:	892a                	mv	s2,a0
  close(fd);
 19c:	8526                	mv	a0,s1
 19e:	00000097          	auipc	ra,0x0
 1a2:	13c080e7          	jalr	316(ra) # 2da <close>
  return r;
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	64a2                	ld	s1,8(sp)
 1ae:	6902                	ld	s2,0(sp)
 1b0:	6105                	add	sp,sp,32
 1b2:	8082                	ret
    return -1;
 1b4:	597d                	li	s2,-1
 1b6:	bfc5                	j	1a6 <stat+0x34>

00000000000001b8 <atoi>:

int
atoi(const char *s)
{
 1b8:	1141                	add	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1be:	00054683          	lbu	a3,0(a0)
 1c2:	fd06879b          	addw	a5,a3,-48
 1c6:	0ff7f793          	zext.b	a5,a5
 1ca:	4625                	li	a2,9
 1cc:	02f66863          	bltu	a2,a5,1fc <atoi+0x44>
 1d0:	872a                	mv	a4,a0
  n = 0;
 1d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d4:	0705                	add	a4,a4,1
 1d6:	0025179b          	sllw	a5,a0,0x2
 1da:	9fa9                	addw	a5,a5,a0
 1dc:	0017979b          	sllw	a5,a5,0x1
 1e0:	9fb5                	addw	a5,a5,a3
 1e2:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e6:	00074683          	lbu	a3,0(a4)
 1ea:	fd06879b          	addw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	fef671e3          	bgeu	a2,a5,1d4 <atoi+0x1c>
  return n;
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	add	sp,sp,16
 1fa:	8082                	ret
  n = 0;
 1fc:	4501                	li	a0,0
 1fe:	bfe5                	j	1f6 <atoi+0x3e>

0000000000000200 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 200:	1141                	add	sp,sp,-16
 202:	e422                	sd	s0,8(sp)
 204:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 206:	02b57463          	bgeu	a0,a1,22e <memmove+0x2e>
    while(n-- > 0)
 20a:	00c05f63          	blez	a2,228 <memmove+0x28>
 20e:	1602                	sll	a2,a2,0x20
 210:	9201                	srl	a2,a2,0x20
 212:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 216:	872a                	mv	a4,a0
      *dst++ = *src++;
 218:	0585                	add	a1,a1,1
 21a:	0705                	add	a4,a4,1
 21c:	fff5c683          	lbu	a3,-1(a1)
 220:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 224:	fee79ae3          	bne	a5,a4,218 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	add	sp,sp,16
 22c:	8082                	ret
    dst += n;
 22e:	00c50733          	add	a4,a0,a2
    src += n;
 232:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 234:	fec05ae3          	blez	a2,228 <memmove+0x28>
 238:	fff6079b          	addw	a5,a2,-1
 23c:	1782                	sll	a5,a5,0x20
 23e:	9381                	srl	a5,a5,0x20
 240:	fff7c793          	not	a5,a5
 244:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 246:	15fd                	add	a1,a1,-1
 248:	177d                	add	a4,a4,-1
 24a:	0005c683          	lbu	a3,0(a1)
 24e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 252:	fee79ae3          	bne	a5,a4,246 <memmove+0x46>
 256:	bfc9                	j	228 <memmove+0x28>

0000000000000258 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 258:	1141                	add	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25e:	ca05                	beqz	a2,28e <memcmp+0x36>
 260:	fff6069b          	addw	a3,a2,-1
 264:	1682                	sll	a3,a3,0x20
 266:	9281                	srl	a3,a3,0x20
 268:	0685                	add	a3,a3,1
 26a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26c:	00054783          	lbu	a5,0(a0)
 270:	0005c703          	lbu	a4,0(a1)
 274:	00e79863          	bne	a5,a4,284 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 278:	0505                	add	a0,a0,1
    p2++;
 27a:	0585                	add	a1,a1,1
  while (n-- > 0) {
 27c:	fed518e3          	bne	a0,a3,26c <memcmp+0x14>
  }
  return 0;
 280:	4501                	li	a0,0
 282:	a019                	j	288 <memcmp+0x30>
      return *p1 - *p2;
 284:	40e7853b          	subw	a0,a5,a4
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	add	sp,sp,16
 28c:	8082                	ret
  return 0;
 28e:	4501                	li	a0,0
 290:	bfe5                	j	288 <memcmp+0x30>

0000000000000292 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 292:	1141                	add	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 29a:	00000097          	auipc	ra,0x0
 29e:	f66080e7          	jalr	-154(ra) # 200 <memmove>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	add	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2aa:	4885                	li	a7,1
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b2:	4889                	li	a7,2
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ba:	488d                	li	a7,3
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c2:	4891                	li	a7,4
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <read>:
.global read
read:
 li a7, SYS_read
 2ca:	4895                	li	a7,5
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <write>:
.global write
write:
 li a7, SYS_write
 2d2:	48c1                	li	a7,16
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <close>:
.global close
close:
 li a7, SYS_close
 2da:	48d5                	li	a7,21
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e2:	4899                	li	a7,6
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ea:	489d                	li	a7,7
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <open>:
.global open
open:
 li a7, SYS_open
 2f2:	48bd                	li	a7,15
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2fa:	48c5                	li	a7,17
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 302:	48c9                	li	a7,18
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 30a:	48a1                	li	a7,8
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <link>:
.global link
link:
 li a7, SYS_link
 312:	48cd                	li	a7,19
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 31a:	48d1                	li	a7,20
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 322:	48a5                	li	a7,9
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <dup>:
.global dup
dup:
 li a7, SYS_dup
 32a:	48a9                	li	a7,10
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 332:	48ad                	li	a7,11
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 33a:	48b1                	li	a7,12
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 342:	48b5                	li	a7,13
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 34a:	48b9                	li	a7,14
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <trace>:
.global trace
trace:
 li a7, SYS_trace
 352:	48d9                	li	a7,22
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 35a:	48dd                	li	a7,23
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 362:	1101                	add	sp,sp,-32
 364:	ec06                	sd	ra,24(sp)
 366:	e822                	sd	s0,16(sp)
 368:	1000                	add	s0,sp,32
 36a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36e:	4605                	li	a2,1
 370:	fef40593          	add	a1,s0,-17
 374:	00000097          	auipc	ra,0x0
 378:	f5e080e7          	jalr	-162(ra) # 2d2 <write>
}
 37c:	60e2                	ld	ra,24(sp)
 37e:	6442                	ld	s0,16(sp)
 380:	6105                	add	sp,sp,32
 382:	8082                	ret

0000000000000384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 384:	7139                	add	sp,sp,-64
 386:	fc06                	sd	ra,56(sp)
 388:	f822                	sd	s0,48(sp)
 38a:	f426                	sd	s1,40(sp)
 38c:	f04a                	sd	s2,32(sp)
 38e:	ec4e                	sd	s3,24(sp)
 390:	0080                	add	s0,sp,64
 392:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 394:	c299                	beqz	a3,39a <printint+0x16>
 396:	0805c963          	bltz	a1,428 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39a:	2581                	sext.w	a1,a1
  neg = 0;
 39c:	4881                	li	a7,0
 39e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a4:	2601                	sext.w	a2,a2
 3a6:	00000517          	auipc	a0,0x0
 3aa:	49a50513          	add	a0,a0,1178 # 840 <digits>
 3ae:	883a                	mv	a6,a4
 3b0:	2705                	addw	a4,a4,1
 3b2:	02c5f7bb          	remuw	a5,a1,a2
 3b6:	1782                	sll	a5,a5,0x20
 3b8:	9381                	srl	a5,a5,0x20
 3ba:	97aa                	add	a5,a5,a0
 3bc:	0007c783          	lbu	a5,0(a5)
 3c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c4:	0005879b          	sext.w	a5,a1
 3c8:	02c5d5bb          	divuw	a1,a1,a2
 3cc:	0685                	add	a3,a3,1
 3ce:	fec7f0e3          	bgeu	a5,a2,3ae <printint+0x2a>
  if(neg)
 3d2:	00088c63          	beqz	a7,3ea <printint+0x66>
    buf[i++] = '-';
 3d6:	fd070793          	add	a5,a4,-48
 3da:	00878733          	add	a4,a5,s0
 3de:	02d00793          	li	a5,45
 3e2:	fef70823          	sb	a5,-16(a4)
 3e6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3ea:	02e05863          	blez	a4,41a <printint+0x96>
 3ee:	fc040793          	add	a5,s0,-64
 3f2:	00e78933          	add	s2,a5,a4
 3f6:	fff78993          	add	s3,a5,-1
 3fa:	99ba                	add	s3,s3,a4
 3fc:	377d                	addw	a4,a4,-1
 3fe:	1702                	sll	a4,a4,0x20
 400:	9301                	srl	a4,a4,0x20
 402:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 406:	fff94583          	lbu	a1,-1(s2)
 40a:	8526                	mv	a0,s1
 40c:	00000097          	auipc	ra,0x0
 410:	f56080e7          	jalr	-170(ra) # 362 <putc>
  while(--i >= 0)
 414:	197d                	add	s2,s2,-1
 416:	ff3918e3          	bne	s2,s3,406 <printint+0x82>
}
 41a:	70e2                	ld	ra,56(sp)
 41c:	7442                	ld	s0,48(sp)
 41e:	74a2                	ld	s1,40(sp)
 420:	7902                	ld	s2,32(sp)
 422:	69e2                	ld	s3,24(sp)
 424:	6121                	add	sp,sp,64
 426:	8082                	ret
    x = -xx;
 428:	40b005bb          	negw	a1,a1
    neg = 1;
 42c:	4885                	li	a7,1
    x = -xx;
 42e:	bf85                	j	39e <printint+0x1a>

0000000000000430 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 430:	715d                	add	sp,sp,-80
 432:	e486                	sd	ra,72(sp)
 434:	e0a2                	sd	s0,64(sp)
 436:	fc26                	sd	s1,56(sp)
 438:	f84a                	sd	s2,48(sp)
 43a:	f44e                	sd	s3,40(sp)
 43c:	f052                	sd	s4,32(sp)
 43e:	ec56                	sd	s5,24(sp)
 440:	e85a                	sd	s6,16(sp)
 442:	e45e                	sd	s7,8(sp)
 444:	e062                	sd	s8,0(sp)
 446:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 448:	0005c903          	lbu	s2,0(a1)
 44c:	18090c63          	beqz	s2,5e4 <vprintf+0x1b4>
 450:	8aaa                	mv	s5,a0
 452:	8bb2                	mv	s7,a2
 454:	00158493          	add	s1,a1,1
  state = 0;
 458:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45a:	02500a13          	li	s4,37
 45e:	4b55                	li	s6,21
 460:	a839                	j	47e <vprintf+0x4e>
        putc(fd, c);
 462:	85ca                	mv	a1,s2
 464:	8556                	mv	a0,s5
 466:	00000097          	auipc	ra,0x0
 46a:	efc080e7          	jalr	-260(ra) # 362 <putc>
 46e:	a019                	j	474 <vprintf+0x44>
    } else if(state == '%'){
 470:	01498d63          	beq	s3,s4,48a <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 474:	0485                	add	s1,s1,1
 476:	fff4c903          	lbu	s2,-1(s1)
 47a:	16090563          	beqz	s2,5e4 <vprintf+0x1b4>
    if(state == 0){
 47e:	fe0999e3          	bnez	s3,470 <vprintf+0x40>
      if(c == '%'){
 482:	ff4910e3          	bne	s2,s4,462 <vprintf+0x32>
        state = '%';
 486:	89d2                	mv	s3,s4
 488:	b7f5                	j	474 <vprintf+0x44>
      if(c == 'd'){
 48a:	13490263          	beq	s2,s4,5ae <vprintf+0x17e>
 48e:	f9d9079b          	addw	a5,s2,-99
 492:	0ff7f793          	zext.b	a5,a5
 496:	12fb6563          	bltu	s6,a5,5c0 <vprintf+0x190>
 49a:	f9d9079b          	addw	a5,s2,-99
 49e:	0ff7f713          	zext.b	a4,a5
 4a2:	10eb6f63          	bltu	s6,a4,5c0 <vprintf+0x190>
 4a6:	00271793          	sll	a5,a4,0x2
 4aa:	00000717          	auipc	a4,0x0
 4ae:	33e70713          	add	a4,a4,830 # 7e8 <malloc+0x106>
 4b2:	97ba                	add	a5,a5,a4
 4b4:	439c                	lw	a5,0(a5)
 4b6:	97ba                	add	a5,a5,a4
 4b8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4ba:	008b8913          	add	s2,s7,8
 4be:	4685                	li	a3,1
 4c0:	4629                	li	a2,10
 4c2:	000ba583          	lw	a1,0(s7)
 4c6:	8556                	mv	a0,s5
 4c8:	00000097          	auipc	ra,0x0
 4cc:	ebc080e7          	jalr	-324(ra) # 384 <printint>
 4d0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d2:	4981                	li	s3,0
 4d4:	b745                	j	474 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4d6:	008b8913          	add	s2,s7,8
 4da:	4681                	li	a3,0
 4dc:	4629                	li	a2,10
 4de:	000ba583          	lw	a1,0(s7)
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	ea0080e7          	jalr	-352(ra) # 384 <printint>
 4ec:	8bca                	mv	s7,s2
      state = 0;
 4ee:	4981                	li	s3,0
 4f0:	b751                	j	474 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 4f2:	008b8913          	add	s2,s7,8
 4f6:	4681                	li	a3,0
 4f8:	4641                	li	a2,16
 4fa:	000ba583          	lw	a1,0(s7)
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	e84080e7          	jalr	-380(ra) # 384 <printint>
 508:	8bca                	mv	s7,s2
      state = 0;
 50a:	4981                	li	s3,0
 50c:	b7a5                	j	474 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 50e:	008b8c13          	add	s8,s7,8
 512:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 516:	03000593          	li	a1,48
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	e46080e7          	jalr	-442(ra) # 362 <putc>
  putc(fd, 'x');
 524:	07800593          	li	a1,120
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	e38080e7          	jalr	-456(ra) # 362 <putc>
 532:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 534:	00000b97          	auipc	s7,0x0
 538:	30cb8b93          	add	s7,s7,780 # 840 <digits>
 53c:	03c9d793          	srl	a5,s3,0x3c
 540:	97de                	add	a5,a5,s7
 542:	0007c583          	lbu	a1,0(a5)
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e1a080e7          	jalr	-486(ra) # 362 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 550:	0992                	sll	s3,s3,0x4
 552:	397d                	addw	s2,s2,-1
 554:	fe0914e3          	bnez	s2,53c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 558:	8be2                	mv	s7,s8
      state = 0;
 55a:	4981                	li	s3,0
 55c:	bf21                	j	474 <vprintf+0x44>
        s = va_arg(ap, char*);
 55e:	008b8993          	add	s3,s7,8
 562:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 566:	02090163          	beqz	s2,588 <vprintf+0x158>
        while(*s != 0){
 56a:	00094583          	lbu	a1,0(s2)
 56e:	c9a5                	beqz	a1,5de <vprintf+0x1ae>
          putc(fd, *s);
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	df0080e7          	jalr	-528(ra) # 362 <putc>
          s++;
 57a:	0905                	add	s2,s2,1
        while(*s != 0){
 57c:	00094583          	lbu	a1,0(s2)
 580:	f9e5                	bnez	a1,570 <vprintf+0x140>
        s = va_arg(ap, char*);
 582:	8bce                	mv	s7,s3
      state = 0;
 584:	4981                	li	s3,0
 586:	b5fd                	j	474 <vprintf+0x44>
          s = "(null)";
 588:	00000917          	auipc	s2,0x0
 58c:	25890913          	add	s2,s2,600 # 7e0 <malloc+0xfe>
        while(*s != 0){
 590:	02800593          	li	a1,40
 594:	bff1                	j	570 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 596:	008b8913          	add	s2,s7,8
 59a:	000bc583          	lbu	a1,0(s7)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	dc2080e7          	jalr	-574(ra) # 362 <putc>
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b5e1                	j	474 <vprintf+0x44>
        putc(fd, c);
 5ae:	02500593          	li	a1,37
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	dae080e7          	jalr	-594(ra) # 362 <putc>
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bd5d                	j	474 <vprintf+0x44>
        putc(fd, '%');
 5c0:	02500593          	li	a1,37
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	d9c080e7          	jalr	-612(ra) # 362 <putc>
        putc(fd, c);
 5ce:	85ca                	mv	a1,s2
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	d90080e7          	jalr	-624(ra) # 362 <putc>
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bd61                	j	474 <vprintf+0x44>
        s = va_arg(ap, char*);
 5de:	8bce                	mv	s7,s3
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bd49                	j	474 <vprintf+0x44>
    }
  }
}
 5e4:	60a6                	ld	ra,72(sp)
 5e6:	6406                	ld	s0,64(sp)
 5e8:	74e2                	ld	s1,56(sp)
 5ea:	7942                	ld	s2,48(sp)
 5ec:	79a2                	ld	s3,40(sp)
 5ee:	7a02                	ld	s4,32(sp)
 5f0:	6ae2                	ld	s5,24(sp)
 5f2:	6b42                	ld	s6,16(sp)
 5f4:	6ba2                	ld	s7,8(sp)
 5f6:	6c02                	ld	s8,0(sp)
 5f8:	6161                	add	sp,sp,80
 5fa:	8082                	ret

00000000000005fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5fc:	715d                	add	sp,sp,-80
 5fe:	ec06                	sd	ra,24(sp)
 600:	e822                	sd	s0,16(sp)
 602:	1000                	add	s0,sp,32
 604:	e010                	sd	a2,0(s0)
 606:	e414                	sd	a3,8(s0)
 608:	e818                	sd	a4,16(s0)
 60a:	ec1c                	sd	a5,24(s0)
 60c:	03043023          	sd	a6,32(s0)
 610:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 614:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 618:	8622                	mv	a2,s0
 61a:	00000097          	auipc	ra,0x0
 61e:	e16080e7          	jalr	-490(ra) # 430 <vprintf>
}
 622:	60e2                	ld	ra,24(sp)
 624:	6442                	ld	s0,16(sp)
 626:	6161                	add	sp,sp,80
 628:	8082                	ret

000000000000062a <printf>:

void
printf(const char *fmt, ...)
{
 62a:	711d                	add	sp,sp,-96
 62c:	ec06                	sd	ra,24(sp)
 62e:	e822                	sd	s0,16(sp)
 630:	1000                	add	s0,sp,32
 632:	e40c                	sd	a1,8(s0)
 634:	e810                	sd	a2,16(s0)
 636:	ec14                	sd	a3,24(s0)
 638:	f018                	sd	a4,32(s0)
 63a:	f41c                	sd	a5,40(s0)
 63c:	03043823          	sd	a6,48(s0)
 640:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 644:	00840613          	add	a2,s0,8
 648:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 64c:	85aa                	mv	a1,a0
 64e:	4505                	li	a0,1
 650:	00000097          	auipc	ra,0x0
 654:	de0080e7          	jalr	-544(ra) # 430 <vprintf>
}
 658:	60e2                	ld	ra,24(sp)
 65a:	6442                	ld	s0,16(sp)
 65c:	6125                	add	sp,sp,96
 65e:	8082                	ret

0000000000000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	1141                	add	sp,sp,-16
 662:	e422                	sd	s0,8(sp)
 664:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 666:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66a:	00000797          	auipc	a5,0x0
 66e:	1ee7b783          	ld	a5,494(a5) # 858 <freep>
 672:	a02d                	j	69c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 674:	4618                	lw	a4,8(a2)
 676:	9f2d                	addw	a4,a4,a1
 678:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 67c:	6398                	ld	a4,0(a5)
 67e:	6310                	ld	a2,0(a4)
 680:	a83d                	j	6be <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 682:	ff852703          	lw	a4,-8(a0)
 686:	9f31                	addw	a4,a4,a2
 688:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 68a:	ff053683          	ld	a3,-16(a0)
 68e:	a091                	j	6d2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 690:	6398                	ld	a4,0(a5)
 692:	00e7e463          	bltu	a5,a4,69a <free+0x3a>
 696:	00e6ea63          	bltu	a3,a4,6aa <free+0x4a>
{
 69a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69c:	fed7fae3          	bgeu	a5,a3,690 <free+0x30>
 6a0:	6398                	ld	a4,0(a5)
 6a2:	00e6e463          	bltu	a3,a4,6aa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a6:	fee7eae3          	bltu	a5,a4,69a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6aa:	ff852583          	lw	a1,-8(a0)
 6ae:	6390                	ld	a2,0(a5)
 6b0:	02059813          	sll	a6,a1,0x20
 6b4:	01c85713          	srl	a4,a6,0x1c
 6b8:	9736                	add	a4,a4,a3
 6ba:	fae60de3          	beq	a2,a4,674 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6be:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6c2:	4790                	lw	a2,8(a5)
 6c4:	02061593          	sll	a1,a2,0x20
 6c8:	01c5d713          	srl	a4,a1,0x1c
 6cc:	973e                	add	a4,a4,a5
 6ce:	fae68ae3          	beq	a3,a4,682 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6d2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6d4:	00000717          	auipc	a4,0x0
 6d8:	18f73223          	sd	a5,388(a4) # 858 <freep>
}
 6dc:	6422                	ld	s0,8(sp)
 6de:	0141                	add	sp,sp,16
 6e0:	8082                	ret

00000000000006e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e2:	7139                	add	sp,sp,-64
 6e4:	fc06                	sd	ra,56(sp)
 6e6:	f822                	sd	s0,48(sp)
 6e8:	f426                	sd	s1,40(sp)
 6ea:	f04a                	sd	s2,32(sp)
 6ec:	ec4e                	sd	s3,24(sp)
 6ee:	e852                	sd	s4,16(sp)
 6f0:	e456                	sd	s5,8(sp)
 6f2:	e05a                	sd	s6,0(sp)
 6f4:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f6:	02051493          	sll	s1,a0,0x20
 6fa:	9081                	srl	s1,s1,0x20
 6fc:	04bd                	add	s1,s1,15
 6fe:	8091                	srl	s1,s1,0x4
 700:	0014899b          	addw	s3,s1,1
 704:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 706:	00000517          	auipc	a0,0x0
 70a:	15253503          	ld	a0,338(a0) # 858 <freep>
 70e:	c515                	beqz	a0,73a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 710:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 712:	4798                	lw	a4,8(a5)
 714:	02977f63          	bgeu	a4,s1,752 <malloc+0x70>
  if(nu < 4096)
 718:	8a4e                	mv	s4,s3
 71a:	0009871b          	sext.w	a4,s3
 71e:	6685                	lui	a3,0x1
 720:	00d77363          	bgeu	a4,a3,726 <malloc+0x44>
 724:	6a05                	lui	s4,0x1
 726:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 72a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 72e:	00000917          	auipc	s2,0x0
 732:	12a90913          	add	s2,s2,298 # 858 <freep>
  if(p == (char*)-1)
 736:	5afd                	li	s5,-1
 738:	a895                	j	7ac <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 73a:	00000797          	auipc	a5,0x0
 73e:	12678793          	add	a5,a5,294 # 860 <base>
 742:	00000717          	auipc	a4,0x0
 746:	10f73b23          	sd	a5,278(a4) # 858 <freep>
 74a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 74c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 750:	b7e1                	j	718 <malloc+0x36>
      if(p->s.size == nunits)
 752:	02e48c63          	beq	s1,a4,78a <malloc+0xa8>
        p->s.size -= nunits;
 756:	4137073b          	subw	a4,a4,s3
 75a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 75c:	02071693          	sll	a3,a4,0x20
 760:	01c6d713          	srl	a4,a3,0x1c
 764:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 766:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 76a:	00000717          	auipc	a4,0x0
 76e:	0ea73723          	sd	a0,238(a4) # 858 <freep>
      return (void*)(p + 1);
 772:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 776:	70e2                	ld	ra,56(sp)
 778:	7442                	ld	s0,48(sp)
 77a:	74a2                	ld	s1,40(sp)
 77c:	7902                	ld	s2,32(sp)
 77e:	69e2                	ld	s3,24(sp)
 780:	6a42                	ld	s4,16(sp)
 782:	6aa2                	ld	s5,8(sp)
 784:	6b02                	ld	s6,0(sp)
 786:	6121                	add	sp,sp,64
 788:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	e118                	sd	a4,0(a0)
 78e:	bff1                	j	76a <malloc+0x88>
  hp->s.size = nu;
 790:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 794:	0541                	add	a0,a0,16
 796:	00000097          	auipc	ra,0x0
 79a:	eca080e7          	jalr	-310(ra) # 660 <free>
  return freep;
 79e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7a2:	d971                	beqz	a0,776 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a6:	4798                	lw	a4,8(a5)
 7a8:	fa9775e3          	bgeu	a4,s1,752 <malloc+0x70>
    if(p == freep)
 7ac:	00093703          	ld	a4,0(s2)
 7b0:	853e                	mv	a0,a5
 7b2:	fef719e3          	bne	a4,a5,7a4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7b6:	8552                	mv	a0,s4
 7b8:	00000097          	auipc	ra,0x0
 7bc:	b82080e7          	jalr	-1150(ra) # 33a <sbrk>
  if(p == (char*)-1)
 7c0:	fd5518e3          	bne	a0,s5,790 <malloc+0xae>
        return 0;
 7c4:	4501                	li	a0,0
 7c6:	bf45                	j	776 <malloc+0x94>
