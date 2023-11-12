
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	add	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	add	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xor	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	add	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	add	a3,a3,797 # 1f31d <__global_pointer$+0x1d454>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	add	a2,a2,423 # 41a7 <__global_pointer$+0x22de>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	add	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd623>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	add	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	add	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	add	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	add	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	67050513          	add	a0,a0,1648 # 16d0 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	add	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	add	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	add	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	df0080e7          	jalr	-528(ra) # e80 <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	27650513          	add	a0,a0,630 # 1310 <malloc+0xe8>
      a2:	00001097          	auipc	ra,0x1
      a6:	dbe080e7          	jalr	-578(ra) # e60 <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	26650513          	add	a0,a0,614 # 1310 <malloc+0xe8>
      b2:	00001097          	auipc	ra,0x1
      b6:	db6080e7          	jalr	-586(ra) # e68 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	25c50513          	add	a0,a0,604 # 1318 <malloc+0xf0>
      c4:	00001097          	auipc	ra,0x1
      c8:	0ac080e7          	jalr	172(ra) # 1170 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d2a080e7          	jalr	-726(ra) # df8 <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	26250513          	add	a0,a0,610 # 1338 <malloc+0x110>
      de:	00001097          	auipc	ra,0x1
      e2:	d8a080e7          	jalr	-630(ra) # e68 <chdir>
      e6:	00001997          	auipc	s3,0x1
      ea:	26298993          	add	s3,s3,610 # 1348 <malloc+0x120>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	25098993          	add	s3,s3,592 # 1340 <malloc+0x118>
  uint64 iters = 0;
      f8:	4481                	li	s1,0
  int fd = -1;
      fa:	5a7d                	li	s4,-1
      fc:	00001917          	auipc	s2,0x1
     100:	4fc90913          	add	s2,s2,1276 # 15f8 <malloc+0x3d0>
     104:	a839                	j	122 <go+0xaa>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	24650513          	add	a0,a0,582 # 1350 <malloc+0x128>
     112:	00001097          	auipc	ra,0x1
     116:	d26080e7          	jalr	-730(ra) # e38 <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	d06080e7          	jalr	-762(ra) # e20 <close>
    iters++;
     122:	0485                	add	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	ce4080e7          	jalr	-796(ra) # e18 <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	47d9                	li	a5,22
     152:	fca7e8e3          	bltu	a5,a0,122 <go+0xaa>
     156:	050a                	sll	a0,a0,0x2
     158:	954a                	add	a0,a0,s2
     15a:	411c                	lw	a5,0(a0)
     15c:	97ca                	add	a5,a5,s2
     15e:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     160:	20200593          	li	a1,514
     164:	00001517          	auipc	a0,0x1
     168:	1fc50513          	add	a0,a0,508 # 1360 <malloc+0x138>
     16c:	00001097          	auipc	ra,0x1
     170:	ccc080e7          	jalr	-820(ra) # e38 <open>
     174:	00001097          	auipc	ra,0x1
     178:	cac080e7          	jalr	-852(ra) # e20 <close>
     17c:	b75d                	j	122 <go+0xaa>
    } else if(what == 3){
      unlink("grindir/../a");
     17e:	00001517          	auipc	a0,0x1
     182:	1d250513          	add	a0,a0,466 # 1350 <malloc+0x128>
     186:	00001097          	auipc	ra,0x1
     18a:	cc2080e7          	jalr	-830(ra) # e48 <unlink>
     18e:	bf51                	j	122 <go+0xaa>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     190:	00001517          	auipc	a0,0x1
     194:	18050513          	add	a0,a0,384 # 1310 <malloc+0xe8>
     198:	00001097          	auipc	ra,0x1
     19c:	cd0080e7          	jalr	-816(ra) # e68 <chdir>
     1a0:	e115                	bnez	a0,1c4 <go+0x14c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1a2:	00001517          	auipc	a0,0x1
     1a6:	1d650513          	add	a0,a0,470 # 1378 <malloc+0x150>
     1aa:	00001097          	auipc	ra,0x1
     1ae:	c9e080e7          	jalr	-866(ra) # e48 <unlink>
      chdir("/");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	18650513          	add	a0,a0,390 # 1338 <malloc+0x110>
     1ba:	00001097          	auipc	ra,0x1
     1be:	cae080e7          	jalr	-850(ra) # e68 <chdir>
     1c2:	b785                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     1c4:	00001517          	auipc	a0,0x1
     1c8:	15450513          	add	a0,a0,340 # 1318 <malloc+0xf0>
     1cc:	00001097          	auipc	ra,0x1
     1d0:	fa4080e7          	jalr	-92(ra) # 1170 <printf>
        exit(1);
     1d4:	4505                	li	a0,1
     1d6:	00001097          	auipc	ra,0x1
     1da:	c22080e7          	jalr	-990(ra) # df8 <exit>
    } else if(what == 5){
      close(fd);
     1de:	8552                	mv	a0,s4
     1e0:	00001097          	auipc	ra,0x1
     1e4:	c40080e7          	jalr	-960(ra) # e20 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1e8:	20200593          	li	a1,514
     1ec:	00001517          	auipc	a0,0x1
     1f0:	19450513          	add	a0,a0,404 # 1380 <malloc+0x158>
     1f4:	00001097          	auipc	ra,0x1
     1f8:	c44080e7          	jalr	-956(ra) # e38 <open>
     1fc:	8a2a                	mv	s4,a0
     1fe:	b715                	j	122 <go+0xaa>
    } else if(what == 6){
      close(fd);
     200:	8552                	mv	a0,s4
     202:	00001097          	auipc	ra,0x1
     206:	c1e080e7          	jalr	-994(ra) # e20 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	18250513          	add	a0,a0,386 # 1390 <malloc+0x168>
     216:	00001097          	auipc	ra,0x1
     21a:	c22080e7          	jalr	-990(ra) # e38 <open>
     21e:	8a2a                	mv	s4,a0
     220:	b709                	j	122 <go+0xaa>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     222:	3e700613          	li	a2,999
     226:	00001597          	auipc	a1,0x1
     22a:	4ba58593          	add	a1,a1,1210 # 16e0 <buf.0>
     22e:	8552                	mv	a0,s4
     230:	00001097          	auipc	ra,0x1
     234:	be8080e7          	jalr	-1048(ra) # e18 <write>
     238:	b5ed                	j	122 <go+0xaa>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     23a:	3e700613          	li	a2,999
     23e:	00001597          	auipc	a1,0x1
     242:	4a258593          	add	a1,a1,1186 # 16e0 <buf.0>
     246:	8552                	mv	a0,s4
     248:	00001097          	auipc	ra,0x1
     24c:	bc8080e7          	jalr	-1080(ra) # e10 <read>
     250:	bdc9                	j	122 <go+0xaa>
    } else if(what == 9){
      mkdir("grindir/../a");
     252:	00001517          	auipc	a0,0x1
     256:	0fe50513          	add	a0,a0,254 # 1350 <malloc+0x128>
     25a:	00001097          	auipc	ra,0x1
     25e:	c06080e7          	jalr	-1018(ra) # e60 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     262:	20200593          	li	a1,514
     266:	00001517          	auipc	a0,0x1
     26a:	14250513          	add	a0,a0,322 # 13a8 <malloc+0x180>
     26e:	00001097          	auipc	ra,0x1
     272:	bca080e7          	jalr	-1078(ra) # e38 <open>
     276:	00001097          	auipc	ra,0x1
     27a:	baa080e7          	jalr	-1110(ra) # e20 <close>
      unlink("a/a");
     27e:	00001517          	auipc	a0,0x1
     282:	13a50513          	add	a0,a0,314 # 13b8 <malloc+0x190>
     286:	00001097          	auipc	ra,0x1
     28a:	bc2080e7          	jalr	-1086(ra) # e48 <unlink>
     28e:	bd51                	j	122 <go+0xaa>
    } else if(what == 10){
      mkdir("/../b");
     290:	00001517          	auipc	a0,0x1
     294:	13050513          	add	a0,a0,304 # 13c0 <malloc+0x198>
     298:	00001097          	auipc	ra,0x1
     29c:	bc8080e7          	jalr	-1080(ra) # e60 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2a0:	20200593          	li	a1,514
     2a4:	00001517          	auipc	a0,0x1
     2a8:	12450513          	add	a0,a0,292 # 13c8 <malloc+0x1a0>
     2ac:	00001097          	auipc	ra,0x1
     2b0:	b8c080e7          	jalr	-1140(ra) # e38 <open>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	b6c080e7          	jalr	-1172(ra) # e20 <close>
      unlink("b/b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	11c50513          	add	a0,a0,284 # 13d8 <malloc+0x1b0>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	b84080e7          	jalr	-1148(ra) # e48 <unlink>
     2cc:	bd99                	j	122 <go+0xaa>
    } else if(what == 11){
      unlink("b");
     2ce:	00001517          	auipc	a0,0x1
     2d2:	0d250513          	add	a0,a0,210 # 13a0 <malloc+0x178>
     2d6:	00001097          	auipc	ra,0x1
     2da:	b72080e7          	jalr	-1166(ra) # e48 <unlink>
      link("../grindir/./../a", "../b");
     2de:	00001597          	auipc	a1,0x1
     2e2:	09a58593          	add	a1,a1,154 # 1378 <malloc+0x150>
     2e6:	00001517          	auipc	a0,0x1
     2ea:	0fa50513          	add	a0,a0,250 # 13e0 <malloc+0x1b8>
     2ee:	00001097          	auipc	ra,0x1
     2f2:	b6a080e7          	jalr	-1174(ra) # e58 <link>
     2f6:	b535                	j	122 <go+0xaa>
    } else if(what == 12){
      unlink("../grindir/../a");
     2f8:	00001517          	auipc	a0,0x1
     2fc:	10050513          	add	a0,a0,256 # 13f8 <malloc+0x1d0>
     300:	00001097          	auipc	ra,0x1
     304:	b48080e7          	jalr	-1208(ra) # e48 <unlink>
      link(".././b", "/grindir/../a");
     308:	00001597          	auipc	a1,0x1
     30c:	07858593          	add	a1,a1,120 # 1380 <malloc+0x158>
     310:	00001517          	auipc	a0,0x1
     314:	0f850513          	add	a0,a0,248 # 1408 <malloc+0x1e0>
     318:	00001097          	auipc	ra,0x1
     31c:	b40080e7          	jalr	-1216(ra) # e58 <link>
     320:	b509                	j	122 <go+0xaa>
    } else if(what == 13){
      int pid = fork();
     322:	00001097          	auipc	ra,0x1
     326:	ace080e7          	jalr	-1330(ra) # df0 <fork>
      if(pid == 0){
     32a:	c909                	beqz	a0,33c <go+0x2c4>
        exit(0);
      } else if(pid < 0){
     32c:	00054c63          	bltz	a0,344 <go+0x2cc>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     330:	4501                	li	a0,0
     332:	00001097          	auipc	ra,0x1
     336:	ace080e7          	jalr	-1330(ra) # e00 <wait>
     33a:	b3e5                	j	122 <go+0xaa>
        exit(0);
     33c:	00001097          	auipc	ra,0x1
     340:	abc080e7          	jalr	-1348(ra) # df8 <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	0cc50513          	add	a0,a0,204 # 1410 <malloc+0x1e8>
     34c:	00001097          	auipc	ra,0x1
     350:	e24080e7          	jalr	-476(ra) # 1170 <printf>
        exit(1);
     354:	4505                	li	a0,1
     356:	00001097          	auipc	ra,0x1
     35a:	aa2080e7          	jalr	-1374(ra) # df8 <exit>
    } else if(what == 14){
      int pid = fork();
     35e:	00001097          	auipc	ra,0x1
     362:	a92080e7          	jalr	-1390(ra) # df0 <fork>
      if(pid == 0){
     366:	c909                	beqz	a0,378 <go+0x300>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     368:	02054563          	bltz	a0,392 <go+0x31a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     36c:	4501                	li	a0,0
     36e:	00001097          	auipc	ra,0x1
     372:	a92080e7          	jalr	-1390(ra) # e00 <wait>
     376:	b375                	j	122 <go+0xaa>
        fork();
     378:	00001097          	auipc	ra,0x1
     37c:	a78080e7          	jalr	-1416(ra) # df0 <fork>
        fork();
     380:	00001097          	auipc	ra,0x1
     384:	a70080e7          	jalr	-1424(ra) # df0 <fork>
        exit(0);
     388:	4501                	li	a0,0
     38a:	00001097          	auipc	ra,0x1
     38e:	a6e080e7          	jalr	-1426(ra) # df8 <exit>
        printf("grind: fork failed\n");
     392:	00001517          	auipc	a0,0x1
     396:	07e50513          	add	a0,a0,126 # 1410 <malloc+0x1e8>
     39a:	00001097          	auipc	ra,0x1
     39e:	dd6080e7          	jalr	-554(ra) # 1170 <printf>
        exit(1);
     3a2:	4505                	li	a0,1
     3a4:	00001097          	auipc	ra,0x1
     3a8:	a54080e7          	jalr	-1452(ra) # df8 <exit>
    } else if(what == 15){
      sbrk(6011);
     3ac:	6505                	lui	a0,0x1
     3ae:	77b50513          	add	a0,a0,1915 # 177b <buf.0+0x9b>
     3b2:	00001097          	auipc	ra,0x1
     3b6:	ace080e7          	jalr	-1330(ra) # e80 <sbrk>
     3ba:	b3a5                	j	122 <go+0xaa>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3bc:	4501                	li	a0,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	ac2080e7          	jalr	-1342(ra) # e80 <sbrk>
     3c6:	d4aafee3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     3ca:	4501                	li	a0,0
     3cc:	00001097          	auipc	ra,0x1
     3d0:	ab4080e7          	jalr	-1356(ra) # e80 <sbrk>
     3d4:	40aa853b          	subw	a0,s5,a0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	aa8080e7          	jalr	-1368(ra) # e80 <sbrk>
     3e0:	b389                	j	122 <go+0xaa>
    } else if(what == 17){
      int pid = fork();
     3e2:	00001097          	auipc	ra,0x1
     3e6:	a0e080e7          	jalr	-1522(ra) # df0 <fork>
     3ea:	8b2a                	mv	s6,a0
      if(pid == 0){
     3ec:	c51d                	beqz	a0,41a <go+0x3a2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3ee:	04054963          	bltz	a0,440 <go+0x3c8>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3f2:	00001517          	auipc	a0,0x1
     3f6:	03650513          	add	a0,a0,54 # 1428 <malloc+0x200>
     3fa:	00001097          	auipc	ra,0x1
     3fe:	a6e080e7          	jalr	-1426(ra) # e68 <chdir>
     402:	ed21                	bnez	a0,45a <go+0x3e2>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     404:	855a                	mv	a0,s6
     406:	00001097          	auipc	ra,0x1
     40a:	a22080e7          	jalr	-1502(ra) # e28 <kill>
      wait(0);
     40e:	4501                	li	a0,0
     410:	00001097          	auipc	ra,0x1
     414:	9f0080e7          	jalr	-1552(ra) # e00 <wait>
     418:	b329                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     41a:	20200593          	li	a1,514
     41e:	00001517          	auipc	a0,0x1
     422:	fd250513          	add	a0,a0,-46 # 13f0 <malloc+0x1c8>
     426:	00001097          	auipc	ra,0x1
     42a:	a12080e7          	jalr	-1518(ra) # e38 <open>
     42e:	00001097          	auipc	ra,0x1
     432:	9f2080e7          	jalr	-1550(ra) # e20 <close>
        exit(0);
     436:	4501                	li	a0,0
     438:	00001097          	auipc	ra,0x1
     43c:	9c0080e7          	jalr	-1600(ra) # df8 <exit>
        printf("grind: fork failed\n");
     440:	00001517          	auipc	a0,0x1
     444:	fd050513          	add	a0,a0,-48 # 1410 <malloc+0x1e8>
     448:	00001097          	auipc	ra,0x1
     44c:	d28080e7          	jalr	-728(ra) # 1170 <printf>
        exit(1);
     450:	4505                	li	a0,1
     452:	00001097          	auipc	ra,0x1
     456:	9a6080e7          	jalr	-1626(ra) # df8 <exit>
        printf("grind: chdir failed\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	fde50513          	add	a0,a0,-34 # 1438 <malloc+0x210>
     462:	00001097          	auipc	ra,0x1
     466:	d0e080e7          	jalr	-754(ra) # 1170 <printf>
        exit(1);
     46a:	4505                	li	a0,1
     46c:	00001097          	auipc	ra,0x1
     470:	98c080e7          	jalr	-1652(ra) # df8 <exit>
    } else if(what == 18){
      int pid = fork();
     474:	00001097          	auipc	ra,0x1
     478:	97c080e7          	jalr	-1668(ra) # df0 <fork>
      if(pid == 0){
     47c:	c909                	beqz	a0,48e <go+0x416>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     47e:	02054563          	bltz	a0,4a8 <go+0x430>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     482:	4501                	li	a0,0
     484:	00001097          	auipc	ra,0x1
     488:	97c080e7          	jalr	-1668(ra) # e00 <wait>
     48c:	b959                	j	122 <go+0xaa>
        kill(getpid());
     48e:	00001097          	auipc	ra,0x1
     492:	9ea080e7          	jalr	-1558(ra) # e78 <getpid>
     496:	00001097          	auipc	ra,0x1
     49a:	992080e7          	jalr	-1646(ra) # e28 <kill>
        exit(0);
     49e:	4501                	li	a0,0
     4a0:	00001097          	auipc	ra,0x1
     4a4:	958080e7          	jalr	-1704(ra) # df8 <exit>
        printf("grind: fork failed\n");
     4a8:	00001517          	auipc	a0,0x1
     4ac:	f6850513          	add	a0,a0,-152 # 1410 <malloc+0x1e8>
     4b0:	00001097          	auipc	ra,0x1
     4b4:	cc0080e7          	jalr	-832(ra) # 1170 <printf>
        exit(1);
     4b8:	4505                	li	a0,1
     4ba:	00001097          	auipc	ra,0x1
     4be:	93e080e7          	jalr	-1730(ra) # df8 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4c2:	fa840513          	add	a0,s0,-88
     4c6:	00001097          	auipc	ra,0x1
     4ca:	942080e7          	jalr	-1726(ra) # e08 <pipe>
     4ce:	02054b63          	bltz	a0,504 <go+0x48c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4d2:	00001097          	auipc	ra,0x1
     4d6:	91e080e7          	jalr	-1762(ra) # df0 <fork>
      if(pid == 0){
     4da:	c131                	beqz	a0,51e <go+0x4a6>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4dc:	0a054a63          	bltz	a0,590 <go+0x518>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4e0:	fa842503          	lw	a0,-88(s0)
     4e4:	00001097          	auipc	ra,0x1
     4e8:	93c080e7          	jalr	-1732(ra) # e20 <close>
      close(fds[1]);
     4ec:	fac42503          	lw	a0,-84(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	930080e7          	jalr	-1744(ra) # e20 <close>
      wait(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	906080e7          	jalr	-1786(ra) # e00 <wait>
     502:	b105                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     504:	00001517          	auipc	a0,0x1
     508:	f4c50513          	add	a0,a0,-180 # 1450 <malloc+0x228>
     50c:	00001097          	auipc	ra,0x1
     510:	c64080e7          	jalr	-924(ra) # 1170 <printf>
        exit(1);
     514:	4505                	li	a0,1
     516:	00001097          	auipc	ra,0x1
     51a:	8e2080e7          	jalr	-1822(ra) # df8 <exit>
        fork();
     51e:	00001097          	auipc	ra,0x1
     522:	8d2080e7          	jalr	-1838(ra) # df0 <fork>
        fork();
     526:	00001097          	auipc	ra,0x1
     52a:	8ca080e7          	jalr	-1846(ra) # df0 <fork>
        if(write(fds[1], "x", 1) != 1)
     52e:	4605                	li	a2,1
     530:	00001597          	auipc	a1,0x1
     534:	f3858593          	add	a1,a1,-200 # 1468 <malloc+0x240>
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00001097          	auipc	ra,0x1
     540:	8dc080e7          	jalr	-1828(ra) # e18 <write>
     544:	4785                	li	a5,1
     546:	02f51363          	bne	a0,a5,56c <go+0x4f4>
        if(read(fds[0], &c, 1) != 1)
     54a:	4605                	li	a2,1
     54c:	fa040593          	add	a1,s0,-96
     550:	fa842503          	lw	a0,-88(s0)
     554:	00001097          	auipc	ra,0x1
     558:	8bc080e7          	jalr	-1860(ra) # e10 <read>
     55c:	4785                	li	a5,1
     55e:	02f51063          	bne	a0,a5,57e <go+0x506>
        exit(0);
     562:	4501                	li	a0,0
     564:	00001097          	auipc	ra,0x1
     568:	894080e7          	jalr	-1900(ra) # df8 <exit>
          printf("grind: pipe write failed\n");
     56c:	00001517          	auipc	a0,0x1
     570:	f0450513          	add	a0,a0,-252 # 1470 <malloc+0x248>
     574:	00001097          	auipc	ra,0x1
     578:	bfc080e7          	jalr	-1028(ra) # 1170 <printf>
     57c:	b7f9                	j	54a <go+0x4d2>
          printf("grind: pipe read failed\n");
     57e:	00001517          	auipc	a0,0x1
     582:	f1250513          	add	a0,a0,-238 # 1490 <malloc+0x268>
     586:	00001097          	auipc	ra,0x1
     58a:	bea080e7          	jalr	-1046(ra) # 1170 <printf>
     58e:	bfd1                	j	562 <go+0x4ea>
        printf("grind: fork failed\n");
     590:	00001517          	auipc	a0,0x1
     594:	e8050513          	add	a0,a0,-384 # 1410 <malloc+0x1e8>
     598:	00001097          	auipc	ra,0x1
     59c:	bd8080e7          	jalr	-1064(ra) # 1170 <printf>
        exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00001097          	auipc	ra,0x1
     5a6:	856080e7          	jalr	-1962(ra) # df8 <exit>
    } else if(what == 20){
      int pid = fork();
     5aa:	00001097          	auipc	ra,0x1
     5ae:	846080e7          	jalr	-1978(ra) # df0 <fork>
      if(pid == 0){
     5b2:	c909                	beqz	a0,5c4 <go+0x54c>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5b4:	06054f63          	bltz	a0,632 <go+0x5ba>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5b8:	4501                	li	a0,0
     5ba:	00001097          	auipc	ra,0x1
     5be:	846080e7          	jalr	-1978(ra) # e00 <wait>
     5c2:	b685                	j	122 <go+0xaa>
        unlink("a");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	e2c50513          	add	a0,a0,-468 # 13f0 <malloc+0x1c8>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	87c080e7          	jalr	-1924(ra) # e48 <unlink>
        mkdir("a");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	e1c50513          	add	a0,a0,-484 # 13f0 <malloc+0x1c8>
     5dc:	00001097          	auipc	ra,0x1
     5e0:	884080e7          	jalr	-1916(ra) # e60 <mkdir>
        chdir("a");
     5e4:	00001517          	auipc	a0,0x1
     5e8:	e0c50513          	add	a0,a0,-500 # 13f0 <malloc+0x1c8>
     5ec:	00001097          	auipc	ra,0x1
     5f0:	87c080e7          	jalr	-1924(ra) # e68 <chdir>
        unlink("../a");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	d6450513          	add	a0,a0,-668 # 1358 <malloc+0x130>
     5fc:	00001097          	auipc	ra,0x1
     600:	84c080e7          	jalr	-1972(ra) # e48 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     604:	20200593          	li	a1,514
     608:	00001517          	auipc	a0,0x1
     60c:	e6050513          	add	a0,a0,-416 # 1468 <malloc+0x240>
     610:	00001097          	auipc	ra,0x1
     614:	828080e7          	jalr	-2008(ra) # e38 <open>
        unlink("x");
     618:	00001517          	auipc	a0,0x1
     61c:	e5050513          	add	a0,a0,-432 # 1468 <malloc+0x240>
     620:	00001097          	auipc	ra,0x1
     624:	828080e7          	jalr	-2008(ra) # e48 <unlink>
        exit(0);
     628:	4501                	li	a0,0
     62a:	00000097          	auipc	ra,0x0
     62e:	7ce080e7          	jalr	1998(ra) # df8 <exit>
        printf("grind: fork failed\n");
     632:	00001517          	auipc	a0,0x1
     636:	dde50513          	add	a0,a0,-546 # 1410 <malloc+0x1e8>
     63a:	00001097          	auipc	ra,0x1
     63e:	b36080e7          	jalr	-1226(ra) # 1170 <printf>
        exit(1);
     642:	4505                	li	a0,1
     644:	00000097          	auipc	ra,0x0
     648:	7b4080e7          	jalr	1972(ra) # df8 <exit>
    } else if(what == 21){
      unlink("c");
     64c:	00001517          	auipc	a0,0x1
     650:	e6450513          	add	a0,a0,-412 # 14b0 <malloc+0x288>
     654:	00000097          	auipc	ra,0x0
     658:	7f4080e7          	jalr	2036(ra) # e48 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     65c:	20200593          	li	a1,514
     660:	00001517          	auipc	a0,0x1
     664:	e5050513          	add	a0,a0,-432 # 14b0 <malloc+0x288>
     668:	00000097          	auipc	ra,0x0
     66c:	7d0080e7          	jalr	2000(ra) # e38 <open>
     670:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     672:	04054f63          	bltz	a0,6d0 <go+0x658>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     676:	4605                	li	a2,1
     678:	00001597          	auipc	a1,0x1
     67c:	df058593          	add	a1,a1,-528 # 1468 <malloc+0x240>
     680:	00000097          	auipc	ra,0x0
     684:	798080e7          	jalr	1944(ra) # e18 <write>
     688:	4785                	li	a5,1
     68a:	06f51063          	bne	a0,a5,6ea <go+0x672>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     68e:	fa840593          	add	a1,s0,-88
     692:	855a                	mv	a0,s6
     694:	00000097          	auipc	ra,0x0
     698:	7bc080e7          	jalr	1980(ra) # e50 <fstat>
     69c:	e525                	bnez	a0,704 <go+0x68c>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     69e:	fb843583          	ld	a1,-72(s0)
     6a2:	4785                	li	a5,1
     6a4:	06f59d63          	bne	a1,a5,71e <go+0x6a6>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6a8:	fac42583          	lw	a1,-84(s0)
     6ac:	0c800793          	li	a5,200
     6b0:	08b7e563          	bltu	a5,a1,73a <go+0x6c2>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6b4:	855a                	mv	a0,s6
     6b6:	00000097          	auipc	ra,0x0
     6ba:	76a080e7          	jalr	1898(ra) # e20 <close>
      unlink("c");
     6be:	00001517          	auipc	a0,0x1
     6c2:	df250513          	add	a0,a0,-526 # 14b0 <malloc+0x288>
     6c6:	00000097          	auipc	ra,0x0
     6ca:	782080e7          	jalr	1922(ra) # e48 <unlink>
     6ce:	bc91                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	de850513          	add	a0,a0,-536 # 14b8 <malloc+0x290>
     6d8:	00001097          	auipc	ra,0x1
     6dc:	a98080e7          	jalr	-1384(ra) # 1170 <printf>
        exit(1);
     6e0:	4505                	li	a0,1
     6e2:	00000097          	auipc	ra,0x0
     6e6:	716080e7          	jalr	1814(ra) # df8 <exit>
        printf("grind: write c failed\n");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	de650513          	add	a0,a0,-538 # 14d0 <malloc+0x2a8>
     6f2:	00001097          	auipc	ra,0x1
     6f6:	a7e080e7          	jalr	-1410(ra) # 1170 <printf>
        exit(1);
     6fa:	4505                	li	a0,1
     6fc:	00000097          	auipc	ra,0x0
     700:	6fc080e7          	jalr	1788(ra) # df8 <exit>
        printf("grind: fstat failed\n");
     704:	00001517          	auipc	a0,0x1
     708:	de450513          	add	a0,a0,-540 # 14e8 <malloc+0x2c0>
     70c:	00001097          	auipc	ra,0x1
     710:	a64080e7          	jalr	-1436(ra) # 1170 <printf>
        exit(1);
     714:	4505                	li	a0,1
     716:	00000097          	auipc	ra,0x0
     71a:	6e2080e7          	jalr	1762(ra) # df8 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     71e:	2581                	sext.w	a1,a1
     720:	00001517          	auipc	a0,0x1
     724:	de050513          	add	a0,a0,-544 # 1500 <malloc+0x2d8>
     728:	00001097          	auipc	ra,0x1
     72c:	a48080e7          	jalr	-1464(ra) # 1170 <printf>
        exit(1);
     730:	4505                	li	a0,1
     732:	00000097          	auipc	ra,0x0
     736:	6c6080e7          	jalr	1734(ra) # df8 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     73a:	00001517          	auipc	a0,0x1
     73e:	dee50513          	add	a0,a0,-530 # 1528 <malloc+0x300>
     742:	00001097          	auipc	ra,0x1
     746:	a2e080e7          	jalr	-1490(ra) # 1170 <printf>
        exit(1);
     74a:	4505                	li	a0,1
     74c:	00000097          	auipc	ra,0x0
     750:	6ac080e7          	jalr	1708(ra) # df8 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     754:	f9840513          	add	a0,s0,-104
     758:	00000097          	auipc	ra,0x0
     75c:	6b0080e7          	jalr	1712(ra) # e08 <pipe>
     760:	10054063          	bltz	a0,860 <go+0x7e8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     764:	fa040513          	add	a0,s0,-96
     768:	00000097          	auipc	ra,0x0
     76c:	6a0080e7          	jalr	1696(ra) # e08 <pipe>
     770:	10054663          	bltz	a0,87c <go+0x804>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     774:	00000097          	auipc	ra,0x0
     778:	67c080e7          	jalr	1660(ra) # df0 <fork>
      if(pid1 == 0){
     77c:	10050e63          	beqz	a0,898 <go+0x820>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     780:	1c054663          	bltz	a0,94c <go+0x8d4>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     784:	00000097          	auipc	ra,0x0
     788:	66c080e7          	jalr	1644(ra) # df0 <fork>
      if(pid2 == 0){
     78c:	1c050e63          	beqz	a0,968 <go+0x8f0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     790:	2a054a63          	bltz	a0,a44 <go+0x9cc>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     794:	f9842503          	lw	a0,-104(s0)
     798:	00000097          	auipc	ra,0x0
     79c:	688080e7          	jalr	1672(ra) # e20 <close>
      close(aa[1]);
     7a0:	f9c42503          	lw	a0,-100(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	67c080e7          	jalr	1660(ra) # e20 <close>
      close(bb[1]);
     7ac:	fa442503          	lw	a0,-92(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	670080e7          	jalr	1648(ra) # e20 <close>
      char buf[4] = { 0, 0, 0, 0 };
     7b8:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7bc:	4605                	li	a2,1
     7be:	f9040593          	add	a1,s0,-112
     7c2:	fa042503          	lw	a0,-96(s0)
     7c6:	00000097          	auipc	ra,0x0
     7ca:	64a080e7          	jalr	1610(ra) # e10 <read>
      read(bb[0], buf+1, 1);
     7ce:	4605                	li	a2,1
     7d0:	f9140593          	add	a1,s0,-111
     7d4:	fa042503          	lw	a0,-96(s0)
     7d8:	00000097          	auipc	ra,0x0
     7dc:	638080e7          	jalr	1592(ra) # e10 <read>
      read(bb[0], buf+2, 1);
     7e0:	4605                	li	a2,1
     7e2:	f9240593          	add	a1,s0,-110
     7e6:	fa042503          	lw	a0,-96(s0)
     7ea:	00000097          	auipc	ra,0x0
     7ee:	626080e7          	jalr	1574(ra) # e10 <read>
      close(bb[0]);
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	62a080e7          	jalr	1578(ra) # e20 <close>
      int st1, st2;
      wait(&st1);
     7fe:	f9440513          	add	a0,s0,-108
     802:	00000097          	auipc	ra,0x0
     806:	5fe080e7          	jalr	1534(ra) # e00 <wait>
      wait(&st2);
     80a:	fa840513          	add	a0,s0,-88
     80e:	00000097          	auipc	ra,0x0
     812:	5f2080e7          	jalr	1522(ra) # e00 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     816:	f9442783          	lw	a5,-108(s0)
     81a:	fa842703          	lw	a4,-88(s0)
     81e:	8fd9                	or	a5,a5,a4
     820:	ef89                	bnez	a5,83a <go+0x7c2>
     822:	00001597          	auipc	a1,0x1
     826:	da658593          	add	a1,a1,-602 # 15c8 <malloc+0x3a0>
     82a:	f9040513          	add	a0,s0,-112
     82e:	00000097          	auipc	ra,0x0
     832:	37a080e7          	jalr	890(ra) # ba8 <strcmp>
     836:	8e0506e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     83a:	f9040693          	add	a3,s0,-112
     83e:	fa842603          	lw	a2,-88(s0)
     842:	f9442583          	lw	a1,-108(s0)
     846:	00001517          	auipc	a0,0x1
     84a:	d8a50513          	add	a0,a0,-630 # 15d0 <malloc+0x3a8>
     84e:	00001097          	auipc	ra,0x1
     852:	922080e7          	jalr	-1758(ra) # 1170 <printf>
        exit(1);
     856:	4505                	li	a0,1
     858:	00000097          	auipc	ra,0x0
     85c:	5a0080e7          	jalr	1440(ra) # df8 <exit>
        fprintf(2, "grind: pipe failed\n");
     860:	00001597          	auipc	a1,0x1
     864:	bf058593          	add	a1,a1,-1040 # 1450 <malloc+0x228>
     868:	4509                	li	a0,2
     86a:	00001097          	auipc	ra,0x1
     86e:	8d8080e7          	jalr	-1832(ra) # 1142 <fprintf>
        exit(1);
     872:	4505                	li	a0,1
     874:	00000097          	auipc	ra,0x0
     878:	584080e7          	jalr	1412(ra) # df8 <exit>
        fprintf(2, "grind: pipe failed\n");
     87c:	00001597          	auipc	a1,0x1
     880:	bd458593          	add	a1,a1,-1068 # 1450 <malloc+0x228>
     884:	4509                	li	a0,2
     886:	00001097          	auipc	ra,0x1
     88a:	8bc080e7          	jalr	-1860(ra) # 1142 <fprintf>
        exit(1);
     88e:	4505                	li	a0,1
     890:	00000097          	auipc	ra,0x0
     894:	568080e7          	jalr	1384(ra) # df8 <exit>
        close(bb[0]);
     898:	fa042503          	lw	a0,-96(s0)
     89c:	00000097          	auipc	ra,0x0
     8a0:	584080e7          	jalr	1412(ra) # e20 <close>
        close(bb[1]);
     8a4:	fa442503          	lw	a0,-92(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	578080e7          	jalr	1400(ra) # e20 <close>
        close(aa[0]);
     8b0:	f9842503          	lw	a0,-104(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	56c080e7          	jalr	1388(ra) # e20 <close>
        close(1);
     8bc:	4505                	li	a0,1
     8be:	00000097          	auipc	ra,0x0
     8c2:	562080e7          	jalr	1378(ra) # e20 <close>
        if(dup(aa[1]) != 1){
     8c6:	f9c42503          	lw	a0,-100(s0)
     8ca:	00000097          	auipc	ra,0x0
     8ce:	5a6080e7          	jalr	1446(ra) # e70 <dup>
     8d2:	4785                	li	a5,1
     8d4:	02f50063          	beq	a0,a5,8f4 <go+0x87c>
          fprintf(2, "grind: dup failed\n");
     8d8:	00001597          	auipc	a1,0x1
     8dc:	c7858593          	add	a1,a1,-904 # 1550 <malloc+0x328>
     8e0:	4509                	li	a0,2
     8e2:	00001097          	auipc	ra,0x1
     8e6:	860080e7          	jalr	-1952(ra) # 1142 <fprintf>
          exit(1);
     8ea:	4505                	li	a0,1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	50c080e7          	jalr	1292(ra) # df8 <exit>
        close(aa[1]);
     8f4:	f9c42503          	lw	a0,-100(s0)
     8f8:	00000097          	auipc	ra,0x0
     8fc:	528080e7          	jalr	1320(ra) # e20 <close>
        char *args[3] = { "echo", "hi", 0 };
     900:	00001797          	auipc	a5,0x1
     904:	c6878793          	add	a5,a5,-920 # 1568 <malloc+0x340>
     908:	faf43423          	sd	a5,-88(s0)
     90c:	00001797          	auipc	a5,0x1
     910:	c6478793          	add	a5,a5,-924 # 1570 <malloc+0x348>
     914:	faf43823          	sd	a5,-80(s0)
     918:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     91c:	fa840593          	add	a1,s0,-88
     920:	00001517          	auipc	a0,0x1
     924:	c5850513          	add	a0,a0,-936 # 1578 <malloc+0x350>
     928:	00000097          	auipc	ra,0x0
     92c:	508080e7          	jalr	1288(ra) # e30 <exec>
        fprintf(2, "grind: echo: not found\n");
     930:	00001597          	auipc	a1,0x1
     934:	c5858593          	add	a1,a1,-936 # 1588 <malloc+0x360>
     938:	4509                	li	a0,2
     93a:	00001097          	auipc	ra,0x1
     93e:	808080e7          	jalr	-2040(ra) # 1142 <fprintf>
        exit(2);
     942:	4509                	li	a0,2
     944:	00000097          	auipc	ra,0x0
     948:	4b4080e7          	jalr	1204(ra) # df8 <exit>
        fprintf(2, "grind: fork failed\n");
     94c:	00001597          	auipc	a1,0x1
     950:	ac458593          	add	a1,a1,-1340 # 1410 <malloc+0x1e8>
     954:	4509                	li	a0,2
     956:	00000097          	auipc	ra,0x0
     95a:	7ec080e7          	jalr	2028(ra) # 1142 <fprintf>
        exit(3);
     95e:	450d                	li	a0,3
     960:	00000097          	auipc	ra,0x0
     964:	498080e7          	jalr	1176(ra) # df8 <exit>
        close(aa[1]);
     968:	f9c42503          	lw	a0,-100(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	4b4080e7          	jalr	1204(ra) # e20 <close>
        close(bb[0]);
     974:	fa042503          	lw	a0,-96(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	4a8080e7          	jalr	1192(ra) # e20 <close>
        close(0);
     980:	4501                	li	a0,0
     982:	00000097          	auipc	ra,0x0
     986:	49e080e7          	jalr	1182(ra) # e20 <close>
        if(dup(aa[0]) != 0){
     98a:	f9842503          	lw	a0,-104(s0)
     98e:	00000097          	auipc	ra,0x0
     992:	4e2080e7          	jalr	1250(ra) # e70 <dup>
     996:	cd19                	beqz	a0,9b4 <go+0x93c>
          fprintf(2, "grind: dup failed\n");
     998:	00001597          	auipc	a1,0x1
     99c:	bb858593          	add	a1,a1,-1096 # 1550 <malloc+0x328>
     9a0:	4509                	li	a0,2
     9a2:	00000097          	auipc	ra,0x0
     9a6:	7a0080e7          	jalr	1952(ra) # 1142 <fprintf>
          exit(4);
     9aa:	4511                	li	a0,4
     9ac:	00000097          	auipc	ra,0x0
     9b0:	44c080e7          	jalr	1100(ra) # df8 <exit>
        close(aa[0]);
     9b4:	f9842503          	lw	a0,-104(s0)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	468080e7          	jalr	1128(ra) # e20 <close>
        close(1);
     9c0:	4505                	li	a0,1
     9c2:	00000097          	auipc	ra,0x0
     9c6:	45e080e7          	jalr	1118(ra) # e20 <close>
        if(dup(bb[1]) != 1){
     9ca:	fa442503          	lw	a0,-92(s0)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	4a2080e7          	jalr	1186(ra) # e70 <dup>
     9d6:	4785                	li	a5,1
     9d8:	02f50063          	beq	a0,a5,9f8 <go+0x980>
          fprintf(2, "grind: dup failed\n");
     9dc:	00001597          	auipc	a1,0x1
     9e0:	b7458593          	add	a1,a1,-1164 # 1550 <malloc+0x328>
     9e4:	4509                	li	a0,2
     9e6:	00000097          	auipc	ra,0x0
     9ea:	75c080e7          	jalr	1884(ra) # 1142 <fprintf>
          exit(5);
     9ee:	4515                	li	a0,5
     9f0:	00000097          	auipc	ra,0x0
     9f4:	408080e7          	jalr	1032(ra) # df8 <exit>
        close(bb[1]);
     9f8:	fa442503          	lw	a0,-92(s0)
     9fc:	00000097          	auipc	ra,0x0
     a00:	424080e7          	jalr	1060(ra) # e20 <close>
        char *args[2] = { "cat", 0 };
     a04:	00001797          	auipc	a5,0x1
     a08:	b9c78793          	add	a5,a5,-1124 # 15a0 <malloc+0x378>
     a0c:	faf43423          	sd	a5,-88(s0)
     a10:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a14:	fa840593          	add	a1,s0,-88
     a18:	00001517          	auipc	a0,0x1
     a1c:	b9050513          	add	a0,a0,-1136 # 15a8 <malloc+0x380>
     a20:	00000097          	auipc	ra,0x0
     a24:	410080e7          	jalr	1040(ra) # e30 <exec>
        fprintf(2, "grind: cat: not found\n");
     a28:	00001597          	auipc	a1,0x1
     a2c:	b8858593          	add	a1,a1,-1144 # 15b0 <malloc+0x388>
     a30:	4509                	li	a0,2
     a32:	00000097          	auipc	ra,0x0
     a36:	710080e7          	jalr	1808(ra) # 1142 <fprintf>
        exit(6);
     a3a:	4519                	li	a0,6
     a3c:	00000097          	auipc	ra,0x0
     a40:	3bc080e7          	jalr	956(ra) # df8 <exit>
        fprintf(2, "grind: fork failed\n");
     a44:	00001597          	auipc	a1,0x1
     a48:	9cc58593          	add	a1,a1,-1588 # 1410 <malloc+0x1e8>
     a4c:	4509                	li	a0,2
     a4e:	00000097          	auipc	ra,0x0
     a52:	6f4080e7          	jalr	1780(ra) # 1142 <fprintf>
        exit(7);
     a56:	451d                	li	a0,7
     a58:	00000097          	auipc	ra,0x0
     a5c:	3a0080e7          	jalr	928(ra) # df8 <exit>

0000000000000a60 <iter>:
  }
}

void
iter()
{
     a60:	7179                	add	sp,sp,-48
     a62:	f406                	sd	ra,40(sp)
     a64:	f022                	sd	s0,32(sp)
     a66:	ec26                	sd	s1,24(sp)
     a68:	e84a                	sd	s2,16(sp)
     a6a:	1800                	add	s0,sp,48
  unlink("a");
     a6c:	00001517          	auipc	a0,0x1
     a70:	98450513          	add	a0,a0,-1660 # 13f0 <malloc+0x1c8>
     a74:	00000097          	auipc	ra,0x0
     a78:	3d4080e7          	jalr	980(ra) # e48 <unlink>
  unlink("b");
     a7c:	00001517          	auipc	a0,0x1
     a80:	92450513          	add	a0,a0,-1756 # 13a0 <malloc+0x178>
     a84:	00000097          	auipc	ra,0x0
     a88:	3c4080e7          	jalr	964(ra) # e48 <unlink>
  
  int pid1 = fork();
     a8c:	00000097          	auipc	ra,0x0
     a90:	364080e7          	jalr	868(ra) # df0 <fork>
  if(pid1 < 0){
     a94:	00054e63          	bltz	a0,ab0 <iter+0x50>
     a98:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     a9a:	e905                	bnez	a0,aca <iter+0x6a>
    rand_next = 31;
     a9c:	47fd                	li	a5,31
     a9e:	00001717          	auipc	a4,0x1
     aa2:	c2f73923          	sd	a5,-974(a4) # 16d0 <rand_next>
    go(0);
     aa6:	4501                	li	a0,0
     aa8:	fffff097          	auipc	ra,0xfffff
     aac:	5d0080e7          	jalr	1488(ra) # 78 <go>
    printf("grind: fork failed\n");
     ab0:	00001517          	auipc	a0,0x1
     ab4:	96050513          	add	a0,a0,-1696 # 1410 <malloc+0x1e8>
     ab8:	00000097          	auipc	ra,0x0
     abc:	6b8080e7          	jalr	1720(ra) # 1170 <printf>
    exit(1);
     ac0:	4505                	li	a0,1
     ac2:	00000097          	auipc	ra,0x0
     ac6:	336080e7          	jalr	822(ra) # df8 <exit>
    exit(0);
  }

  int pid2 = fork();
     aca:	00000097          	auipc	ra,0x0
     ace:	326080e7          	jalr	806(ra) # df0 <fork>
     ad2:	892a                	mv	s2,a0
  if(pid2 < 0){
     ad4:	00054f63          	bltz	a0,af2 <iter+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     ad8:	e915                	bnez	a0,b0c <iter+0xac>
    rand_next = 7177;
     ada:	6789                	lui	a5,0x2
     adc:	c0978793          	add	a5,a5,-1015 # 1c09 <__BSS_END__+0x131>
     ae0:	00001717          	auipc	a4,0x1
     ae4:	bef73823          	sd	a5,-1040(a4) # 16d0 <rand_next>
    go(1);
     ae8:	4505                	li	a0,1
     aea:	fffff097          	auipc	ra,0xfffff
     aee:	58e080e7          	jalr	1422(ra) # 78 <go>
    printf("grind: fork failed\n");
     af2:	00001517          	auipc	a0,0x1
     af6:	91e50513          	add	a0,a0,-1762 # 1410 <malloc+0x1e8>
     afa:	00000097          	auipc	ra,0x0
     afe:	676080e7          	jalr	1654(ra) # 1170 <printf>
    exit(1);
     b02:	4505                	li	a0,1
     b04:	00000097          	auipc	ra,0x0
     b08:	2f4080e7          	jalr	756(ra) # df8 <exit>
    exit(0);
  }

  int st1 = -1;
     b0c:	57fd                	li	a5,-1
     b0e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b12:	fdc40513          	add	a0,s0,-36
     b16:	00000097          	auipc	ra,0x0
     b1a:	2ea080e7          	jalr	746(ra) # e00 <wait>
  if(st1 != 0){
     b1e:	fdc42783          	lw	a5,-36(s0)
     b22:	ef99                	bnez	a5,b40 <iter+0xe0>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b24:	57fd                	li	a5,-1
     b26:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b2a:	fd840513          	add	a0,s0,-40
     b2e:	00000097          	auipc	ra,0x0
     b32:	2d2080e7          	jalr	722(ra) # e00 <wait>

  exit(0);
     b36:	4501                	li	a0,0
     b38:	00000097          	auipc	ra,0x0
     b3c:	2c0080e7          	jalr	704(ra) # df8 <exit>
    kill(pid1);
     b40:	8526                	mv	a0,s1
     b42:	00000097          	auipc	ra,0x0
     b46:	2e6080e7          	jalr	742(ra) # e28 <kill>
    kill(pid2);
     b4a:	854a                	mv	a0,s2
     b4c:	00000097          	auipc	ra,0x0
     b50:	2dc080e7          	jalr	732(ra) # e28 <kill>
     b54:	bfc1                	j	b24 <iter+0xc4>

0000000000000b56 <main>:
}

int
main()
{
     b56:	1141                	add	sp,sp,-16
     b58:	e406                	sd	ra,8(sp)
     b5a:	e022                	sd	s0,0(sp)
     b5c:	0800                	add	s0,sp,16
     b5e:	a811                	j	b72 <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     b60:	00000097          	auipc	ra,0x0
     b64:	f00080e7          	jalr	-256(ra) # a60 <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     b68:	4551                	li	a0,20
     b6a:	00000097          	auipc	ra,0x0
     b6e:	31e080e7          	jalr	798(ra) # e88 <sleep>
    int pid = fork();
     b72:	00000097          	auipc	ra,0x0
     b76:	27e080e7          	jalr	638(ra) # df0 <fork>
    if(pid == 0){
     b7a:	d17d                	beqz	a0,b60 <main+0xa>
    if(pid > 0){
     b7c:	fea056e3          	blez	a0,b68 <main+0x12>
      wait(0);
     b80:	4501                	li	a0,0
     b82:	00000097          	auipc	ra,0x0
     b86:	27e080e7          	jalr	638(ra) # e00 <wait>
     b8a:	bff9                	j	b68 <main+0x12>

0000000000000b8c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b8c:	1141                	add	sp,sp,-16
     b8e:	e422                	sd	s0,8(sp)
     b90:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b92:	87aa                	mv	a5,a0
     b94:	0585                	add	a1,a1,1
     b96:	0785                	add	a5,a5,1
     b98:	fff5c703          	lbu	a4,-1(a1)
     b9c:	fee78fa3          	sb	a4,-1(a5)
     ba0:	fb75                	bnez	a4,b94 <strcpy+0x8>
    ;
  return os;
}
     ba2:	6422                	ld	s0,8(sp)
     ba4:	0141                	add	sp,sp,16
     ba6:	8082                	ret

0000000000000ba8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba8:	1141                	add	sp,sp,-16
     baa:	e422                	sd	s0,8(sp)
     bac:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     bae:	00054783          	lbu	a5,0(a0)
     bb2:	cb91                	beqz	a5,bc6 <strcmp+0x1e>
     bb4:	0005c703          	lbu	a4,0(a1)
     bb8:	00f71763          	bne	a4,a5,bc6 <strcmp+0x1e>
    p++, q++;
     bbc:	0505                	add	a0,a0,1
     bbe:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     bc0:	00054783          	lbu	a5,0(a0)
     bc4:	fbe5                	bnez	a5,bb4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bc6:	0005c503          	lbu	a0,0(a1)
}
     bca:	40a7853b          	subw	a0,a5,a0
     bce:	6422                	ld	s0,8(sp)
     bd0:	0141                	add	sp,sp,16
     bd2:	8082                	ret

0000000000000bd4 <strlen>:

uint
strlen(const char *s)
{
     bd4:	1141                	add	sp,sp,-16
     bd6:	e422                	sd	s0,8(sp)
     bd8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bda:	00054783          	lbu	a5,0(a0)
     bde:	cf91                	beqz	a5,bfa <strlen+0x26>
     be0:	0505                	add	a0,a0,1
     be2:	87aa                	mv	a5,a0
     be4:	86be                	mv	a3,a5
     be6:	0785                	add	a5,a5,1
     be8:	fff7c703          	lbu	a4,-1(a5)
     bec:	ff65                	bnez	a4,be4 <strlen+0x10>
     bee:	40a6853b          	subw	a0,a3,a0
     bf2:	2505                	addw	a0,a0,1
    ;
  return n;
}
     bf4:	6422                	ld	s0,8(sp)
     bf6:	0141                	add	sp,sp,16
     bf8:	8082                	ret
  for(n = 0; s[n]; n++)
     bfa:	4501                	li	a0,0
     bfc:	bfe5                	j	bf4 <strlen+0x20>

0000000000000bfe <memset>:

void*
memset(void *dst, int c, uint n)
{
     bfe:	1141                	add	sp,sp,-16
     c00:	e422                	sd	s0,8(sp)
     c02:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c04:	ca19                	beqz	a2,c1a <memset+0x1c>
     c06:	87aa                	mv	a5,a0
     c08:	1602                	sll	a2,a2,0x20
     c0a:	9201                	srl	a2,a2,0x20
     c0c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c10:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c14:	0785                	add	a5,a5,1
     c16:	fee79de3          	bne	a5,a4,c10 <memset+0x12>
  }
  return dst;
}
     c1a:	6422                	ld	s0,8(sp)
     c1c:	0141                	add	sp,sp,16
     c1e:	8082                	ret

0000000000000c20 <strchr>:

char*
strchr(const char *s, char c)
{
     c20:	1141                	add	sp,sp,-16
     c22:	e422                	sd	s0,8(sp)
     c24:	0800                	add	s0,sp,16
  for(; *s; s++)
     c26:	00054783          	lbu	a5,0(a0)
     c2a:	cb99                	beqz	a5,c40 <strchr+0x20>
    if(*s == c)
     c2c:	00f58763          	beq	a1,a5,c3a <strchr+0x1a>
  for(; *s; s++)
     c30:	0505                	add	a0,a0,1
     c32:	00054783          	lbu	a5,0(a0)
     c36:	fbfd                	bnez	a5,c2c <strchr+0xc>
      return (char*)s;
  return 0;
     c38:	4501                	li	a0,0
}
     c3a:	6422                	ld	s0,8(sp)
     c3c:	0141                	add	sp,sp,16
     c3e:	8082                	ret
  return 0;
     c40:	4501                	li	a0,0
     c42:	bfe5                	j	c3a <strchr+0x1a>

0000000000000c44 <gets>:

char*
gets(char *buf, int max)
{
     c44:	711d                	add	sp,sp,-96
     c46:	ec86                	sd	ra,88(sp)
     c48:	e8a2                	sd	s0,80(sp)
     c4a:	e4a6                	sd	s1,72(sp)
     c4c:	e0ca                	sd	s2,64(sp)
     c4e:	fc4e                	sd	s3,56(sp)
     c50:	f852                	sd	s4,48(sp)
     c52:	f456                	sd	s5,40(sp)
     c54:	f05a                	sd	s6,32(sp)
     c56:	ec5e                	sd	s7,24(sp)
     c58:	1080                	add	s0,sp,96
     c5a:	8baa                	mv	s7,a0
     c5c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c5e:	892a                	mv	s2,a0
     c60:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c62:	4aa9                	li	s5,10
     c64:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c66:	89a6                	mv	s3,s1
     c68:	2485                	addw	s1,s1,1
     c6a:	0344d863          	bge	s1,s4,c9a <gets+0x56>
    cc = read(0, &c, 1);
     c6e:	4605                	li	a2,1
     c70:	faf40593          	add	a1,s0,-81
     c74:	4501                	li	a0,0
     c76:	00000097          	auipc	ra,0x0
     c7a:	19a080e7          	jalr	410(ra) # e10 <read>
    if(cc < 1)
     c7e:	00a05e63          	blez	a0,c9a <gets+0x56>
    buf[i++] = c;
     c82:	faf44783          	lbu	a5,-81(s0)
     c86:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c8a:	01578763          	beq	a5,s5,c98 <gets+0x54>
     c8e:	0905                	add	s2,s2,1
     c90:	fd679be3          	bne	a5,s6,c66 <gets+0x22>
  for(i=0; i+1 < max; ){
     c94:	89a6                	mv	s3,s1
     c96:	a011                	j	c9a <gets+0x56>
     c98:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c9a:	99de                	add	s3,s3,s7
     c9c:	00098023          	sb	zero,0(s3)
  return buf;
}
     ca0:	855e                	mv	a0,s7
     ca2:	60e6                	ld	ra,88(sp)
     ca4:	6446                	ld	s0,80(sp)
     ca6:	64a6                	ld	s1,72(sp)
     ca8:	6906                	ld	s2,64(sp)
     caa:	79e2                	ld	s3,56(sp)
     cac:	7a42                	ld	s4,48(sp)
     cae:	7aa2                	ld	s5,40(sp)
     cb0:	7b02                	ld	s6,32(sp)
     cb2:	6be2                	ld	s7,24(sp)
     cb4:	6125                	add	sp,sp,96
     cb6:	8082                	ret

0000000000000cb8 <stat>:

int
stat(const char *n, struct stat *st)
{
     cb8:	1101                	add	sp,sp,-32
     cba:	ec06                	sd	ra,24(sp)
     cbc:	e822                	sd	s0,16(sp)
     cbe:	e426                	sd	s1,8(sp)
     cc0:	e04a                	sd	s2,0(sp)
     cc2:	1000                	add	s0,sp,32
     cc4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cc6:	4581                	li	a1,0
     cc8:	00000097          	auipc	ra,0x0
     ccc:	170080e7          	jalr	368(ra) # e38 <open>
  if(fd < 0)
     cd0:	02054563          	bltz	a0,cfa <stat+0x42>
     cd4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cd6:	85ca                	mv	a1,s2
     cd8:	00000097          	auipc	ra,0x0
     cdc:	178080e7          	jalr	376(ra) # e50 <fstat>
     ce0:	892a                	mv	s2,a0
  close(fd);
     ce2:	8526                	mv	a0,s1
     ce4:	00000097          	auipc	ra,0x0
     ce8:	13c080e7          	jalr	316(ra) # e20 <close>
  return r;
}
     cec:	854a                	mv	a0,s2
     cee:	60e2                	ld	ra,24(sp)
     cf0:	6442                	ld	s0,16(sp)
     cf2:	64a2                	ld	s1,8(sp)
     cf4:	6902                	ld	s2,0(sp)
     cf6:	6105                	add	sp,sp,32
     cf8:	8082                	ret
    return -1;
     cfa:	597d                	li	s2,-1
     cfc:	bfc5                	j	cec <stat+0x34>

0000000000000cfe <atoi>:

int
atoi(const char *s)
{
     cfe:	1141                	add	sp,sp,-16
     d00:	e422                	sd	s0,8(sp)
     d02:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d04:	00054683          	lbu	a3,0(a0)
     d08:	fd06879b          	addw	a5,a3,-48
     d0c:	0ff7f793          	zext.b	a5,a5
     d10:	4625                	li	a2,9
     d12:	02f66863          	bltu	a2,a5,d42 <atoi+0x44>
     d16:	872a                	mv	a4,a0
  n = 0;
     d18:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d1a:	0705                	add	a4,a4,1
     d1c:	0025179b          	sllw	a5,a0,0x2
     d20:	9fa9                	addw	a5,a5,a0
     d22:	0017979b          	sllw	a5,a5,0x1
     d26:	9fb5                	addw	a5,a5,a3
     d28:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d2c:	00074683          	lbu	a3,0(a4)
     d30:	fd06879b          	addw	a5,a3,-48
     d34:	0ff7f793          	zext.b	a5,a5
     d38:	fef671e3          	bgeu	a2,a5,d1a <atoi+0x1c>
  return n;
}
     d3c:	6422                	ld	s0,8(sp)
     d3e:	0141                	add	sp,sp,16
     d40:	8082                	ret
  n = 0;
     d42:	4501                	li	a0,0
     d44:	bfe5                	j	d3c <atoi+0x3e>

0000000000000d46 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d46:	1141                	add	sp,sp,-16
     d48:	e422                	sd	s0,8(sp)
     d4a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d4c:	02b57463          	bgeu	a0,a1,d74 <memmove+0x2e>
    while(n-- > 0)
     d50:	00c05f63          	blez	a2,d6e <memmove+0x28>
     d54:	1602                	sll	a2,a2,0x20
     d56:	9201                	srl	a2,a2,0x20
     d58:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d5c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d5e:	0585                	add	a1,a1,1
     d60:	0705                	add	a4,a4,1
     d62:	fff5c683          	lbu	a3,-1(a1)
     d66:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d6a:	fee79ae3          	bne	a5,a4,d5e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d6e:	6422                	ld	s0,8(sp)
     d70:	0141                	add	sp,sp,16
     d72:	8082                	ret
    dst += n;
     d74:	00c50733          	add	a4,a0,a2
    src += n;
     d78:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d7a:	fec05ae3          	blez	a2,d6e <memmove+0x28>
     d7e:	fff6079b          	addw	a5,a2,-1
     d82:	1782                	sll	a5,a5,0x20
     d84:	9381                	srl	a5,a5,0x20
     d86:	fff7c793          	not	a5,a5
     d8a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d8c:	15fd                	add	a1,a1,-1
     d8e:	177d                	add	a4,a4,-1
     d90:	0005c683          	lbu	a3,0(a1)
     d94:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d98:	fee79ae3          	bne	a5,a4,d8c <memmove+0x46>
     d9c:	bfc9                	j	d6e <memmove+0x28>

0000000000000d9e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d9e:	1141                	add	sp,sp,-16
     da0:	e422                	sd	s0,8(sp)
     da2:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     da4:	ca05                	beqz	a2,dd4 <memcmp+0x36>
     da6:	fff6069b          	addw	a3,a2,-1
     daa:	1682                	sll	a3,a3,0x20
     dac:	9281                	srl	a3,a3,0x20
     dae:	0685                	add	a3,a3,1
     db0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     db2:	00054783          	lbu	a5,0(a0)
     db6:	0005c703          	lbu	a4,0(a1)
     dba:	00e79863          	bne	a5,a4,dca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dbe:	0505                	add	a0,a0,1
    p2++;
     dc0:	0585                	add	a1,a1,1
  while (n-- > 0) {
     dc2:	fed518e3          	bne	a0,a3,db2 <memcmp+0x14>
  }
  return 0;
     dc6:	4501                	li	a0,0
     dc8:	a019                	j	dce <memcmp+0x30>
      return *p1 - *p2;
     dca:	40e7853b          	subw	a0,a5,a4
}
     dce:	6422                	ld	s0,8(sp)
     dd0:	0141                	add	sp,sp,16
     dd2:	8082                	ret
  return 0;
     dd4:	4501                	li	a0,0
     dd6:	bfe5                	j	dce <memcmp+0x30>

0000000000000dd8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     dd8:	1141                	add	sp,sp,-16
     dda:	e406                	sd	ra,8(sp)
     ddc:	e022                	sd	s0,0(sp)
     dde:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     de0:	00000097          	auipc	ra,0x0
     de4:	f66080e7          	jalr	-154(ra) # d46 <memmove>
}
     de8:	60a2                	ld	ra,8(sp)
     dea:	6402                	ld	s0,0(sp)
     dec:	0141                	add	sp,sp,16
     dee:	8082                	ret

0000000000000df0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     df0:	4885                	li	a7,1
 ecall
     df2:	00000073          	ecall
 ret
     df6:	8082                	ret

0000000000000df8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     df8:	4889                	li	a7,2
 ecall
     dfa:	00000073          	ecall
 ret
     dfe:	8082                	ret

0000000000000e00 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e00:	488d                	li	a7,3
 ecall
     e02:	00000073          	ecall
 ret
     e06:	8082                	ret

0000000000000e08 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e08:	4891                	li	a7,4
 ecall
     e0a:	00000073          	ecall
 ret
     e0e:	8082                	ret

0000000000000e10 <read>:
.global read
read:
 li a7, SYS_read
     e10:	4895                	li	a7,5
 ecall
     e12:	00000073          	ecall
 ret
     e16:	8082                	ret

0000000000000e18 <write>:
.global write
write:
 li a7, SYS_write
     e18:	48c1                	li	a7,16
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <close>:
.global close
close:
 li a7, SYS_close
     e20:	48d5                	li	a7,21
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e28:	4899                	li	a7,6
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e30:	489d                	li	a7,7
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <open>:
.global open
open:
 li a7, SYS_open
     e38:	48bd                	li	a7,15
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e40:	48c5                	li	a7,17
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e48:	48c9                	li	a7,18
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e50:	48a1                	li	a7,8
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <link>:
.global link
link:
 li a7, SYS_link
     e58:	48cd                	li	a7,19
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e60:	48d1                	li	a7,20
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e68:	48a5                	li	a7,9
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e70:	48a9                	li	a7,10
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e78:	48ad                	li	a7,11
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e80:	48b1                	li	a7,12
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e88:	48b5                	li	a7,13
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e90:	48b9                	li	a7,14
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <trace>:
.global trace
trace:
 li a7, SYS_trace
     e98:	48d9                	li	a7,22
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
     ea0:	48dd                	li	a7,23
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ea8:	1101                	add	sp,sp,-32
     eaa:	ec06                	sd	ra,24(sp)
     eac:	e822                	sd	s0,16(sp)
     eae:	1000                	add	s0,sp,32
     eb0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     eb4:	4605                	li	a2,1
     eb6:	fef40593          	add	a1,s0,-17
     eba:	00000097          	auipc	ra,0x0
     ebe:	f5e080e7          	jalr	-162(ra) # e18 <write>
}
     ec2:	60e2                	ld	ra,24(sp)
     ec4:	6442                	ld	s0,16(sp)
     ec6:	6105                	add	sp,sp,32
     ec8:	8082                	ret

0000000000000eca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eca:	7139                	add	sp,sp,-64
     ecc:	fc06                	sd	ra,56(sp)
     ece:	f822                	sd	s0,48(sp)
     ed0:	f426                	sd	s1,40(sp)
     ed2:	f04a                	sd	s2,32(sp)
     ed4:	ec4e                	sd	s3,24(sp)
     ed6:	0080                	add	s0,sp,64
     ed8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     eda:	c299                	beqz	a3,ee0 <printint+0x16>
     edc:	0805c963          	bltz	a1,f6e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ee0:	2581                	sext.w	a1,a1
  neg = 0;
     ee2:	4881                	li	a7,0
     ee4:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     ee8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     eea:	2601                	sext.w	a2,a2
     eec:	00000517          	auipc	a0,0x0
     ef0:	7cc50513          	add	a0,a0,1996 # 16b8 <digits>
     ef4:	883a                	mv	a6,a4
     ef6:	2705                	addw	a4,a4,1
     ef8:	02c5f7bb          	remuw	a5,a1,a2
     efc:	1782                	sll	a5,a5,0x20
     efe:	9381                	srl	a5,a5,0x20
     f00:	97aa                	add	a5,a5,a0
     f02:	0007c783          	lbu	a5,0(a5)
     f06:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f0a:	0005879b          	sext.w	a5,a1
     f0e:	02c5d5bb          	divuw	a1,a1,a2
     f12:	0685                	add	a3,a3,1
     f14:	fec7f0e3          	bgeu	a5,a2,ef4 <printint+0x2a>
  if(neg)
     f18:	00088c63          	beqz	a7,f30 <printint+0x66>
    buf[i++] = '-';
     f1c:	fd070793          	add	a5,a4,-48
     f20:	00878733          	add	a4,a5,s0
     f24:	02d00793          	li	a5,45
     f28:	fef70823          	sb	a5,-16(a4)
     f2c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     f30:	02e05863          	blez	a4,f60 <printint+0x96>
     f34:	fc040793          	add	a5,s0,-64
     f38:	00e78933          	add	s2,a5,a4
     f3c:	fff78993          	add	s3,a5,-1
     f40:	99ba                	add	s3,s3,a4
     f42:	377d                	addw	a4,a4,-1
     f44:	1702                	sll	a4,a4,0x20
     f46:	9301                	srl	a4,a4,0x20
     f48:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f4c:	fff94583          	lbu	a1,-1(s2)
     f50:	8526                	mv	a0,s1
     f52:	00000097          	auipc	ra,0x0
     f56:	f56080e7          	jalr	-170(ra) # ea8 <putc>
  while(--i >= 0)
     f5a:	197d                	add	s2,s2,-1
     f5c:	ff3918e3          	bne	s2,s3,f4c <printint+0x82>
}
     f60:	70e2                	ld	ra,56(sp)
     f62:	7442                	ld	s0,48(sp)
     f64:	74a2                	ld	s1,40(sp)
     f66:	7902                	ld	s2,32(sp)
     f68:	69e2                	ld	s3,24(sp)
     f6a:	6121                	add	sp,sp,64
     f6c:	8082                	ret
    x = -xx;
     f6e:	40b005bb          	negw	a1,a1
    neg = 1;
     f72:	4885                	li	a7,1
    x = -xx;
     f74:	bf85                	j	ee4 <printint+0x1a>

0000000000000f76 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f76:	715d                	add	sp,sp,-80
     f78:	e486                	sd	ra,72(sp)
     f7a:	e0a2                	sd	s0,64(sp)
     f7c:	fc26                	sd	s1,56(sp)
     f7e:	f84a                	sd	s2,48(sp)
     f80:	f44e                	sd	s3,40(sp)
     f82:	f052                	sd	s4,32(sp)
     f84:	ec56                	sd	s5,24(sp)
     f86:	e85a                	sd	s6,16(sp)
     f88:	e45e                	sd	s7,8(sp)
     f8a:	e062                	sd	s8,0(sp)
     f8c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f8e:	0005c903          	lbu	s2,0(a1)
     f92:	18090c63          	beqz	s2,112a <vprintf+0x1b4>
     f96:	8aaa                	mv	s5,a0
     f98:	8bb2                	mv	s7,a2
     f9a:	00158493          	add	s1,a1,1
  state = 0;
     f9e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fa0:	02500a13          	li	s4,37
     fa4:	4b55                	li	s6,21
     fa6:	a839                	j	fc4 <vprintf+0x4e>
        putc(fd, c);
     fa8:	85ca                	mv	a1,s2
     faa:	8556                	mv	a0,s5
     fac:	00000097          	auipc	ra,0x0
     fb0:	efc080e7          	jalr	-260(ra) # ea8 <putc>
     fb4:	a019                	j	fba <vprintf+0x44>
    } else if(state == '%'){
     fb6:	01498d63          	beq	s3,s4,fd0 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
     fba:	0485                	add	s1,s1,1
     fbc:	fff4c903          	lbu	s2,-1(s1)
     fc0:	16090563          	beqz	s2,112a <vprintf+0x1b4>
    if(state == 0){
     fc4:	fe0999e3          	bnez	s3,fb6 <vprintf+0x40>
      if(c == '%'){
     fc8:	ff4910e3          	bne	s2,s4,fa8 <vprintf+0x32>
        state = '%';
     fcc:	89d2                	mv	s3,s4
     fce:	b7f5                	j	fba <vprintf+0x44>
      if(c == 'd'){
     fd0:	13490263          	beq	s2,s4,10f4 <vprintf+0x17e>
     fd4:	f9d9079b          	addw	a5,s2,-99
     fd8:	0ff7f793          	zext.b	a5,a5
     fdc:	12fb6563          	bltu	s6,a5,1106 <vprintf+0x190>
     fe0:	f9d9079b          	addw	a5,s2,-99
     fe4:	0ff7f713          	zext.b	a4,a5
     fe8:	10eb6f63          	bltu	s6,a4,1106 <vprintf+0x190>
     fec:	00271793          	sll	a5,a4,0x2
     ff0:	00000717          	auipc	a4,0x0
     ff4:	67070713          	add	a4,a4,1648 # 1660 <malloc+0x438>
     ff8:	97ba                	add	a5,a5,a4
     ffa:	439c                	lw	a5,0(a5)
     ffc:	97ba                	add	a5,a5,a4
     ffe:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1000:	008b8913          	add	s2,s7,8
    1004:	4685                	li	a3,1
    1006:	4629                	li	a2,10
    1008:	000ba583          	lw	a1,0(s7)
    100c:	8556                	mv	a0,s5
    100e:	00000097          	auipc	ra,0x0
    1012:	ebc080e7          	jalr	-324(ra) # eca <printint>
    1016:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1018:	4981                	li	s3,0
    101a:	b745                	j	fba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    101c:	008b8913          	add	s2,s7,8
    1020:	4681                	li	a3,0
    1022:	4629                	li	a2,10
    1024:	000ba583          	lw	a1,0(s7)
    1028:	8556                	mv	a0,s5
    102a:	00000097          	auipc	ra,0x0
    102e:	ea0080e7          	jalr	-352(ra) # eca <printint>
    1032:	8bca                	mv	s7,s2
      state = 0;
    1034:	4981                	li	s3,0
    1036:	b751                	j	fba <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    1038:	008b8913          	add	s2,s7,8
    103c:	4681                	li	a3,0
    103e:	4641                	li	a2,16
    1040:	000ba583          	lw	a1,0(s7)
    1044:	8556                	mv	a0,s5
    1046:	00000097          	auipc	ra,0x0
    104a:	e84080e7          	jalr	-380(ra) # eca <printint>
    104e:	8bca                	mv	s7,s2
      state = 0;
    1050:	4981                	li	s3,0
    1052:	b7a5                	j	fba <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    1054:	008b8c13          	add	s8,s7,8
    1058:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    105c:	03000593          	li	a1,48
    1060:	8556                	mv	a0,s5
    1062:	00000097          	auipc	ra,0x0
    1066:	e46080e7          	jalr	-442(ra) # ea8 <putc>
  putc(fd, 'x');
    106a:	07800593          	li	a1,120
    106e:	8556                	mv	a0,s5
    1070:	00000097          	auipc	ra,0x0
    1074:	e38080e7          	jalr	-456(ra) # ea8 <putc>
    1078:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    107a:	00000b97          	auipc	s7,0x0
    107e:	63eb8b93          	add	s7,s7,1598 # 16b8 <digits>
    1082:	03c9d793          	srl	a5,s3,0x3c
    1086:	97de                	add	a5,a5,s7
    1088:	0007c583          	lbu	a1,0(a5)
    108c:	8556                	mv	a0,s5
    108e:	00000097          	auipc	ra,0x0
    1092:	e1a080e7          	jalr	-486(ra) # ea8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1096:	0992                	sll	s3,s3,0x4
    1098:	397d                	addw	s2,s2,-1
    109a:	fe0914e3          	bnez	s2,1082 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    109e:	8be2                	mv	s7,s8
      state = 0;
    10a0:	4981                	li	s3,0
    10a2:	bf21                	j	fba <vprintf+0x44>
        s = va_arg(ap, char*);
    10a4:	008b8993          	add	s3,s7,8
    10a8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    10ac:	02090163          	beqz	s2,10ce <vprintf+0x158>
        while(*s != 0){
    10b0:	00094583          	lbu	a1,0(s2)
    10b4:	c9a5                	beqz	a1,1124 <vprintf+0x1ae>
          putc(fd, *s);
    10b6:	8556                	mv	a0,s5
    10b8:	00000097          	auipc	ra,0x0
    10bc:	df0080e7          	jalr	-528(ra) # ea8 <putc>
          s++;
    10c0:	0905                	add	s2,s2,1
        while(*s != 0){
    10c2:	00094583          	lbu	a1,0(s2)
    10c6:	f9e5                	bnez	a1,10b6 <vprintf+0x140>
        s = va_arg(ap, char*);
    10c8:	8bce                	mv	s7,s3
      state = 0;
    10ca:	4981                	li	s3,0
    10cc:	b5fd                	j	fba <vprintf+0x44>
          s = "(null)";
    10ce:	00000917          	auipc	s2,0x0
    10d2:	58a90913          	add	s2,s2,1418 # 1658 <malloc+0x430>
        while(*s != 0){
    10d6:	02800593          	li	a1,40
    10da:	bff1                	j	10b6 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    10dc:	008b8913          	add	s2,s7,8
    10e0:	000bc583          	lbu	a1,0(s7)
    10e4:	8556                	mv	a0,s5
    10e6:	00000097          	auipc	ra,0x0
    10ea:	dc2080e7          	jalr	-574(ra) # ea8 <putc>
    10ee:	8bca                	mv	s7,s2
      state = 0;
    10f0:	4981                	li	s3,0
    10f2:	b5e1                	j	fba <vprintf+0x44>
        putc(fd, c);
    10f4:	02500593          	li	a1,37
    10f8:	8556                	mv	a0,s5
    10fa:	00000097          	auipc	ra,0x0
    10fe:	dae080e7          	jalr	-594(ra) # ea8 <putc>
      state = 0;
    1102:	4981                	li	s3,0
    1104:	bd5d                	j	fba <vprintf+0x44>
        putc(fd, '%');
    1106:	02500593          	li	a1,37
    110a:	8556                	mv	a0,s5
    110c:	00000097          	auipc	ra,0x0
    1110:	d9c080e7          	jalr	-612(ra) # ea8 <putc>
        putc(fd, c);
    1114:	85ca                	mv	a1,s2
    1116:	8556                	mv	a0,s5
    1118:	00000097          	auipc	ra,0x0
    111c:	d90080e7          	jalr	-624(ra) # ea8 <putc>
      state = 0;
    1120:	4981                	li	s3,0
    1122:	bd61                	j	fba <vprintf+0x44>
        s = va_arg(ap, char*);
    1124:	8bce                	mv	s7,s3
      state = 0;
    1126:	4981                	li	s3,0
    1128:	bd49                	j	fba <vprintf+0x44>
    }
  }
}
    112a:	60a6                	ld	ra,72(sp)
    112c:	6406                	ld	s0,64(sp)
    112e:	74e2                	ld	s1,56(sp)
    1130:	7942                	ld	s2,48(sp)
    1132:	79a2                	ld	s3,40(sp)
    1134:	7a02                	ld	s4,32(sp)
    1136:	6ae2                	ld	s5,24(sp)
    1138:	6b42                	ld	s6,16(sp)
    113a:	6ba2                	ld	s7,8(sp)
    113c:	6c02                	ld	s8,0(sp)
    113e:	6161                	add	sp,sp,80
    1140:	8082                	ret

0000000000001142 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1142:	715d                	add	sp,sp,-80
    1144:	ec06                	sd	ra,24(sp)
    1146:	e822                	sd	s0,16(sp)
    1148:	1000                	add	s0,sp,32
    114a:	e010                	sd	a2,0(s0)
    114c:	e414                	sd	a3,8(s0)
    114e:	e818                	sd	a4,16(s0)
    1150:	ec1c                	sd	a5,24(s0)
    1152:	03043023          	sd	a6,32(s0)
    1156:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    115a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    115e:	8622                	mv	a2,s0
    1160:	00000097          	auipc	ra,0x0
    1164:	e16080e7          	jalr	-490(ra) # f76 <vprintf>
}
    1168:	60e2                	ld	ra,24(sp)
    116a:	6442                	ld	s0,16(sp)
    116c:	6161                	add	sp,sp,80
    116e:	8082                	ret

0000000000001170 <printf>:

void
printf(const char *fmt, ...)
{
    1170:	711d                	add	sp,sp,-96
    1172:	ec06                	sd	ra,24(sp)
    1174:	e822                	sd	s0,16(sp)
    1176:	1000                	add	s0,sp,32
    1178:	e40c                	sd	a1,8(s0)
    117a:	e810                	sd	a2,16(s0)
    117c:	ec14                	sd	a3,24(s0)
    117e:	f018                	sd	a4,32(s0)
    1180:	f41c                	sd	a5,40(s0)
    1182:	03043823          	sd	a6,48(s0)
    1186:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    118a:	00840613          	add	a2,s0,8
    118e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1192:	85aa                	mv	a1,a0
    1194:	4505                	li	a0,1
    1196:	00000097          	auipc	ra,0x0
    119a:	de0080e7          	jalr	-544(ra) # f76 <vprintf>
}
    119e:	60e2                	ld	ra,24(sp)
    11a0:	6442                	ld	s0,16(sp)
    11a2:	6125                	add	sp,sp,96
    11a4:	8082                	ret

00000000000011a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11a6:	1141                	add	sp,sp,-16
    11a8:	e422                	sd	s0,8(sp)
    11aa:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11ac:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11b0:	00000797          	auipc	a5,0x0
    11b4:	5287b783          	ld	a5,1320(a5) # 16d8 <freep>
    11b8:	a02d                	j	11e2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11ba:	4618                	lw	a4,8(a2)
    11bc:	9f2d                	addw	a4,a4,a1
    11be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11c2:	6398                	ld	a4,0(a5)
    11c4:	6310                	ld	a2,0(a4)
    11c6:	a83d                	j	1204 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11c8:	ff852703          	lw	a4,-8(a0)
    11cc:	9f31                	addw	a4,a4,a2
    11ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11d0:	ff053683          	ld	a3,-16(a0)
    11d4:	a091                	j	1218 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11d6:	6398                	ld	a4,0(a5)
    11d8:	00e7e463          	bltu	a5,a4,11e0 <free+0x3a>
    11dc:	00e6ea63          	bltu	a3,a4,11f0 <free+0x4a>
{
    11e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11e2:	fed7fae3          	bgeu	a5,a3,11d6 <free+0x30>
    11e6:	6398                	ld	a4,0(a5)
    11e8:	00e6e463          	bltu	a3,a4,11f0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ec:	fee7eae3          	bltu	a5,a4,11e0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11f0:	ff852583          	lw	a1,-8(a0)
    11f4:	6390                	ld	a2,0(a5)
    11f6:	02059813          	sll	a6,a1,0x20
    11fa:	01c85713          	srl	a4,a6,0x1c
    11fe:	9736                	add	a4,a4,a3
    1200:	fae60de3          	beq	a2,a4,11ba <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1204:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1208:	4790                	lw	a2,8(a5)
    120a:	02061593          	sll	a1,a2,0x20
    120e:	01c5d713          	srl	a4,a1,0x1c
    1212:	973e                	add	a4,a4,a5
    1214:	fae68ae3          	beq	a3,a4,11c8 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1218:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    121a:	00000717          	auipc	a4,0x0
    121e:	4af73f23          	sd	a5,1214(a4) # 16d8 <freep>
}
    1222:	6422                	ld	s0,8(sp)
    1224:	0141                	add	sp,sp,16
    1226:	8082                	ret

0000000000001228 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1228:	7139                	add	sp,sp,-64
    122a:	fc06                	sd	ra,56(sp)
    122c:	f822                	sd	s0,48(sp)
    122e:	f426                	sd	s1,40(sp)
    1230:	f04a                	sd	s2,32(sp)
    1232:	ec4e                	sd	s3,24(sp)
    1234:	e852                	sd	s4,16(sp)
    1236:	e456                	sd	s5,8(sp)
    1238:	e05a                	sd	s6,0(sp)
    123a:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    123c:	02051493          	sll	s1,a0,0x20
    1240:	9081                	srl	s1,s1,0x20
    1242:	04bd                	add	s1,s1,15
    1244:	8091                	srl	s1,s1,0x4
    1246:	0014899b          	addw	s3,s1,1
    124a:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    124c:	00000517          	auipc	a0,0x0
    1250:	48c53503          	ld	a0,1164(a0) # 16d8 <freep>
    1254:	c515                	beqz	a0,1280 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1256:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1258:	4798                	lw	a4,8(a5)
    125a:	02977f63          	bgeu	a4,s1,1298 <malloc+0x70>
  if(nu < 4096)
    125e:	8a4e                	mv	s4,s3
    1260:	0009871b          	sext.w	a4,s3
    1264:	6685                	lui	a3,0x1
    1266:	00d77363          	bgeu	a4,a3,126c <malloc+0x44>
    126a:	6a05                	lui	s4,0x1
    126c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1270:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1274:	00000917          	auipc	s2,0x0
    1278:	46490913          	add	s2,s2,1124 # 16d8 <freep>
  if(p == (char*)-1)
    127c:	5afd                	li	s5,-1
    127e:	a895                	j	12f2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1280:	00001797          	auipc	a5,0x1
    1284:	84878793          	add	a5,a5,-1976 # 1ac8 <base>
    1288:	00000717          	auipc	a4,0x0
    128c:	44f73823          	sd	a5,1104(a4) # 16d8 <freep>
    1290:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1292:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1296:	b7e1                	j	125e <malloc+0x36>
      if(p->s.size == nunits)
    1298:	02e48c63          	beq	s1,a4,12d0 <malloc+0xa8>
        p->s.size -= nunits;
    129c:	4137073b          	subw	a4,a4,s3
    12a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12a2:	02071693          	sll	a3,a4,0x20
    12a6:	01c6d713          	srl	a4,a3,0x1c
    12aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12b0:	00000717          	auipc	a4,0x0
    12b4:	42a73423          	sd	a0,1064(a4) # 16d8 <freep>
      return (void*)(p + 1);
    12b8:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12bc:	70e2                	ld	ra,56(sp)
    12be:	7442                	ld	s0,48(sp)
    12c0:	74a2                	ld	s1,40(sp)
    12c2:	7902                	ld	s2,32(sp)
    12c4:	69e2                	ld	s3,24(sp)
    12c6:	6a42                	ld	s4,16(sp)
    12c8:	6aa2                	ld	s5,8(sp)
    12ca:	6b02                	ld	s6,0(sp)
    12cc:	6121                	add	sp,sp,64
    12ce:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12d0:	6398                	ld	a4,0(a5)
    12d2:	e118                	sd	a4,0(a0)
    12d4:	bff1                	j	12b0 <malloc+0x88>
  hp->s.size = nu;
    12d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12da:	0541                	add	a0,a0,16
    12dc:	00000097          	auipc	ra,0x0
    12e0:	eca080e7          	jalr	-310(ra) # 11a6 <free>
  return freep;
    12e4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12e8:	d971                	beqz	a0,12bc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12ec:	4798                	lw	a4,8(a5)
    12ee:	fa9775e3          	bgeu	a4,s1,1298 <malloc+0x70>
    if(p == freep)
    12f2:	00093703          	ld	a4,0(s2)
    12f6:	853e                	mv	a0,a5
    12f8:	fef719e3          	bne	a4,a5,12ea <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    12fc:	8552                	mv	a0,s4
    12fe:	00000097          	auipc	ra,0x0
    1302:	b82080e7          	jalr	-1150(ra) # e80 <sbrk>
  if(p == (char*)-1)
    1306:	fd5518e3          	bne	a0,s5,12d6 <malloc+0xae>
        return 0;
    130a:	4501                	li	a0,0
    130c:	bf45                	j	12bc <malloc+0x94>
