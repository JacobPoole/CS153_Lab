
_lab1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"

#define WNOHANG 	1

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
   a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	
	int exitWait(void);
	int waitPid(void);
	int CELEBW02(void);

  printf(1, "\n This program tests the correctness of your lab#1\n");
   d:	c7 44 24 04 5c 09 00 	movl   $0x95c,0x4(%esp)
  14:	00 
  15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1c:	e8 0f 05 00 00       	call   530 <printf>
  
  if (atoi(argv[1]) == 1)
  21:	8b 43 04             	mov    0x4(%ebx),%eax
  24:	89 04 24             	mov    %eax,(%esp)
  27:	e8 34 03 00 00       	call   360 <atoi>
  2c:	83 f8 01             	cmp    $0x1,%eax
  2f:	74 43                	je     74 <main+0x74>
	exitWait();
  else if (atoi(argv[1]) == 2)
  31:	8b 43 04             	mov    0x4(%ebx),%eax
  34:	89 04 24             	mov    %eax,(%esp)
  37:	e8 24 03 00 00       	call   360 <atoi>
  3c:	83 f8 02             	cmp    $0x2,%eax
  3f:	74 27                	je     68 <main+0x68>
	waitPid();
  else if (atoi(argv[1]) == 3)
  41:	8b 43 04             	mov    0x4(%ebx),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 14 03 00 00       	call   360 <atoi>
  4c:	83 f8 03             	cmp    $0x3,%eax
  4f:	74 17                	je     68 <main+0x68>
	CELEBW02();
  else 
   printf(1, "\ntype \"lab1 1\" to test exit and wait, \"lab1 2\" to test waitpid and \"lab1 3\" to test the extra credit WNOHANG option \n");
  51:	c7 44 24 04 90 09 00 	movl   $0x990,0x4(%esp)
  58:	00 
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 cb 04 00 00       	call   530 <printf>
  65:	8d 76 00             	lea    0x0(%esi),%esi
  
    // End of test
	 exitS(0);
  68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6f:	e8 ee 03 00 00       	call   462 <exitS>
	exitWait();
  74:	e8 07 00 00 00       	call   80 <exitWait>
  79:	eb ed                	jmp    68 <main+0x68>
  7b:	66 90                	xchg   %ax,%ax
  7d:	66 90                	xchg   %ax,%ax
  7f:	90                   	nop

00000080 <exitWait>:
	 return 0;
 }
  
int exitWait(void) {
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	56                   	push   %esi
  84:	53                   	push   %ebx
       int i;
  // use this part to test exit(int status) and wait(int* status)
 
  printf(1, "\n  Parts a & b) testing exit(int status) and wait(int* status):\n");

  for (i = 0; i < 2; i++) {
  85:	31 db                	xor    %ebx,%ebx
int exitWait(void) {
  87:	83 ec 20             	sub    $0x20,%esp
  printf(1, "\n  Parts a & b) testing exit(int status) and wait(int* status):\n");
  8a:	c7 44 24 04 98 08 00 	movl   $0x898,0x4(%esp)
  91:	00 
      {
	 printf(1, "\nThis is child with PID# %d and I will exit with status %d\n" ,getpid(), -1);
      exitS(-1);
  } 
    } else if (pid > 0) { // only the parent executes this code
      ret_pid = waitS(&exit_status);
  92:	8d 75 f4             	lea    -0xc(%ebp),%esi
  printf(1, "\n  Parts a & b) testing exit(int status) and wait(int* status):\n");
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 8f 04 00 00       	call   530 <printf>
    pid = fork();
  a1:	e8 14 03 00 00       	call   3ba <fork>
    if (pid == 0) { // only the child executed this code
  a6:	83 f8 00             	cmp    $0x0,%eax
  a9:	74 45                	je     f0 <exitWait+0x70>
  ab:	90                   	nop
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if (pid > 0) { // only the parent executes this code
  b0:	0f 8e a3 00 00 00    	jle    159 <exitWait+0xd9>
      ret_pid = waitS(&exit_status);
  b6:	89 34 24             	mov    %esi,(%esp)
  for (i = 0; i < 2; i++) {
  b9:	83 c3 01             	add    $0x1,%ebx
      ret_pid = waitS(&exit_status);
  bc:	e8 a9 03 00 00       	call   46a <waitS>
      printf(1, "\n This is the parent: child with PID# %d has exited with status %d\n", ret_pid, exit_status);
  c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  c4:	c7 44 24 04 18 09 00 	movl   $0x918,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  db:	e8 50 04 00 00       	call   530 <printf>
  for (i = 0; i < 2; i++) {
  e0:	83 fb 02             	cmp    $0x2,%ebx
  e3:	75 bc                	jne    a1 <exitWait+0x21>
	  printf(2, "\nError using fork\n");
      exitS(-1);
    }
  }
  return 0;
}
  e5:	83 c4 20             	add    $0x20,%esp
  e8:	31 c0                	xor    %eax,%eax
  ea:	5b                   	pop    %ebx
  eb:	5e                   	pop    %esi
  ec:	5d                   	pop    %ebp
  ed:	c3                   	ret    
  ee:	66 90                	xchg   %ax,%ax
      if (i == 0)
  f0:	85 db                	test   %ebx,%ebx
  f2:	75 34                	jne    128 <exitWait+0xa8>
      printf(1, "\nThis is child with PID# %d and I will exit with status %d\n", getpid(), 0);
  f4:	e8 49 03 00 00       	call   442 <getpid>
  f9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 100:	00 
 101:	c7 44 24 04 dc 08 00 	movl   $0x8dc,0x4(%esp)
 108:	00 
 109:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 110:	89 44 24 08          	mov    %eax,0x8(%esp)
 114:	e8 17 04 00 00       	call   530 <printf>
      exitS(0);
 119:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 120:	e8 3d 03 00 00       	call   462 <exitS>
 125:	8d 76 00             	lea    0x0(%esi),%esi
	 printf(1, "\nThis is child with PID# %d and I will exit with status %d\n" ,getpid(), -1);
 128:	e8 15 03 00 00       	call   442 <getpid>
 12d:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
 134:	ff 
 135:	c7 44 24 04 dc 08 00 	movl   $0x8dc,0x4(%esp)
 13c:	00 
 13d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 144:	89 44 24 08          	mov    %eax,0x8(%esp)
 148:	e8 e3 03 00 00       	call   530 <printf>
      exitS(-1);
 14d:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 154:	e8 09 03 00 00       	call   462 <exitS>
	  printf(2, "\nError using fork\n");
 159:	c7 44 24 04 08 0a 00 	movl   $0xa08,0x4(%esp)
 160:	00 
 161:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 168:	e8 c3 03 00 00       	call   530 <printf>
      exitS(-1);
 16d:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 174:	e8 e9 02 00 00       	call   462 <exitS>
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000180 <waitPid>:

int waitPid(void){
 180:	55                   	push   %ebp
      printf(1, "\n This is the parent: Now waiting for child with PID# %d\n",pid_a[4]);
      //ret_pid = waitpid(pid_a[4], &exit_status, 0);
      printf(1, "\n This is the partent: Child# %d has exited with status %d\n",ret_pid, exit_status);
     */ 
      return 0;
  }
 181:	31 c0                	xor    %eax,%eax
int waitPid(void){
 183:	89 e5                	mov    %esp,%ebp
  }
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	89 f6                	mov    %esi,%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <CELEBW02>:

int CELEBW02(void){
 190:	55                   	push   %ebp
    }
  } while (retpid == 0);
  */
  return 0;
 
  }
 191:	31 c0                	xor    %eax,%eax
int CELEBW02(void){
 193:	89 e5                	mov    %esp,%ebp
  }
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    
 197:	66 90                	xchg   %ax,%ax
 199:	66 90                	xchg   %ax,%ax
 19b:	66 90                	xchg   %ax,%ax
 19d:	66 90                	xchg   %ax,%ax
 19f:	90                   	nop

000001a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1a9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1aa:	89 c2                	mov    %eax,%edx
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1b0:	83 c1 01             	add    $0x1,%ecx
 1b3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1b7:	83 c2 01             	add    $0x1,%edx
 1ba:	84 db                	test   %bl,%bl
 1bc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1bf:	75 ef                	jne    1b0 <strcpy+0x10>
    ;
  return os;
}
 1c1:	5b                   	pop    %ebx
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
 1c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 55 08             	mov    0x8(%ebp),%edx
 1d6:	53                   	push   %ebx
 1d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1da:	0f b6 02             	movzbl (%edx),%eax
 1dd:	84 c0                	test   %al,%al
 1df:	74 2d                	je     20e <strcmp+0x3e>
 1e1:	0f b6 19             	movzbl (%ecx),%ebx
 1e4:	38 d8                	cmp    %bl,%al
 1e6:	74 0e                	je     1f6 <strcmp+0x26>
 1e8:	eb 2b                	jmp    215 <strcmp+0x45>
 1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1f0:	38 c8                	cmp    %cl,%al
 1f2:	75 15                	jne    209 <strcmp+0x39>
    p++, q++;
 1f4:	89 d9                	mov    %ebx,%ecx
 1f6:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1f9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1fc:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1ff:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 203:	84 c0                	test   %al,%al
 205:	75 e9                	jne    1f0 <strcmp+0x20>
 207:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 209:	29 c8                	sub    %ecx,%eax
}
 20b:	5b                   	pop    %ebx
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    
 20e:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
 211:	31 c0                	xor    %eax,%eax
 213:	eb f4                	jmp    209 <strcmp+0x39>
 215:	0f b6 cb             	movzbl %bl,%ecx
 218:	eb ef                	jmp    209 <strcmp+0x39>
 21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000220 <strlen>:

uint
strlen(const char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 226:	80 39 00             	cmpb   $0x0,(%ecx)
 229:	74 12                	je     23d <strlen+0x1d>
 22b:	31 d2                	xor    %edx,%edx
 22d:	8d 76 00             	lea    0x0(%esi),%esi
 230:	83 c2 01             	add    $0x1,%edx
 233:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 237:	89 d0                	mov    %edx,%eax
 239:	75 f5                	jne    230 <strlen+0x10>
    ;
  return n;
}
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 23d:	31 c0                	xor    %eax,%eax
}
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret    
 241:	eb 0d                	jmp    250 <memset>
 243:	90                   	nop
 244:	90                   	nop
 245:	90                   	nop
 246:	90                   	nop
 247:	90                   	nop
 248:	90                   	nop
 249:	90                   	nop
 24a:	90                   	nop
 24b:	90                   	nop
 24c:	90                   	nop
 24d:	90                   	nop
 24e:	90                   	nop
 24f:	90                   	nop

00000250 <memset>:

void*
memset(void *dst, int c, uint n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	8b 55 08             	mov    0x8(%ebp),%edx
 256:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 257:	8b 4d 10             	mov    0x10(%ebp),%ecx
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 d7                	mov    %edx,%edi
 25f:	fc                   	cld    
 260:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 262:	89 d0                	mov    %edx,%eax
 264:	5f                   	pop    %edi
 265:	5d                   	pop    %ebp
 266:	c3                   	ret    
 267:	89 f6                	mov    %esi,%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	53                   	push   %ebx
 277:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 27a:	0f b6 18             	movzbl (%eax),%ebx
 27d:	84 db                	test   %bl,%bl
 27f:	74 1d                	je     29e <strchr+0x2e>
    if(*s == c)
 281:	38 d3                	cmp    %dl,%bl
 283:	89 d1                	mov    %edx,%ecx
 285:	75 0d                	jne    294 <strchr+0x24>
 287:	eb 17                	jmp    2a0 <strchr+0x30>
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 290:	38 ca                	cmp    %cl,%dl
 292:	74 0c                	je     2a0 <strchr+0x30>
  for(; *s; s++)
 294:	83 c0 01             	add    $0x1,%eax
 297:	0f b6 10             	movzbl (%eax),%edx
 29a:	84 d2                	test   %dl,%dl
 29c:	75 f2                	jne    290 <strchr+0x20>
      return (char*)s;
  return 0;
 29e:	31 c0                	xor    %eax,%eax
}
 2a0:	5b                   	pop    %ebx
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    
 2a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <gets>:

char*
gets(char *buf, int max)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b5:	31 f6                	xor    %esi,%esi
{
 2b7:	53                   	push   %ebx
 2b8:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 2bb:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 2be:	eb 31                	jmp    2f1 <gets+0x41>
    cc = read(0, &c, 1);
 2c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2c7:	00 
 2c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 2cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2d3:	e8 02 01 00 00       	call   3da <read>
    if(cc < 1)
 2d8:	85 c0                	test   %eax,%eax
 2da:	7e 1d                	jle    2f9 <gets+0x49>
      break;
    buf[i++] = c;
 2dc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 2e0:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 2e2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 2e5:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 2e7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2eb:	74 0c                	je     2f9 <gets+0x49>
 2ed:	3c 0a                	cmp    $0xa,%al
 2ef:	74 08                	je     2f9 <gets+0x49>
  for(i=0; i+1 < max; ){
 2f1:	8d 5e 01             	lea    0x1(%esi),%ebx
 2f4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2f7:	7c c7                	jl     2c0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 300:	83 c4 2c             	add    $0x2c,%esp
 303:	5b                   	pop    %ebx
 304:	5e                   	pop    %esi
 305:	5f                   	pop    %edi
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    
 308:	90                   	nop
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000310 <stat>:

int
stat(const char *n, struct stat *st)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	56                   	push   %esi
 314:	53                   	push   %ebx
 315:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 322:	00 
 323:	89 04 24             	mov    %eax,(%esp)
 326:	e8 d7 00 00 00       	call   402 <open>
  if(fd < 0)
 32b:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 32d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 32f:	78 27                	js     358 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 331:	8b 45 0c             	mov    0xc(%ebp),%eax
 334:	89 1c 24             	mov    %ebx,(%esp)
 337:	89 44 24 04          	mov    %eax,0x4(%esp)
 33b:	e8 da 00 00 00       	call   41a <fstat>
  close(fd);
 340:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 343:	89 c6                	mov    %eax,%esi
  close(fd);
 345:	e8 a0 00 00 00       	call   3ea <close>
  return r;
 34a:	89 f0                	mov    %esi,%eax
}
 34c:	83 c4 10             	add    $0x10,%esp
 34f:	5b                   	pop    %ebx
 350:	5e                   	pop    %esi
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	90                   	nop
 354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 35d:	eb ed                	jmp    34c <stat+0x3c>
 35f:	90                   	nop

00000360 <atoi>:

int
atoi(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	8b 4d 08             	mov    0x8(%ebp),%ecx
 366:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 367:	0f be 11             	movsbl (%ecx),%edx
 36a:	8d 42 d0             	lea    -0x30(%edx),%eax
 36d:	3c 09                	cmp    $0x9,%al
  n = 0;
 36f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 374:	77 17                	ja     38d <atoi+0x2d>
 376:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 378:	83 c1 01             	add    $0x1,%ecx
 37b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 37e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 382:	0f be 11             	movsbl (%ecx),%edx
 385:	8d 5a d0             	lea    -0x30(%edx),%ebx
 388:	80 fb 09             	cmp    $0x9,%bl
 38b:	76 eb                	jbe    378 <atoi+0x18>
  return n;
}
 38d:	5b                   	pop    %ebx
 38e:	5d                   	pop    %ebp
 38f:	c3                   	ret    

00000390 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 390:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 391:	31 d2                	xor    %edx,%edx
{
 393:	89 e5                	mov    %esp,%ebp
 395:	56                   	push   %esi
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	53                   	push   %ebx
 39a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 39d:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 3a0:	85 db                	test   %ebx,%ebx
 3a2:	7e 12                	jle    3b6 <memmove+0x26>
 3a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3b2:	39 da                	cmp    %ebx,%edx
 3b4:	75 f2                	jne    3a8 <memmove+0x18>
  return vdst;
}
 3b6:	5b                   	pop    %ebx
 3b7:	5e                   	pop    %esi
 3b8:	5d                   	pop    %ebp
 3b9:	c3                   	ret    

000003ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ba:	b8 01 00 00 00       	mov    $0x1,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <exit>:
SYSCALL(exit)
 3c2:	b8 02 00 00 00       	mov    $0x2,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <wait>:
SYSCALL(wait)
 3ca:	b8 03 00 00 00       	mov    $0x3,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <pipe>:
SYSCALL(pipe)
 3d2:	b8 04 00 00 00       	mov    $0x4,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <read>:
SYSCALL(read)
 3da:	b8 05 00 00 00       	mov    $0x5,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <write>:
SYSCALL(write)
 3e2:	b8 10 00 00 00       	mov    $0x10,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <close>:
SYSCALL(close)
 3ea:	b8 15 00 00 00       	mov    $0x15,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <kill>:
SYSCALL(kill)
 3f2:	b8 06 00 00 00       	mov    $0x6,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <exec>:
SYSCALL(exec)
 3fa:	b8 07 00 00 00       	mov    $0x7,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <open>:
SYSCALL(open)
 402:	b8 0f 00 00 00       	mov    $0xf,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <mknod>:
SYSCALL(mknod)
 40a:	b8 11 00 00 00       	mov    $0x11,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <unlink>:
SYSCALL(unlink)
 412:	b8 12 00 00 00       	mov    $0x12,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <fstat>:
SYSCALL(fstat)
 41a:	b8 08 00 00 00       	mov    $0x8,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <link>:
SYSCALL(link)
 422:	b8 13 00 00 00       	mov    $0x13,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <mkdir>:
SYSCALL(mkdir)
 42a:	b8 14 00 00 00       	mov    $0x14,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <chdir>:
SYSCALL(chdir)
 432:	b8 09 00 00 00       	mov    $0x9,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <dup>:
SYSCALL(dup)
 43a:	b8 0a 00 00 00       	mov    $0xa,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <getpid>:
SYSCALL(getpid)
 442:	b8 0b 00 00 00       	mov    $0xb,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <sbrk>:
SYSCALL(sbrk)
 44a:	b8 0c 00 00 00       	mov    $0xc,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <sleep>:
SYSCALL(sleep)
 452:	b8 0d 00 00 00       	mov    $0xd,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <uptime>:
SYSCALL(uptime)
 45a:	b8 0e 00 00 00       	mov    $0xe,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <exitS>:
SYSCALL(exitS)
 462:	b8 16 00 00 00       	mov    $0x16,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <waitS>:
SYSCALL(waitS)
 46a:	b8 17 00 00 00       	mov    $0x17,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <waitpid>:
SYSCALL(waitpid)
 472:	b8 18 00 00 00       	mov    $0x18,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <setpriority>:
SYSCALL(setpriority)
 47a:	b8 19 00 00 00       	mov    $0x19,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    
 482:	66 90                	xchg   %ax,%ax
 484:	66 90                	xchg   %ax,%ax
 486:	66 90                	xchg   %ax,%ax
 488:	66 90                	xchg   %ax,%ax
 48a:	66 90                	xchg   %ax,%ax
 48c:	66 90                	xchg   %ax,%ax
 48e:	66 90                	xchg   %ax,%ax

00000490 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	89 c6                	mov    %eax,%esi
 497:	53                   	push   %ebx
 498:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 49b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 49e:	85 db                	test   %ebx,%ebx
 4a0:	74 09                	je     4ab <printint+0x1b>
 4a2:	89 d0                	mov    %edx,%eax
 4a4:	c1 e8 1f             	shr    $0x1f,%eax
 4a7:	84 c0                	test   %al,%al
 4a9:	75 75                	jne    520 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ab:	89 d0                	mov    %edx,%eax
  neg = 0;
 4ad:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4b4:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 4b7:	31 ff                	xor    %edi,%edi
 4b9:	89 ce                	mov    %ecx,%esi
 4bb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 4be:	eb 02                	jmp    4c2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 4c0:	89 cf                	mov    %ecx,%edi
 4c2:	31 d2                	xor    %edx,%edx
 4c4:	f7 f6                	div    %esi
 4c6:	8d 4f 01             	lea    0x1(%edi),%ecx
 4c9:	0f b6 92 22 0a 00 00 	movzbl 0xa22(%edx),%edx
  }while((x /= base) != 0);
 4d0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 4d2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 4d5:	75 e9                	jne    4c0 <printint+0x30>
  if(neg)
 4d7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 4da:	89 c8                	mov    %ecx,%eax
 4dc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 4df:	85 d2                	test   %edx,%edx
 4e1:	74 08                	je     4eb <printint+0x5b>
    buf[i++] = '-';
 4e3:	8d 4f 02             	lea    0x2(%edi),%ecx
 4e6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 4eb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 4ee:	66 90                	xchg   %ax,%ax
 4f0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 4f5:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 4f8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ff:	00 
 500:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 504:	89 34 24             	mov    %esi,(%esp)
 507:	88 45 d7             	mov    %al,-0x29(%ebp)
 50a:	e8 d3 fe ff ff       	call   3e2 <write>
  while(--i >= 0)
 50f:	83 ff ff             	cmp    $0xffffffff,%edi
 512:	75 dc                	jne    4f0 <printint+0x60>
    putc(fd, buf[i]);
}
 514:	83 c4 4c             	add    $0x4c,%esp
 517:	5b                   	pop    %ebx
 518:	5e                   	pop    %esi
 519:	5f                   	pop    %edi
 51a:	5d                   	pop    %ebp
 51b:	c3                   	ret    
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 520:	89 d0                	mov    %edx,%eax
 522:	f7 d8                	neg    %eax
    neg = 1;
 524:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 52b:	eb 87                	jmp    4b4 <printint+0x24>
 52d:	8d 76 00             	lea    0x0(%esi),%esi

00000530 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 534:	31 ff                	xor    %edi,%edi
{
 536:	56                   	push   %esi
 537:	53                   	push   %ebx
 538:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 53b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 53e:	8d 45 10             	lea    0x10(%ebp),%eax
{
 541:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 544:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 547:	0f b6 13             	movzbl (%ebx),%edx
 54a:	83 c3 01             	add    $0x1,%ebx
 54d:	84 d2                	test   %dl,%dl
 54f:	75 39                	jne    58a <printf+0x5a>
 551:	e9 c2 00 00 00       	jmp    618 <printf+0xe8>
 556:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 558:	83 fa 25             	cmp    $0x25,%edx
 55b:	0f 84 bf 00 00 00    	je     620 <printf+0xf0>
  write(fd, &c, 1);
 561:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 564:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 56b:	00 
 56c:	89 44 24 04          	mov    %eax,0x4(%esp)
 570:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 573:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 576:	e8 67 fe ff ff       	call   3e2 <write>
 57b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 57e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 582:	84 d2                	test   %dl,%dl
 584:	0f 84 8e 00 00 00    	je     618 <printf+0xe8>
    if(state == 0){
 58a:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 58c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 58f:	74 c7                	je     558 <printf+0x28>
      }
    } else if(state == '%'){
 591:	83 ff 25             	cmp    $0x25,%edi
 594:	75 e5                	jne    57b <printf+0x4b>
      if(c == 'd'){
 596:	83 fa 64             	cmp    $0x64,%edx
 599:	0f 84 31 01 00 00    	je     6d0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 59f:	25 f7 00 00 00       	and    $0xf7,%eax
 5a4:	83 f8 70             	cmp    $0x70,%eax
 5a7:	0f 84 83 00 00 00    	je     630 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5ad:	83 fa 73             	cmp    $0x73,%edx
 5b0:	0f 84 a2 00 00 00    	je     658 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b6:	83 fa 63             	cmp    $0x63,%edx
 5b9:	0f 84 35 01 00 00    	je     6f4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5bf:	83 fa 25             	cmp    $0x25,%edx
 5c2:	0f 84 e0 00 00 00    	je     6a8 <printf+0x178>
  write(fd, &c, 1);
 5c8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5cb:	83 c3 01             	add    $0x1,%ebx
 5ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5d6:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 5d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dc:	89 34 24             	mov    %esi,(%esp)
 5df:	89 55 d0             	mov    %edx,-0x30(%ebp)
 5e2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 5e6:	e8 f7 fd ff ff       	call   3e2 <write>
        putc(fd, c);
 5eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 5ee:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f8:	00 
 5f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fd:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 600:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 603:	e8 da fd ff ff       	call   3e2 <write>
  for(i = 0; fmt[i]; i++){
 608:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 60c:	84 d2                	test   %dl,%dl
 60e:	0f 85 76 ff ff ff    	jne    58a <printf+0x5a>
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 618:	83 c4 3c             	add    $0x3c,%esp
 61b:	5b                   	pop    %ebx
 61c:	5e                   	pop    %esi
 61d:	5f                   	pop    %edi
 61e:	5d                   	pop    %ebp
 61f:	c3                   	ret    
        state = '%';
 620:	bf 25 00 00 00       	mov    $0x25,%edi
 625:	e9 51 ff ff ff       	jmp    57b <printf+0x4b>
 62a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 630:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 633:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 638:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 63a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 641:	8b 10                	mov    (%eax),%edx
 643:	89 f0                	mov    %esi,%eax
 645:	e8 46 fe ff ff       	call   490 <printint>
        ap++;
 64a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 64e:	e9 28 ff ff ff       	jmp    57b <printf+0x4b>
 653:	90                   	nop
 654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 65b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 65f:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 661:	b8 1b 0a 00 00       	mov    $0xa1b,%eax
 666:	85 ff                	test   %edi,%edi
 668:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 66b:	0f b6 07             	movzbl (%edi),%eax
 66e:	84 c0                	test   %al,%al
 670:	74 2a                	je     69c <printf+0x16c>
 672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 678:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 67b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 67e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 681:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 688:	00 
 689:	89 44 24 04          	mov    %eax,0x4(%esp)
 68d:	89 34 24             	mov    %esi,(%esp)
 690:	e8 4d fd ff ff       	call   3e2 <write>
        while(*s != 0){
 695:	0f b6 07             	movzbl (%edi),%eax
 698:	84 c0                	test   %al,%al
 69a:	75 dc                	jne    678 <printf+0x148>
      state = 0;
 69c:	31 ff                	xor    %edi,%edi
 69e:	e9 d8 fe ff ff       	jmp    57b <printf+0x4b>
 6a3:	90                   	nop
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 6a8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 6ab:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6ad:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b4:	00 
 6b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b9:	89 34 24             	mov    %esi,(%esp)
 6bc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 6c0:	e8 1d fd ff ff       	call   3e2 <write>
 6c5:	e9 b1 fe ff ff       	jmp    57b <printf+0x4b>
 6ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 6d8:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 6db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	89 f0                	mov    %esi,%eax
 6e6:	e8 a5 fd ff ff       	call   490 <printint>
        ap++;
 6eb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6ef:	e9 87 fe ff ff       	jmp    57b <printf+0x4b>
        putc(fd, *ap);
 6f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 6f7:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 6f9:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 6fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 702:	00 
 703:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 706:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 709:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 70c:	89 44 24 04          	mov    %eax,0x4(%esp)
 710:	e8 cd fc ff ff       	call   3e2 <write>
        ap++;
 715:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 719:	e9 5d fe ff ff       	jmp    57b <printf+0x4b>
 71e:	66 90                	xchg   %ax,%ax

00000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 04 0d 00 00       	mov    0xd04,%eax
{
 726:	89 e5                	mov    %esp,%ebp
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	53                   	push   %ebx
 72b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72e:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 730:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 733:	39 d0                	cmp    %edx,%eax
 735:	72 11                	jb     748 <free+0x28>
 737:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 738:	39 c8                	cmp    %ecx,%eax
 73a:	72 04                	jb     740 <free+0x20>
 73c:	39 ca                	cmp    %ecx,%edx
 73e:	72 10                	jb     750 <free+0x30>
 740:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 742:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 746:	73 f0                	jae    738 <free+0x18>
 748:	39 ca                	cmp    %ecx,%edx
 74a:	72 04                	jb     750 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74c:	39 c8                	cmp    %ecx,%eax
 74e:	72 f0                	jb     740 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 750:	8b 73 fc             	mov    -0x4(%ebx),%esi
 753:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 756:	39 cf                	cmp    %ecx,%edi
 758:	74 1e                	je     778 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 75a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 75d:	8b 48 04             	mov    0x4(%eax),%ecx
 760:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 763:	39 f2                	cmp    %esi,%edx
 765:	74 28                	je     78f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 767:	89 10                	mov    %edx,(%eax)
  freep = p;
 769:	a3 04 0d 00 00       	mov    %eax,0xd04
}
 76e:	5b                   	pop    %ebx
 76f:	5e                   	pop    %esi
 770:	5f                   	pop    %edi
 771:	5d                   	pop    %ebp
 772:	c3                   	ret    
 773:	90                   	nop
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 778:	03 71 04             	add    0x4(%ecx),%esi
 77b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 77e:	8b 08                	mov    (%eax),%ecx
 780:	8b 09                	mov    (%ecx),%ecx
 782:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 785:	8b 48 04             	mov    0x4(%eax),%ecx
 788:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 78b:	39 f2                	cmp    %esi,%edx
 78d:	75 d8                	jne    767 <free+0x47>
    p->s.size += bp->s.size;
 78f:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 792:	a3 04 0d 00 00       	mov    %eax,0xd04
    p->s.size += bp->s.size;
 797:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 79d:	89 10                	mov    %edx,(%eax)
}
 79f:	5b                   	pop    %ebx
 7a0:	5e                   	pop    %esi
 7a1:	5f                   	pop    %edi
 7a2:	5d                   	pop    %ebp
 7a3:	c3                   	ret    
 7a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7bc:	8b 1d 04 0d 00 00    	mov    0xd04,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c2:	8d 48 07             	lea    0x7(%eax),%ecx
 7c5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 7c8:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ca:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 7cd:	0f 84 9b 00 00 00    	je     86e <malloc+0xbe>
 7d3:	8b 13                	mov    (%ebx),%edx
 7d5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7d8:	39 fe                	cmp    %edi,%esi
 7da:	76 64                	jbe    840 <malloc+0x90>
 7dc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 7e3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 7e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7eb:	eb 0e                	jmp    7fb <malloc+0x4b>
 7ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7f2:	8b 78 04             	mov    0x4(%eax),%edi
 7f5:	39 fe                	cmp    %edi,%esi
 7f7:	76 4f                	jbe    848 <malloc+0x98>
 7f9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fb:	3b 15 04 0d 00 00    	cmp    0xd04,%edx
 801:	75 ed                	jne    7f0 <malloc+0x40>
  if(nu < 4096)
 803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 806:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 80c:	bf 00 10 00 00       	mov    $0x1000,%edi
 811:	0f 43 fe             	cmovae %esi,%edi
 814:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 817:	89 04 24             	mov    %eax,(%esp)
 81a:	e8 2b fc ff ff       	call   44a <sbrk>
  if(p == (char*)-1)
 81f:	83 f8 ff             	cmp    $0xffffffff,%eax
 822:	74 18                	je     83c <malloc+0x8c>
  hp->s.size = nu;
 824:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 827:	83 c0 08             	add    $0x8,%eax
 82a:	89 04 24             	mov    %eax,(%esp)
 82d:	e8 ee fe ff ff       	call   720 <free>
  return freep;
 832:	8b 15 04 0d 00 00    	mov    0xd04,%edx
      if((p = morecore(nunits)) == 0)
 838:	85 d2                	test   %edx,%edx
 83a:	75 b4                	jne    7f0 <malloc+0x40>
        return 0;
 83c:	31 c0                	xor    %eax,%eax
 83e:	eb 20                	jmp    860 <malloc+0xb0>
    if(p->s.size >= nunits){
 840:	89 d0                	mov    %edx,%eax
 842:	89 da                	mov    %ebx,%edx
 844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 848:	39 fe                	cmp    %edi,%esi
 84a:	74 1c                	je     868 <malloc+0xb8>
        p->s.size -= nunits;
 84c:	29 f7                	sub    %esi,%edi
 84e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 851:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 854:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 857:	89 15 04 0d 00 00    	mov    %edx,0xd04
      return (void*)(p + 1);
 85d:	83 c0 08             	add    $0x8,%eax
  }
}
 860:	83 c4 1c             	add    $0x1c,%esp
 863:	5b                   	pop    %ebx
 864:	5e                   	pop    %esi
 865:	5f                   	pop    %edi
 866:	5d                   	pop    %ebp
 867:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 868:	8b 08                	mov    (%eax),%ecx
 86a:	89 0a                	mov    %ecx,(%edx)
 86c:	eb e9                	jmp    857 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 86e:	c7 05 04 0d 00 00 08 	movl   $0xd08,0xd04
 875:	0d 00 00 
    base.s.size = 0;
 878:	ba 08 0d 00 00       	mov    $0xd08,%edx
    base.s.ptr = freep = prevp = &base;
 87d:	c7 05 08 0d 00 00 08 	movl   $0xd08,0xd08
 884:	0d 00 00 
    base.s.size = 0;
 887:	c7 05 0c 0d 00 00 00 	movl   $0x0,0xd0c
 88e:	00 00 00 
 891:	e9 46 ff ff ff       	jmp    7dc <malloc+0x2c>
