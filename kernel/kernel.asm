
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9f013103          	ld	sp,-1552(sp) # 800089f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	73a050ef          	jal	80005750 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	sll	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	add	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	sll	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	add	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	0d8080e7          	jalr	216(ra) # 80006132 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	178080e7          	jalr	376(ra) # 800061e6 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	add	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	add	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b70080e7          	jalr	-1168(ra) # 80005bfa <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	add	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	add	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	add	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	add	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	add	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	fac080e7          	jalr	-84(ra) # 800060a2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	add	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	add	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	add	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	add	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	004080e7          	jalr	4(ra) # 80006132 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	add	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	0a0080e7          	jalr	160(ra) # 800061e6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	add	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	add	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	076080e7          	jalr	118(ra) # 800061e6 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <free_mem>:

// Return the number of bytes of free memory
uint64
free_mem(void)
{
    8000017a:	1101                	add	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	add	s0,sp,32
  struct run *r;
  // counting the number of free page
  uint64 num = 0;
  // add lock
  acquire(&kmem.lock);
    80000184:	00009497          	auipc	s1,0x9
    80000188:	eac48493          	add	s1,s1,-340 # 80009030 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	fa4080e7          	jalr	-92(ra) # 80006132 <acquire>
  // r points to freelist
  r = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
  // while r not null
  while (r)
    80000198:	c785                	beqz	a5,800001c0 <free_mem+0x46>
  uint64 num = 0;
    8000019a:	4481                	li	s1,0
  {
    // the num add one
    num++;
    8000019c:	0485                	add	s1,s1,1
    // r points to the next
    r = r->next;
    8000019e:	639c                	ld	a5,0(a5)
  while (r)
    800001a0:	fff5                	bnez	a5,8000019c <free_mem+0x22>
  }
  // release lock
  release(&kmem.lock);
    800001a2:	00009517          	auipc	a0,0x9
    800001a6:	e8e50513          	add	a0,a0,-370 # 80009030 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	03c080e7          	jalr	60(ra) # 800061e6 <release>
  // page multiplicated 4096-byte page
  return num * PGSIZE;
}
    800001b2:	00c49513          	sll	a0,s1,0xc
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	add	sp,sp,32
    800001be:	8082                	ret
  uint64 num = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7c5                	j	800001a2 <free_mem+0x28>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	add	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	sll	a2,a2,0x20
    800001d0:	9201                	srl	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	add	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	add	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	add	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	sll	a3,a3,0x20
    800001f4:	9281                	srl	a3,a3,0x20
    800001f6:	0685                	add	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	add	a0,a0,1
    80000208:	0585                	add	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	add	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	add	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	sll	a2,a2,0x20
    8000022e:	9201                	srl	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	add	a1,a1,1
    80000238:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	fef59ae3          	bne	a1,a5,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	add	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	sll	a3,a2,0x20
    80000250:	9281                	srl	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addw	a5,a2,-1
    80000260:	1782                	sll	a5,a5,0x20
    80000262:	9381                	srl	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	add	a4,a4,-1
    8000026c:	16fd                	add	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fee79ae3          	bne	a5,a4,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	add	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	add	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	add	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addw	a2,a2,-1
    800002ac:	0505                	add	a0,a0,1
    800002ae:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a809                	j	800002c6 <strncmp+0x32>
    800002b6:	4501                	li	a0,0
    800002b8:	a039                	j	800002c6 <strncmp+0x32>
  if(n == 0)
    800002ba:	ca09                	beqz	a2,800002cc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002bc:	00054503          	lbu	a0,0(a0)
    800002c0:	0005c783          	lbu	a5,0(a1)
    800002c4:	9d1d                	subw	a0,a0,a5
}
    800002c6:	6422                	ld	s0,8(sp)
    800002c8:	0141                	add	sp,sp,16
    800002ca:	8082                	ret
    return 0;
    800002cc:	4501                	li	a0,0
    800002ce:	bfe5                	j	800002c6 <strncmp+0x32>

00000000800002d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d0:	1141                	add	sp,sp,-16
    800002d2:	e422                	sd	s0,8(sp)
    800002d4:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d6:	87aa                	mv	a5,a0
    800002d8:	86b2                	mv	a3,a2
    800002da:	367d                	addw	a2,a2,-1
    800002dc:	00d05963          	blez	a3,800002ee <strncpy+0x1e>
    800002e0:	0785                	add	a5,a5,1
    800002e2:	0005c703          	lbu	a4,0(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	0585                	add	a1,a1,1
    800002ec:	f775                	bnez	a4,800002d8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ee:	873e                	mv	a4,a5
    800002f0:	9fb5                	addw	a5,a5,a3
    800002f2:	37fd                	addw	a5,a5,-1
    800002f4:	00c05963          	blez	a2,80000306 <strncpy+0x36>
    *s++ = 0;
    800002f8:	0705                	add	a4,a4,1
    800002fa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002fe:	40e786bb          	subw	a3,a5,a4
    80000302:	fed04be3          	bgtz	a3,800002f8 <strncpy+0x28>
  return os;
}
    80000306:	6422                	ld	s0,8(sp)
    80000308:	0141                	add	sp,sp,16
    8000030a:	8082                	ret

000000008000030c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000030c:	1141                	add	sp,sp,-16
    8000030e:	e422                	sd	s0,8(sp)
    80000310:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000312:	02c05363          	blez	a2,80000338 <safestrcpy+0x2c>
    80000316:	fff6069b          	addw	a3,a2,-1
    8000031a:	1682                	sll	a3,a3,0x20
    8000031c:	9281                	srl	a3,a3,0x20
    8000031e:	96ae                	add	a3,a3,a1
    80000320:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000322:	00d58963          	beq	a1,a3,80000334 <safestrcpy+0x28>
    80000326:	0585                	add	a1,a1,1
    80000328:	0785                	add	a5,a5,1
    8000032a:	fff5c703          	lbu	a4,-1(a1)
    8000032e:	fee78fa3          	sb	a4,-1(a5)
    80000332:	fb65                	bnez	a4,80000322 <safestrcpy+0x16>
    ;
  *s = 0;
    80000334:	00078023          	sb	zero,0(a5)
  return os;
}
    80000338:	6422                	ld	s0,8(sp)
    8000033a:	0141                	add	sp,sp,16
    8000033c:	8082                	ret

000000008000033e <strlen>:

int
strlen(const char *s)
{
    8000033e:	1141                	add	sp,sp,-16
    80000340:	e422                	sd	s0,8(sp)
    80000342:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000344:	00054783          	lbu	a5,0(a0)
    80000348:	cf91                	beqz	a5,80000364 <strlen+0x26>
    8000034a:	0505                	add	a0,a0,1
    8000034c:	87aa                	mv	a5,a0
    8000034e:	86be                	mv	a3,a5
    80000350:	0785                	add	a5,a5,1
    80000352:	fff7c703          	lbu	a4,-1(a5)
    80000356:	ff65                	bnez	a4,8000034e <strlen+0x10>
    80000358:	40a6853b          	subw	a0,a3,a0
    8000035c:	2505                	addw	a0,a0,1
    ;
  return n;
}
    8000035e:	6422                	ld	s0,8(sp)
    80000360:	0141                	add	sp,sp,16
    80000362:	8082                	ret
  for(n = 0; s[n]; n++)
    80000364:	4501                	li	a0,0
    80000366:	bfe5                	j	8000035e <strlen+0x20>

0000000080000368 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000368:	1141                	add	sp,sp,-16
    8000036a:	e406                	sd	ra,8(sp)
    8000036c:	e022                	sd	s0,0(sp)
    8000036e:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000370:	00001097          	auipc	ra,0x1
    80000374:	af0080e7          	jalr	-1296(ra) # 80000e60 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000378:	00009717          	auipc	a4,0x9
    8000037c:	c8870713          	add	a4,a4,-888 # 80009000 <started>
  if(cpuid() == 0){
    80000380:	c139                	beqz	a0,800003c6 <main+0x5e>
    while(started == 0)
    80000382:	431c                	lw	a5,0(a4)
    80000384:	2781                	sext.w	a5,a5
    80000386:	dff5                	beqz	a5,80000382 <main+0x1a>
      ;
    __sync_synchronize();
    80000388:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000038c:	00001097          	auipc	ra,0x1
    80000390:	ad4080e7          	jalr	-1324(ra) # 80000e60 <cpuid>
    80000394:	85aa                	mv	a1,a0
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	ca250513          	add	a0,a0,-862 # 80008038 <etext+0x38>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	8a6080e7          	jalr	-1882(ra) # 80005c44 <printf>
    kvminithart();    // turn on paging
    800003a6:	00000097          	auipc	ra,0x0
    800003aa:	0d8080e7          	jalr	216(ra) # 8000047e <kvminithart>
    trapinithart();   // install kernel trap vector
    800003ae:	00001097          	auipc	ra,0x1
    800003b2:	790080e7          	jalr	1936(ra) # 80001b3e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b6:	00005097          	auipc	ra,0x5
    800003ba:	d7a080e7          	jalr	-646(ra) # 80005130 <plicinithart>
  }

  scheduler();        
    800003be:	00001097          	auipc	ra,0x1
    800003c2:	fe8080e7          	jalr	-24(ra) # 800013a6 <scheduler>
    consoleinit();
    800003c6:	00005097          	auipc	ra,0x5
    800003ca:	744080e7          	jalr	1860(ra) # 80005b0a <consoleinit>
    printfinit();
    800003ce:	00006097          	auipc	ra,0x6
    800003d2:	a56080e7          	jalr	-1450(ra) # 80005e24 <printfinit>
    printf("\n");
    800003d6:	00008517          	auipc	a0,0x8
    800003da:	c7250513          	add	a0,a0,-910 # 80008048 <etext+0x48>
    800003de:	00006097          	auipc	ra,0x6
    800003e2:	866080e7          	jalr	-1946(ra) # 80005c44 <printf>
    printf("xv6 kernel is booting\n");
    800003e6:	00008517          	auipc	a0,0x8
    800003ea:	c3a50513          	add	a0,a0,-966 # 80008020 <etext+0x20>
    800003ee:	00006097          	auipc	ra,0x6
    800003f2:	856080e7          	jalr	-1962(ra) # 80005c44 <printf>
    printf("\n");
    800003f6:	00008517          	auipc	a0,0x8
    800003fa:	c5250513          	add	a0,a0,-942 # 80008048 <etext+0x48>
    800003fe:	00006097          	auipc	ra,0x6
    80000402:	846080e7          	jalr	-1978(ra) # 80005c44 <printf>
    kinit();         // physical page allocator
    80000406:	00000097          	auipc	ra,0x0
    8000040a:	cd8080e7          	jalr	-808(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	322080e7          	jalr	802(ra) # 80000730 <kvminit>
    kvminithart();   // turn on paging
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	068080e7          	jalr	104(ra) # 8000047e <kvminithart>
    procinit();      // process table
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	992080e7          	jalr	-1646(ra) # 80000db0 <procinit>
    trapinit();      // trap vectors
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	6f0080e7          	jalr	1776(ra) # 80001b16 <trapinit>
    trapinithart();  // install kernel trap vector
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	710080e7          	jalr	1808(ra) # 80001b3e <trapinithart>
    plicinit();      // set up interrupt controller
    80000436:	00005097          	auipc	ra,0x5
    8000043a:	ce4080e7          	jalr	-796(ra) # 8000511a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	cf2080e7          	jalr	-782(ra) # 80005130 <plicinithart>
    binit();         // buffer cache
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	f0c080e7          	jalr	-244(ra) # 80002352 <binit>
    iinit();         // inode table
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	598080e7          	jalr	1432(ra) # 800029e6 <iinit>
    fileinit();      // file table
    80000456:	00003097          	auipc	ra,0x3
    8000045a:	51a080e7          	jalr	1306(ra) # 80003970 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000045e:	00005097          	auipc	ra,0x5
    80000462:	df2080e7          	jalr	-526(ra) # 80005250 <virtio_disk_init>
    userinit();      // first user process
    80000466:	00001097          	auipc	ra,0x1
    8000046a:	cfe080e7          	jalr	-770(ra) # 80001164 <userinit>
    __sync_synchronize();
    8000046e:	0ff0000f          	fence
    started = 1;
    80000472:	4785                	li	a5,1
    80000474:	00009717          	auipc	a4,0x9
    80000478:	b8f72623          	sw	a5,-1140(a4) # 80009000 <started>
    8000047c:	b789                	j	800003be <main+0x56>

000000008000047e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000047e:	1141                	add	sp,sp,-16
    80000480:	e422                	sd	s0,8(sp)
    80000482:	0800                	add	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000484:	00009797          	auipc	a5,0x9
    80000488:	b847b783          	ld	a5,-1148(a5) # 80009008 <kernel_pagetable>
    8000048c:	83b1                	srl	a5,a5,0xc
    8000048e:	577d                	li	a4,-1
    80000490:	177e                	sll	a4,a4,0x3f
    80000492:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000494:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000498:	12000073          	sfence.vma
  sfence_vma();
}
    8000049c:	6422                	ld	s0,8(sp)
    8000049e:	0141                	add	sp,sp,16
    800004a0:	8082                	ret

00000000800004a2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004a2:	7139                	add	sp,sp,-64
    800004a4:	fc06                	sd	ra,56(sp)
    800004a6:	f822                	sd	s0,48(sp)
    800004a8:	f426                	sd	s1,40(sp)
    800004aa:	f04a                	sd	s2,32(sp)
    800004ac:	ec4e                	sd	s3,24(sp)
    800004ae:	e852                	sd	s4,16(sp)
    800004b0:	e456                	sd	s5,8(sp)
    800004b2:	e05a                	sd	s6,0(sp)
    800004b4:	0080                	add	s0,sp,64
    800004b6:	84aa                	mv	s1,a0
    800004b8:	89ae                	mv	s3,a1
    800004ba:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004bc:	57fd                	li	a5,-1
    800004be:	83e9                	srl	a5,a5,0x1a
    800004c0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004c2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004c4:	04b7f263          	bgeu	a5,a1,80000508 <walk+0x66>
    panic("walk");
    800004c8:	00008517          	auipc	a0,0x8
    800004cc:	b8850513          	add	a0,a0,-1144 # 80008050 <etext+0x50>
    800004d0:	00005097          	auipc	ra,0x5
    800004d4:	72a080e7          	jalr	1834(ra) # 80005bfa <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004d8:	060a8663          	beqz	s5,80000544 <walk+0xa2>
    800004dc:	00000097          	auipc	ra,0x0
    800004e0:	c3e080e7          	jalr	-962(ra) # 8000011a <kalloc>
    800004e4:	84aa                	mv	s1,a0
    800004e6:	c529                	beqz	a0,80000530 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004e8:	6605                	lui	a2,0x1
    800004ea:	4581                	li	a1,0
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	cd8080e7          	jalr	-808(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004f4:	00c4d793          	srl	a5,s1,0xc
    800004f8:	07aa                	sll	a5,a5,0xa
    800004fa:	0017e793          	or	a5,a5,1
    800004fe:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000502:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    80000504:	036a0063          	beq	s4,s6,80000524 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000508:	0149d933          	srl	s2,s3,s4
    8000050c:	1ff97913          	and	s2,s2,511
    80000510:	090e                	sll	s2,s2,0x3
    80000512:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000514:	00093483          	ld	s1,0(s2)
    80000518:	0014f793          	and	a5,s1,1
    8000051c:	dfd5                	beqz	a5,800004d8 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000051e:	80a9                	srl	s1,s1,0xa
    80000520:	04b2                	sll	s1,s1,0xc
    80000522:	b7c5                	j	80000502 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000524:	00c9d513          	srl	a0,s3,0xc
    80000528:	1ff57513          	and	a0,a0,511
    8000052c:	050e                	sll	a0,a0,0x3
    8000052e:	9526                	add	a0,a0,s1
}
    80000530:	70e2                	ld	ra,56(sp)
    80000532:	7442                	ld	s0,48(sp)
    80000534:	74a2                	ld	s1,40(sp)
    80000536:	7902                	ld	s2,32(sp)
    80000538:	69e2                	ld	s3,24(sp)
    8000053a:	6a42                	ld	s4,16(sp)
    8000053c:	6aa2                	ld	s5,8(sp)
    8000053e:	6b02                	ld	s6,0(sp)
    80000540:	6121                	add	sp,sp,64
    80000542:	8082                	ret
        return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7ed                	j	80000530 <walk+0x8e>

0000000080000548 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000548:	57fd                	li	a5,-1
    8000054a:	83e9                	srl	a5,a5,0x1a
    8000054c:	00b7f463          	bgeu	a5,a1,80000554 <walkaddr+0xc>
    return 0;
    80000550:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000552:	8082                	ret
{
    80000554:	1141                	add	sp,sp,-16
    80000556:	e406                	sd	ra,8(sp)
    80000558:	e022                	sd	s0,0(sp)
    8000055a:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000055c:	4601                	li	a2,0
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	f44080e7          	jalr	-188(ra) # 800004a2 <walk>
  if(pte == 0)
    80000566:	c105                	beqz	a0,80000586 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000568:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000056a:	0117f693          	and	a3,a5,17
    8000056e:	4745                	li	a4,17
    return 0;
    80000570:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000572:	00e68663          	beq	a3,a4,8000057e <walkaddr+0x36>
}
    80000576:	60a2                	ld	ra,8(sp)
    80000578:	6402                	ld	s0,0(sp)
    8000057a:	0141                	add	sp,sp,16
    8000057c:	8082                	ret
  pa = PTE2PA(*pte);
    8000057e:	83a9                	srl	a5,a5,0xa
    80000580:	00c79513          	sll	a0,a5,0xc
  return pa;
    80000584:	bfcd                	j	80000576 <walkaddr+0x2e>
    return 0;
    80000586:	4501                	li	a0,0
    80000588:	b7fd                	j	80000576 <walkaddr+0x2e>

000000008000058a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000058a:	715d                	add	sp,sp,-80
    8000058c:	e486                	sd	ra,72(sp)
    8000058e:	e0a2                	sd	s0,64(sp)
    80000590:	fc26                	sd	s1,56(sp)
    80000592:	f84a                	sd	s2,48(sp)
    80000594:	f44e                	sd	s3,40(sp)
    80000596:	f052                	sd	s4,32(sp)
    80000598:	ec56                	sd	s5,24(sp)
    8000059a:	e85a                	sd	s6,16(sp)
    8000059c:	e45e                	sd	s7,8(sp)
    8000059e:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a0:	c639                	beqz	a2,800005ee <mappages+0x64>
    800005a2:	8aaa                	mv	s5,a0
    800005a4:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005a6:	777d                	lui	a4,0xfffff
    800005a8:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005ac:	fff58993          	add	s3,a1,-1
    800005b0:	99b2                	add	s3,s3,a2
    800005b2:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005b6:	893e                	mv	s2,a5
    800005b8:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005bc:	6b85                	lui	s7,0x1
    800005be:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c2:	4605                	li	a2,1
    800005c4:	85ca                	mv	a1,s2
    800005c6:	8556                	mv	a0,s5
    800005c8:	00000097          	auipc	ra,0x0
    800005cc:	eda080e7          	jalr	-294(ra) # 800004a2 <walk>
    800005d0:	cd1d                	beqz	a0,8000060e <mappages+0x84>
    if(*pte & PTE_V)
    800005d2:	611c                	ld	a5,0(a0)
    800005d4:	8b85                	and	a5,a5,1
    800005d6:	e785                	bnez	a5,800005fe <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005d8:	80b1                	srl	s1,s1,0xc
    800005da:	04aa                	sll	s1,s1,0xa
    800005dc:	0164e4b3          	or	s1,s1,s6
    800005e0:	0014e493          	or	s1,s1,1
    800005e4:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e6:	05390063          	beq	s2,s3,80000626 <mappages+0x9c>
    a += PGSIZE;
    800005ea:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ec:	bfc9                	j	800005be <mappages+0x34>
    panic("mappages: size");
    800005ee:	00008517          	auipc	a0,0x8
    800005f2:	a6a50513          	add	a0,a0,-1430 # 80008058 <etext+0x58>
    800005f6:	00005097          	auipc	ra,0x5
    800005fa:	604080e7          	jalr	1540(ra) # 80005bfa <panic>
      panic("mappages: remap");
    800005fe:	00008517          	auipc	a0,0x8
    80000602:	a6a50513          	add	a0,a0,-1430 # 80008068 <etext+0x68>
    80000606:	00005097          	auipc	ra,0x5
    8000060a:	5f4080e7          	jalr	1524(ra) # 80005bfa <panic>
      return -1;
    8000060e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000610:	60a6                	ld	ra,72(sp)
    80000612:	6406                	ld	s0,64(sp)
    80000614:	74e2                	ld	s1,56(sp)
    80000616:	7942                	ld	s2,48(sp)
    80000618:	79a2                	ld	s3,40(sp)
    8000061a:	7a02                	ld	s4,32(sp)
    8000061c:	6ae2                	ld	s5,24(sp)
    8000061e:	6b42                	ld	s6,16(sp)
    80000620:	6ba2                	ld	s7,8(sp)
    80000622:	6161                	add	sp,sp,80
    80000624:	8082                	ret
  return 0;
    80000626:	4501                	li	a0,0
    80000628:	b7e5                	j	80000610 <mappages+0x86>

000000008000062a <kvmmap>:
{
    8000062a:	1141                	add	sp,sp,-16
    8000062c:	e406                	sd	ra,8(sp)
    8000062e:	e022                	sd	s0,0(sp)
    80000630:	0800                	add	s0,sp,16
    80000632:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000634:	86b2                	mv	a3,a2
    80000636:	863e                	mv	a2,a5
    80000638:	00000097          	auipc	ra,0x0
    8000063c:	f52080e7          	jalr	-174(ra) # 8000058a <mappages>
    80000640:	e509                	bnez	a0,8000064a <kvmmap+0x20>
}
    80000642:	60a2                	ld	ra,8(sp)
    80000644:	6402                	ld	s0,0(sp)
    80000646:	0141                	add	sp,sp,16
    80000648:	8082                	ret
    panic("kvmmap");
    8000064a:	00008517          	auipc	a0,0x8
    8000064e:	a2e50513          	add	a0,a0,-1490 # 80008078 <etext+0x78>
    80000652:	00005097          	auipc	ra,0x5
    80000656:	5a8080e7          	jalr	1448(ra) # 80005bfa <panic>

000000008000065a <kvmmake>:
{
    8000065a:	1101                	add	sp,sp,-32
    8000065c:	ec06                	sd	ra,24(sp)
    8000065e:	e822                	sd	s0,16(sp)
    80000660:	e426                	sd	s1,8(sp)
    80000662:	e04a                	sd	s2,0(sp)
    80000664:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	ab4080e7          	jalr	-1356(ra) # 8000011a <kalloc>
    8000066e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000670:	6605                	lui	a2,0x1
    80000672:	4581                	li	a1,0
    80000674:	00000097          	auipc	ra,0x0
    80000678:	b50080e7          	jalr	-1200(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000067c:	4719                	li	a4,6
    8000067e:	6685                	lui	a3,0x1
    80000680:	10000637          	lui	a2,0x10000
    80000684:	100005b7          	lui	a1,0x10000
    80000688:	8526                	mv	a0,s1
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	fa0080e7          	jalr	-96(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000692:	4719                	li	a4,6
    80000694:	6685                	lui	a3,0x1
    80000696:	10001637          	lui	a2,0x10001
    8000069a:	100015b7          	lui	a1,0x10001
    8000069e:	8526                	mv	a0,s1
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	f8a080e7          	jalr	-118(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a8:	4719                	li	a4,6
    800006aa:	004006b7          	lui	a3,0x400
    800006ae:	0c000637          	lui	a2,0xc000
    800006b2:	0c0005b7          	lui	a1,0xc000
    800006b6:	8526                	mv	a0,s1
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	f72080e7          	jalr	-142(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c0:	00008917          	auipc	s2,0x8
    800006c4:	94090913          	add	s2,s2,-1728 # 80008000 <etext>
    800006c8:	4729                	li	a4,10
    800006ca:	80008697          	auipc	a3,0x80008
    800006ce:	93668693          	add	a3,a3,-1738 # 8000 <_entry-0x7fff8000>
    800006d2:	4605                	li	a2,1
    800006d4:	067e                	sll	a2,a2,0x1f
    800006d6:	85b2                	mv	a1,a2
    800006d8:	8526                	mv	a0,s1
    800006da:	00000097          	auipc	ra,0x0
    800006de:	f50080e7          	jalr	-176(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e2:	4719                	li	a4,6
    800006e4:	46c5                	li	a3,17
    800006e6:	06ee                	sll	a3,a3,0x1b
    800006e8:	412686b3          	sub	a3,a3,s2
    800006ec:	864a                	mv	a2,s2
    800006ee:	85ca                	mv	a1,s2
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f38080e7          	jalr	-200(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fa:	4729                	li	a4,10
    800006fc:	6685                	lui	a3,0x1
    800006fe:	00007617          	auipc	a2,0x7
    80000702:	90260613          	add	a2,a2,-1790 # 80007000 <_trampoline>
    80000706:	040005b7          	lui	a1,0x4000
    8000070a:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000070c:	05b2                	sll	a1,a1,0xc
    8000070e:	8526                	mv	a0,s1
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f1a080e7          	jalr	-230(ra) # 8000062a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000718:	8526                	mv	a0,s1
    8000071a:	00000097          	auipc	ra,0x0
    8000071e:	600080e7          	jalr	1536(ra) # 80000d1a <proc_mapstacks>
}
    80000722:	8526                	mv	a0,s1
    80000724:	60e2                	ld	ra,24(sp)
    80000726:	6442                	ld	s0,16(sp)
    80000728:	64a2                	ld	s1,8(sp)
    8000072a:	6902                	ld	s2,0(sp)
    8000072c:	6105                	add	sp,sp,32
    8000072e:	8082                	ret

0000000080000730 <kvminit>:
{
    80000730:	1141                	add	sp,sp,-16
    80000732:	e406                	sd	ra,8(sp)
    80000734:	e022                	sd	s0,0(sp)
    80000736:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	f22080e7          	jalr	-222(ra) # 8000065a <kvmmake>
    80000740:	00009797          	auipc	a5,0x9
    80000744:	8ca7b423          	sd	a0,-1848(a5) # 80009008 <kernel_pagetable>
}
    80000748:	60a2                	ld	ra,8(sp)
    8000074a:	6402                	ld	s0,0(sp)
    8000074c:	0141                	add	sp,sp,16
    8000074e:	8082                	ret

0000000080000750 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000750:	715d                	add	sp,sp,-80
    80000752:	e486                	sd	ra,72(sp)
    80000754:	e0a2                	sd	s0,64(sp)
    80000756:	fc26                	sd	s1,56(sp)
    80000758:	f84a                	sd	s2,48(sp)
    8000075a:	f44e                	sd	s3,40(sp)
    8000075c:	f052                	sd	s4,32(sp)
    8000075e:	ec56                	sd	s5,24(sp)
    80000760:	e85a                	sd	s6,16(sp)
    80000762:	e45e                	sd	s7,8(sp)
    80000764:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000766:	03459793          	sll	a5,a1,0x34
    8000076a:	e795                	bnez	a5,80000796 <uvmunmap+0x46>
    8000076c:	8a2a                	mv	s4,a0
    8000076e:	892e                	mv	s2,a1
    80000770:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000772:	0632                	sll	a2,a2,0xc
    80000774:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000778:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	6b05                	lui	s6,0x1
    8000077c:	0735e263          	bltu	a1,s3,800007e0 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000780:	60a6                	ld	ra,72(sp)
    80000782:	6406                	ld	s0,64(sp)
    80000784:	74e2                	ld	s1,56(sp)
    80000786:	7942                	ld	s2,48(sp)
    80000788:	79a2                	ld	s3,40(sp)
    8000078a:	7a02                	ld	s4,32(sp)
    8000078c:	6ae2                	ld	s5,24(sp)
    8000078e:	6b42                	ld	s6,16(sp)
    80000790:	6ba2                	ld	s7,8(sp)
    80000792:	6161                	add	sp,sp,80
    80000794:	8082                	ret
    panic("uvmunmap: not aligned");
    80000796:	00008517          	auipc	a0,0x8
    8000079a:	8ea50513          	add	a0,a0,-1814 # 80008080 <etext+0x80>
    8000079e:	00005097          	auipc	ra,0x5
    800007a2:	45c080e7          	jalr	1116(ra) # 80005bfa <panic>
      panic("uvmunmap: walk");
    800007a6:	00008517          	auipc	a0,0x8
    800007aa:	8f250513          	add	a0,a0,-1806 # 80008098 <etext+0x98>
    800007ae:	00005097          	auipc	ra,0x5
    800007b2:	44c080e7          	jalr	1100(ra) # 80005bfa <panic>
      panic("uvmunmap: not mapped");
    800007b6:	00008517          	auipc	a0,0x8
    800007ba:	8f250513          	add	a0,a0,-1806 # 800080a8 <etext+0xa8>
    800007be:	00005097          	auipc	ra,0x5
    800007c2:	43c080e7          	jalr	1084(ra) # 80005bfa <panic>
      panic("uvmunmap: not a leaf");
    800007c6:	00008517          	auipc	a0,0x8
    800007ca:	8fa50513          	add	a0,a0,-1798 # 800080c0 <etext+0xc0>
    800007ce:	00005097          	auipc	ra,0x5
    800007d2:	42c080e7          	jalr	1068(ra) # 80005bfa <panic>
    *pte = 0;
    800007d6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007da:	995a                	add	s2,s2,s6
    800007dc:	fb3972e3          	bgeu	s2,s3,80000780 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e0:	4601                	li	a2,0
    800007e2:	85ca                	mv	a1,s2
    800007e4:	8552                	mv	a0,s4
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	cbc080e7          	jalr	-836(ra) # 800004a2 <walk>
    800007ee:	84aa                	mv	s1,a0
    800007f0:	d95d                	beqz	a0,800007a6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007f2:	6108                	ld	a0,0(a0)
    800007f4:	00157793          	and	a5,a0,1
    800007f8:	dfdd                	beqz	a5,800007b6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007fa:	3ff57793          	and	a5,a0,1023
    800007fe:	fd7784e3          	beq	a5,s7,800007c6 <uvmunmap+0x76>
    if(do_free){
    80000802:	fc0a8ae3          	beqz	s5,800007d6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000806:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80000808:	0532                	sll	a0,a0,0xc
    8000080a:	00000097          	auipc	ra,0x0
    8000080e:	812080e7          	jalr	-2030(ra) # 8000001c <kfree>
    80000812:	b7d1                	j	800007d6 <uvmunmap+0x86>

0000000080000814 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000814:	1101                	add	sp,sp,-32
    80000816:	ec06                	sd	ra,24(sp)
    80000818:	e822                	sd	s0,16(sp)
    8000081a:	e426                	sd	s1,8(sp)
    8000081c:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	8fc080e7          	jalr	-1796(ra) # 8000011a <kalloc>
    80000826:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000828:	c519                	beqz	a0,80000836 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	996080e7          	jalr	-1642(ra) # 800001c4 <memset>
  return pagetable;
}
    80000836:	8526                	mv	a0,s1
    80000838:	60e2                	ld	ra,24(sp)
    8000083a:	6442                	ld	s0,16(sp)
    8000083c:	64a2                	ld	s1,8(sp)
    8000083e:	6105                	add	sp,sp,32
    80000840:	8082                	ret

0000000080000842 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000842:	7179                	add	sp,sp,-48
    80000844:	f406                	sd	ra,40(sp)
    80000846:	f022                	sd	s0,32(sp)
    80000848:	ec26                	sd	s1,24(sp)
    8000084a:	e84a                	sd	s2,16(sp)
    8000084c:	e44e                	sd	s3,8(sp)
    8000084e:	e052                	sd	s4,0(sp)
    80000850:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000852:	6785                	lui	a5,0x1
    80000854:	04f67863          	bgeu	a2,a5,800008a4 <uvminit+0x62>
    80000858:	8a2a                	mv	s4,a0
    8000085a:	89ae                	mv	s3,a1
    8000085c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	8bc080e7          	jalr	-1860(ra) # 8000011a <kalloc>
    80000866:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000868:	6605                	lui	a2,0x1
    8000086a:	4581                	li	a1,0
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	958080e7          	jalr	-1704(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000874:	4779                	li	a4,30
    80000876:	86ca                	mv	a3,s2
    80000878:	6605                	lui	a2,0x1
    8000087a:	4581                	li	a1,0
    8000087c:	8552                	mv	a0,s4
    8000087e:	00000097          	auipc	ra,0x0
    80000882:	d0c080e7          	jalr	-756(ra) # 8000058a <mappages>
  memmove(mem, src, sz);
    80000886:	8626                	mv	a2,s1
    80000888:	85ce                	mv	a1,s3
    8000088a:	854a                	mv	a0,s2
    8000088c:	00000097          	auipc	ra,0x0
    80000890:	994080e7          	jalr	-1644(ra) # 80000220 <memmove>
}
    80000894:	70a2                	ld	ra,40(sp)
    80000896:	7402                	ld	s0,32(sp)
    80000898:	64e2                	ld	s1,24(sp)
    8000089a:	6942                	ld	s2,16(sp)
    8000089c:	69a2                	ld	s3,8(sp)
    8000089e:	6a02                	ld	s4,0(sp)
    800008a0:	6145                	add	sp,sp,48
    800008a2:	8082                	ret
    panic("inituvm: more than a page");
    800008a4:	00008517          	auipc	a0,0x8
    800008a8:	83450513          	add	a0,a0,-1996 # 800080d8 <etext+0xd8>
    800008ac:	00005097          	auipc	ra,0x5
    800008b0:	34e080e7          	jalr	846(ra) # 80005bfa <panic>

00000000800008b4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008b4:	1101                	add	sp,sp,-32
    800008b6:	ec06                	sd	ra,24(sp)
    800008b8:	e822                	sd	s0,16(sp)
    800008ba:	e426                	sd	s1,8(sp)
    800008bc:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008be:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c0:	00b67d63          	bgeu	a2,a1,800008da <uvmdealloc+0x26>
    800008c4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008c6:	6785                	lui	a5,0x1
    800008c8:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ca:	00f60733          	add	a4,a2,a5
    800008ce:	76fd                	lui	a3,0xfffff
    800008d0:	8f75                	and	a4,a4,a3
    800008d2:	97ae                	add	a5,a5,a1
    800008d4:	8ff5                	and	a5,a5,a3
    800008d6:	00f76863          	bltu	a4,a5,800008e6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008da:	8526                	mv	a0,s1
    800008dc:	60e2                	ld	ra,24(sp)
    800008de:	6442                	ld	s0,16(sp)
    800008e0:	64a2                	ld	s1,8(sp)
    800008e2:	6105                	add	sp,sp,32
    800008e4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008e6:	8f99                	sub	a5,a5,a4
    800008e8:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ea:	4685                	li	a3,1
    800008ec:	0007861b          	sext.w	a2,a5
    800008f0:	85ba                	mv	a1,a4
    800008f2:	00000097          	auipc	ra,0x0
    800008f6:	e5e080e7          	jalr	-418(ra) # 80000750 <uvmunmap>
    800008fa:	b7c5                	j	800008da <uvmdealloc+0x26>

00000000800008fc <uvmalloc>:
  if(newsz < oldsz)
    800008fc:	0ab66163          	bltu	a2,a1,8000099e <uvmalloc+0xa2>
{
    80000900:	7139                	add	sp,sp,-64
    80000902:	fc06                	sd	ra,56(sp)
    80000904:	f822                	sd	s0,48(sp)
    80000906:	f426                	sd	s1,40(sp)
    80000908:	f04a                	sd	s2,32(sp)
    8000090a:	ec4e                	sd	s3,24(sp)
    8000090c:	e852                	sd	s4,16(sp)
    8000090e:	e456                	sd	s5,8(sp)
    80000910:	0080                	add	s0,sp,64
    80000912:	8aaa                	mv	s5,a0
    80000914:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000916:	6785                	lui	a5,0x1
    80000918:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000091a:	95be                	add	a1,a1,a5
    8000091c:	77fd                	lui	a5,0xfffff
    8000091e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000922:	08c9f063          	bgeu	s3,a2,800009a2 <uvmalloc+0xa6>
    80000926:	894e                	mv	s2,s3
    mem = kalloc();
    80000928:	fffff097          	auipc	ra,0xfffff
    8000092c:	7f2080e7          	jalr	2034(ra) # 8000011a <kalloc>
    80000930:	84aa                	mv	s1,a0
    if(mem == 0){
    80000932:	c51d                	beqz	a0,80000960 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000934:	6605                	lui	a2,0x1
    80000936:	4581                	li	a1,0
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	88c080e7          	jalr	-1908(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000940:	4779                	li	a4,30
    80000942:	86a6                	mv	a3,s1
    80000944:	6605                	lui	a2,0x1
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	c40080e7          	jalr	-960(ra) # 8000058a <mappages>
    80000952:	e905                	bnez	a0,80000982 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000954:	6785                	lui	a5,0x1
    80000956:	993e                	add	s2,s2,a5
    80000958:	fd4968e3          	bltu	s2,s4,80000928 <uvmalloc+0x2c>
  return newsz;
    8000095c:	8552                	mv	a0,s4
    8000095e:	a809                	j	80000970 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000960:	864e                	mv	a2,s3
    80000962:	85ca                	mv	a1,s2
    80000964:	8556                	mv	a0,s5
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	f4e080e7          	jalr	-178(ra) # 800008b4 <uvmdealloc>
      return 0;
    8000096e:	4501                	li	a0,0
}
    80000970:	70e2                	ld	ra,56(sp)
    80000972:	7442                	ld	s0,48(sp)
    80000974:	74a2                	ld	s1,40(sp)
    80000976:	7902                	ld	s2,32(sp)
    80000978:	69e2                	ld	s3,24(sp)
    8000097a:	6a42                	ld	s4,16(sp)
    8000097c:	6aa2                	ld	s5,8(sp)
    8000097e:	6121                	add	sp,sp,64
    80000980:	8082                	ret
      kfree(mem);
    80000982:	8526                	mv	a0,s1
    80000984:	fffff097          	auipc	ra,0xfffff
    80000988:	698080e7          	jalr	1688(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000098c:	864e                	mv	a2,s3
    8000098e:	85ca                	mv	a1,s2
    80000990:	8556                	mv	a0,s5
    80000992:	00000097          	auipc	ra,0x0
    80000996:	f22080e7          	jalr	-222(ra) # 800008b4 <uvmdealloc>
      return 0;
    8000099a:	4501                	li	a0,0
    8000099c:	bfd1                	j	80000970 <uvmalloc+0x74>
    return oldsz;
    8000099e:	852e                	mv	a0,a1
}
    800009a0:	8082                	ret
  return newsz;
    800009a2:	8532                	mv	a0,a2
    800009a4:	b7f1                	j	80000970 <uvmalloc+0x74>

00000000800009a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a6:	7179                	add	sp,sp,-48
    800009a8:	f406                	sd	ra,40(sp)
    800009aa:	f022                	sd	s0,32(sp)
    800009ac:	ec26                	sd	s1,24(sp)
    800009ae:	e84a                	sd	s2,16(sp)
    800009b0:	e44e                	sd	s3,8(sp)
    800009b2:	e052                	sd	s4,0(sp)
    800009b4:	1800                	add	s0,sp,48
    800009b6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009b8:	84aa                	mv	s1,a0
    800009ba:	6905                	lui	s2,0x1
    800009bc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009be:	4985                	li	s3,1
    800009c0:	a829                	j	800009da <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009c2:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c4:	00c79513          	sll	a0,a5,0xc
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	fde080e7          	jalr	-34(ra) # 800009a6 <freewalk>
      pagetable[i] = 0;
    800009d0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009d4:	04a1                	add	s1,s1,8
    800009d6:	03248163          	beq	s1,s2,800009f8 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009da:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009dc:	00f7f713          	and	a4,a5,15
    800009e0:	ff3701e3          	beq	a4,s3,800009c2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009e4:	8b85                	and	a5,a5,1
    800009e6:	d7fd                	beqz	a5,800009d4 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009e8:	00007517          	auipc	a0,0x7
    800009ec:	71050513          	add	a0,a0,1808 # 800080f8 <etext+0xf8>
    800009f0:	00005097          	auipc	ra,0x5
    800009f4:	20a080e7          	jalr	522(ra) # 80005bfa <panic>
    }
  }
  kfree((void*)pagetable);
    800009f8:	8552                	mv	a0,s4
    800009fa:	fffff097          	auipc	ra,0xfffff
    800009fe:	622080e7          	jalr	1570(ra) # 8000001c <kfree>
}
    80000a02:	70a2                	ld	ra,40(sp)
    80000a04:	7402                	ld	s0,32(sp)
    80000a06:	64e2                	ld	s1,24(sp)
    80000a08:	6942                	ld	s2,16(sp)
    80000a0a:	69a2                	ld	s3,8(sp)
    80000a0c:	6a02                	ld	s4,0(sp)
    80000a0e:	6145                	add	sp,sp,48
    80000a10:	8082                	ret

0000000080000a12 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a12:	1101                	add	sp,sp,-32
    80000a14:	ec06                	sd	ra,24(sp)
    80000a16:	e822                	sd	s0,16(sp)
    80000a18:	e426                	sd	s1,8(sp)
    80000a1a:	1000                	add	s0,sp,32
    80000a1c:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a1e:	e999                	bnez	a1,80000a34 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a20:	8526                	mv	a0,s1
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	f84080e7          	jalr	-124(ra) # 800009a6 <freewalk>
}
    80000a2a:	60e2                	ld	ra,24(sp)
    80000a2c:	6442                	ld	s0,16(sp)
    80000a2e:	64a2                	ld	s1,8(sp)
    80000a30:	6105                	add	sp,sp,32
    80000a32:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a34:	6785                	lui	a5,0x1
    80000a36:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a38:	95be                	add	a1,a1,a5
    80000a3a:	4685                	li	a3,1
    80000a3c:	00c5d613          	srl	a2,a1,0xc
    80000a40:	4581                	li	a1,0
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	d0e080e7          	jalr	-754(ra) # 80000750 <uvmunmap>
    80000a4a:	bfd9                	j	80000a20 <uvmfree+0xe>

0000000080000a4c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a4c:	c679                	beqz	a2,80000b1a <uvmcopy+0xce>
{
    80000a4e:	715d                	add	sp,sp,-80
    80000a50:	e486                	sd	ra,72(sp)
    80000a52:	e0a2                	sd	s0,64(sp)
    80000a54:	fc26                	sd	s1,56(sp)
    80000a56:	f84a                	sd	s2,48(sp)
    80000a58:	f44e                	sd	s3,40(sp)
    80000a5a:	f052                	sd	s4,32(sp)
    80000a5c:	ec56                	sd	s5,24(sp)
    80000a5e:	e85a                	sd	s6,16(sp)
    80000a60:	e45e                	sd	s7,8(sp)
    80000a62:	0880                	add	s0,sp,80
    80000a64:	8b2a                	mv	s6,a0
    80000a66:	8aae                	mv	s5,a1
    80000a68:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a6c:	4601                	li	a2,0
    80000a6e:	85ce                	mv	a1,s3
    80000a70:	855a                	mv	a0,s6
    80000a72:	00000097          	auipc	ra,0x0
    80000a76:	a30080e7          	jalr	-1488(ra) # 800004a2 <walk>
    80000a7a:	c531                	beqz	a0,80000ac6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a7c:	6118                	ld	a4,0(a0)
    80000a7e:	00177793          	and	a5,a4,1
    80000a82:	cbb1                	beqz	a5,80000ad6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a84:	00a75593          	srl	a1,a4,0xa
    80000a88:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a8c:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a90:	fffff097          	auipc	ra,0xfffff
    80000a94:	68a080e7          	jalr	1674(ra) # 8000011a <kalloc>
    80000a98:	892a                	mv	s2,a0
    80000a9a:	c939                	beqz	a0,80000af0 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a9c:	6605                	lui	a2,0x1
    80000a9e:	85de                	mv	a1,s7
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	780080e7          	jalr	1920(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aa8:	8726                	mv	a4,s1
    80000aaa:	86ca                	mv	a3,s2
    80000aac:	6605                	lui	a2,0x1
    80000aae:	85ce                	mv	a1,s3
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	ad8080e7          	jalr	-1320(ra) # 8000058a <mappages>
    80000aba:	e515                	bnez	a0,80000ae6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000abc:	6785                	lui	a5,0x1
    80000abe:	99be                	add	s3,s3,a5
    80000ac0:	fb49e6e3          	bltu	s3,s4,80000a6c <uvmcopy+0x20>
    80000ac4:	a081                	j	80000b04 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac6:	00007517          	auipc	a0,0x7
    80000aca:	64250513          	add	a0,a0,1602 # 80008108 <etext+0x108>
    80000ace:	00005097          	auipc	ra,0x5
    80000ad2:	12c080e7          	jalr	300(ra) # 80005bfa <panic>
      panic("uvmcopy: page not present");
    80000ad6:	00007517          	auipc	a0,0x7
    80000ada:	65250513          	add	a0,a0,1618 # 80008128 <etext+0x128>
    80000ade:	00005097          	auipc	ra,0x5
    80000ae2:	11c080e7          	jalr	284(ra) # 80005bfa <panic>
      kfree(mem);
    80000ae6:	854a                	mv	a0,s2
    80000ae8:	fffff097          	auipc	ra,0xfffff
    80000aec:	534080e7          	jalr	1332(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af0:	4685                	li	a3,1
    80000af2:	00c9d613          	srl	a2,s3,0xc
    80000af6:	4581                	li	a1,0
    80000af8:	8556                	mv	a0,s5
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	c56080e7          	jalr	-938(ra) # 80000750 <uvmunmap>
  return -1;
    80000b02:	557d                	li	a0,-1
}
    80000b04:	60a6                	ld	ra,72(sp)
    80000b06:	6406                	ld	s0,64(sp)
    80000b08:	74e2                	ld	s1,56(sp)
    80000b0a:	7942                	ld	s2,48(sp)
    80000b0c:	79a2                	ld	s3,40(sp)
    80000b0e:	7a02                	ld	s4,32(sp)
    80000b10:	6ae2                	ld	s5,24(sp)
    80000b12:	6b42                	ld	s6,16(sp)
    80000b14:	6ba2                	ld	s7,8(sp)
    80000b16:	6161                	add	sp,sp,80
    80000b18:	8082                	ret
  return 0;
    80000b1a:	4501                	li	a0,0
}
    80000b1c:	8082                	ret

0000000080000b1e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b1e:	1141                	add	sp,sp,-16
    80000b20:	e406                	sd	ra,8(sp)
    80000b22:	e022                	sd	s0,0(sp)
    80000b24:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b26:	4601                	li	a2,0
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	97a080e7          	jalr	-1670(ra) # 800004a2 <walk>
  if(pte == 0)
    80000b30:	c901                	beqz	a0,80000b40 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b32:	611c                	ld	a5,0(a0)
    80000b34:	9bbd                	and	a5,a5,-17
    80000b36:	e11c                	sd	a5,0(a0)
}
    80000b38:	60a2                	ld	ra,8(sp)
    80000b3a:	6402                	ld	s0,0(sp)
    80000b3c:	0141                	add	sp,sp,16
    80000b3e:	8082                	ret
    panic("uvmclear");
    80000b40:	00007517          	auipc	a0,0x7
    80000b44:	60850513          	add	a0,a0,1544 # 80008148 <etext+0x148>
    80000b48:	00005097          	auipc	ra,0x5
    80000b4c:	0b2080e7          	jalr	178(ra) # 80005bfa <panic>

0000000080000b50 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b50:	c6bd                	beqz	a3,80000bbe <copyout+0x6e>
{
    80000b52:	715d                	add	sp,sp,-80
    80000b54:	e486                	sd	ra,72(sp)
    80000b56:	e0a2                	sd	s0,64(sp)
    80000b58:	fc26                	sd	s1,56(sp)
    80000b5a:	f84a                	sd	s2,48(sp)
    80000b5c:	f44e                	sd	s3,40(sp)
    80000b5e:	f052                	sd	s4,32(sp)
    80000b60:	ec56                	sd	s5,24(sp)
    80000b62:	e85a                	sd	s6,16(sp)
    80000b64:	e45e                	sd	s7,8(sp)
    80000b66:	e062                	sd	s8,0(sp)
    80000b68:	0880                	add	s0,sp,80
    80000b6a:	8b2a                	mv	s6,a0
    80000b6c:	8c2e                	mv	s8,a1
    80000b6e:	8a32                	mv	s4,a2
    80000b70:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b72:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b74:	6a85                	lui	s5,0x1
    80000b76:	a015                	j	80000b9a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b78:	9562                	add	a0,a0,s8
    80000b7a:	0004861b          	sext.w	a2,s1
    80000b7e:	85d2                	mv	a1,s4
    80000b80:	41250533          	sub	a0,a0,s2
    80000b84:	fffff097          	auipc	ra,0xfffff
    80000b88:	69c080e7          	jalr	1692(ra) # 80000220 <memmove>

    len -= n;
    80000b8c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b90:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b92:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b96:	02098263          	beqz	s3,80000bba <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b9e:	85ca                	mv	a1,s2
    80000ba0:	855a                	mv	a0,s6
    80000ba2:	00000097          	auipc	ra,0x0
    80000ba6:	9a6080e7          	jalr	-1626(ra) # 80000548 <walkaddr>
    if(pa0 == 0)
    80000baa:	cd01                	beqz	a0,80000bc2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bac:	418904b3          	sub	s1,s2,s8
    80000bb0:	94d6                	add	s1,s1,s5
    80000bb2:	fc99f3e3          	bgeu	s3,s1,80000b78 <copyout+0x28>
    80000bb6:	84ce                	mv	s1,s3
    80000bb8:	b7c1                	j	80000b78 <copyout+0x28>
  }
  return 0;
    80000bba:	4501                	li	a0,0
    80000bbc:	a021                	j	80000bc4 <copyout+0x74>
    80000bbe:	4501                	li	a0,0
}
    80000bc0:	8082                	ret
      return -1;
    80000bc2:	557d                	li	a0,-1
}
    80000bc4:	60a6                	ld	ra,72(sp)
    80000bc6:	6406                	ld	s0,64(sp)
    80000bc8:	74e2                	ld	s1,56(sp)
    80000bca:	7942                	ld	s2,48(sp)
    80000bcc:	79a2                	ld	s3,40(sp)
    80000bce:	7a02                	ld	s4,32(sp)
    80000bd0:	6ae2                	ld	s5,24(sp)
    80000bd2:	6b42                	ld	s6,16(sp)
    80000bd4:	6ba2                	ld	s7,8(sp)
    80000bd6:	6c02                	ld	s8,0(sp)
    80000bd8:	6161                	add	sp,sp,80
    80000bda:	8082                	ret

0000000080000bdc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bdc:	caa5                	beqz	a3,80000c4c <copyin+0x70>
{
    80000bde:	715d                	add	sp,sp,-80
    80000be0:	e486                	sd	ra,72(sp)
    80000be2:	e0a2                	sd	s0,64(sp)
    80000be4:	fc26                	sd	s1,56(sp)
    80000be6:	f84a                	sd	s2,48(sp)
    80000be8:	f44e                	sd	s3,40(sp)
    80000bea:	f052                	sd	s4,32(sp)
    80000bec:	ec56                	sd	s5,24(sp)
    80000bee:	e85a                	sd	s6,16(sp)
    80000bf0:	e45e                	sd	s7,8(sp)
    80000bf2:	e062                	sd	s8,0(sp)
    80000bf4:	0880                	add	s0,sp,80
    80000bf6:	8b2a                	mv	s6,a0
    80000bf8:	8a2e                	mv	s4,a1
    80000bfa:	8c32                	mv	s8,a2
    80000bfc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bfe:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c00:	6a85                	lui	s5,0x1
    80000c02:	a01d                	j	80000c28 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c04:	018505b3          	add	a1,a0,s8
    80000c08:	0004861b          	sext.w	a2,s1
    80000c0c:	412585b3          	sub	a1,a1,s2
    80000c10:	8552                	mv	a0,s4
    80000c12:	fffff097          	auipc	ra,0xfffff
    80000c16:	60e080e7          	jalr	1550(ra) # 80000220 <memmove>

    len -= n;
    80000c1a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c1e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c20:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c24:	02098263          	beqz	s3,80000c48 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c28:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2c:	85ca                	mv	a1,s2
    80000c2e:	855a                	mv	a0,s6
    80000c30:	00000097          	auipc	ra,0x0
    80000c34:	918080e7          	jalr	-1768(ra) # 80000548 <walkaddr>
    if(pa0 == 0)
    80000c38:	cd01                	beqz	a0,80000c50 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c3a:	418904b3          	sub	s1,s2,s8
    80000c3e:	94d6                	add	s1,s1,s5
    80000c40:	fc99f2e3          	bgeu	s3,s1,80000c04 <copyin+0x28>
    80000c44:	84ce                	mv	s1,s3
    80000c46:	bf7d                	j	80000c04 <copyin+0x28>
  }
  return 0;
    80000c48:	4501                	li	a0,0
    80000c4a:	a021                	j	80000c52 <copyin+0x76>
    80000c4c:	4501                	li	a0,0
}
    80000c4e:	8082                	ret
      return -1;
    80000c50:	557d                	li	a0,-1
}
    80000c52:	60a6                	ld	ra,72(sp)
    80000c54:	6406                	ld	s0,64(sp)
    80000c56:	74e2                	ld	s1,56(sp)
    80000c58:	7942                	ld	s2,48(sp)
    80000c5a:	79a2                	ld	s3,40(sp)
    80000c5c:	7a02                	ld	s4,32(sp)
    80000c5e:	6ae2                	ld	s5,24(sp)
    80000c60:	6b42                	ld	s6,16(sp)
    80000c62:	6ba2                	ld	s7,8(sp)
    80000c64:	6c02                	ld	s8,0(sp)
    80000c66:	6161                	add	sp,sp,80
    80000c68:	8082                	ret

0000000080000c6a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6a:	c2dd                	beqz	a3,80000d10 <copyinstr+0xa6>
{
    80000c6c:	715d                	add	sp,sp,-80
    80000c6e:	e486                	sd	ra,72(sp)
    80000c70:	e0a2                	sd	s0,64(sp)
    80000c72:	fc26                	sd	s1,56(sp)
    80000c74:	f84a                	sd	s2,48(sp)
    80000c76:	f44e                	sd	s3,40(sp)
    80000c78:	f052                	sd	s4,32(sp)
    80000c7a:	ec56                	sd	s5,24(sp)
    80000c7c:	e85a                	sd	s6,16(sp)
    80000c7e:	e45e                	sd	s7,8(sp)
    80000c80:	0880                	add	s0,sp,80
    80000c82:	8a2a                	mv	s4,a0
    80000c84:	8b2e                	mv	s6,a1
    80000c86:	8bb2                	mv	s7,a2
    80000c88:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8c:	6985                	lui	s3,0x1
    80000c8e:	a02d                	j	80000cb8 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c90:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c94:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c96:	37fd                	addw	a5,a5,-1
    80000c98:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c9c:	60a6                	ld	ra,72(sp)
    80000c9e:	6406                	ld	s0,64(sp)
    80000ca0:	74e2                	ld	s1,56(sp)
    80000ca2:	7942                	ld	s2,48(sp)
    80000ca4:	79a2                	ld	s3,40(sp)
    80000ca6:	7a02                	ld	s4,32(sp)
    80000ca8:	6ae2                	ld	s5,24(sp)
    80000caa:	6b42                	ld	s6,16(sp)
    80000cac:	6ba2                	ld	s7,8(sp)
    80000cae:	6161                	add	sp,sp,80
    80000cb0:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb2:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cb6:	c8a9                	beqz	s1,80000d08 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cb8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cbc:	85ca                	mv	a1,s2
    80000cbe:	8552                	mv	a0,s4
    80000cc0:	00000097          	auipc	ra,0x0
    80000cc4:	888080e7          	jalr	-1912(ra) # 80000548 <walkaddr>
    if(pa0 == 0)
    80000cc8:	c131                	beqz	a0,80000d0c <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000cca:	417906b3          	sub	a3,s2,s7
    80000cce:	96ce                	add	a3,a3,s3
    80000cd0:	00d4f363          	bgeu	s1,a3,80000cd6 <copyinstr+0x6c>
    80000cd4:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cd6:	955e                	add	a0,a0,s7
    80000cd8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cdc:	daf9                	beqz	a3,80000cb2 <copyinstr+0x48>
    80000cde:	87da                	mv	a5,s6
    80000ce0:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ce2:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ce6:	96da                	add	a3,a3,s6
    80000ce8:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cea:	00f60733          	add	a4,a2,a5
    80000cee:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cf2:	df59                	beqz	a4,80000c90 <copyinstr+0x26>
        *dst = *p;
    80000cf4:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cf8:	0785                	add	a5,a5,1
    while(n > 0){
    80000cfa:	fed797e3          	bne	a5,a3,80000ce8 <copyinstr+0x7e>
    80000cfe:	14fd                	add	s1,s1,-1
    80000d00:	94c2                	add	s1,s1,a6
      --max;
    80000d02:	8c8d                	sub	s1,s1,a1
      dst++;
    80000d04:	8b3e                	mv	s6,a5
    80000d06:	b775                	j	80000cb2 <copyinstr+0x48>
    80000d08:	4781                	li	a5,0
    80000d0a:	b771                	j	80000c96 <copyinstr+0x2c>
      return -1;
    80000d0c:	557d                	li	a0,-1
    80000d0e:	b779                	j	80000c9c <copyinstr+0x32>
  int got_null = 0;
    80000d10:	4781                	li	a5,0
  if(got_null){
    80000d12:	37fd                	addw	a5,a5,-1
    80000d14:	0007851b          	sext.w	a0,a5
}
    80000d18:	8082                	ret

0000000080000d1a <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d1a:	7139                	add	sp,sp,-64
    80000d1c:	fc06                	sd	ra,56(sp)
    80000d1e:	f822                	sd	s0,48(sp)
    80000d20:	f426                	sd	s1,40(sp)
    80000d22:	f04a                	sd	s2,32(sp)
    80000d24:	ec4e                	sd	s3,24(sp)
    80000d26:	e852                	sd	s4,16(sp)
    80000d28:	e456                	sd	s5,8(sp)
    80000d2a:	e05a                	sd	s6,0(sp)
    80000d2c:	0080                	add	s0,sp,64
    80000d2e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	00008497          	auipc	s1,0x8
    80000d34:	75048493          	add	s1,s1,1872 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d38:	8b26                	mv	s6,s1
    80000d3a:	00007a97          	auipc	s5,0x7
    80000d3e:	2c6a8a93          	add	s5,s5,710 # 80008000 <etext>
    80000d42:	04000937          	lui	s2,0x4000
    80000d46:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d48:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4a:	0000ea17          	auipc	s4,0xe
    80000d4e:	136a0a13          	add	s4,s4,310 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d52:	fffff097          	auipc	ra,0xfffff
    80000d56:	3c8080e7          	jalr	968(ra) # 8000011a <kalloc>
    80000d5a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d5c:	c131                	beqz	a0,80000da0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d5e:	416485b3          	sub	a1,s1,s6
    80000d62:	858d                	sra	a1,a1,0x3
    80000d64:	000ab783          	ld	a5,0(s5)
    80000d68:	02f585b3          	mul	a1,a1,a5
    80000d6c:	2585                	addw	a1,a1,1
    80000d6e:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d72:	4719                	li	a4,6
    80000d74:	6685                	lui	a3,0x1
    80000d76:	40b905b3          	sub	a1,s2,a1
    80000d7a:	854e                	mv	a0,s3
    80000d7c:	00000097          	auipc	ra,0x0
    80000d80:	8ae080e7          	jalr	-1874(ra) # 8000062a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d84:	16848493          	add	s1,s1,360
    80000d88:	fd4495e3          	bne	s1,s4,80000d52 <proc_mapstacks+0x38>
  }
}
    80000d8c:	70e2                	ld	ra,56(sp)
    80000d8e:	7442                	ld	s0,48(sp)
    80000d90:	74a2                	ld	s1,40(sp)
    80000d92:	7902                	ld	s2,32(sp)
    80000d94:	69e2                	ld	s3,24(sp)
    80000d96:	6a42                	ld	s4,16(sp)
    80000d98:	6aa2                	ld	s5,8(sp)
    80000d9a:	6b02                	ld	s6,0(sp)
    80000d9c:	6121                	add	sp,sp,64
    80000d9e:	8082                	ret
      panic("kalloc");
    80000da0:	00007517          	auipc	a0,0x7
    80000da4:	3b850513          	add	a0,a0,952 # 80008158 <etext+0x158>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	e52080e7          	jalr	-430(ra) # 80005bfa <panic>

0000000080000db0 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db0:	7139                	add	sp,sp,-64
    80000db2:	fc06                	sd	ra,56(sp)
    80000db4:	f822                	sd	s0,48(sp)
    80000db6:	f426                	sd	s1,40(sp)
    80000db8:	f04a                	sd	s2,32(sp)
    80000dba:	ec4e                	sd	s3,24(sp)
    80000dbc:	e852                	sd	s4,16(sp)
    80000dbe:	e456                	sd	s5,8(sp)
    80000dc0:	e05a                	sd	s6,0(sp)
    80000dc2:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dc4:	00007597          	auipc	a1,0x7
    80000dc8:	39c58593          	add	a1,a1,924 # 80008160 <etext+0x160>
    80000dcc:	00008517          	auipc	a0,0x8
    80000dd0:	28450513          	add	a0,a0,644 # 80009050 <pid_lock>
    80000dd4:	00005097          	auipc	ra,0x5
    80000dd8:	2ce080e7          	jalr	718(ra) # 800060a2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ddc:	00007597          	auipc	a1,0x7
    80000de0:	38c58593          	add	a1,a1,908 # 80008168 <etext+0x168>
    80000de4:	00008517          	auipc	a0,0x8
    80000de8:	28450513          	add	a0,a0,644 # 80009068 <wait_lock>
    80000dec:	00005097          	auipc	ra,0x5
    80000df0:	2b6080e7          	jalr	694(ra) # 800060a2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df4:	00008497          	auipc	s1,0x8
    80000df8:	68c48493          	add	s1,s1,1676 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dfc:	00007b17          	auipc	s6,0x7
    80000e00:	37cb0b13          	add	s6,s6,892 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e04:	8aa6                	mv	s5,s1
    80000e06:	00007a17          	auipc	s4,0x7
    80000e0a:	1faa0a13          	add	s4,s4,506 # 80008000 <etext>
    80000e0e:	04000937          	lui	s2,0x4000
    80000e12:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e14:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e16:	0000e997          	auipc	s3,0xe
    80000e1a:	06a98993          	add	s3,s3,106 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000e1e:	85da                	mv	a1,s6
    80000e20:	8526                	mv	a0,s1
    80000e22:	00005097          	auipc	ra,0x5
    80000e26:	280080e7          	jalr	640(ra) # 800060a2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e2a:	415487b3          	sub	a5,s1,s5
    80000e2e:	878d                	sra	a5,a5,0x3
    80000e30:	000a3703          	ld	a4,0(s4)
    80000e34:	02e787b3          	mul	a5,a5,a4
    80000e38:	2785                	addw	a5,a5,1
    80000e3a:	00d7979b          	sllw	a5,a5,0xd
    80000e3e:	40f907b3          	sub	a5,s2,a5
    80000e42:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e44:	16848493          	add	s1,s1,360
    80000e48:	fd349be3          	bne	s1,s3,80000e1e <procinit+0x6e>
  }
}
    80000e4c:	70e2                	ld	ra,56(sp)
    80000e4e:	7442                	ld	s0,48(sp)
    80000e50:	74a2                	ld	s1,40(sp)
    80000e52:	7902                	ld	s2,32(sp)
    80000e54:	69e2                	ld	s3,24(sp)
    80000e56:	6a42                	ld	s4,16(sp)
    80000e58:	6aa2                	ld	s5,8(sp)
    80000e5a:	6b02                	ld	s6,0(sp)
    80000e5c:	6121                	add	sp,sp,64
    80000e5e:	8082                	ret

0000000080000e60 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e60:	1141                	add	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e66:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e68:	2501                	sext.w	a0,a0
    80000e6a:	6422                	ld	s0,8(sp)
    80000e6c:	0141                	add	sp,sp,16
    80000e6e:	8082                	ret

0000000080000e70 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e70:	1141                	add	sp,sp,-16
    80000e72:	e422                	sd	s0,8(sp)
    80000e74:	0800                	add	s0,sp,16
    80000e76:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e78:	2781                	sext.w	a5,a5
    80000e7a:	079e                	sll	a5,a5,0x7
  return c;
}
    80000e7c:	00008517          	auipc	a0,0x8
    80000e80:	20450513          	add	a0,a0,516 # 80009080 <cpus>
    80000e84:	953e                	add	a0,a0,a5
    80000e86:	6422                	ld	s0,8(sp)
    80000e88:	0141                	add	sp,sp,16
    80000e8a:	8082                	ret

0000000080000e8c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e8c:	1101                	add	sp,sp,-32
    80000e8e:	ec06                	sd	ra,24(sp)
    80000e90:	e822                	sd	s0,16(sp)
    80000e92:	e426                	sd	s1,8(sp)
    80000e94:	1000                	add	s0,sp,32
  push_off();
    80000e96:	00005097          	auipc	ra,0x5
    80000e9a:	250080e7          	jalr	592(ra) # 800060e6 <push_off>
    80000e9e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea0:	2781                	sext.w	a5,a5
    80000ea2:	079e                	sll	a5,a5,0x7
    80000ea4:	00008717          	auipc	a4,0x8
    80000ea8:	1ac70713          	add	a4,a4,428 # 80009050 <pid_lock>
    80000eac:	97ba                	add	a5,a5,a4
    80000eae:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb0:	00005097          	auipc	ra,0x5
    80000eb4:	2d6080e7          	jalr	726(ra) # 80006186 <pop_off>
  return p;
}
    80000eb8:	8526                	mv	a0,s1
    80000eba:	60e2                	ld	ra,24(sp)
    80000ebc:	6442                	ld	s0,16(sp)
    80000ebe:	64a2                	ld	s1,8(sp)
    80000ec0:	6105                	add	sp,sp,32
    80000ec2:	8082                	ret

0000000080000ec4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ec4:	1141                	add	sp,sp,-16
    80000ec6:	e406                	sd	ra,8(sp)
    80000ec8:	e022                	sd	s0,0(sp)
    80000eca:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ecc:	00000097          	auipc	ra,0x0
    80000ed0:	fc0080e7          	jalr	-64(ra) # 80000e8c <myproc>
    80000ed4:	00005097          	auipc	ra,0x5
    80000ed8:	312080e7          	jalr	786(ra) # 800061e6 <release>

  if (first) {
    80000edc:	00008797          	auipc	a5,0x8
    80000ee0:	ac47a783          	lw	a5,-1340(a5) # 800089a0 <first.1>
    80000ee4:	eb89                	bnez	a5,80000ef6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ee6:	00001097          	auipc	ra,0x1
    80000eea:	c70080e7          	jalr	-912(ra) # 80001b56 <usertrapret>
}
    80000eee:	60a2                	ld	ra,8(sp)
    80000ef0:	6402                	ld	s0,0(sp)
    80000ef2:	0141                	add	sp,sp,16
    80000ef4:	8082                	ret
    first = 0;
    80000ef6:	00008797          	auipc	a5,0x8
    80000efa:	aa07a523          	sw	zero,-1366(a5) # 800089a0 <first.1>
    fsinit(ROOTDEV);
    80000efe:	4505                	li	a0,1
    80000f00:	00002097          	auipc	ra,0x2
    80000f04:	a66080e7          	jalr	-1434(ra) # 80002966 <fsinit>
    80000f08:	bff9                	j	80000ee6 <forkret+0x22>

0000000080000f0a <allocpid>:
allocpid() {
    80000f0a:	1101                	add	sp,sp,-32
    80000f0c:	ec06                	sd	ra,24(sp)
    80000f0e:	e822                	sd	s0,16(sp)
    80000f10:	e426                	sd	s1,8(sp)
    80000f12:	e04a                	sd	s2,0(sp)
    80000f14:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80000f16:	00008917          	auipc	s2,0x8
    80000f1a:	13a90913          	add	s2,s2,314 # 80009050 <pid_lock>
    80000f1e:	854a                	mv	a0,s2
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	212080e7          	jalr	530(ra) # 80006132 <acquire>
  pid = nextpid;
    80000f28:	00008797          	auipc	a5,0x8
    80000f2c:	a7c78793          	add	a5,a5,-1412 # 800089a4 <nextpid>
    80000f30:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f32:	0014871b          	addw	a4,s1,1
    80000f36:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f38:	854a                	mv	a0,s2
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	2ac080e7          	jalr	684(ra) # 800061e6 <release>
}
    80000f42:	8526                	mv	a0,s1
    80000f44:	60e2                	ld	ra,24(sp)
    80000f46:	6442                	ld	s0,16(sp)
    80000f48:	64a2                	ld	s1,8(sp)
    80000f4a:	6902                	ld	s2,0(sp)
    80000f4c:	6105                	add	sp,sp,32
    80000f4e:	8082                	ret

0000000080000f50 <proc_pagetable>:
{
    80000f50:	1101                	add	sp,sp,-32
    80000f52:	ec06                	sd	ra,24(sp)
    80000f54:	e822                	sd	s0,16(sp)
    80000f56:	e426                	sd	s1,8(sp)
    80000f58:	e04a                	sd	s2,0(sp)
    80000f5a:	1000                	add	s0,sp,32
    80000f5c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f5e:	00000097          	auipc	ra,0x0
    80000f62:	8b6080e7          	jalr	-1866(ra) # 80000814 <uvmcreate>
    80000f66:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f68:	c121                	beqz	a0,80000fa8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f6a:	4729                	li	a4,10
    80000f6c:	00006697          	auipc	a3,0x6
    80000f70:	09468693          	add	a3,a3,148 # 80007000 <_trampoline>
    80000f74:	6605                	lui	a2,0x1
    80000f76:	040005b7          	lui	a1,0x4000
    80000f7a:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f7c:	05b2                	sll	a1,a1,0xc
    80000f7e:	fffff097          	auipc	ra,0xfffff
    80000f82:	60c080e7          	jalr	1548(ra) # 8000058a <mappages>
    80000f86:	02054863          	bltz	a0,80000fb6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f8a:	4719                	li	a4,6
    80000f8c:	05893683          	ld	a3,88(s2)
    80000f90:	6605                	lui	a2,0x1
    80000f92:	020005b7          	lui	a1,0x2000
    80000f96:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f98:	05b6                	sll	a1,a1,0xd
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	fffff097          	auipc	ra,0xfffff
    80000fa0:	5ee080e7          	jalr	1518(ra) # 8000058a <mappages>
    80000fa4:	02054163          	bltz	a0,80000fc6 <proc_pagetable+0x76>
}
    80000fa8:	8526                	mv	a0,s1
    80000faa:	60e2                	ld	ra,24(sp)
    80000fac:	6442                	ld	s0,16(sp)
    80000fae:	64a2                	ld	s1,8(sp)
    80000fb0:	6902                	ld	s2,0(sp)
    80000fb2:	6105                	add	sp,sp,32
    80000fb4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fb6:	4581                	li	a1,0
    80000fb8:	8526                	mv	a0,s1
    80000fba:	00000097          	auipc	ra,0x0
    80000fbe:	a58080e7          	jalr	-1448(ra) # 80000a12 <uvmfree>
    return 0;
    80000fc2:	4481                	li	s1,0
    80000fc4:	b7d5                	j	80000fa8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc6:	4681                	li	a3,0
    80000fc8:	4605                	li	a2,1
    80000fca:	040005b7          	lui	a1,0x4000
    80000fce:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fd0:	05b2                	sll	a1,a1,0xc
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	77c080e7          	jalr	1916(ra) # 80000750 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fdc:	4581                	li	a1,0
    80000fde:	8526                	mv	a0,s1
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	a32080e7          	jalr	-1486(ra) # 80000a12 <uvmfree>
    return 0;
    80000fe8:	4481                	li	s1,0
    80000fea:	bf7d                	j	80000fa8 <proc_pagetable+0x58>

0000000080000fec <proc_freepagetable>:
{
    80000fec:	1101                	add	sp,sp,-32
    80000fee:	ec06                	sd	ra,24(sp)
    80000ff0:	e822                	sd	s0,16(sp)
    80000ff2:	e426                	sd	s1,8(sp)
    80000ff4:	e04a                	sd	s2,0(sp)
    80000ff6:	1000                	add	s0,sp,32
    80000ff8:	84aa                	mv	s1,a0
    80000ffa:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ffc:	4681                	li	a3,0
    80000ffe:	4605                	li	a2,1
    80001000:	040005b7          	lui	a1,0x4000
    80001004:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001006:	05b2                	sll	a1,a1,0xc
    80001008:	fffff097          	auipc	ra,0xfffff
    8000100c:	748080e7          	jalr	1864(ra) # 80000750 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001010:	4681                	li	a3,0
    80001012:	4605                	li	a2,1
    80001014:	020005b7          	lui	a1,0x2000
    80001018:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000101a:	05b6                	sll	a1,a1,0xd
    8000101c:	8526                	mv	a0,s1
    8000101e:	fffff097          	auipc	ra,0xfffff
    80001022:	732080e7          	jalr	1842(ra) # 80000750 <uvmunmap>
  uvmfree(pagetable, sz);
    80001026:	85ca                	mv	a1,s2
    80001028:	8526                	mv	a0,s1
    8000102a:	00000097          	auipc	ra,0x0
    8000102e:	9e8080e7          	jalr	-1560(ra) # 80000a12 <uvmfree>
}
    80001032:	60e2                	ld	ra,24(sp)
    80001034:	6442                	ld	s0,16(sp)
    80001036:	64a2                	ld	s1,8(sp)
    80001038:	6902                	ld	s2,0(sp)
    8000103a:	6105                	add	sp,sp,32
    8000103c:	8082                	ret

000000008000103e <freeproc>:
{
    8000103e:	1101                	add	sp,sp,-32
    80001040:	ec06                	sd	ra,24(sp)
    80001042:	e822                	sd	s0,16(sp)
    80001044:	e426                	sd	s1,8(sp)
    80001046:	1000                	add	s0,sp,32
    80001048:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000104a:	6d28                	ld	a0,88(a0)
    8000104c:	c509                	beqz	a0,80001056 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	fce080e7          	jalr	-50(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001056:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000105a:	68a8                	ld	a0,80(s1)
    8000105c:	c511                	beqz	a0,80001068 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000105e:	64ac                	ld	a1,72(s1)
    80001060:	00000097          	auipc	ra,0x0
    80001064:	f8c080e7          	jalr	-116(ra) # 80000fec <proc_freepagetable>
  p->pagetable = 0;
    80001068:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000106c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001070:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001074:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001078:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000107c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001080:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001084:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001088:	0004ac23          	sw	zero,24(s1)
}
    8000108c:	60e2                	ld	ra,24(sp)
    8000108e:	6442                	ld	s0,16(sp)
    80001090:	64a2                	ld	s1,8(sp)
    80001092:	6105                	add	sp,sp,32
    80001094:	8082                	ret

0000000080001096 <allocproc>:
{
    80001096:	1101                	add	sp,sp,-32
    80001098:	ec06                	sd	ra,24(sp)
    8000109a:	e822                	sd	s0,16(sp)
    8000109c:	e426                	sd	s1,8(sp)
    8000109e:	e04a                	sd	s2,0(sp)
    800010a0:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a2:	00008497          	auipc	s1,0x8
    800010a6:	3de48493          	add	s1,s1,990 # 80009480 <proc>
    800010aa:	0000e917          	auipc	s2,0xe
    800010ae:	dd690913          	add	s2,s2,-554 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800010b2:	8526                	mv	a0,s1
    800010b4:	00005097          	auipc	ra,0x5
    800010b8:	07e080e7          	jalr	126(ra) # 80006132 <acquire>
    if(p->state == UNUSED) {
    800010bc:	4c9c                	lw	a5,24(s1)
    800010be:	cf81                	beqz	a5,800010d6 <allocproc+0x40>
      release(&p->lock);
    800010c0:	8526                	mv	a0,s1
    800010c2:	00005097          	auipc	ra,0x5
    800010c6:	124080e7          	jalr	292(ra) # 800061e6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ca:	16848493          	add	s1,s1,360
    800010ce:	ff2492e3          	bne	s1,s2,800010b2 <allocproc+0x1c>
  return 0;
    800010d2:	4481                	li	s1,0
    800010d4:	a889                	j	80001126 <allocproc+0x90>
  p->pid = allocpid();
    800010d6:	00000097          	auipc	ra,0x0
    800010da:	e34080e7          	jalr	-460(ra) # 80000f0a <allocpid>
    800010de:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e0:	4785                	li	a5,1
    800010e2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	036080e7          	jalr	54(ra) # 8000011a <kalloc>
    800010ec:	892a                	mv	s2,a0
    800010ee:	eca8                	sd	a0,88(s1)
    800010f0:	c131                	beqz	a0,80001134 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f2:	8526                	mv	a0,s1
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	e5c080e7          	jalr	-420(ra) # 80000f50 <proc_pagetable>
    800010fc:	892a                	mv	s2,a0
    800010fe:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001100:	c531                	beqz	a0,8000114c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001102:	07000613          	li	a2,112
    80001106:	4581                	li	a1,0
    80001108:	06048513          	add	a0,s1,96
    8000110c:	fffff097          	auipc	ra,0xfffff
    80001110:	0b8080e7          	jalr	184(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    80001114:	00000797          	auipc	a5,0x0
    80001118:	db078793          	add	a5,a5,-592 # 80000ec4 <forkret>
    8000111c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000111e:	60bc                	ld	a5,64(s1)
    80001120:	6705                	lui	a4,0x1
    80001122:	97ba                	add	a5,a5,a4
    80001124:	f4bc                	sd	a5,104(s1)
}
    80001126:	8526                	mv	a0,s1
    80001128:	60e2                	ld	ra,24(sp)
    8000112a:	6442                	ld	s0,16(sp)
    8000112c:	64a2                	ld	s1,8(sp)
    8000112e:	6902                	ld	s2,0(sp)
    80001130:	6105                	add	sp,sp,32
    80001132:	8082                	ret
    freeproc(p);
    80001134:	8526                	mv	a0,s1
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	f08080e7          	jalr	-248(ra) # 8000103e <freeproc>
    release(&p->lock);
    8000113e:	8526                	mv	a0,s1
    80001140:	00005097          	auipc	ra,0x5
    80001144:	0a6080e7          	jalr	166(ra) # 800061e6 <release>
    return 0;
    80001148:	84ca                	mv	s1,s2
    8000114a:	bff1                	j	80001126 <allocproc+0x90>
    freeproc(p);
    8000114c:	8526                	mv	a0,s1
    8000114e:	00000097          	auipc	ra,0x0
    80001152:	ef0080e7          	jalr	-272(ra) # 8000103e <freeproc>
    release(&p->lock);
    80001156:	8526                	mv	a0,s1
    80001158:	00005097          	auipc	ra,0x5
    8000115c:	08e080e7          	jalr	142(ra) # 800061e6 <release>
    return 0;
    80001160:	84ca                	mv	s1,s2
    80001162:	b7d1                	j	80001126 <allocproc+0x90>

0000000080001164 <userinit>:
{
    80001164:	1101                	add	sp,sp,-32
    80001166:	ec06                	sd	ra,24(sp)
    80001168:	e822                	sd	s0,16(sp)
    8000116a:	e426                	sd	s1,8(sp)
    8000116c:	1000                	add	s0,sp,32
  p = allocproc();
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	f28080e7          	jalr	-216(ra) # 80001096 <allocproc>
    80001176:	84aa                	mv	s1,a0
  initproc = p;
    80001178:	00008797          	auipc	a5,0x8
    8000117c:	e8a7bc23          	sd	a0,-360(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001180:	03400613          	li	a2,52
    80001184:	00008597          	auipc	a1,0x8
    80001188:	82c58593          	add	a1,a1,-2004 # 800089b0 <initcode>
    8000118c:	6928                	ld	a0,80(a0)
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	6b4080e7          	jalr	1716(ra) # 80000842 <uvminit>
  p->sz = PGSIZE;
    80001196:	6785                	lui	a5,0x1
    80001198:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000119a:	6cb8                	ld	a4,88(s1)
    8000119c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a0:	6cb8                	ld	a4,88(s1)
    800011a2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a4:	4641                	li	a2,16
    800011a6:	00007597          	auipc	a1,0x7
    800011aa:	fda58593          	add	a1,a1,-38 # 80008180 <etext+0x180>
    800011ae:	15848513          	add	a0,s1,344
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	15a080e7          	jalr	346(ra) # 8000030c <safestrcpy>
  p->cwd = namei("/");
    800011ba:	00007517          	auipc	a0,0x7
    800011be:	fd650513          	add	a0,a0,-42 # 80008190 <etext+0x190>
    800011c2:	00002097          	auipc	ra,0x2
    800011c6:	1ce080e7          	jalr	462(ra) # 80003390 <namei>
    800011ca:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ce:	478d                	li	a5,3
    800011d0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d2:	8526                	mv	a0,s1
    800011d4:	00005097          	auipc	ra,0x5
    800011d8:	012080e7          	jalr	18(ra) # 800061e6 <release>
}
    800011dc:	60e2                	ld	ra,24(sp)
    800011de:	6442                	ld	s0,16(sp)
    800011e0:	64a2                	ld	s1,8(sp)
    800011e2:	6105                	add	sp,sp,32
    800011e4:	8082                	ret

00000000800011e6 <growproc>:
{
    800011e6:	1101                	add	sp,sp,-32
    800011e8:	ec06                	sd	ra,24(sp)
    800011ea:	e822                	sd	s0,16(sp)
    800011ec:	e426                	sd	s1,8(sp)
    800011ee:	e04a                	sd	s2,0(sp)
    800011f0:	1000                	add	s0,sp,32
    800011f2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011f4:	00000097          	auipc	ra,0x0
    800011f8:	c98080e7          	jalr	-872(ra) # 80000e8c <myproc>
    800011fc:	892a                	mv	s2,a0
  sz = p->sz;
    800011fe:	652c                	ld	a1,72(a0)
    80001200:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001204:	00904f63          	bgtz	s1,80001222 <growproc+0x3c>
  } else if(n < 0){
    80001208:	0204cd63          	bltz	s1,80001242 <growproc+0x5c>
  p->sz = sz;
    8000120c:	1782                	sll	a5,a5,0x20
    8000120e:	9381                	srl	a5,a5,0x20
    80001210:	04f93423          	sd	a5,72(s2)
  return 0;
    80001214:	4501                	li	a0,0
}
    80001216:	60e2                	ld	ra,24(sp)
    80001218:	6442                	ld	s0,16(sp)
    8000121a:	64a2                	ld	s1,8(sp)
    8000121c:	6902                	ld	s2,0(sp)
    8000121e:	6105                	add	sp,sp,32
    80001220:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001222:	00f4863b          	addw	a2,s1,a5
    80001226:	1602                	sll	a2,a2,0x20
    80001228:	9201                	srl	a2,a2,0x20
    8000122a:	1582                	sll	a1,a1,0x20
    8000122c:	9181                	srl	a1,a1,0x20
    8000122e:	6928                	ld	a0,80(a0)
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	6cc080e7          	jalr	1740(ra) # 800008fc <uvmalloc>
    80001238:	0005079b          	sext.w	a5,a0
    8000123c:	fbe1                	bnez	a5,8000120c <growproc+0x26>
      return -1;
    8000123e:	557d                	li	a0,-1
    80001240:	bfd9                	j	80001216 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001242:	00f4863b          	addw	a2,s1,a5
    80001246:	1602                	sll	a2,a2,0x20
    80001248:	9201                	srl	a2,a2,0x20
    8000124a:	1582                	sll	a1,a1,0x20
    8000124c:	9181                	srl	a1,a1,0x20
    8000124e:	6928                	ld	a0,80(a0)
    80001250:	fffff097          	auipc	ra,0xfffff
    80001254:	664080e7          	jalr	1636(ra) # 800008b4 <uvmdealloc>
    80001258:	0005079b          	sext.w	a5,a0
    8000125c:	bf45                	j	8000120c <growproc+0x26>

000000008000125e <fork>:
{
    8000125e:	7139                	add	sp,sp,-64
    80001260:	fc06                	sd	ra,56(sp)
    80001262:	f822                	sd	s0,48(sp)
    80001264:	f426                	sd	s1,40(sp)
    80001266:	f04a                	sd	s2,32(sp)
    80001268:	ec4e                	sd	s3,24(sp)
    8000126a:	e852                	sd	s4,16(sp)
    8000126c:	e456                	sd	s5,8(sp)
    8000126e:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001270:	00000097          	auipc	ra,0x0
    80001274:	c1c080e7          	jalr	-996(ra) # 80000e8c <myproc>
    80001278:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e1c080e7          	jalr	-484(ra) # 80001096 <allocproc>
    80001282:	12050063          	beqz	a0,800013a2 <fork+0x144>
    80001286:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001288:	048ab603          	ld	a2,72(s5)
    8000128c:	692c                	ld	a1,80(a0)
    8000128e:	050ab503          	ld	a0,80(s5)
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	7ba080e7          	jalr	1978(ra) # 80000a4c <uvmcopy>
    8000129a:	04054863          	bltz	a0,800012ea <fork+0x8c>
  np->sz = p->sz;
    8000129e:	048ab783          	ld	a5,72(s5)
    800012a2:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012a6:	058ab683          	ld	a3,88(s5)
    800012aa:	87b6                	mv	a5,a3
    800012ac:	0589b703          	ld	a4,88(s3)
    800012b0:	12068693          	add	a3,a3,288
    800012b4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b8:	6788                	ld	a0,8(a5)
    800012ba:	6b8c                	ld	a1,16(a5)
    800012bc:	6f90                	ld	a2,24(a5)
    800012be:	01073023          	sd	a6,0(a4)
    800012c2:	e708                	sd	a0,8(a4)
    800012c4:	eb0c                	sd	a1,16(a4)
    800012c6:	ef10                	sd	a2,24(a4)
    800012c8:	02078793          	add	a5,a5,32
    800012cc:	02070713          	add	a4,a4,32
    800012d0:	fed792e3          	bne	a5,a3,800012b4 <fork+0x56>
  np->trapframe->a0 = 0;
    800012d4:	0589b783          	ld	a5,88(s3)
    800012d8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012dc:	0d0a8493          	add	s1,s5,208
    800012e0:	0d098913          	add	s2,s3,208
    800012e4:	150a8a13          	add	s4,s5,336
    800012e8:	a00d                	j	8000130a <fork+0xac>
    freeproc(np);
    800012ea:	854e                	mv	a0,s3
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	d52080e7          	jalr	-686(ra) # 8000103e <freeproc>
    release(&np->lock);
    800012f4:	854e                	mv	a0,s3
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	ef0080e7          	jalr	-272(ra) # 800061e6 <release>
    return -1;
    800012fe:	597d                	li	s2,-1
    80001300:	a079                	j	8000138e <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001302:	04a1                	add	s1,s1,8
    80001304:	0921                	add	s2,s2,8
    80001306:	01448b63          	beq	s1,s4,8000131c <fork+0xbe>
    if(p->ofile[i])
    8000130a:	6088                	ld	a0,0(s1)
    8000130c:	d97d                	beqz	a0,80001302 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000130e:	00002097          	auipc	ra,0x2
    80001312:	6f4080e7          	jalr	1780(ra) # 80003a02 <filedup>
    80001316:	00a93023          	sd	a0,0(s2)
    8000131a:	b7e5                	j	80001302 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000131c:	150ab503          	ld	a0,336(s5)
    80001320:	00002097          	auipc	ra,0x2
    80001324:	87c080e7          	jalr	-1924(ra) # 80002b9c <idup>
    80001328:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000132c:	4641                	li	a2,16
    8000132e:	158a8593          	add	a1,s5,344
    80001332:	15898513          	add	a0,s3,344
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	fd6080e7          	jalr	-42(ra) # 8000030c <safestrcpy>
  pid = np->pid;
    8000133e:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001342:	854e                	mv	a0,s3
    80001344:	00005097          	auipc	ra,0x5
    80001348:	ea2080e7          	jalr	-350(ra) # 800061e6 <release>
  acquire(&wait_lock);
    8000134c:	00008497          	auipc	s1,0x8
    80001350:	d1c48493          	add	s1,s1,-740 # 80009068 <wait_lock>
    80001354:	8526                	mv	a0,s1
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	ddc080e7          	jalr	-548(ra) # 80006132 <acquire>
  np->parent = p;
    8000135e:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001362:	8526                	mv	a0,s1
    80001364:	00005097          	auipc	ra,0x5
    80001368:	e82080e7          	jalr	-382(ra) # 800061e6 <release>
  acquire(&np->lock);
    8000136c:	854e                	mv	a0,s3
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	dc4080e7          	jalr	-572(ra) # 80006132 <acquire>
  np->state = RUNNABLE;
    80001376:	478d                	li	a5,3
    80001378:	00f9ac23          	sw	a5,24(s3)
  np->mask = p->mask;
    8000137c:	034aa783          	lw	a5,52(s5)
    80001380:	02f9aa23          	sw	a5,52(s3)
  release(&np->lock);
    80001384:	854e                	mv	a0,s3
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	e60080e7          	jalr	-416(ra) # 800061e6 <release>
}
    8000138e:	854a                	mv	a0,s2
    80001390:	70e2                	ld	ra,56(sp)
    80001392:	7442                	ld	s0,48(sp)
    80001394:	74a2                	ld	s1,40(sp)
    80001396:	7902                	ld	s2,32(sp)
    80001398:	69e2                	ld	s3,24(sp)
    8000139a:	6a42                	ld	s4,16(sp)
    8000139c:	6aa2                	ld	s5,8(sp)
    8000139e:	6121                	add	sp,sp,64
    800013a0:	8082                	ret
    return -1;
    800013a2:	597d                	li	s2,-1
    800013a4:	b7ed                	j	8000138e <fork+0x130>

00000000800013a6 <scheduler>:
{
    800013a6:	7139                	add	sp,sp,-64
    800013a8:	fc06                	sd	ra,56(sp)
    800013aa:	f822                	sd	s0,48(sp)
    800013ac:	f426                	sd	s1,40(sp)
    800013ae:	f04a                	sd	s2,32(sp)
    800013b0:	ec4e                	sd	s3,24(sp)
    800013b2:	e852                	sd	s4,16(sp)
    800013b4:	e456                	sd	s5,8(sp)
    800013b6:	e05a                	sd	s6,0(sp)
    800013b8:	0080                	add	s0,sp,64
    800013ba:	8792                	mv	a5,tp
  int id = r_tp();
    800013bc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013be:	00779a93          	sll	s5,a5,0x7
    800013c2:	00008717          	auipc	a4,0x8
    800013c6:	c8e70713          	add	a4,a4,-882 # 80009050 <pid_lock>
    800013ca:	9756                	add	a4,a4,s5
    800013cc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d0:	00008717          	auipc	a4,0x8
    800013d4:	cb870713          	add	a4,a4,-840 # 80009088 <cpus+0x8>
    800013d8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013da:	498d                	li	s3,3
        p->state = RUNNING;
    800013dc:	4b11                	li	s6,4
        c->proc = p;
    800013de:	079e                	sll	a5,a5,0x7
    800013e0:	00008a17          	auipc	s4,0x8
    800013e4:	c70a0a13          	add	s4,s4,-912 # 80009050 <pid_lock>
    800013e8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ea:	0000e917          	auipc	s2,0xe
    800013ee:	a9690913          	add	s2,s2,-1386 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f6:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fa:	10079073          	csrw	sstatus,a5
    800013fe:	00008497          	auipc	s1,0x8
    80001402:	08248493          	add	s1,s1,130 # 80009480 <proc>
    80001406:	a811                	j	8000141a <scheduler+0x74>
      release(&p->lock);
    80001408:	8526                	mv	a0,s1
    8000140a:	00005097          	auipc	ra,0x5
    8000140e:	ddc080e7          	jalr	-548(ra) # 800061e6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001412:	16848493          	add	s1,s1,360
    80001416:	fd248ee3          	beq	s1,s2,800013f2 <scheduler+0x4c>
      acquire(&p->lock);
    8000141a:	8526                	mv	a0,s1
    8000141c:	00005097          	auipc	ra,0x5
    80001420:	d16080e7          	jalr	-746(ra) # 80006132 <acquire>
      if(p->state == RUNNABLE) {
    80001424:	4c9c                	lw	a5,24(s1)
    80001426:	ff3791e3          	bne	a5,s3,80001408 <scheduler+0x62>
        p->state = RUNNING;
    8000142a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001432:	06048593          	add	a1,s1,96
    80001436:	8556                	mv	a0,s5
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	674080e7          	jalr	1652(ra) # 80001aac <swtch>
        c->proc = 0;
    80001440:	020a3823          	sd	zero,48(s4)
    80001444:	b7d1                	j	80001408 <scheduler+0x62>

0000000080001446 <sched>:
{
    80001446:	7179                	add	sp,sp,-48
    80001448:	f406                	sd	ra,40(sp)
    8000144a:	f022                	sd	s0,32(sp)
    8000144c:	ec26                	sd	s1,24(sp)
    8000144e:	e84a                	sd	s2,16(sp)
    80001450:	e44e                	sd	s3,8(sp)
    80001452:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001454:	00000097          	auipc	ra,0x0
    80001458:	a38080e7          	jalr	-1480(ra) # 80000e8c <myproc>
    8000145c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145e:	00005097          	auipc	ra,0x5
    80001462:	c5a080e7          	jalr	-934(ra) # 800060b8 <holding>
    80001466:	c93d                	beqz	a0,800014dc <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001468:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146a:	2781                	sext.w	a5,a5
    8000146c:	079e                	sll	a5,a5,0x7
    8000146e:	00008717          	auipc	a4,0x8
    80001472:	be270713          	add	a4,a4,-1054 # 80009050 <pid_lock>
    80001476:	97ba                	add	a5,a5,a4
    80001478:	0a87a703          	lw	a4,168(a5)
    8000147c:	4785                	li	a5,1
    8000147e:	06f71763          	bne	a4,a5,800014ec <sched+0xa6>
  if(p->state == RUNNING)
    80001482:	4c98                	lw	a4,24(s1)
    80001484:	4791                	li	a5,4
    80001486:	06f70b63          	beq	a4,a5,800014fc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148e:	8b89                	and	a5,a5,2
  if(intr_get())
    80001490:	efb5                	bnez	a5,8000150c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001492:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001494:	00008917          	auipc	s2,0x8
    80001498:	bbc90913          	add	s2,s2,-1092 # 80009050 <pid_lock>
    8000149c:	2781                	sext.w	a5,a5
    8000149e:	079e                	sll	a5,a5,0x7
    800014a0:	97ca                	add	a5,a5,s2
    800014a2:	0ac7a983          	lw	s3,172(a5)
    800014a6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a8:	2781                	sext.w	a5,a5
    800014aa:	079e                	sll	a5,a5,0x7
    800014ac:	00008597          	auipc	a1,0x8
    800014b0:	bdc58593          	add	a1,a1,-1060 # 80009088 <cpus+0x8>
    800014b4:	95be                	add	a1,a1,a5
    800014b6:	06048513          	add	a0,s1,96
    800014ba:	00000097          	auipc	ra,0x0
    800014be:	5f2080e7          	jalr	1522(ra) # 80001aac <swtch>
    800014c2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c4:	2781                	sext.w	a5,a5
    800014c6:	079e                	sll	a5,a5,0x7
    800014c8:	993e                	add	s2,s2,a5
    800014ca:	0b392623          	sw	s3,172(s2)
}
    800014ce:	70a2                	ld	ra,40(sp)
    800014d0:	7402                	ld	s0,32(sp)
    800014d2:	64e2                	ld	s1,24(sp)
    800014d4:	6942                	ld	s2,16(sp)
    800014d6:	69a2                	ld	s3,8(sp)
    800014d8:	6145                	add	sp,sp,48
    800014da:	8082                	ret
    panic("sched p->lock");
    800014dc:	00007517          	auipc	a0,0x7
    800014e0:	cbc50513          	add	a0,a0,-836 # 80008198 <etext+0x198>
    800014e4:	00004097          	auipc	ra,0x4
    800014e8:	716080e7          	jalr	1814(ra) # 80005bfa <panic>
    panic("sched locks");
    800014ec:	00007517          	auipc	a0,0x7
    800014f0:	cbc50513          	add	a0,a0,-836 # 800081a8 <etext+0x1a8>
    800014f4:	00004097          	auipc	ra,0x4
    800014f8:	706080e7          	jalr	1798(ra) # 80005bfa <panic>
    panic("sched running");
    800014fc:	00007517          	auipc	a0,0x7
    80001500:	cbc50513          	add	a0,a0,-836 # 800081b8 <etext+0x1b8>
    80001504:	00004097          	auipc	ra,0x4
    80001508:	6f6080e7          	jalr	1782(ra) # 80005bfa <panic>
    panic("sched interruptible");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	cbc50513          	add	a0,a0,-836 # 800081c8 <etext+0x1c8>
    80001514:	00004097          	auipc	ra,0x4
    80001518:	6e6080e7          	jalr	1766(ra) # 80005bfa <panic>

000000008000151c <yield>:
{
    8000151c:	1101                	add	sp,sp,-32
    8000151e:	ec06                	sd	ra,24(sp)
    80001520:	e822                	sd	s0,16(sp)
    80001522:	e426                	sd	s1,8(sp)
    80001524:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	966080e7          	jalr	-1690(ra) # 80000e8c <myproc>
    8000152e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001530:	00005097          	auipc	ra,0x5
    80001534:	c02080e7          	jalr	-1022(ra) # 80006132 <acquire>
  p->state = RUNNABLE;
    80001538:	478d                	li	a5,3
    8000153a:	cc9c                	sw	a5,24(s1)
  sched();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	f0a080e7          	jalr	-246(ra) # 80001446 <sched>
  release(&p->lock);
    80001544:	8526                	mv	a0,s1
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	ca0080e7          	jalr	-864(ra) # 800061e6 <release>
}
    8000154e:	60e2                	ld	ra,24(sp)
    80001550:	6442                	ld	s0,16(sp)
    80001552:	64a2                	ld	s1,8(sp)
    80001554:	6105                	add	sp,sp,32
    80001556:	8082                	ret

0000000080001558 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001558:	7179                	add	sp,sp,-48
    8000155a:	f406                	sd	ra,40(sp)
    8000155c:	f022                	sd	s0,32(sp)
    8000155e:	ec26                	sd	s1,24(sp)
    80001560:	e84a                	sd	s2,16(sp)
    80001562:	e44e                	sd	s3,8(sp)
    80001564:	1800                	add	s0,sp,48
    80001566:	89aa                	mv	s3,a0
    80001568:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	922080e7          	jalr	-1758(ra) # 80000e8c <myproc>
    80001572:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001574:	00005097          	auipc	ra,0x5
    80001578:	bbe080e7          	jalr	-1090(ra) # 80006132 <acquire>
  release(lk);
    8000157c:	854a                	mv	a0,s2
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	c68080e7          	jalr	-920(ra) # 800061e6 <release>

  // Go to sleep.
  p->chan = chan;
    80001586:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158a:	4789                	li	a5,2
    8000158c:	cc9c                	sw	a5,24(s1)

  sched();
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	eb8080e7          	jalr	-328(ra) # 80001446 <sched>

  // Tidy up.
  p->chan = 0;
    80001596:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	c4a080e7          	jalr	-950(ra) # 800061e6 <release>
  acquire(lk);
    800015a4:	854a                	mv	a0,s2
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	b8c080e7          	jalr	-1140(ra) # 80006132 <acquire>
}
    800015ae:	70a2                	ld	ra,40(sp)
    800015b0:	7402                	ld	s0,32(sp)
    800015b2:	64e2                	ld	s1,24(sp)
    800015b4:	6942                	ld	s2,16(sp)
    800015b6:	69a2                	ld	s3,8(sp)
    800015b8:	6145                	add	sp,sp,48
    800015ba:	8082                	ret

00000000800015bc <wait>:
{
    800015bc:	715d                	add	sp,sp,-80
    800015be:	e486                	sd	ra,72(sp)
    800015c0:	e0a2                	sd	s0,64(sp)
    800015c2:	fc26                	sd	s1,56(sp)
    800015c4:	f84a                	sd	s2,48(sp)
    800015c6:	f44e                	sd	s3,40(sp)
    800015c8:	f052                	sd	s4,32(sp)
    800015ca:	ec56                	sd	s5,24(sp)
    800015cc:	e85a                	sd	s6,16(sp)
    800015ce:	e45e                	sd	s7,8(sp)
    800015d0:	e062                	sd	s8,0(sp)
    800015d2:	0880                	add	s0,sp,80
    800015d4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d6:	00000097          	auipc	ra,0x0
    800015da:	8b6080e7          	jalr	-1866(ra) # 80000e8c <myproc>
    800015de:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e0:	00008517          	auipc	a0,0x8
    800015e4:	a8850513          	add	a0,a0,-1400 # 80009068 <wait_lock>
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	b4a080e7          	jalr	-1206(ra) # 80006132 <acquire>
    havekids = 0;
    800015f0:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f2:	4a15                	li	s4,5
        havekids = 1;
    800015f4:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015f6:	0000e997          	auipc	s3,0xe
    800015fa:	88a98993          	add	s3,s3,-1910 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fe:	00008c17          	auipc	s8,0x8
    80001602:	a6ac0c13          	add	s8,s8,-1430 # 80009068 <wait_lock>
    80001606:	a87d                	j	800016c4 <wait+0x108>
          pid = np->pid;
    80001608:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000160c:	000b0e63          	beqz	s6,80001628 <wait+0x6c>
    80001610:	4691                	li	a3,4
    80001612:	02c48613          	add	a2,s1,44
    80001616:	85da                	mv	a1,s6
    80001618:	05093503          	ld	a0,80(s2)
    8000161c:	fffff097          	auipc	ra,0xfffff
    80001620:	534080e7          	jalr	1332(ra) # 80000b50 <copyout>
    80001624:	04054163          	bltz	a0,80001666 <wait+0xaa>
          freeproc(np);
    80001628:	8526                	mv	a0,s1
    8000162a:	00000097          	auipc	ra,0x0
    8000162e:	a14080e7          	jalr	-1516(ra) # 8000103e <freeproc>
          release(&np->lock);
    80001632:	8526                	mv	a0,s1
    80001634:	00005097          	auipc	ra,0x5
    80001638:	bb2080e7          	jalr	-1102(ra) # 800061e6 <release>
          release(&wait_lock);
    8000163c:	00008517          	auipc	a0,0x8
    80001640:	a2c50513          	add	a0,a0,-1492 # 80009068 <wait_lock>
    80001644:	00005097          	auipc	ra,0x5
    80001648:	ba2080e7          	jalr	-1118(ra) # 800061e6 <release>
}
    8000164c:	854e                	mv	a0,s3
    8000164e:	60a6                	ld	ra,72(sp)
    80001650:	6406                	ld	s0,64(sp)
    80001652:	74e2                	ld	s1,56(sp)
    80001654:	7942                	ld	s2,48(sp)
    80001656:	79a2                	ld	s3,40(sp)
    80001658:	7a02                	ld	s4,32(sp)
    8000165a:	6ae2                	ld	s5,24(sp)
    8000165c:	6b42                	ld	s6,16(sp)
    8000165e:	6ba2                	ld	s7,8(sp)
    80001660:	6c02                	ld	s8,0(sp)
    80001662:	6161                	add	sp,sp,80
    80001664:	8082                	ret
            release(&np->lock);
    80001666:	8526                	mv	a0,s1
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	b7e080e7          	jalr	-1154(ra) # 800061e6 <release>
            release(&wait_lock);
    80001670:	00008517          	auipc	a0,0x8
    80001674:	9f850513          	add	a0,a0,-1544 # 80009068 <wait_lock>
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	b6e080e7          	jalr	-1170(ra) # 800061e6 <release>
            return -1;
    80001680:	59fd                	li	s3,-1
    80001682:	b7e9                	j	8000164c <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    80001684:	16848493          	add	s1,s1,360
    80001688:	03348463          	beq	s1,s3,800016b0 <wait+0xf4>
      if(np->parent == p){
    8000168c:	7c9c                	ld	a5,56(s1)
    8000168e:	ff279be3          	bne	a5,s2,80001684 <wait+0xc8>
        acquire(&np->lock);
    80001692:	8526                	mv	a0,s1
    80001694:	00005097          	auipc	ra,0x5
    80001698:	a9e080e7          	jalr	-1378(ra) # 80006132 <acquire>
        if(np->state == ZOMBIE){
    8000169c:	4c9c                	lw	a5,24(s1)
    8000169e:	f74785e3          	beq	a5,s4,80001608 <wait+0x4c>
        release(&np->lock);
    800016a2:	8526                	mv	a0,s1
    800016a4:	00005097          	auipc	ra,0x5
    800016a8:	b42080e7          	jalr	-1214(ra) # 800061e6 <release>
        havekids = 1;
    800016ac:	8756                	mv	a4,s5
    800016ae:	bfd9                	j	80001684 <wait+0xc8>
    if(!havekids || p->killed){
    800016b0:	c305                	beqz	a4,800016d0 <wait+0x114>
    800016b2:	02892783          	lw	a5,40(s2)
    800016b6:	ef89                	bnez	a5,800016d0 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b8:	85e2                	mv	a1,s8
    800016ba:	854a                	mv	a0,s2
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	e9c080e7          	jalr	-356(ra) # 80001558 <sleep>
    havekids = 0;
    800016c4:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016c6:	00008497          	auipc	s1,0x8
    800016ca:	dba48493          	add	s1,s1,-582 # 80009480 <proc>
    800016ce:	bf7d                	j	8000168c <wait+0xd0>
      release(&wait_lock);
    800016d0:	00008517          	auipc	a0,0x8
    800016d4:	99850513          	add	a0,a0,-1640 # 80009068 <wait_lock>
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	b0e080e7          	jalr	-1266(ra) # 800061e6 <release>
      return -1;
    800016e0:	59fd                	li	s3,-1
    800016e2:	b7ad                	j	8000164c <wait+0x90>

00000000800016e4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e4:	7139                	add	sp,sp,-64
    800016e6:	fc06                	sd	ra,56(sp)
    800016e8:	f822                	sd	s0,48(sp)
    800016ea:	f426                	sd	s1,40(sp)
    800016ec:	f04a                	sd	s2,32(sp)
    800016ee:	ec4e                	sd	s3,24(sp)
    800016f0:	e852                	sd	s4,16(sp)
    800016f2:	e456                	sd	s5,8(sp)
    800016f4:	0080                	add	s0,sp,64
    800016f6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f8:	00008497          	auipc	s1,0x8
    800016fc:	d8848493          	add	s1,s1,-632 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001700:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001702:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001704:	0000d917          	auipc	s2,0xd
    80001708:	77c90913          	add	s2,s2,1916 # 8000ee80 <tickslock>
    8000170c:	a811                	j	80001720 <wakeup+0x3c>
      }
      release(&p->lock);
    8000170e:	8526                	mv	a0,s1
    80001710:	00005097          	auipc	ra,0x5
    80001714:	ad6080e7          	jalr	-1322(ra) # 800061e6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001718:	16848493          	add	s1,s1,360
    8000171c:	03248663          	beq	s1,s2,80001748 <wakeup+0x64>
    if(p != myproc()){
    80001720:	fffff097          	auipc	ra,0xfffff
    80001724:	76c080e7          	jalr	1900(ra) # 80000e8c <myproc>
    80001728:	fea488e3          	beq	s1,a0,80001718 <wakeup+0x34>
      acquire(&p->lock);
    8000172c:	8526                	mv	a0,s1
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	a04080e7          	jalr	-1532(ra) # 80006132 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001736:	4c9c                	lw	a5,24(s1)
    80001738:	fd379be3          	bne	a5,s3,8000170e <wakeup+0x2a>
    8000173c:	709c                	ld	a5,32(s1)
    8000173e:	fd4798e3          	bne	a5,s4,8000170e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001742:	0154ac23          	sw	s5,24(s1)
    80001746:	b7e1                	j	8000170e <wakeup+0x2a>
    }
  }
}
    80001748:	70e2                	ld	ra,56(sp)
    8000174a:	7442                	ld	s0,48(sp)
    8000174c:	74a2                	ld	s1,40(sp)
    8000174e:	7902                	ld	s2,32(sp)
    80001750:	69e2                	ld	s3,24(sp)
    80001752:	6a42                	ld	s4,16(sp)
    80001754:	6aa2                	ld	s5,8(sp)
    80001756:	6121                	add	sp,sp,64
    80001758:	8082                	ret

000000008000175a <reparent>:
{
    8000175a:	7179                	add	sp,sp,-48
    8000175c:	f406                	sd	ra,40(sp)
    8000175e:	f022                	sd	s0,32(sp)
    80001760:	ec26                	sd	s1,24(sp)
    80001762:	e84a                	sd	s2,16(sp)
    80001764:	e44e                	sd	s3,8(sp)
    80001766:	e052                	sd	s4,0(sp)
    80001768:	1800                	add	s0,sp,48
    8000176a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176c:	00008497          	auipc	s1,0x8
    80001770:	d1448493          	add	s1,s1,-748 # 80009480 <proc>
      pp->parent = initproc;
    80001774:	00008a17          	auipc	s4,0x8
    80001778:	89ca0a13          	add	s4,s4,-1892 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177c:	0000d997          	auipc	s3,0xd
    80001780:	70498993          	add	s3,s3,1796 # 8000ee80 <tickslock>
    80001784:	a029                	j	8000178e <reparent+0x34>
    80001786:	16848493          	add	s1,s1,360
    8000178a:	01348d63          	beq	s1,s3,800017a4 <reparent+0x4a>
    if(pp->parent == p){
    8000178e:	7c9c                	ld	a5,56(s1)
    80001790:	ff279be3          	bne	a5,s2,80001786 <reparent+0x2c>
      pp->parent = initproc;
    80001794:	000a3503          	ld	a0,0(s4)
    80001798:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000179a:	00000097          	auipc	ra,0x0
    8000179e:	f4a080e7          	jalr	-182(ra) # 800016e4 <wakeup>
    800017a2:	b7d5                	j	80001786 <reparent+0x2c>
}
    800017a4:	70a2                	ld	ra,40(sp)
    800017a6:	7402                	ld	s0,32(sp)
    800017a8:	64e2                	ld	s1,24(sp)
    800017aa:	6942                	ld	s2,16(sp)
    800017ac:	69a2                	ld	s3,8(sp)
    800017ae:	6a02                	ld	s4,0(sp)
    800017b0:	6145                	add	sp,sp,48
    800017b2:	8082                	ret

00000000800017b4 <exit>:
{
    800017b4:	7179                	add	sp,sp,-48
    800017b6:	f406                	sd	ra,40(sp)
    800017b8:	f022                	sd	s0,32(sp)
    800017ba:	ec26                	sd	s1,24(sp)
    800017bc:	e84a                	sd	s2,16(sp)
    800017be:	e44e                	sd	s3,8(sp)
    800017c0:	e052                	sd	s4,0(sp)
    800017c2:	1800                	add	s0,sp,48
    800017c4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c6:	fffff097          	auipc	ra,0xfffff
    800017ca:	6c6080e7          	jalr	1734(ra) # 80000e8c <myproc>
    800017ce:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d0:	00008797          	auipc	a5,0x8
    800017d4:	8407b783          	ld	a5,-1984(a5) # 80009010 <initproc>
    800017d8:	0d050493          	add	s1,a0,208
    800017dc:	15050913          	add	s2,a0,336
    800017e0:	02a79363          	bne	a5,a0,80001806 <exit+0x52>
    panic("init exiting");
    800017e4:	00007517          	auipc	a0,0x7
    800017e8:	9fc50513          	add	a0,a0,-1540 # 800081e0 <etext+0x1e0>
    800017ec:	00004097          	auipc	ra,0x4
    800017f0:	40e080e7          	jalr	1038(ra) # 80005bfa <panic>
      fileclose(f);
    800017f4:	00002097          	auipc	ra,0x2
    800017f8:	260080e7          	jalr	608(ra) # 80003a54 <fileclose>
      p->ofile[fd] = 0;
    800017fc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001800:	04a1                	add	s1,s1,8
    80001802:	01248563          	beq	s1,s2,8000180c <exit+0x58>
    if(p->ofile[fd]){
    80001806:	6088                	ld	a0,0(s1)
    80001808:	f575                	bnez	a0,800017f4 <exit+0x40>
    8000180a:	bfdd                	j	80001800 <exit+0x4c>
  begin_op();
    8000180c:	00002097          	auipc	ra,0x2
    80001810:	d84080e7          	jalr	-636(ra) # 80003590 <begin_op>
  iput(p->cwd);
    80001814:	1509b503          	ld	a0,336(s3)
    80001818:	00001097          	auipc	ra,0x1
    8000181c:	57c080e7          	jalr	1404(ra) # 80002d94 <iput>
  end_op();
    80001820:	00002097          	auipc	ra,0x2
    80001824:	dea080e7          	jalr	-534(ra) # 8000360a <end_op>
  p->cwd = 0;
    80001828:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000182c:	00008497          	auipc	s1,0x8
    80001830:	83c48493          	add	s1,s1,-1988 # 80009068 <wait_lock>
    80001834:	8526                	mv	a0,s1
    80001836:	00005097          	auipc	ra,0x5
    8000183a:	8fc080e7          	jalr	-1796(ra) # 80006132 <acquire>
  reparent(p);
    8000183e:	854e                	mv	a0,s3
    80001840:	00000097          	auipc	ra,0x0
    80001844:	f1a080e7          	jalr	-230(ra) # 8000175a <reparent>
  wakeup(p->parent);
    80001848:	0389b503          	ld	a0,56(s3)
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	e98080e7          	jalr	-360(ra) # 800016e4 <wakeup>
  acquire(&p->lock);
    80001854:	854e                	mv	a0,s3
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	8dc080e7          	jalr	-1828(ra) # 80006132 <acquire>
  p->xstate = status;
    8000185e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001862:	4795                	li	a5,5
    80001864:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	97c080e7          	jalr	-1668(ra) # 800061e6 <release>
  sched();
    80001872:	00000097          	auipc	ra,0x0
    80001876:	bd4080e7          	jalr	-1068(ra) # 80001446 <sched>
  panic("zombie exit");
    8000187a:	00007517          	auipc	a0,0x7
    8000187e:	97650513          	add	a0,a0,-1674 # 800081f0 <etext+0x1f0>
    80001882:	00004097          	auipc	ra,0x4
    80001886:	378080e7          	jalr	888(ra) # 80005bfa <panic>

000000008000188a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000188a:	7179                	add	sp,sp,-48
    8000188c:	f406                	sd	ra,40(sp)
    8000188e:	f022                	sd	s0,32(sp)
    80001890:	ec26                	sd	s1,24(sp)
    80001892:	e84a                	sd	s2,16(sp)
    80001894:	e44e                	sd	s3,8(sp)
    80001896:	1800                	add	s0,sp,48
    80001898:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000189a:	00008497          	auipc	s1,0x8
    8000189e:	be648493          	add	s1,s1,-1050 # 80009480 <proc>
    800018a2:	0000d997          	auipc	s3,0xd
    800018a6:	5de98993          	add	s3,s3,1502 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	886080e7          	jalr	-1914(ra) # 80006132 <acquire>
    if(p->pid == pid){
    800018b4:	589c                	lw	a5,48(s1)
    800018b6:	01278d63          	beq	a5,s2,800018d0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	92a080e7          	jalr	-1750(ra) # 800061e6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c4:	16848493          	add	s1,s1,360
    800018c8:	ff3491e3          	bne	s1,s3,800018aa <kill+0x20>
  }
  return -1;
    800018cc:	557d                	li	a0,-1
    800018ce:	a829                	j	800018e8 <kill+0x5e>
      p->killed = 1;
    800018d0:	4785                	li	a5,1
    800018d2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d4:	4c98                	lw	a4,24(s1)
    800018d6:	4789                	li	a5,2
    800018d8:	00f70f63          	beq	a4,a5,800018f6 <kill+0x6c>
      release(&p->lock);
    800018dc:	8526                	mv	a0,s1
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	908080e7          	jalr	-1784(ra) # 800061e6 <release>
      return 0;
    800018e6:	4501                	li	a0,0
}
    800018e8:	70a2                	ld	ra,40(sp)
    800018ea:	7402                	ld	s0,32(sp)
    800018ec:	64e2                	ld	s1,24(sp)
    800018ee:	6942                	ld	s2,16(sp)
    800018f0:	69a2                	ld	s3,8(sp)
    800018f2:	6145                	add	sp,sp,48
    800018f4:	8082                	ret
        p->state = RUNNABLE;
    800018f6:	478d                	li	a5,3
    800018f8:	cc9c                	sw	a5,24(s1)
    800018fa:	b7cd                	j	800018dc <kill+0x52>

00000000800018fc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fc:	7179                	add	sp,sp,-48
    800018fe:	f406                	sd	ra,40(sp)
    80001900:	f022                	sd	s0,32(sp)
    80001902:	ec26                	sd	s1,24(sp)
    80001904:	e84a                	sd	s2,16(sp)
    80001906:	e44e                	sd	s3,8(sp)
    80001908:	e052                	sd	s4,0(sp)
    8000190a:	1800                	add	s0,sp,48
    8000190c:	84aa                	mv	s1,a0
    8000190e:	892e                	mv	s2,a1
    80001910:	89b2                	mv	s3,a2
    80001912:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	578080e7          	jalr	1400(ra) # 80000e8c <myproc>
  if(user_dst){
    8000191c:	c08d                	beqz	s1,8000193e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191e:	86d2                	mv	a3,s4
    80001920:	864e                	mv	a2,s3
    80001922:	85ca                	mv	a1,s2
    80001924:	6928                	ld	a0,80(a0)
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	22a080e7          	jalr	554(ra) # 80000b50 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192e:	70a2                	ld	ra,40(sp)
    80001930:	7402                	ld	s0,32(sp)
    80001932:	64e2                	ld	s1,24(sp)
    80001934:	6942                	ld	s2,16(sp)
    80001936:	69a2                	ld	s3,8(sp)
    80001938:	6a02                	ld	s4,0(sp)
    8000193a:	6145                	add	sp,sp,48
    8000193c:	8082                	ret
    memmove((char *)dst, src, len);
    8000193e:	000a061b          	sext.w	a2,s4
    80001942:	85ce                	mv	a1,s3
    80001944:	854a                	mv	a0,s2
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	8da080e7          	jalr	-1830(ra) # 80000220 <memmove>
    return 0;
    8000194e:	8526                	mv	a0,s1
    80001950:	bff9                	j	8000192e <either_copyout+0x32>

0000000080001952 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001952:	7179                	add	sp,sp,-48
    80001954:	f406                	sd	ra,40(sp)
    80001956:	f022                	sd	s0,32(sp)
    80001958:	ec26                	sd	s1,24(sp)
    8000195a:	e84a                	sd	s2,16(sp)
    8000195c:	e44e                	sd	s3,8(sp)
    8000195e:	e052                	sd	s4,0(sp)
    80001960:	1800                	add	s0,sp,48
    80001962:	892a                	mv	s2,a0
    80001964:	84ae                	mv	s1,a1
    80001966:	89b2                	mv	s3,a2
    80001968:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	522080e7          	jalr	1314(ra) # 80000e8c <myproc>
  if(user_src){
    80001972:	c08d                	beqz	s1,80001994 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001974:	86d2                	mv	a3,s4
    80001976:	864e                	mv	a2,s3
    80001978:	85ca                	mv	a1,s2
    8000197a:	6928                	ld	a0,80(a0)
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	260080e7          	jalr	608(ra) # 80000bdc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001984:	70a2                	ld	ra,40(sp)
    80001986:	7402                	ld	s0,32(sp)
    80001988:	64e2                	ld	s1,24(sp)
    8000198a:	6942                	ld	s2,16(sp)
    8000198c:	69a2                	ld	s3,8(sp)
    8000198e:	6a02                	ld	s4,0(sp)
    80001990:	6145                	add	sp,sp,48
    80001992:	8082                	ret
    memmove(dst, (char*)src, len);
    80001994:	000a061b          	sext.w	a2,s4
    80001998:	85ce                	mv	a1,s3
    8000199a:	854a                	mv	a0,s2
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	884080e7          	jalr	-1916(ra) # 80000220 <memmove>
    return 0;
    800019a4:	8526                	mv	a0,s1
    800019a6:	bff9                	j	80001984 <either_copyin+0x32>

00000000800019a8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a8:	715d                	add	sp,sp,-80
    800019aa:	e486                	sd	ra,72(sp)
    800019ac:	e0a2                	sd	s0,64(sp)
    800019ae:	fc26                	sd	s1,56(sp)
    800019b0:	f84a                	sd	s2,48(sp)
    800019b2:	f44e                	sd	s3,40(sp)
    800019b4:	f052                	sd	s4,32(sp)
    800019b6:	ec56                	sd	s5,24(sp)
    800019b8:	e85a                	sd	s6,16(sp)
    800019ba:	e45e                	sd	s7,8(sp)
    800019bc:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019be:	00006517          	auipc	a0,0x6
    800019c2:	68a50513          	add	a0,a0,1674 # 80008048 <etext+0x48>
    800019c6:	00004097          	auipc	ra,0x4
    800019ca:	27e080e7          	jalr	638(ra) # 80005c44 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ce:	00008497          	auipc	s1,0x8
    800019d2:	c0a48493          	add	s1,s1,-1014 # 800095d8 <proc+0x158>
    800019d6:	0000d917          	auipc	s2,0xd
    800019da:	60290913          	add	s2,s2,1538 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019de:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e0:	00007997          	auipc	s3,0x7
    800019e4:	82098993          	add	s3,s3,-2016 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e8:	00007a97          	auipc	s5,0x7
    800019ec:	820a8a93          	add	s5,s5,-2016 # 80008208 <etext+0x208>
    printf("\n");
    800019f0:	00006a17          	auipc	s4,0x6
    800019f4:	658a0a13          	add	s4,s4,1624 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f8:	00007b97          	auipc	s7,0x7
    800019fc:	848b8b93          	add	s7,s7,-1976 # 80008240 <states.0>
    80001a00:	a00d                	j	80001a22 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a02:	ed86a583          	lw	a1,-296(a3)
    80001a06:	8556                	mv	a0,s5
    80001a08:	00004097          	auipc	ra,0x4
    80001a0c:	23c080e7          	jalr	572(ra) # 80005c44 <printf>
    printf("\n");
    80001a10:	8552                	mv	a0,s4
    80001a12:	00004097          	auipc	ra,0x4
    80001a16:	232080e7          	jalr	562(ra) # 80005c44 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1a:	16848493          	add	s1,s1,360
    80001a1e:	03248263          	beq	s1,s2,80001a42 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a22:	86a6                	mv	a3,s1
    80001a24:	ec04a783          	lw	a5,-320(s1)
    80001a28:	dbed                	beqz	a5,80001a1a <procdump+0x72>
      state = "???";
    80001a2a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2c:	fcfb6be3          	bltu	s6,a5,80001a02 <procdump+0x5a>
    80001a30:	02079713          	sll	a4,a5,0x20
    80001a34:	01d75793          	srl	a5,a4,0x1d
    80001a38:	97de                	add	a5,a5,s7
    80001a3a:	6390                	ld	a2,0(a5)
    80001a3c:	f279                	bnez	a2,80001a02 <procdump+0x5a>
      state = "???";
    80001a3e:	864e                	mv	a2,s3
    80001a40:	b7c9                	j	80001a02 <procdump+0x5a>
  }
}
    80001a42:	60a6                	ld	ra,72(sp)
    80001a44:	6406                	ld	s0,64(sp)
    80001a46:	74e2                	ld	s1,56(sp)
    80001a48:	7942                	ld	s2,48(sp)
    80001a4a:	79a2                	ld	s3,40(sp)
    80001a4c:	7a02                	ld	s4,32(sp)
    80001a4e:	6ae2                	ld	s5,24(sp)
    80001a50:	6b42                	ld	s6,16(sp)
    80001a52:	6ba2                	ld	s7,8(sp)
    80001a54:	6161                	add	sp,sp,80
    80001a56:	8082                	ret

0000000080001a58 <nproc>:

// Return the number of processes whose state is not UNUSED
uint64
nproc(void)
{
    80001a58:	7179                	add	sp,sp,-48
    80001a5a:	f406                	sd	ra,40(sp)
    80001a5c:	f022                	sd	s0,32(sp)
    80001a5e:	ec26                	sd	s1,24(sp)
    80001a60:	e84a                	sd	s2,16(sp)
    80001a62:	e44e                	sd	s3,8(sp)
    80001a64:	1800                	add	s0,sp,48
  struct proc *p;
  // counting the number of processes
  uint64 num = 0;
    80001a66:	4901                	li	s2,0
  // traverse all processes
  for (p = proc; p < &proc[NPROC]; p++)
    80001a68:	00008497          	auipc	s1,0x8
    80001a6c:	a1848493          	add	s1,s1,-1512 # 80009480 <proc>
    80001a70:	0000d997          	auipc	s3,0xd
    80001a74:	41098993          	add	s3,s3,1040 # 8000ee80 <tickslock>
  {
    // add lock
    acquire(&p->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	00004097          	auipc	ra,0x4
    80001a7e:	6b8080e7          	jalr	1720(ra) # 80006132 <acquire>
    // if the processes's state is not UNUSED
    if (p->state != UNUSED)
    80001a82:	4c9c                	lw	a5,24(s1)
    {
      // the num add one
      num++;
    80001a84:	00f037b3          	snez	a5,a5
    80001a88:	993e                	add	s2,s2,a5
    }
    // release lock
    release(&p->lock);
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	00004097          	auipc	ra,0x4
    80001a90:	75a080e7          	jalr	1882(ra) # 800061e6 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a94:	16848493          	add	s1,s1,360
    80001a98:	ff3490e3          	bne	s1,s3,80001a78 <nproc+0x20>
  }
  return num;
}
    80001a9c:	854a                	mv	a0,s2
    80001a9e:	70a2                	ld	ra,40(sp)
    80001aa0:	7402                	ld	s0,32(sp)
    80001aa2:	64e2                	ld	s1,24(sp)
    80001aa4:	6942                	ld	s2,16(sp)
    80001aa6:	69a2                	ld	s3,8(sp)
    80001aa8:	6145                	add	sp,sp,48
    80001aaa:	8082                	ret

0000000080001aac <swtch>:
    80001aac:	00153023          	sd	ra,0(a0)
    80001ab0:	00253423          	sd	sp,8(a0)
    80001ab4:	e900                	sd	s0,16(a0)
    80001ab6:	ed04                	sd	s1,24(a0)
    80001ab8:	03253023          	sd	s2,32(a0)
    80001abc:	03353423          	sd	s3,40(a0)
    80001ac0:	03453823          	sd	s4,48(a0)
    80001ac4:	03553c23          	sd	s5,56(a0)
    80001ac8:	05653023          	sd	s6,64(a0)
    80001acc:	05753423          	sd	s7,72(a0)
    80001ad0:	05853823          	sd	s8,80(a0)
    80001ad4:	05953c23          	sd	s9,88(a0)
    80001ad8:	07a53023          	sd	s10,96(a0)
    80001adc:	07b53423          	sd	s11,104(a0)
    80001ae0:	0005b083          	ld	ra,0(a1)
    80001ae4:	0085b103          	ld	sp,8(a1)
    80001ae8:	6980                	ld	s0,16(a1)
    80001aea:	6d84                	ld	s1,24(a1)
    80001aec:	0205b903          	ld	s2,32(a1)
    80001af0:	0285b983          	ld	s3,40(a1)
    80001af4:	0305ba03          	ld	s4,48(a1)
    80001af8:	0385ba83          	ld	s5,56(a1)
    80001afc:	0405bb03          	ld	s6,64(a1)
    80001b00:	0485bb83          	ld	s7,72(a1)
    80001b04:	0505bc03          	ld	s8,80(a1)
    80001b08:	0585bc83          	ld	s9,88(a1)
    80001b0c:	0605bd03          	ld	s10,96(a1)
    80001b10:	0685bd83          	ld	s11,104(a1)
    80001b14:	8082                	ret

0000000080001b16 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b16:	1141                	add	sp,sp,-16
    80001b18:	e406                	sd	ra,8(sp)
    80001b1a:	e022                	sd	s0,0(sp)
    80001b1c:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001b1e:	00006597          	auipc	a1,0x6
    80001b22:	75258593          	add	a1,a1,1874 # 80008270 <states.0+0x30>
    80001b26:	0000d517          	auipc	a0,0xd
    80001b2a:	35a50513          	add	a0,a0,858 # 8000ee80 <tickslock>
    80001b2e:	00004097          	auipc	ra,0x4
    80001b32:	574080e7          	jalr	1396(ra) # 800060a2 <initlock>
}
    80001b36:	60a2                	ld	ra,8(sp)
    80001b38:	6402                	ld	s0,0(sp)
    80001b3a:	0141                	add	sp,sp,16
    80001b3c:	8082                	ret

0000000080001b3e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b3e:	1141                	add	sp,sp,-16
    80001b40:	e422                	sd	s0,8(sp)
    80001b42:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b44:	00003797          	auipc	a5,0x3
    80001b48:	51c78793          	add	a5,a5,1308 # 80005060 <kernelvec>
    80001b4c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b50:	6422                	ld	s0,8(sp)
    80001b52:	0141                	add	sp,sp,16
    80001b54:	8082                	ret

0000000080001b56 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b56:	1141                	add	sp,sp,-16
    80001b58:	e406                	sd	ra,8(sp)
    80001b5a:	e022                	sd	s0,0(sp)
    80001b5c:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001b5e:	fffff097          	auipc	ra,0xfffff
    80001b62:	32e080e7          	jalr	814(ra) # 80000e8c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b66:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b6a:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b70:	00005697          	auipc	a3,0x5
    80001b74:	49068693          	add	a3,a3,1168 # 80007000 <_trampoline>
    80001b78:	00005717          	auipc	a4,0x5
    80001b7c:	48870713          	add	a4,a4,1160 # 80007000 <_trampoline>
    80001b80:	8f15                	sub	a4,a4,a3
    80001b82:	040007b7          	lui	a5,0x4000
    80001b86:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b88:	07b2                	sll	a5,a5,0xc
    80001b8a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b8c:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b90:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b92:	18002673          	csrr	a2,satp
    80001b96:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b98:	6d30                	ld	a2,88(a0)
    80001b9a:	6138                	ld	a4,64(a0)
    80001b9c:	6585                	lui	a1,0x1
    80001b9e:	972e                	add	a4,a4,a1
    80001ba0:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ba2:	6d38                	ld	a4,88(a0)
    80001ba4:	00000617          	auipc	a2,0x0
    80001ba8:	13c60613          	add	a2,a2,316 # 80001ce0 <usertrap>
    80001bac:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bae:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bb0:	8612                	mv	a2,tp
    80001bb2:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb4:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bb8:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bbc:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bc4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bc6:	6f18                	ld	a4,24(a4)
    80001bc8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bcc:	692c                	ld	a1,80(a0)
    80001bce:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bd0:	00005717          	auipc	a4,0x5
    80001bd4:	4c070713          	add	a4,a4,1216 # 80007090 <userret>
    80001bd8:	8f15                	sub	a4,a4,a3
    80001bda:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bdc:	577d                	li	a4,-1
    80001bde:	177e                	sll	a4,a4,0x3f
    80001be0:	8dd9                	or	a1,a1,a4
    80001be2:	02000537          	lui	a0,0x2000
    80001be6:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001be8:	0536                	sll	a0,a0,0xd
    80001bea:	9782                	jalr	a5
}
    80001bec:	60a2                	ld	ra,8(sp)
    80001bee:	6402                	ld	s0,0(sp)
    80001bf0:	0141                	add	sp,sp,16
    80001bf2:	8082                	ret

0000000080001bf4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bf4:	1101                	add	sp,sp,-32
    80001bf6:	ec06                	sd	ra,24(sp)
    80001bf8:	e822                	sd	s0,16(sp)
    80001bfa:	e426                	sd	s1,8(sp)
    80001bfc:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001bfe:	0000d497          	auipc	s1,0xd
    80001c02:	28248493          	add	s1,s1,642 # 8000ee80 <tickslock>
    80001c06:	8526                	mv	a0,s1
    80001c08:	00004097          	auipc	ra,0x4
    80001c0c:	52a080e7          	jalr	1322(ra) # 80006132 <acquire>
  ticks++;
    80001c10:	00007517          	auipc	a0,0x7
    80001c14:	40850513          	add	a0,a0,1032 # 80009018 <ticks>
    80001c18:	411c                	lw	a5,0(a0)
    80001c1a:	2785                	addw	a5,a5,1
    80001c1c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c1e:	00000097          	auipc	ra,0x0
    80001c22:	ac6080e7          	jalr	-1338(ra) # 800016e4 <wakeup>
  release(&tickslock);
    80001c26:	8526                	mv	a0,s1
    80001c28:	00004097          	auipc	ra,0x4
    80001c2c:	5be080e7          	jalr	1470(ra) # 800061e6 <release>
}
    80001c30:	60e2                	ld	ra,24(sp)
    80001c32:	6442                	ld	s0,16(sp)
    80001c34:	64a2                	ld	s1,8(sp)
    80001c36:	6105                	add	sp,sp,32
    80001c38:	8082                	ret

0000000080001c3a <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c3a:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c3e:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c40:	0807df63          	bgez	a5,80001cde <devintr+0xa4>
{
    80001c44:	1101                	add	sp,sp,-32
    80001c46:	ec06                	sd	ra,24(sp)
    80001c48:	e822                	sd	s0,16(sp)
    80001c4a:	e426                	sd	s1,8(sp)
    80001c4c:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001c4e:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c52:	46a5                	li	a3,9
    80001c54:	00d70d63          	beq	a4,a3,80001c6e <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001c58:	577d                	li	a4,-1
    80001c5a:	177e                	sll	a4,a4,0x3f
    80001c5c:	0705                	add	a4,a4,1
    return 0;
    80001c5e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c60:	04e78e63          	beq	a5,a4,80001cbc <devintr+0x82>
  }
}
    80001c64:	60e2                	ld	ra,24(sp)
    80001c66:	6442                	ld	s0,16(sp)
    80001c68:	64a2                	ld	s1,8(sp)
    80001c6a:	6105                	add	sp,sp,32
    80001c6c:	8082                	ret
    int irq = plic_claim();
    80001c6e:	00003097          	auipc	ra,0x3
    80001c72:	4fa080e7          	jalr	1274(ra) # 80005168 <plic_claim>
    80001c76:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c78:	47a9                	li	a5,10
    80001c7a:	02f50763          	beq	a0,a5,80001ca8 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001c7e:	4785                	li	a5,1
    80001c80:	02f50963          	beq	a0,a5,80001cb2 <devintr+0x78>
    return 1;
    80001c84:	4505                	li	a0,1
    } else if(irq){
    80001c86:	dcf9                	beqz	s1,80001c64 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c88:	85a6                	mv	a1,s1
    80001c8a:	00006517          	auipc	a0,0x6
    80001c8e:	5ee50513          	add	a0,a0,1518 # 80008278 <states.0+0x38>
    80001c92:	00004097          	auipc	ra,0x4
    80001c96:	fb2080e7          	jalr	-78(ra) # 80005c44 <printf>
      plic_complete(irq);
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	00003097          	auipc	ra,0x3
    80001ca0:	4f0080e7          	jalr	1264(ra) # 8000518c <plic_complete>
    return 1;
    80001ca4:	4505                	li	a0,1
    80001ca6:	bf7d                	j	80001c64 <devintr+0x2a>
      uartintr();
    80001ca8:	00004097          	auipc	ra,0x4
    80001cac:	3aa080e7          	jalr	938(ra) # 80006052 <uartintr>
    if(irq)
    80001cb0:	b7ed                	j	80001c9a <devintr+0x60>
      virtio_disk_intr();
    80001cb2:	00004097          	auipc	ra,0x4
    80001cb6:	964080e7          	jalr	-1692(ra) # 80005616 <virtio_disk_intr>
    if(irq)
    80001cba:	b7c5                	j	80001c9a <devintr+0x60>
    if(cpuid() == 0){
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	1a4080e7          	jalr	420(ra) # 80000e60 <cpuid>
    80001cc4:	c901                	beqz	a0,80001cd4 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cc6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cca:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ccc:	14479073          	csrw	sip,a5
    return 2;
    80001cd0:	4509                	li	a0,2
    80001cd2:	bf49                	j	80001c64 <devintr+0x2a>
      clockintr();
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	f20080e7          	jalr	-224(ra) # 80001bf4 <clockintr>
    80001cdc:	b7ed                	j	80001cc6 <devintr+0x8c>
}
    80001cde:	8082                	ret

0000000080001ce0 <usertrap>:
{
    80001ce0:	1101                	add	sp,sp,-32
    80001ce2:	ec06                	sd	ra,24(sp)
    80001ce4:	e822                	sd	s0,16(sp)
    80001ce6:	e426                	sd	s1,8(sp)
    80001ce8:	e04a                	sd	s2,0(sp)
    80001cea:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cec:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf0:	1007f793          	and	a5,a5,256
    80001cf4:	e3ad                	bnez	a5,80001d56 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf6:	00003797          	auipc	a5,0x3
    80001cfa:	36a78793          	add	a5,a5,874 # 80005060 <kernelvec>
    80001cfe:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d02:	fffff097          	auipc	ra,0xfffff
    80001d06:	18a080e7          	jalr	394(ra) # 80000e8c <myproc>
    80001d0a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d0c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d0e:	14102773          	csrr	a4,sepc
    80001d12:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d14:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d18:	47a1                	li	a5,8
    80001d1a:	04f71c63          	bne	a4,a5,80001d72 <usertrap+0x92>
    if(p->killed)
    80001d1e:	551c                	lw	a5,40(a0)
    80001d20:	e3b9                	bnez	a5,80001d66 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d22:	6cb8                	ld	a4,88(s1)
    80001d24:	6f1c                	ld	a5,24(a4)
    80001d26:	0791                	add	a5,a5,4
    80001d28:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d2e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d32:	10079073          	csrw	sstatus,a5
    syscall();
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	2e0080e7          	jalr	736(ra) # 80002016 <syscall>
  if(p->killed)
    80001d3e:	549c                	lw	a5,40(s1)
    80001d40:	ebc1                	bnez	a5,80001dd0 <usertrap+0xf0>
  usertrapret();
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	e14080e7          	jalr	-492(ra) # 80001b56 <usertrapret>
}
    80001d4a:	60e2                	ld	ra,24(sp)
    80001d4c:	6442                	ld	s0,16(sp)
    80001d4e:	64a2                	ld	s1,8(sp)
    80001d50:	6902                	ld	s2,0(sp)
    80001d52:	6105                	add	sp,sp,32
    80001d54:	8082                	ret
    panic("usertrap: not from user mode");
    80001d56:	00006517          	auipc	a0,0x6
    80001d5a:	54250513          	add	a0,a0,1346 # 80008298 <states.0+0x58>
    80001d5e:	00004097          	auipc	ra,0x4
    80001d62:	e9c080e7          	jalr	-356(ra) # 80005bfa <panic>
      exit(-1);
    80001d66:	557d                	li	a0,-1
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	a4c080e7          	jalr	-1460(ra) # 800017b4 <exit>
    80001d70:	bf4d                	j	80001d22 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d72:	00000097          	auipc	ra,0x0
    80001d76:	ec8080e7          	jalr	-312(ra) # 80001c3a <devintr>
    80001d7a:	892a                	mv	s2,a0
    80001d7c:	c501                	beqz	a0,80001d84 <usertrap+0xa4>
  if(p->killed)
    80001d7e:	549c                	lw	a5,40(s1)
    80001d80:	c3a1                	beqz	a5,80001dc0 <usertrap+0xe0>
    80001d82:	a815                	j	80001db6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d84:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d88:	5890                	lw	a2,48(s1)
    80001d8a:	00006517          	auipc	a0,0x6
    80001d8e:	52e50513          	add	a0,a0,1326 # 800082b8 <states.0+0x78>
    80001d92:	00004097          	auipc	ra,0x4
    80001d96:	eb2080e7          	jalr	-334(ra) # 80005c44 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d9a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d9e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001da2:	00006517          	auipc	a0,0x6
    80001da6:	54650513          	add	a0,a0,1350 # 800082e8 <states.0+0xa8>
    80001daa:	00004097          	auipc	ra,0x4
    80001dae:	e9a080e7          	jalr	-358(ra) # 80005c44 <printf>
    p->killed = 1;
    80001db2:	4785                	li	a5,1
    80001db4:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001db6:	557d                	li	a0,-1
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	9fc080e7          	jalr	-1540(ra) # 800017b4 <exit>
  if(which_dev == 2)
    80001dc0:	4789                	li	a5,2
    80001dc2:	f8f910e3          	bne	s2,a5,80001d42 <usertrap+0x62>
    yield();
    80001dc6:	fffff097          	auipc	ra,0xfffff
    80001dca:	756080e7          	jalr	1878(ra) # 8000151c <yield>
    80001dce:	bf95                	j	80001d42 <usertrap+0x62>
  int which_dev = 0;
    80001dd0:	4901                	li	s2,0
    80001dd2:	b7d5                	j	80001db6 <usertrap+0xd6>

0000000080001dd4 <kerneltrap>:
{
    80001dd4:	7179                	add	sp,sp,-48
    80001dd6:	f406                	sd	ra,40(sp)
    80001dd8:	f022                	sd	s0,32(sp)
    80001dda:	ec26                	sd	s1,24(sp)
    80001ddc:	e84a                	sd	s2,16(sp)
    80001dde:	e44e                	sd	s3,8(sp)
    80001de0:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dea:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dee:	1004f793          	and	a5,s1,256
    80001df2:	cb85                	beqz	a5,80001e22 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001df8:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001dfa:	ef85                	bnez	a5,80001e32 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dfc:	00000097          	auipc	ra,0x0
    80001e00:	e3e080e7          	jalr	-450(ra) # 80001c3a <devintr>
    80001e04:	cd1d                	beqz	a0,80001e42 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e06:	4789                	li	a5,2
    80001e08:	06f50a63          	beq	a0,a5,80001e7c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e0c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e10:	10049073          	csrw	sstatus,s1
}
    80001e14:	70a2                	ld	ra,40(sp)
    80001e16:	7402                	ld	s0,32(sp)
    80001e18:	64e2                	ld	s1,24(sp)
    80001e1a:	6942                	ld	s2,16(sp)
    80001e1c:	69a2                	ld	s3,8(sp)
    80001e1e:	6145                	add	sp,sp,48
    80001e20:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e22:	00006517          	auipc	a0,0x6
    80001e26:	4e650513          	add	a0,a0,1254 # 80008308 <states.0+0xc8>
    80001e2a:	00004097          	auipc	ra,0x4
    80001e2e:	dd0080e7          	jalr	-560(ra) # 80005bfa <panic>
    panic("kerneltrap: interrupts enabled");
    80001e32:	00006517          	auipc	a0,0x6
    80001e36:	4fe50513          	add	a0,a0,1278 # 80008330 <states.0+0xf0>
    80001e3a:	00004097          	auipc	ra,0x4
    80001e3e:	dc0080e7          	jalr	-576(ra) # 80005bfa <panic>
    printf("scause %p\n", scause);
    80001e42:	85ce                	mv	a1,s3
    80001e44:	00006517          	auipc	a0,0x6
    80001e48:	50c50513          	add	a0,a0,1292 # 80008350 <states.0+0x110>
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	df8080e7          	jalr	-520(ra) # 80005c44 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e54:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e58:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e5c:	00006517          	auipc	a0,0x6
    80001e60:	50450513          	add	a0,a0,1284 # 80008360 <states.0+0x120>
    80001e64:	00004097          	auipc	ra,0x4
    80001e68:	de0080e7          	jalr	-544(ra) # 80005c44 <printf>
    panic("kerneltrap");
    80001e6c:	00006517          	auipc	a0,0x6
    80001e70:	50c50513          	add	a0,a0,1292 # 80008378 <states.0+0x138>
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	d86080e7          	jalr	-634(ra) # 80005bfa <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e7c:	fffff097          	auipc	ra,0xfffff
    80001e80:	010080e7          	jalr	16(ra) # 80000e8c <myproc>
    80001e84:	d541                	beqz	a0,80001e0c <kerneltrap+0x38>
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	006080e7          	jalr	6(ra) # 80000e8c <myproc>
    80001e8e:	4d18                	lw	a4,24(a0)
    80001e90:	4791                	li	a5,4
    80001e92:	f6f71de3          	bne	a4,a5,80001e0c <kerneltrap+0x38>
    yield();
    80001e96:	fffff097          	auipc	ra,0xfffff
    80001e9a:	686080e7          	jalr	1670(ra) # 8000151c <yield>
    80001e9e:	b7bd                	j	80001e0c <kerneltrap+0x38>

0000000080001ea0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ea0:	1101                	add	sp,sp,-32
    80001ea2:	ec06                	sd	ra,24(sp)
    80001ea4:	e822                	sd	s0,16(sp)
    80001ea6:	e426                	sd	s1,8(sp)
    80001ea8:	1000                	add	s0,sp,32
    80001eaa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	fe0080e7          	jalr	-32(ra) # 80000e8c <myproc>
  switch (n) {
    80001eb4:	4795                	li	a5,5
    80001eb6:	0497e163          	bltu	a5,s1,80001ef8 <argraw+0x58>
    80001eba:	048a                	sll	s1,s1,0x2
    80001ebc:	00006717          	auipc	a4,0x6
    80001ec0:	5bc70713          	add	a4,a4,1468 # 80008478 <states.0+0x238>
    80001ec4:	94ba                	add	s1,s1,a4
    80001ec6:	409c                	lw	a5,0(s1)
    80001ec8:	97ba                	add	a5,a5,a4
    80001eca:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ecc:	6d3c                	ld	a5,88(a0)
    80001ece:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ed0:	60e2                	ld	ra,24(sp)
    80001ed2:	6442                	ld	s0,16(sp)
    80001ed4:	64a2                	ld	s1,8(sp)
    80001ed6:	6105                	add	sp,sp,32
    80001ed8:	8082                	ret
    return p->trapframe->a1;
    80001eda:	6d3c                	ld	a5,88(a0)
    80001edc:	7fa8                	ld	a0,120(a5)
    80001ede:	bfcd                	j	80001ed0 <argraw+0x30>
    return p->trapframe->a2;
    80001ee0:	6d3c                	ld	a5,88(a0)
    80001ee2:	63c8                	ld	a0,128(a5)
    80001ee4:	b7f5                	j	80001ed0 <argraw+0x30>
    return p->trapframe->a3;
    80001ee6:	6d3c                	ld	a5,88(a0)
    80001ee8:	67c8                	ld	a0,136(a5)
    80001eea:	b7dd                	j	80001ed0 <argraw+0x30>
    return p->trapframe->a4;
    80001eec:	6d3c                	ld	a5,88(a0)
    80001eee:	6bc8                	ld	a0,144(a5)
    80001ef0:	b7c5                	j	80001ed0 <argraw+0x30>
    return p->trapframe->a5;
    80001ef2:	6d3c                	ld	a5,88(a0)
    80001ef4:	6fc8                	ld	a0,152(a5)
    80001ef6:	bfe9                	j	80001ed0 <argraw+0x30>
  panic("argraw");
    80001ef8:	00006517          	auipc	a0,0x6
    80001efc:	49050513          	add	a0,a0,1168 # 80008388 <states.0+0x148>
    80001f00:	00004097          	auipc	ra,0x4
    80001f04:	cfa080e7          	jalr	-774(ra) # 80005bfa <panic>

0000000080001f08 <fetchaddr>:
{
    80001f08:	1101                	add	sp,sp,-32
    80001f0a:	ec06                	sd	ra,24(sp)
    80001f0c:	e822                	sd	s0,16(sp)
    80001f0e:	e426                	sd	s1,8(sp)
    80001f10:	e04a                	sd	s2,0(sp)
    80001f12:	1000                	add	s0,sp,32
    80001f14:	84aa                	mv	s1,a0
    80001f16:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	f74080e7          	jalr	-140(ra) # 80000e8c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f20:	653c                	ld	a5,72(a0)
    80001f22:	02f4f863          	bgeu	s1,a5,80001f52 <fetchaddr+0x4a>
    80001f26:	00848713          	add	a4,s1,8
    80001f2a:	02e7e663          	bltu	a5,a4,80001f56 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f2e:	46a1                	li	a3,8
    80001f30:	8626                	mv	a2,s1
    80001f32:	85ca                	mv	a1,s2
    80001f34:	6928                	ld	a0,80(a0)
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	ca6080e7          	jalr	-858(ra) # 80000bdc <copyin>
    80001f3e:	00a03533          	snez	a0,a0
    80001f42:	40a00533          	neg	a0,a0
}
    80001f46:	60e2                	ld	ra,24(sp)
    80001f48:	6442                	ld	s0,16(sp)
    80001f4a:	64a2                	ld	s1,8(sp)
    80001f4c:	6902                	ld	s2,0(sp)
    80001f4e:	6105                	add	sp,sp,32
    80001f50:	8082                	ret
    return -1;
    80001f52:	557d                	li	a0,-1
    80001f54:	bfcd                	j	80001f46 <fetchaddr+0x3e>
    80001f56:	557d                	li	a0,-1
    80001f58:	b7fd                	j	80001f46 <fetchaddr+0x3e>

0000000080001f5a <fetchstr>:
{
    80001f5a:	7179                	add	sp,sp,-48
    80001f5c:	f406                	sd	ra,40(sp)
    80001f5e:	f022                	sd	s0,32(sp)
    80001f60:	ec26                	sd	s1,24(sp)
    80001f62:	e84a                	sd	s2,16(sp)
    80001f64:	e44e                	sd	s3,8(sp)
    80001f66:	1800                	add	s0,sp,48
    80001f68:	892a                	mv	s2,a0
    80001f6a:	84ae                	mv	s1,a1
    80001f6c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f6e:	fffff097          	auipc	ra,0xfffff
    80001f72:	f1e080e7          	jalr	-226(ra) # 80000e8c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f76:	86ce                	mv	a3,s3
    80001f78:	864a                	mv	a2,s2
    80001f7a:	85a6                	mv	a1,s1
    80001f7c:	6928                	ld	a0,80(a0)
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	cec080e7          	jalr	-788(ra) # 80000c6a <copyinstr>
  if(err < 0)
    80001f86:	00054763          	bltz	a0,80001f94 <fetchstr+0x3a>
  return strlen(buf);
    80001f8a:	8526                	mv	a0,s1
    80001f8c:	ffffe097          	auipc	ra,0xffffe
    80001f90:	3b2080e7          	jalr	946(ra) # 8000033e <strlen>
}
    80001f94:	70a2                	ld	ra,40(sp)
    80001f96:	7402                	ld	s0,32(sp)
    80001f98:	64e2                	ld	s1,24(sp)
    80001f9a:	6942                	ld	s2,16(sp)
    80001f9c:	69a2                	ld	s3,8(sp)
    80001f9e:	6145                	add	sp,sp,48
    80001fa0:	8082                	ret

0000000080001fa2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fa2:	1101                	add	sp,sp,-32
    80001fa4:	ec06                	sd	ra,24(sp)
    80001fa6:	e822                	sd	s0,16(sp)
    80001fa8:	e426                	sd	s1,8(sp)
    80001faa:	1000                	add	s0,sp,32
    80001fac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fae:	00000097          	auipc	ra,0x0
    80001fb2:	ef2080e7          	jalr	-270(ra) # 80001ea0 <argraw>
    80001fb6:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fb8:	4501                	li	a0,0
    80001fba:	60e2                	ld	ra,24(sp)
    80001fbc:	6442                	ld	s0,16(sp)
    80001fbe:	64a2                	ld	s1,8(sp)
    80001fc0:	6105                	add	sp,sp,32
    80001fc2:	8082                	ret

0000000080001fc4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fc4:	1101                	add	sp,sp,-32
    80001fc6:	ec06                	sd	ra,24(sp)
    80001fc8:	e822                	sd	s0,16(sp)
    80001fca:	e426                	sd	s1,8(sp)
    80001fcc:	1000                	add	s0,sp,32
    80001fce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	ed0080e7          	jalr	-304(ra) # 80001ea0 <argraw>
    80001fd8:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fda:	4501                	li	a0,0
    80001fdc:	60e2                	ld	ra,24(sp)
    80001fde:	6442                	ld	s0,16(sp)
    80001fe0:	64a2                	ld	s1,8(sp)
    80001fe2:	6105                	add	sp,sp,32
    80001fe4:	8082                	ret

0000000080001fe6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fe6:	1101                	add	sp,sp,-32
    80001fe8:	ec06                	sd	ra,24(sp)
    80001fea:	e822                	sd	s0,16(sp)
    80001fec:	e426                	sd	s1,8(sp)
    80001fee:	e04a                	sd	s2,0(sp)
    80001ff0:	1000                	add	s0,sp,32
    80001ff2:	84ae                	mv	s1,a1
    80001ff4:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001ff6:	00000097          	auipc	ra,0x0
    80001ffa:	eaa080e7          	jalr	-342(ra) # 80001ea0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001ffe:	864a                	mv	a2,s2
    80002000:	85a6                	mv	a1,s1
    80002002:	00000097          	auipc	ra,0x0
    80002006:	f58080e7          	jalr	-168(ra) # 80001f5a <fetchstr>
}
    8000200a:	60e2                	ld	ra,24(sp)
    8000200c:	6442                	ld	s0,16(sp)
    8000200e:	64a2                	ld	s1,8(sp)
    80002010:	6902                	ld	s2,0(sp)
    80002012:	6105                	add	sp,sp,32
    80002014:	8082                	ret

0000000080002016 <syscall>:
  "open", "write", "mknod", "unlink", "link", 
  "mkdir", "close", "trace", "sysinfo"};

void
syscall(void)
{
    80002016:	7179                	add	sp,sp,-48
    80002018:	f406                	sd	ra,40(sp)
    8000201a:	f022                	sd	s0,32(sp)
    8000201c:	ec26                	sd	s1,24(sp)
    8000201e:	e84a                	sd	s2,16(sp)
    80002020:	e44e                	sd	s3,8(sp)
    80002022:	1800                	add	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	e68080e7          	jalr	-408(ra) # 80000e8c <myproc>
    8000202c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;//读取系统调用号，用户级进程将系统调用号存在a7寄存器中，内核级进程从a7寄存器中读取系统调用号，执行后将返回值存在a0寄存器中
    8000202e:	05853903          	ld	s2,88(a0)
    80002032:	0a893783          	ld	a5,168(s2)
    80002036:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000203a:	37fd                	addw	a5,a5,-1
    8000203c:	4759                	li	a4,22
    8000203e:	04f76663          	bltu	a4,a5,8000208a <syscall+0x74>
    80002042:	00399713          	sll	a4,s3,0x3
    80002046:	00006797          	auipc	a5,0x6
    8000204a:	44a78793          	add	a5,a5,1098 # 80008490 <syscalls>
    8000204e:	97ba                	add	a5,a5,a4
    80002050:	639c                	ld	a5,0(a5)
    80002052:	cf85                	beqz	a5,8000208a <syscall+0x74>
    p->trapframe->a0 = syscalls[num]();
    80002054:	9782                	jalr	a5
    80002056:	06a93823          	sd	a0,112(s2)
    if((1 << num) & p->mask) {//mask默认为0，只有trace可以设置mask的值
    8000205a:	58dc                	lw	a5,52(s1)
    8000205c:	4137d7bb          	sraw	a5,a5,s3
    80002060:	8b85                	and	a5,a5,1
    80002062:	c3b9                	beqz	a5,800020a8 <syscall+0x92>
      //  进程号  系统调用名  ->  返回值
      printf("%d: syscall %s -> %d\n", p->pid, syscall_names[num], p->trapframe->a0);
    80002064:	6cb8                	ld	a4,88(s1)
    80002066:	098e                	sll	s3,s3,0x3
    80002068:	00006797          	auipc	a5,0x6
    8000206c:	42878793          	add	a5,a5,1064 # 80008490 <syscalls>
    80002070:	97ce                	add	a5,a5,s3
    80002072:	7b34                	ld	a3,112(a4)
    80002074:	63f0                	ld	a2,192(a5)
    80002076:	588c                	lw	a1,48(s1)
    80002078:	00006517          	auipc	a0,0x6
    8000207c:	31850513          	add	a0,a0,792 # 80008390 <states.0+0x150>
    80002080:	00004097          	auipc	ra,0x4
    80002084:	bc4080e7          	jalr	-1084(ra) # 80005c44 <printf>
    80002088:	a005                	j	800020a8 <syscall+0x92>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000208a:	86ce                	mv	a3,s3
    8000208c:	15848613          	add	a2,s1,344
    80002090:	588c                	lw	a1,48(s1)
    80002092:	00006517          	auipc	a0,0x6
    80002096:	31650513          	add	a0,a0,790 # 800083a8 <states.0+0x168>
    8000209a:	00004097          	auipc	ra,0x4
    8000209e:	baa080e7          	jalr	-1110(ra) # 80005c44 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020a2:	6cbc                	ld	a5,88(s1)
    800020a4:	577d                	li	a4,-1
    800020a6:	fbb8                	sd	a4,112(a5)
  }
}
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6942                	ld	s2,16(sp)
    800020b0:	69a2                	ld	s3,8(sp)
    800020b2:	6145                	add	sp,sp,48
    800020b4:	8082                	ret

00000000800020b6 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    800020b6:	1101                	add	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	1000                	add	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020be:	fec40593          	add	a1,s0,-20
    800020c2:	4501                	li	a0,0
    800020c4:	00000097          	auipc	ra,0x0
    800020c8:	ede080e7          	jalr	-290(ra) # 80001fa2 <argint>
    return -1;
    800020cc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020ce:	00054963          	bltz	a0,800020e0 <sys_exit+0x2a>
  exit(n);
    800020d2:	fec42503          	lw	a0,-20(s0)
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	6de080e7          	jalr	1758(ra) # 800017b4 <exit>
  return 0;  // not reached
    800020de:	4781                	li	a5,0
}
    800020e0:	853e                	mv	a0,a5
    800020e2:	60e2                	ld	ra,24(sp)
    800020e4:	6442                	ld	s0,16(sp)
    800020e6:	6105                	add	sp,sp,32
    800020e8:	8082                	ret

00000000800020ea <sys_getpid>:

uint64
sys_getpid(void)
{
    800020ea:	1141                	add	sp,sp,-16
    800020ec:	e406                	sd	ra,8(sp)
    800020ee:	e022                	sd	s0,0(sp)
    800020f0:	0800                	add	s0,sp,16
  return myproc()->pid;
    800020f2:	fffff097          	auipc	ra,0xfffff
    800020f6:	d9a080e7          	jalr	-614(ra) # 80000e8c <myproc>
}
    800020fa:	5908                	lw	a0,48(a0)
    800020fc:	60a2                	ld	ra,8(sp)
    800020fe:	6402                	ld	s0,0(sp)
    80002100:	0141                	add	sp,sp,16
    80002102:	8082                	ret

0000000080002104 <sys_fork>:

uint64
sys_fork(void)
{
    80002104:	1141                	add	sp,sp,-16
    80002106:	e406                	sd	ra,8(sp)
    80002108:	e022                	sd	s0,0(sp)
    8000210a:	0800                	add	s0,sp,16
  return fork();
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	152080e7          	jalr	338(ra) # 8000125e <fork>
}
    80002114:	60a2                	ld	ra,8(sp)
    80002116:	6402                	ld	s0,0(sp)
    80002118:	0141                	add	sp,sp,16
    8000211a:	8082                	ret

000000008000211c <sys_wait>:

uint64
sys_wait(void)
{
    8000211c:	1101                	add	sp,sp,-32
    8000211e:	ec06                	sd	ra,24(sp)
    80002120:	e822                	sd	s0,16(sp)
    80002122:	1000                	add	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002124:	fe840593          	add	a1,s0,-24
    80002128:	4501                	li	a0,0
    8000212a:	00000097          	auipc	ra,0x0
    8000212e:	e9a080e7          	jalr	-358(ra) # 80001fc4 <argaddr>
    80002132:	87aa                	mv	a5,a0
    return -1;
    80002134:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002136:	0007c863          	bltz	a5,80002146 <sys_wait+0x2a>
  return wait(p);
    8000213a:	fe843503          	ld	a0,-24(s0)
    8000213e:	fffff097          	auipc	ra,0xfffff
    80002142:	47e080e7          	jalr	1150(ra) # 800015bc <wait>
}
    80002146:	60e2                	ld	ra,24(sp)
    80002148:	6442                	ld	s0,16(sp)
    8000214a:	6105                	add	sp,sp,32
    8000214c:	8082                	ret

000000008000214e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000214e:	7179                	add	sp,sp,-48
    80002150:	f406                	sd	ra,40(sp)
    80002152:	f022                	sd	s0,32(sp)
    80002154:	ec26                	sd	s1,24(sp)
    80002156:	1800                	add	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002158:	fdc40593          	add	a1,s0,-36
    8000215c:	4501                	li	a0,0
    8000215e:	00000097          	auipc	ra,0x0
    80002162:	e44080e7          	jalr	-444(ra) # 80001fa2 <argint>
    80002166:	87aa                	mv	a5,a0
    return -1;
    80002168:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000216a:	0207c063          	bltz	a5,8000218a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	d1e080e7          	jalr	-738(ra) # 80000e8c <myproc>
    80002176:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002178:	fdc42503          	lw	a0,-36(s0)
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	06a080e7          	jalr	106(ra) # 800011e6 <growproc>
    80002184:	00054863          	bltz	a0,80002194 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002188:	8526                	mv	a0,s1
}
    8000218a:	70a2                	ld	ra,40(sp)
    8000218c:	7402                	ld	s0,32(sp)
    8000218e:	64e2                	ld	s1,24(sp)
    80002190:	6145                	add	sp,sp,48
    80002192:	8082                	ret
    return -1;
    80002194:	557d                	li	a0,-1
    80002196:	bfd5                	j	8000218a <sys_sbrk+0x3c>

0000000080002198 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002198:	7139                	add	sp,sp,-64
    8000219a:	fc06                	sd	ra,56(sp)
    8000219c:	f822                	sd	s0,48(sp)
    8000219e:	f426                	sd	s1,40(sp)
    800021a0:	f04a                	sd	s2,32(sp)
    800021a2:	ec4e                	sd	s3,24(sp)
    800021a4:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021a6:	fcc40593          	add	a1,s0,-52
    800021aa:	4501                	li	a0,0
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	df6080e7          	jalr	-522(ra) # 80001fa2 <argint>
    return -1;
    800021b4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021b6:	06054563          	bltz	a0,80002220 <sys_sleep+0x88>
  acquire(&tickslock);
    800021ba:	0000d517          	auipc	a0,0xd
    800021be:	cc650513          	add	a0,a0,-826 # 8000ee80 <tickslock>
    800021c2:	00004097          	auipc	ra,0x4
    800021c6:	f70080e7          	jalr	-144(ra) # 80006132 <acquire>
  ticks0 = ticks;
    800021ca:	00007917          	auipc	s2,0x7
    800021ce:	e4e92903          	lw	s2,-434(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021d2:	fcc42783          	lw	a5,-52(s0)
    800021d6:	cf85                	beqz	a5,8000220e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021d8:	0000d997          	auipc	s3,0xd
    800021dc:	ca898993          	add	s3,s3,-856 # 8000ee80 <tickslock>
    800021e0:	00007497          	auipc	s1,0x7
    800021e4:	e3848493          	add	s1,s1,-456 # 80009018 <ticks>
    if(myproc()->killed){
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	ca4080e7          	jalr	-860(ra) # 80000e8c <myproc>
    800021f0:	551c                	lw	a5,40(a0)
    800021f2:	ef9d                	bnez	a5,80002230 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021f4:	85ce                	mv	a1,s3
    800021f6:	8526                	mv	a0,s1
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	360080e7          	jalr	864(ra) # 80001558 <sleep>
  while(ticks - ticks0 < n){
    80002200:	409c                	lw	a5,0(s1)
    80002202:	412787bb          	subw	a5,a5,s2
    80002206:	fcc42703          	lw	a4,-52(s0)
    8000220a:	fce7efe3          	bltu	a5,a4,800021e8 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000220e:	0000d517          	auipc	a0,0xd
    80002212:	c7250513          	add	a0,a0,-910 # 8000ee80 <tickslock>
    80002216:	00004097          	auipc	ra,0x4
    8000221a:	fd0080e7          	jalr	-48(ra) # 800061e6 <release>
  return 0;
    8000221e:	4781                	li	a5,0
}
    80002220:	853e                	mv	a0,a5
    80002222:	70e2                	ld	ra,56(sp)
    80002224:	7442                	ld	s0,48(sp)
    80002226:	74a2                	ld	s1,40(sp)
    80002228:	7902                	ld	s2,32(sp)
    8000222a:	69e2                	ld	s3,24(sp)
    8000222c:	6121                	add	sp,sp,64
    8000222e:	8082                	ret
      release(&tickslock);
    80002230:	0000d517          	auipc	a0,0xd
    80002234:	c5050513          	add	a0,a0,-944 # 8000ee80 <tickslock>
    80002238:	00004097          	auipc	ra,0x4
    8000223c:	fae080e7          	jalr	-82(ra) # 800061e6 <release>
      return -1;
    80002240:	57fd                	li	a5,-1
    80002242:	bff9                	j	80002220 <sys_sleep+0x88>

0000000080002244 <sys_kill>:

uint64
sys_kill(void)
{
    80002244:	1101                	add	sp,sp,-32
    80002246:	ec06                	sd	ra,24(sp)
    80002248:	e822                	sd	s0,16(sp)
    8000224a:	1000                	add	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000224c:	fec40593          	add	a1,s0,-20
    80002250:	4501                	li	a0,0
    80002252:	00000097          	auipc	ra,0x0
    80002256:	d50080e7          	jalr	-688(ra) # 80001fa2 <argint>
    8000225a:	87aa                	mv	a5,a0
    return -1;
    8000225c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000225e:	0007c863          	bltz	a5,8000226e <sys_kill+0x2a>
  return kill(pid);
    80002262:	fec42503          	lw	a0,-20(s0)
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	624080e7          	jalr	1572(ra) # 8000188a <kill>
}
    8000226e:	60e2                	ld	ra,24(sp)
    80002270:	6442                	ld	s0,16(sp)
    80002272:	6105                	add	sp,sp,32
    80002274:	8082                	ret

0000000080002276 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002276:	1101                	add	sp,sp,-32
    80002278:	ec06                	sd	ra,24(sp)
    8000227a:	e822                	sd	s0,16(sp)
    8000227c:	e426                	sd	s1,8(sp)
    8000227e:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002280:	0000d517          	auipc	a0,0xd
    80002284:	c0050513          	add	a0,a0,-1024 # 8000ee80 <tickslock>
    80002288:	00004097          	auipc	ra,0x4
    8000228c:	eaa080e7          	jalr	-342(ra) # 80006132 <acquire>
  xticks = ticks;
    80002290:	00007497          	auipc	s1,0x7
    80002294:	d884a483          	lw	s1,-632(s1) # 80009018 <ticks>
  release(&tickslock);
    80002298:	0000d517          	auipc	a0,0xd
    8000229c:	be850513          	add	a0,a0,-1048 # 8000ee80 <tickslock>
    800022a0:	00004097          	auipc	ra,0x4
    800022a4:	f46080e7          	jalr	-186(ra) # 800061e6 <release>
  return xticks;
}
    800022a8:	02049513          	sll	a0,s1,0x20
    800022ac:	9101                	srl	a0,a0,0x20
    800022ae:	60e2                	ld	ra,24(sp)
    800022b0:	6442                	ld	s0,16(sp)
    800022b2:	64a2                	ld	s1,8(sp)
    800022b4:	6105                	add	sp,sp,32
    800022b6:	8082                	ret

00000000800022b8 <sys_trace>:

uint64
sys_trace(void)
{
    800022b8:	1101                	add	sp,sp,-32
    800022ba:	ec06                	sd	ra,24(sp)
    800022bc:	e822                	sd	s0,16(sp)
    800022be:	1000                	add	s0,sp,32
  int mask;
  // 取 a0 寄存器中的值返回给 mask(用户传入的参数)
  if(argint(0, &mask) < 0)
    800022c0:	fec40593          	add	a1,s0,-20
    800022c4:	4501                	li	a0,0
    800022c6:	00000097          	auipc	ra,0x0
    800022ca:	cdc080e7          	jalr	-804(ra) # 80001fa2 <argint>
    return -1;
    800022ce:	57fd                	li	a5,-1
  if(argint(0, &mask) < 0)
    800022d0:	00054a63          	bltz	a0,800022e4 <sys_trace+0x2c>
  // 把 mask 传给现有进程的 mask
  myproc()->mask = mask;
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	bb8080e7          	jalr	-1096(ra) # 80000e8c <myproc>
    800022dc:	fec42783          	lw	a5,-20(s0)
    800022e0:	d95c                	sw	a5,52(a0)
  return 0;
    800022e2:	4781                	li	a5,0
}
    800022e4:	853e                	mv	a0,a5
    800022e6:	60e2                	ld	ra,24(sp)
    800022e8:	6442                	ld	s0,16(sp)
    800022ea:	6105                	add	sp,sp,32
    800022ec:	8082                	ret

00000000800022ee <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    800022ee:	7139                	add	sp,sp,-64
    800022f0:	fc06                	sd	ra,56(sp)
    800022f2:	f822                	sd	s0,48(sp)
    800022f4:	f426                	sd	s1,40(sp)
    800022f6:	0080                	add	s0,sp,64
  // addr is a user virtual address, pointing to a struct sysinfo
  uint64 addr;
  struct sysinfo info;
  struct proc *p = myproc();
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	b94080e7          	jalr	-1132(ra) # 80000e8c <myproc>
    80002300:	84aa                	mv	s1,a0
  
  if (argaddr(0, &addr) < 0)
    80002302:	fd840593          	add	a1,s0,-40
    80002306:	4501                	li	a0,0
    80002308:	00000097          	auipc	ra,0x0
    8000230c:	cbc080e7          	jalr	-836(ra) # 80001fc4 <argaddr>
	  return -1;
    80002310:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0)
    80002312:	02054a63          	bltz	a0,80002346 <sys_sysinfo+0x58>
  // get the number of bytes of free memory
  info.freemem = free_mem();
    80002316:	ffffe097          	auipc	ra,0xffffe
    8000231a:	e64080e7          	jalr	-412(ra) # 8000017a <free_mem>
    8000231e:	fca43423          	sd	a0,-56(s0)
  // get the number of processes whose state is not UNUSED
  info.nproc = nproc();
    80002322:	fffff097          	auipc	ra,0xfffff
    80002326:	736080e7          	jalr	1846(ra) # 80001a58 <nproc>
    8000232a:	fca43823          	sd	a0,-48(s0)

  if (copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    8000232e:	46c1                	li	a3,16
    80002330:	fc840613          	add	a2,s0,-56
    80002334:	fd843583          	ld	a1,-40(s0)
    80002338:	68a8                	ld	a0,80(s1)
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	816080e7          	jalr	-2026(ra) # 80000b50 <copyout>
    80002342:	43f55793          	sra	a5,a0,0x3f
    return -1;
  
  return 0;
    80002346:	853e                	mv	a0,a5
    80002348:	70e2                	ld	ra,56(sp)
    8000234a:	7442                	ld	s0,48(sp)
    8000234c:	74a2                	ld	s1,40(sp)
    8000234e:	6121                	add	sp,sp,64
    80002350:	8082                	ret

0000000080002352 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002352:	7179                	add	sp,sp,-48
    80002354:	f406                	sd	ra,40(sp)
    80002356:	f022                	sd	s0,32(sp)
    80002358:	ec26                	sd	s1,24(sp)
    8000235a:	e84a                	sd	s2,16(sp)
    8000235c:	e44e                	sd	s3,8(sp)
    8000235e:	e052                	sd	s4,0(sp)
    80002360:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002362:	00006597          	auipc	a1,0x6
    80002366:	2ae58593          	add	a1,a1,686 # 80008610 <syscall_names+0xc0>
    8000236a:	0000d517          	auipc	a0,0xd
    8000236e:	b2e50513          	add	a0,a0,-1234 # 8000ee98 <bcache>
    80002372:	00004097          	auipc	ra,0x4
    80002376:	d30080e7          	jalr	-720(ra) # 800060a2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000237a:	00015797          	auipc	a5,0x15
    8000237e:	b1e78793          	add	a5,a5,-1250 # 80016e98 <bcache+0x8000>
    80002382:	00015717          	auipc	a4,0x15
    80002386:	d7e70713          	add	a4,a4,-642 # 80017100 <bcache+0x8268>
    8000238a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000238e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002392:	0000d497          	auipc	s1,0xd
    80002396:	b1e48493          	add	s1,s1,-1250 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000239a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000239c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000239e:	00006a17          	auipc	s4,0x6
    800023a2:	27aa0a13          	add	s4,s4,634 # 80008618 <syscall_names+0xc8>
    b->next = bcache.head.next;
    800023a6:	2b893783          	ld	a5,696(s2)
    800023aa:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023ac:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b0:	85d2                	mv	a1,s4
    800023b2:	01048513          	add	a0,s1,16
    800023b6:	00001097          	auipc	ra,0x1
    800023ba:	490080e7          	jalr	1168(ra) # 80003846 <initsleeplock>
    bcache.head.next->prev = b;
    800023be:	2b893783          	ld	a5,696(s2)
    800023c2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023c4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c8:	45848493          	add	s1,s1,1112
    800023cc:	fd349de3          	bne	s1,s3,800023a6 <binit+0x54>
  }
}
    800023d0:	70a2                	ld	ra,40(sp)
    800023d2:	7402                	ld	s0,32(sp)
    800023d4:	64e2                	ld	s1,24(sp)
    800023d6:	6942                	ld	s2,16(sp)
    800023d8:	69a2                	ld	s3,8(sp)
    800023da:	6a02                	ld	s4,0(sp)
    800023dc:	6145                	add	sp,sp,48
    800023de:	8082                	ret

00000000800023e0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e0:	7179                	add	sp,sp,-48
    800023e2:	f406                	sd	ra,40(sp)
    800023e4:	f022                	sd	s0,32(sp)
    800023e6:	ec26                	sd	s1,24(sp)
    800023e8:	e84a                	sd	s2,16(sp)
    800023ea:	e44e                	sd	s3,8(sp)
    800023ec:	1800                	add	s0,sp,48
    800023ee:	892a                	mv	s2,a0
    800023f0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023f2:	0000d517          	auipc	a0,0xd
    800023f6:	aa650513          	add	a0,a0,-1370 # 8000ee98 <bcache>
    800023fa:	00004097          	auipc	ra,0x4
    800023fe:	d38080e7          	jalr	-712(ra) # 80006132 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002402:	00015497          	auipc	s1,0x15
    80002406:	d4e4b483          	ld	s1,-690(s1) # 80017150 <bcache+0x82b8>
    8000240a:	00015797          	auipc	a5,0x15
    8000240e:	cf678793          	add	a5,a5,-778 # 80017100 <bcache+0x8268>
    80002412:	02f48f63          	beq	s1,a5,80002450 <bread+0x70>
    80002416:	873e                	mv	a4,a5
    80002418:	a021                	j	80002420 <bread+0x40>
    8000241a:	68a4                	ld	s1,80(s1)
    8000241c:	02e48a63          	beq	s1,a4,80002450 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002420:	449c                	lw	a5,8(s1)
    80002422:	ff279ce3          	bne	a5,s2,8000241a <bread+0x3a>
    80002426:	44dc                	lw	a5,12(s1)
    80002428:	ff3799e3          	bne	a5,s3,8000241a <bread+0x3a>
      b->refcnt++;
    8000242c:	40bc                	lw	a5,64(s1)
    8000242e:	2785                	addw	a5,a5,1
    80002430:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002432:	0000d517          	auipc	a0,0xd
    80002436:	a6650513          	add	a0,a0,-1434 # 8000ee98 <bcache>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	dac080e7          	jalr	-596(ra) # 800061e6 <release>
      acquiresleep(&b->lock);
    80002442:	01048513          	add	a0,s1,16
    80002446:	00001097          	auipc	ra,0x1
    8000244a:	43a080e7          	jalr	1082(ra) # 80003880 <acquiresleep>
      return b;
    8000244e:	a8b9                	j	800024ac <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002450:	00015497          	auipc	s1,0x15
    80002454:	cf84b483          	ld	s1,-776(s1) # 80017148 <bcache+0x82b0>
    80002458:	00015797          	auipc	a5,0x15
    8000245c:	ca878793          	add	a5,a5,-856 # 80017100 <bcache+0x8268>
    80002460:	00f48863          	beq	s1,a5,80002470 <bread+0x90>
    80002464:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002466:	40bc                	lw	a5,64(s1)
    80002468:	cf81                	beqz	a5,80002480 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000246a:	64a4                	ld	s1,72(s1)
    8000246c:	fee49de3          	bne	s1,a4,80002466 <bread+0x86>
  panic("bget: no buffers");
    80002470:	00006517          	auipc	a0,0x6
    80002474:	1b050513          	add	a0,a0,432 # 80008620 <syscall_names+0xd0>
    80002478:	00003097          	auipc	ra,0x3
    8000247c:	782080e7          	jalr	1922(ra) # 80005bfa <panic>
      b->dev = dev;
    80002480:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002484:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002488:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000248c:	4785                	li	a5,1
    8000248e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002490:	0000d517          	auipc	a0,0xd
    80002494:	a0850513          	add	a0,a0,-1528 # 8000ee98 <bcache>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	d4e080e7          	jalr	-690(ra) # 800061e6 <release>
      acquiresleep(&b->lock);
    800024a0:	01048513          	add	a0,s1,16
    800024a4:	00001097          	auipc	ra,0x1
    800024a8:	3dc080e7          	jalr	988(ra) # 80003880 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024ac:	409c                	lw	a5,0(s1)
    800024ae:	cb89                	beqz	a5,800024c0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b0:	8526                	mv	a0,s1
    800024b2:	70a2                	ld	ra,40(sp)
    800024b4:	7402                	ld	s0,32(sp)
    800024b6:	64e2                	ld	s1,24(sp)
    800024b8:	6942                	ld	s2,16(sp)
    800024ba:	69a2                	ld	s3,8(sp)
    800024bc:	6145                	add	sp,sp,48
    800024be:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c0:	4581                	li	a1,0
    800024c2:	8526                	mv	a0,s1
    800024c4:	00003097          	auipc	ra,0x3
    800024c8:	ece080e7          	jalr	-306(ra) # 80005392 <virtio_disk_rw>
    b->valid = 1;
    800024cc:	4785                	li	a5,1
    800024ce:	c09c                	sw	a5,0(s1)
  return b;
    800024d0:	b7c5                	j	800024b0 <bread+0xd0>

00000000800024d2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024d2:	1101                	add	sp,sp,-32
    800024d4:	ec06                	sd	ra,24(sp)
    800024d6:	e822                	sd	s0,16(sp)
    800024d8:	e426                	sd	s1,8(sp)
    800024da:	1000                	add	s0,sp,32
    800024dc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024de:	0541                	add	a0,a0,16
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	43a080e7          	jalr	1082(ra) # 8000391a <holdingsleep>
    800024e8:	cd01                	beqz	a0,80002500 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ea:	4585                	li	a1,1
    800024ec:	8526                	mv	a0,s1
    800024ee:	00003097          	auipc	ra,0x3
    800024f2:	ea4080e7          	jalr	-348(ra) # 80005392 <virtio_disk_rw>
}
    800024f6:	60e2                	ld	ra,24(sp)
    800024f8:	6442                	ld	s0,16(sp)
    800024fa:	64a2                	ld	s1,8(sp)
    800024fc:	6105                	add	sp,sp,32
    800024fe:	8082                	ret
    panic("bwrite");
    80002500:	00006517          	auipc	a0,0x6
    80002504:	13850513          	add	a0,a0,312 # 80008638 <syscall_names+0xe8>
    80002508:	00003097          	auipc	ra,0x3
    8000250c:	6f2080e7          	jalr	1778(ra) # 80005bfa <panic>

0000000080002510 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002510:	1101                	add	sp,sp,-32
    80002512:	ec06                	sd	ra,24(sp)
    80002514:	e822                	sd	s0,16(sp)
    80002516:	e426                	sd	s1,8(sp)
    80002518:	e04a                	sd	s2,0(sp)
    8000251a:	1000                	add	s0,sp,32
    8000251c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000251e:	01050913          	add	s2,a0,16
    80002522:	854a                	mv	a0,s2
    80002524:	00001097          	auipc	ra,0x1
    80002528:	3f6080e7          	jalr	1014(ra) # 8000391a <holdingsleep>
    8000252c:	c925                	beqz	a0,8000259c <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000252e:	854a                	mv	a0,s2
    80002530:	00001097          	auipc	ra,0x1
    80002534:	3a6080e7          	jalr	934(ra) # 800038d6 <releasesleep>

  acquire(&bcache.lock);
    80002538:	0000d517          	auipc	a0,0xd
    8000253c:	96050513          	add	a0,a0,-1696 # 8000ee98 <bcache>
    80002540:	00004097          	auipc	ra,0x4
    80002544:	bf2080e7          	jalr	-1038(ra) # 80006132 <acquire>
  b->refcnt--;
    80002548:	40bc                	lw	a5,64(s1)
    8000254a:	37fd                	addw	a5,a5,-1
    8000254c:	0007871b          	sext.w	a4,a5
    80002550:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002552:	e71d                	bnez	a4,80002580 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002554:	68b8                	ld	a4,80(s1)
    80002556:	64bc                	ld	a5,72(s1)
    80002558:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000255a:	68b8                	ld	a4,80(s1)
    8000255c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000255e:	00015797          	auipc	a5,0x15
    80002562:	93a78793          	add	a5,a5,-1734 # 80016e98 <bcache+0x8000>
    80002566:	2b87b703          	ld	a4,696(a5)
    8000256a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000256c:	00015717          	auipc	a4,0x15
    80002570:	b9470713          	add	a4,a4,-1132 # 80017100 <bcache+0x8268>
    80002574:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002576:	2b87b703          	ld	a4,696(a5)
    8000257a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000257c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002580:	0000d517          	auipc	a0,0xd
    80002584:	91850513          	add	a0,a0,-1768 # 8000ee98 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	c5e080e7          	jalr	-930(ra) # 800061e6 <release>
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6902                	ld	s2,0(sp)
    80002598:	6105                	add	sp,sp,32
    8000259a:	8082                	ret
    panic("brelse");
    8000259c:	00006517          	auipc	a0,0x6
    800025a0:	0a450513          	add	a0,a0,164 # 80008640 <syscall_names+0xf0>
    800025a4:	00003097          	auipc	ra,0x3
    800025a8:	656080e7          	jalr	1622(ra) # 80005bfa <panic>

00000000800025ac <bpin>:

void
bpin(struct buf *b) {
    800025ac:	1101                	add	sp,sp,-32
    800025ae:	ec06                	sd	ra,24(sp)
    800025b0:	e822                	sd	s0,16(sp)
    800025b2:	e426                	sd	s1,8(sp)
    800025b4:	1000                	add	s0,sp,32
    800025b6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b8:	0000d517          	auipc	a0,0xd
    800025bc:	8e050513          	add	a0,a0,-1824 # 8000ee98 <bcache>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	b72080e7          	jalr	-1166(ra) # 80006132 <acquire>
  b->refcnt++;
    800025c8:	40bc                	lw	a5,64(s1)
    800025ca:	2785                	addw	a5,a5,1
    800025cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ce:	0000d517          	auipc	a0,0xd
    800025d2:	8ca50513          	add	a0,a0,-1846 # 8000ee98 <bcache>
    800025d6:	00004097          	auipc	ra,0x4
    800025da:	c10080e7          	jalr	-1008(ra) # 800061e6 <release>
}
    800025de:	60e2                	ld	ra,24(sp)
    800025e0:	6442                	ld	s0,16(sp)
    800025e2:	64a2                	ld	s1,8(sp)
    800025e4:	6105                	add	sp,sp,32
    800025e6:	8082                	ret

00000000800025e8 <bunpin>:

void
bunpin(struct buf *b) {
    800025e8:	1101                	add	sp,sp,-32
    800025ea:	ec06                	sd	ra,24(sp)
    800025ec:	e822                	sd	s0,16(sp)
    800025ee:	e426                	sd	s1,8(sp)
    800025f0:	1000                	add	s0,sp,32
    800025f2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f4:	0000d517          	auipc	a0,0xd
    800025f8:	8a450513          	add	a0,a0,-1884 # 8000ee98 <bcache>
    800025fc:	00004097          	auipc	ra,0x4
    80002600:	b36080e7          	jalr	-1226(ra) # 80006132 <acquire>
  b->refcnt--;
    80002604:	40bc                	lw	a5,64(s1)
    80002606:	37fd                	addw	a5,a5,-1
    80002608:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260a:	0000d517          	auipc	a0,0xd
    8000260e:	88e50513          	add	a0,a0,-1906 # 8000ee98 <bcache>
    80002612:	00004097          	auipc	ra,0x4
    80002616:	bd4080e7          	jalr	-1068(ra) # 800061e6 <release>
}
    8000261a:	60e2                	ld	ra,24(sp)
    8000261c:	6442                	ld	s0,16(sp)
    8000261e:	64a2                	ld	s1,8(sp)
    80002620:	6105                	add	sp,sp,32
    80002622:	8082                	ret

0000000080002624 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002624:	1101                	add	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	e426                	sd	s1,8(sp)
    8000262c:	e04a                	sd	s2,0(sp)
    8000262e:	1000                	add	s0,sp,32
    80002630:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002632:	00d5d59b          	srlw	a1,a1,0xd
    80002636:	00015797          	auipc	a5,0x15
    8000263a:	f3e7a783          	lw	a5,-194(a5) # 80017574 <sb+0x1c>
    8000263e:	9dbd                	addw	a1,a1,a5
    80002640:	00000097          	auipc	ra,0x0
    80002644:	da0080e7          	jalr	-608(ra) # 800023e0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002648:	0074f713          	and	a4,s1,7
    8000264c:	4785                	li	a5,1
    8000264e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002652:	14ce                	sll	s1,s1,0x33
    80002654:	90d9                	srl	s1,s1,0x36
    80002656:	00950733          	add	a4,a0,s1
    8000265a:	05874703          	lbu	a4,88(a4)
    8000265e:	00e7f6b3          	and	a3,a5,a4
    80002662:	c69d                	beqz	a3,80002690 <bfree+0x6c>
    80002664:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002666:	94aa                	add	s1,s1,a0
    80002668:	fff7c793          	not	a5,a5
    8000266c:	8f7d                	and	a4,a4,a5
    8000266e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002672:	00001097          	auipc	ra,0x1
    80002676:	0f0080e7          	jalr	240(ra) # 80003762 <log_write>
  brelse(bp);
    8000267a:	854a                	mv	a0,s2
    8000267c:	00000097          	auipc	ra,0x0
    80002680:	e94080e7          	jalr	-364(ra) # 80002510 <brelse>
}
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6902                	ld	s2,0(sp)
    8000268c:	6105                	add	sp,sp,32
    8000268e:	8082                	ret
    panic("freeing free block");
    80002690:	00006517          	auipc	a0,0x6
    80002694:	fb850513          	add	a0,a0,-72 # 80008648 <syscall_names+0xf8>
    80002698:	00003097          	auipc	ra,0x3
    8000269c:	562080e7          	jalr	1378(ra) # 80005bfa <panic>

00000000800026a0 <balloc>:
{
    800026a0:	711d                	add	sp,sp,-96
    800026a2:	ec86                	sd	ra,88(sp)
    800026a4:	e8a2                	sd	s0,80(sp)
    800026a6:	e4a6                	sd	s1,72(sp)
    800026a8:	e0ca                	sd	s2,64(sp)
    800026aa:	fc4e                	sd	s3,56(sp)
    800026ac:	f852                	sd	s4,48(sp)
    800026ae:	f456                	sd	s5,40(sp)
    800026b0:	f05a                	sd	s6,32(sp)
    800026b2:	ec5e                	sd	s7,24(sp)
    800026b4:	e862                	sd	s8,16(sp)
    800026b6:	e466                	sd	s9,8(sp)
    800026b8:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026ba:	00015797          	auipc	a5,0x15
    800026be:	ea27a783          	lw	a5,-350(a5) # 8001755c <sb+0x4>
    800026c2:	cbc1                	beqz	a5,80002752 <balloc+0xb2>
    800026c4:	8baa                	mv	s7,a0
    800026c6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026c8:	00015b17          	auipc	s6,0x15
    800026cc:	e90b0b13          	add	s6,s6,-368 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026d2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026d6:	6c89                	lui	s9,0x2
    800026d8:	a831                	j	800026f4 <balloc+0x54>
    brelse(bp);
    800026da:	854a                	mv	a0,s2
    800026dc:	00000097          	auipc	ra,0x0
    800026e0:	e34080e7          	jalr	-460(ra) # 80002510 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026e4:	015c87bb          	addw	a5,s9,s5
    800026e8:	00078a9b          	sext.w	s5,a5
    800026ec:	004b2703          	lw	a4,4(s6)
    800026f0:	06eaf163          	bgeu	s5,a4,80002752 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800026f4:	41fad79b          	sraw	a5,s5,0x1f
    800026f8:	0137d79b          	srlw	a5,a5,0x13
    800026fc:	015787bb          	addw	a5,a5,s5
    80002700:	40d7d79b          	sraw	a5,a5,0xd
    80002704:	01cb2583          	lw	a1,28(s6)
    80002708:	9dbd                	addw	a1,a1,a5
    8000270a:	855e                	mv	a0,s7
    8000270c:	00000097          	auipc	ra,0x0
    80002710:	cd4080e7          	jalr	-812(ra) # 800023e0 <bread>
    80002714:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002716:	004b2503          	lw	a0,4(s6)
    8000271a:	000a849b          	sext.w	s1,s5
    8000271e:	8762                	mv	a4,s8
    80002720:	faa4fde3          	bgeu	s1,a0,800026da <balloc+0x3a>
      m = 1 << (bi % 8);
    80002724:	00777693          	and	a3,a4,7
    80002728:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000272c:	41f7579b          	sraw	a5,a4,0x1f
    80002730:	01d7d79b          	srlw	a5,a5,0x1d
    80002734:	9fb9                	addw	a5,a5,a4
    80002736:	4037d79b          	sraw	a5,a5,0x3
    8000273a:	00f90633          	add	a2,s2,a5
    8000273e:	05864603          	lbu	a2,88(a2)
    80002742:	00c6f5b3          	and	a1,a3,a2
    80002746:	cd91                	beqz	a1,80002762 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002748:	2705                	addw	a4,a4,1
    8000274a:	2485                	addw	s1,s1,1
    8000274c:	fd471ae3          	bne	a4,s4,80002720 <balloc+0x80>
    80002750:	b769                	j	800026da <balloc+0x3a>
  panic("balloc: out of blocks");
    80002752:	00006517          	auipc	a0,0x6
    80002756:	f0e50513          	add	a0,a0,-242 # 80008660 <syscall_names+0x110>
    8000275a:	00003097          	auipc	ra,0x3
    8000275e:	4a0080e7          	jalr	1184(ra) # 80005bfa <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002762:	97ca                	add	a5,a5,s2
    80002764:	8e55                	or	a2,a2,a3
    80002766:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000276a:	854a                	mv	a0,s2
    8000276c:	00001097          	auipc	ra,0x1
    80002770:	ff6080e7          	jalr	-10(ra) # 80003762 <log_write>
        brelse(bp);
    80002774:	854a                	mv	a0,s2
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	d9a080e7          	jalr	-614(ra) # 80002510 <brelse>
  bp = bread(dev, bno);
    8000277e:	85a6                	mv	a1,s1
    80002780:	855e                	mv	a0,s7
    80002782:	00000097          	auipc	ra,0x0
    80002786:	c5e080e7          	jalr	-930(ra) # 800023e0 <bread>
    8000278a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000278c:	40000613          	li	a2,1024
    80002790:	4581                	li	a1,0
    80002792:	05850513          	add	a0,a0,88
    80002796:	ffffe097          	auipc	ra,0xffffe
    8000279a:	a2e080e7          	jalr	-1490(ra) # 800001c4 <memset>
  log_write(bp);
    8000279e:	854a                	mv	a0,s2
    800027a0:	00001097          	auipc	ra,0x1
    800027a4:	fc2080e7          	jalr	-62(ra) # 80003762 <log_write>
  brelse(bp);
    800027a8:	854a                	mv	a0,s2
    800027aa:	00000097          	auipc	ra,0x0
    800027ae:	d66080e7          	jalr	-666(ra) # 80002510 <brelse>
}
    800027b2:	8526                	mv	a0,s1
    800027b4:	60e6                	ld	ra,88(sp)
    800027b6:	6446                	ld	s0,80(sp)
    800027b8:	64a6                	ld	s1,72(sp)
    800027ba:	6906                	ld	s2,64(sp)
    800027bc:	79e2                	ld	s3,56(sp)
    800027be:	7a42                	ld	s4,48(sp)
    800027c0:	7aa2                	ld	s5,40(sp)
    800027c2:	7b02                	ld	s6,32(sp)
    800027c4:	6be2                	ld	s7,24(sp)
    800027c6:	6c42                	ld	s8,16(sp)
    800027c8:	6ca2                	ld	s9,8(sp)
    800027ca:	6125                	add	sp,sp,96
    800027cc:	8082                	ret

00000000800027ce <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ce:	7179                	add	sp,sp,-48
    800027d0:	f406                	sd	ra,40(sp)
    800027d2:	f022                	sd	s0,32(sp)
    800027d4:	ec26                	sd	s1,24(sp)
    800027d6:	e84a                	sd	s2,16(sp)
    800027d8:	e44e                	sd	s3,8(sp)
    800027da:	e052                	sd	s4,0(sp)
    800027dc:	1800                	add	s0,sp,48
    800027de:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027e0:	47ad                	li	a5,11
    800027e2:	04b7fe63          	bgeu	a5,a1,8000283e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027e6:	ff45849b          	addw	s1,a1,-12
    800027ea:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027ee:	0ff00793          	li	a5,255
    800027f2:	0ae7e463          	bltu	a5,a4,8000289a <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027f6:	08052583          	lw	a1,128(a0)
    800027fa:	c5b5                	beqz	a1,80002866 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027fc:	00092503          	lw	a0,0(s2)
    80002800:	00000097          	auipc	ra,0x0
    80002804:	be0080e7          	jalr	-1056(ra) # 800023e0 <bread>
    80002808:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000280a:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    8000280e:	02049713          	sll	a4,s1,0x20
    80002812:	01e75593          	srl	a1,a4,0x1e
    80002816:	00b784b3          	add	s1,a5,a1
    8000281a:	0004a983          	lw	s3,0(s1)
    8000281e:	04098e63          	beqz	s3,8000287a <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002822:	8552                	mv	a0,s4
    80002824:	00000097          	auipc	ra,0x0
    80002828:	cec080e7          	jalr	-788(ra) # 80002510 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000282c:	854e                	mv	a0,s3
    8000282e:	70a2                	ld	ra,40(sp)
    80002830:	7402                	ld	s0,32(sp)
    80002832:	64e2                	ld	s1,24(sp)
    80002834:	6942                	ld	s2,16(sp)
    80002836:	69a2                	ld	s3,8(sp)
    80002838:	6a02                	ld	s4,0(sp)
    8000283a:	6145                	add	sp,sp,48
    8000283c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000283e:	02059793          	sll	a5,a1,0x20
    80002842:	01e7d593          	srl	a1,a5,0x1e
    80002846:	00b504b3          	add	s1,a0,a1
    8000284a:	0504a983          	lw	s3,80(s1)
    8000284e:	fc099fe3          	bnez	s3,8000282c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002852:	4108                	lw	a0,0(a0)
    80002854:	00000097          	auipc	ra,0x0
    80002858:	e4c080e7          	jalr	-436(ra) # 800026a0 <balloc>
    8000285c:	0005099b          	sext.w	s3,a0
    80002860:	0534a823          	sw	s3,80(s1)
    80002864:	b7e1                	j	8000282c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002866:	4108                	lw	a0,0(a0)
    80002868:	00000097          	auipc	ra,0x0
    8000286c:	e38080e7          	jalr	-456(ra) # 800026a0 <balloc>
    80002870:	0005059b          	sext.w	a1,a0
    80002874:	08b92023          	sw	a1,128(s2)
    80002878:	b751                	j	800027fc <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000287a:	00092503          	lw	a0,0(s2)
    8000287e:	00000097          	auipc	ra,0x0
    80002882:	e22080e7          	jalr	-478(ra) # 800026a0 <balloc>
    80002886:	0005099b          	sext.w	s3,a0
    8000288a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000288e:	8552                	mv	a0,s4
    80002890:	00001097          	auipc	ra,0x1
    80002894:	ed2080e7          	jalr	-302(ra) # 80003762 <log_write>
    80002898:	b769                	j	80002822 <bmap+0x54>
  panic("bmap: out of range");
    8000289a:	00006517          	auipc	a0,0x6
    8000289e:	dde50513          	add	a0,a0,-546 # 80008678 <syscall_names+0x128>
    800028a2:	00003097          	auipc	ra,0x3
    800028a6:	358080e7          	jalr	856(ra) # 80005bfa <panic>

00000000800028aa <iget>:
{
    800028aa:	7179                	add	sp,sp,-48
    800028ac:	f406                	sd	ra,40(sp)
    800028ae:	f022                	sd	s0,32(sp)
    800028b0:	ec26                	sd	s1,24(sp)
    800028b2:	e84a                	sd	s2,16(sp)
    800028b4:	e44e                	sd	s3,8(sp)
    800028b6:	e052                	sd	s4,0(sp)
    800028b8:	1800                	add	s0,sp,48
    800028ba:	89aa                	mv	s3,a0
    800028bc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028be:	00015517          	auipc	a0,0x15
    800028c2:	cba50513          	add	a0,a0,-838 # 80017578 <itable>
    800028c6:	00004097          	auipc	ra,0x4
    800028ca:	86c080e7          	jalr	-1940(ra) # 80006132 <acquire>
  empty = 0;
    800028ce:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028d0:	00015497          	auipc	s1,0x15
    800028d4:	cc048493          	add	s1,s1,-832 # 80017590 <itable+0x18>
    800028d8:	00016697          	auipc	a3,0x16
    800028dc:	74868693          	add	a3,a3,1864 # 80019020 <log>
    800028e0:	a039                	j	800028ee <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e2:	02090b63          	beqz	s2,80002918 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028e6:	08848493          	add	s1,s1,136
    800028ea:	02d48a63          	beq	s1,a3,8000291e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028ee:	449c                	lw	a5,8(s1)
    800028f0:	fef059e3          	blez	a5,800028e2 <iget+0x38>
    800028f4:	4098                	lw	a4,0(s1)
    800028f6:	ff3716e3          	bne	a4,s3,800028e2 <iget+0x38>
    800028fa:	40d8                	lw	a4,4(s1)
    800028fc:	ff4713e3          	bne	a4,s4,800028e2 <iget+0x38>
      ip->ref++;
    80002900:	2785                	addw	a5,a5,1
    80002902:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002904:	00015517          	auipc	a0,0x15
    80002908:	c7450513          	add	a0,a0,-908 # 80017578 <itable>
    8000290c:	00004097          	auipc	ra,0x4
    80002910:	8da080e7          	jalr	-1830(ra) # 800061e6 <release>
      return ip;
    80002914:	8926                	mv	s2,s1
    80002916:	a03d                	j	80002944 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002918:	f7f9                	bnez	a5,800028e6 <iget+0x3c>
    8000291a:	8926                	mv	s2,s1
    8000291c:	b7e9                	j	800028e6 <iget+0x3c>
  if(empty == 0)
    8000291e:	02090c63          	beqz	s2,80002956 <iget+0xac>
  ip->dev = dev;
    80002922:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002926:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000292a:	4785                	li	a5,1
    8000292c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002930:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002934:	00015517          	auipc	a0,0x15
    80002938:	c4450513          	add	a0,a0,-956 # 80017578 <itable>
    8000293c:	00004097          	auipc	ra,0x4
    80002940:	8aa080e7          	jalr	-1878(ra) # 800061e6 <release>
}
    80002944:	854a                	mv	a0,s2
    80002946:	70a2                	ld	ra,40(sp)
    80002948:	7402                	ld	s0,32(sp)
    8000294a:	64e2                	ld	s1,24(sp)
    8000294c:	6942                	ld	s2,16(sp)
    8000294e:	69a2                	ld	s3,8(sp)
    80002950:	6a02                	ld	s4,0(sp)
    80002952:	6145                	add	sp,sp,48
    80002954:	8082                	ret
    panic("iget: no inodes");
    80002956:	00006517          	auipc	a0,0x6
    8000295a:	d3a50513          	add	a0,a0,-710 # 80008690 <syscall_names+0x140>
    8000295e:	00003097          	auipc	ra,0x3
    80002962:	29c080e7          	jalr	668(ra) # 80005bfa <panic>

0000000080002966 <fsinit>:
fsinit(int dev) {
    80002966:	7179                	add	sp,sp,-48
    80002968:	f406                	sd	ra,40(sp)
    8000296a:	f022                	sd	s0,32(sp)
    8000296c:	ec26                	sd	s1,24(sp)
    8000296e:	e84a                	sd	s2,16(sp)
    80002970:	e44e                	sd	s3,8(sp)
    80002972:	1800                	add	s0,sp,48
    80002974:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002976:	4585                	li	a1,1
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	a68080e7          	jalr	-1432(ra) # 800023e0 <bread>
    80002980:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002982:	00015997          	auipc	s3,0x15
    80002986:	bd698993          	add	s3,s3,-1066 # 80017558 <sb>
    8000298a:	02000613          	li	a2,32
    8000298e:	05850593          	add	a1,a0,88
    80002992:	854e                	mv	a0,s3
    80002994:	ffffe097          	auipc	ra,0xffffe
    80002998:	88c080e7          	jalr	-1908(ra) # 80000220 <memmove>
  brelse(bp);
    8000299c:	8526                	mv	a0,s1
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	b72080e7          	jalr	-1166(ra) # 80002510 <brelse>
  if(sb.magic != FSMAGIC)
    800029a6:	0009a703          	lw	a4,0(s3)
    800029aa:	102037b7          	lui	a5,0x10203
    800029ae:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029b2:	02f71263          	bne	a4,a5,800029d6 <fsinit+0x70>
  initlog(dev, &sb);
    800029b6:	00015597          	auipc	a1,0x15
    800029ba:	ba258593          	add	a1,a1,-1118 # 80017558 <sb>
    800029be:	854a                	mv	a0,s2
    800029c0:	00001097          	auipc	ra,0x1
    800029c4:	b38080e7          	jalr	-1224(ra) # 800034f8 <initlog>
}
    800029c8:	70a2                	ld	ra,40(sp)
    800029ca:	7402                	ld	s0,32(sp)
    800029cc:	64e2                	ld	s1,24(sp)
    800029ce:	6942                	ld	s2,16(sp)
    800029d0:	69a2                	ld	s3,8(sp)
    800029d2:	6145                	add	sp,sp,48
    800029d4:	8082                	ret
    panic("invalid file system");
    800029d6:	00006517          	auipc	a0,0x6
    800029da:	cca50513          	add	a0,a0,-822 # 800086a0 <syscall_names+0x150>
    800029de:	00003097          	auipc	ra,0x3
    800029e2:	21c080e7          	jalr	540(ra) # 80005bfa <panic>

00000000800029e6 <iinit>:
{
    800029e6:	7179                	add	sp,sp,-48
    800029e8:	f406                	sd	ra,40(sp)
    800029ea:	f022                	sd	s0,32(sp)
    800029ec:	ec26                	sd	s1,24(sp)
    800029ee:	e84a                	sd	s2,16(sp)
    800029f0:	e44e                	sd	s3,8(sp)
    800029f2:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    800029f4:	00006597          	auipc	a1,0x6
    800029f8:	cc458593          	add	a1,a1,-828 # 800086b8 <syscall_names+0x168>
    800029fc:	00015517          	auipc	a0,0x15
    80002a00:	b7c50513          	add	a0,a0,-1156 # 80017578 <itable>
    80002a04:	00003097          	auipc	ra,0x3
    80002a08:	69e080e7          	jalr	1694(ra) # 800060a2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a0c:	00015497          	auipc	s1,0x15
    80002a10:	b9448493          	add	s1,s1,-1132 # 800175a0 <itable+0x28>
    80002a14:	00016997          	auipc	s3,0x16
    80002a18:	61c98993          	add	s3,s3,1564 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a1c:	00006917          	auipc	s2,0x6
    80002a20:	ca490913          	add	s2,s2,-860 # 800086c0 <syscall_names+0x170>
    80002a24:	85ca                	mv	a1,s2
    80002a26:	8526                	mv	a0,s1
    80002a28:	00001097          	auipc	ra,0x1
    80002a2c:	e1e080e7          	jalr	-482(ra) # 80003846 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a30:	08848493          	add	s1,s1,136
    80002a34:	ff3498e3          	bne	s1,s3,80002a24 <iinit+0x3e>
}
    80002a38:	70a2                	ld	ra,40(sp)
    80002a3a:	7402                	ld	s0,32(sp)
    80002a3c:	64e2                	ld	s1,24(sp)
    80002a3e:	6942                	ld	s2,16(sp)
    80002a40:	69a2                	ld	s3,8(sp)
    80002a42:	6145                	add	sp,sp,48
    80002a44:	8082                	ret

0000000080002a46 <ialloc>:
{
    80002a46:	7139                	add	sp,sp,-64
    80002a48:	fc06                	sd	ra,56(sp)
    80002a4a:	f822                	sd	s0,48(sp)
    80002a4c:	f426                	sd	s1,40(sp)
    80002a4e:	f04a                	sd	s2,32(sp)
    80002a50:	ec4e                	sd	s3,24(sp)
    80002a52:	e852                	sd	s4,16(sp)
    80002a54:	e456                	sd	s5,8(sp)
    80002a56:	e05a                	sd	s6,0(sp)
    80002a58:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a5a:	00015717          	auipc	a4,0x15
    80002a5e:	b0a72703          	lw	a4,-1270(a4) # 80017564 <sb+0xc>
    80002a62:	4785                	li	a5,1
    80002a64:	04e7f863          	bgeu	a5,a4,80002ab4 <ialloc+0x6e>
    80002a68:	8aaa                	mv	s5,a0
    80002a6a:	8b2e                	mv	s6,a1
    80002a6c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a6e:	00015a17          	auipc	s4,0x15
    80002a72:	aeaa0a13          	add	s4,s4,-1302 # 80017558 <sb>
    80002a76:	00495593          	srl	a1,s2,0x4
    80002a7a:	018a2783          	lw	a5,24(s4)
    80002a7e:	9dbd                	addw	a1,a1,a5
    80002a80:	8556                	mv	a0,s5
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	95e080e7          	jalr	-1698(ra) # 800023e0 <bread>
    80002a8a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a8c:	05850993          	add	s3,a0,88
    80002a90:	00f97793          	and	a5,s2,15
    80002a94:	079a                	sll	a5,a5,0x6
    80002a96:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a98:	00099783          	lh	a5,0(s3)
    80002a9c:	c785                	beqz	a5,80002ac4 <ialloc+0x7e>
    brelse(bp);
    80002a9e:	00000097          	auipc	ra,0x0
    80002aa2:	a72080e7          	jalr	-1422(ra) # 80002510 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aa6:	0905                	add	s2,s2,1
    80002aa8:	00ca2703          	lw	a4,12(s4)
    80002aac:	0009079b          	sext.w	a5,s2
    80002ab0:	fce7e3e3          	bltu	a5,a4,80002a76 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002ab4:	00006517          	auipc	a0,0x6
    80002ab8:	c1450513          	add	a0,a0,-1004 # 800086c8 <syscall_names+0x178>
    80002abc:	00003097          	auipc	ra,0x3
    80002ac0:	13e080e7          	jalr	318(ra) # 80005bfa <panic>
      memset(dip, 0, sizeof(*dip));
    80002ac4:	04000613          	li	a2,64
    80002ac8:	4581                	li	a1,0
    80002aca:	854e                	mv	a0,s3
    80002acc:	ffffd097          	auipc	ra,0xffffd
    80002ad0:	6f8080e7          	jalr	1784(ra) # 800001c4 <memset>
      dip->type = type;
    80002ad4:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ad8:	8526                	mv	a0,s1
    80002ada:	00001097          	auipc	ra,0x1
    80002ade:	c88080e7          	jalr	-888(ra) # 80003762 <log_write>
      brelse(bp);
    80002ae2:	8526                	mv	a0,s1
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	a2c080e7          	jalr	-1492(ra) # 80002510 <brelse>
      return iget(dev, inum);
    80002aec:	0009059b          	sext.w	a1,s2
    80002af0:	8556                	mv	a0,s5
    80002af2:	00000097          	auipc	ra,0x0
    80002af6:	db8080e7          	jalr	-584(ra) # 800028aa <iget>
}
    80002afa:	70e2                	ld	ra,56(sp)
    80002afc:	7442                	ld	s0,48(sp)
    80002afe:	74a2                	ld	s1,40(sp)
    80002b00:	7902                	ld	s2,32(sp)
    80002b02:	69e2                	ld	s3,24(sp)
    80002b04:	6a42                	ld	s4,16(sp)
    80002b06:	6aa2                	ld	s5,8(sp)
    80002b08:	6b02                	ld	s6,0(sp)
    80002b0a:	6121                	add	sp,sp,64
    80002b0c:	8082                	ret

0000000080002b0e <iupdate>:
{
    80002b0e:	1101                	add	sp,sp,-32
    80002b10:	ec06                	sd	ra,24(sp)
    80002b12:	e822                	sd	s0,16(sp)
    80002b14:	e426                	sd	s1,8(sp)
    80002b16:	e04a                	sd	s2,0(sp)
    80002b18:	1000                	add	s0,sp,32
    80002b1a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b1c:	415c                	lw	a5,4(a0)
    80002b1e:	0047d79b          	srlw	a5,a5,0x4
    80002b22:	00015597          	auipc	a1,0x15
    80002b26:	a4e5a583          	lw	a1,-1458(a1) # 80017570 <sb+0x18>
    80002b2a:	9dbd                	addw	a1,a1,a5
    80002b2c:	4108                	lw	a0,0(a0)
    80002b2e:	00000097          	auipc	ra,0x0
    80002b32:	8b2080e7          	jalr	-1870(ra) # 800023e0 <bread>
    80002b36:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b38:	05850793          	add	a5,a0,88
    80002b3c:	40d8                	lw	a4,4(s1)
    80002b3e:	8b3d                	and	a4,a4,15
    80002b40:	071a                	sll	a4,a4,0x6
    80002b42:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b44:	04449703          	lh	a4,68(s1)
    80002b48:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b4c:	04649703          	lh	a4,70(s1)
    80002b50:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b54:	04849703          	lh	a4,72(s1)
    80002b58:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b5c:	04a49703          	lh	a4,74(s1)
    80002b60:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b64:	44f8                	lw	a4,76(s1)
    80002b66:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b68:	03400613          	li	a2,52
    80002b6c:	05048593          	add	a1,s1,80
    80002b70:	00c78513          	add	a0,a5,12
    80002b74:	ffffd097          	auipc	ra,0xffffd
    80002b78:	6ac080e7          	jalr	1708(ra) # 80000220 <memmove>
  log_write(bp);
    80002b7c:	854a                	mv	a0,s2
    80002b7e:	00001097          	auipc	ra,0x1
    80002b82:	be4080e7          	jalr	-1052(ra) # 80003762 <log_write>
  brelse(bp);
    80002b86:	854a                	mv	a0,s2
    80002b88:	00000097          	auipc	ra,0x0
    80002b8c:	988080e7          	jalr	-1656(ra) # 80002510 <brelse>
}
    80002b90:	60e2                	ld	ra,24(sp)
    80002b92:	6442                	ld	s0,16(sp)
    80002b94:	64a2                	ld	s1,8(sp)
    80002b96:	6902                	ld	s2,0(sp)
    80002b98:	6105                	add	sp,sp,32
    80002b9a:	8082                	ret

0000000080002b9c <idup>:
{
    80002b9c:	1101                	add	sp,sp,-32
    80002b9e:	ec06                	sd	ra,24(sp)
    80002ba0:	e822                	sd	s0,16(sp)
    80002ba2:	e426                	sd	s1,8(sp)
    80002ba4:	1000                	add	s0,sp,32
    80002ba6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ba8:	00015517          	auipc	a0,0x15
    80002bac:	9d050513          	add	a0,a0,-1584 # 80017578 <itable>
    80002bb0:	00003097          	auipc	ra,0x3
    80002bb4:	582080e7          	jalr	1410(ra) # 80006132 <acquire>
  ip->ref++;
    80002bb8:	449c                	lw	a5,8(s1)
    80002bba:	2785                	addw	a5,a5,1
    80002bbc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bbe:	00015517          	auipc	a0,0x15
    80002bc2:	9ba50513          	add	a0,a0,-1606 # 80017578 <itable>
    80002bc6:	00003097          	auipc	ra,0x3
    80002bca:	620080e7          	jalr	1568(ra) # 800061e6 <release>
}
    80002bce:	8526                	mv	a0,s1
    80002bd0:	60e2                	ld	ra,24(sp)
    80002bd2:	6442                	ld	s0,16(sp)
    80002bd4:	64a2                	ld	s1,8(sp)
    80002bd6:	6105                	add	sp,sp,32
    80002bd8:	8082                	ret

0000000080002bda <ilock>:
{
    80002bda:	1101                	add	sp,sp,-32
    80002bdc:	ec06                	sd	ra,24(sp)
    80002bde:	e822                	sd	s0,16(sp)
    80002be0:	e426                	sd	s1,8(sp)
    80002be2:	e04a                	sd	s2,0(sp)
    80002be4:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002be6:	c115                	beqz	a0,80002c0a <ilock+0x30>
    80002be8:	84aa                	mv	s1,a0
    80002bea:	451c                	lw	a5,8(a0)
    80002bec:	00f05f63          	blez	a5,80002c0a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bf0:	0541                	add	a0,a0,16
    80002bf2:	00001097          	auipc	ra,0x1
    80002bf6:	c8e080e7          	jalr	-882(ra) # 80003880 <acquiresleep>
  if(ip->valid == 0){
    80002bfa:	40bc                	lw	a5,64(s1)
    80002bfc:	cf99                	beqz	a5,80002c1a <ilock+0x40>
}
    80002bfe:	60e2                	ld	ra,24(sp)
    80002c00:	6442                	ld	s0,16(sp)
    80002c02:	64a2                	ld	s1,8(sp)
    80002c04:	6902                	ld	s2,0(sp)
    80002c06:	6105                	add	sp,sp,32
    80002c08:	8082                	ret
    panic("ilock");
    80002c0a:	00006517          	auipc	a0,0x6
    80002c0e:	ad650513          	add	a0,a0,-1322 # 800086e0 <syscall_names+0x190>
    80002c12:	00003097          	auipc	ra,0x3
    80002c16:	fe8080e7          	jalr	-24(ra) # 80005bfa <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c1a:	40dc                	lw	a5,4(s1)
    80002c1c:	0047d79b          	srlw	a5,a5,0x4
    80002c20:	00015597          	auipc	a1,0x15
    80002c24:	9505a583          	lw	a1,-1712(a1) # 80017570 <sb+0x18>
    80002c28:	9dbd                	addw	a1,a1,a5
    80002c2a:	4088                	lw	a0,0(s1)
    80002c2c:	fffff097          	auipc	ra,0xfffff
    80002c30:	7b4080e7          	jalr	1972(ra) # 800023e0 <bread>
    80002c34:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c36:	05850593          	add	a1,a0,88
    80002c3a:	40dc                	lw	a5,4(s1)
    80002c3c:	8bbd                	and	a5,a5,15
    80002c3e:	079a                	sll	a5,a5,0x6
    80002c40:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c42:	00059783          	lh	a5,0(a1)
    80002c46:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c4a:	00259783          	lh	a5,2(a1)
    80002c4e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c52:	00459783          	lh	a5,4(a1)
    80002c56:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c5a:	00659783          	lh	a5,6(a1)
    80002c5e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c62:	459c                	lw	a5,8(a1)
    80002c64:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c66:	03400613          	li	a2,52
    80002c6a:	05b1                	add	a1,a1,12
    80002c6c:	05048513          	add	a0,s1,80
    80002c70:	ffffd097          	auipc	ra,0xffffd
    80002c74:	5b0080e7          	jalr	1456(ra) # 80000220 <memmove>
    brelse(bp);
    80002c78:	854a                	mv	a0,s2
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	896080e7          	jalr	-1898(ra) # 80002510 <brelse>
    ip->valid = 1;
    80002c82:	4785                	li	a5,1
    80002c84:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c86:	04449783          	lh	a5,68(s1)
    80002c8a:	fbb5                	bnez	a5,80002bfe <ilock+0x24>
      panic("ilock: no type");
    80002c8c:	00006517          	auipc	a0,0x6
    80002c90:	a5c50513          	add	a0,a0,-1444 # 800086e8 <syscall_names+0x198>
    80002c94:	00003097          	auipc	ra,0x3
    80002c98:	f66080e7          	jalr	-154(ra) # 80005bfa <panic>

0000000080002c9c <iunlock>:
{
    80002c9c:	1101                	add	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	e426                	sd	s1,8(sp)
    80002ca4:	e04a                	sd	s2,0(sp)
    80002ca6:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ca8:	c905                	beqz	a0,80002cd8 <iunlock+0x3c>
    80002caa:	84aa                	mv	s1,a0
    80002cac:	01050913          	add	s2,a0,16
    80002cb0:	854a                	mv	a0,s2
    80002cb2:	00001097          	auipc	ra,0x1
    80002cb6:	c68080e7          	jalr	-920(ra) # 8000391a <holdingsleep>
    80002cba:	cd19                	beqz	a0,80002cd8 <iunlock+0x3c>
    80002cbc:	449c                	lw	a5,8(s1)
    80002cbe:	00f05d63          	blez	a5,80002cd8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cc2:	854a                	mv	a0,s2
    80002cc4:	00001097          	auipc	ra,0x1
    80002cc8:	c12080e7          	jalr	-1006(ra) # 800038d6 <releasesleep>
}
    80002ccc:	60e2                	ld	ra,24(sp)
    80002cce:	6442                	ld	s0,16(sp)
    80002cd0:	64a2                	ld	s1,8(sp)
    80002cd2:	6902                	ld	s2,0(sp)
    80002cd4:	6105                	add	sp,sp,32
    80002cd6:	8082                	ret
    panic("iunlock");
    80002cd8:	00006517          	auipc	a0,0x6
    80002cdc:	a2050513          	add	a0,a0,-1504 # 800086f8 <syscall_names+0x1a8>
    80002ce0:	00003097          	auipc	ra,0x3
    80002ce4:	f1a080e7          	jalr	-230(ra) # 80005bfa <panic>

0000000080002ce8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ce8:	7179                	add	sp,sp,-48
    80002cea:	f406                	sd	ra,40(sp)
    80002cec:	f022                	sd	s0,32(sp)
    80002cee:	ec26                	sd	s1,24(sp)
    80002cf0:	e84a                	sd	s2,16(sp)
    80002cf2:	e44e                	sd	s3,8(sp)
    80002cf4:	e052                	sd	s4,0(sp)
    80002cf6:	1800                	add	s0,sp,48
    80002cf8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cfa:	05050493          	add	s1,a0,80
    80002cfe:	08050913          	add	s2,a0,128
    80002d02:	a021                	j	80002d0a <itrunc+0x22>
    80002d04:	0491                	add	s1,s1,4
    80002d06:	01248d63          	beq	s1,s2,80002d20 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d0a:	408c                	lw	a1,0(s1)
    80002d0c:	dde5                	beqz	a1,80002d04 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d0e:	0009a503          	lw	a0,0(s3)
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	912080e7          	jalr	-1774(ra) # 80002624 <bfree>
      ip->addrs[i] = 0;
    80002d1a:	0004a023          	sw	zero,0(s1)
    80002d1e:	b7dd                	j	80002d04 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d20:	0809a583          	lw	a1,128(s3)
    80002d24:	e185                	bnez	a1,80002d44 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d26:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d2a:	854e                	mv	a0,s3
    80002d2c:	00000097          	auipc	ra,0x0
    80002d30:	de2080e7          	jalr	-542(ra) # 80002b0e <iupdate>
}
    80002d34:	70a2                	ld	ra,40(sp)
    80002d36:	7402                	ld	s0,32(sp)
    80002d38:	64e2                	ld	s1,24(sp)
    80002d3a:	6942                	ld	s2,16(sp)
    80002d3c:	69a2                	ld	s3,8(sp)
    80002d3e:	6a02                	ld	s4,0(sp)
    80002d40:	6145                	add	sp,sp,48
    80002d42:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d44:	0009a503          	lw	a0,0(s3)
    80002d48:	fffff097          	auipc	ra,0xfffff
    80002d4c:	698080e7          	jalr	1688(ra) # 800023e0 <bread>
    80002d50:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d52:	05850493          	add	s1,a0,88
    80002d56:	45850913          	add	s2,a0,1112
    80002d5a:	a021                	j	80002d62 <itrunc+0x7a>
    80002d5c:	0491                	add	s1,s1,4
    80002d5e:	01248b63          	beq	s1,s2,80002d74 <itrunc+0x8c>
      if(a[j])
    80002d62:	408c                	lw	a1,0(s1)
    80002d64:	dde5                	beqz	a1,80002d5c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d66:	0009a503          	lw	a0,0(s3)
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	8ba080e7          	jalr	-1862(ra) # 80002624 <bfree>
    80002d72:	b7ed                	j	80002d5c <itrunc+0x74>
    brelse(bp);
    80002d74:	8552                	mv	a0,s4
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	79a080e7          	jalr	1946(ra) # 80002510 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d7e:	0809a583          	lw	a1,128(s3)
    80002d82:	0009a503          	lw	a0,0(s3)
    80002d86:	00000097          	auipc	ra,0x0
    80002d8a:	89e080e7          	jalr	-1890(ra) # 80002624 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d8e:	0809a023          	sw	zero,128(s3)
    80002d92:	bf51                	j	80002d26 <itrunc+0x3e>

0000000080002d94 <iput>:
{
    80002d94:	1101                	add	sp,sp,-32
    80002d96:	ec06                	sd	ra,24(sp)
    80002d98:	e822                	sd	s0,16(sp)
    80002d9a:	e426                	sd	s1,8(sp)
    80002d9c:	e04a                	sd	s2,0(sp)
    80002d9e:	1000                	add	s0,sp,32
    80002da0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002da2:	00014517          	auipc	a0,0x14
    80002da6:	7d650513          	add	a0,a0,2006 # 80017578 <itable>
    80002daa:	00003097          	auipc	ra,0x3
    80002dae:	388080e7          	jalr	904(ra) # 80006132 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002db2:	4498                	lw	a4,8(s1)
    80002db4:	4785                	li	a5,1
    80002db6:	02f70363          	beq	a4,a5,80002ddc <iput+0x48>
  ip->ref--;
    80002dba:	449c                	lw	a5,8(s1)
    80002dbc:	37fd                	addw	a5,a5,-1
    80002dbe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dc0:	00014517          	auipc	a0,0x14
    80002dc4:	7b850513          	add	a0,a0,1976 # 80017578 <itable>
    80002dc8:	00003097          	auipc	ra,0x3
    80002dcc:	41e080e7          	jalr	1054(ra) # 800061e6 <release>
}
    80002dd0:	60e2                	ld	ra,24(sp)
    80002dd2:	6442                	ld	s0,16(sp)
    80002dd4:	64a2                	ld	s1,8(sp)
    80002dd6:	6902                	ld	s2,0(sp)
    80002dd8:	6105                	add	sp,sp,32
    80002dda:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ddc:	40bc                	lw	a5,64(s1)
    80002dde:	dff1                	beqz	a5,80002dba <iput+0x26>
    80002de0:	04a49783          	lh	a5,74(s1)
    80002de4:	fbf9                	bnez	a5,80002dba <iput+0x26>
    acquiresleep(&ip->lock);
    80002de6:	01048913          	add	s2,s1,16
    80002dea:	854a                	mv	a0,s2
    80002dec:	00001097          	auipc	ra,0x1
    80002df0:	a94080e7          	jalr	-1388(ra) # 80003880 <acquiresleep>
    release(&itable.lock);
    80002df4:	00014517          	auipc	a0,0x14
    80002df8:	78450513          	add	a0,a0,1924 # 80017578 <itable>
    80002dfc:	00003097          	auipc	ra,0x3
    80002e00:	3ea080e7          	jalr	1002(ra) # 800061e6 <release>
    itrunc(ip);
    80002e04:	8526                	mv	a0,s1
    80002e06:	00000097          	auipc	ra,0x0
    80002e0a:	ee2080e7          	jalr	-286(ra) # 80002ce8 <itrunc>
    ip->type = 0;
    80002e0e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e12:	8526                	mv	a0,s1
    80002e14:	00000097          	auipc	ra,0x0
    80002e18:	cfa080e7          	jalr	-774(ra) # 80002b0e <iupdate>
    ip->valid = 0;
    80002e1c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e20:	854a                	mv	a0,s2
    80002e22:	00001097          	auipc	ra,0x1
    80002e26:	ab4080e7          	jalr	-1356(ra) # 800038d6 <releasesleep>
    acquire(&itable.lock);
    80002e2a:	00014517          	auipc	a0,0x14
    80002e2e:	74e50513          	add	a0,a0,1870 # 80017578 <itable>
    80002e32:	00003097          	auipc	ra,0x3
    80002e36:	300080e7          	jalr	768(ra) # 80006132 <acquire>
    80002e3a:	b741                	j	80002dba <iput+0x26>

0000000080002e3c <iunlockput>:
{
    80002e3c:	1101                	add	sp,sp,-32
    80002e3e:	ec06                	sd	ra,24(sp)
    80002e40:	e822                	sd	s0,16(sp)
    80002e42:	e426                	sd	s1,8(sp)
    80002e44:	1000                	add	s0,sp,32
    80002e46:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e48:	00000097          	auipc	ra,0x0
    80002e4c:	e54080e7          	jalr	-428(ra) # 80002c9c <iunlock>
  iput(ip);
    80002e50:	8526                	mv	a0,s1
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	f42080e7          	jalr	-190(ra) # 80002d94 <iput>
}
    80002e5a:	60e2                	ld	ra,24(sp)
    80002e5c:	6442                	ld	s0,16(sp)
    80002e5e:	64a2                	ld	s1,8(sp)
    80002e60:	6105                	add	sp,sp,32
    80002e62:	8082                	ret

0000000080002e64 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e64:	1141                	add	sp,sp,-16
    80002e66:	e422                	sd	s0,8(sp)
    80002e68:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002e6a:	411c                	lw	a5,0(a0)
    80002e6c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e6e:	415c                	lw	a5,4(a0)
    80002e70:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e72:	04451783          	lh	a5,68(a0)
    80002e76:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e7a:	04a51783          	lh	a5,74(a0)
    80002e7e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e82:	04c56783          	lwu	a5,76(a0)
    80002e86:	e99c                	sd	a5,16(a1)
}
    80002e88:	6422                	ld	s0,8(sp)
    80002e8a:	0141                	add	sp,sp,16
    80002e8c:	8082                	ret

0000000080002e8e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e8e:	457c                	lw	a5,76(a0)
    80002e90:	0ed7e963          	bltu	a5,a3,80002f82 <readi+0xf4>
{
    80002e94:	7159                	add	sp,sp,-112
    80002e96:	f486                	sd	ra,104(sp)
    80002e98:	f0a2                	sd	s0,96(sp)
    80002e9a:	eca6                	sd	s1,88(sp)
    80002e9c:	e8ca                	sd	s2,80(sp)
    80002e9e:	e4ce                	sd	s3,72(sp)
    80002ea0:	e0d2                	sd	s4,64(sp)
    80002ea2:	fc56                	sd	s5,56(sp)
    80002ea4:	f85a                	sd	s6,48(sp)
    80002ea6:	f45e                	sd	s7,40(sp)
    80002ea8:	f062                	sd	s8,32(sp)
    80002eaa:	ec66                	sd	s9,24(sp)
    80002eac:	e86a                	sd	s10,16(sp)
    80002eae:	e46e                	sd	s11,8(sp)
    80002eb0:	1880                	add	s0,sp,112
    80002eb2:	8baa                	mv	s7,a0
    80002eb4:	8c2e                	mv	s8,a1
    80002eb6:	8ab2                	mv	s5,a2
    80002eb8:	84b6                	mv	s1,a3
    80002eba:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ebc:	9f35                	addw	a4,a4,a3
    return 0;
    80002ebe:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ec0:	0ad76063          	bltu	a4,a3,80002f60 <readi+0xd2>
  if(off + n > ip->size)
    80002ec4:	00e7f463          	bgeu	a5,a4,80002ecc <readi+0x3e>
    n = ip->size - off;
    80002ec8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ecc:	0a0b0963          	beqz	s6,80002f7e <readi+0xf0>
    80002ed0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ed2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ed6:	5cfd                	li	s9,-1
    80002ed8:	a82d                	j	80002f12 <readi+0x84>
    80002eda:	020a1d93          	sll	s11,s4,0x20
    80002ede:	020ddd93          	srl	s11,s11,0x20
    80002ee2:	05890613          	add	a2,s2,88
    80002ee6:	86ee                	mv	a3,s11
    80002ee8:	963a                	add	a2,a2,a4
    80002eea:	85d6                	mv	a1,s5
    80002eec:	8562                	mv	a0,s8
    80002eee:	fffff097          	auipc	ra,0xfffff
    80002ef2:	a0e080e7          	jalr	-1522(ra) # 800018fc <either_copyout>
    80002ef6:	05950d63          	beq	a0,s9,80002f50 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002efa:	854a                	mv	a0,s2
    80002efc:	fffff097          	auipc	ra,0xfffff
    80002f00:	614080e7          	jalr	1556(ra) # 80002510 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f04:	013a09bb          	addw	s3,s4,s3
    80002f08:	009a04bb          	addw	s1,s4,s1
    80002f0c:	9aee                	add	s5,s5,s11
    80002f0e:	0569f763          	bgeu	s3,s6,80002f5c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f12:	000ba903          	lw	s2,0(s7)
    80002f16:	00a4d59b          	srlw	a1,s1,0xa
    80002f1a:	855e                	mv	a0,s7
    80002f1c:	00000097          	auipc	ra,0x0
    80002f20:	8b2080e7          	jalr	-1870(ra) # 800027ce <bmap>
    80002f24:	0005059b          	sext.w	a1,a0
    80002f28:	854a                	mv	a0,s2
    80002f2a:	fffff097          	auipc	ra,0xfffff
    80002f2e:	4b6080e7          	jalr	1206(ra) # 800023e0 <bread>
    80002f32:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f34:	3ff4f713          	and	a4,s1,1023
    80002f38:	40ed07bb          	subw	a5,s10,a4
    80002f3c:	413b06bb          	subw	a3,s6,s3
    80002f40:	8a3e                	mv	s4,a5
    80002f42:	2781                	sext.w	a5,a5
    80002f44:	0006861b          	sext.w	a2,a3
    80002f48:	f8f679e3          	bgeu	a2,a5,80002eda <readi+0x4c>
    80002f4c:	8a36                	mv	s4,a3
    80002f4e:	b771                	j	80002eda <readi+0x4c>
      brelse(bp);
    80002f50:	854a                	mv	a0,s2
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	5be080e7          	jalr	1470(ra) # 80002510 <brelse>
      tot = -1;
    80002f5a:	59fd                	li	s3,-1
  }
  return tot;
    80002f5c:	0009851b          	sext.w	a0,s3
}
    80002f60:	70a6                	ld	ra,104(sp)
    80002f62:	7406                	ld	s0,96(sp)
    80002f64:	64e6                	ld	s1,88(sp)
    80002f66:	6946                	ld	s2,80(sp)
    80002f68:	69a6                	ld	s3,72(sp)
    80002f6a:	6a06                	ld	s4,64(sp)
    80002f6c:	7ae2                	ld	s5,56(sp)
    80002f6e:	7b42                	ld	s6,48(sp)
    80002f70:	7ba2                	ld	s7,40(sp)
    80002f72:	7c02                	ld	s8,32(sp)
    80002f74:	6ce2                	ld	s9,24(sp)
    80002f76:	6d42                	ld	s10,16(sp)
    80002f78:	6da2                	ld	s11,8(sp)
    80002f7a:	6165                	add	sp,sp,112
    80002f7c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f7e:	89da                	mv	s3,s6
    80002f80:	bff1                	j	80002f5c <readi+0xce>
    return 0;
    80002f82:	4501                	li	a0,0
}
    80002f84:	8082                	ret

0000000080002f86 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f86:	457c                	lw	a5,76(a0)
    80002f88:	10d7e863          	bltu	a5,a3,80003098 <writei+0x112>
{
    80002f8c:	7159                	add	sp,sp,-112
    80002f8e:	f486                	sd	ra,104(sp)
    80002f90:	f0a2                	sd	s0,96(sp)
    80002f92:	eca6                	sd	s1,88(sp)
    80002f94:	e8ca                	sd	s2,80(sp)
    80002f96:	e4ce                	sd	s3,72(sp)
    80002f98:	e0d2                	sd	s4,64(sp)
    80002f9a:	fc56                	sd	s5,56(sp)
    80002f9c:	f85a                	sd	s6,48(sp)
    80002f9e:	f45e                	sd	s7,40(sp)
    80002fa0:	f062                	sd	s8,32(sp)
    80002fa2:	ec66                	sd	s9,24(sp)
    80002fa4:	e86a                	sd	s10,16(sp)
    80002fa6:	e46e                	sd	s11,8(sp)
    80002fa8:	1880                	add	s0,sp,112
    80002faa:	8b2a                	mv	s6,a0
    80002fac:	8c2e                	mv	s8,a1
    80002fae:	8ab2                	mv	s5,a2
    80002fb0:	8936                	mv	s2,a3
    80002fb2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fb4:	00e687bb          	addw	a5,a3,a4
    80002fb8:	0ed7e263          	bltu	a5,a3,8000309c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fbc:	00043737          	lui	a4,0x43
    80002fc0:	0ef76063          	bltu	a4,a5,800030a0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fc4:	0c0b8863          	beqz	s7,80003094 <writei+0x10e>
    80002fc8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fca:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fce:	5cfd                	li	s9,-1
    80002fd0:	a091                	j	80003014 <writei+0x8e>
    80002fd2:	02099d93          	sll	s11,s3,0x20
    80002fd6:	020ddd93          	srl	s11,s11,0x20
    80002fda:	05848513          	add	a0,s1,88
    80002fde:	86ee                	mv	a3,s11
    80002fe0:	8656                	mv	a2,s5
    80002fe2:	85e2                	mv	a1,s8
    80002fe4:	953a                	add	a0,a0,a4
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	96c080e7          	jalr	-1684(ra) # 80001952 <either_copyin>
    80002fee:	07950263          	beq	a0,s9,80003052 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ff2:	8526                	mv	a0,s1
    80002ff4:	00000097          	auipc	ra,0x0
    80002ff8:	76e080e7          	jalr	1902(ra) # 80003762 <log_write>
    brelse(bp);
    80002ffc:	8526                	mv	a0,s1
    80002ffe:	fffff097          	auipc	ra,0xfffff
    80003002:	512080e7          	jalr	1298(ra) # 80002510 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003006:	01498a3b          	addw	s4,s3,s4
    8000300a:	0129893b          	addw	s2,s3,s2
    8000300e:	9aee                	add	s5,s5,s11
    80003010:	057a7663          	bgeu	s4,s7,8000305c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003014:	000b2483          	lw	s1,0(s6)
    80003018:	00a9559b          	srlw	a1,s2,0xa
    8000301c:	855a                	mv	a0,s6
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	7b0080e7          	jalr	1968(ra) # 800027ce <bmap>
    80003026:	0005059b          	sext.w	a1,a0
    8000302a:	8526                	mv	a0,s1
    8000302c:	fffff097          	auipc	ra,0xfffff
    80003030:	3b4080e7          	jalr	948(ra) # 800023e0 <bread>
    80003034:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003036:	3ff97713          	and	a4,s2,1023
    8000303a:	40ed07bb          	subw	a5,s10,a4
    8000303e:	414b86bb          	subw	a3,s7,s4
    80003042:	89be                	mv	s3,a5
    80003044:	2781                	sext.w	a5,a5
    80003046:	0006861b          	sext.w	a2,a3
    8000304a:	f8f674e3          	bgeu	a2,a5,80002fd2 <writei+0x4c>
    8000304e:	89b6                	mv	s3,a3
    80003050:	b749                	j	80002fd2 <writei+0x4c>
      brelse(bp);
    80003052:	8526                	mv	a0,s1
    80003054:	fffff097          	auipc	ra,0xfffff
    80003058:	4bc080e7          	jalr	1212(ra) # 80002510 <brelse>
  }

  if(off > ip->size)
    8000305c:	04cb2783          	lw	a5,76(s6)
    80003060:	0127f463          	bgeu	a5,s2,80003068 <writei+0xe2>
    ip->size = off;
    80003064:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003068:	855a                	mv	a0,s6
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	aa4080e7          	jalr	-1372(ra) # 80002b0e <iupdate>

  return tot;
    80003072:	000a051b          	sext.w	a0,s4
}
    80003076:	70a6                	ld	ra,104(sp)
    80003078:	7406                	ld	s0,96(sp)
    8000307a:	64e6                	ld	s1,88(sp)
    8000307c:	6946                	ld	s2,80(sp)
    8000307e:	69a6                	ld	s3,72(sp)
    80003080:	6a06                	ld	s4,64(sp)
    80003082:	7ae2                	ld	s5,56(sp)
    80003084:	7b42                	ld	s6,48(sp)
    80003086:	7ba2                	ld	s7,40(sp)
    80003088:	7c02                	ld	s8,32(sp)
    8000308a:	6ce2                	ld	s9,24(sp)
    8000308c:	6d42                	ld	s10,16(sp)
    8000308e:	6da2                	ld	s11,8(sp)
    80003090:	6165                	add	sp,sp,112
    80003092:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003094:	8a5e                	mv	s4,s7
    80003096:	bfc9                	j	80003068 <writei+0xe2>
    return -1;
    80003098:	557d                	li	a0,-1
}
    8000309a:	8082                	ret
    return -1;
    8000309c:	557d                	li	a0,-1
    8000309e:	bfe1                	j	80003076 <writei+0xf0>
    return -1;
    800030a0:	557d                	li	a0,-1
    800030a2:	bfd1                	j	80003076 <writei+0xf0>

00000000800030a4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030a4:	1141                	add	sp,sp,-16
    800030a6:	e406                	sd	ra,8(sp)
    800030a8:	e022                	sd	s0,0(sp)
    800030aa:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030ac:	4639                	li	a2,14
    800030ae:	ffffd097          	auipc	ra,0xffffd
    800030b2:	1e6080e7          	jalr	486(ra) # 80000294 <strncmp>
}
    800030b6:	60a2                	ld	ra,8(sp)
    800030b8:	6402                	ld	s0,0(sp)
    800030ba:	0141                	add	sp,sp,16
    800030bc:	8082                	ret

00000000800030be <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030be:	7139                	add	sp,sp,-64
    800030c0:	fc06                	sd	ra,56(sp)
    800030c2:	f822                	sd	s0,48(sp)
    800030c4:	f426                	sd	s1,40(sp)
    800030c6:	f04a                	sd	s2,32(sp)
    800030c8:	ec4e                	sd	s3,24(sp)
    800030ca:	e852                	sd	s4,16(sp)
    800030cc:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030ce:	04451703          	lh	a4,68(a0)
    800030d2:	4785                	li	a5,1
    800030d4:	00f71a63          	bne	a4,a5,800030e8 <dirlookup+0x2a>
    800030d8:	892a                	mv	s2,a0
    800030da:	89ae                	mv	s3,a1
    800030dc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030de:	457c                	lw	a5,76(a0)
    800030e0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030e2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e4:	e79d                	bnez	a5,80003112 <dirlookup+0x54>
    800030e6:	a8a5                	j	8000315e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030e8:	00005517          	auipc	a0,0x5
    800030ec:	61850513          	add	a0,a0,1560 # 80008700 <syscall_names+0x1b0>
    800030f0:	00003097          	auipc	ra,0x3
    800030f4:	b0a080e7          	jalr	-1270(ra) # 80005bfa <panic>
      panic("dirlookup read");
    800030f8:	00005517          	auipc	a0,0x5
    800030fc:	62050513          	add	a0,a0,1568 # 80008718 <syscall_names+0x1c8>
    80003100:	00003097          	auipc	ra,0x3
    80003104:	afa080e7          	jalr	-1286(ra) # 80005bfa <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003108:	24c1                	addw	s1,s1,16
    8000310a:	04c92783          	lw	a5,76(s2)
    8000310e:	04f4f763          	bgeu	s1,a5,8000315c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003112:	4741                	li	a4,16
    80003114:	86a6                	mv	a3,s1
    80003116:	fc040613          	add	a2,s0,-64
    8000311a:	4581                	li	a1,0
    8000311c:	854a                	mv	a0,s2
    8000311e:	00000097          	auipc	ra,0x0
    80003122:	d70080e7          	jalr	-656(ra) # 80002e8e <readi>
    80003126:	47c1                	li	a5,16
    80003128:	fcf518e3          	bne	a0,a5,800030f8 <dirlookup+0x3a>
    if(de.inum == 0)
    8000312c:	fc045783          	lhu	a5,-64(s0)
    80003130:	dfe1                	beqz	a5,80003108 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003132:	fc240593          	add	a1,s0,-62
    80003136:	854e                	mv	a0,s3
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	f6c080e7          	jalr	-148(ra) # 800030a4 <namecmp>
    80003140:	f561                	bnez	a0,80003108 <dirlookup+0x4a>
      if(poff)
    80003142:	000a0463          	beqz	s4,8000314a <dirlookup+0x8c>
        *poff = off;
    80003146:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000314a:	fc045583          	lhu	a1,-64(s0)
    8000314e:	00092503          	lw	a0,0(s2)
    80003152:	fffff097          	auipc	ra,0xfffff
    80003156:	758080e7          	jalr	1880(ra) # 800028aa <iget>
    8000315a:	a011                	j	8000315e <dirlookup+0xa0>
  return 0;
    8000315c:	4501                	li	a0,0
}
    8000315e:	70e2                	ld	ra,56(sp)
    80003160:	7442                	ld	s0,48(sp)
    80003162:	74a2                	ld	s1,40(sp)
    80003164:	7902                	ld	s2,32(sp)
    80003166:	69e2                	ld	s3,24(sp)
    80003168:	6a42                	ld	s4,16(sp)
    8000316a:	6121                	add	sp,sp,64
    8000316c:	8082                	ret

000000008000316e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000316e:	711d                	add	sp,sp,-96
    80003170:	ec86                	sd	ra,88(sp)
    80003172:	e8a2                	sd	s0,80(sp)
    80003174:	e4a6                	sd	s1,72(sp)
    80003176:	e0ca                	sd	s2,64(sp)
    80003178:	fc4e                	sd	s3,56(sp)
    8000317a:	f852                	sd	s4,48(sp)
    8000317c:	f456                	sd	s5,40(sp)
    8000317e:	f05a                	sd	s6,32(sp)
    80003180:	ec5e                	sd	s7,24(sp)
    80003182:	e862                	sd	s8,16(sp)
    80003184:	e466                	sd	s9,8(sp)
    80003186:	1080                	add	s0,sp,96
    80003188:	84aa                	mv	s1,a0
    8000318a:	8b2e                	mv	s6,a1
    8000318c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000318e:	00054703          	lbu	a4,0(a0)
    80003192:	02f00793          	li	a5,47
    80003196:	02f70263          	beq	a4,a5,800031ba <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000319a:	ffffe097          	auipc	ra,0xffffe
    8000319e:	cf2080e7          	jalr	-782(ra) # 80000e8c <myproc>
    800031a2:	15053503          	ld	a0,336(a0)
    800031a6:	00000097          	auipc	ra,0x0
    800031aa:	9f6080e7          	jalr	-1546(ra) # 80002b9c <idup>
    800031ae:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031b0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031b4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031b6:	4b85                	li	s7,1
    800031b8:	a875                	j	80003274 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800031ba:	4585                	li	a1,1
    800031bc:	4505                	li	a0,1
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	6ec080e7          	jalr	1772(ra) # 800028aa <iget>
    800031c6:	8a2a                	mv	s4,a0
    800031c8:	b7e5                	j	800031b0 <namex+0x42>
      iunlockput(ip);
    800031ca:	8552                	mv	a0,s4
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	c70080e7          	jalr	-912(ra) # 80002e3c <iunlockput>
      return 0;
    800031d4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031d6:	8552                	mv	a0,s4
    800031d8:	60e6                	ld	ra,88(sp)
    800031da:	6446                	ld	s0,80(sp)
    800031dc:	64a6                	ld	s1,72(sp)
    800031de:	6906                	ld	s2,64(sp)
    800031e0:	79e2                	ld	s3,56(sp)
    800031e2:	7a42                	ld	s4,48(sp)
    800031e4:	7aa2                	ld	s5,40(sp)
    800031e6:	7b02                	ld	s6,32(sp)
    800031e8:	6be2                	ld	s7,24(sp)
    800031ea:	6c42                	ld	s8,16(sp)
    800031ec:	6ca2                	ld	s9,8(sp)
    800031ee:	6125                	add	sp,sp,96
    800031f0:	8082                	ret
      iunlock(ip);
    800031f2:	8552                	mv	a0,s4
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	aa8080e7          	jalr	-1368(ra) # 80002c9c <iunlock>
      return ip;
    800031fc:	bfe9                	j	800031d6 <namex+0x68>
      iunlockput(ip);
    800031fe:	8552                	mv	a0,s4
    80003200:	00000097          	auipc	ra,0x0
    80003204:	c3c080e7          	jalr	-964(ra) # 80002e3c <iunlockput>
      return 0;
    80003208:	8a4e                	mv	s4,s3
    8000320a:	b7f1                	j	800031d6 <namex+0x68>
  len = path - s;
    8000320c:	40998633          	sub	a2,s3,s1
    80003210:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003214:	099c5863          	bge	s8,s9,800032a4 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003218:	4639                	li	a2,14
    8000321a:	85a6                	mv	a1,s1
    8000321c:	8556                	mv	a0,s5
    8000321e:	ffffd097          	auipc	ra,0xffffd
    80003222:	002080e7          	jalr	2(ra) # 80000220 <memmove>
    80003226:	84ce                	mv	s1,s3
  while(*path == '/')
    80003228:	0004c783          	lbu	a5,0(s1)
    8000322c:	01279763          	bne	a5,s2,8000323a <namex+0xcc>
    path++;
    80003230:	0485                	add	s1,s1,1
  while(*path == '/')
    80003232:	0004c783          	lbu	a5,0(s1)
    80003236:	ff278de3          	beq	a5,s2,80003230 <namex+0xc2>
    ilock(ip);
    8000323a:	8552                	mv	a0,s4
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	99e080e7          	jalr	-1634(ra) # 80002bda <ilock>
    if(ip->type != T_DIR){
    80003244:	044a1783          	lh	a5,68(s4)
    80003248:	f97791e3          	bne	a5,s7,800031ca <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000324c:	000b0563          	beqz	s6,80003256 <namex+0xe8>
    80003250:	0004c783          	lbu	a5,0(s1)
    80003254:	dfd9                	beqz	a5,800031f2 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003256:	4601                	li	a2,0
    80003258:	85d6                	mv	a1,s5
    8000325a:	8552                	mv	a0,s4
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	e62080e7          	jalr	-414(ra) # 800030be <dirlookup>
    80003264:	89aa                	mv	s3,a0
    80003266:	dd41                	beqz	a0,800031fe <namex+0x90>
    iunlockput(ip);
    80003268:	8552                	mv	a0,s4
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	bd2080e7          	jalr	-1070(ra) # 80002e3c <iunlockput>
    ip = next;
    80003272:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003274:	0004c783          	lbu	a5,0(s1)
    80003278:	01279763          	bne	a5,s2,80003286 <namex+0x118>
    path++;
    8000327c:	0485                	add	s1,s1,1
  while(*path == '/')
    8000327e:	0004c783          	lbu	a5,0(s1)
    80003282:	ff278de3          	beq	a5,s2,8000327c <namex+0x10e>
  if(*path == 0)
    80003286:	cb9d                	beqz	a5,800032bc <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003288:	0004c783          	lbu	a5,0(s1)
    8000328c:	89a6                	mv	s3,s1
  len = path - s;
    8000328e:	4c81                	li	s9,0
    80003290:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003292:	01278963          	beq	a5,s2,800032a4 <namex+0x136>
    80003296:	dbbd                	beqz	a5,8000320c <namex+0x9e>
    path++;
    80003298:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    8000329a:	0009c783          	lbu	a5,0(s3)
    8000329e:	ff279ce3          	bne	a5,s2,80003296 <namex+0x128>
    800032a2:	b7ad                	j	8000320c <namex+0x9e>
    memmove(name, s, len);
    800032a4:	2601                	sext.w	a2,a2
    800032a6:	85a6                	mv	a1,s1
    800032a8:	8556                	mv	a0,s5
    800032aa:	ffffd097          	auipc	ra,0xffffd
    800032ae:	f76080e7          	jalr	-138(ra) # 80000220 <memmove>
    name[len] = 0;
    800032b2:	9cd6                	add	s9,s9,s5
    800032b4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032b8:	84ce                	mv	s1,s3
    800032ba:	b7bd                	j	80003228 <namex+0xba>
  if(nameiparent){
    800032bc:	f00b0de3          	beqz	s6,800031d6 <namex+0x68>
    iput(ip);
    800032c0:	8552                	mv	a0,s4
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	ad2080e7          	jalr	-1326(ra) # 80002d94 <iput>
    return 0;
    800032ca:	4a01                	li	s4,0
    800032cc:	b729                	j	800031d6 <namex+0x68>

00000000800032ce <dirlink>:
{
    800032ce:	7139                	add	sp,sp,-64
    800032d0:	fc06                	sd	ra,56(sp)
    800032d2:	f822                	sd	s0,48(sp)
    800032d4:	f426                	sd	s1,40(sp)
    800032d6:	f04a                	sd	s2,32(sp)
    800032d8:	ec4e                	sd	s3,24(sp)
    800032da:	e852                	sd	s4,16(sp)
    800032dc:	0080                	add	s0,sp,64
    800032de:	892a                	mv	s2,a0
    800032e0:	8a2e                	mv	s4,a1
    800032e2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032e4:	4601                	li	a2,0
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	dd8080e7          	jalr	-552(ra) # 800030be <dirlookup>
    800032ee:	e93d                	bnez	a0,80003364 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f0:	04c92483          	lw	s1,76(s2)
    800032f4:	c49d                	beqz	s1,80003322 <dirlink+0x54>
    800032f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f8:	4741                	li	a4,16
    800032fa:	86a6                	mv	a3,s1
    800032fc:	fc040613          	add	a2,s0,-64
    80003300:	4581                	li	a1,0
    80003302:	854a                	mv	a0,s2
    80003304:	00000097          	auipc	ra,0x0
    80003308:	b8a080e7          	jalr	-1142(ra) # 80002e8e <readi>
    8000330c:	47c1                	li	a5,16
    8000330e:	06f51163          	bne	a0,a5,80003370 <dirlink+0xa2>
    if(de.inum == 0)
    80003312:	fc045783          	lhu	a5,-64(s0)
    80003316:	c791                	beqz	a5,80003322 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003318:	24c1                	addw	s1,s1,16
    8000331a:	04c92783          	lw	a5,76(s2)
    8000331e:	fcf4ede3          	bltu	s1,a5,800032f8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003322:	4639                	li	a2,14
    80003324:	85d2                	mv	a1,s4
    80003326:	fc240513          	add	a0,s0,-62
    8000332a:	ffffd097          	auipc	ra,0xffffd
    8000332e:	fa6080e7          	jalr	-90(ra) # 800002d0 <strncpy>
  de.inum = inum;
    80003332:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003336:	4741                	li	a4,16
    80003338:	86a6                	mv	a3,s1
    8000333a:	fc040613          	add	a2,s0,-64
    8000333e:	4581                	li	a1,0
    80003340:	854a                	mv	a0,s2
    80003342:	00000097          	auipc	ra,0x0
    80003346:	c44080e7          	jalr	-956(ra) # 80002f86 <writei>
    8000334a:	872a                	mv	a4,a0
    8000334c:	47c1                	li	a5,16
  return 0;
    8000334e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003350:	02f71863          	bne	a4,a5,80003380 <dirlink+0xb2>
}
    80003354:	70e2                	ld	ra,56(sp)
    80003356:	7442                	ld	s0,48(sp)
    80003358:	74a2                	ld	s1,40(sp)
    8000335a:	7902                	ld	s2,32(sp)
    8000335c:	69e2                	ld	s3,24(sp)
    8000335e:	6a42                	ld	s4,16(sp)
    80003360:	6121                	add	sp,sp,64
    80003362:	8082                	ret
    iput(ip);
    80003364:	00000097          	auipc	ra,0x0
    80003368:	a30080e7          	jalr	-1488(ra) # 80002d94 <iput>
    return -1;
    8000336c:	557d                	li	a0,-1
    8000336e:	b7dd                	j	80003354 <dirlink+0x86>
      panic("dirlink read");
    80003370:	00005517          	auipc	a0,0x5
    80003374:	3b850513          	add	a0,a0,952 # 80008728 <syscall_names+0x1d8>
    80003378:	00003097          	auipc	ra,0x3
    8000337c:	882080e7          	jalr	-1918(ra) # 80005bfa <panic>
    panic("dirlink");
    80003380:	00005517          	auipc	a0,0x5
    80003384:	4b050513          	add	a0,a0,1200 # 80008830 <syscall_names+0x2e0>
    80003388:	00003097          	auipc	ra,0x3
    8000338c:	872080e7          	jalr	-1934(ra) # 80005bfa <panic>

0000000080003390 <namei>:

struct inode*
namei(char *path)
{
    80003390:	1101                	add	sp,sp,-32
    80003392:	ec06                	sd	ra,24(sp)
    80003394:	e822                	sd	s0,16(sp)
    80003396:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003398:	fe040613          	add	a2,s0,-32
    8000339c:	4581                	li	a1,0
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	dd0080e7          	jalr	-560(ra) # 8000316e <namex>
}
    800033a6:	60e2                	ld	ra,24(sp)
    800033a8:	6442                	ld	s0,16(sp)
    800033aa:	6105                	add	sp,sp,32
    800033ac:	8082                	ret

00000000800033ae <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033ae:	1141                	add	sp,sp,-16
    800033b0:	e406                	sd	ra,8(sp)
    800033b2:	e022                	sd	s0,0(sp)
    800033b4:	0800                	add	s0,sp,16
    800033b6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033b8:	4585                	li	a1,1
    800033ba:	00000097          	auipc	ra,0x0
    800033be:	db4080e7          	jalr	-588(ra) # 8000316e <namex>
}
    800033c2:	60a2                	ld	ra,8(sp)
    800033c4:	6402                	ld	s0,0(sp)
    800033c6:	0141                	add	sp,sp,16
    800033c8:	8082                	ret

00000000800033ca <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033ca:	1101                	add	sp,sp,-32
    800033cc:	ec06                	sd	ra,24(sp)
    800033ce:	e822                	sd	s0,16(sp)
    800033d0:	e426                	sd	s1,8(sp)
    800033d2:	e04a                	sd	s2,0(sp)
    800033d4:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033d6:	00016917          	auipc	s2,0x16
    800033da:	c4a90913          	add	s2,s2,-950 # 80019020 <log>
    800033de:	01892583          	lw	a1,24(s2)
    800033e2:	02892503          	lw	a0,40(s2)
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	ffa080e7          	jalr	-6(ra) # 800023e0 <bread>
    800033ee:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033f0:	02c92603          	lw	a2,44(s2)
    800033f4:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033f6:	00c05f63          	blez	a2,80003414 <write_head+0x4a>
    800033fa:	00016717          	auipc	a4,0x16
    800033fe:	c5670713          	add	a4,a4,-938 # 80019050 <log+0x30>
    80003402:	87aa                	mv	a5,a0
    80003404:	060a                	sll	a2,a2,0x2
    80003406:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003408:	4314                	lw	a3,0(a4)
    8000340a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000340c:	0711                	add	a4,a4,4
    8000340e:	0791                	add	a5,a5,4
    80003410:	fec79ce3          	bne	a5,a2,80003408 <write_head+0x3e>
  }
  bwrite(buf);
    80003414:	8526                	mv	a0,s1
    80003416:	fffff097          	auipc	ra,0xfffff
    8000341a:	0bc080e7          	jalr	188(ra) # 800024d2 <bwrite>
  brelse(buf);
    8000341e:	8526                	mv	a0,s1
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	0f0080e7          	jalr	240(ra) # 80002510 <brelse>
}
    80003428:	60e2                	ld	ra,24(sp)
    8000342a:	6442                	ld	s0,16(sp)
    8000342c:	64a2                	ld	s1,8(sp)
    8000342e:	6902                	ld	s2,0(sp)
    80003430:	6105                	add	sp,sp,32
    80003432:	8082                	ret

0000000080003434 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003434:	00016797          	auipc	a5,0x16
    80003438:	c187a783          	lw	a5,-1000(a5) # 8001904c <log+0x2c>
    8000343c:	0af05d63          	blez	a5,800034f6 <install_trans+0xc2>
{
    80003440:	7139                	add	sp,sp,-64
    80003442:	fc06                	sd	ra,56(sp)
    80003444:	f822                	sd	s0,48(sp)
    80003446:	f426                	sd	s1,40(sp)
    80003448:	f04a                	sd	s2,32(sp)
    8000344a:	ec4e                	sd	s3,24(sp)
    8000344c:	e852                	sd	s4,16(sp)
    8000344e:	e456                	sd	s5,8(sp)
    80003450:	e05a                	sd	s6,0(sp)
    80003452:	0080                	add	s0,sp,64
    80003454:	8b2a                	mv	s6,a0
    80003456:	00016a97          	auipc	s5,0x16
    8000345a:	bfaa8a93          	add	s5,s5,-1030 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003460:	00016997          	auipc	s3,0x16
    80003464:	bc098993          	add	s3,s3,-1088 # 80019020 <log>
    80003468:	a00d                	j	8000348a <install_trans+0x56>
    brelse(lbuf);
    8000346a:	854a                	mv	a0,s2
    8000346c:	fffff097          	auipc	ra,0xfffff
    80003470:	0a4080e7          	jalr	164(ra) # 80002510 <brelse>
    brelse(dbuf);
    80003474:	8526                	mv	a0,s1
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	09a080e7          	jalr	154(ra) # 80002510 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347e:	2a05                	addw	s4,s4,1
    80003480:	0a91                	add	s5,s5,4
    80003482:	02c9a783          	lw	a5,44(s3)
    80003486:	04fa5e63          	bge	s4,a5,800034e2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000348a:	0189a583          	lw	a1,24(s3)
    8000348e:	014585bb          	addw	a1,a1,s4
    80003492:	2585                	addw	a1,a1,1
    80003494:	0289a503          	lw	a0,40(s3)
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	f48080e7          	jalr	-184(ra) # 800023e0 <bread>
    800034a0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034a2:	000aa583          	lw	a1,0(s5)
    800034a6:	0289a503          	lw	a0,40(s3)
    800034aa:	fffff097          	auipc	ra,0xfffff
    800034ae:	f36080e7          	jalr	-202(ra) # 800023e0 <bread>
    800034b2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034b4:	40000613          	li	a2,1024
    800034b8:	05890593          	add	a1,s2,88
    800034bc:	05850513          	add	a0,a0,88
    800034c0:	ffffd097          	auipc	ra,0xffffd
    800034c4:	d60080e7          	jalr	-672(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034c8:	8526                	mv	a0,s1
    800034ca:	fffff097          	auipc	ra,0xfffff
    800034ce:	008080e7          	jalr	8(ra) # 800024d2 <bwrite>
    if(recovering == 0)
    800034d2:	f80b1ce3          	bnez	s6,8000346a <install_trans+0x36>
      bunpin(dbuf);
    800034d6:	8526                	mv	a0,s1
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	110080e7          	jalr	272(ra) # 800025e8 <bunpin>
    800034e0:	b769                	j	8000346a <install_trans+0x36>
}
    800034e2:	70e2                	ld	ra,56(sp)
    800034e4:	7442                	ld	s0,48(sp)
    800034e6:	74a2                	ld	s1,40(sp)
    800034e8:	7902                	ld	s2,32(sp)
    800034ea:	69e2                	ld	s3,24(sp)
    800034ec:	6a42                	ld	s4,16(sp)
    800034ee:	6aa2                	ld	s5,8(sp)
    800034f0:	6b02                	ld	s6,0(sp)
    800034f2:	6121                	add	sp,sp,64
    800034f4:	8082                	ret
    800034f6:	8082                	ret

00000000800034f8 <initlog>:
{
    800034f8:	7179                	add	sp,sp,-48
    800034fa:	f406                	sd	ra,40(sp)
    800034fc:	f022                	sd	s0,32(sp)
    800034fe:	ec26                	sd	s1,24(sp)
    80003500:	e84a                	sd	s2,16(sp)
    80003502:	e44e                	sd	s3,8(sp)
    80003504:	1800                	add	s0,sp,48
    80003506:	892a                	mv	s2,a0
    80003508:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000350a:	00016497          	auipc	s1,0x16
    8000350e:	b1648493          	add	s1,s1,-1258 # 80019020 <log>
    80003512:	00005597          	auipc	a1,0x5
    80003516:	22658593          	add	a1,a1,550 # 80008738 <syscall_names+0x1e8>
    8000351a:	8526                	mv	a0,s1
    8000351c:	00003097          	auipc	ra,0x3
    80003520:	b86080e7          	jalr	-1146(ra) # 800060a2 <initlock>
  log.start = sb->logstart;
    80003524:	0149a583          	lw	a1,20(s3)
    80003528:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000352a:	0109a783          	lw	a5,16(s3)
    8000352e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003530:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003534:	854a                	mv	a0,s2
    80003536:	fffff097          	auipc	ra,0xfffff
    8000353a:	eaa080e7          	jalr	-342(ra) # 800023e0 <bread>
  log.lh.n = lh->n;
    8000353e:	4d30                	lw	a2,88(a0)
    80003540:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003542:	00c05f63          	blez	a2,80003560 <initlog+0x68>
    80003546:	87aa                	mv	a5,a0
    80003548:	00016717          	auipc	a4,0x16
    8000354c:	b0870713          	add	a4,a4,-1272 # 80019050 <log+0x30>
    80003550:	060a                	sll	a2,a2,0x2
    80003552:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003554:	4ff4                	lw	a3,92(a5)
    80003556:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003558:	0791                	add	a5,a5,4
    8000355a:	0711                	add	a4,a4,4
    8000355c:	fec79ce3          	bne	a5,a2,80003554 <initlog+0x5c>
  brelse(buf);
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	fb0080e7          	jalr	-80(ra) # 80002510 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003568:	4505                	li	a0,1
    8000356a:	00000097          	auipc	ra,0x0
    8000356e:	eca080e7          	jalr	-310(ra) # 80003434 <install_trans>
  log.lh.n = 0;
    80003572:	00016797          	auipc	a5,0x16
    80003576:	ac07ad23          	sw	zero,-1318(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    8000357a:	00000097          	auipc	ra,0x0
    8000357e:	e50080e7          	jalr	-432(ra) # 800033ca <write_head>
}
    80003582:	70a2                	ld	ra,40(sp)
    80003584:	7402                	ld	s0,32(sp)
    80003586:	64e2                	ld	s1,24(sp)
    80003588:	6942                	ld	s2,16(sp)
    8000358a:	69a2                	ld	s3,8(sp)
    8000358c:	6145                	add	sp,sp,48
    8000358e:	8082                	ret

0000000080003590 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003590:	1101                	add	sp,sp,-32
    80003592:	ec06                	sd	ra,24(sp)
    80003594:	e822                	sd	s0,16(sp)
    80003596:	e426                	sd	s1,8(sp)
    80003598:	e04a                	sd	s2,0(sp)
    8000359a:	1000                	add	s0,sp,32
  acquire(&log.lock);
    8000359c:	00016517          	auipc	a0,0x16
    800035a0:	a8450513          	add	a0,a0,-1404 # 80019020 <log>
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	b8e080e7          	jalr	-1138(ra) # 80006132 <acquire>
  while(1){
    if(log.committing){
    800035ac:	00016497          	auipc	s1,0x16
    800035b0:	a7448493          	add	s1,s1,-1420 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035b4:	4979                	li	s2,30
    800035b6:	a039                	j	800035c4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035b8:	85a6                	mv	a1,s1
    800035ba:	8526                	mv	a0,s1
    800035bc:	ffffe097          	auipc	ra,0xffffe
    800035c0:	f9c080e7          	jalr	-100(ra) # 80001558 <sleep>
    if(log.committing){
    800035c4:	50dc                	lw	a5,36(s1)
    800035c6:	fbed                	bnez	a5,800035b8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c8:	5098                	lw	a4,32(s1)
    800035ca:	2705                	addw	a4,a4,1
    800035cc:	0027179b          	sllw	a5,a4,0x2
    800035d0:	9fb9                	addw	a5,a5,a4
    800035d2:	0017979b          	sllw	a5,a5,0x1
    800035d6:	54d4                	lw	a3,44(s1)
    800035d8:	9fb5                	addw	a5,a5,a3
    800035da:	00f95963          	bge	s2,a5,800035ec <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035de:	85a6                	mv	a1,s1
    800035e0:	8526                	mv	a0,s1
    800035e2:	ffffe097          	auipc	ra,0xffffe
    800035e6:	f76080e7          	jalr	-138(ra) # 80001558 <sleep>
    800035ea:	bfe9                	j	800035c4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035ec:	00016517          	auipc	a0,0x16
    800035f0:	a3450513          	add	a0,a0,-1484 # 80019020 <log>
    800035f4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800035f6:	00003097          	auipc	ra,0x3
    800035fa:	bf0080e7          	jalr	-1040(ra) # 800061e6 <release>
      break;
    }
  }
}
    800035fe:	60e2                	ld	ra,24(sp)
    80003600:	6442                	ld	s0,16(sp)
    80003602:	64a2                	ld	s1,8(sp)
    80003604:	6902                	ld	s2,0(sp)
    80003606:	6105                	add	sp,sp,32
    80003608:	8082                	ret

000000008000360a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000360a:	7139                	add	sp,sp,-64
    8000360c:	fc06                	sd	ra,56(sp)
    8000360e:	f822                	sd	s0,48(sp)
    80003610:	f426                	sd	s1,40(sp)
    80003612:	f04a                	sd	s2,32(sp)
    80003614:	ec4e                	sd	s3,24(sp)
    80003616:	e852                	sd	s4,16(sp)
    80003618:	e456                	sd	s5,8(sp)
    8000361a:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000361c:	00016497          	auipc	s1,0x16
    80003620:	a0448493          	add	s1,s1,-1532 # 80019020 <log>
    80003624:	8526                	mv	a0,s1
    80003626:	00003097          	auipc	ra,0x3
    8000362a:	b0c080e7          	jalr	-1268(ra) # 80006132 <acquire>
  log.outstanding -= 1;
    8000362e:	509c                	lw	a5,32(s1)
    80003630:	37fd                	addw	a5,a5,-1
    80003632:	0007891b          	sext.w	s2,a5
    80003636:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003638:	50dc                	lw	a5,36(s1)
    8000363a:	e7b9                	bnez	a5,80003688 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000363c:	04091e63          	bnez	s2,80003698 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003640:	00016497          	auipc	s1,0x16
    80003644:	9e048493          	add	s1,s1,-1568 # 80019020 <log>
    80003648:	4785                	li	a5,1
    8000364a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000364c:	8526                	mv	a0,s1
    8000364e:	00003097          	auipc	ra,0x3
    80003652:	b98080e7          	jalr	-1128(ra) # 800061e6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003656:	54dc                	lw	a5,44(s1)
    80003658:	06f04763          	bgtz	a5,800036c6 <end_op+0xbc>
    acquire(&log.lock);
    8000365c:	00016497          	auipc	s1,0x16
    80003660:	9c448493          	add	s1,s1,-1596 # 80019020 <log>
    80003664:	8526                	mv	a0,s1
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	acc080e7          	jalr	-1332(ra) # 80006132 <acquire>
    log.committing = 0;
    8000366e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003672:	8526                	mv	a0,s1
    80003674:	ffffe097          	auipc	ra,0xffffe
    80003678:	070080e7          	jalr	112(ra) # 800016e4 <wakeup>
    release(&log.lock);
    8000367c:	8526                	mv	a0,s1
    8000367e:	00003097          	auipc	ra,0x3
    80003682:	b68080e7          	jalr	-1176(ra) # 800061e6 <release>
}
    80003686:	a03d                	j	800036b4 <end_op+0xaa>
    panic("log.committing");
    80003688:	00005517          	auipc	a0,0x5
    8000368c:	0b850513          	add	a0,a0,184 # 80008740 <syscall_names+0x1f0>
    80003690:	00002097          	auipc	ra,0x2
    80003694:	56a080e7          	jalr	1386(ra) # 80005bfa <panic>
    wakeup(&log);
    80003698:	00016497          	auipc	s1,0x16
    8000369c:	98848493          	add	s1,s1,-1656 # 80019020 <log>
    800036a0:	8526                	mv	a0,s1
    800036a2:	ffffe097          	auipc	ra,0xffffe
    800036a6:	042080e7          	jalr	66(ra) # 800016e4 <wakeup>
  release(&log.lock);
    800036aa:	8526                	mv	a0,s1
    800036ac:	00003097          	auipc	ra,0x3
    800036b0:	b3a080e7          	jalr	-1222(ra) # 800061e6 <release>
}
    800036b4:	70e2                	ld	ra,56(sp)
    800036b6:	7442                	ld	s0,48(sp)
    800036b8:	74a2                	ld	s1,40(sp)
    800036ba:	7902                	ld	s2,32(sp)
    800036bc:	69e2                	ld	s3,24(sp)
    800036be:	6a42                	ld	s4,16(sp)
    800036c0:	6aa2                	ld	s5,8(sp)
    800036c2:	6121                	add	sp,sp,64
    800036c4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036c6:	00016a97          	auipc	s5,0x16
    800036ca:	98aa8a93          	add	s5,s5,-1654 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ce:	00016a17          	auipc	s4,0x16
    800036d2:	952a0a13          	add	s4,s4,-1710 # 80019020 <log>
    800036d6:	018a2583          	lw	a1,24(s4)
    800036da:	012585bb          	addw	a1,a1,s2
    800036de:	2585                	addw	a1,a1,1
    800036e0:	028a2503          	lw	a0,40(s4)
    800036e4:	fffff097          	auipc	ra,0xfffff
    800036e8:	cfc080e7          	jalr	-772(ra) # 800023e0 <bread>
    800036ec:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036ee:	000aa583          	lw	a1,0(s5)
    800036f2:	028a2503          	lw	a0,40(s4)
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	cea080e7          	jalr	-790(ra) # 800023e0 <bread>
    800036fe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003700:	40000613          	li	a2,1024
    80003704:	05850593          	add	a1,a0,88
    80003708:	05848513          	add	a0,s1,88
    8000370c:	ffffd097          	auipc	ra,0xffffd
    80003710:	b14080e7          	jalr	-1260(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    80003714:	8526                	mv	a0,s1
    80003716:	fffff097          	auipc	ra,0xfffff
    8000371a:	dbc080e7          	jalr	-580(ra) # 800024d2 <bwrite>
    brelse(from);
    8000371e:	854e                	mv	a0,s3
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	df0080e7          	jalr	-528(ra) # 80002510 <brelse>
    brelse(to);
    80003728:	8526                	mv	a0,s1
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	de6080e7          	jalr	-538(ra) # 80002510 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003732:	2905                	addw	s2,s2,1
    80003734:	0a91                	add	s5,s5,4
    80003736:	02ca2783          	lw	a5,44(s4)
    8000373a:	f8f94ee3          	blt	s2,a5,800036d6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	c8c080e7          	jalr	-884(ra) # 800033ca <write_head>
    install_trans(0); // Now install writes to home locations
    80003746:	4501                	li	a0,0
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	cec080e7          	jalr	-788(ra) # 80003434 <install_trans>
    log.lh.n = 0;
    80003750:	00016797          	auipc	a5,0x16
    80003754:	8e07ae23          	sw	zero,-1796(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	c72080e7          	jalr	-910(ra) # 800033ca <write_head>
    80003760:	bdf5                	j	8000365c <end_op+0x52>

0000000080003762 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003762:	1101                	add	sp,sp,-32
    80003764:	ec06                	sd	ra,24(sp)
    80003766:	e822                	sd	s0,16(sp)
    80003768:	e426                	sd	s1,8(sp)
    8000376a:	e04a                	sd	s2,0(sp)
    8000376c:	1000                	add	s0,sp,32
    8000376e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003770:	00016917          	auipc	s2,0x16
    80003774:	8b090913          	add	s2,s2,-1872 # 80019020 <log>
    80003778:	854a                	mv	a0,s2
    8000377a:	00003097          	auipc	ra,0x3
    8000377e:	9b8080e7          	jalr	-1608(ra) # 80006132 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003782:	02c92603          	lw	a2,44(s2)
    80003786:	47f5                	li	a5,29
    80003788:	06c7c563          	blt	a5,a2,800037f2 <log_write+0x90>
    8000378c:	00016797          	auipc	a5,0x16
    80003790:	8b07a783          	lw	a5,-1872(a5) # 8001903c <log+0x1c>
    80003794:	37fd                	addw	a5,a5,-1
    80003796:	04f65e63          	bge	a2,a5,800037f2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000379a:	00016797          	auipc	a5,0x16
    8000379e:	8a67a783          	lw	a5,-1882(a5) # 80019040 <log+0x20>
    800037a2:	06f05063          	blez	a5,80003802 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037a6:	4781                	li	a5,0
    800037a8:	06c05563          	blez	a2,80003812 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ac:	44cc                	lw	a1,12(s1)
    800037ae:	00016717          	auipc	a4,0x16
    800037b2:	8a270713          	add	a4,a4,-1886 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037b6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037b8:	4314                	lw	a3,0(a4)
    800037ba:	04b68c63          	beq	a3,a1,80003812 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037be:	2785                	addw	a5,a5,1
    800037c0:	0711                	add	a4,a4,4
    800037c2:	fef61be3          	bne	a2,a5,800037b8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037c6:	0621                	add	a2,a2,8
    800037c8:	060a                	sll	a2,a2,0x2
    800037ca:	00016797          	auipc	a5,0x16
    800037ce:	85678793          	add	a5,a5,-1962 # 80019020 <log>
    800037d2:	97b2                	add	a5,a5,a2
    800037d4:	44d8                	lw	a4,12(s1)
    800037d6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037d8:	8526                	mv	a0,s1
    800037da:	fffff097          	auipc	ra,0xfffff
    800037de:	dd2080e7          	jalr	-558(ra) # 800025ac <bpin>
    log.lh.n++;
    800037e2:	00016717          	auipc	a4,0x16
    800037e6:	83e70713          	add	a4,a4,-1986 # 80019020 <log>
    800037ea:	575c                	lw	a5,44(a4)
    800037ec:	2785                	addw	a5,a5,1
    800037ee:	d75c                	sw	a5,44(a4)
    800037f0:	a82d                	j	8000382a <log_write+0xc8>
    panic("too big a transaction");
    800037f2:	00005517          	auipc	a0,0x5
    800037f6:	f5e50513          	add	a0,a0,-162 # 80008750 <syscall_names+0x200>
    800037fa:	00002097          	auipc	ra,0x2
    800037fe:	400080e7          	jalr	1024(ra) # 80005bfa <panic>
    panic("log_write outside of trans");
    80003802:	00005517          	auipc	a0,0x5
    80003806:	f6650513          	add	a0,a0,-154 # 80008768 <syscall_names+0x218>
    8000380a:	00002097          	auipc	ra,0x2
    8000380e:	3f0080e7          	jalr	1008(ra) # 80005bfa <panic>
  log.lh.block[i] = b->blockno;
    80003812:	00878693          	add	a3,a5,8
    80003816:	068a                	sll	a3,a3,0x2
    80003818:	00016717          	auipc	a4,0x16
    8000381c:	80870713          	add	a4,a4,-2040 # 80019020 <log>
    80003820:	9736                	add	a4,a4,a3
    80003822:	44d4                	lw	a3,12(s1)
    80003824:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003826:	faf609e3          	beq	a2,a5,800037d8 <log_write+0x76>
  }
  release(&log.lock);
    8000382a:	00015517          	auipc	a0,0x15
    8000382e:	7f650513          	add	a0,a0,2038 # 80019020 <log>
    80003832:	00003097          	auipc	ra,0x3
    80003836:	9b4080e7          	jalr	-1612(ra) # 800061e6 <release>
}
    8000383a:	60e2                	ld	ra,24(sp)
    8000383c:	6442                	ld	s0,16(sp)
    8000383e:	64a2                	ld	s1,8(sp)
    80003840:	6902                	ld	s2,0(sp)
    80003842:	6105                	add	sp,sp,32
    80003844:	8082                	ret

0000000080003846 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003846:	1101                	add	sp,sp,-32
    80003848:	ec06                	sd	ra,24(sp)
    8000384a:	e822                	sd	s0,16(sp)
    8000384c:	e426                	sd	s1,8(sp)
    8000384e:	e04a                	sd	s2,0(sp)
    80003850:	1000                	add	s0,sp,32
    80003852:	84aa                	mv	s1,a0
    80003854:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003856:	00005597          	auipc	a1,0x5
    8000385a:	f3258593          	add	a1,a1,-206 # 80008788 <syscall_names+0x238>
    8000385e:	0521                	add	a0,a0,8
    80003860:	00003097          	auipc	ra,0x3
    80003864:	842080e7          	jalr	-1982(ra) # 800060a2 <initlock>
  lk->name = name;
    80003868:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000386c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003870:	0204a423          	sw	zero,40(s1)
}
    80003874:	60e2                	ld	ra,24(sp)
    80003876:	6442                	ld	s0,16(sp)
    80003878:	64a2                	ld	s1,8(sp)
    8000387a:	6902                	ld	s2,0(sp)
    8000387c:	6105                	add	sp,sp,32
    8000387e:	8082                	ret

0000000080003880 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003880:	1101                	add	sp,sp,-32
    80003882:	ec06                	sd	ra,24(sp)
    80003884:	e822                	sd	s0,16(sp)
    80003886:	e426                	sd	s1,8(sp)
    80003888:	e04a                	sd	s2,0(sp)
    8000388a:	1000                	add	s0,sp,32
    8000388c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000388e:	00850913          	add	s2,a0,8
    80003892:	854a                	mv	a0,s2
    80003894:	00003097          	auipc	ra,0x3
    80003898:	89e080e7          	jalr	-1890(ra) # 80006132 <acquire>
  while (lk->locked) {
    8000389c:	409c                	lw	a5,0(s1)
    8000389e:	cb89                	beqz	a5,800038b0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038a0:	85ca                	mv	a1,s2
    800038a2:	8526                	mv	a0,s1
    800038a4:	ffffe097          	auipc	ra,0xffffe
    800038a8:	cb4080e7          	jalr	-844(ra) # 80001558 <sleep>
  while (lk->locked) {
    800038ac:	409c                	lw	a5,0(s1)
    800038ae:	fbed                	bnez	a5,800038a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038b0:	4785                	li	a5,1
    800038b2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038b4:	ffffd097          	auipc	ra,0xffffd
    800038b8:	5d8080e7          	jalr	1496(ra) # 80000e8c <myproc>
    800038bc:	591c                	lw	a5,48(a0)
    800038be:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038c0:	854a                	mv	a0,s2
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	924080e7          	jalr	-1756(ra) # 800061e6 <release>
}
    800038ca:	60e2                	ld	ra,24(sp)
    800038cc:	6442                	ld	s0,16(sp)
    800038ce:	64a2                	ld	s1,8(sp)
    800038d0:	6902                	ld	s2,0(sp)
    800038d2:	6105                	add	sp,sp,32
    800038d4:	8082                	ret

00000000800038d6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038d6:	1101                	add	sp,sp,-32
    800038d8:	ec06                	sd	ra,24(sp)
    800038da:	e822                	sd	s0,16(sp)
    800038dc:	e426                	sd	s1,8(sp)
    800038de:	e04a                	sd	s2,0(sp)
    800038e0:	1000                	add	s0,sp,32
    800038e2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038e4:	00850913          	add	s2,a0,8
    800038e8:	854a                	mv	a0,s2
    800038ea:	00003097          	auipc	ra,0x3
    800038ee:	848080e7          	jalr	-1976(ra) # 80006132 <acquire>
  lk->locked = 0;
    800038f2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038f6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038fa:	8526                	mv	a0,s1
    800038fc:	ffffe097          	auipc	ra,0xffffe
    80003900:	de8080e7          	jalr	-536(ra) # 800016e4 <wakeup>
  release(&lk->lk);
    80003904:	854a                	mv	a0,s2
    80003906:	00003097          	auipc	ra,0x3
    8000390a:	8e0080e7          	jalr	-1824(ra) # 800061e6 <release>
}
    8000390e:	60e2                	ld	ra,24(sp)
    80003910:	6442                	ld	s0,16(sp)
    80003912:	64a2                	ld	s1,8(sp)
    80003914:	6902                	ld	s2,0(sp)
    80003916:	6105                	add	sp,sp,32
    80003918:	8082                	ret

000000008000391a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000391a:	7179                	add	sp,sp,-48
    8000391c:	f406                	sd	ra,40(sp)
    8000391e:	f022                	sd	s0,32(sp)
    80003920:	ec26                	sd	s1,24(sp)
    80003922:	e84a                	sd	s2,16(sp)
    80003924:	e44e                	sd	s3,8(sp)
    80003926:	1800                	add	s0,sp,48
    80003928:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000392a:	00850913          	add	s2,a0,8
    8000392e:	854a                	mv	a0,s2
    80003930:	00003097          	auipc	ra,0x3
    80003934:	802080e7          	jalr	-2046(ra) # 80006132 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003938:	409c                	lw	a5,0(s1)
    8000393a:	ef99                	bnez	a5,80003958 <holdingsleep+0x3e>
    8000393c:	4481                	li	s1,0
  release(&lk->lk);
    8000393e:	854a                	mv	a0,s2
    80003940:	00003097          	auipc	ra,0x3
    80003944:	8a6080e7          	jalr	-1882(ra) # 800061e6 <release>
  return r;
}
    80003948:	8526                	mv	a0,s1
    8000394a:	70a2                	ld	ra,40(sp)
    8000394c:	7402                	ld	s0,32(sp)
    8000394e:	64e2                	ld	s1,24(sp)
    80003950:	6942                	ld	s2,16(sp)
    80003952:	69a2                	ld	s3,8(sp)
    80003954:	6145                	add	sp,sp,48
    80003956:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003958:	0284a983          	lw	s3,40(s1)
    8000395c:	ffffd097          	auipc	ra,0xffffd
    80003960:	530080e7          	jalr	1328(ra) # 80000e8c <myproc>
    80003964:	5904                	lw	s1,48(a0)
    80003966:	413484b3          	sub	s1,s1,s3
    8000396a:	0014b493          	seqz	s1,s1
    8000396e:	bfc1                	j	8000393e <holdingsleep+0x24>

0000000080003970 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003970:	1141                	add	sp,sp,-16
    80003972:	e406                	sd	ra,8(sp)
    80003974:	e022                	sd	s0,0(sp)
    80003976:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003978:	00005597          	auipc	a1,0x5
    8000397c:	e2058593          	add	a1,a1,-480 # 80008798 <syscall_names+0x248>
    80003980:	00015517          	auipc	a0,0x15
    80003984:	7e850513          	add	a0,a0,2024 # 80019168 <ftable>
    80003988:	00002097          	auipc	ra,0x2
    8000398c:	71a080e7          	jalr	1818(ra) # 800060a2 <initlock>
}
    80003990:	60a2                	ld	ra,8(sp)
    80003992:	6402                	ld	s0,0(sp)
    80003994:	0141                	add	sp,sp,16
    80003996:	8082                	ret

0000000080003998 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003998:	1101                	add	sp,sp,-32
    8000399a:	ec06                	sd	ra,24(sp)
    8000399c:	e822                	sd	s0,16(sp)
    8000399e:	e426                	sd	s1,8(sp)
    800039a0:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039a2:	00015517          	auipc	a0,0x15
    800039a6:	7c650513          	add	a0,a0,1990 # 80019168 <ftable>
    800039aa:	00002097          	auipc	ra,0x2
    800039ae:	788080e7          	jalr	1928(ra) # 80006132 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b2:	00015497          	auipc	s1,0x15
    800039b6:	7ce48493          	add	s1,s1,1998 # 80019180 <ftable+0x18>
    800039ba:	00016717          	auipc	a4,0x16
    800039be:	76670713          	add	a4,a4,1894 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    800039c2:	40dc                	lw	a5,4(s1)
    800039c4:	cf99                	beqz	a5,800039e2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039c6:	02848493          	add	s1,s1,40
    800039ca:	fee49ce3          	bne	s1,a4,800039c2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039ce:	00015517          	auipc	a0,0x15
    800039d2:	79a50513          	add	a0,a0,1946 # 80019168 <ftable>
    800039d6:	00003097          	auipc	ra,0x3
    800039da:	810080e7          	jalr	-2032(ra) # 800061e6 <release>
  return 0;
    800039de:	4481                	li	s1,0
    800039e0:	a819                	j	800039f6 <filealloc+0x5e>
      f->ref = 1;
    800039e2:	4785                	li	a5,1
    800039e4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039e6:	00015517          	auipc	a0,0x15
    800039ea:	78250513          	add	a0,a0,1922 # 80019168 <ftable>
    800039ee:	00002097          	auipc	ra,0x2
    800039f2:	7f8080e7          	jalr	2040(ra) # 800061e6 <release>
}
    800039f6:	8526                	mv	a0,s1
    800039f8:	60e2                	ld	ra,24(sp)
    800039fa:	6442                	ld	s0,16(sp)
    800039fc:	64a2                	ld	s1,8(sp)
    800039fe:	6105                	add	sp,sp,32
    80003a00:	8082                	ret

0000000080003a02 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a02:	1101                	add	sp,sp,-32
    80003a04:	ec06                	sd	ra,24(sp)
    80003a06:	e822                	sd	s0,16(sp)
    80003a08:	e426                	sd	s1,8(sp)
    80003a0a:	1000                	add	s0,sp,32
    80003a0c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a0e:	00015517          	auipc	a0,0x15
    80003a12:	75a50513          	add	a0,a0,1882 # 80019168 <ftable>
    80003a16:	00002097          	auipc	ra,0x2
    80003a1a:	71c080e7          	jalr	1820(ra) # 80006132 <acquire>
  if(f->ref < 1)
    80003a1e:	40dc                	lw	a5,4(s1)
    80003a20:	02f05263          	blez	a5,80003a44 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a24:	2785                	addw	a5,a5,1
    80003a26:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a28:	00015517          	auipc	a0,0x15
    80003a2c:	74050513          	add	a0,a0,1856 # 80019168 <ftable>
    80003a30:	00002097          	auipc	ra,0x2
    80003a34:	7b6080e7          	jalr	1974(ra) # 800061e6 <release>
  return f;
}
    80003a38:	8526                	mv	a0,s1
    80003a3a:	60e2                	ld	ra,24(sp)
    80003a3c:	6442                	ld	s0,16(sp)
    80003a3e:	64a2                	ld	s1,8(sp)
    80003a40:	6105                	add	sp,sp,32
    80003a42:	8082                	ret
    panic("filedup");
    80003a44:	00005517          	auipc	a0,0x5
    80003a48:	d5c50513          	add	a0,a0,-676 # 800087a0 <syscall_names+0x250>
    80003a4c:	00002097          	auipc	ra,0x2
    80003a50:	1ae080e7          	jalr	430(ra) # 80005bfa <panic>

0000000080003a54 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a54:	7139                	add	sp,sp,-64
    80003a56:	fc06                	sd	ra,56(sp)
    80003a58:	f822                	sd	s0,48(sp)
    80003a5a:	f426                	sd	s1,40(sp)
    80003a5c:	f04a                	sd	s2,32(sp)
    80003a5e:	ec4e                	sd	s3,24(sp)
    80003a60:	e852                	sd	s4,16(sp)
    80003a62:	e456                	sd	s5,8(sp)
    80003a64:	0080                	add	s0,sp,64
    80003a66:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a68:	00015517          	auipc	a0,0x15
    80003a6c:	70050513          	add	a0,a0,1792 # 80019168 <ftable>
    80003a70:	00002097          	auipc	ra,0x2
    80003a74:	6c2080e7          	jalr	1730(ra) # 80006132 <acquire>
  if(f->ref < 1)
    80003a78:	40dc                	lw	a5,4(s1)
    80003a7a:	06f05163          	blez	a5,80003adc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a7e:	37fd                	addw	a5,a5,-1
    80003a80:	0007871b          	sext.w	a4,a5
    80003a84:	c0dc                	sw	a5,4(s1)
    80003a86:	06e04363          	bgtz	a4,80003aec <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a8a:	0004a903          	lw	s2,0(s1)
    80003a8e:	0094ca83          	lbu	s5,9(s1)
    80003a92:	0104ba03          	ld	s4,16(s1)
    80003a96:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a9a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a9e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aa2:	00015517          	auipc	a0,0x15
    80003aa6:	6c650513          	add	a0,a0,1734 # 80019168 <ftable>
    80003aaa:	00002097          	auipc	ra,0x2
    80003aae:	73c080e7          	jalr	1852(ra) # 800061e6 <release>

  if(ff.type == FD_PIPE){
    80003ab2:	4785                	li	a5,1
    80003ab4:	04f90d63          	beq	s2,a5,80003b0e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ab8:	3979                	addw	s2,s2,-2
    80003aba:	4785                	li	a5,1
    80003abc:	0527e063          	bltu	a5,s2,80003afc <fileclose+0xa8>
    begin_op();
    80003ac0:	00000097          	auipc	ra,0x0
    80003ac4:	ad0080e7          	jalr	-1328(ra) # 80003590 <begin_op>
    iput(ff.ip);
    80003ac8:	854e                	mv	a0,s3
    80003aca:	fffff097          	auipc	ra,0xfffff
    80003ace:	2ca080e7          	jalr	714(ra) # 80002d94 <iput>
    end_op();
    80003ad2:	00000097          	auipc	ra,0x0
    80003ad6:	b38080e7          	jalr	-1224(ra) # 8000360a <end_op>
    80003ada:	a00d                	j	80003afc <fileclose+0xa8>
    panic("fileclose");
    80003adc:	00005517          	auipc	a0,0x5
    80003ae0:	ccc50513          	add	a0,a0,-820 # 800087a8 <syscall_names+0x258>
    80003ae4:	00002097          	auipc	ra,0x2
    80003ae8:	116080e7          	jalr	278(ra) # 80005bfa <panic>
    release(&ftable.lock);
    80003aec:	00015517          	auipc	a0,0x15
    80003af0:	67c50513          	add	a0,a0,1660 # 80019168 <ftable>
    80003af4:	00002097          	auipc	ra,0x2
    80003af8:	6f2080e7          	jalr	1778(ra) # 800061e6 <release>
  }
}
    80003afc:	70e2                	ld	ra,56(sp)
    80003afe:	7442                	ld	s0,48(sp)
    80003b00:	74a2                	ld	s1,40(sp)
    80003b02:	7902                	ld	s2,32(sp)
    80003b04:	69e2                	ld	s3,24(sp)
    80003b06:	6a42                	ld	s4,16(sp)
    80003b08:	6aa2                	ld	s5,8(sp)
    80003b0a:	6121                	add	sp,sp,64
    80003b0c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b0e:	85d6                	mv	a1,s5
    80003b10:	8552                	mv	a0,s4
    80003b12:	00000097          	auipc	ra,0x0
    80003b16:	348080e7          	jalr	840(ra) # 80003e5a <pipeclose>
    80003b1a:	b7cd                	j	80003afc <fileclose+0xa8>

0000000080003b1c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b1c:	715d                	add	sp,sp,-80
    80003b1e:	e486                	sd	ra,72(sp)
    80003b20:	e0a2                	sd	s0,64(sp)
    80003b22:	fc26                	sd	s1,56(sp)
    80003b24:	f84a                	sd	s2,48(sp)
    80003b26:	f44e                	sd	s3,40(sp)
    80003b28:	0880                	add	s0,sp,80
    80003b2a:	84aa                	mv	s1,a0
    80003b2c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b2e:	ffffd097          	auipc	ra,0xffffd
    80003b32:	35e080e7          	jalr	862(ra) # 80000e8c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b36:	409c                	lw	a5,0(s1)
    80003b38:	37f9                	addw	a5,a5,-2
    80003b3a:	4705                	li	a4,1
    80003b3c:	04f76763          	bltu	a4,a5,80003b8a <filestat+0x6e>
    80003b40:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b42:	6c88                	ld	a0,24(s1)
    80003b44:	fffff097          	auipc	ra,0xfffff
    80003b48:	096080e7          	jalr	150(ra) # 80002bda <ilock>
    stati(f->ip, &st);
    80003b4c:	fb840593          	add	a1,s0,-72
    80003b50:	6c88                	ld	a0,24(s1)
    80003b52:	fffff097          	auipc	ra,0xfffff
    80003b56:	312080e7          	jalr	786(ra) # 80002e64 <stati>
    iunlock(f->ip);
    80003b5a:	6c88                	ld	a0,24(s1)
    80003b5c:	fffff097          	auipc	ra,0xfffff
    80003b60:	140080e7          	jalr	320(ra) # 80002c9c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b64:	46e1                	li	a3,24
    80003b66:	fb840613          	add	a2,s0,-72
    80003b6a:	85ce                	mv	a1,s3
    80003b6c:	05093503          	ld	a0,80(s2)
    80003b70:	ffffd097          	auipc	ra,0xffffd
    80003b74:	fe0080e7          	jalr	-32(ra) # 80000b50 <copyout>
    80003b78:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b7c:	60a6                	ld	ra,72(sp)
    80003b7e:	6406                	ld	s0,64(sp)
    80003b80:	74e2                	ld	s1,56(sp)
    80003b82:	7942                	ld	s2,48(sp)
    80003b84:	79a2                	ld	s3,40(sp)
    80003b86:	6161                	add	sp,sp,80
    80003b88:	8082                	ret
  return -1;
    80003b8a:	557d                	li	a0,-1
    80003b8c:	bfc5                	j	80003b7c <filestat+0x60>

0000000080003b8e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b8e:	7179                	add	sp,sp,-48
    80003b90:	f406                	sd	ra,40(sp)
    80003b92:	f022                	sd	s0,32(sp)
    80003b94:	ec26                	sd	s1,24(sp)
    80003b96:	e84a                	sd	s2,16(sp)
    80003b98:	e44e                	sd	s3,8(sp)
    80003b9a:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b9c:	00854783          	lbu	a5,8(a0)
    80003ba0:	c3d5                	beqz	a5,80003c44 <fileread+0xb6>
    80003ba2:	84aa                	mv	s1,a0
    80003ba4:	89ae                	mv	s3,a1
    80003ba6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ba8:	411c                	lw	a5,0(a0)
    80003baa:	4705                	li	a4,1
    80003bac:	04e78963          	beq	a5,a4,80003bfe <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bb0:	470d                	li	a4,3
    80003bb2:	04e78d63          	beq	a5,a4,80003c0c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bb6:	4709                	li	a4,2
    80003bb8:	06e79e63          	bne	a5,a4,80003c34 <fileread+0xa6>
    ilock(f->ip);
    80003bbc:	6d08                	ld	a0,24(a0)
    80003bbe:	fffff097          	auipc	ra,0xfffff
    80003bc2:	01c080e7          	jalr	28(ra) # 80002bda <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bc6:	874a                	mv	a4,s2
    80003bc8:	5094                	lw	a3,32(s1)
    80003bca:	864e                	mv	a2,s3
    80003bcc:	4585                	li	a1,1
    80003bce:	6c88                	ld	a0,24(s1)
    80003bd0:	fffff097          	auipc	ra,0xfffff
    80003bd4:	2be080e7          	jalr	702(ra) # 80002e8e <readi>
    80003bd8:	892a                	mv	s2,a0
    80003bda:	00a05563          	blez	a0,80003be4 <fileread+0x56>
      f->off += r;
    80003bde:	509c                	lw	a5,32(s1)
    80003be0:	9fa9                	addw	a5,a5,a0
    80003be2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003be4:	6c88                	ld	a0,24(s1)
    80003be6:	fffff097          	auipc	ra,0xfffff
    80003bea:	0b6080e7          	jalr	182(ra) # 80002c9c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bee:	854a                	mv	a0,s2
    80003bf0:	70a2                	ld	ra,40(sp)
    80003bf2:	7402                	ld	s0,32(sp)
    80003bf4:	64e2                	ld	s1,24(sp)
    80003bf6:	6942                	ld	s2,16(sp)
    80003bf8:	69a2                	ld	s3,8(sp)
    80003bfa:	6145                	add	sp,sp,48
    80003bfc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bfe:	6908                	ld	a0,16(a0)
    80003c00:	00000097          	auipc	ra,0x0
    80003c04:	3bc080e7          	jalr	956(ra) # 80003fbc <piperead>
    80003c08:	892a                	mv	s2,a0
    80003c0a:	b7d5                	j	80003bee <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c0c:	02451783          	lh	a5,36(a0)
    80003c10:	03079693          	sll	a3,a5,0x30
    80003c14:	92c1                	srl	a3,a3,0x30
    80003c16:	4725                	li	a4,9
    80003c18:	02d76863          	bltu	a4,a3,80003c48 <fileread+0xba>
    80003c1c:	0792                	sll	a5,a5,0x4
    80003c1e:	00015717          	auipc	a4,0x15
    80003c22:	4aa70713          	add	a4,a4,1194 # 800190c8 <devsw>
    80003c26:	97ba                	add	a5,a5,a4
    80003c28:	639c                	ld	a5,0(a5)
    80003c2a:	c38d                	beqz	a5,80003c4c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c2c:	4505                	li	a0,1
    80003c2e:	9782                	jalr	a5
    80003c30:	892a                	mv	s2,a0
    80003c32:	bf75                	j	80003bee <fileread+0x60>
    panic("fileread");
    80003c34:	00005517          	auipc	a0,0x5
    80003c38:	b8450513          	add	a0,a0,-1148 # 800087b8 <syscall_names+0x268>
    80003c3c:	00002097          	auipc	ra,0x2
    80003c40:	fbe080e7          	jalr	-66(ra) # 80005bfa <panic>
    return -1;
    80003c44:	597d                	li	s2,-1
    80003c46:	b765                	j	80003bee <fileread+0x60>
      return -1;
    80003c48:	597d                	li	s2,-1
    80003c4a:	b755                	j	80003bee <fileread+0x60>
    80003c4c:	597d                	li	s2,-1
    80003c4e:	b745                	j	80003bee <fileread+0x60>

0000000080003c50 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c50:	00954783          	lbu	a5,9(a0)
    80003c54:	10078e63          	beqz	a5,80003d70 <filewrite+0x120>
{
    80003c58:	715d                	add	sp,sp,-80
    80003c5a:	e486                	sd	ra,72(sp)
    80003c5c:	e0a2                	sd	s0,64(sp)
    80003c5e:	fc26                	sd	s1,56(sp)
    80003c60:	f84a                	sd	s2,48(sp)
    80003c62:	f44e                	sd	s3,40(sp)
    80003c64:	f052                	sd	s4,32(sp)
    80003c66:	ec56                	sd	s5,24(sp)
    80003c68:	e85a                	sd	s6,16(sp)
    80003c6a:	e45e                	sd	s7,8(sp)
    80003c6c:	e062                	sd	s8,0(sp)
    80003c6e:	0880                	add	s0,sp,80
    80003c70:	892a                	mv	s2,a0
    80003c72:	8b2e                	mv	s6,a1
    80003c74:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c76:	411c                	lw	a5,0(a0)
    80003c78:	4705                	li	a4,1
    80003c7a:	02e78263          	beq	a5,a4,80003c9e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c7e:	470d                	li	a4,3
    80003c80:	02e78563          	beq	a5,a4,80003caa <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c84:	4709                	li	a4,2
    80003c86:	0ce79d63          	bne	a5,a4,80003d60 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c8a:	0ac05b63          	blez	a2,80003d40 <filewrite+0xf0>
    int i = 0;
    80003c8e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003c90:	6b85                	lui	s7,0x1
    80003c92:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c96:	6c05                	lui	s8,0x1
    80003c98:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c9c:	a851                	j	80003d30 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003c9e:	6908                	ld	a0,16(a0)
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	22a080e7          	jalr	554(ra) # 80003eca <pipewrite>
    80003ca8:	a045                	j	80003d48 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003caa:	02451783          	lh	a5,36(a0)
    80003cae:	03079693          	sll	a3,a5,0x30
    80003cb2:	92c1                	srl	a3,a3,0x30
    80003cb4:	4725                	li	a4,9
    80003cb6:	0ad76f63          	bltu	a4,a3,80003d74 <filewrite+0x124>
    80003cba:	0792                	sll	a5,a5,0x4
    80003cbc:	00015717          	auipc	a4,0x15
    80003cc0:	40c70713          	add	a4,a4,1036 # 800190c8 <devsw>
    80003cc4:	97ba                	add	a5,a5,a4
    80003cc6:	679c                	ld	a5,8(a5)
    80003cc8:	cbc5                	beqz	a5,80003d78 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003cca:	4505                	li	a0,1
    80003ccc:	9782                	jalr	a5
    80003cce:	a8ad                	j	80003d48 <filewrite+0xf8>
      if(n1 > max)
    80003cd0:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	8bc080e7          	jalr	-1860(ra) # 80003590 <begin_op>
      ilock(f->ip);
    80003cdc:	01893503          	ld	a0,24(s2)
    80003ce0:	fffff097          	auipc	ra,0xfffff
    80003ce4:	efa080e7          	jalr	-262(ra) # 80002bda <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ce8:	8756                	mv	a4,s5
    80003cea:	02092683          	lw	a3,32(s2)
    80003cee:	01698633          	add	a2,s3,s6
    80003cf2:	4585                	li	a1,1
    80003cf4:	01893503          	ld	a0,24(s2)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	28e080e7          	jalr	654(ra) # 80002f86 <writei>
    80003d00:	84aa                	mv	s1,a0
    80003d02:	00a05763          	blez	a0,80003d10 <filewrite+0xc0>
        f->off += r;
    80003d06:	02092783          	lw	a5,32(s2)
    80003d0a:	9fa9                	addw	a5,a5,a0
    80003d0c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d10:	01893503          	ld	a0,24(s2)
    80003d14:	fffff097          	auipc	ra,0xfffff
    80003d18:	f88080e7          	jalr	-120(ra) # 80002c9c <iunlock>
      end_op();
    80003d1c:	00000097          	auipc	ra,0x0
    80003d20:	8ee080e7          	jalr	-1810(ra) # 8000360a <end_op>

      if(r != n1){
    80003d24:	009a9f63          	bne	s5,s1,80003d42 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003d28:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d2c:	0149db63          	bge	s3,s4,80003d42 <filewrite+0xf2>
      int n1 = n - i;
    80003d30:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d34:	0004879b          	sext.w	a5,s1
    80003d38:	f8fbdce3          	bge	s7,a5,80003cd0 <filewrite+0x80>
    80003d3c:	84e2                	mv	s1,s8
    80003d3e:	bf49                	j	80003cd0 <filewrite+0x80>
    int i = 0;
    80003d40:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d42:	033a1d63          	bne	s4,s3,80003d7c <filewrite+0x12c>
    80003d46:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d48:	60a6                	ld	ra,72(sp)
    80003d4a:	6406                	ld	s0,64(sp)
    80003d4c:	74e2                	ld	s1,56(sp)
    80003d4e:	7942                	ld	s2,48(sp)
    80003d50:	79a2                	ld	s3,40(sp)
    80003d52:	7a02                	ld	s4,32(sp)
    80003d54:	6ae2                	ld	s5,24(sp)
    80003d56:	6b42                	ld	s6,16(sp)
    80003d58:	6ba2                	ld	s7,8(sp)
    80003d5a:	6c02                	ld	s8,0(sp)
    80003d5c:	6161                	add	sp,sp,80
    80003d5e:	8082                	ret
    panic("filewrite");
    80003d60:	00005517          	auipc	a0,0x5
    80003d64:	a6850513          	add	a0,a0,-1432 # 800087c8 <syscall_names+0x278>
    80003d68:	00002097          	auipc	ra,0x2
    80003d6c:	e92080e7          	jalr	-366(ra) # 80005bfa <panic>
    return -1;
    80003d70:	557d                	li	a0,-1
}
    80003d72:	8082                	ret
      return -1;
    80003d74:	557d                	li	a0,-1
    80003d76:	bfc9                	j	80003d48 <filewrite+0xf8>
    80003d78:	557d                	li	a0,-1
    80003d7a:	b7f9                	j	80003d48 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003d7c:	557d                	li	a0,-1
    80003d7e:	b7e9                	j	80003d48 <filewrite+0xf8>

0000000080003d80 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d80:	7179                	add	sp,sp,-48
    80003d82:	f406                	sd	ra,40(sp)
    80003d84:	f022                	sd	s0,32(sp)
    80003d86:	ec26                	sd	s1,24(sp)
    80003d88:	e84a                	sd	s2,16(sp)
    80003d8a:	e44e                	sd	s3,8(sp)
    80003d8c:	e052                	sd	s4,0(sp)
    80003d8e:	1800                	add	s0,sp,48
    80003d90:	84aa                	mv	s1,a0
    80003d92:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d94:	0005b023          	sd	zero,0(a1)
    80003d98:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	bfc080e7          	jalr	-1028(ra) # 80003998 <filealloc>
    80003da4:	e088                	sd	a0,0(s1)
    80003da6:	c551                	beqz	a0,80003e32 <pipealloc+0xb2>
    80003da8:	00000097          	auipc	ra,0x0
    80003dac:	bf0080e7          	jalr	-1040(ra) # 80003998 <filealloc>
    80003db0:	00aa3023          	sd	a0,0(s4)
    80003db4:	c92d                	beqz	a0,80003e26 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003db6:	ffffc097          	auipc	ra,0xffffc
    80003dba:	364080e7          	jalr	868(ra) # 8000011a <kalloc>
    80003dbe:	892a                	mv	s2,a0
    80003dc0:	c125                	beqz	a0,80003e20 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dc2:	4985                	li	s3,1
    80003dc4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dc8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dcc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dd0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dd4:	00004597          	auipc	a1,0x4
    80003dd8:	60c58593          	add	a1,a1,1548 # 800083e0 <states.0+0x1a0>
    80003ddc:	00002097          	auipc	ra,0x2
    80003de0:	2c6080e7          	jalr	710(ra) # 800060a2 <initlock>
  (*f0)->type = FD_PIPE;
    80003de4:	609c                	ld	a5,0(s1)
    80003de6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dea:	609c                	ld	a5,0(s1)
    80003dec:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003df0:	609c                	ld	a5,0(s1)
    80003df2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003df6:	609c                	ld	a5,0(s1)
    80003df8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dfc:	000a3783          	ld	a5,0(s4)
    80003e00:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e04:	000a3783          	ld	a5,0(s4)
    80003e08:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e0c:	000a3783          	ld	a5,0(s4)
    80003e10:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e14:	000a3783          	ld	a5,0(s4)
    80003e18:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e1c:	4501                	li	a0,0
    80003e1e:	a025                	j	80003e46 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e20:	6088                	ld	a0,0(s1)
    80003e22:	e501                	bnez	a0,80003e2a <pipealloc+0xaa>
    80003e24:	a039                	j	80003e32 <pipealloc+0xb2>
    80003e26:	6088                	ld	a0,0(s1)
    80003e28:	c51d                	beqz	a0,80003e56 <pipealloc+0xd6>
    fileclose(*f0);
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	c2a080e7          	jalr	-982(ra) # 80003a54 <fileclose>
  if(*f1)
    80003e32:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e36:	557d                	li	a0,-1
  if(*f1)
    80003e38:	c799                	beqz	a5,80003e46 <pipealloc+0xc6>
    fileclose(*f1);
    80003e3a:	853e                	mv	a0,a5
    80003e3c:	00000097          	auipc	ra,0x0
    80003e40:	c18080e7          	jalr	-1000(ra) # 80003a54 <fileclose>
  return -1;
    80003e44:	557d                	li	a0,-1
}
    80003e46:	70a2                	ld	ra,40(sp)
    80003e48:	7402                	ld	s0,32(sp)
    80003e4a:	64e2                	ld	s1,24(sp)
    80003e4c:	6942                	ld	s2,16(sp)
    80003e4e:	69a2                	ld	s3,8(sp)
    80003e50:	6a02                	ld	s4,0(sp)
    80003e52:	6145                	add	sp,sp,48
    80003e54:	8082                	ret
  return -1;
    80003e56:	557d                	li	a0,-1
    80003e58:	b7fd                	j	80003e46 <pipealloc+0xc6>

0000000080003e5a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e5a:	1101                	add	sp,sp,-32
    80003e5c:	ec06                	sd	ra,24(sp)
    80003e5e:	e822                	sd	s0,16(sp)
    80003e60:	e426                	sd	s1,8(sp)
    80003e62:	e04a                	sd	s2,0(sp)
    80003e64:	1000                	add	s0,sp,32
    80003e66:	84aa                	mv	s1,a0
    80003e68:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e6a:	00002097          	auipc	ra,0x2
    80003e6e:	2c8080e7          	jalr	712(ra) # 80006132 <acquire>
  if(writable){
    80003e72:	02090d63          	beqz	s2,80003eac <pipeclose+0x52>
    pi->writeopen = 0;
    80003e76:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e7a:	21848513          	add	a0,s1,536
    80003e7e:	ffffe097          	auipc	ra,0xffffe
    80003e82:	866080e7          	jalr	-1946(ra) # 800016e4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e86:	2204b783          	ld	a5,544(s1)
    80003e8a:	eb95                	bnez	a5,80003ebe <pipeclose+0x64>
    release(&pi->lock);
    80003e8c:	8526                	mv	a0,s1
    80003e8e:	00002097          	auipc	ra,0x2
    80003e92:	358080e7          	jalr	856(ra) # 800061e6 <release>
    kfree((char*)pi);
    80003e96:	8526                	mv	a0,s1
    80003e98:	ffffc097          	auipc	ra,0xffffc
    80003e9c:	184080e7          	jalr	388(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ea0:	60e2                	ld	ra,24(sp)
    80003ea2:	6442                	ld	s0,16(sp)
    80003ea4:	64a2                	ld	s1,8(sp)
    80003ea6:	6902                	ld	s2,0(sp)
    80003ea8:	6105                	add	sp,sp,32
    80003eaa:	8082                	ret
    pi->readopen = 0;
    80003eac:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eb0:	21c48513          	add	a0,s1,540
    80003eb4:	ffffe097          	auipc	ra,0xffffe
    80003eb8:	830080e7          	jalr	-2000(ra) # 800016e4 <wakeup>
    80003ebc:	b7e9                	j	80003e86 <pipeclose+0x2c>
    release(&pi->lock);
    80003ebe:	8526                	mv	a0,s1
    80003ec0:	00002097          	auipc	ra,0x2
    80003ec4:	326080e7          	jalr	806(ra) # 800061e6 <release>
}
    80003ec8:	bfe1                	j	80003ea0 <pipeclose+0x46>

0000000080003eca <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eca:	711d                	add	sp,sp,-96
    80003ecc:	ec86                	sd	ra,88(sp)
    80003ece:	e8a2                	sd	s0,80(sp)
    80003ed0:	e4a6                	sd	s1,72(sp)
    80003ed2:	e0ca                	sd	s2,64(sp)
    80003ed4:	fc4e                	sd	s3,56(sp)
    80003ed6:	f852                	sd	s4,48(sp)
    80003ed8:	f456                	sd	s5,40(sp)
    80003eda:	f05a                	sd	s6,32(sp)
    80003edc:	ec5e                	sd	s7,24(sp)
    80003ede:	e862                	sd	s8,16(sp)
    80003ee0:	1080                	add	s0,sp,96
    80003ee2:	84aa                	mv	s1,a0
    80003ee4:	8aae                	mv	s5,a1
    80003ee6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ee8:	ffffd097          	auipc	ra,0xffffd
    80003eec:	fa4080e7          	jalr	-92(ra) # 80000e8c <myproc>
    80003ef0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	00002097          	auipc	ra,0x2
    80003ef8:	23e080e7          	jalr	574(ra) # 80006132 <acquire>
  while(i < n){
    80003efc:	0b405363          	blez	s4,80003fa2 <pipewrite+0xd8>
  int i = 0;
    80003f00:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f02:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f04:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f08:	21c48b93          	add	s7,s1,540
    80003f0c:	a089                	j	80003f4e <pipewrite+0x84>
      release(&pi->lock);
    80003f0e:	8526                	mv	a0,s1
    80003f10:	00002097          	auipc	ra,0x2
    80003f14:	2d6080e7          	jalr	726(ra) # 800061e6 <release>
      return -1;
    80003f18:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f1a:	854a                	mv	a0,s2
    80003f1c:	60e6                	ld	ra,88(sp)
    80003f1e:	6446                	ld	s0,80(sp)
    80003f20:	64a6                	ld	s1,72(sp)
    80003f22:	6906                	ld	s2,64(sp)
    80003f24:	79e2                	ld	s3,56(sp)
    80003f26:	7a42                	ld	s4,48(sp)
    80003f28:	7aa2                	ld	s5,40(sp)
    80003f2a:	7b02                	ld	s6,32(sp)
    80003f2c:	6be2                	ld	s7,24(sp)
    80003f2e:	6c42                	ld	s8,16(sp)
    80003f30:	6125                	add	sp,sp,96
    80003f32:	8082                	ret
      wakeup(&pi->nread);
    80003f34:	8562                	mv	a0,s8
    80003f36:	ffffd097          	auipc	ra,0xffffd
    80003f3a:	7ae080e7          	jalr	1966(ra) # 800016e4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f3e:	85a6                	mv	a1,s1
    80003f40:	855e                	mv	a0,s7
    80003f42:	ffffd097          	auipc	ra,0xffffd
    80003f46:	616080e7          	jalr	1558(ra) # 80001558 <sleep>
  while(i < n){
    80003f4a:	05495d63          	bge	s2,s4,80003fa4 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f4e:	2204a783          	lw	a5,544(s1)
    80003f52:	dfd5                	beqz	a5,80003f0e <pipewrite+0x44>
    80003f54:	0289a783          	lw	a5,40(s3)
    80003f58:	fbdd                	bnez	a5,80003f0e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f5a:	2184a783          	lw	a5,536(s1)
    80003f5e:	21c4a703          	lw	a4,540(s1)
    80003f62:	2007879b          	addw	a5,a5,512
    80003f66:	fcf707e3          	beq	a4,a5,80003f34 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f6a:	4685                	li	a3,1
    80003f6c:	01590633          	add	a2,s2,s5
    80003f70:	faf40593          	add	a1,s0,-81
    80003f74:	0509b503          	ld	a0,80(s3)
    80003f78:	ffffd097          	auipc	ra,0xffffd
    80003f7c:	c64080e7          	jalr	-924(ra) # 80000bdc <copyin>
    80003f80:	03650263          	beq	a0,s6,80003fa4 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f84:	21c4a783          	lw	a5,540(s1)
    80003f88:	0017871b          	addw	a4,a5,1
    80003f8c:	20e4ae23          	sw	a4,540(s1)
    80003f90:	1ff7f793          	and	a5,a5,511
    80003f94:	97a6                	add	a5,a5,s1
    80003f96:	faf44703          	lbu	a4,-81(s0)
    80003f9a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f9e:	2905                	addw	s2,s2,1
    80003fa0:	b76d                	j	80003f4a <pipewrite+0x80>
  int i = 0;
    80003fa2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fa4:	21848513          	add	a0,s1,536
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	73c080e7          	jalr	1852(ra) # 800016e4 <wakeup>
  release(&pi->lock);
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	00002097          	auipc	ra,0x2
    80003fb6:	234080e7          	jalr	564(ra) # 800061e6 <release>
  return i;
    80003fba:	b785                	j	80003f1a <pipewrite+0x50>

0000000080003fbc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fbc:	715d                	add	sp,sp,-80
    80003fbe:	e486                	sd	ra,72(sp)
    80003fc0:	e0a2                	sd	s0,64(sp)
    80003fc2:	fc26                	sd	s1,56(sp)
    80003fc4:	f84a                	sd	s2,48(sp)
    80003fc6:	f44e                	sd	s3,40(sp)
    80003fc8:	f052                	sd	s4,32(sp)
    80003fca:	ec56                	sd	s5,24(sp)
    80003fcc:	e85a                	sd	s6,16(sp)
    80003fce:	0880                	add	s0,sp,80
    80003fd0:	84aa                	mv	s1,a0
    80003fd2:	892e                	mv	s2,a1
    80003fd4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fd6:	ffffd097          	auipc	ra,0xffffd
    80003fda:	eb6080e7          	jalr	-330(ra) # 80000e8c <myproc>
    80003fde:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	00002097          	auipc	ra,0x2
    80003fe6:	150080e7          	jalr	336(ra) # 80006132 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fea:	2184a703          	lw	a4,536(s1)
    80003fee:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ff2:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff6:	02f71463          	bne	a4,a5,8000401e <piperead+0x62>
    80003ffa:	2244a783          	lw	a5,548(s1)
    80003ffe:	c385                	beqz	a5,8000401e <piperead+0x62>
    if(pr->killed){
    80004000:	028a2783          	lw	a5,40(s4)
    80004004:	ebc9                	bnez	a5,80004096 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004006:	85a6                	mv	a1,s1
    80004008:	854e                	mv	a0,s3
    8000400a:	ffffd097          	auipc	ra,0xffffd
    8000400e:	54e080e7          	jalr	1358(ra) # 80001558 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004012:	2184a703          	lw	a4,536(s1)
    80004016:	21c4a783          	lw	a5,540(s1)
    8000401a:	fef700e3          	beq	a4,a5,80003ffa <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000401e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004020:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004022:	05505463          	blez	s5,8000406a <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004026:	2184a783          	lw	a5,536(s1)
    8000402a:	21c4a703          	lw	a4,540(s1)
    8000402e:	02f70e63          	beq	a4,a5,8000406a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004032:	0017871b          	addw	a4,a5,1
    80004036:	20e4ac23          	sw	a4,536(s1)
    8000403a:	1ff7f793          	and	a5,a5,511
    8000403e:	97a6                	add	a5,a5,s1
    80004040:	0187c783          	lbu	a5,24(a5)
    80004044:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004048:	4685                	li	a3,1
    8000404a:	fbf40613          	add	a2,s0,-65
    8000404e:	85ca                	mv	a1,s2
    80004050:	050a3503          	ld	a0,80(s4)
    80004054:	ffffd097          	auipc	ra,0xffffd
    80004058:	afc080e7          	jalr	-1284(ra) # 80000b50 <copyout>
    8000405c:	01650763          	beq	a0,s6,8000406a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004060:	2985                	addw	s3,s3,1
    80004062:	0905                	add	s2,s2,1
    80004064:	fd3a91e3          	bne	s5,s3,80004026 <piperead+0x6a>
    80004068:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000406a:	21c48513          	add	a0,s1,540
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	676080e7          	jalr	1654(ra) # 800016e4 <wakeup>
  release(&pi->lock);
    80004076:	8526                	mv	a0,s1
    80004078:	00002097          	auipc	ra,0x2
    8000407c:	16e080e7          	jalr	366(ra) # 800061e6 <release>
  return i;
}
    80004080:	854e                	mv	a0,s3
    80004082:	60a6                	ld	ra,72(sp)
    80004084:	6406                	ld	s0,64(sp)
    80004086:	74e2                	ld	s1,56(sp)
    80004088:	7942                	ld	s2,48(sp)
    8000408a:	79a2                	ld	s3,40(sp)
    8000408c:	7a02                	ld	s4,32(sp)
    8000408e:	6ae2                	ld	s5,24(sp)
    80004090:	6b42                	ld	s6,16(sp)
    80004092:	6161                	add	sp,sp,80
    80004094:	8082                	ret
      release(&pi->lock);
    80004096:	8526                	mv	a0,s1
    80004098:	00002097          	auipc	ra,0x2
    8000409c:	14e080e7          	jalr	334(ra) # 800061e6 <release>
      return -1;
    800040a0:	59fd                	li	s3,-1
    800040a2:	bff9                	j	80004080 <piperead+0xc4>

00000000800040a4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040a4:	df010113          	add	sp,sp,-528
    800040a8:	20113423          	sd	ra,520(sp)
    800040ac:	20813023          	sd	s0,512(sp)
    800040b0:	ffa6                	sd	s1,504(sp)
    800040b2:	fbca                	sd	s2,496(sp)
    800040b4:	f7ce                	sd	s3,488(sp)
    800040b6:	f3d2                	sd	s4,480(sp)
    800040b8:	efd6                	sd	s5,472(sp)
    800040ba:	ebda                	sd	s6,464(sp)
    800040bc:	e7de                	sd	s7,456(sp)
    800040be:	e3e2                	sd	s8,448(sp)
    800040c0:	ff66                	sd	s9,440(sp)
    800040c2:	fb6a                	sd	s10,432(sp)
    800040c4:	f76e                	sd	s11,424(sp)
    800040c6:	0c00                	add	s0,sp,528
    800040c8:	892a                	mv	s2,a0
    800040ca:	dea43c23          	sd	a0,-520(s0)
    800040ce:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040d2:	ffffd097          	auipc	ra,0xffffd
    800040d6:	dba080e7          	jalr	-582(ra) # 80000e8c <myproc>
    800040da:	84aa                	mv	s1,a0

  begin_op();
    800040dc:	fffff097          	auipc	ra,0xfffff
    800040e0:	4b4080e7          	jalr	1204(ra) # 80003590 <begin_op>

  if((ip = namei(path)) == 0){
    800040e4:	854a                	mv	a0,s2
    800040e6:	fffff097          	auipc	ra,0xfffff
    800040ea:	2aa080e7          	jalr	682(ra) # 80003390 <namei>
    800040ee:	c92d                	beqz	a0,80004160 <exec+0xbc>
    800040f0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	ae8080e7          	jalr	-1304(ra) # 80002bda <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040fa:	04000713          	li	a4,64
    800040fe:	4681                	li	a3,0
    80004100:	e5040613          	add	a2,s0,-432
    80004104:	4581                	li	a1,0
    80004106:	8552                	mv	a0,s4
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	d86080e7          	jalr	-634(ra) # 80002e8e <readi>
    80004110:	04000793          	li	a5,64
    80004114:	00f51a63          	bne	a0,a5,80004128 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004118:	e5042703          	lw	a4,-432(s0)
    8000411c:	464c47b7          	lui	a5,0x464c4
    80004120:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004124:	04f70463          	beq	a4,a5,8000416c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004128:	8552                	mv	a0,s4
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	d12080e7          	jalr	-750(ra) # 80002e3c <iunlockput>
    end_op();
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	4d8080e7          	jalr	1240(ra) # 8000360a <end_op>
  }
  return -1;
    8000413a:	557d                	li	a0,-1
}
    8000413c:	20813083          	ld	ra,520(sp)
    80004140:	20013403          	ld	s0,512(sp)
    80004144:	74fe                	ld	s1,504(sp)
    80004146:	795e                	ld	s2,496(sp)
    80004148:	79be                	ld	s3,488(sp)
    8000414a:	7a1e                	ld	s4,480(sp)
    8000414c:	6afe                	ld	s5,472(sp)
    8000414e:	6b5e                	ld	s6,464(sp)
    80004150:	6bbe                	ld	s7,456(sp)
    80004152:	6c1e                	ld	s8,448(sp)
    80004154:	7cfa                	ld	s9,440(sp)
    80004156:	7d5a                	ld	s10,432(sp)
    80004158:	7dba                	ld	s11,424(sp)
    8000415a:	21010113          	add	sp,sp,528
    8000415e:	8082                	ret
    end_op();
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	4aa080e7          	jalr	1194(ra) # 8000360a <end_op>
    return -1;
    80004168:	557d                	li	a0,-1
    8000416a:	bfc9                	j	8000413c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000416c:	8526                	mv	a0,s1
    8000416e:	ffffd097          	auipc	ra,0xffffd
    80004172:	de2080e7          	jalr	-542(ra) # 80000f50 <proc_pagetable>
    80004176:	8b2a                	mv	s6,a0
    80004178:	d945                	beqz	a0,80004128 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000417a:	e7042d03          	lw	s10,-400(s0)
    8000417e:	e8845783          	lhu	a5,-376(s0)
    80004182:	cfe5                	beqz	a5,8000427a <exec+0x1d6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004184:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004186:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004188:	6c85                	lui	s9,0x1
    8000418a:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000418e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004192:	6a85                	lui	s5,0x1
    80004194:	a0b5                	j	80004200 <exec+0x15c>
      panic("loadseg: address should exist");
    80004196:	00004517          	auipc	a0,0x4
    8000419a:	64250513          	add	a0,a0,1602 # 800087d8 <syscall_names+0x288>
    8000419e:	00002097          	auipc	ra,0x2
    800041a2:	a5c080e7          	jalr	-1444(ra) # 80005bfa <panic>
    if(sz - i < PGSIZE)
    800041a6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041a8:	8726                	mv	a4,s1
    800041aa:	012c06bb          	addw	a3,s8,s2
    800041ae:	4581                	li	a1,0
    800041b0:	8552                	mv	a0,s4
    800041b2:	fffff097          	auipc	ra,0xfffff
    800041b6:	cdc080e7          	jalr	-804(ra) # 80002e8e <readi>
    800041ba:	2501                	sext.w	a0,a0
    800041bc:	24a49063          	bne	s1,a0,800043fc <exec+0x358>
  for(i = 0; i < sz; i += PGSIZE){
    800041c0:	012a893b          	addw	s2,s5,s2
    800041c4:	03397563          	bgeu	s2,s3,800041ee <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    800041c8:	02091593          	sll	a1,s2,0x20
    800041cc:	9181                	srl	a1,a1,0x20
    800041ce:	95de                	add	a1,a1,s7
    800041d0:	855a                	mv	a0,s6
    800041d2:	ffffc097          	auipc	ra,0xffffc
    800041d6:	376080e7          	jalr	886(ra) # 80000548 <walkaddr>
    800041da:	862a                	mv	a2,a0
    if(pa == 0)
    800041dc:	dd4d                	beqz	a0,80004196 <exec+0xf2>
    if(sz - i < PGSIZE)
    800041de:	412984bb          	subw	s1,s3,s2
    800041e2:	0004879b          	sext.w	a5,s1
    800041e6:	fcfcf0e3          	bgeu	s9,a5,800041a6 <exec+0x102>
    800041ea:	84d6                	mv	s1,s5
    800041ec:	bf6d                	j	800041a6 <exec+0x102>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800041ee:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f2:	2d85                	addw	s11,s11,1
    800041f4:	038d0d1b          	addw	s10,s10,56
    800041f8:	e8845783          	lhu	a5,-376(s0)
    800041fc:	08fdd063          	bge	s11,a5,8000427c <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004200:	2d01                	sext.w	s10,s10
    80004202:	03800713          	li	a4,56
    80004206:	86ea                	mv	a3,s10
    80004208:	e1840613          	add	a2,s0,-488
    8000420c:	4581                	li	a1,0
    8000420e:	8552                	mv	a0,s4
    80004210:	fffff097          	auipc	ra,0xfffff
    80004214:	c7e080e7          	jalr	-898(ra) # 80002e8e <readi>
    80004218:	03800793          	li	a5,56
    8000421c:	1cf51e63          	bne	a0,a5,800043f8 <exec+0x354>
    if(ph.type != ELF_PROG_LOAD)
    80004220:	e1842783          	lw	a5,-488(s0)
    80004224:	4705                	li	a4,1
    80004226:	fce796e3          	bne	a5,a4,800041f2 <exec+0x14e>
    if(ph.memsz < ph.filesz)
    8000422a:	e4043603          	ld	a2,-448(s0)
    8000422e:	e3843783          	ld	a5,-456(s0)
    80004232:	1ef66063          	bltu	a2,a5,80004412 <exec+0x36e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004236:	e2843783          	ld	a5,-472(s0)
    8000423a:	963e                	add	a2,a2,a5
    8000423c:	1cf66e63          	bltu	a2,a5,80004418 <exec+0x374>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004240:	85a6                	mv	a1,s1
    80004242:	855a                	mv	a0,s6
    80004244:	ffffc097          	auipc	ra,0xffffc
    80004248:	6b8080e7          	jalr	1720(ra) # 800008fc <uvmalloc>
    8000424c:	e0a43423          	sd	a0,-504(s0)
    80004250:	1c050763          	beqz	a0,8000441e <exec+0x37a>
    if((ph.vaddr % PGSIZE) != 0)
    80004254:	e2843b83          	ld	s7,-472(s0)
    80004258:	df043783          	ld	a5,-528(s0)
    8000425c:	00fbf7b3          	and	a5,s7,a5
    80004260:	18079e63          	bnez	a5,800043fc <exec+0x358>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004264:	e2042c03          	lw	s8,-480(s0)
    80004268:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000426c:	00098463          	beqz	s3,80004274 <exec+0x1d0>
    80004270:	4901                	li	s2,0
    80004272:	bf99                	j	800041c8 <exec+0x124>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004274:	e0843483          	ld	s1,-504(s0)
    80004278:	bfad                	j	800041f2 <exec+0x14e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000427a:	4481                	li	s1,0
  iunlockput(ip);
    8000427c:	8552                	mv	a0,s4
    8000427e:	fffff097          	auipc	ra,0xfffff
    80004282:	bbe080e7          	jalr	-1090(ra) # 80002e3c <iunlockput>
  end_op();
    80004286:	fffff097          	auipc	ra,0xfffff
    8000428a:	384080e7          	jalr	900(ra) # 8000360a <end_op>
  p = myproc();
    8000428e:	ffffd097          	auipc	ra,0xffffd
    80004292:	bfe080e7          	jalr	-1026(ra) # 80000e8c <myproc>
    80004296:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004298:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000429c:	6985                	lui	s3,0x1
    8000429e:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800042a0:	99a6                	add	s3,s3,s1
    800042a2:	77fd                	lui	a5,0xfffff
    800042a4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042a8:	6609                	lui	a2,0x2
    800042aa:	964e                	add	a2,a2,s3
    800042ac:	85ce                	mv	a1,s3
    800042ae:	855a                	mv	a0,s6
    800042b0:	ffffc097          	auipc	ra,0xffffc
    800042b4:	64c080e7          	jalr	1612(ra) # 800008fc <uvmalloc>
    800042b8:	892a                	mv	s2,a0
    800042ba:	e0a43423          	sd	a0,-504(s0)
    800042be:	e509                	bnez	a0,800042c8 <exec+0x224>
  if(pagetable)
    800042c0:	e1343423          	sd	s3,-504(s0)
    800042c4:	4a01                	li	s4,0
    800042c6:	aa1d                	j	800043fc <exec+0x358>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042c8:	75f9                	lui	a1,0xffffe
    800042ca:	95aa                	add	a1,a1,a0
    800042cc:	855a                	mv	a0,s6
    800042ce:	ffffd097          	auipc	ra,0xffffd
    800042d2:	850080e7          	jalr	-1968(ra) # 80000b1e <uvmclear>
  stackbase = sp - PGSIZE;
    800042d6:	7bfd                	lui	s7,0xfffff
    800042d8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800042da:	e0043783          	ld	a5,-512(s0)
    800042de:	6388                	ld	a0,0(a5)
    800042e0:	c52d                	beqz	a0,8000434a <exec+0x2a6>
    800042e2:	e9040993          	add	s3,s0,-368
    800042e6:	f9040c13          	add	s8,s0,-112
    800042ea:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042ec:	ffffc097          	auipc	ra,0xffffc
    800042f0:	052080e7          	jalr	82(ra) # 8000033e <strlen>
    800042f4:	0015079b          	addw	a5,a0,1
    800042f8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042fc:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004300:	13796263          	bltu	s2,s7,80004424 <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004304:	e0043d03          	ld	s10,-512(s0)
    80004308:	000d3a03          	ld	s4,0(s10)
    8000430c:	8552                	mv	a0,s4
    8000430e:	ffffc097          	auipc	ra,0xffffc
    80004312:	030080e7          	jalr	48(ra) # 8000033e <strlen>
    80004316:	0015069b          	addw	a3,a0,1
    8000431a:	8652                	mv	a2,s4
    8000431c:	85ca                	mv	a1,s2
    8000431e:	855a                	mv	a0,s6
    80004320:	ffffd097          	auipc	ra,0xffffd
    80004324:	830080e7          	jalr	-2000(ra) # 80000b50 <copyout>
    80004328:	10054063          	bltz	a0,80004428 <exec+0x384>
    ustack[argc] = sp;
    8000432c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004330:	0485                	add	s1,s1,1
    80004332:	008d0793          	add	a5,s10,8
    80004336:	e0f43023          	sd	a5,-512(s0)
    8000433a:	008d3503          	ld	a0,8(s10)
    8000433e:	c909                	beqz	a0,80004350 <exec+0x2ac>
    if(argc >= MAXARG)
    80004340:	09a1                	add	s3,s3,8
    80004342:	fb8995e3          	bne	s3,s8,800042ec <exec+0x248>
  ip = 0;
    80004346:	4a01                	li	s4,0
    80004348:	a855                	j	800043fc <exec+0x358>
  sp = sz;
    8000434a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000434e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004350:	00349793          	sll	a5,s1,0x3
    80004354:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    80004358:	97a2                	add	a5,a5,s0
    8000435a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000435e:	00148693          	add	a3,s1,1
    80004362:	068e                	sll	a3,a3,0x3
    80004364:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004368:	ff097913          	and	s2,s2,-16
  sz = sz1;
    8000436c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004370:	f57968e3          	bltu	s2,s7,800042c0 <exec+0x21c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004374:	e9040613          	add	a2,s0,-368
    80004378:	85ca                	mv	a1,s2
    8000437a:	855a                	mv	a0,s6
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	7d4080e7          	jalr	2004(ra) # 80000b50 <copyout>
    80004384:	0a054463          	bltz	a0,8000442c <exec+0x388>
  p->trapframe->a1 = sp;
    80004388:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000438c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004390:	df843783          	ld	a5,-520(s0)
    80004394:	0007c703          	lbu	a4,0(a5)
    80004398:	cf11                	beqz	a4,800043b4 <exec+0x310>
    8000439a:	0785                	add	a5,a5,1
    if(*s == '/')
    8000439c:	02f00693          	li	a3,47
    800043a0:	a039                	j	800043ae <exec+0x30a>
      last = s+1;
    800043a2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043a6:	0785                	add	a5,a5,1
    800043a8:	fff7c703          	lbu	a4,-1(a5)
    800043ac:	c701                	beqz	a4,800043b4 <exec+0x310>
    if(*s == '/')
    800043ae:	fed71ce3          	bne	a4,a3,800043a6 <exec+0x302>
    800043b2:	bfc5                	j	800043a2 <exec+0x2fe>
  safestrcpy(p->name, last, sizeof(p->name));
    800043b4:	4641                	li	a2,16
    800043b6:	df843583          	ld	a1,-520(s0)
    800043ba:	158a8513          	add	a0,s5,344
    800043be:	ffffc097          	auipc	ra,0xffffc
    800043c2:	f4e080e7          	jalr	-178(ra) # 8000030c <safestrcpy>
  oldpagetable = p->pagetable;
    800043c6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043ca:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800043ce:	e0843783          	ld	a5,-504(s0)
    800043d2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043d6:	058ab783          	ld	a5,88(s5)
    800043da:	e6843703          	ld	a4,-408(s0)
    800043de:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043e0:	058ab783          	ld	a5,88(s5)
    800043e4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043e8:	85e6                	mv	a1,s9
    800043ea:	ffffd097          	auipc	ra,0xffffd
    800043ee:	c02080e7          	jalr	-1022(ra) # 80000fec <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043f2:	0004851b          	sext.w	a0,s1
    800043f6:	b399                	j	8000413c <exec+0x98>
    800043f8:	e0943423          	sd	s1,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043fc:	e0843583          	ld	a1,-504(s0)
    80004400:	855a                	mv	a0,s6
    80004402:	ffffd097          	auipc	ra,0xffffd
    80004406:	bea080e7          	jalr	-1046(ra) # 80000fec <proc_freepagetable>
  return -1;
    8000440a:	557d                	li	a0,-1
  if(ip){
    8000440c:	d20a08e3          	beqz	s4,8000413c <exec+0x98>
    80004410:	bb21                	j	80004128 <exec+0x84>
    80004412:	e0943423          	sd	s1,-504(s0)
    80004416:	b7dd                	j	800043fc <exec+0x358>
    80004418:	e0943423          	sd	s1,-504(s0)
    8000441c:	b7c5                	j	800043fc <exec+0x358>
    8000441e:	e0943423          	sd	s1,-504(s0)
    80004422:	bfe9                	j	800043fc <exec+0x358>
  ip = 0;
    80004424:	4a01                	li	s4,0
    80004426:	bfd9                	j	800043fc <exec+0x358>
    80004428:	4a01                	li	s4,0
  if(pagetable)
    8000442a:	bfc9                	j	800043fc <exec+0x358>
  sz = sz1;
    8000442c:	e0843983          	ld	s3,-504(s0)
    80004430:	bd41                	j	800042c0 <exec+0x21c>

0000000080004432 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004432:	7179                	add	sp,sp,-48
    80004434:	f406                	sd	ra,40(sp)
    80004436:	f022                	sd	s0,32(sp)
    80004438:	ec26                	sd	s1,24(sp)
    8000443a:	e84a                	sd	s2,16(sp)
    8000443c:	1800                	add	s0,sp,48
    8000443e:	892e                	mv	s2,a1
    80004440:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004442:	fdc40593          	add	a1,s0,-36
    80004446:	ffffe097          	auipc	ra,0xffffe
    8000444a:	b5c080e7          	jalr	-1188(ra) # 80001fa2 <argint>
    8000444e:	04054063          	bltz	a0,8000448e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004452:	fdc42703          	lw	a4,-36(s0)
    80004456:	47bd                	li	a5,15
    80004458:	02e7ed63          	bltu	a5,a4,80004492 <argfd+0x60>
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	a30080e7          	jalr	-1488(ra) # 80000e8c <myproc>
    80004464:	fdc42703          	lw	a4,-36(s0)
    80004468:	01a70793          	add	a5,a4,26
    8000446c:	078e                	sll	a5,a5,0x3
    8000446e:	953e                	add	a0,a0,a5
    80004470:	611c                	ld	a5,0(a0)
    80004472:	c395                	beqz	a5,80004496 <argfd+0x64>
    return -1;
  if(pfd)
    80004474:	00090463          	beqz	s2,8000447c <argfd+0x4a>
    *pfd = fd;
    80004478:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000447c:	4501                	li	a0,0
  if(pf)
    8000447e:	c091                	beqz	s1,80004482 <argfd+0x50>
    *pf = f;
    80004480:	e09c                	sd	a5,0(s1)
}
    80004482:	70a2                	ld	ra,40(sp)
    80004484:	7402                	ld	s0,32(sp)
    80004486:	64e2                	ld	s1,24(sp)
    80004488:	6942                	ld	s2,16(sp)
    8000448a:	6145                	add	sp,sp,48
    8000448c:	8082                	ret
    return -1;
    8000448e:	557d                	li	a0,-1
    80004490:	bfcd                	j	80004482 <argfd+0x50>
    return -1;
    80004492:	557d                	li	a0,-1
    80004494:	b7fd                	j	80004482 <argfd+0x50>
    80004496:	557d                	li	a0,-1
    80004498:	b7ed                	j	80004482 <argfd+0x50>

000000008000449a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000449a:	1101                	add	sp,sp,-32
    8000449c:	ec06                	sd	ra,24(sp)
    8000449e:	e822                	sd	s0,16(sp)
    800044a0:	e426                	sd	s1,8(sp)
    800044a2:	1000                	add	s0,sp,32
    800044a4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044a6:	ffffd097          	auipc	ra,0xffffd
    800044aa:	9e6080e7          	jalr	-1562(ra) # 80000e8c <myproc>
    800044ae:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044b0:	0d050793          	add	a5,a0,208
    800044b4:	4501                	li	a0,0
    800044b6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044b8:	6398                	ld	a4,0(a5)
    800044ba:	cb19                	beqz	a4,800044d0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044bc:	2505                	addw	a0,a0,1
    800044be:	07a1                	add	a5,a5,8
    800044c0:	fed51ce3          	bne	a0,a3,800044b8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044c4:	557d                	li	a0,-1
}
    800044c6:	60e2                	ld	ra,24(sp)
    800044c8:	6442                	ld	s0,16(sp)
    800044ca:	64a2                	ld	s1,8(sp)
    800044cc:	6105                	add	sp,sp,32
    800044ce:	8082                	ret
      p->ofile[fd] = f;
    800044d0:	01a50793          	add	a5,a0,26
    800044d4:	078e                	sll	a5,a5,0x3
    800044d6:	963e                	add	a2,a2,a5
    800044d8:	e204                	sd	s1,0(a2)
      return fd;
    800044da:	b7f5                	j	800044c6 <fdalloc+0x2c>

00000000800044dc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044dc:	715d                	add	sp,sp,-80
    800044de:	e486                	sd	ra,72(sp)
    800044e0:	e0a2                	sd	s0,64(sp)
    800044e2:	fc26                	sd	s1,56(sp)
    800044e4:	f84a                	sd	s2,48(sp)
    800044e6:	f44e                	sd	s3,40(sp)
    800044e8:	f052                	sd	s4,32(sp)
    800044ea:	ec56                	sd	s5,24(sp)
    800044ec:	0880                	add	s0,sp,80
    800044ee:	8aae                	mv	s5,a1
    800044f0:	8a32                	mv	s4,a2
    800044f2:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044f4:	fb040593          	add	a1,s0,-80
    800044f8:	fffff097          	auipc	ra,0xfffff
    800044fc:	eb6080e7          	jalr	-330(ra) # 800033ae <nameiparent>
    80004500:	892a                	mv	s2,a0
    80004502:	12050c63          	beqz	a0,8000463a <create+0x15e>
    return 0;

  ilock(dp);
    80004506:	ffffe097          	auipc	ra,0xffffe
    8000450a:	6d4080e7          	jalr	1748(ra) # 80002bda <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000450e:	4601                	li	a2,0
    80004510:	fb040593          	add	a1,s0,-80
    80004514:	854a                	mv	a0,s2
    80004516:	fffff097          	auipc	ra,0xfffff
    8000451a:	ba8080e7          	jalr	-1112(ra) # 800030be <dirlookup>
    8000451e:	84aa                	mv	s1,a0
    80004520:	c539                	beqz	a0,8000456e <create+0x92>
    iunlockput(dp);
    80004522:	854a                	mv	a0,s2
    80004524:	fffff097          	auipc	ra,0xfffff
    80004528:	918080e7          	jalr	-1768(ra) # 80002e3c <iunlockput>
    ilock(ip);
    8000452c:	8526                	mv	a0,s1
    8000452e:	ffffe097          	auipc	ra,0xffffe
    80004532:	6ac080e7          	jalr	1708(ra) # 80002bda <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004536:	4789                	li	a5,2
    80004538:	02fa9463          	bne	s5,a5,80004560 <create+0x84>
    8000453c:	0444d783          	lhu	a5,68(s1)
    80004540:	37f9                	addw	a5,a5,-2
    80004542:	17c2                	sll	a5,a5,0x30
    80004544:	93c1                	srl	a5,a5,0x30
    80004546:	4705                	li	a4,1
    80004548:	00f76c63          	bltu	a4,a5,80004560 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000454c:	8526                	mv	a0,s1
    8000454e:	60a6                	ld	ra,72(sp)
    80004550:	6406                	ld	s0,64(sp)
    80004552:	74e2                	ld	s1,56(sp)
    80004554:	7942                	ld	s2,48(sp)
    80004556:	79a2                	ld	s3,40(sp)
    80004558:	7a02                	ld	s4,32(sp)
    8000455a:	6ae2                	ld	s5,24(sp)
    8000455c:	6161                	add	sp,sp,80
    8000455e:	8082                	ret
    iunlockput(ip);
    80004560:	8526                	mv	a0,s1
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	8da080e7          	jalr	-1830(ra) # 80002e3c <iunlockput>
    return 0;
    8000456a:	4481                	li	s1,0
    8000456c:	b7c5                	j	8000454c <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000456e:	85d6                	mv	a1,s5
    80004570:	00092503          	lw	a0,0(s2)
    80004574:	ffffe097          	auipc	ra,0xffffe
    80004578:	4d2080e7          	jalr	1234(ra) # 80002a46 <ialloc>
    8000457c:	84aa                	mv	s1,a0
    8000457e:	c139                	beqz	a0,800045c4 <create+0xe8>
  ilock(ip);
    80004580:	ffffe097          	auipc	ra,0xffffe
    80004584:	65a080e7          	jalr	1626(ra) # 80002bda <ilock>
  ip->major = major;
    80004588:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000458c:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004590:	4985                	li	s3,1
    80004592:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004596:	8526                	mv	a0,s1
    80004598:	ffffe097          	auipc	ra,0xffffe
    8000459c:	576080e7          	jalr	1398(ra) # 80002b0e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045a0:	033a8a63          	beq	s5,s3,800045d4 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800045a4:	40d0                	lw	a2,4(s1)
    800045a6:	fb040593          	add	a1,s0,-80
    800045aa:	854a                	mv	a0,s2
    800045ac:	fffff097          	auipc	ra,0xfffff
    800045b0:	d22080e7          	jalr	-734(ra) # 800032ce <dirlink>
    800045b4:	06054b63          	bltz	a0,8000462a <create+0x14e>
  iunlockput(dp);
    800045b8:	854a                	mv	a0,s2
    800045ba:	fffff097          	auipc	ra,0xfffff
    800045be:	882080e7          	jalr	-1918(ra) # 80002e3c <iunlockput>
  return ip;
    800045c2:	b769                	j	8000454c <create+0x70>
    panic("create: ialloc");
    800045c4:	00004517          	auipc	a0,0x4
    800045c8:	23450513          	add	a0,a0,564 # 800087f8 <syscall_names+0x2a8>
    800045cc:	00001097          	auipc	ra,0x1
    800045d0:	62e080e7          	jalr	1582(ra) # 80005bfa <panic>
    dp->nlink++;  // for ".."
    800045d4:	04a95783          	lhu	a5,74(s2)
    800045d8:	2785                	addw	a5,a5,1
    800045da:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045de:	854a                	mv	a0,s2
    800045e0:	ffffe097          	auipc	ra,0xffffe
    800045e4:	52e080e7          	jalr	1326(ra) # 80002b0e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045e8:	40d0                	lw	a2,4(s1)
    800045ea:	00004597          	auipc	a1,0x4
    800045ee:	21e58593          	add	a1,a1,542 # 80008808 <syscall_names+0x2b8>
    800045f2:	8526                	mv	a0,s1
    800045f4:	fffff097          	auipc	ra,0xfffff
    800045f8:	cda080e7          	jalr	-806(ra) # 800032ce <dirlink>
    800045fc:	00054f63          	bltz	a0,8000461a <create+0x13e>
    80004600:	00492603          	lw	a2,4(s2)
    80004604:	00004597          	auipc	a1,0x4
    80004608:	20c58593          	add	a1,a1,524 # 80008810 <syscall_names+0x2c0>
    8000460c:	8526                	mv	a0,s1
    8000460e:	fffff097          	auipc	ra,0xfffff
    80004612:	cc0080e7          	jalr	-832(ra) # 800032ce <dirlink>
    80004616:	f80557e3          	bgez	a0,800045a4 <create+0xc8>
      panic("create dots");
    8000461a:	00004517          	auipc	a0,0x4
    8000461e:	1fe50513          	add	a0,a0,510 # 80008818 <syscall_names+0x2c8>
    80004622:	00001097          	auipc	ra,0x1
    80004626:	5d8080e7          	jalr	1496(ra) # 80005bfa <panic>
    panic("create: dirlink");
    8000462a:	00004517          	auipc	a0,0x4
    8000462e:	1fe50513          	add	a0,a0,510 # 80008828 <syscall_names+0x2d8>
    80004632:	00001097          	auipc	ra,0x1
    80004636:	5c8080e7          	jalr	1480(ra) # 80005bfa <panic>
    return 0;
    8000463a:	84aa                	mv	s1,a0
    8000463c:	bf01                	j	8000454c <create+0x70>

000000008000463e <sys_dup>:
{
    8000463e:	7179                	add	sp,sp,-48
    80004640:	f406                	sd	ra,40(sp)
    80004642:	f022                	sd	s0,32(sp)
    80004644:	ec26                	sd	s1,24(sp)
    80004646:	e84a                	sd	s2,16(sp)
    80004648:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000464a:	fd840613          	add	a2,s0,-40
    8000464e:	4581                	li	a1,0
    80004650:	4501                	li	a0,0
    80004652:	00000097          	auipc	ra,0x0
    80004656:	de0080e7          	jalr	-544(ra) # 80004432 <argfd>
    return -1;
    8000465a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000465c:	02054363          	bltz	a0,80004682 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004660:	fd843903          	ld	s2,-40(s0)
    80004664:	854a                	mv	a0,s2
    80004666:	00000097          	auipc	ra,0x0
    8000466a:	e34080e7          	jalr	-460(ra) # 8000449a <fdalloc>
    8000466e:	84aa                	mv	s1,a0
    return -1;
    80004670:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004672:	00054863          	bltz	a0,80004682 <sys_dup+0x44>
  filedup(f);
    80004676:	854a                	mv	a0,s2
    80004678:	fffff097          	auipc	ra,0xfffff
    8000467c:	38a080e7          	jalr	906(ra) # 80003a02 <filedup>
  return fd;
    80004680:	87a6                	mv	a5,s1
}
    80004682:	853e                	mv	a0,a5
    80004684:	70a2                	ld	ra,40(sp)
    80004686:	7402                	ld	s0,32(sp)
    80004688:	64e2                	ld	s1,24(sp)
    8000468a:	6942                	ld	s2,16(sp)
    8000468c:	6145                	add	sp,sp,48
    8000468e:	8082                	ret

0000000080004690 <sys_read>:
{
    80004690:	7179                	add	sp,sp,-48
    80004692:	f406                	sd	ra,40(sp)
    80004694:	f022                	sd	s0,32(sp)
    80004696:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004698:	fe840613          	add	a2,s0,-24
    8000469c:	4581                	li	a1,0
    8000469e:	4501                	li	a0,0
    800046a0:	00000097          	auipc	ra,0x0
    800046a4:	d92080e7          	jalr	-622(ra) # 80004432 <argfd>
    return -1;
    800046a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046aa:	04054163          	bltz	a0,800046ec <sys_read+0x5c>
    800046ae:	fe440593          	add	a1,s0,-28
    800046b2:	4509                	li	a0,2
    800046b4:	ffffe097          	auipc	ra,0xffffe
    800046b8:	8ee080e7          	jalr	-1810(ra) # 80001fa2 <argint>
    return -1;
    800046bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046be:	02054763          	bltz	a0,800046ec <sys_read+0x5c>
    800046c2:	fd840593          	add	a1,s0,-40
    800046c6:	4505                	li	a0,1
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	8fc080e7          	jalr	-1796(ra) # 80001fc4 <argaddr>
    return -1;
    800046d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d2:	00054d63          	bltz	a0,800046ec <sys_read+0x5c>
  return fileread(f, p, n);
    800046d6:	fe442603          	lw	a2,-28(s0)
    800046da:	fd843583          	ld	a1,-40(s0)
    800046de:	fe843503          	ld	a0,-24(s0)
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	4ac080e7          	jalr	1196(ra) # 80003b8e <fileread>
    800046ea:	87aa                	mv	a5,a0
}
    800046ec:	853e                	mv	a0,a5
    800046ee:	70a2                	ld	ra,40(sp)
    800046f0:	7402                	ld	s0,32(sp)
    800046f2:	6145                	add	sp,sp,48
    800046f4:	8082                	ret

00000000800046f6 <sys_write>:
{
    800046f6:	7179                	add	sp,sp,-48
    800046f8:	f406                	sd	ra,40(sp)
    800046fa:	f022                	sd	s0,32(sp)
    800046fc:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fe:	fe840613          	add	a2,s0,-24
    80004702:	4581                	li	a1,0
    80004704:	4501                	li	a0,0
    80004706:	00000097          	auipc	ra,0x0
    8000470a:	d2c080e7          	jalr	-724(ra) # 80004432 <argfd>
    return -1;
    8000470e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004710:	04054163          	bltz	a0,80004752 <sys_write+0x5c>
    80004714:	fe440593          	add	a1,s0,-28
    80004718:	4509                	li	a0,2
    8000471a:	ffffe097          	auipc	ra,0xffffe
    8000471e:	888080e7          	jalr	-1912(ra) # 80001fa2 <argint>
    return -1;
    80004722:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004724:	02054763          	bltz	a0,80004752 <sys_write+0x5c>
    80004728:	fd840593          	add	a1,s0,-40
    8000472c:	4505                	li	a0,1
    8000472e:	ffffe097          	auipc	ra,0xffffe
    80004732:	896080e7          	jalr	-1898(ra) # 80001fc4 <argaddr>
    return -1;
    80004736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004738:	00054d63          	bltz	a0,80004752 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000473c:	fe442603          	lw	a2,-28(s0)
    80004740:	fd843583          	ld	a1,-40(s0)
    80004744:	fe843503          	ld	a0,-24(s0)
    80004748:	fffff097          	auipc	ra,0xfffff
    8000474c:	508080e7          	jalr	1288(ra) # 80003c50 <filewrite>
    80004750:	87aa                	mv	a5,a0
}
    80004752:	853e                	mv	a0,a5
    80004754:	70a2                	ld	ra,40(sp)
    80004756:	7402                	ld	s0,32(sp)
    80004758:	6145                	add	sp,sp,48
    8000475a:	8082                	ret

000000008000475c <sys_close>:
{
    8000475c:	1101                	add	sp,sp,-32
    8000475e:	ec06                	sd	ra,24(sp)
    80004760:	e822                	sd	s0,16(sp)
    80004762:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004764:	fe040613          	add	a2,s0,-32
    80004768:	fec40593          	add	a1,s0,-20
    8000476c:	4501                	li	a0,0
    8000476e:	00000097          	auipc	ra,0x0
    80004772:	cc4080e7          	jalr	-828(ra) # 80004432 <argfd>
    return -1;
    80004776:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004778:	02054463          	bltz	a0,800047a0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000477c:	ffffc097          	auipc	ra,0xffffc
    80004780:	710080e7          	jalr	1808(ra) # 80000e8c <myproc>
    80004784:	fec42783          	lw	a5,-20(s0)
    80004788:	07e9                	add	a5,a5,26
    8000478a:	078e                	sll	a5,a5,0x3
    8000478c:	953e                	add	a0,a0,a5
    8000478e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004792:	fe043503          	ld	a0,-32(s0)
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	2be080e7          	jalr	702(ra) # 80003a54 <fileclose>
  return 0;
    8000479e:	4781                	li	a5,0
}
    800047a0:	853e                	mv	a0,a5
    800047a2:	60e2                	ld	ra,24(sp)
    800047a4:	6442                	ld	s0,16(sp)
    800047a6:	6105                	add	sp,sp,32
    800047a8:	8082                	ret

00000000800047aa <sys_fstat>:
{
    800047aa:	1101                	add	sp,sp,-32
    800047ac:	ec06                	sd	ra,24(sp)
    800047ae:	e822                	sd	s0,16(sp)
    800047b0:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047b2:	fe840613          	add	a2,s0,-24
    800047b6:	4581                	li	a1,0
    800047b8:	4501                	li	a0,0
    800047ba:	00000097          	auipc	ra,0x0
    800047be:	c78080e7          	jalr	-904(ra) # 80004432 <argfd>
    return -1;
    800047c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047c4:	02054563          	bltz	a0,800047ee <sys_fstat+0x44>
    800047c8:	fe040593          	add	a1,s0,-32
    800047cc:	4505                	li	a0,1
    800047ce:	ffffd097          	auipc	ra,0xffffd
    800047d2:	7f6080e7          	jalr	2038(ra) # 80001fc4 <argaddr>
    return -1;
    800047d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047d8:	00054b63          	bltz	a0,800047ee <sys_fstat+0x44>
  return filestat(f, st);
    800047dc:	fe043583          	ld	a1,-32(s0)
    800047e0:	fe843503          	ld	a0,-24(s0)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	338080e7          	jalr	824(ra) # 80003b1c <filestat>
    800047ec:	87aa                	mv	a5,a0
}
    800047ee:	853e                	mv	a0,a5
    800047f0:	60e2                	ld	ra,24(sp)
    800047f2:	6442                	ld	s0,16(sp)
    800047f4:	6105                	add	sp,sp,32
    800047f6:	8082                	ret

00000000800047f8 <sys_link>:
{
    800047f8:	7169                	add	sp,sp,-304
    800047fa:	f606                	sd	ra,296(sp)
    800047fc:	f222                	sd	s0,288(sp)
    800047fe:	ee26                	sd	s1,280(sp)
    80004800:	ea4a                	sd	s2,272(sp)
    80004802:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004804:	08000613          	li	a2,128
    80004808:	ed040593          	add	a1,s0,-304
    8000480c:	4501                	li	a0,0
    8000480e:	ffffd097          	auipc	ra,0xffffd
    80004812:	7d8080e7          	jalr	2008(ra) # 80001fe6 <argstr>
    return -1;
    80004816:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004818:	10054e63          	bltz	a0,80004934 <sys_link+0x13c>
    8000481c:	08000613          	li	a2,128
    80004820:	f5040593          	add	a1,s0,-176
    80004824:	4505                	li	a0,1
    80004826:	ffffd097          	auipc	ra,0xffffd
    8000482a:	7c0080e7          	jalr	1984(ra) # 80001fe6 <argstr>
    return -1;
    8000482e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004830:	10054263          	bltz	a0,80004934 <sys_link+0x13c>
  begin_op();
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	d5c080e7          	jalr	-676(ra) # 80003590 <begin_op>
  if((ip = namei(old)) == 0){
    8000483c:	ed040513          	add	a0,s0,-304
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	b50080e7          	jalr	-1200(ra) # 80003390 <namei>
    80004848:	84aa                	mv	s1,a0
    8000484a:	c551                	beqz	a0,800048d6 <sys_link+0xde>
  ilock(ip);
    8000484c:	ffffe097          	auipc	ra,0xffffe
    80004850:	38e080e7          	jalr	910(ra) # 80002bda <ilock>
  if(ip->type == T_DIR){
    80004854:	04449703          	lh	a4,68(s1)
    80004858:	4785                	li	a5,1
    8000485a:	08f70463          	beq	a4,a5,800048e2 <sys_link+0xea>
  ip->nlink++;
    8000485e:	04a4d783          	lhu	a5,74(s1)
    80004862:	2785                	addw	a5,a5,1
    80004864:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004868:	8526                	mv	a0,s1
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	2a4080e7          	jalr	676(ra) # 80002b0e <iupdate>
  iunlock(ip);
    80004872:	8526                	mv	a0,s1
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	428080e7          	jalr	1064(ra) # 80002c9c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000487c:	fd040593          	add	a1,s0,-48
    80004880:	f5040513          	add	a0,s0,-176
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	b2a080e7          	jalr	-1238(ra) # 800033ae <nameiparent>
    8000488c:	892a                	mv	s2,a0
    8000488e:	c935                	beqz	a0,80004902 <sys_link+0x10a>
  ilock(dp);
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	34a080e7          	jalr	842(ra) # 80002bda <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004898:	00092703          	lw	a4,0(s2)
    8000489c:	409c                	lw	a5,0(s1)
    8000489e:	04f71d63          	bne	a4,a5,800048f8 <sys_link+0x100>
    800048a2:	40d0                	lw	a2,4(s1)
    800048a4:	fd040593          	add	a1,s0,-48
    800048a8:	854a                	mv	a0,s2
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	a24080e7          	jalr	-1500(ra) # 800032ce <dirlink>
    800048b2:	04054363          	bltz	a0,800048f8 <sys_link+0x100>
  iunlockput(dp);
    800048b6:	854a                	mv	a0,s2
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	584080e7          	jalr	1412(ra) # 80002e3c <iunlockput>
  iput(ip);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	4d2080e7          	jalr	1234(ra) # 80002d94 <iput>
  end_op();
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	d40080e7          	jalr	-704(ra) # 8000360a <end_op>
  return 0;
    800048d2:	4781                	li	a5,0
    800048d4:	a085                	j	80004934 <sys_link+0x13c>
    end_op();
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	d34080e7          	jalr	-716(ra) # 8000360a <end_op>
    return -1;
    800048de:	57fd                	li	a5,-1
    800048e0:	a891                	j	80004934 <sys_link+0x13c>
    iunlockput(ip);
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	558080e7          	jalr	1368(ra) # 80002e3c <iunlockput>
    end_op();
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	d1e080e7          	jalr	-738(ra) # 8000360a <end_op>
    return -1;
    800048f4:	57fd                	li	a5,-1
    800048f6:	a83d                	j	80004934 <sys_link+0x13c>
    iunlockput(dp);
    800048f8:	854a                	mv	a0,s2
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	542080e7          	jalr	1346(ra) # 80002e3c <iunlockput>
  ilock(ip);
    80004902:	8526                	mv	a0,s1
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	2d6080e7          	jalr	726(ra) # 80002bda <ilock>
  ip->nlink--;
    8000490c:	04a4d783          	lhu	a5,74(s1)
    80004910:	37fd                	addw	a5,a5,-1
    80004912:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004916:	8526                	mv	a0,s1
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	1f6080e7          	jalr	502(ra) # 80002b0e <iupdate>
  iunlockput(ip);
    80004920:	8526                	mv	a0,s1
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	51a080e7          	jalr	1306(ra) # 80002e3c <iunlockput>
  end_op();
    8000492a:	fffff097          	auipc	ra,0xfffff
    8000492e:	ce0080e7          	jalr	-800(ra) # 8000360a <end_op>
  return -1;
    80004932:	57fd                	li	a5,-1
}
    80004934:	853e                	mv	a0,a5
    80004936:	70b2                	ld	ra,296(sp)
    80004938:	7412                	ld	s0,288(sp)
    8000493a:	64f2                	ld	s1,280(sp)
    8000493c:	6952                	ld	s2,272(sp)
    8000493e:	6155                	add	sp,sp,304
    80004940:	8082                	ret

0000000080004942 <sys_unlink>:
{
    80004942:	7151                	add	sp,sp,-240
    80004944:	f586                	sd	ra,232(sp)
    80004946:	f1a2                	sd	s0,224(sp)
    80004948:	eda6                	sd	s1,216(sp)
    8000494a:	e9ca                	sd	s2,208(sp)
    8000494c:	e5ce                	sd	s3,200(sp)
    8000494e:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004950:	08000613          	li	a2,128
    80004954:	f3040593          	add	a1,s0,-208
    80004958:	4501                	li	a0,0
    8000495a:	ffffd097          	auipc	ra,0xffffd
    8000495e:	68c080e7          	jalr	1676(ra) # 80001fe6 <argstr>
    80004962:	18054163          	bltz	a0,80004ae4 <sys_unlink+0x1a2>
  begin_op();
    80004966:	fffff097          	auipc	ra,0xfffff
    8000496a:	c2a080e7          	jalr	-982(ra) # 80003590 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000496e:	fb040593          	add	a1,s0,-80
    80004972:	f3040513          	add	a0,s0,-208
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	a38080e7          	jalr	-1480(ra) # 800033ae <nameiparent>
    8000497e:	84aa                	mv	s1,a0
    80004980:	c979                	beqz	a0,80004a56 <sys_unlink+0x114>
  ilock(dp);
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	258080e7          	jalr	600(ra) # 80002bda <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000498a:	00004597          	auipc	a1,0x4
    8000498e:	e7e58593          	add	a1,a1,-386 # 80008808 <syscall_names+0x2b8>
    80004992:	fb040513          	add	a0,s0,-80
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	70e080e7          	jalr	1806(ra) # 800030a4 <namecmp>
    8000499e:	14050a63          	beqz	a0,80004af2 <sys_unlink+0x1b0>
    800049a2:	00004597          	auipc	a1,0x4
    800049a6:	e6e58593          	add	a1,a1,-402 # 80008810 <syscall_names+0x2c0>
    800049aa:	fb040513          	add	a0,s0,-80
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	6f6080e7          	jalr	1782(ra) # 800030a4 <namecmp>
    800049b6:	12050e63          	beqz	a0,80004af2 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049ba:	f2c40613          	add	a2,s0,-212
    800049be:	fb040593          	add	a1,s0,-80
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	6fa080e7          	jalr	1786(ra) # 800030be <dirlookup>
    800049cc:	892a                	mv	s2,a0
    800049ce:	12050263          	beqz	a0,80004af2 <sys_unlink+0x1b0>
  ilock(ip);
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	208080e7          	jalr	520(ra) # 80002bda <ilock>
  if(ip->nlink < 1)
    800049da:	04a91783          	lh	a5,74(s2)
    800049de:	08f05263          	blez	a5,80004a62 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049e2:	04491703          	lh	a4,68(s2)
    800049e6:	4785                	li	a5,1
    800049e8:	08f70563          	beq	a4,a5,80004a72 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049ec:	4641                	li	a2,16
    800049ee:	4581                	li	a1,0
    800049f0:	fc040513          	add	a0,s0,-64
    800049f4:	ffffb097          	auipc	ra,0xffffb
    800049f8:	7d0080e7          	jalr	2000(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049fc:	4741                	li	a4,16
    800049fe:	f2c42683          	lw	a3,-212(s0)
    80004a02:	fc040613          	add	a2,s0,-64
    80004a06:	4581                	li	a1,0
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	57c080e7          	jalr	1404(ra) # 80002f86 <writei>
    80004a12:	47c1                	li	a5,16
    80004a14:	0af51563          	bne	a0,a5,80004abe <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a18:	04491703          	lh	a4,68(s2)
    80004a1c:	4785                	li	a5,1
    80004a1e:	0af70863          	beq	a4,a5,80004ace <sys_unlink+0x18c>
  iunlockput(dp);
    80004a22:	8526                	mv	a0,s1
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	418080e7          	jalr	1048(ra) # 80002e3c <iunlockput>
  ip->nlink--;
    80004a2c:	04a95783          	lhu	a5,74(s2)
    80004a30:	37fd                	addw	a5,a5,-1
    80004a32:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a36:	854a                	mv	a0,s2
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	0d6080e7          	jalr	214(ra) # 80002b0e <iupdate>
  iunlockput(ip);
    80004a40:	854a                	mv	a0,s2
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	3fa080e7          	jalr	1018(ra) # 80002e3c <iunlockput>
  end_op();
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	bc0080e7          	jalr	-1088(ra) # 8000360a <end_op>
  return 0;
    80004a52:	4501                	li	a0,0
    80004a54:	a84d                	j	80004b06 <sys_unlink+0x1c4>
    end_op();
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	bb4080e7          	jalr	-1100(ra) # 8000360a <end_op>
    return -1;
    80004a5e:	557d                	li	a0,-1
    80004a60:	a05d                	j	80004b06 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a62:	00004517          	auipc	a0,0x4
    80004a66:	dd650513          	add	a0,a0,-554 # 80008838 <syscall_names+0x2e8>
    80004a6a:	00001097          	auipc	ra,0x1
    80004a6e:	190080e7          	jalr	400(ra) # 80005bfa <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a72:	04c92703          	lw	a4,76(s2)
    80004a76:	02000793          	li	a5,32
    80004a7a:	f6e7f9e3          	bgeu	a5,a4,800049ec <sys_unlink+0xaa>
    80004a7e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a82:	4741                	li	a4,16
    80004a84:	86ce                	mv	a3,s3
    80004a86:	f1840613          	add	a2,s0,-232
    80004a8a:	4581                	li	a1,0
    80004a8c:	854a                	mv	a0,s2
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	400080e7          	jalr	1024(ra) # 80002e8e <readi>
    80004a96:	47c1                	li	a5,16
    80004a98:	00f51b63          	bne	a0,a5,80004aae <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a9c:	f1845783          	lhu	a5,-232(s0)
    80004aa0:	e7a1                	bnez	a5,80004ae8 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aa2:	29c1                	addw	s3,s3,16
    80004aa4:	04c92783          	lw	a5,76(s2)
    80004aa8:	fcf9ede3          	bltu	s3,a5,80004a82 <sys_unlink+0x140>
    80004aac:	b781                	j	800049ec <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004aae:	00004517          	auipc	a0,0x4
    80004ab2:	da250513          	add	a0,a0,-606 # 80008850 <syscall_names+0x300>
    80004ab6:	00001097          	auipc	ra,0x1
    80004aba:	144080e7          	jalr	324(ra) # 80005bfa <panic>
    panic("unlink: writei");
    80004abe:	00004517          	auipc	a0,0x4
    80004ac2:	daa50513          	add	a0,a0,-598 # 80008868 <syscall_names+0x318>
    80004ac6:	00001097          	auipc	ra,0x1
    80004aca:	134080e7          	jalr	308(ra) # 80005bfa <panic>
    dp->nlink--;
    80004ace:	04a4d783          	lhu	a5,74(s1)
    80004ad2:	37fd                	addw	a5,a5,-1
    80004ad4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ad8:	8526                	mv	a0,s1
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	034080e7          	jalr	52(ra) # 80002b0e <iupdate>
    80004ae2:	b781                	j	80004a22 <sys_unlink+0xe0>
    return -1;
    80004ae4:	557d                	li	a0,-1
    80004ae6:	a005                	j	80004b06 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ae8:	854a                	mv	a0,s2
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	352080e7          	jalr	850(ra) # 80002e3c <iunlockput>
  iunlockput(dp);
    80004af2:	8526                	mv	a0,s1
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	348080e7          	jalr	840(ra) # 80002e3c <iunlockput>
  end_op();
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	b0e080e7          	jalr	-1266(ra) # 8000360a <end_op>
  return -1;
    80004b04:	557d                	li	a0,-1
}
    80004b06:	70ae                	ld	ra,232(sp)
    80004b08:	740e                	ld	s0,224(sp)
    80004b0a:	64ee                	ld	s1,216(sp)
    80004b0c:	694e                	ld	s2,208(sp)
    80004b0e:	69ae                	ld	s3,200(sp)
    80004b10:	616d                	add	sp,sp,240
    80004b12:	8082                	ret

0000000080004b14 <sys_open>:

uint64
sys_open(void)
{
    80004b14:	7131                	add	sp,sp,-192
    80004b16:	fd06                	sd	ra,184(sp)
    80004b18:	f922                	sd	s0,176(sp)
    80004b1a:	f526                	sd	s1,168(sp)
    80004b1c:	f14a                	sd	s2,160(sp)
    80004b1e:	ed4e                	sd	s3,152(sp)
    80004b20:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b22:	08000613          	li	a2,128
    80004b26:	f5040593          	add	a1,s0,-176
    80004b2a:	4501                	li	a0,0
    80004b2c:	ffffd097          	auipc	ra,0xffffd
    80004b30:	4ba080e7          	jalr	1210(ra) # 80001fe6 <argstr>
    return -1;
    80004b34:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b36:	0c054063          	bltz	a0,80004bf6 <sys_open+0xe2>
    80004b3a:	f4c40593          	add	a1,s0,-180
    80004b3e:	4505                	li	a0,1
    80004b40:	ffffd097          	auipc	ra,0xffffd
    80004b44:	462080e7          	jalr	1122(ra) # 80001fa2 <argint>
    80004b48:	0a054763          	bltz	a0,80004bf6 <sys_open+0xe2>

  begin_op();
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	a44080e7          	jalr	-1468(ra) # 80003590 <begin_op>

  if(omode & O_CREATE){
    80004b54:	f4c42783          	lw	a5,-180(s0)
    80004b58:	2007f793          	and	a5,a5,512
    80004b5c:	cbd5                	beqz	a5,80004c10 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004b5e:	4681                	li	a3,0
    80004b60:	4601                	li	a2,0
    80004b62:	4589                	li	a1,2
    80004b64:	f5040513          	add	a0,s0,-176
    80004b68:	00000097          	auipc	ra,0x0
    80004b6c:	974080e7          	jalr	-1676(ra) # 800044dc <create>
    80004b70:	892a                	mv	s2,a0
    if(ip == 0){
    80004b72:	c951                	beqz	a0,80004c06 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b74:	04491703          	lh	a4,68(s2)
    80004b78:	478d                	li	a5,3
    80004b7a:	00f71763          	bne	a4,a5,80004b88 <sys_open+0x74>
    80004b7e:	04695703          	lhu	a4,70(s2)
    80004b82:	47a5                	li	a5,9
    80004b84:	0ce7eb63          	bltu	a5,a4,80004c5a <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	e10080e7          	jalr	-496(ra) # 80003998 <filealloc>
    80004b90:	89aa                	mv	s3,a0
    80004b92:	c565                	beqz	a0,80004c7a <sys_open+0x166>
    80004b94:	00000097          	auipc	ra,0x0
    80004b98:	906080e7          	jalr	-1786(ra) # 8000449a <fdalloc>
    80004b9c:	84aa                	mv	s1,a0
    80004b9e:	0c054963          	bltz	a0,80004c70 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ba2:	04491703          	lh	a4,68(s2)
    80004ba6:	478d                	li	a5,3
    80004ba8:	0ef70463          	beq	a4,a5,80004c90 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bac:	4789                	li	a5,2
    80004bae:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bb2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bb6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bba:	f4c42783          	lw	a5,-180(s0)
    80004bbe:	0017c713          	xor	a4,a5,1
    80004bc2:	8b05                	and	a4,a4,1
    80004bc4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bc8:	0037f713          	and	a4,a5,3
    80004bcc:	00e03733          	snez	a4,a4
    80004bd0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bd4:	4007f793          	and	a5,a5,1024
    80004bd8:	c791                	beqz	a5,80004be4 <sys_open+0xd0>
    80004bda:	04491703          	lh	a4,68(s2)
    80004bde:	4789                	li	a5,2
    80004be0:	0af70f63          	beq	a4,a5,80004c9e <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004be4:	854a                	mv	a0,s2
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	0b6080e7          	jalr	182(ra) # 80002c9c <iunlock>
  end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	a1c080e7          	jalr	-1508(ra) # 8000360a <end_op>

  return fd;
}
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	70ea                	ld	ra,184(sp)
    80004bfa:	744a                	ld	s0,176(sp)
    80004bfc:	74aa                	ld	s1,168(sp)
    80004bfe:	790a                	ld	s2,160(sp)
    80004c00:	69ea                	ld	s3,152(sp)
    80004c02:	6129                	add	sp,sp,192
    80004c04:	8082                	ret
      end_op();
    80004c06:	fffff097          	auipc	ra,0xfffff
    80004c0a:	a04080e7          	jalr	-1532(ra) # 8000360a <end_op>
      return -1;
    80004c0e:	b7e5                	j	80004bf6 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004c10:	f5040513          	add	a0,s0,-176
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	77c080e7          	jalr	1916(ra) # 80003390 <namei>
    80004c1c:	892a                	mv	s2,a0
    80004c1e:	c905                	beqz	a0,80004c4e <sys_open+0x13a>
    ilock(ip);
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	fba080e7          	jalr	-70(ra) # 80002bda <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c28:	04491703          	lh	a4,68(s2)
    80004c2c:	4785                	li	a5,1
    80004c2e:	f4f713e3          	bne	a4,a5,80004b74 <sys_open+0x60>
    80004c32:	f4c42783          	lw	a5,-180(s0)
    80004c36:	dba9                	beqz	a5,80004b88 <sys_open+0x74>
      iunlockput(ip);
    80004c38:	854a                	mv	a0,s2
    80004c3a:	ffffe097          	auipc	ra,0xffffe
    80004c3e:	202080e7          	jalr	514(ra) # 80002e3c <iunlockput>
      end_op();
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	9c8080e7          	jalr	-1592(ra) # 8000360a <end_op>
      return -1;
    80004c4a:	54fd                	li	s1,-1
    80004c4c:	b76d                	j	80004bf6 <sys_open+0xe2>
      end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	9bc080e7          	jalr	-1604(ra) # 8000360a <end_op>
      return -1;
    80004c56:	54fd                	li	s1,-1
    80004c58:	bf79                	j	80004bf6 <sys_open+0xe2>
    iunlockput(ip);
    80004c5a:	854a                	mv	a0,s2
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	1e0080e7          	jalr	480(ra) # 80002e3c <iunlockput>
    end_op();
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	9a6080e7          	jalr	-1626(ra) # 8000360a <end_op>
    return -1;
    80004c6c:	54fd                	li	s1,-1
    80004c6e:	b761                	j	80004bf6 <sys_open+0xe2>
      fileclose(f);
    80004c70:	854e                	mv	a0,s3
    80004c72:	fffff097          	auipc	ra,0xfffff
    80004c76:	de2080e7          	jalr	-542(ra) # 80003a54 <fileclose>
    iunlockput(ip);
    80004c7a:	854a                	mv	a0,s2
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	1c0080e7          	jalr	448(ra) # 80002e3c <iunlockput>
    end_op();
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	986080e7          	jalr	-1658(ra) # 8000360a <end_op>
    return -1;
    80004c8c:	54fd                	li	s1,-1
    80004c8e:	b7a5                	j	80004bf6 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004c90:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c94:	04691783          	lh	a5,70(s2)
    80004c98:	02f99223          	sh	a5,36(s3)
    80004c9c:	bf29                	j	80004bb6 <sys_open+0xa2>
    itrunc(ip);
    80004c9e:	854a                	mv	a0,s2
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	048080e7          	jalr	72(ra) # 80002ce8 <itrunc>
    80004ca8:	bf35                	j	80004be4 <sys_open+0xd0>

0000000080004caa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004caa:	7175                	add	sp,sp,-144
    80004cac:	e506                	sd	ra,136(sp)
    80004cae:	e122                	sd	s0,128(sp)
    80004cb0:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	8de080e7          	jalr	-1826(ra) # 80003590 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cba:	08000613          	li	a2,128
    80004cbe:	f7040593          	add	a1,s0,-144
    80004cc2:	4501                	li	a0,0
    80004cc4:	ffffd097          	auipc	ra,0xffffd
    80004cc8:	322080e7          	jalr	802(ra) # 80001fe6 <argstr>
    80004ccc:	02054963          	bltz	a0,80004cfe <sys_mkdir+0x54>
    80004cd0:	4681                	li	a3,0
    80004cd2:	4601                	li	a2,0
    80004cd4:	4585                	li	a1,1
    80004cd6:	f7040513          	add	a0,s0,-144
    80004cda:	00000097          	auipc	ra,0x0
    80004cde:	802080e7          	jalr	-2046(ra) # 800044dc <create>
    80004ce2:	cd11                	beqz	a0,80004cfe <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	158080e7          	jalr	344(ra) # 80002e3c <iunlockput>
  end_op();
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	91e080e7          	jalr	-1762(ra) # 8000360a <end_op>
  return 0;
    80004cf4:	4501                	li	a0,0
}
    80004cf6:	60aa                	ld	ra,136(sp)
    80004cf8:	640a                	ld	s0,128(sp)
    80004cfa:	6149                	add	sp,sp,144
    80004cfc:	8082                	ret
    end_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	90c080e7          	jalr	-1780(ra) # 8000360a <end_op>
    return -1;
    80004d06:	557d                	li	a0,-1
    80004d08:	b7fd                	j	80004cf6 <sys_mkdir+0x4c>

0000000080004d0a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d0a:	7135                	add	sp,sp,-160
    80004d0c:	ed06                	sd	ra,152(sp)
    80004d0e:	e922                	sd	s0,144(sp)
    80004d10:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d12:	fffff097          	auipc	ra,0xfffff
    80004d16:	87e080e7          	jalr	-1922(ra) # 80003590 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d1a:	08000613          	li	a2,128
    80004d1e:	f7040593          	add	a1,s0,-144
    80004d22:	4501                	li	a0,0
    80004d24:	ffffd097          	auipc	ra,0xffffd
    80004d28:	2c2080e7          	jalr	706(ra) # 80001fe6 <argstr>
    80004d2c:	04054a63          	bltz	a0,80004d80 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d30:	f6c40593          	add	a1,s0,-148
    80004d34:	4505                	li	a0,1
    80004d36:	ffffd097          	auipc	ra,0xffffd
    80004d3a:	26c080e7          	jalr	620(ra) # 80001fa2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d3e:	04054163          	bltz	a0,80004d80 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d42:	f6840593          	add	a1,s0,-152
    80004d46:	4509                	li	a0,2
    80004d48:	ffffd097          	auipc	ra,0xffffd
    80004d4c:	25a080e7          	jalr	602(ra) # 80001fa2 <argint>
     argint(1, &major) < 0 ||
    80004d50:	02054863          	bltz	a0,80004d80 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d54:	f6841683          	lh	a3,-152(s0)
    80004d58:	f6c41603          	lh	a2,-148(s0)
    80004d5c:	458d                	li	a1,3
    80004d5e:	f7040513          	add	a0,s0,-144
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	77a080e7          	jalr	1914(ra) # 800044dc <create>
     argint(2, &minor) < 0 ||
    80004d6a:	c919                	beqz	a0,80004d80 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	0d0080e7          	jalr	208(ra) # 80002e3c <iunlockput>
  end_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	896080e7          	jalr	-1898(ra) # 8000360a <end_op>
  return 0;
    80004d7c:	4501                	li	a0,0
    80004d7e:	a031                	j	80004d8a <sys_mknod+0x80>
    end_op();
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	88a080e7          	jalr	-1910(ra) # 8000360a <end_op>
    return -1;
    80004d88:	557d                	li	a0,-1
}
    80004d8a:	60ea                	ld	ra,152(sp)
    80004d8c:	644a                	ld	s0,144(sp)
    80004d8e:	610d                	add	sp,sp,160
    80004d90:	8082                	ret

0000000080004d92 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d92:	7135                	add	sp,sp,-160
    80004d94:	ed06                	sd	ra,152(sp)
    80004d96:	e922                	sd	s0,144(sp)
    80004d98:	e526                	sd	s1,136(sp)
    80004d9a:	e14a                	sd	s2,128(sp)
    80004d9c:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d9e:	ffffc097          	auipc	ra,0xffffc
    80004da2:	0ee080e7          	jalr	238(ra) # 80000e8c <myproc>
    80004da6:	892a                	mv	s2,a0
  
  begin_op();
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	7e8080e7          	jalr	2024(ra) # 80003590 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004db0:	08000613          	li	a2,128
    80004db4:	f6040593          	add	a1,s0,-160
    80004db8:	4501                	li	a0,0
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	22c080e7          	jalr	556(ra) # 80001fe6 <argstr>
    80004dc2:	04054b63          	bltz	a0,80004e18 <sys_chdir+0x86>
    80004dc6:	f6040513          	add	a0,s0,-160
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	5c6080e7          	jalr	1478(ra) # 80003390 <namei>
    80004dd2:	84aa                	mv	s1,a0
    80004dd4:	c131                	beqz	a0,80004e18 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	e04080e7          	jalr	-508(ra) # 80002bda <ilock>
  if(ip->type != T_DIR){
    80004dde:	04449703          	lh	a4,68(s1)
    80004de2:	4785                	li	a5,1
    80004de4:	04f71063          	bne	a4,a5,80004e24 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004de8:	8526                	mv	a0,s1
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	eb2080e7          	jalr	-334(ra) # 80002c9c <iunlock>
  iput(p->cwd);
    80004df2:	15093503          	ld	a0,336(s2)
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	f9e080e7          	jalr	-98(ra) # 80002d94 <iput>
  end_op();
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	80c080e7          	jalr	-2036(ra) # 8000360a <end_op>
  p->cwd = ip;
    80004e06:	14993823          	sd	s1,336(s2)
  return 0;
    80004e0a:	4501                	li	a0,0
}
    80004e0c:	60ea                	ld	ra,152(sp)
    80004e0e:	644a                	ld	s0,144(sp)
    80004e10:	64aa                	ld	s1,136(sp)
    80004e12:	690a                	ld	s2,128(sp)
    80004e14:	610d                	add	sp,sp,160
    80004e16:	8082                	ret
    end_op();
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	7f2080e7          	jalr	2034(ra) # 8000360a <end_op>
    return -1;
    80004e20:	557d                	li	a0,-1
    80004e22:	b7ed                	j	80004e0c <sys_chdir+0x7a>
    iunlockput(ip);
    80004e24:	8526                	mv	a0,s1
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	016080e7          	jalr	22(ra) # 80002e3c <iunlockput>
    end_op();
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	7dc080e7          	jalr	2012(ra) # 8000360a <end_op>
    return -1;
    80004e36:	557d                	li	a0,-1
    80004e38:	bfd1                	j	80004e0c <sys_chdir+0x7a>

0000000080004e3a <sys_exec>:

uint64
sys_exec(void)
{
    80004e3a:	7121                	add	sp,sp,-448
    80004e3c:	ff06                	sd	ra,440(sp)
    80004e3e:	fb22                	sd	s0,432(sp)
    80004e40:	f726                	sd	s1,424(sp)
    80004e42:	f34a                	sd	s2,416(sp)
    80004e44:	ef4e                	sd	s3,408(sp)
    80004e46:	eb52                	sd	s4,400(sp)
    80004e48:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e4a:	08000613          	li	a2,128
    80004e4e:	f5040593          	add	a1,s0,-176
    80004e52:	4501                	li	a0,0
    80004e54:	ffffd097          	auipc	ra,0xffffd
    80004e58:	192080e7          	jalr	402(ra) # 80001fe6 <argstr>
    return -1;
    80004e5c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e5e:	0c054a63          	bltz	a0,80004f32 <sys_exec+0xf8>
    80004e62:	e4840593          	add	a1,s0,-440
    80004e66:	4505                	li	a0,1
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	15c080e7          	jalr	348(ra) # 80001fc4 <argaddr>
    80004e70:	0c054163          	bltz	a0,80004f32 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004e74:	10000613          	li	a2,256
    80004e78:	4581                	li	a1,0
    80004e7a:	e5040513          	add	a0,s0,-432
    80004e7e:	ffffb097          	auipc	ra,0xffffb
    80004e82:	346080e7          	jalr	838(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e86:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e8a:	89a6                	mv	s3,s1
    80004e8c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e8e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e92:	00391513          	sll	a0,s2,0x3
    80004e96:	e4040593          	add	a1,s0,-448
    80004e9a:	e4843783          	ld	a5,-440(s0)
    80004e9e:	953e                	add	a0,a0,a5
    80004ea0:	ffffd097          	auipc	ra,0xffffd
    80004ea4:	068080e7          	jalr	104(ra) # 80001f08 <fetchaddr>
    80004ea8:	02054a63          	bltz	a0,80004edc <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004eac:	e4043783          	ld	a5,-448(s0)
    80004eb0:	c3b9                	beqz	a5,80004ef6 <sys_exec+0xbc>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eb2:	ffffb097          	auipc	ra,0xffffb
    80004eb6:	268080e7          	jalr	616(ra) # 8000011a <kalloc>
    80004eba:	85aa                	mv	a1,a0
    80004ebc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ec0:	cd11                	beqz	a0,80004edc <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ec2:	6605                	lui	a2,0x1
    80004ec4:	e4043503          	ld	a0,-448(s0)
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	092080e7          	jalr	146(ra) # 80001f5a <fetchstr>
    80004ed0:	00054663          	bltz	a0,80004edc <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004ed4:	0905                	add	s2,s2,1
    80004ed6:	09a1                	add	s3,s3,8
    80004ed8:	fb491de3          	bne	s2,s4,80004e92 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004edc:	f5040913          	add	s2,s0,-176
    80004ee0:	6088                	ld	a0,0(s1)
    80004ee2:	c539                	beqz	a0,80004f30 <sys_exec+0xf6>
    kfree(argv[i]);
    80004ee4:	ffffb097          	auipc	ra,0xffffb
    80004ee8:	138080e7          	jalr	312(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eec:	04a1                	add	s1,s1,8
    80004eee:	ff2499e3          	bne	s1,s2,80004ee0 <sys_exec+0xa6>
  return -1;
    80004ef2:	597d                	li	s2,-1
    80004ef4:	a83d                	j	80004f32 <sys_exec+0xf8>
      argv[i] = 0;
    80004ef6:	0009079b          	sext.w	a5,s2
    80004efa:	078e                	sll	a5,a5,0x3
    80004efc:	fd078793          	add	a5,a5,-48
    80004f00:	97a2                	add	a5,a5,s0
    80004f02:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f06:	e5040593          	add	a1,s0,-432
    80004f0a:	f5040513          	add	a0,s0,-176
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	196080e7          	jalr	406(ra) # 800040a4 <exec>
    80004f16:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f18:	f5040993          	add	s3,s0,-176
    80004f1c:	6088                	ld	a0,0(s1)
    80004f1e:	c911                	beqz	a0,80004f32 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f20:	ffffb097          	auipc	ra,0xffffb
    80004f24:	0fc080e7          	jalr	252(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f28:	04a1                	add	s1,s1,8
    80004f2a:	ff3499e3          	bne	s1,s3,80004f1c <sys_exec+0xe2>
    80004f2e:	a011                	j	80004f32 <sys_exec+0xf8>
  return -1;
    80004f30:	597d                	li	s2,-1
}
    80004f32:	854a                	mv	a0,s2
    80004f34:	70fa                	ld	ra,440(sp)
    80004f36:	745a                	ld	s0,432(sp)
    80004f38:	74ba                	ld	s1,424(sp)
    80004f3a:	791a                	ld	s2,416(sp)
    80004f3c:	69fa                	ld	s3,408(sp)
    80004f3e:	6a5a                	ld	s4,400(sp)
    80004f40:	6139                	add	sp,sp,448
    80004f42:	8082                	ret

0000000080004f44 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f44:	7139                	add	sp,sp,-64
    80004f46:	fc06                	sd	ra,56(sp)
    80004f48:	f822                	sd	s0,48(sp)
    80004f4a:	f426                	sd	s1,40(sp)
    80004f4c:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f4e:	ffffc097          	auipc	ra,0xffffc
    80004f52:	f3e080e7          	jalr	-194(ra) # 80000e8c <myproc>
    80004f56:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f58:	fd840593          	add	a1,s0,-40
    80004f5c:	4501                	li	a0,0
    80004f5e:	ffffd097          	auipc	ra,0xffffd
    80004f62:	066080e7          	jalr	102(ra) # 80001fc4 <argaddr>
    return -1;
    80004f66:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f68:	0e054063          	bltz	a0,80005048 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f6c:	fc840593          	add	a1,s0,-56
    80004f70:	fd040513          	add	a0,s0,-48
    80004f74:	fffff097          	auipc	ra,0xfffff
    80004f78:	e0c080e7          	jalr	-500(ra) # 80003d80 <pipealloc>
    return -1;
    80004f7c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f7e:	0c054563          	bltz	a0,80005048 <sys_pipe+0x104>
  fd0 = -1;
    80004f82:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f86:	fd043503          	ld	a0,-48(s0)
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	510080e7          	jalr	1296(ra) # 8000449a <fdalloc>
    80004f92:	fca42223          	sw	a0,-60(s0)
    80004f96:	08054c63          	bltz	a0,8000502e <sys_pipe+0xea>
    80004f9a:	fc843503          	ld	a0,-56(s0)
    80004f9e:	fffff097          	auipc	ra,0xfffff
    80004fa2:	4fc080e7          	jalr	1276(ra) # 8000449a <fdalloc>
    80004fa6:	fca42023          	sw	a0,-64(s0)
    80004faa:	06054963          	bltz	a0,8000501c <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fae:	4691                	li	a3,4
    80004fb0:	fc440613          	add	a2,s0,-60
    80004fb4:	fd843583          	ld	a1,-40(s0)
    80004fb8:	68a8                	ld	a0,80(s1)
    80004fba:	ffffc097          	auipc	ra,0xffffc
    80004fbe:	b96080e7          	jalr	-1130(ra) # 80000b50 <copyout>
    80004fc2:	02054063          	bltz	a0,80004fe2 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fc6:	4691                	li	a3,4
    80004fc8:	fc040613          	add	a2,s0,-64
    80004fcc:	fd843583          	ld	a1,-40(s0)
    80004fd0:	0591                	add	a1,a1,4
    80004fd2:	68a8                	ld	a0,80(s1)
    80004fd4:	ffffc097          	auipc	ra,0xffffc
    80004fd8:	b7c080e7          	jalr	-1156(ra) # 80000b50 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fdc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fde:	06055563          	bgez	a0,80005048 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fe2:	fc442783          	lw	a5,-60(s0)
    80004fe6:	07e9                	add	a5,a5,26
    80004fe8:	078e                	sll	a5,a5,0x3
    80004fea:	97a6                	add	a5,a5,s1
    80004fec:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ff0:	fc042783          	lw	a5,-64(s0)
    80004ff4:	07e9                	add	a5,a5,26
    80004ff6:	078e                	sll	a5,a5,0x3
    80004ff8:	00f48533          	add	a0,s1,a5
    80004ffc:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005000:	fd043503          	ld	a0,-48(s0)
    80005004:	fffff097          	auipc	ra,0xfffff
    80005008:	a50080e7          	jalr	-1456(ra) # 80003a54 <fileclose>
    fileclose(wf);
    8000500c:	fc843503          	ld	a0,-56(s0)
    80005010:	fffff097          	auipc	ra,0xfffff
    80005014:	a44080e7          	jalr	-1468(ra) # 80003a54 <fileclose>
    return -1;
    80005018:	57fd                	li	a5,-1
    8000501a:	a03d                	j	80005048 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000501c:	fc442783          	lw	a5,-60(s0)
    80005020:	0007c763          	bltz	a5,8000502e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005024:	07e9                	add	a5,a5,26
    80005026:	078e                	sll	a5,a5,0x3
    80005028:	97a6                	add	a5,a5,s1
    8000502a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000502e:	fd043503          	ld	a0,-48(s0)
    80005032:	fffff097          	auipc	ra,0xfffff
    80005036:	a22080e7          	jalr	-1502(ra) # 80003a54 <fileclose>
    fileclose(wf);
    8000503a:	fc843503          	ld	a0,-56(s0)
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	a16080e7          	jalr	-1514(ra) # 80003a54 <fileclose>
    return -1;
    80005046:	57fd                	li	a5,-1
}
    80005048:	853e                	mv	a0,a5
    8000504a:	70e2                	ld	ra,56(sp)
    8000504c:	7442                	ld	s0,48(sp)
    8000504e:	74a2                	ld	s1,40(sp)
    80005050:	6121                	add	sp,sp,64
    80005052:	8082                	ret
	...

0000000080005060 <kernelvec>:
    80005060:	7111                	add	sp,sp,-256
    80005062:	e006                	sd	ra,0(sp)
    80005064:	e40a                	sd	sp,8(sp)
    80005066:	e80e                	sd	gp,16(sp)
    80005068:	ec12                	sd	tp,24(sp)
    8000506a:	f016                	sd	t0,32(sp)
    8000506c:	f41a                	sd	t1,40(sp)
    8000506e:	f81e                	sd	t2,48(sp)
    80005070:	fc22                	sd	s0,56(sp)
    80005072:	e0a6                	sd	s1,64(sp)
    80005074:	e4aa                	sd	a0,72(sp)
    80005076:	e8ae                	sd	a1,80(sp)
    80005078:	ecb2                	sd	a2,88(sp)
    8000507a:	f0b6                	sd	a3,96(sp)
    8000507c:	f4ba                	sd	a4,104(sp)
    8000507e:	f8be                	sd	a5,112(sp)
    80005080:	fcc2                	sd	a6,120(sp)
    80005082:	e146                	sd	a7,128(sp)
    80005084:	e54a                	sd	s2,136(sp)
    80005086:	e94e                	sd	s3,144(sp)
    80005088:	ed52                	sd	s4,152(sp)
    8000508a:	f156                	sd	s5,160(sp)
    8000508c:	f55a                	sd	s6,168(sp)
    8000508e:	f95e                	sd	s7,176(sp)
    80005090:	fd62                	sd	s8,184(sp)
    80005092:	e1e6                	sd	s9,192(sp)
    80005094:	e5ea                	sd	s10,200(sp)
    80005096:	e9ee                	sd	s11,208(sp)
    80005098:	edf2                	sd	t3,216(sp)
    8000509a:	f1f6                	sd	t4,224(sp)
    8000509c:	f5fa                	sd	t5,232(sp)
    8000509e:	f9fe                	sd	t6,240(sp)
    800050a0:	d35fc0ef          	jal	80001dd4 <kerneltrap>
    800050a4:	6082                	ld	ra,0(sp)
    800050a6:	6122                	ld	sp,8(sp)
    800050a8:	61c2                	ld	gp,16(sp)
    800050aa:	7282                	ld	t0,32(sp)
    800050ac:	7322                	ld	t1,40(sp)
    800050ae:	73c2                	ld	t2,48(sp)
    800050b0:	7462                	ld	s0,56(sp)
    800050b2:	6486                	ld	s1,64(sp)
    800050b4:	6526                	ld	a0,72(sp)
    800050b6:	65c6                	ld	a1,80(sp)
    800050b8:	6666                	ld	a2,88(sp)
    800050ba:	7686                	ld	a3,96(sp)
    800050bc:	7726                	ld	a4,104(sp)
    800050be:	77c6                	ld	a5,112(sp)
    800050c0:	7866                	ld	a6,120(sp)
    800050c2:	688a                	ld	a7,128(sp)
    800050c4:	692a                	ld	s2,136(sp)
    800050c6:	69ca                	ld	s3,144(sp)
    800050c8:	6a6a                	ld	s4,152(sp)
    800050ca:	7a8a                	ld	s5,160(sp)
    800050cc:	7b2a                	ld	s6,168(sp)
    800050ce:	7bca                	ld	s7,176(sp)
    800050d0:	7c6a                	ld	s8,184(sp)
    800050d2:	6c8e                	ld	s9,192(sp)
    800050d4:	6d2e                	ld	s10,200(sp)
    800050d6:	6dce                	ld	s11,208(sp)
    800050d8:	6e6e                	ld	t3,216(sp)
    800050da:	7e8e                	ld	t4,224(sp)
    800050dc:	7f2e                	ld	t5,232(sp)
    800050de:	7fce                	ld	t6,240(sp)
    800050e0:	6111                	add	sp,sp,256
    800050e2:	10200073          	sret
    800050e6:	00000013          	nop
    800050ea:	00000013          	nop
    800050ee:	0001                	nop

00000000800050f0 <timervec>:
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	e10c                	sd	a1,0(a0)
    800050f6:	e510                	sd	a2,8(a0)
    800050f8:	e914                	sd	a3,16(a0)
    800050fa:	6d0c                	ld	a1,24(a0)
    800050fc:	7110                	ld	a2,32(a0)
    800050fe:	6194                	ld	a3,0(a1)
    80005100:	96b2                	add	a3,a3,a2
    80005102:	e194                	sd	a3,0(a1)
    80005104:	4589                	li	a1,2
    80005106:	14459073          	csrw	sip,a1
    8000510a:	6914                	ld	a3,16(a0)
    8000510c:	6510                	ld	a2,8(a0)
    8000510e:	610c                	ld	a1,0(a0)
    80005110:	34051573          	csrrw	a0,mscratch,a0
    80005114:	30200073          	mret
	...

000000008000511a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000511a:	1141                	add	sp,sp,-16
    8000511c:	e422                	sd	s0,8(sp)
    8000511e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005120:	0c0007b7          	lui	a5,0xc000
    80005124:	4705                	li	a4,1
    80005126:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005128:	c3d8                	sw	a4,4(a5)
}
    8000512a:	6422                	ld	s0,8(sp)
    8000512c:	0141                	add	sp,sp,16
    8000512e:	8082                	ret

0000000080005130 <plicinithart>:

void
plicinithart(void)
{
    80005130:	1141                	add	sp,sp,-16
    80005132:	e406                	sd	ra,8(sp)
    80005134:	e022                	sd	s0,0(sp)
    80005136:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	d28080e7          	jalr	-728(ra) # 80000e60 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005140:	0085171b          	sllw	a4,a0,0x8
    80005144:	0c0027b7          	lui	a5,0xc002
    80005148:	97ba                	add	a5,a5,a4
    8000514a:	40200713          	li	a4,1026
    8000514e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005152:	00d5151b          	sllw	a0,a0,0xd
    80005156:	0c2017b7          	lui	a5,0xc201
    8000515a:	97aa                	add	a5,a5,a0
    8000515c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	add	sp,sp,16
    80005166:	8082                	ret

0000000080005168 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005168:	1141                	add	sp,sp,-16
    8000516a:	e406                	sd	ra,8(sp)
    8000516c:	e022                	sd	s0,0(sp)
    8000516e:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	cf0080e7          	jalr	-784(ra) # 80000e60 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005178:	00d5151b          	sllw	a0,a0,0xd
    8000517c:	0c2017b7          	lui	a5,0xc201
    80005180:	97aa                	add	a5,a5,a0
  return irq;
}
    80005182:	43c8                	lw	a0,4(a5)
    80005184:	60a2                	ld	ra,8(sp)
    80005186:	6402                	ld	s0,0(sp)
    80005188:	0141                	add	sp,sp,16
    8000518a:	8082                	ret

000000008000518c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000518c:	1101                	add	sp,sp,-32
    8000518e:	ec06                	sd	ra,24(sp)
    80005190:	e822                	sd	s0,16(sp)
    80005192:	e426                	sd	s1,8(sp)
    80005194:	1000                	add	s0,sp,32
    80005196:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	cc8080e7          	jalr	-824(ra) # 80000e60 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051a0:	00d5151b          	sllw	a0,a0,0xd
    800051a4:	0c2017b7          	lui	a5,0xc201
    800051a8:	97aa                	add	a5,a5,a0
    800051aa:	c3c4                	sw	s1,4(a5)
}
    800051ac:	60e2                	ld	ra,24(sp)
    800051ae:	6442                	ld	s0,16(sp)
    800051b0:	64a2                	ld	s1,8(sp)
    800051b2:	6105                	add	sp,sp,32
    800051b4:	8082                	ret

00000000800051b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051b6:	1141                	add	sp,sp,-16
    800051b8:	e406                	sd	ra,8(sp)
    800051ba:	e022                	sd	s0,0(sp)
    800051bc:	0800                	add	s0,sp,16
  if(i >= NUM)
    800051be:	479d                	li	a5,7
    800051c0:	06a7c863          	blt	a5,a0,80005230 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800051c4:	00016717          	auipc	a4,0x16
    800051c8:	e3c70713          	add	a4,a4,-452 # 8001b000 <disk>
    800051cc:	972a                	add	a4,a4,a0
    800051ce:	6789                	lui	a5,0x2
    800051d0:	97ba                	add	a5,a5,a4
    800051d2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051d6:	e7ad                	bnez	a5,80005240 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051d8:	00451793          	sll	a5,a0,0x4
    800051dc:	00018717          	auipc	a4,0x18
    800051e0:	e2470713          	add	a4,a4,-476 # 8001d000 <disk+0x2000>
    800051e4:	6314                	ld	a3,0(a4)
    800051e6:	96be                	add	a3,a3,a5
    800051e8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051ec:	6314                	ld	a3,0(a4)
    800051ee:	96be                	add	a3,a3,a5
    800051f0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051f4:	6314                	ld	a3,0(a4)
    800051f6:	96be                	add	a3,a3,a5
    800051f8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051fc:	6318                	ld	a4,0(a4)
    800051fe:	97ba                	add	a5,a5,a4
    80005200:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005204:	00016717          	auipc	a4,0x16
    80005208:	dfc70713          	add	a4,a4,-516 # 8001b000 <disk>
    8000520c:	972a                	add	a4,a4,a0
    8000520e:	6789                	lui	a5,0x2
    80005210:	97ba                	add	a5,a5,a4
    80005212:	4705                	li	a4,1
    80005214:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005218:	00018517          	auipc	a0,0x18
    8000521c:	e0050513          	add	a0,a0,-512 # 8001d018 <disk+0x2018>
    80005220:	ffffc097          	auipc	ra,0xffffc
    80005224:	4c4080e7          	jalr	1220(ra) # 800016e4 <wakeup>
}
    80005228:	60a2                	ld	ra,8(sp)
    8000522a:	6402                	ld	s0,0(sp)
    8000522c:	0141                	add	sp,sp,16
    8000522e:	8082                	ret
    panic("free_desc 1");
    80005230:	00003517          	auipc	a0,0x3
    80005234:	64850513          	add	a0,a0,1608 # 80008878 <syscall_names+0x328>
    80005238:	00001097          	auipc	ra,0x1
    8000523c:	9c2080e7          	jalr	-1598(ra) # 80005bfa <panic>
    panic("free_desc 2");
    80005240:	00003517          	auipc	a0,0x3
    80005244:	64850513          	add	a0,a0,1608 # 80008888 <syscall_names+0x338>
    80005248:	00001097          	auipc	ra,0x1
    8000524c:	9b2080e7          	jalr	-1614(ra) # 80005bfa <panic>

0000000080005250 <virtio_disk_init>:
{
    80005250:	1101                	add	sp,sp,-32
    80005252:	ec06                	sd	ra,24(sp)
    80005254:	e822                	sd	s0,16(sp)
    80005256:	e426                	sd	s1,8(sp)
    80005258:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000525a:	00003597          	auipc	a1,0x3
    8000525e:	63e58593          	add	a1,a1,1598 # 80008898 <syscall_names+0x348>
    80005262:	00018517          	auipc	a0,0x18
    80005266:	ec650513          	add	a0,a0,-314 # 8001d128 <disk+0x2128>
    8000526a:	00001097          	auipc	ra,0x1
    8000526e:	e38080e7          	jalr	-456(ra) # 800060a2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005272:	100017b7          	lui	a5,0x10001
    80005276:	4398                	lw	a4,0(a5)
    80005278:	2701                	sext.w	a4,a4
    8000527a:	747277b7          	lui	a5,0x74727
    8000527e:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005282:	0ef71063          	bne	a4,a5,80005362 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005286:	100017b7          	lui	a5,0x10001
    8000528a:	43dc                	lw	a5,4(a5)
    8000528c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000528e:	4705                	li	a4,1
    80005290:	0ce79963          	bne	a5,a4,80005362 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005294:	100017b7          	lui	a5,0x10001
    80005298:	479c                	lw	a5,8(a5)
    8000529a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000529c:	4709                	li	a4,2
    8000529e:	0ce79263          	bne	a5,a4,80005362 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052a2:	100017b7          	lui	a5,0x10001
    800052a6:	47d8                	lw	a4,12(a5)
    800052a8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052aa:	554d47b7          	lui	a5,0x554d4
    800052ae:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052b2:	0af71863          	bne	a4,a5,80005362 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	4705                	li	a4,1
    800052bc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052be:	470d                	li	a4,3
    800052c0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052c2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052c4:	c7ffe6b7          	lui	a3,0xc7ffe
    800052c8:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052cc:	8f75                	and	a4,a4,a3
    800052ce:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d0:	472d                	li	a4,11
    800052d2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d4:	473d                	li	a4,15
    800052d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052d8:	6705                	lui	a4,0x1
    800052da:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052dc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052e0:	5bdc                	lw	a5,52(a5)
    800052e2:	2781                	sext.w	a5,a5
  if(max == 0)
    800052e4:	c7d9                	beqz	a5,80005372 <virtio_disk_init+0x122>
  if(max < NUM)
    800052e6:	471d                	li	a4,7
    800052e8:	08f77d63          	bgeu	a4,a5,80005382 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052ec:	100014b7          	lui	s1,0x10001
    800052f0:	47a1                	li	a5,8
    800052f2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052f4:	6609                	lui	a2,0x2
    800052f6:	4581                	li	a1,0
    800052f8:	00016517          	auipc	a0,0x16
    800052fc:	d0850513          	add	a0,a0,-760 # 8001b000 <disk>
    80005300:	ffffb097          	auipc	ra,0xffffb
    80005304:	ec4080e7          	jalr	-316(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005308:	00016717          	auipc	a4,0x16
    8000530c:	cf870713          	add	a4,a4,-776 # 8001b000 <disk>
    80005310:	00c75793          	srl	a5,a4,0xc
    80005314:	2781                	sext.w	a5,a5
    80005316:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005318:	00018797          	auipc	a5,0x18
    8000531c:	ce878793          	add	a5,a5,-792 # 8001d000 <disk+0x2000>
    80005320:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005322:	00016717          	auipc	a4,0x16
    80005326:	d5e70713          	add	a4,a4,-674 # 8001b080 <disk+0x80>
    8000532a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000532c:	00017717          	auipc	a4,0x17
    80005330:	cd470713          	add	a4,a4,-812 # 8001c000 <disk+0x1000>
    80005334:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005336:	4705                	li	a4,1
    80005338:	00e78c23          	sb	a4,24(a5)
    8000533c:	00e78ca3          	sb	a4,25(a5)
    80005340:	00e78d23          	sb	a4,26(a5)
    80005344:	00e78da3          	sb	a4,27(a5)
    80005348:	00e78e23          	sb	a4,28(a5)
    8000534c:	00e78ea3          	sb	a4,29(a5)
    80005350:	00e78f23          	sb	a4,30(a5)
    80005354:	00e78fa3          	sb	a4,31(a5)
}
    80005358:	60e2                	ld	ra,24(sp)
    8000535a:	6442                	ld	s0,16(sp)
    8000535c:	64a2                	ld	s1,8(sp)
    8000535e:	6105                	add	sp,sp,32
    80005360:	8082                	ret
    panic("could not find virtio disk");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	54650513          	add	a0,a0,1350 # 800088a8 <syscall_names+0x358>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	890080e7          	jalr	-1904(ra) # 80005bfa <panic>
    panic("virtio disk has no queue 0");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	55650513          	add	a0,a0,1366 # 800088c8 <syscall_names+0x378>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	880080e7          	jalr	-1920(ra) # 80005bfa <panic>
    panic("virtio disk max queue too short");
    80005382:	00003517          	auipc	a0,0x3
    80005386:	56650513          	add	a0,a0,1382 # 800088e8 <syscall_names+0x398>
    8000538a:	00001097          	auipc	ra,0x1
    8000538e:	870080e7          	jalr	-1936(ra) # 80005bfa <panic>

0000000080005392 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005392:	7159                	add	sp,sp,-112
    80005394:	f486                	sd	ra,104(sp)
    80005396:	f0a2                	sd	s0,96(sp)
    80005398:	eca6                	sd	s1,88(sp)
    8000539a:	e8ca                	sd	s2,80(sp)
    8000539c:	e4ce                	sd	s3,72(sp)
    8000539e:	e0d2                	sd	s4,64(sp)
    800053a0:	fc56                	sd	s5,56(sp)
    800053a2:	f85a                	sd	s6,48(sp)
    800053a4:	f45e                	sd	s7,40(sp)
    800053a6:	f062                	sd	s8,32(sp)
    800053a8:	ec66                	sd	s9,24(sp)
    800053aa:	e86a                	sd	s10,16(sp)
    800053ac:	1880                	add	s0,sp,112
    800053ae:	8a2a                	mv	s4,a0
    800053b0:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053b2:	00c52c03          	lw	s8,12(a0)
    800053b6:	001c1c1b          	sllw	s8,s8,0x1
    800053ba:	1c02                	sll	s8,s8,0x20
    800053bc:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800053c0:	00018517          	auipc	a0,0x18
    800053c4:	d6850513          	add	a0,a0,-664 # 8001d128 <disk+0x2128>
    800053c8:	00001097          	auipc	ra,0x1
    800053cc:	d6a080e7          	jalr	-662(ra) # 80006132 <acquire>
  for(int i = 0; i < 3; i++){
    800053d0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800053d2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053d4:	00016b97          	auipc	s7,0x16
    800053d8:	c2cb8b93          	add	s7,s7,-980 # 8001b000 <disk>
    800053dc:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053de:	4a8d                	li	s5,3
    800053e0:	a0b5                	j	8000544c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800053e2:	00fb8733          	add	a4,s7,a5
    800053e6:	975a                	add	a4,a4,s6
    800053e8:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053ec:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800053ee:	0207c563          	bltz	a5,80005418 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    800053f2:	2605                	addw	a2,a2,1 # 2001 <_entry-0x7fffdfff>
    800053f4:	0591                	add	a1,a1,4
    800053f6:	19560c63          	beq	a2,s5,8000558e <virtio_disk_rw+0x1fc>
    idx[i] = alloc_desc();
    800053fa:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800053fc:	00018717          	auipc	a4,0x18
    80005400:	c1c70713          	add	a4,a4,-996 # 8001d018 <disk+0x2018>
    80005404:	87ca                	mv	a5,s2
    if(disk.free[i]){
    80005406:	00074683          	lbu	a3,0(a4)
    8000540a:	fee1                	bnez	a3,800053e2 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    8000540c:	2785                	addw	a5,a5,1
    8000540e:	0705                	add	a4,a4,1
    80005410:	fe979be3          	bne	a5,s1,80005406 <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    80005414:	57fd                	li	a5,-1
    80005416:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005418:	00c05e63          	blez	a2,80005434 <virtio_disk_rw+0xa2>
    8000541c:	060a                	sll	a2,a2,0x2
    8000541e:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005422:	0009a503          	lw	a0,0(s3)
    80005426:	00000097          	auipc	ra,0x0
    8000542a:	d90080e7          	jalr	-624(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    8000542e:	0991                	add	s3,s3,4
    80005430:	ffa999e3          	bne	s3,s10,80005422 <virtio_disk_rw+0x90>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005434:	00018597          	auipc	a1,0x18
    80005438:	cf458593          	add	a1,a1,-780 # 8001d128 <disk+0x2128>
    8000543c:	00018517          	auipc	a0,0x18
    80005440:	bdc50513          	add	a0,a0,-1060 # 8001d018 <disk+0x2018>
    80005444:	ffffc097          	auipc	ra,0xffffc
    80005448:	114080e7          	jalr	276(ra) # 80001558 <sleep>
  for(int i = 0; i < 3; i++){
    8000544c:	f9040993          	add	s3,s0,-112
{
    80005450:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005452:	864a                	mv	a2,s2
    80005454:	b75d                	j	800053fa <virtio_disk_rw+0x68>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005456:	00018697          	auipc	a3,0x18
    8000545a:	baa6b683          	ld	a3,-1110(a3) # 8001d000 <disk+0x2000>
    8000545e:	96ba                	add	a3,a3,a4
    80005460:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005464:	00016817          	auipc	a6,0x16
    80005468:	b9c80813          	add	a6,a6,-1124 # 8001b000 <disk>
    8000546c:	00018697          	auipc	a3,0x18
    80005470:	b9468693          	add	a3,a3,-1132 # 8001d000 <disk+0x2000>
    80005474:	6290                	ld	a2,0(a3)
    80005476:	963a                	add	a2,a2,a4
    80005478:	00c65583          	lhu	a1,12(a2)
    8000547c:	0015e593          	or	a1,a1,1
    80005480:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005484:	f9842603          	lw	a2,-104(s0)
    80005488:	628c                	ld	a1,0(a3)
    8000548a:	972e                	add	a4,a4,a1
    8000548c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005490:	20050593          	add	a1,a0,512
    80005494:	0592                	sll	a1,a1,0x4
    80005496:	95c2                	add	a1,a1,a6
    80005498:	577d                	li	a4,-1
    8000549a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000549e:	00461713          	sll	a4,a2,0x4
    800054a2:	6290                	ld	a2,0(a3)
    800054a4:	963a                	add	a2,a2,a4
    800054a6:	03078793          	add	a5,a5,48
    800054aa:	97c2                	add	a5,a5,a6
    800054ac:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054ae:	629c                	ld	a5,0(a3)
    800054b0:	97ba                	add	a5,a5,a4
    800054b2:	4605                	li	a2,1
    800054b4:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054b6:	629c                	ld	a5,0(a3)
    800054b8:	97ba                	add	a5,a5,a4
    800054ba:	4809                	li	a6,2
    800054bc:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800054c0:	629c                	ld	a5,0(a3)
    800054c2:	97ba                	add	a5,a5,a4
    800054c4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054c8:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    800054cc:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054d0:	6698                	ld	a4,8(a3)
    800054d2:	00275783          	lhu	a5,2(a4)
    800054d6:	8b9d                	and	a5,a5,7
    800054d8:	0786                	sll	a5,a5,0x1
    800054da:	973e                	add	a4,a4,a5
    800054dc:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800054e0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054e4:	6698                	ld	a4,8(a3)
    800054e6:	00275783          	lhu	a5,2(a4)
    800054ea:	2785                	addw	a5,a5,1
    800054ec:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054f0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054f4:	100017b7          	lui	a5,0x10001
    800054f8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054fc:	004a2783          	lw	a5,4(s4)
    80005500:	02c79163          	bne	a5,a2,80005522 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005504:	00018917          	auipc	s2,0x18
    80005508:	c2490913          	add	s2,s2,-988 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000550c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000550e:	85ca                	mv	a1,s2
    80005510:	8552                	mv	a0,s4
    80005512:	ffffc097          	auipc	ra,0xffffc
    80005516:	046080e7          	jalr	70(ra) # 80001558 <sleep>
  while(b->disk == 1) {
    8000551a:	004a2783          	lw	a5,4(s4)
    8000551e:	fe9788e3          	beq	a5,s1,8000550e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005522:	f9042903          	lw	s2,-112(s0)
    80005526:	20090713          	add	a4,s2,512
    8000552a:	0712                	sll	a4,a4,0x4
    8000552c:	00016797          	auipc	a5,0x16
    80005530:	ad478793          	add	a5,a5,-1324 # 8001b000 <disk>
    80005534:	97ba                	add	a5,a5,a4
    80005536:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000553a:	00018997          	auipc	s3,0x18
    8000553e:	ac698993          	add	s3,s3,-1338 # 8001d000 <disk+0x2000>
    80005542:	00491713          	sll	a4,s2,0x4
    80005546:	0009b783          	ld	a5,0(s3)
    8000554a:	97ba                	add	a5,a5,a4
    8000554c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005550:	854a                	mv	a0,s2
    80005552:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005556:	00000097          	auipc	ra,0x0
    8000555a:	c60080e7          	jalr	-928(ra) # 800051b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000555e:	8885                	and	s1,s1,1
    80005560:	f0ed                	bnez	s1,80005542 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005562:	00018517          	auipc	a0,0x18
    80005566:	bc650513          	add	a0,a0,-1082 # 8001d128 <disk+0x2128>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	c7c080e7          	jalr	-900(ra) # 800061e6 <release>
}
    80005572:	70a6                	ld	ra,104(sp)
    80005574:	7406                	ld	s0,96(sp)
    80005576:	64e6                	ld	s1,88(sp)
    80005578:	6946                	ld	s2,80(sp)
    8000557a:	69a6                	ld	s3,72(sp)
    8000557c:	6a06                	ld	s4,64(sp)
    8000557e:	7ae2                	ld	s5,56(sp)
    80005580:	7b42                	ld	s6,48(sp)
    80005582:	7ba2                	ld	s7,40(sp)
    80005584:	7c02                	ld	s8,32(sp)
    80005586:	6ce2                	ld	s9,24(sp)
    80005588:	6d42                	ld	s10,16(sp)
    8000558a:	6165                	add	sp,sp,112
    8000558c:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000558e:	f9042503          	lw	a0,-112(s0)
    80005592:	20050793          	add	a5,a0,512
    80005596:	0792                	sll	a5,a5,0x4
  if(write)
    80005598:	00016817          	auipc	a6,0x16
    8000559c:	a6880813          	add	a6,a6,-1432 # 8001b000 <disk>
    800055a0:	00f80733          	add	a4,a6,a5
    800055a4:	019036b3          	snez	a3,s9
    800055a8:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055ac:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055b0:	0b873823          	sd	s8,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055b4:	7679                	lui	a2,0xffffe
    800055b6:	963e                	add	a2,a2,a5
    800055b8:	00018697          	auipc	a3,0x18
    800055bc:	a4868693          	add	a3,a3,-1464 # 8001d000 <disk+0x2000>
    800055c0:	6298                	ld	a4,0(a3)
    800055c2:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055c4:	0a878593          	add	a1,a5,168
    800055c8:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055ca:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055cc:	6298                	ld	a4,0(a3)
    800055ce:	9732                	add	a4,a4,a2
    800055d0:	45c1                	li	a1,16
    800055d2:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055d4:	6298                	ld	a4,0(a3)
    800055d6:	9732                	add	a4,a4,a2
    800055d8:	4585                	li	a1,1
    800055da:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055de:	f9442703          	lw	a4,-108(s0)
    800055e2:	628c                	ld	a1,0(a3)
    800055e4:	962e                	add	a2,a2,a1
    800055e6:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800055ea:	0712                	sll	a4,a4,0x4
    800055ec:	6290                	ld	a2,0(a3)
    800055ee:	963a                	add	a2,a2,a4
    800055f0:	058a0593          	add	a1,s4,88
    800055f4:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055f6:	6294                	ld	a3,0(a3)
    800055f8:	96ba                	add	a3,a3,a4
    800055fa:	40000613          	li	a2,1024
    800055fe:	c690                	sw	a2,8(a3)
  if(write)
    80005600:	e40c9be3          	bnez	s9,80005456 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005604:	00018697          	auipc	a3,0x18
    80005608:	9fc6b683          	ld	a3,-1540(a3) # 8001d000 <disk+0x2000>
    8000560c:	96ba                	add	a3,a3,a4
    8000560e:	4609                	li	a2,2
    80005610:	00c69623          	sh	a2,12(a3)
    80005614:	bd81                	j	80005464 <virtio_disk_rw+0xd2>

0000000080005616 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005616:	1101                	add	sp,sp,-32
    80005618:	ec06                	sd	ra,24(sp)
    8000561a:	e822                	sd	s0,16(sp)
    8000561c:	e426                	sd	s1,8(sp)
    8000561e:	e04a                	sd	s2,0(sp)
    80005620:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005622:	00018517          	auipc	a0,0x18
    80005626:	b0650513          	add	a0,a0,-1274 # 8001d128 <disk+0x2128>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	b08080e7          	jalr	-1272(ra) # 80006132 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005632:	10001737          	lui	a4,0x10001
    80005636:	533c                	lw	a5,96(a4)
    80005638:	8b8d                	and	a5,a5,3
    8000563a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000563c:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005640:	00018797          	auipc	a5,0x18
    80005644:	9c078793          	add	a5,a5,-1600 # 8001d000 <disk+0x2000>
    80005648:	6b94                	ld	a3,16(a5)
    8000564a:	0207d703          	lhu	a4,32(a5)
    8000564e:	0026d783          	lhu	a5,2(a3)
    80005652:	06f70163          	beq	a4,a5,800056b4 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005656:	00016917          	auipc	s2,0x16
    8000565a:	9aa90913          	add	s2,s2,-1622 # 8001b000 <disk>
    8000565e:	00018497          	auipc	s1,0x18
    80005662:	9a248493          	add	s1,s1,-1630 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005666:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000566a:	6898                	ld	a4,16(s1)
    8000566c:	0204d783          	lhu	a5,32(s1)
    80005670:	8b9d                	and	a5,a5,7
    80005672:	078e                	sll	a5,a5,0x3
    80005674:	97ba                	add	a5,a5,a4
    80005676:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005678:	20078713          	add	a4,a5,512
    8000567c:	0712                	sll	a4,a4,0x4
    8000567e:	974a                	add	a4,a4,s2
    80005680:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005684:	e731                	bnez	a4,800056d0 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005686:	20078793          	add	a5,a5,512
    8000568a:	0792                	sll	a5,a5,0x4
    8000568c:	97ca                	add	a5,a5,s2
    8000568e:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005690:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005694:	ffffc097          	auipc	ra,0xffffc
    80005698:	050080e7          	jalr	80(ra) # 800016e4 <wakeup>

    disk.used_idx += 1;
    8000569c:	0204d783          	lhu	a5,32(s1)
    800056a0:	2785                	addw	a5,a5,1
    800056a2:	17c2                	sll	a5,a5,0x30
    800056a4:	93c1                	srl	a5,a5,0x30
    800056a6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056aa:	6898                	ld	a4,16(s1)
    800056ac:	00275703          	lhu	a4,2(a4)
    800056b0:	faf71be3          	bne	a4,a5,80005666 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056b4:	00018517          	auipc	a0,0x18
    800056b8:	a7450513          	add	a0,a0,-1420 # 8001d128 <disk+0x2128>
    800056bc:	00001097          	auipc	ra,0x1
    800056c0:	b2a080e7          	jalr	-1238(ra) # 800061e6 <release>
}
    800056c4:	60e2                	ld	ra,24(sp)
    800056c6:	6442                	ld	s0,16(sp)
    800056c8:	64a2                	ld	s1,8(sp)
    800056ca:	6902                	ld	s2,0(sp)
    800056cc:	6105                	add	sp,sp,32
    800056ce:	8082                	ret
      panic("virtio_disk_intr status");
    800056d0:	00003517          	auipc	a0,0x3
    800056d4:	23850513          	add	a0,a0,568 # 80008908 <syscall_names+0x3b8>
    800056d8:	00000097          	auipc	ra,0x0
    800056dc:	522080e7          	jalr	1314(ra) # 80005bfa <panic>

00000000800056e0 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056e0:	1141                	add	sp,sp,-16
    800056e2:	e422                	sd	s0,8(sp)
    800056e4:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056e6:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056ea:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056ee:	0037979b          	sllw	a5,a5,0x3
    800056f2:	02004737          	lui	a4,0x2004
    800056f6:	97ba                	add	a5,a5,a4
    800056f8:	0200c737          	lui	a4,0x200c
    800056fc:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005700:	000f4637          	lui	a2,0xf4
    80005704:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005708:	9732                	add	a4,a4,a2
    8000570a:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000570c:	00259693          	sll	a3,a1,0x2
    80005710:	96ae                	add	a3,a3,a1
    80005712:	068e                	sll	a3,a3,0x3
    80005714:	00019717          	auipc	a4,0x19
    80005718:	8ec70713          	add	a4,a4,-1812 # 8001e000 <timer_scratch>
    8000571c:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000571e:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005720:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005722:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005726:	00000797          	auipc	a5,0x0
    8000572a:	9ca78793          	add	a5,a5,-1590 # 800050f0 <timervec>
    8000572e:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005732:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005736:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000573a:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000573e:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005742:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005746:	30479073          	csrw	mie,a5
}
    8000574a:	6422                	ld	s0,8(sp)
    8000574c:	0141                	add	sp,sp,16
    8000574e:	8082                	ret

0000000080005750 <start>:
{
    80005750:	1141                	add	sp,sp,-16
    80005752:	e406                	sd	ra,8(sp)
    80005754:	e022                	sd	s0,0(sp)
    80005756:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005758:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000575c:	7779                	lui	a4,0xffffe
    8000575e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005762:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005764:	6705                	lui	a4,0x1
    80005766:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000576a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000576c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005770:	ffffb797          	auipc	a5,0xffffb
    80005774:	bf878793          	add	a5,a5,-1032 # 80000368 <main>
    80005778:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000577c:	4781                	li	a5,0
    8000577e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005782:	67c1                	lui	a5,0x10
    80005784:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005786:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000578a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000578e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005792:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005796:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000579a:	57fd                	li	a5,-1
    8000579c:	83a9                	srl	a5,a5,0xa
    8000579e:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057a2:	47bd                	li	a5,15
    800057a4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057a8:	00000097          	auipc	ra,0x0
    800057ac:	f38080e7          	jalr	-200(ra) # 800056e0 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057b0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057b4:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057b6:	823e                	mv	tp,a5
  asm volatile("mret");
    800057b8:	30200073          	mret
}
    800057bc:	60a2                	ld	ra,8(sp)
    800057be:	6402                	ld	s0,0(sp)
    800057c0:	0141                	add	sp,sp,16
    800057c2:	8082                	ret

00000000800057c4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057c4:	715d                	add	sp,sp,-80
    800057c6:	e486                	sd	ra,72(sp)
    800057c8:	e0a2                	sd	s0,64(sp)
    800057ca:	fc26                	sd	s1,56(sp)
    800057cc:	f84a                	sd	s2,48(sp)
    800057ce:	f44e                	sd	s3,40(sp)
    800057d0:	f052                	sd	s4,32(sp)
    800057d2:	ec56                	sd	s5,24(sp)
    800057d4:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057d6:	04c05763          	blez	a2,80005824 <consolewrite+0x60>
    800057da:	8a2a                	mv	s4,a0
    800057dc:	84ae                	mv	s1,a1
    800057de:	89b2                	mv	s3,a2
    800057e0:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057e2:	5afd                	li	s5,-1
    800057e4:	4685                	li	a3,1
    800057e6:	8626                	mv	a2,s1
    800057e8:	85d2                	mv	a1,s4
    800057ea:	fbf40513          	add	a0,s0,-65
    800057ee:	ffffc097          	auipc	ra,0xffffc
    800057f2:	164080e7          	jalr	356(ra) # 80001952 <either_copyin>
    800057f6:	01550d63          	beq	a0,s5,80005810 <consolewrite+0x4c>
      break;
    uartputc(c);
    800057fa:	fbf44503          	lbu	a0,-65(s0)
    800057fe:	00000097          	auipc	ra,0x0
    80005802:	77a080e7          	jalr	1914(ra) # 80005f78 <uartputc>
  for(i = 0; i < n; i++){
    80005806:	2905                	addw	s2,s2,1
    80005808:	0485                	add	s1,s1,1
    8000580a:	fd299de3          	bne	s3,s2,800057e4 <consolewrite+0x20>
    8000580e:	894e                	mv	s2,s3
  }

  return i;
}
    80005810:	854a                	mv	a0,s2
    80005812:	60a6                	ld	ra,72(sp)
    80005814:	6406                	ld	s0,64(sp)
    80005816:	74e2                	ld	s1,56(sp)
    80005818:	7942                	ld	s2,48(sp)
    8000581a:	79a2                	ld	s3,40(sp)
    8000581c:	7a02                	ld	s4,32(sp)
    8000581e:	6ae2                	ld	s5,24(sp)
    80005820:	6161                	add	sp,sp,80
    80005822:	8082                	ret
  for(i = 0; i < n; i++){
    80005824:	4901                	li	s2,0
    80005826:	b7ed                	j	80005810 <consolewrite+0x4c>

0000000080005828 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005828:	711d                	add	sp,sp,-96
    8000582a:	ec86                	sd	ra,88(sp)
    8000582c:	e8a2                	sd	s0,80(sp)
    8000582e:	e4a6                	sd	s1,72(sp)
    80005830:	e0ca                	sd	s2,64(sp)
    80005832:	fc4e                	sd	s3,56(sp)
    80005834:	f852                	sd	s4,48(sp)
    80005836:	f456                	sd	s5,40(sp)
    80005838:	f05a                	sd	s6,32(sp)
    8000583a:	ec5e                	sd	s7,24(sp)
    8000583c:	1080                	add	s0,sp,96
    8000583e:	8aaa                	mv	s5,a0
    80005840:	8a2e                	mv	s4,a1
    80005842:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005844:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005848:	00021517          	auipc	a0,0x21
    8000584c:	8f850513          	add	a0,a0,-1800 # 80026140 <cons>
    80005850:	00001097          	auipc	ra,0x1
    80005854:	8e2080e7          	jalr	-1822(ra) # 80006132 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005858:	00021497          	auipc	s1,0x21
    8000585c:	8e848493          	add	s1,s1,-1816 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005860:	00021917          	auipc	s2,0x21
    80005864:	97890913          	add	s2,s2,-1672 # 800261d8 <cons+0x98>
  while(n > 0){
    80005868:	07305f63          	blez	s3,800058e6 <consoleread+0xbe>
    while(cons.r == cons.w){
    8000586c:	0984a783          	lw	a5,152(s1)
    80005870:	09c4a703          	lw	a4,156(s1)
    80005874:	02f71463          	bne	a4,a5,8000589c <consoleread+0x74>
      if(myproc()->killed){
    80005878:	ffffb097          	auipc	ra,0xffffb
    8000587c:	614080e7          	jalr	1556(ra) # 80000e8c <myproc>
    80005880:	551c                	lw	a5,40(a0)
    80005882:	efad                	bnez	a5,800058fc <consoleread+0xd4>
      sleep(&cons.r, &cons.lock);
    80005884:	85a6                	mv	a1,s1
    80005886:	854a                	mv	a0,s2
    80005888:	ffffc097          	auipc	ra,0xffffc
    8000588c:	cd0080e7          	jalr	-816(ra) # 80001558 <sleep>
    while(cons.r == cons.w){
    80005890:	0984a783          	lw	a5,152(s1)
    80005894:	09c4a703          	lw	a4,156(s1)
    80005898:	fef700e3          	beq	a4,a5,80005878 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    8000589c:	00021717          	auipc	a4,0x21
    800058a0:	8a470713          	add	a4,a4,-1884 # 80026140 <cons>
    800058a4:	0017869b          	addw	a3,a5,1
    800058a8:	08d72c23          	sw	a3,152(a4)
    800058ac:	07f7f693          	and	a3,a5,127
    800058b0:	9736                	add	a4,a4,a3
    800058b2:	01874703          	lbu	a4,24(a4)
    800058b6:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800058ba:	4691                	li	a3,4
    800058bc:	06db8463          	beq	s7,a3,80005924 <consoleread+0xfc>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800058c0:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058c4:	4685                	li	a3,1
    800058c6:	faf40613          	add	a2,s0,-81
    800058ca:	85d2                	mv	a1,s4
    800058cc:	8556                	mv	a0,s5
    800058ce:	ffffc097          	auipc	ra,0xffffc
    800058d2:	02e080e7          	jalr	46(ra) # 800018fc <either_copyout>
    800058d6:	57fd                	li	a5,-1
    800058d8:	00f50763          	beq	a0,a5,800058e6 <consoleread+0xbe>
      break;

    dst++;
    800058dc:	0a05                	add	s4,s4,1
    --n;
    800058de:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    800058e0:	47a9                	li	a5,10
    800058e2:	f8fb93e3          	bne	s7,a5,80005868 <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058e6:	00021517          	auipc	a0,0x21
    800058ea:	85a50513          	add	a0,a0,-1958 # 80026140 <cons>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	8f8080e7          	jalr	-1800(ra) # 800061e6 <release>

  return target - n;
    800058f6:	413b053b          	subw	a0,s6,s3
    800058fa:	a811                	j	8000590e <consoleread+0xe6>
        release(&cons.lock);
    800058fc:	00021517          	auipc	a0,0x21
    80005900:	84450513          	add	a0,a0,-1980 # 80026140 <cons>
    80005904:	00001097          	auipc	ra,0x1
    80005908:	8e2080e7          	jalr	-1822(ra) # 800061e6 <release>
        return -1;
    8000590c:	557d                	li	a0,-1
}
    8000590e:	60e6                	ld	ra,88(sp)
    80005910:	6446                	ld	s0,80(sp)
    80005912:	64a6                	ld	s1,72(sp)
    80005914:	6906                	ld	s2,64(sp)
    80005916:	79e2                	ld	s3,56(sp)
    80005918:	7a42                	ld	s4,48(sp)
    8000591a:	7aa2                	ld	s5,40(sp)
    8000591c:	7b02                	ld	s6,32(sp)
    8000591e:	6be2                	ld	s7,24(sp)
    80005920:	6125                	add	sp,sp,96
    80005922:	8082                	ret
      if(n < target){
    80005924:	0009871b          	sext.w	a4,s3
    80005928:	fb677fe3          	bgeu	a4,s6,800058e6 <consoleread+0xbe>
        cons.r--;
    8000592c:	00021717          	auipc	a4,0x21
    80005930:	8af72623          	sw	a5,-1876(a4) # 800261d8 <cons+0x98>
    80005934:	bf4d                	j	800058e6 <consoleread+0xbe>

0000000080005936 <consputc>:
{
    80005936:	1141                	add	sp,sp,-16
    80005938:	e406                	sd	ra,8(sp)
    8000593a:	e022                	sd	s0,0(sp)
    8000593c:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    8000593e:	10000793          	li	a5,256
    80005942:	00f50a63          	beq	a0,a5,80005956 <consputc+0x20>
    uartputc_sync(c);
    80005946:	00000097          	auipc	ra,0x0
    8000594a:	560080e7          	jalr	1376(ra) # 80005ea6 <uartputc_sync>
}
    8000594e:	60a2                	ld	ra,8(sp)
    80005950:	6402                	ld	s0,0(sp)
    80005952:	0141                	add	sp,sp,16
    80005954:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005956:	4521                	li	a0,8
    80005958:	00000097          	auipc	ra,0x0
    8000595c:	54e080e7          	jalr	1358(ra) # 80005ea6 <uartputc_sync>
    80005960:	02000513          	li	a0,32
    80005964:	00000097          	auipc	ra,0x0
    80005968:	542080e7          	jalr	1346(ra) # 80005ea6 <uartputc_sync>
    8000596c:	4521                	li	a0,8
    8000596e:	00000097          	auipc	ra,0x0
    80005972:	538080e7          	jalr	1336(ra) # 80005ea6 <uartputc_sync>
    80005976:	bfe1                	j	8000594e <consputc+0x18>

0000000080005978 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005978:	1101                	add	sp,sp,-32
    8000597a:	ec06                	sd	ra,24(sp)
    8000597c:	e822                	sd	s0,16(sp)
    8000597e:	e426                	sd	s1,8(sp)
    80005980:	e04a                	sd	s2,0(sp)
    80005982:	1000                	add	s0,sp,32
    80005984:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005986:	00020517          	auipc	a0,0x20
    8000598a:	7ba50513          	add	a0,a0,1978 # 80026140 <cons>
    8000598e:	00000097          	auipc	ra,0x0
    80005992:	7a4080e7          	jalr	1956(ra) # 80006132 <acquire>

  switch(c){
    80005996:	47d5                	li	a5,21
    80005998:	0af48663          	beq	s1,a5,80005a44 <consoleintr+0xcc>
    8000599c:	0297ca63          	blt	a5,s1,800059d0 <consoleintr+0x58>
    800059a0:	47a1                	li	a5,8
    800059a2:	0ef48763          	beq	s1,a5,80005a90 <consoleintr+0x118>
    800059a6:	47c1                	li	a5,16
    800059a8:	10f49a63          	bne	s1,a5,80005abc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059ac:	ffffc097          	auipc	ra,0xffffc
    800059b0:	ffc080e7          	jalr	-4(ra) # 800019a8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059b4:	00020517          	auipc	a0,0x20
    800059b8:	78c50513          	add	a0,a0,1932 # 80026140 <cons>
    800059bc:	00001097          	auipc	ra,0x1
    800059c0:	82a080e7          	jalr	-2006(ra) # 800061e6 <release>
}
    800059c4:	60e2                	ld	ra,24(sp)
    800059c6:	6442                	ld	s0,16(sp)
    800059c8:	64a2                	ld	s1,8(sp)
    800059ca:	6902                	ld	s2,0(sp)
    800059cc:	6105                	add	sp,sp,32
    800059ce:	8082                	ret
  switch(c){
    800059d0:	07f00793          	li	a5,127
    800059d4:	0af48e63          	beq	s1,a5,80005a90 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059d8:	00020717          	auipc	a4,0x20
    800059dc:	76870713          	add	a4,a4,1896 # 80026140 <cons>
    800059e0:	0a072783          	lw	a5,160(a4)
    800059e4:	09872703          	lw	a4,152(a4)
    800059e8:	9f99                	subw	a5,a5,a4
    800059ea:	07f00713          	li	a4,127
    800059ee:	fcf763e3          	bltu	a4,a5,800059b4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800059f2:	47b5                	li	a5,13
    800059f4:	0cf48763          	beq	s1,a5,80005ac2 <consoleintr+0x14a>
      consputc(c);
    800059f8:	8526                	mv	a0,s1
    800059fa:	00000097          	auipc	ra,0x0
    800059fe:	f3c080e7          	jalr	-196(ra) # 80005936 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a02:	00020797          	auipc	a5,0x20
    80005a06:	73e78793          	add	a5,a5,1854 # 80026140 <cons>
    80005a0a:	0a07a703          	lw	a4,160(a5)
    80005a0e:	0017069b          	addw	a3,a4,1
    80005a12:	0006861b          	sext.w	a2,a3
    80005a16:	0ad7a023          	sw	a3,160(a5)
    80005a1a:	07f77713          	and	a4,a4,127
    80005a1e:	97ba                	add	a5,a5,a4
    80005a20:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a24:	47a9                	li	a5,10
    80005a26:	0cf48563          	beq	s1,a5,80005af0 <consoleintr+0x178>
    80005a2a:	4791                	li	a5,4
    80005a2c:	0cf48263          	beq	s1,a5,80005af0 <consoleintr+0x178>
    80005a30:	00020797          	auipc	a5,0x20
    80005a34:	7a87a783          	lw	a5,1960(a5) # 800261d8 <cons+0x98>
    80005a38:	0807879b          	addw	a5,a5,128
    80005a3c:	f6f61ce3          	bne	a2,a5,800059b4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a40:	863e                	mv	a2,a5
    80005a42:	a07d                	j	80005af0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a44:	00020717          	auipc	a4,0x20
    80005a48:	6fc70713          	add	a4,a4,1788 # 80026140 <cons>
    80005a4c:	0a072783          	lw	a5,160(a4)
    80005a50:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a54:	00020497          	auipc	s1,0x20
    80005a58:	6ec48493          	add	s1,s1,1772 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a5c:	4929                	li	s2,10
    80005a5e:	f4f70be3          	beq	a4,a5,800059b4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a62:	37fd                	addw	a5,a5,-1
    80005a64:	07f7f713          	and	a4,a5,127
    80005a68:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a6a:	01874703          	lbu	a4,24(a4)
    80005a6e:	f52703e3          	beq	a4,s2,800059b4 <consoleintr+0x3c>
      cons.e--;
    80005a72:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a76:	10000513          	li	a0,256
    80005a7a:	00000097          	auipc	ra,0x0
    80005a7e:	ebc080e7          	jalr	-324(ra) # 80005936 <consputc>
    while(cons.e != cons.w &&
    80005a82:	0a04a783          	lw	a5,160(s1)
    80005a86:	09c4a703          	lw	a4,156(s1)
    80005a8a:	fcf71ce3          	bne	a4,a5,80005a62 <consoleintr+0xea>
    80005a8e:	b71d                	j	800059b4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a90:	00020717          	auipc	a4,0x20
    80005a94:	6b070713          	add	a4,a4,1712 # 80026140 <cons>
    80005a98:	0a072783          	lw	a5,160(a4)
    80005a9c:	09c72703          	lw	a4,156(a4)
    80005aa0:	f0f70ae3          	beq	a4,a5,800059b4 <consoleintr+0x3c>
      cons.e--;
    80005aa4:	37fd                	addw	a5,a5,-1
    80005aa6:	00020717          	auipc	a4,0x20
    80005aaa:	72f72d23          	sw	a5,1850(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005aae:	10000513          	li	a0,256
    80005ab2:	00000097          	auipc	ra,0x0
    80005ab6:	e84080e7          	jalr	-380(ra) # 80005936 <consputc>
    80005aba:	bded                	j	800059b4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005abc:	ee048ce3          	beqz	s1,800059b4 <consoleintr+0x3c>
    80005ac0:	bf21                	j	800059d8 <consoleintr+0x60>
      consputc(c);
    80005ac2:	4529                	li	a0,10
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	e72080e7          	jalr	-398(ra) # 80005936 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005acc:	00020797          	auipc	a5,0x20
    80005ad0:	67478793          	add	a5,a5,1652 # 80026140 <cons>
    80005ad4:	0a07a703          	lw	a4,160(a5)
    80005ad8:	0017069b          	addw	a3,a4,1
    80005adc:	0006861b          	sext.w	a2,a3
    80005ae0:	0ad7a023          	sw	a3,160(a5)
    80005ae4:	07f77713          	and	a4,a4,127
    80005ae8:	97ba                	add	a5,a5,a4
    80005aea:	4729                	li	a4,10
    80005aec:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005af0:	00020797          	auipc	a5,0x20
    80005af4:	6ec7a623          	sw	a2,1772(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005af8:	00020517          	auipc	a0,0x20
    80005afc:	6e050513          	add	a0,a0,1760 # 800261d8 <cons+0x98>
    80005b00:	ffffc097          	auipc	ra,0xffffc
    80005b04:	be4080e7          	jalr	-1052(ra) # 800016e4 <wakeup>
    80005b08:	b575                	j	800059b4 <consoleintr+0x3c>

0000000080005b0a <consoleinit>:

void
consoleinit(void)
{
    80005b0a:	1141                	add	sp,sp,-16
    80005b0c:	e406                	sd	ra,8(sp)
    80005b0e:	e022                	sd	s0,0(sp)
    80005b10:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b12:	00003597          	auipc	a1,0x3
    80005b16:	e0e58593          	add	a1,a1,-498 # 80008920 <syscall_names+0x3d0>
    80005b1a:	00020517          	auipc	a0,0x20
    80005b1e:	62650513          	add	a0,a0,1574 # 80026140 <cons>
    80005b22:	00000097          	auipc	ra,0x0
    80005b26:	580080e7          	jalr	1408(ra) # 800060a2 <initlock>

  uartinit();
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	32c080e7          	jalr	812(ra) # 80005e56 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b32:	00013797          	auipc	a5,0x13
    80005b36:	59678793          	add	a5,a5,1430 # 800190c8 <devsw>
    80005b3a:	00000717          	auipc	a4,0x0
    80005b3e:	cee70713          	add	a4,a4,-786 # 80005828 <consoleread>
    80005b42:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b44:	00000717          	auipc	a4,0x0
    80005b48:	c8070713          	add	a4,a4,-896 # 800057c4 <consolewrite>
    80005b4c:	ef98                	sd	a4,24(a5)
}
    80005b4e:	60a2                	ld	ra,8(sp)
    80005b50:	6402                	ld	s0,0(sp)
    80005b52:	0141                	add	sp,sp,16
    80005b54:	8082                	ret

0000000080005b56 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b56:	7179                	add	sp,sp,-48
    80005b58:	f406                	sd	ra,40(sp)
    80005b5a:	f022                	sd	s0,32(sp)
    80005b5c:	ec26                	sd	s1,24(sp)
    80005b5e:	e84a                	sd	s2,16(sp)
    80005b60:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b62:	c219                	beqz	a2,80005b68 <printint+0x12>
    80005b64:	08054763          	bltz	a0,80005bf2 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b68:	2501                	sext.w	a0,a0
    80005b6a:	4881                	li	a7,0
    80005b6c:	fd040693          	add	a3,s0,-48

  i = 0;
    80005b70:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b72:	2581                	sext.w	a1,a1
    80005b74:	00003617          	auipc	a2,0x3
    80005b78:	ddc60613          	add	a2,a2,-548 # 80008950 <digits>
    80005b7c:	883a                	mv	a6,a4
    80005b7e:	2705                	addw	a4,a4,1
    80005b80:	02b577bb          	remuw	a5,a0,a1
    80005b84:	1782                	sll	a5,a5,0x20
    80005b86:	9381                	srl	a5,a5,0x20
    80005b88:	97b2                	add	a5,a5,a2
    80005b8a:	0007c783          	lbu	a5,0(a5)
    80005b8e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b92:	0005079b          	sext.w	a5,a0
    80005b96:	02b5553b          	divuw	a0,a0,a1
    80005b9a:	0685                	add	a3,a3,1
    80005b9c:	feb7f0e3          	bgeu	a5,a1,80005b7c <printint+0x26>

  if(sign)
    80005ba0:	00088c63          	beqz	a7,80005bb8 <printint+0x62>
    buf[i++] = '-';
    80005ba4:	fe070793          	add	a5,a4,-32
    80005ba8:	00878733          	add	a4,a5,s0
    80005bac:	02d00793          	li	a5,45
    80005bb0:	fef70823          	sb	a5,-16(a4)
    80005bb4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005bb8:	02e05763          	blez	a4,80005be6 <printint+0x90>
    80005bbc:	fd040793          	add	a5,s0,-48
    80005bc0:	00e784b3          	add	s1,a5,a4
    80005bc4:	fff78913          	add	s2,a5,-1
    80005bc8:	993a                	add	s2,s2,a4
    80005bca:	377d                	addw	a4,a4,-1
    80005bcc:	1702                	sll	a4,a4,0x20
    80005bce:	9301                	srl	a4,a4,0x20
    80005bd0:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bd4:	fff4c503          	lbu	a0,-1(s1)
    80005bd8:	00000097          	auipc	ra,0x0
    80005bdc:	d5e080e7          	jalr	-674(ra) # 80005936 <consputc>
  while(--i >= 0)
    80005be0:	14fd                	add	s1,s1,-1
    80005be2:	ff2499e3          	bne	s1,s2,80005bd4 <printint+0x7e>
}
    80005be6:	70a2                	ld	ra,40(sp)
    80005be8:	7402                	ld	s0,32(sp)
    80005bea:	64e2                	ld	s1,24(sp)
    80005bec:	6942                	ld	s2,16(sp)
    80005bee:	6145                	add	sp,sp,48
    80005bf0:	8082                	ret
    x = -xx;
    80005bf2:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005bf6:	4885                	li	a7,1
    x = -xx;
    80005bf8:	bf95                	j	80005b6c <printint+0x16>

0000000080005bfa <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005bfa:	1101                	add	sp,sp,-32
    80005bfc:	ec06                	sd	ra,24(sp)
    80005bfe:	e822                	sd	s0,16(sp)
    80005c00:	e426                	sd	s1,8(sp)
    80005c02:	1000                	add	s0,sp,32
    80005c04:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c06:	00020797          	auipc	a5,0x20
    80005c0a:	5e07ad23          	sw	zero,1530(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c0e:	00003517          	auipc	a0,0x3
    80005c12:	d1a50513          	add	a0,a0,-742 # 80008928 <syscall_names+0x3d8>
    80005c16:	00000097          	auipc	ra,0x0
    80005c1a:	02e080e7          	jalr	46(ra) # 80005c44 <printf>
  printf(s);
    80005c1e:	8526                	mv	a0,s1
    80005c20:	00000097          	auipc	ra,0x0
    80005c24:	024080e7          	jalr	36(ra) # 80005c44 <printf>
  printf("\n");
    80005c28:	00002517          	auipc	a0,0x2
    80005c2c:	42050513          	add	a0,a0,1056 # 80008048 <etext+0x48>
    80005c30:	00000097          	auipc	ra,0x0
    80005c34:	014080e7          	jalr	20(ra) # 80005c44 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c38:	4785                	li	a5,1
    80005c3a:	00003717          	auipc	a4,0x3
    80005c3e:	3ef72123          	sw	a5,994(a4) # 8000901c <panicked>
  for(;;)
    80005c42:	a001                	j	80005c42 <panic+0x48>

0000000080005c44 <printf>:
{
    80005c44:	7131                	add	sp,sp,-192
    80005c46:	fc86                	sd	ra,120(sp)
    80005c48:	f8a2                	sd	s0,112(sp)
    80005c4a:	f4a6                	sd	s1,104(sp)
    80005c4c:	f0ca                	sd	s2,96(sp)
    80005c4e:	ecce                	sd	s3,88(sp)
    80005c50:	e8d2                	sd	s4,80(sp)
    80005c52:	e4d6                	sd	s5,72(sp)
    80005c54:	e0da                	sd	s6,64(sp)
    80005c56:	fc5e                	sd	s7,56(sp)
    80005c58:	f862                	sd	s8,48(sp)
    80005c5a:	f466                	sd	s9,40(sp)
    80005c5c:	f06a                	sd	s10,32(sp)
    80005c5e:	ec6e                	sd	s11,24(sp)
    80005c60:	0100                	add	s0,sp,128
    80005c62:	8a2a                	mv	s4,a0
    80005c64:	e40c                	sd	a1,8(s0)
    80005c66:	e810                	sd	a2,16(s0)
    80005c68:	ec14                	sd	a3,24(s0)
    80005c6a:	f018                	sd	a4,32(s0)
    80005c6c:	f41c                	sd	a5,40(s0)
    80005c6e:	03043823          	sd	a6,48(s0)
    80005c72:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c76:	00020d97          	auipc	s11,0x20
    80005c7a:	58adad83          	lw	s11,1418(s11) # 80026200 <pr+0x18>
  if(locking)
    80005c7e:	020d9b63          	bnez	s11,80005cb4 <printf+0x70>
  if (fmt == 0)
    80005c82:	040a0263          	beqz	s4,80005cc6 <printf+0x82>
  va_start(ap, fmt);
    80005c86:	00840793          	add	a5,s0,8
    80005c8a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c8e:	000a4503          	lbu	a0,0(s4)
    80005c92:	14050f63          	beqz	a0,80005df0 <printf+0x1ac>
    80005c96:	4981                	li	s3,0
    if(c != '%'){
    80005c98:	02500a93          	li	s5,37
    switch(c){
    80005c9c:	07000b93          	li	s7,112
  consputc('x');
    80005ca0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ca2:	00003b17          	auipc	s6,0x3
    80005ca6:	caeb0b13          	add	s6,s6,-850 # 80008950 <digits>
    switch(c){
    80005caa:	07300c93          	li	s9,115
    80005cae:	06400c13          	li	s8,100
    80005cb2:	a82d                	j	80005cec <printf+0xa8>
    acquire(&pr.lock);
    80005cb4:	00020517          	auipc	a0,0x20
    80005cb8:	53450513          	add	a0,a0,1332 # 800261e8 <pr>
    80005cbc:	00000097          	auipc	ra,0x0
    80005cc0:	476080e7          	jalr	1142(ra) # 80006132 <acquire>
    80005cc4:	bf7d                	j	80005c82 <printf+0x3e>
    panic("null fmt");
    80005cc6:	00003517          	auipc	a0,0x3
    80005cca:	c7250513          	add	a0,a0,-910 # 80008938 <syscall_names+0x3e8>
    80005cce:	00000097          	auipc	ra,0x0
    80005cd2:	f2c080e7          	jalr	-212(ra) # 80005bfa <panic>
      consputc(c);
    80005cd6:	00000097          	auipc	ra,0x0
    80005cda:	c60080e7          	jalr	-928(ra) # 80005936 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cde:	2985                	addw	s3,s3,1
    80005ce0:	013a07b3          	add	a5,s4,s3
    80005ce4:	0007c503          	lbu	a0,0(a5)
    80005ce8:	10050463          	beqz	a0,80005df0 <printf+0x1ac>
    if(c != '%'){
    80005cec:	ff5515e3          	bne	a0,s5,80005cd6 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005cf0:	2985                	addw	s3,s3,1
    80005cf2:	013a07b3          	add	a5,s4,s3
    80005cf6:	0007c783          	lbu	a5,0(a5)
    80005cfa:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005cfe:	cbed                	beqz	a5,80005df0 <printf+0x1ac>
    switch(c){
    80005d00:	05778a63          	beq	a5,s7,80005d54 <printf+0x110>
    80005d04:	02fbf663          	bgeu	s7,a5,80005d30 <printf+0xec>
    80005d08:	09978863          	beq	a5,s9,80005d98 <printf+0x154>
    80005d0c:	07800713          	li	a4,120
    80005d10:	0ce79563          	bne	a5,a4,80005dda <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d14:	f8843783          	ld	a5,-120(s0)
    80005d18:	00878713          	add	a4,a5,8
    80005d1c:	f8e43423          	sd	a4,-120(s0)
    80005d20:	4605                	li	a2,1
    80005d22:	85ea                	mv	a1,s10
    80005d24:	4388                	lw	a0,0(a5)
    80005d26:	00000097          	auipc	ra,0x0
    80005d2a:	e30080e7          	jalr	-464(ra) # 80005b56 <printint>
      break;
    80005d2e:	bf45                	j	80005cde <printf+0x9a>
    switch(c){
    80005d30:	09578f63          	beq	a5,s5,80005dce <printf+0x18a>
    80005d34:	0b879363          	bne	a5,s8,80005dda <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d38:	f8843783          	ld	a5,-120(s0)
    80005d3c:	00878713          	add	a4,a5,8
    80005d40:	f8e43423          	sd	a4,-120(s0)
    80005d44:	4605                	li	a2,1
    80005d46:	45a9                	li	a1,10
    80005d48:	4388                	lw	a0,0(a5)
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	e0c080e7          	jalr	-500(ra) # 80005b56 <printint>
      break;
    80005d52:	b771                	j	80005cde <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d54:	f8843783          	ld	a5,-120(s0)
    80005d58:	00878713          	add	a4,a5,8
    80005d5c:	f8e43423          	sd	a4,-120(s0)
    80005d60:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d64:	03000513          	li	a0,48
    80005d68:	00000097          	auipc	ra,0x0
    80005d6c:	bce080e7          	jalr	-1074(ra) # 80005936 <consputc>
  consputc('x');
    80005d70:	07800513          	li	a0,120
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	bc2080e7          	jalr	-1086(ra) # 80005936 <consputc>
    80005d7c:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d7e:	03c95793          	srl	a5,s2,0x3c
    80005d82:	97da                	add	a5,a5,s6
    80005d84:	0007c503          	lbu	a0,0(a5)
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	bae080e7          	jalr	-1106(ra) # 80005936 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d90:	0912                	sll	s2,s2,0x4
    80005d92:	34fd                	addw	s1,s1,-1
    80005d94:	f4ed                	bnez	s1,80005d7e <printf+0x13a>
    80005d96:	b7a1                	j	80005cde <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d98:	f8843783          	ld	a5,-120(s0)
    80005d9c:	00878713          	add	a4,a5,8
    80005da0:	f8e43423          	sd	a4,-120(s0)
    80005da4:	6384                	ld	s1,0(a5)
    80005da6:	cc89                	beqz	s1,80005dc0 <printf+0x17c>
      for(; *s; s++)
    80005da8:	0004c503          	lbu	a0,0(s1)
    80005dac:	d90d                	beqz	a0,80005cde <printf+0x9a>
        consputc(*s);
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	b88080e7          	jalr	-1144(ra) # 80005936 <consputc>
      for(; *s; s++)
    80005db6:	0485                	add	s1,s1,1
    80005db8:	0004c503          	lbu	a0,0(s1)
    80005dbc:	f96d                	bnez	a0,80005dae <printf+0x16a>
    80005dbe:	b705                	j	80005cde <printf+0x9a>
        s = "(null)";
    80005dc0:	00003497          	auipc	s1,0x3
    80005dc4:	b7048493          	add	s1,s1,-1168 # 80008930 <syscall_names+0x3e0>
      for(; *s; s++)
    80005dc8:	02800513          	li	a0,40
    80005dcc:	b7cd                	j	80005dae <printf+0x16a>
      consputc('%');
    80005dce:	8556                	mv	a0,s5
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	b66080e7          	jalr	-1178(ra) # 80005936 <consputc>
      break;
    80005dd8:	b719                	j	80005cde <printf+0x9a>
      consputc('%');
    80005dda:	8556                	mv	a0,s5
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	b5a080e7          	jalr	-1190(ra) # 80005936 <consputc>
      consputc(c);
    80005de4:	8526                	mv	a0,s1
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	b50080e7          	jalr	-1200(ra) # 80005936 <consputc>
      break;
    80005dee:	bdc5                	j	80005cde <printf+0x9a>
  if(locking)
    80005df0:	020d9163          	bnez	s11,80005e12 <printf+0x1ce>
}
    80005df4:	70e6                	ld	ra,120(sp)
    80005df6:	7446                	ld	s0,112(sp)
    80005df8:	74a6                	ld	s1,104(sp)
    80005dfa:	7906                	ld	s2,96(sp)
    80005dfc:	69e6                	ld	s3,88(sp)
    80005dfe:	6a46                	ld	s4,80(sp)
    80005e00:	6aa6                	ld	s5,72(sp)
    80005e02:	6b06                	ld	s6,64(sp)
    80005e04:	7be2                	ld	s7,56(sp)
    80005e06:	7c42                	ld	s8,48(sp)
    80005e08:	7ca2                	ld	s9,40(sp)
    80005e0a:	7d02                	ld	s10,32(sp)
    80005e0c:	6de2                	ld	s11,24(sp)
    80005e0e:	6129                	add	sp,sp,192
    80005e10:	8082                	ret
    release(&pr.lock);
    80005e12:	00020517          	auipc	a0,0x20
    80005e16:	3d650513          	add	a0,a0,982 # 800261e8 <pr>
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	3cc080e7          	jalr	972(ra) # 800061e6 <release>
}
    80005e22:	bfc9                	j	80005df4 <printf+0x1b0>

0000000080005e24 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e24:	1101                	add	sp,sp,-32
    80005e26:	ec06                	sd	ra,24(sp)
    80005e28:	e822                	sd	s0,16(sp)
    80005e2a:	e426                	sd	s1,8(sp)
    80005e2c:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e2e:	00020497          	auipc	s1,0x20
    80005e32:	3ba48493          	add	s1,s1,954 # 800261e8 <pr>
    80005e36:	00003597          	auipc	a1,0x3
    80005e3a:	b1258593          	add	a1,a1,-1262 # 80008948 <syscall_names+0x3f8>
    80005e3e:	8526                	mv	a0,s1
    80005e40:	00000097          	auipc	ra,0x0
    80005e44:	262080e7          	jalr	610(ra) # 800060a2 <initlock>
  pr.locking = 1;
    80005e48:	4785                	li	a5,1
    80005e4a:	cc9c                	sw	a5,24(s1)
}
    80005e4c:	60e2                	ld	ra,24(sp)
    80005e4e:	6442                	ld	s0,16(sp)
    80005e50:	64a2                	ld	s1,8(sp)
    80005e52:	6105                	add	sp,sp,32
    80005e54:	8082                	ret

0000000080005e56 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e56:	1141                	add	sp,sp,-16
    80005e58:	e406                	sd	ra,8(sp)
    80005e5a:	e022                	sd	s0,0(sp)
    80005e5c:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e5e:	100007b7          	lui	a5,0x10000
    80005e62:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e66:	f8000713          	li	a4,-128
    80005e6a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e6e:	470d                	li	a4,3
    80005e70:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e74:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e78:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e7c:	469d                	li	a3,7
    80005e7e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e82:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e86:	00003597          	auipc	a1,0x3
    80005e8a:	ae258593          	add	a1,a1,-1310 # 80008968 <digits+0x18>
    80005e8e:	00020517          	auipc	a0,0x20
    80005e92:	37a50513          	add	a0,a0,890 # 80026208 <uart_tx_lock>
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	20c080e7          	jalr	524(ra) # 800060a2 <initlock>
}
    80005e9e:	60a2                	ld	ra,8(sp)
    80005ea0:	6402                	ld	s0,0(sp)
    80005ea2:	0141                	add	sp,sp,16
    80005ea4:	8082                	ret

0000000080005ea6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ea6:	1101                	add	sp,sp,-32
    80005ea8:	ec06                	sd	ra,24(sp)
    80005eaa:	e822                	sd	s0,16(sp)
    80005eac:	e426                	sd	s1,8(sp)
    80005eae:	1000                	add	s0,sp,32
    80005eb0:	84aa                	mv	s1,a0
  push_off();
    80005eb2:	00000097          	auipc	ra,0x0
    80005eb6:	234080e7          	jalr	564(ra) # 800060e6 <push_off>

  if(panicked){
    80005eba:	00003797          	auipc	a5,0x3
    80005ebe:	1627a783          	lw	a5,354(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ec2:	10000737          	lui	a4,0x10000
  if(panicked){
    80005ec6:	c391                	beqz	a5,80005eca <uartputc_sync+0x24>
    for(;;)
    80005ec8:	a001                	j	80005ec8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005eca:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ece:	0207f793          	and	a5,a5,32
    80005ed2:	dfe5                	beqz	a5,80005eca <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005ed4:	0ff4f513          	zext.b	a0,s1
    80005ed8:	100007b7          	lui	a5,0x10000
    80005edc:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005ee0:	00000097          	auipc	ra,0x0
    80005ee4:	2a6080e7          	jalr	678(ra) # 80006186 <pop_off>
}
    80005ee8:	60e2                	ld	ra,24(sp)
    80005eea:	6442                	ld	s0,16(sp)
    80005eec:	64a2                	ld	s1,8(sp)
    80005eee:	6105                	add	sp,sp,32
    80005ef0:	8082                	ret

0000000080005ef2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005ef2:	00003797          	auipc	a5,0x3
    80005ef6:	12e7b783          	ld	a5,302(a5) # 80009020 <uart_tx_r>
    80005efa:	00003717          	auipc	a4,0x3
    80005efe:	12e73703          	ld	a4,302(a4) # 80009028 <uart_tx_w>
    80005f02:	06f70a63          	beq	a4,a5,80005f76 <uartstart+0x84>
{
    80005f06:	7139                	add	sp,sp,-64
    80005f08:	fc06                	sd	ra,56(sp)
    80005f0a:	f822                	sd	s0,48(sp)
    80005f0c:	f426                	sd	s1,40(sp)
    80005f0e:	f04a                	sd	s2,32(sp)
    80005f10:	ec4e                	sd	s3,24(sp)
    80005f12:	e852                	sd	s4,16(sp)
    80005f14:	e456                	sd	s5,8(sp)
    80005f16:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f18:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f1c:	00020a17          	auipc	s4,0x20
    80005f20:	2eca0a13          	add	s4,s4,748 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f24:	00003497          	auipc	s1,0x3
    80005f28:	0fc48493          	add	s1,s1,252 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f2c:	00003997          	auipc	s3,0x3
    80005f30:	0fc98993          	add	s3,s3,252 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f34:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f38:	02077713          	and	a4,a4,32
    80005f3c:	c705                	beqz	a4,80005f64 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f3e:	01f7f713          	and	a4,a5,31
    80005f42:	9752                	add	a4,a4,s4
    80005f44:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f48:	0785                	add	a5,a5,1
    80005f4a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f4c:	8526                	mv	a0,s1
    80005f4e:	ffffb097          	auipc	ra,0xffffb
    80005f52:	796080e7          	jalr	1942(ra) # 800016e4 <wakeup>
    
    WriteReg(THR, c);
    80005f56:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f5a:	609c                	ld	a5,0(s1)
    80005f5c:	0009b703          	ld	a4,0(s3)
    80005f60:	fcf71ae3          	bne	a4,a5,80005f34 <uartstart+0x42>
  }
}
    80005f64:	70e2                	ld	ra,56(sp)
    80005f66:	7442                	ld	s0,48(sp)
    80005f68:	74a2                	ld	s1,40(sp)
    80005f6a:	7902                	ld	s2,32(sp)
    80005f6c:	69e2                	ld	s3,24(sp)
    80005f6e:	6a42                	ld	s4,16(sp)
    80005f70:	6aa2                	ld	s5,8(sp)
    80005f72:	6121                	add	sp,sp,64
    80005f74:	8082                	ret
    80005f76:	8082                	ret

0000000080005f78 <uartputc>:
{
    80005f78:	7179                	add	sp,sp,-48
    80005f7a:	f406                	sd	ra,40(sp)
    80005f7c:	f022                	sd	s0,32(sp)
    80005f7e:	ec26                	sd	s1,24(sp)
    80005f80:	e84a                	sd	s2,16(sp)
    80005f82:	e44e                	sd	s3,8(sp)
    80005f84:	e052                	sd	s4,0(sp)
    80005f86:	1800                	add	s0,sp,48
    80005f88:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f8a:	00020517          	auipc	a0,0x20
    80005f8e:	27e50513          	add	a0,a0,638 # 80026208 <uart_tx_lock>
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	1a0080e7          	jalr	416(ra) # 80006132 <acquire>
  if(panicked){
    80005f9a:	00003797          	auipc	a5,0x3
    80005f9e:	0827a783          	lw	a5,130(a5) # 8000901c <panicked>
    80005fa2:	c391                	beqz	a5,80005fa6 <uartputc+0x2e>
    for(;;)
    80005fa4:	a001                	j	80005fa4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fa6:	00003717          	auipc	a4,0x3
    80005faa:	08273703          	ld	a4,130(a4) # 80009028 <uart_tx_w>
    80005fae:	00003797          	auipc	a5,0x3
    80005fb2:	0727b783          	ld	a5,114(a5) # 80009020 <uart_tx_r>
    80005fb6:	02078793          	add	a5,a5,32
    80005fba:	02e79b63          	bne	a5,a4,80005ff0 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005fbe:	00020997          	auipc	s3,0x20
    80005fc2:	24a98993          	add	s3,s3,586 # 80026208 <uart_tx_lock>
    80005fc6:	00003497          	auipc	s1,0x3
    80005fca:	05a48493          	add	s1,s1,90 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fce:	00003917          	auipc	s2,0x3
    80005fd2:	05a90913          	add	s2,s2,90 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005fd6:	85ce                	mv	a1,s3
    80005fd8:	8526                	mv	a0,s1
    80005fda:	ffffb097          	auipc	ra,0xffffb
    80005fde:	57e080e7          	jalr	1406(ra) # 80001558 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fe2:	00093703          	ld	a4,0(s2)
    80005fe6:	609c                	ld	a5,0(s1)
    80005fe8:	02078793          	add	a5,a5,32
    80005fec:	fee785e3          	beq	a5,a4,80005fd6 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005ff0:	00020497          	auipc	s1,0x20
    80005ff4:	21848493          	add	s1,s1,536 # 80026208 <uart_tx_lock>
    80005ff8:	01f77793          	and	a5,a4,31
    80005ffc:	97a6                	add	a5,a5,s1
    80005ffe:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006002:	0705                	add	a4,a4,1
    80006004:	00003797          	auipc	a5,0x3
    80006008:	02e7b223          	sd	a4,36(a5) # 80009028 <uart_tx_w>
      uartstart();
    8000600c:	00000097          	auipc	ra,0x0
    80006010:	ee6080e7          	jalr	-282(ra) # 80005ef2 <uartstart>
      release(&uart_tx_lock);
    80006014:	8526                	mv	a0,s1
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	1d0080e7          	jalr	464(ra) # 800061e6 <release>
}
    8000601e:	70a2                	ld	ra,40(sp)
    80006020:	7402                	ld	s0,32(sp)
    80006022:	64e2                	ld	s1,24(sp)
    80006024:	6942                	ld	s2,16(sp)
    80006026:	69a2                	ld	s3,8(sp)
    80006028:	6a02                	ld	s4,0(sp)
    8000602a:	6145                	add	sp,sp,48
    8000602c:	8082                	ret

000000008000602e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000602e:	1141                	add	sp,sp,-16
    80006030:	e422                	sd	s0,8(sp)
    80006032:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006034:	100007b7          	lui	a5,0x10000
    80006038:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000603c:	8b85                	and	a5,a5,1
    8000603e:	cb81                	beqz	a5,8000604e <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006040:	100007b7          	lui	a5,0x10000
    80006044:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006048:	6422                	ld	s0,8(sp)
    8000604a:	0141                	add	sp,sp,16
    8000604c:	8082                	ret
    return -1;
    8000604e:	557d                	li	a0,-1
    80006050:	bfe5                	j	80006048 <uartgetc+0x1a>

0000000080006052 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006052:	1101                	add	sp,sp,-32
    80006054:	ec06                	sd	ra,24(sp)
    80006056:	e822                	sd	s0,16(sp)
    80006058:	e426                	sd	s1,8(sp)
    8000605a:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000605c:	54fd                	li	s1,-1
    8000605e:	a029                	j	80006068 <uartintr+0x16>
      break;
    consoleintr(c);
    80006060:	00000097          	auipc	ra,0x0
    80006064:	918080e7          	jalr	-1768(ra) # 80005978 <consoleintr>
    int c = uartgetc();
    80006068:	00000097          	auipc	ra,0x0
    8000606c:	fc6080e7          	jalr	-58(ra) # 8000602e <uartgetc>
    if(c == -1)
    80006070:	fe9518e3          	bne	a0,s1,80006060 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006074:	00020497          	auipc	s1,0x20
    80006078:	19448493          	add	s1,s1,404 # 80026208 <uart_tx_lock>
    8000607c:	8526                	mv	a0,s1
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	0b4080e7          	jalr	180(ra) # 80006132 <acquire>
  uartstart();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	e6c080e7          	jalr	-404(ra) # 80005ef2 <uartstart>
  release(&uart_tx_lock);
    8000608e:	8526                	mv	a0,s1
    80006090:	00000097          	auipc	ra,0x0
    80006094:	156080e7          	jalr	342(ra) # 800061e6 <release>
}
    80006098:	60e2                	ld	ra,24(sp)
    8000609a:	6442                	ld	s0,16(sp)
    8000609c:	64a2                	ld	s1,8(sp)
    8000609e:	6105                	add	sp,sp,32
    800060a0:	8082                	ret

00000000800060a2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060a2:	1141                	add	sp,sp,-16
    800060a4:	e422                	sd	s0,8(sp)
    800060a6:	0800                	add	s0,sp,16
  lk->name = name;
    800060a8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060aa:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060ae:	00053823          	sd	zero,16(a0)
}
    800060b2:	6422                	ld	s0,8(sp)
    800060b4:	0141                	add	sp,sp,16
    800060b6:	8082                	ret

00000000800060b8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060b8:	411c                	lw	a5,0(a0)
    800060ba:	e399                	bnez	a5,800060c0 <holding+0x8>
    800060bc:	4501                	li	a0,0
  return r;
}
    800060be:	8082                	ret
{
    800060c0:	1101                	add	sp,sp,-32
    800060c2:	ec06                	sd	ra,24(sp)
    800060c4:	e822                	sd	s0,16(sp)
    800060c6:	e426                	sd	s1,8(sp)
    800060c8:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800060ca:	6904                	ld	s1,16(a0)
    800060cc:	ffffb097          	auipc	ra,0xffffb
    800060d0:	da4080e7          	jalr	-604(ra) # 80000e70 <mycpu>
    800060d4:	40a48533          	sub	a0,s1,a0
    800060d8:	00153513          	seqz	a0,a0
}
    800060dc:	60e2                	ld	ra,24(sp)
    800060de:	6442                	ld	s0,16(sp)
    800060e0:	64a2                	ld	s1,8(sp)
    800060e2:	6105                	add	sp,sp,32
    800060e4:	8082                	ret

00000000800060e6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800060e6:	1101                	add	sp,sp,-32
    800060e8:	ec06                	sd	ra,24(sp)
    800060ea:	e822                	sd	s0,16(sp)
    800060ec:	e426                	sd	s1,8(sp)
    800060ee:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060f0:	100024f3          	csrr	s1,sstatus
    800060f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800060f8:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060fa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800060fe:	ffffb097          	auipc	ra,0xffffb
    80006102:	d72080e7          	jalr	-654(ra) # 80000e70 <mycpu>
    80006106:	5d3c                	lw	a5,120(a0)
    80006108:	cf89                	beqz	a5,80006122 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000610a:	ffffb097          	auipc	ra,0xffffb
    8000610e:	d66080e7          	jalr	-666(ra) # 80000e70 <mycpu>
    80006112:	5d3c                	lw	a5,120(a0)
    80006114:	2785                	addw	a5,a5,1
    80006116:	dd3c                	sw	a5,120(a0)
}
    80006118:	60e2                	ld	ra,24(sp)
    8000611a:	6442                	ld	s0,16(sp)
    8000611c:	64a2                	ld	s1,8(sp)
    8000611e:	6105                	add	sp,sp,32
    80006120:	8082                	ret
    mycpu()->intena = old;
    80006122:	ffffb097          	auipc	ra,0xffffb
    80006126:	d4e080e7          	jalr	-690(ra) # 80000e70 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000612a:	8085                	srl	s1,s1,0x1
    8000612c:	8885                	and	s1,s1,1
    8000612e:	dd64                	sw	s1,124(a0)
    80006130:	bfe9                	j	8000610a <push_off+0x24>

0000000080006132 <acquire>:
{
    80006132:	1101                	add	sp,sp,-32
    80006134:	ec06                	sd	ra,24(sp)
    80006136:	e822                	sd	s0,16(sp)
    80006138:	e426                	sd	s1,8(sp)
    8000613a:	1000                	add	s0,sp,32
    8000613c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	fa8080e7          	jalr	-88(ra) # 800060e6 <push_off>
  if(holding(lk))
    80006146:	8526                	mv	a0,s1
    80006148:	00000097          	auipc	ra,0x0
    8000614c:	f70080e7          	jalr	-144(ra) # 800060b8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006150:	4705                	li	a4,1
  if(holding(lk))
    80006152:	e115                	bnez	a0,80006176 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006154:	87ba                	mv	a5,a4
    80006156:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000615a:	2781                	sext.w	a5,a5
    8000615c:	ffe5                	bnez	a5,80006154 <acquire+0x22>
  __sync_synchronize();
    8000615e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006162:	ffffb097          	auipc	ra,0xffffb
    80006166:	d0e080e7          	jalr	-754(ra) # 80000e70 <mycpu>
    8000616a:	e888                	sd	a0,16(s1)
}
    8000616c:	60e2                	ld	ra,24(sp)
    8000616e:	6442                	ld	s0,16(sp)
    80006170:	64a2                	ld	s1,8(sp)
    80006172:	6105                	add	sp,sp,32
    80006174:	8082                	ret
    panic("acquire");
    80006176:	00002517          	auipc	a0,0x2
    8000617a:	7fa50513          	add	a0,a0,2042 # 80008970 <digits+0x20>
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	a7c080e7          	jalr	-1412(ra) # 80005bfa <panic>

0000000080006186 <pop_off>:

void
pop_off(void)
{
    80006186:	1141                	add	sp,sp,-16
    80006188:	e406                	sd	ra,8(sp)
    8000618a:	e022                	sd	s0,0(sp)
    8000618c:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    8000618e:	ffffb097          	auipc	ra,0xffffb
    80006192:	ce2080e7          	jalr	-798(ra) # 80000e70 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006196:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000619a:	8b89                	and	a5,a5,2
  if(intr_get())
    8000619c:	e78d                	bnez	a5,800061c6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000619e:	5d3c                	lw	a5,120(a0)
    800061a0:	02f05b63          	blez	a5,800061d6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061a4:	37fd                	addw	a5,a5,-1
    800061a6:	0007871b          	sext.w	a4,a5
    800061aa:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061ac:	eb09                	bnez	a4,800061be <pop_off+0x38>
    800061ae:	5d7c                	lw	a5,124(a0)
    800061b0:	c799                	beqz	a5,800061be <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061b2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061b6:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061ba:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061be:	60a2                	ld	ra,8(sp)
    800061c0:	6402                	ld	s0,0(sp)
    800061c2:	0141                	add	sp,sp,16
    800061c4:	8082                	ret
    panic("pop_off - interruptible");
    800061c6:	00002517          	auipc	a0,0x2
    800061ca:	7b250513          	add	a0,a0,1970 # 80008978 <digits+0x28>
    800061ce:	00000097          	auipc	ra,0x0
    800061d2:	a2c080e7          	jalr	-1492(ra) # 80005bfa <panic>
    panic("pop_off");
    800061d6:	00002517          	auipc	a0,0x2
    800061da:	7ba50513          	add	a0,a0,1978 # 80008990 <digits+0x40>
    800061de:	00000097          	auipc	ra,0x0
    800061e2:	a1c080e7          	jalr	-1508(ra) # 80005bfa <panic>

00000000800061e6 <release>:
{
    800061e6:	1101                	add	sp,sp,-32
    800061e8:	ec06                	sd	ra,24(sp)
    800061ea:	e822                	sd	s0,16(sp)
    800061ec:	e426                	sd	s1,8(sp)
    800061ee:	1000                	add	s0,sp,32
    800061f0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	ec6080e7          	jalr	-314(ra) # 800060b8 <holding>
    800061fa:	c115                	beqz	a0,8000621e <release+0x38>
  lk->cpu = 0;
    800061fc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006200:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006204:	0f50000f          	fence	iorw,ow
    80006208:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	f7a080e7          	jalr	-134(ra) # 80006186 <pop_off>
}
    80006214:	60e2                	ld	ra,24(sp)
    80006216:	6442                	ld	s0,16(sp)
    80006218:	64a2                	ld	s1,8(sp)
    8000621a:	6105                	add	sp,sp,32
    8000621c:	8082                	ret
    panic("release");
    8000621e:	00002517          	auipc	a0,0x2
    80006222:	77a50513          	add	a0,a0,1914 # 80008998 <digits+0x48>
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	9d4080e7          	jalr	-1580(ra) # 80005bfa <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
