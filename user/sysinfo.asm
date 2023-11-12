
user/_sysinfo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/sysinfo.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	add	s0,sp,32
    // param error
    if (argc != 1)
   8:	4785                	li	a5,1
   a:	02f50163          	beq	a0,a5,2c <main+0x2c>
    {
        fprintf(2, "Usage: %s need not param\n", argv[0]);
   e:	6190                	ld	a2,0(a1)
  10:	00000597          	auipc	a1,0x0
  14:	7d058593          	add	a1,a1,2000 # 7e0 <malloc+0xea>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	5f6080e7          	jalr	1526(ra) # 610 <fprintf>
        exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2a2080e7          	jalr	674(ra) # 2c6 <exit>
    }

    struct sysinfo info;
    sysinfo(&info);
  2c:	fe040513          	add	a0,s0,-32
  30:	00000097          	auipc	ra,0x0
  34:	33e080e7          	jalr	830(ra) # 36e <sysinfo>
    // print the sysinfo
    printf("free space: %d\nused process: %d\n", info.freemem, info.nproc);
  38:	fe843603          	ld	a2,-24(s0)
  3c:	fe043583          	ld	a1,-32(s0)
  40:	00000517          	auipc	a0,0x0
  44:	7c050513          	add	a0,a0,1984 # 800 <malloc+0x10a>
  48:	00000097          	auipc	ra,0x0
  4c:	5f6080e7          	jalr	1526(ra) # 63e <printf>
    exit(0);
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	274080e7          	jalr	628(ra) # 2c6 <exit>

000000000000005a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  5a:	1141                	add	sp,sp,-16
  5c:	e422                	sd	s0,8(sp)
  5e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  60:	87aa                	mv	a5,a0
  62:	0585                	add	a1,a1,1
  64:	0785                	add	a5,a5,1
  66:	fff5c703          	lbu	a4,-1(a1)
  6a:	fee78fa3          	sb	a4,-1(a5)
  6e:	fb75                	bnez	a4,62 <strcpy+0x8>
    ;
  return os;
}
  70:	6422                	ld	s0,8(sp)
  72:	0141                	add	sp,sp,16
  74:	8082                	ret

0000000000000076 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  76:	1141                	add	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cb91                	beqz	a5,94 <strcmp+0x1e>
  82:	0005c703          	lbu	a4,0(a1)
  86:	00f71763          	bne	a4,a5,94 <strcmp+0x1e>
    p++, q++;
  8a:	0505                	add	a0,a0,1
  8c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  8e:	00054783          	lbu	a5,0(a0)
  92:	fbe5                	bnez	a5,82 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  94:	0005c503          	lbu	a0,0(a1)
}
  98:	40a7853b          	subw	a0,a5,a0
  9c:	6422                	ld	s0,8(sp)
  9e:	0141                	add	sp,sp,16
  a0:	8082                	ret

00000000000000a2 <strlen>:

uint
strlen(const char *s)
{
  a2:	1141                	add	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	cf91                	beqz	a5,c8 <strlen+0x26>
  ae:	0505                	add	a0,a0,1
  b0:	87aa                	mv	a5,a0
  b2:	86be                	mv	a3,a5
  b4:	0785                	add	a5,a5,1
  b6:	fff7c703          	lbu	a4,-1(a5)
  ba:	ff65                	bnez	a4,b2 <strlen+0x10>
  bc:	40a6853b          	subw	a0,a3,a0
  c0:	2505                	addw	a0,a0,1
    ;
  return n;
}
  c2:	6422                	ld	s0,8(sp)
  c4:	0141                	add	sp,sp,16
  c6:	8082                	ret
  for(n = 0; s[n]; n++)
  c8:	4501                	li	a0,0
  ca:	bfe5                	j	c2 <strlen+0x20>

00000000000000cc <memset>:

void*
memset(void *dst, int c, uint n)
{
  cc:	1141                	add	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d2:	ca19                	beqz	a2,e8 <memset+0x1c>
  d4:	87aa                	mv	a5,a0
  d6:	1602                	sll	a2,a2,0x20
  d8:	9201                	srl	a2,a2,0x20
  da:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  de:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e2:	0785                	add	a5,a5,1
  e4:	fee79de3          	bne	a5,a4,de <memset+0x12>
  }
  return dst;
}
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	add	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strchr>:

char*
strchr(const char *s, char c)
{
  ee:	1141                	add	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	add	s0,sp,16
  for(; *s; s++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb99                	beqz	a5,10e <strchr+0x20>
    if(*s == c)
  fa:	00f58763          	beq	a1,a5,108 <strchr+0x1a>
  for(; *s; s++)
  fe:	0505                	add	a0,a0,1
 100:	00054783          	lbu	a5,0(a0)
 104:	fbfd                	bnez	a5,fa <strchr+0xc>
      return (char*)s;
  return 0;
 106:	4501                	li	a0,0
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	add	sp,sp,16
 10c:	8082                	ret
  return 0;
 10e:	4501                	li	a0,0
 110:	bfe5                	j	108 <strchr+0x1a>

0000000000000112 <gets>:

char*
gets(char *buf, int max)
{
 112:	711d                	add	sp,sp,-96
 114:	ec86                	sd	ra,88(sp)
 116:	e8a2                	sd	s0,80(sp)
 118:	e4a6                	sd	s1,72(sp)
 11a:	e0ca                	sd	s2,64(sp)
 11c:	fc4e                	sd	s3,56(sp)
 11e:	f852                	sd	s4,48(sp)
 120:	f456                	sd	s5,40(sp)
 122:	f05a                	sd	s6,32(sp)
 124:	ec5e                	sd	s7,24(sp)
 126:	1080                	add	s0,sp,96
 128:	8baa                	mv	s7,a0
 12a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12c:	892a                	mv	s2,a0
 12e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 130:	4aa9                	li	s5,10
 132:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 134:	89a6                	mv	s3,s1
 136:	2485                	addw	s1,s1,1
 138:	0344d863          	bge	s1,s4,168 <gets+0x56>
    cc = read(0, &c, 1);
 13c:	4605                	li	a2,1
 13e:	faf40593          	add	a1,s0,-81
 142:	4501                	li	a0,0
 144:	00000097          	auipc	ra,0x0
 148:	19a080e7          	jalr	410(ra) # 2de <read>
    if(cc < 1)
 14c:	00a05e63          	blez	a0,168 <gets+0x56>
    buf[i++] = c;
 150:	faf44783          	lbu	a5,-81(s0)
 154:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 158:	01578763          	beq	a5,s5,166 <gets+0x54>
 15c:	0905                	add	s2,s2,1
 15e:	fd679be3          	bne	a5,s6,134 <gets+0x22>
  for(i=0; i+1 < max; ){
 162:	89a6                	mv	s3,s1
 164:	a011                	j	168 <gets+0x56>
 166:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 168:	99de                	add	s3,s3,s7
 16a:	00098023          	sb	zero,0(s3)
  return buf;
}
 16e:	855e                	mv	a0,s7
 170:	60e6                	ld	ra,88(sp)
 172:	6446                	ld	s0,80(sp)
 174:	64a6                	ld	s1,72(sp)
 176:	6906                	ld	s2,64(sp)
 178:	79e2                	ld	s3,56(sp)
 17a:	7a42                	ld	s4,48(sp)
 17c:	7aa2                	ld	s5,40(sp)
 17e:	7b02                	ld	s6,32(sp)
 180:	6be2                	ld	s7,24(sp)
 182:	6125                	add	sp,sp,96
 184:	8082                	ret

0000000000000186 <stat>:

int
stat(const char *n, struct stat *st)
{
 186:	1101                	add	sp,sp,-32
 188:	ec06                	sd	ra,24(sp)
 18a:	e822                	sd	s0,16(sp)
 18c:	e426                	sd	s1,8(sp)
 18e:	e04a                	sd	s2,0(sp)
 190:	1000                	add	s0,sp,32
 192:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	4581                	li	a1,0
 196:	00000097          	auipc	ra,0x0
 19a:	170080e7          	jalr	368(ra) # 306 <open>
  if(fd < 0)
 19e:	02054563          	bltz	a0,1c8 <stat+0x42>
 1a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a4:	85ca                	mv	a1,s2
 1a6:	00000097          	auipc	ra,0x0
 1aa:	178080e7          	jalr	376(ra) # 31e <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	00000097          	auipc	ra,0x0
 1b6:	13c080e7          	jalr	316(ra) # 2ee <close>
  return r;
}
 1ba:	854a                	mv	a0,s2
 1bc:	60e2                	ld	ra,24(sp)
 1be:	6442                	ld	s0,16(sp)
 1c0:	64a2                	ld	s1,8(sp)
 1c2:	6902                	ld	s2,0(sp)
 1c4:	6105                	add	sp,sp,32
 1c6:	8082                	ret
    return -1;
 1c8:	597d                	li	s2,-1
 1ca:	bfc5                	j	1ba <stat+0x34>

00000000000001cc <atoi>:

int
atoi(const char *s)
{
 1cc:	1141                	add	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d2:	00054683          	lbu	a3,0(a0)
 1d6:	fd06879b          	addw	a5,a3,-48
 1da:	0ff7f793          	zext.b	a5,a5
 1de:	4625                	li	a2,9
 1e0:	02f66863          	bltu	a2,a5,210 <atoi+0x44>
 1e4:	872a                	mv	a4,a0
  n = 0;
 1e6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e8:	0705                	add	a4,a4,1
 1ea:	0025179b          	sllw	a5,a0,0x2
 1ee:	9fa9                	addw	a5,a5,a0
 1f0:	0017979b          	sllw	a5,a5,0x1
 1f4:	9fb5                	addw	a5,a5,a3
 1f6:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fa:	00074683          	lbu	a3,0(a4)
 1fe:	fd06879b          	addw	a5,a3,-48
 202:	0ff7f793          	zext.b	a5,a5
 206:	fef671e3          	bgeu	a2,a5,1e8 <atoi+0x1c>
  return n;
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	add	sp,sp,16
 20e:	8082                	ret
  n = 0;
 210:	4501                	li	a0,0
 212:	bfe5                	j	20a <atoi+0x3e>

0000000000000214 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 214:	1141                	add	sp,sp,-16
 216:	e422                	sd	s0,8(sp)
 218:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 21a:	02b57463          	bgeu	a0,a1,242 <memmove+0x2e>
    while(n-- > 0)
 21e:	00c05f63          	blez	a2,23c <memmove+0x28>
 222:	1602                	sll	a2,a2,0x20
 224:	9201                	srl	a2,a2,0x20
 226:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 22a:	872a                	mv	a4,a0
      *dst++ = *src++;
 22c:	0585                	add	a1,a1,1
 22e:	0705                	add	a4,a4,1
 230:	fff5c683          	lbu	a3,-1(a1)
 234:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 238:	fee79ae3          	bne	a5,a4,22c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	add	sp,sp,16
 240:	8082                	ret
    dst += n;
 242:	00c50733          	add	a4,a0,a2
    src += n;
 246:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 248:	fec05ae3          	blez	a2,23c <memmove+0x28>
 24c:	fff6079b          	addw	a5,a2,-1
 250:	1782                	sll	a5,a5,0x20
 252:	9381                	srl	a5,a5,0x20
 254:	fff7c793          	not	a5,a5
 258:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25a:	15fd                	add	a1,a1,-1
 25c:	177d                	add	a4,a4,-1
 25e:	0005c683          	lbu	a3,0(a1)
 262:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 266:	fee79ae3          	bne	a5,a4,25a <memmove+0x46>
 26a:	bfc9                	j	23c <memmove+0x28>

000000000000026c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26c:	1141                	add	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 272:	ca05                	beqz	a2,2a2 <memcmp+0x36>
 274:	fff6069b          	addw	a3,a2,-1
 278:	1682                	sll	a3,a3,0x20
 27a:	9281                	srl	a3,a3,0x20
 27c:	0685                	add	a3,a3,1
 27e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 280:	00054783          	lbu	a5,0(a0)
 284:	0005c703          	lbu	a4,0(a1)
 288:	00e79863          	bne	a5,a4,298 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28c:	0505                	add	a0,a0,1
    p2++;
 28e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 290:	fed518e3          	bne	a0,a3,280 <memcmp+0x14>
  }
  return 0;
 294:	4501                	li	a0,0
 296:	a019                	j	29c <memcmp+0x30>
      return *p1 - *p2;
 298:	40e7853b          	subw	a0,a5,a4
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	add	sp,sp,16
 2a0:	8082                	ret
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	bfe5                	j	29c <memcmp+0x30>

00000000000002a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a6:	1141                	add	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2ae:	00000097          	auipc	ra,0x0
 2b2:	f66080e7          	jalr	-154(ra) # 214 <memmove>
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	add	sp,sp,16
 2bc:	8082                	ret

00000000000002be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2be:	4885                	li	a7,1
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c6:	4889                	li	a7,2
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ce:	488d                	li	a7,3
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d6:	4891                	li	a7,4
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <read>:
.global read
read:
 li a7, SYS_read
 2de:	4895                	li	a7,5
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <write>:
.global write
write:
 li a7, SYS_write
 2e6:	48c1                	li	a7,16
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <close>:
.global close
close:
 li a7, SYS_close
 2ee:	48d5                	li	a7,21
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f6:	4899                	li	a7,6
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fe:	489d                	li	a7,7
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <open>:
.global open
open:
 li a7, SYS_open
 306:	48bd                	li	a7,15
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30e:	48c5                	li	a7,17
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 316:	48c9                	li	a7,18
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31e:	48a1                	li	a7,8
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <link>:
.global link
link:
 li a7, SYS_link
 326:	48cd                	li	a7,19
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32e:	48d1                	li	a7,20
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 336:	48a5                	li	a7,9
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <dup>:
.global dup
dup:
 li a7, SYS_dup
 33e:	48a9                	li	a7,10
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 346:	48ad                	li	a7,11
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34e:	48b1                	li	a7,12
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 356:	48b5                	li	a7,13
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35e:	48b9                	li	a7,14
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <trace>:
.global trace
trace:
 li a7, SYS_trace
 366:	48d9                	li	a7,22
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 36e:	48dd                	li	a7,23
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 376:	1101                	add	sp,sp,-32
 378:	ec06                	sd	ra,24(sp)
 37a:	e822                	sd	s0,16(sp)
 37c:	1000                	add	s0,sp,32
 37e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 382:	4605                	li	a2,1
 384:	fef40593          	add	a1,s0,-17
 388:	00000097          	auipc	ra,0x0
 38c:	f5e080e7          	jalr	-162(ra) # 2e6 <write>
}
 390:	60e2                	ld	ra,24(sp)
 392:	6442                	ld	s0,16(sp)
 394:	6105                	add	sp,sp,32
 396:	8082                	ret

0000000000000398 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 398:	7139                	add	sp,sp,-64
 39a:	fc06                	sd	ra,56(sp)
 39c:	f822                	sd	s0,48(sp)
 39e:	f426                	sd	s1,40(sp)
 3a0:	f04a                	sd	s2,32(sp)
 3a2:	ec4e                	sd	s3,24(sp)
 3a4:	0080                	add	s0,sp,64
 3a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a8:	c299                	beqz	a3,3ae <printint+0x16>
 3aa:	0805c963          	bltz	a1,43c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ae:	2581                	sext.w	a1,a1
  neg = 0;
 3b0:	4881                	li	a7,0
 3b2:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b8:	2601                	sext.w	a2,a2
 3ba:	00000517          	auipc	a0,0x0
 3be:	4ce50513          	add	a0,a0,1230 # 888 <digits>
 3c2:	883a                	mv	a6,a4
 3c4:	2705                	addw	a4,a4,1
 3c6:	02c5f7bb          	remuw	a5,a1,a2
 3ca:	1782                	sll	a5,a5,0x20
 3cc:	9381                	srl	a5,a5,0x20
 3ce:	97aa                	add	a5,a5,a0
 3d0:	0007c783          	lbu	a5,0(a5)
 3d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d8:	0005879b          	sext.w	a5,a1
 3dc:	02c5d5bb          	divuw	a1,a1,a2
 3e0:	0685                	add	a3,a3,1
 3e2:	fec7f0e3          	bgeu	a5,a2,3c2 <printint+0x2a>
  if(neg)
 3e6:	00088c63          	beqz	a7,3fe <printint+0x66>
    buf[i++] = '-';
 3ea:	fd070793          	add	a5,a4,-48
 3ee:	00878733          	add	a4,a5,s0
 3f2:	02d00793          	li	a5,45
 3f6:	fef70823          	sb	a5,-16(a4)
 3fa:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3fe:	02e05863          	blez	a4,42e <printint+0x96>
 402:	fc040793          	add	a5,s0,-64
 406:	00e78933          	add	s2,a5,a4
 40a:	fff78993          	add	s3,a5,-1
 40e:	99ba                	add	s3,s3,a4
 410:	377d                	addw	a4,a4,-1
 412:	1702                	sll	a4,a4,0x20
 414:	9301                	srl	a4,a4,0x20
 416:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41a:	fff94583          	lbu	a1,-1(s2)
 41e:	8526                	mv	a0,s1
 420:	00000097          	auipc	ra,0x0
 424:	f56080e7          	jalr	-170(ra) # 376 <putc>
  while(--i >= 0)
 428:	197d                	add	s2,s2,-1
 42a:	ff3918e3          	bne	s2,s3,41a <printint+0x82>
}
 42e:	70e2                	ld	ra,56(sp)
 430:	7442                	ld	s0,48(sp)
 432:	74a2                	ld	s1,40(sp)
 434:	7902                	ld	s2,32(sp)
 436:	69e2                	ld	s3,24(sp)
 438:	6121                	add	sp,sp,64
 43a:	8082                	ret
    x = -xx;
 43c:	40b005bb          	negw	a1,a1
    neg = 1;
 440:	4885                	li	a7,1
    x = -xx;
 442:	bf85                	j	3b2 <printint+0x1a>

0000000000000444 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 444:	715d                	add	sp,sp,-80
 446:	e486                	sd	ra,72(sp)
 448:	e0a2                	sd	s0,64(sp)
 44a:	fc26                	sd	s1,56(sp)
 44c:	f84a                	sd	s2,48(sp)
 44e:	f44e                	sd	s3,40(sp)
 450:	f052                	sd	s4,32(sp)
 452:	ec56                	sd	s5,24(sp)
 454:	e85a                	sd	s6,16(sp)
 456:	e45e                	sd	s7,8(sp)
 458:	e062                	sd	s8,0(sp)
 45a:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45c:	0005c903          	lbu	s2,0(a1)
 460:	18090c63          	beqz	s2,5f8 <vprintf+0x1b4>
 464:	8aaa                	mv	s5,a0
 466:	8bb2                	mv	s7,a2
 468:	00158493          	add	s1,a1,1
  state = 0;
 46c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 46e:	02500a13          	li	s4,37
 472:	4b55                	li	s6,21
 474:	a839                	j	492 <vprintf+0x4e>
        putc(fd, c);
 476:	85ca                	mv	a1,s2
 478:	8556                	mv	a0,s5
 47a:	00000097          	auipc	ra,0x0
 47e:	efc080e7          	jalr	-260(ra) # 376 <putc>
 482:	a019                	j	488 <vprintf+0x44>
    } else if(state == '%'){
 484:	01498d63          	beq	s3,s4,49e <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 488:	0485                	add	s1,s1,1
 48a:	fff4c903          	lbu	s2,-1(s1)
 48e:	16090563          	beqz	s2,5f8 <vprintf+0x1b4>
    if(state == 0){
 492:	fe0999e3          	bnez	s3,484 <vprintf+0x40>
      if(c == '%'){
 496:	ff4910e3          	bne	s2,s4,476 <vprintf+0x32>
        state = '%';
 49a:	89d2                	mv	s3,s4
 49c:	b7f5                	j	488 <vprintf+0x44>
      if(c == 'd'){
 49e:	13490263          	beq	s2,s4,5c2 <vprintf+0x17e>
 4a2:	f9d9079b          	addw	a5,s2,-99
 4a6:	0ff7f793          	zext.b	a5,a5
 4aa:	12fb6563          	bltu	s6,a5,5d4 <vprintf+0x190>
 4ae:	f9d9079b          	addw	a5,s2,-99
 4b2:	0ff7f713          	zext.b	a4,a5
 4b6:	10eb6f63          	bltu	s6,a4,5d4 <vprintf+0x190>
 4ba:	00271793          	sll	a5,a4,0x2
 4be:	00000717          	auipc	a4,0x0
 4c2:	37270713          	add	a4,a4,882 # 830 <malloc+0x13a>
 4c6:	97ba                	add	a5,a5,a4
 4c8:	439c                	lw	a5,0(a5)
 4ca:	97ba                	add	a5,a5,a4
 4cc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4ce:	008b8913          	add	s2,s7,8
 4d2:	4685                	li	a3,1
 4d4:	4629                	li	a2,10
 4d6:	000ba583          	lw	a1,0(s7)
 4da:	8556                	mv	a0,s5
 4dc:	00000097          	auipc	ra,0x0
 4e0:	ebc080e7          	jalr	-324(ra) # 398 <printint>
 4e4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e6:	4981                	li	s3,0
 4e8:	b745                	j	488 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ea:	008b8913          	add	s2,s7,8
 4ee:	4681                	li	a3,0
 4f0:	4629                	li	a2,10
 4f2:	000ba583          	lw	a1,0(s7)
 4f6:	8556                	mv	a0,s5
 4f8:	00000097          	auipc	ra,0x0
 4fc:	ea0080e7          	jalr	-352(ra) # 398 <printint>
 500:	8bca                	mv	s7,s2
      state = 0;
 502:	4981                	li	s3,0
 504:	b751                	j	488 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 506:	008b8913          	add	s2,s7,8
 50a:	4681                	li	a3,0
 50c:	4641                	li	a2,16
 50e:	000ba583          	lw	a1,0(s7)
 512:	8556                	mv	a0,s5
 514:	00000097          	auipc	ra,0x0
 518:	e84080e7          	jalr	-380(ra) # 398 <printint>
 51c:	8bca                	mv	s7,s2
      state = 0;
 51e:	4981                	li	s3,0
 520:	b7a5                	j	488 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 522:	008b8c13          	add	s8,s7,8
 526:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 52a:	03000593          	li	a1,48
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	e46080e7          	jalr	-442(ra) # 376 <putc>
  putc(fd, 'x');
 538:	07800593          	li	a1,120
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e38080e7          	jalr	-456(ra) # 376 <putc>
 546:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 548:	00000b97          	auipc	s7,0x0
 54c:	340b8b93          	add	s7,s7,832 # 888 <digits>
 550:	03c9d793          	srl	a5,s3,0x3c
 554:	97de                	add	a5,a5,s7
 556:	0007c583          	lbu	a1,0(a5)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e1a080e7          	jalr	-486(ra) # 376 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 564:	0992                	sll	s3,s3,0x4
 566:	397d                	addw	s2,s2,-1
 568:	fe0914e3          	bnez	s2,550 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 56c:	8be2                	mv	s7,s8
      state = 0;
 56e:	4981                	li	s3,0
 570:	bf21                	j	488 <vprintf+0x44>
        s = va_arg(ap, char*);
 572:	008b8993          	add	s3,s7,8
 576:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 57a:	02090163          	beqz	s2,59c <vprintf+0x158>
        while(*s != 0){
 57e:	00094583          	lbu	a1,0(s2)
 582:	c9a5                	beqz	a1,5f2 <vprintf+0x1ae>
          putc(fd, *s);
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	df0080e7          	jalr	-528(ra) # 376 <putc>
          s++;
 58e:	0905                	add	s2,s2,1
        while(*s != 0){
 590:	00094583          	lbu	a1,0(s2)
 594:	f9e5                	bnez	a1,584 <vprintf+0x140>
        s = va_arg(ap, char*);
 596:	8bce                	mv	s7,s3
      state = 0;
 598:	4981                	li	s3,0
 59a:	b5fd                	j	488 <vprintf+0x44>
          s = "(null)";
 59c:	00000917          	auipc	s2,0x0
 5a0:	28c90913          	add	s2,s2,652 # 828 <malloc+0x132>
        while(*s != 0){
 5a4:	02800593          	li	a1,40
 5a8:	bff1                	j	584 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5aa:	008b8913          	add	s2,s7,8
 5ae:	000bc583          	lbu	a1,0(s7)
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	dc2080e7          	jalr	-574(ra) # 376 <putc>
 5bc:	8bca                	mv	s7,s2
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b5e1                	j	488 <vprintf+0x44>
        putc(fd, c);
 5c2:	02500593          	li	a1,37
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	dae080e7          	jalr	-594(ra) # 376 <putc>
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bd5d                	j	488 <vprintf+0x44>
        putc(fd, '%');
 5d4:	02500593          	li	a1,37
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	d9c080e7          	jalr	-612(ra) # 376 <putc>
        putc(fd, c);
 5e2:	85ca                	mv	a1,s2
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	d90080e7          	jalr	-624(ra) # 376 <putc>
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bd61                	j	488 <vprintf+0x44>
        s = va_arg(ap, char*);
 5f2:	8bce                	mv	s7,s3
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bd49                	j	488 <vprintf+0x44>
    }
  }
}
 5f8:	60a6                	ld	ra,72(sp)
 5fa:	6406                	ld	s0,64(sp)
 5fc:	74e2                	ld	s1,56(sp)
 5fe:	7942                	ld	s2,48(sp)
 600:	79a2                	ld	s3,40(sp)
 602:	7a02                	ld	s4,32(sp)
 604:	6ae2                	ld	s5,24(sp)
 606:	6b42                	ld	s6,16(sp)
 608:	6ba2                	ld	s7,8(sp)
 60a:	6c02                	ld	s8,0(sp)
 60c:	6161                	add	sp,sp,80
 60e:	8082                	ret

0000000000000610 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 610:	715d                	add	sp,sp,-80
 612:	ec06                	sd	ra,24(sp)
 614:	e822                	sd	s0,16(sp)
 616:	1000                	add	s0,sp,32
 618:	e010                	sd	a2,0(s0)
 61a:	e414                	sd	a3,8(s0)
 61c:	e818                	sd	a4,16(s0)
 61e:	ec1c                	sd	a5,24(s0)
 620:	03043023          	sd	a6,32(s0)
 624:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 628:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 62c:	8622                	mv	a2,s0
 62e:	00000097          	auipc	ra,0x0
 632:	e16080e7          	jalr	-490(ra) # 444 <vprintf>
}
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	6161                	add	sp,sp,80
 63c:	8082                	ret

000000000000063e <printf>:

void
printf(const char *fmt, ...)
{
 63e:	711d                	add	sp,sp,-96
 640:	ec06                	sd	ra,24(sp)
 642:	e822                	sd	s0,16(sp)
 644:	1000                	add	s0,sp,32
 646:	e40c                	sd	a1,8(s0)
 648:	e810                	sd	a2,16(s0)
 64a:	ec14                	sd	a3,24(s0)
 64c:	f018                	sd	a4,32(s0)
 64e:	f41c                	sd	a5,40(s0)
 650:	03043823          	sd	a6,48(s0)
 654:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 658:	00840613          	add	a2,s0,8
 65c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 660:	85aa                	mv	a1,a0
 662:	4505                	li	a0,1
 664:	00000097          	auipc	ra,0x0
 668:	de0080e7          	jalr	-544(ra) # 444 <vprintf>
}
 66c:	60e2                	ld	ra,24(sp)
 66e:	6442                	ld	s0,16(sp)
 670:	6125                	add	sp,sp,96
 672:	8082                	ret

0000000000000674 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 674:	1141                	add	sp,sp,-16
 676:	e422                	sd	s0,8(sp)
 678:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67e:	00000797          	auipc	a5,0x0
 682:	2227b783          	ld	a5,546(a5) # 8a0 <freep>
 686:	a02d                	j	6b0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 688:	4618                	lw	a4,8(a2)
 68a:	9f2d                	addw	a4,a4,a1
 68c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 690:	6398                	ld	a4,0(a5)
 692:	6310                	ld	a2,0(a4)
 694:	a83d                	j	6d2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 696:	ff852703          	lw	a4,-8(a0)
 69a:	9f31                	addw	a4,a4,a2
 69c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 69e:	ff053683          	ld	a3,-16(a0)
 6a2:	a091                	j	6e6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a4:	6398                	ld	a4,0(a5)
 6a6:	00e7e463          	bltu	a5,a4,6ae <free+0x3a>
 6aa:	00e6ea63          	bltu	a3,a4,6be <free+0x4a>
{
 6ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b0:	fed7fae3          	bgeu	a5,a3,6a4 <free+0x30>
 6b4:	6398                	ld	a4,0(a5)
 6b6:	00e6e463          	bltu	a3,a4,6be <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ba:	fee7eae3          	bltu	a5,a4,6ae <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6be:	ff852583          	lw	a1,-8(a0)
 6c2:	6390                	ld	a2,0(a5)
 6c4:	02059813          	sll	a6,a1,0x20
 6c8:	01c85713          	srl	a4,a6,0x1c
 6cc:	9736                	add	a4,a4,a3
 6ce:	fae60de3          	beq	a2,a4,688 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6d6:	4790                	lw	a2,8(a5)
 6d8:	02061593          	sll	a1,a2,0x20
 6dc:	01c5d713          	srl	a4,a1,0x1c
 6e0:	973e                	add	a4,a4,a5
 6e2:	fae68ae3          	beq	a3,a4,696 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6e8:	00000717          	auipc	a4,0x0
 6ec:	1af73c23          	sd	a5,440(a4) # 8a0 <freep>
}
 6f0:	6422                	ld	s0,8(sp)
 6f2:	0141                	add	sp,sp,16
 6f4:	8082                	ret

00000000000006f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f6:	7139                	add	sp,sp,-64
 6f8:	fc06                	sd	ra,56(sp)
 6fa:	f822                	sd	s0,48(sp)
 6fc:	f426                	sd	s1,40(sp)
 6fe:	f04a                	sd	s2,32(sp)
 700:	ec4e                	sd	s3,24(sp)
 702:	e852                	sd	s4,16(sp)
 704:	e456                	sd	s5,8(sp)
 706:	e05a                	sd	s6,0(sp)
 708:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70a:	02051493          	sll	s1,a0,0x20
 70e:	9081                	srl	s1,s1,0x20
 710:	04bd                	add	s1,s1,15
 712:	8091                	srl	s1,s1,0x4
 714:	0014899b          	addw	s3,s1,1
 718:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 71a:	00000517          	auipc	a0,0x0
 71e:	18653503          	ld	a0,390(a0) # 8a0 <freep>
 722:	c515                	beqz	a0,74e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 724:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 726:	4798                	lw	a4,8(a5)
 728:	02977f63          	bgeu	a4,s1,766 <malloc+0x70>
  if(nu < 4096)
 72c:	8a4e                	mv	s4,s3
 72e:	0009871b          	sext.w	a4,s3
 732:	6685                	lui	a3,0x1
 734:	00d77363          	bgeu	a4,a3,73a <malloc+0x44>
 738:	6a05                	lui	s4,0x1
 73a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 73e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 742:	00000917          	auipc	s2,0x0
 746:	15e90913          	add	s2,s2,350 # 8a0 <freep>
  if(p == (char*)-1)
 74a:	5afd                	li	s5,-1
 74c:	a895                	j	7c0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 74e:	00000797          	auipc	a5,0x0
 752:	15a78793          	add	a5,a5,346 # 8a8 <base>
 756:	00000717          	auipc	a4,0x0
 75a:	14f73523          	sd	a5,330(a4) # 8a0 <freep>
 75e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 760:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 764:	b7e1                	j	72c <malloc+0x36>
      if(p->s.size == nunits)
 766:	02e48c63          	beq	s1,a4,79e <malloc+0xa8>
        p->s.size -= nunits;
 76a:	4137073b          	subw	a4,a4,s3
 76e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 770:	02071693          	sll	a3,a4,0x20
 774:	01c6d713          	srl	a4,a3,0x1c
 778:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 77a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 77e:	00000717          	auipc	a4,0x0
 782:	12a73123          	sd	a0,290(a4) # 8a0 <freep>
      return (void*)(p + 1);
 786:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 78a:	70e2                	ld	ra,56(sp)
 78c:	7442                	ld	s0,48(sp)
 78e:	74a2                	ld	s1,40(sp)
 790:	7902                	ld	s2,32(sp)
 792:	69e2                	ld	s3,24(sp)
 794:	6a42                	ld	s4,16(sp)
 796:	6aa2                	ld	s5,8(sp)
 798:	6b02                	ld	s6,0(sp)
 79a:	6121                	add	sp,sp,64
 79c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 79e:	6398                	ld	a4,0(a5)
 7a0:	e118                	sd	a4,0(a0)
 7a2:	bff1                	j	77e <malloc+0x88>
  hp->s.size = nu;
 7a4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7a8:	0541                	add	a0,a0,16
 7aa:	00000097          	auipc	ra,0x0
 7ae:	eca080e7          	jalr	-310(ra) # 674 <free>
  return freep;
 7b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7b6:	d971                	beqz	a0,78a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ba:	4798                	lw	a4,8(a5)
 7bc:	fa9775e3          	bgeu	a4,s1,766 <malloc+0x70>
    if(p == freep)
 7c0:	00093703          	ld	a4,0(s2)
 7c4:	853e                	mv	a0,a5
 7c6:	fef719e3          	bne	a4,a5,7b8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7ca:	8552                	mv	a0,s4
 7cc:	00000097          	auipc	ra,0x0
 7d0:	b82080e7          	jalr	-1150(ra) # 34e <sbrk>
  if(p == (char*)-1)
 7d4:	fd5518e3          	bne	a0,s5,7a4 <malloc+0xae>
        return 0;
 7d8:	4501                	li	a0,0
 7da:	bf45                	j	78a <malloc+0x94>
