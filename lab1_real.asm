
_lab1_real:     file format elf32-i386


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
   d:	c7 44 24 04 10 0e 00 	movl   $0xe10,0x4(%esp)
  14:	00 
  15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1c:	e8 6f 08 00 00       	call   890 <printf>
  
  if (atoi(argv[1]) == 1)
  21:	8b 43 04             	mov    0x4(%ebx),%eax
  24:	89 04 24             	mov    %eax,(%esp)
  27:	e8 94 06 00 00       	call   6c0 <atoi>
  2c:	83 f8 01             	cmp    $0x1,%eax
  2f:	74 40                	je     71 <main+0x71>
	exitWait();
  else if (atoi(argv[1]) == 2)
  31:	8b 43 04             	mov    0x4(%ebx),%eax
  34:	89 04 24             	mov    %eax,(%esp)
  37:	e8 84 06 00 00       	call   6c0 <atoi>
  3c:	83 f8 02             	cmp    $0x2,%eax
  3f:	74 37                	je     78 <main+0x78>
	waitPid();
  else if (atoi(argv[1]) == 3)
  41:	8b 43 04             	mov    0x4(%ebx),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 74 06 00 00       	call   6c0 <atoi>
  4c:	83 f8 03             	cmp    $0x3,%eax
  4f:	74 36                	je     87 <main+0x87>
	CELEBW02();
  else 
   printf(1, "\ntype \"lab1 1\" to test exit and wait, \"lab1 2\" to test waitpid and \"lab1 3\" to test the extra credit WNOHANG option \n");
  51:	c7 44 24 04 44 0e 00 	movl   $0xe44,0x4(%esp)
  58:	00 
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 2b 08 00 00       	call   890 <printf>
  
    // End of test
	 exitS(0);
  65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6c:	e8 51 07 00 00       	call   7c2 <exitS>
	exitWait();
  71:	e8 2a 00 00 00       	call   a0 <exitWait>
  76:	eb ed                	jmp    65 <main+0x65>
  78:	90                   	nop
  79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	waitPid();
  80:	e8 1b 01 00 00       	call   1a0 <waitPid>
  85:	eb de                	jmp    65 <main+0x65>
	CELEBW02();
  87:	e8 84 03 00 00       	call   410 <CELEBW02>
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  90:	eb d3                	jmp    65 <main+0x65>
  92:	66 90                	xchg   %ax,%ax
  94:	66 90                	xchg   %ax,%ax
  96:	66 90                	xchg   %ax,%ax
  98:	66 90                	xchg   %ax,%ax
  9a:	66 90                	xchg   %ax,%ax
  9c:	66 90                	xchg   %ax,%ax
  9e:	66 90                	xchg   %ax,%ax

000000a0 <exitWait>:
	 return 0;
 }
  
int exitWait(void) {
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	56                   	push   %esi
  a4:	53                   	push   %ebx
       int i;
  // use this part to test exit(int status) and wait(int* status)
 
  printf(1, "\n  Parts a & b) testing exit(int status) and wait(int* status):\n");

  for (i = 0; i < 2; i++) {
  a5:	31 db                	xor    %ebx,%ebx
int exitWait(void) {
  a7:	83 ec 20             	sub    $0x20,%esp
  printf(1, "\n  Parts a & b) testing exit(int status) and wait(int* status):\n");
  aa:	c7 44 24 04 f8 0b 00 	movl   $0xbf8,0x4(%esp)
  b1:	00 
      {
	 printf(1, "\nThis is child with PID# %d and I will exit with status %d\n" ,getpid(), -1);
      exitS(-1);
  } 
    } else if (pid > 0) { // only the parent executes this code
      ret_pid = waitS(&exit_status);
  b2:	8d 75 f4             	lea    -0xc(%ebp),%esi
  printf(1, "\n  Parts a & b) testing exit(int status) and wait(int* status):\n");
  b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  bc:	e8 cf 07 00 00       	call   890 <printf>
    pid = fork();
  c1:	e8 54 06 00 00       	call   71a <fork>
    if (pid == 0) { // only the child executed this code
  c6:	83 f8 00             	cmp    $0x0,%eax
  c9:	74 45                	je     110 <exitWait+0x70>
  cb:	90                   	nop
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if (pid > 0) { // only the parent executes this code
  d0:	0f 8e a3 00 00 00    	jle    179 <exitWait+0xd9>
      ret_pid = waitS(&exit_status);
  d6:	89 34 24             	mov    %esi,(%esp)
  for (i = 0; i < 2; i++) {
  d9:	83 c3 01             	add    $0x1,%ebx
      ret_pid = waitS(&exit_status);
  dc:	e8 e9 06 00 00       	call   7ca <waitS>
      //exit_status = 0;
      printf(1, "\n This is the parent: child with PID# %d has exited with status %d\n", ret_pid, exit_status);
  e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e4:	c7 44 24 04 78 0c 00 	movl   $0xc78,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  fb:	e8 90 07 00 00       	call   890 <printf>
  for (i = 0; i < 2; i++) {
 100:	83 fb 02             	cmp    $0x2,%ebx
 103:	75 bc                	jne    c1 <exitWait+0x21>
	  printf(2, "\nError using fork\n");
      exitS(-1);
    }
  }
  return 0;
}
 105:	83 c4 20             	add    $0x20,%esp
 108:	31 c0                	xor    %eax,%eax
 10a:	5b                   	pop    %ebx
 10b:	5e                   	pop    %esi
 10c:	5d                   	pop    %ebp
 10d:	c3                   	ret    
 10e:	66 90                	xchg   %ax,%ax
      if (i == 0)
 110:	85 db                	test   %ebx,%ebx
 112:	75 34                	jne    148 <exitWait+0xa8>
      printf(1, "\nThis is child with PID# %d and I will exit with status %d\n", getpid(), 0);
 114:	e8 89 06 00 00       	call   7a2 <getpid>
 119:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 120:	00 
 121:	c7 44 24 04 3c 0c 00 	movl   $0xc3c,0x4(%esp)
 128:	00 
 129:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 130:	89 44 24 08          	mov    %eax,0x8(%esp)
 134:	e8 57 07 00 00       	call   890 <printf>
      exitS(0);
 139:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 140:	e8 7d 06 00 00       	call   7c2 <exitS>
 145:	8d 76 00             	lea    0x0(%esi),%esi
	 printf(1, "\nThis is child with PID# %d and I will exit with status %d\n" ,getpid(), -1);
 148:	e8 55 06 00 00       	call   7a2 <getpid>
 14d:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
 154:	ff 
 155:	c7 44 24 04 3c 0c 00 	movl   $0xc3c,0x4(%esp)
 15c:	00 
 15d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 164:	89 44 24 08          	mov    %eax,0x8(%esp)
 168:	e8 23 07 00 00       	call   890 <printf>
      exitS(-1);
 16d:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 174:	e8 49 06 00 00       	call   7c2 <exitS>
	  printf(2, "\nError using fork\n");
 179:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 180:	00 
 181:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 188:	e8 03 07 00 00       	call   890 <printf>
      exitS(-1);
 18d:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 194:	e8 29 06 00 00       	call   7c2 <exitS>
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001a0 <waitPid>:

int waitPid(void){
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
 1a5:	83 ec 30             	sub    $0x30,%esp
  int ret_pid, exit_status;
  int i;
  int pid_a[5]={0, 0, 0, 0, 0};
 // use this part to test wait(int pid, int* status, int options)

 printf(1, "\n  Part c) testing waitpid(int pid, int* status, int options):\n");
 1a8:	c7 44 24 04 bc 0c 00 	movl   $0xcbc,0x4(%esp)
 1af:	00 
 1b0:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
 1b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ba:	8d 75 f8             	lea    -0x8(%ebp),%esi
  int pid_a[5]={0, 0, 0, 0, 0};
 1bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 1cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 1d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 printf(1, "\n  Part c) testing waitpid(int pid, int* status, int options):\n");
 1e0:	e8 ab 06 00 00       	call   890 <printf>

	for (i = 0; i <5; i++) {
		pid_a[i] = fork();
 1e5:	e8 30 05 00 00       	call   71a <fork>
		if (pid_a[i] == 0) { // only the child executed this code
 1ea:	85 c0                	test   %eax,%eax
		pid_a[i] = fork();
 1ec:	89 03                	mov    %eax,(%ebx)
		if (pid_a[i] == 0) { // only the child executed this code
 1ee:	0f 84 d5 01 00 00    	je     3c9 <waitPid+0x229>
 1f4:	83 c3 04             	add    $0x4,%ebx
	for (i = 0; i <5; i++) {
 1f7:	39 f3                	cmp    %esi,%ebx
 1f9:	75 ea                	jne    1e5 <waitPid+0x45>
			printf(1, "\n The is child with PID# %d and I will exit with status %d\n", getpid(), getpid() + 4);
			exitS(getpid() + 4);
		}
	}
       
      sleep(5);
 1fb:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
      printf(1, "\n This is the parent: Now waiting for child with PID# %d\n",pid_a[3]);
      ret_pid = waitpid(pid_a[3], &exit_status, 0);
 202:	8d 5d e0             	lea    -0x20(%ebp),%ebx
      sleep(5);
 205:	e8 a8 05 00 00       	call   7b2 <sleep>
      printf(1, "\n This is the parent: Now waiting for child with PID# %d\n",pid_a[3]);
 20a:	8b 75 f0             	mov    -0x10(%ebp),%esi
 20d:	c7 44 24 04 38 0d 00 	movl   $0xd38,0x4(%esp)
 214:	00 
 215:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 21c:	89 74 24 08          	mov    %esi,0x8(%esp)
 220:	e8 6b 06 00 00       	call   890 <printf>
      ret_pid = waitpid(pid_a[3], &exit_status, 0);
 225:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 229:	89 34 24             	mov    %esi,(%esp)
 22c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 233:	00 
 234:	e8 99 05 00 00       	call   7d2 <waitpid>
      printf(1, "\n This is the partent: Child# %d has exited with status %d\n",ret_pid, exit_status);
 239:	8b 55 e0             	mov    -0x20(%ebp),%edx
 23c:	c7 44 24 04 74 0d 00 	movl   $0xd74,0x4(%esp)
 243:	00 
 244:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 24b:	89 54 24 0c          	mov    %edx,0xc(%esp)
 24f:	89 44 24 08          	mov    %eax,0x8(%esp)
 253:	e8 38 06 00 00       	call   890 <printf>
      sleep(5);
 258:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 25f:	e8 4e 05 00 00       	call   7b2 <sleep>
      printf(1, "\n This is the parent: Now waiting for child with PID# %d\n",pid_a[1]);
 264:	8b 75 e8             	mov    -0x18(%ebp),%esi
 267:	c7 44 24 04 38 0d 00 	movl   $0xd38,0x4(%esp)
 26e:	00 
 26f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 276:	89 74 24 08          	mov    %esi,0x8(%esp)
 27a:	e8 11 06 00 00       	call   890 <printf>
      ret_pid = waitpid(pid_a[1], &exit_status, 0);
 27f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 283:	89 34 24             	mov    %esi,(%esp)
 286:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 28d:	00 
 28e:	e8 3f 05 00 00       	call   7d2 <waitpid>
      printf(1, "\n This is the partent: Child# %d has exited with status %d\n",ret_pid, exit_status);
 293:	8b 55 e0             	mov    -0x20(%ebp),%edx
 296:	c7 44 24 04 74 0d 00 	movl   $0xd74,0x4(%esp)
 29d:	00 
 29e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
 2a9:	89 44 24 08          	mov    %eax,0x8(%esp)
 2ad:	e8 de 05 00 00       	call   890 <printf>
      sleep(5);
 2b2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2b9:	e8 f4 04 00 00       	call   7b2 <sleep>
      printf(1, "\n This is the parent: Now waiting for child with PID# %d\n",pid_a[2]);
 2be:	8b 75 ec             	mov    -0x14(%ebp),%esi
 2c1:	c7 44 24 04 38 0d 00 	movl   $0xd38,0x4(%esp)
 2c8:	00 
 2c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2d0:	89 74 24 08          	mov    %esi,0x8(%esp)
 2d4:	e8 b7 05 00 00       	call   890 <printf>
      ret_pid = waitpid(pid_a[2], &exit_status, 0);
 2d9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 2dd:	89 34 24             	mov    %esi,(%esp)
 2e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 2e7:	00 
 2e8:	e8 e5 04 00 00       	call   7d2 <waitpid>
      printf(1, "\n This is the partent: Child# %d has exited with status %d\n",ret_pid, exit_status);
 2ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
 2f0:	c7 44 24 04 74 0d 00 	movl   $0xd74,0x4(%esp)
 2f7:	00 
 2f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2ff:	89 54 24 0c          	mov    %edx,0xc(%esp)
 303:	89 44 24 08          	mov    %eax,0x8(%esp)
 307:	e8 84 05 00 00       	call   890 <printf>
      sleep(5);
 30c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 313:	e8 9a 04 00 00       	call   7b2 <sleep>
      printf(1, "\n This is the parent: Now waiting for child with PID# %d\n",pid_a[0]);
 318:	8b 75 e4             	mov    -0x1c(%ebp),%esi
 31b:	c7 44 24 04 38 0d 00 	movl   $0xd38,0x4(%esp)
 322:	00 
 323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 32a:	89 74 24 08          	mov    %esi,0x8(%esp)
 32e:	e8 5d 05 00 00       	call   890 <printf>
      ret_pid = waitpid(pid_a[0], &exit_status, 0);
 333:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 337:	89 34 24             	mov    %esi,(%esp)
 33a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 341:	00 
 342:	e8 8b 04 00 00       	call   7d2 <waitpid>
      printf(1, "\n This is the partent: Child# %d has exited with status %d\n",ret_pid, exit_status);
 347:	8b 55 e0             	mov    -0x20(%ebp),%edx
 34a:	c7 44 24 04 74 0d 00 	movl   $0xd74,0x4(%esp)
 351:	00 
 352:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 359:	89 54 24 0c          	mov    %edx,0xc(%esp)
 35d:	89 44 24 08          	mov    %eax,0x8(%esp)
 361:	e8 2a 05 00 00       	call   890 <printf>
      sleep(5);
 366:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 36d:	e8 40 04 00 00       	call   7b2 <sleep>
      printf(1, "\n This is the parent: Now waiting for child with PID# %d\n",pid_a[4]);
 372:	8b 75 f4             	mov    -0xc(%ebp),%esi
 375:	c7 44 24 04 38 0d 00 	movl   $0xd38,0x4(%esp)
 37c:	00 
 37d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 384:	89 74 24 08          	mov    %esi,0x8(%esp)
 388:	e8 03 05 00 00       	call   890 <printf>
      ret_pid = waitpid(pid_a[4], &exit_status, 0);
 38d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 391:	89 34 24             	mov    %esi,(%esp)
 394:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 39b:	00 
 39c:	e8 31 04 00 00       	call   7d2 <waitpid>
      printf(1, "\n This is the partent: Child# %d has exited with status %d\n",ret_pid, exit_status);
 3a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
 3a4:	c7 44 24 04 74 0d 00 	movl   $0xd74,0x4(%esp)
 3ab:	00 
 3ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
 3b7:	89 44 24 08          	mov    %eax,0x8(%esp)
 3bb:	e8 d0 04 00 00       	call   890 <printf>
      
      return 0;
  }
 3c0:	83 c4 30             	add    $0x30,%esp
 3c3:	31 c0                	xor    %eax,%eax
 3c5:	5b                   	pop    %ebx
 3c6:	5e                   	pop    %esi
 3c7:	5d                   	pop    %ebp
 3c8:	c3                   	ret    
			printf(1, "\n The is child with PID# %d and I will exit with status %d\n", getpid(), getpid() + 4);
 3c9:	e8 d4 03 00 00       	call   7a2 <getpid>
 3ce:	89 c3                	mov    %eax,%ebx
 3d0:	e8 cd 03 00 00       	call   7a2 <getpid>
 3d5:	83 c3 04             	add    $0x4,%ebx
 3d8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 3dc:	c7 44 24 04 fc 0c 00 	movl   $0xcfc,0x4(%esp)
 3e3:	00 
 3e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3eb:	89 44 24 08          	mov    %eax,0x8(%esp)
 3ef:	e8 9c 04 00 00       	call   890 <printf>
			exitS(getpid() + 4);
 3f4:	e8 a9 03 00 00       	call   7a2 <getpid>
 3f9:	83 c0 04             	add    $0x4,%eax
 3fc:	89 04 24             	mov    %eax,(%esp)
 3ff:	e8 be 03 00 00       	call   7c2 <exitS>
 404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 40a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000410 <CELEBW02>:

int CELEBW02(void){
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
 415:	83 ec 20             	sub    $0x20,%esp
	
 printf(1, "\n  Part e) the waitpid option WNOHANG, test program CELEBW02 \n");
 418:	c7 44 24 04 b0 0d 00 	movl   $0xdb0,0x4(%esp)
 41f:	00 
 420:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 427:	e8 64 04 00 00       	call   890 <printf>

  int pid, retpid;
  int status;

  if ((pid = fork()) < 0)
 42c:	e8 e9 02 00 00       	call   71a <fork>
 431:	85 c0                	test   %eax,%eax
 433:	89 c3                	mov    %eax,%ebx
 435:	0f 88 92 00 00 00    	js     4cd <CELEBW02+0xbd>
    printf(2, "fork() error");
  else if (pid == 0) {
 43b:	0f 84 a2 00 00 00    	je     4e3 <CELEBW02+0xd3>
 441:	8d 75 f4             	lea    -0xc(%ebp),%esi
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(5);
    exitS(1);
  }
  else do {
    if ((retpid = waitpid(pid, &status, WNOHANG)) == -1)
 448:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 44f:	00 
 450:	89 74 24 04          	mov    %esi,0x4(%esp)
 454:	89 1c 24             	mov    %ebx,(%esp)
 457:	e8 76 03 00 00       	call   7d2 <waitpid>
 45c:	83 f8 ff             	cmp    $0xffffffff,%eax
 45f:	74 4f                	je     4b0 <CELEBW02+0xa0>
      printf(2, "wait() error");
    else if (retpid == 0) {
 461:	85 c0                	test   %eax,%eax
 463:	75 23                	jne    488 <CELEBW02+0x78>
      printf(1, "child is still running \n");
 465:	c7 44 24 04 e9 0e 00 	movl   $0xee9,0x4(%esp)
 46c:	00 
 46d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 474:	e8 17 04 00 00       	call   890 <printf>
      sleep(1);
 479:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 480:	e8 2d 03 00 00       	call   7b2 <sleep>
 485:	eb c1                	jmp    448 <CELEBW02+0x38>
 487:	90                   	nop
    }
    else {
        printf(1, "child exited with status of %d\n", status);
 488:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48b:	c7 44 24 04 f0 0d 00 	movl   $0xdf0,0x4(%esp)
 492:	00 
 493:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 49a:	89 44 24 08          	mov    %eax,0x8(%esp)
 49e:	e8 ed 03 00 00       	call   890 <printf>
    }
  } while (retpid == 0);
  
  return 0;
  
  }
 4a3:	83 c4 20             	add    $0x20,%esp
 4a6:	31 c0                	xor    %eax,%eax
 4a8:	5b                   	pop    %ebx
 4a9:	5e                   	pop    %esi
 4aa:	5d                   	pop    %ebp
 4ab:	c3                   	ret    
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(2, "wait() error");
 4b0:	c7 44 24 04 dc 0e 00 	movl   $0xedc,0x4(%esp)
 4b7:	00 
 4b8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 4bf:	e8 cc 03 00 00       	call   890 <printf>
  }
 4c4:	83 c4 20             	add    $0x20,%esp
 4c7:	31 c0                	xor    %eax,%eax
 4c9:	5b                   	pop    %ebx
 4ca:	5e                   	pop    %esi
 4cb:	5d                   	pop    %ebp
 4cc:	c3                   	ret    
    printf(2, "fork() error");
 4cd:	c7 44 24 04 cf 0e 00 	movl   $0xecf,0x4(%esp)
 4d4:	00 
 4d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 4dc:	e8 af 03 00 00       	call   890 <printf>
 4e1:	eb c0                	jmp    4a3 <CELEBW02+0x93>
    sleep(5);
 4e3:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 4ea:	e8 c3 02 00 00       	call   7b2 <sleep>
    exitS(1);
 4ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4f6:	e8 c7 02 00 00       	call   7c2 <exitS>
 4fb:	66 90                	xchg   %ax,%ax
 4fd:	66 90                	xchg   %ax,%ax
 4ff:	90                   	nop

00000500 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 509:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 50a:	89 c2                	mov    %eax,%edx
 50c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 510:	83 c1 01             	add    $0x1,%ecx
 513:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 517:	83 c2 01             	add    $0x1,%edx
 51a:	84 db                	test   %bl,%bl
 51c:	88 5a ff             	mov    %bl,-0x1(%edx)
 51f:	75 ef                	jne    510 <strcpy+0x10>
    ;
  return os;
}
 521:	5b                   	pop    %ebx
 522:	5d                   	pop    %ebp
 523:	c3                   	ret    
 524:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 52a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000530 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	8b 55 08             	mov    0x8(%ebp),%edx
 536:	53                   	push   %ebx
 537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 53a:	0f b6 02             	movzbl (%edx),%eax
 53d:	84 c0                	test   %al,%al
 53f:	74 2d                	je     56e <strcmp+0x3e>
 541:	0f b6 19             	movzbl (%ecx),%ebx
 544:	38 d8                	cmp    %bl,%al
 546:	74 0e                	je     556 <strcmp+0x26>
 548:	eb 2b                	jmp    575 <strcmp+0x45>
 54a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 550:	38 c8                	cmp    %cl,%al
 552:	75 15                	jne    569 <strcmp+0x39>
    p++, q++;
 554:	89 d9                	mov    %ebx,%ecx
 556:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 559:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 55c:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 55f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 563:	84 c0                	test   %al,%al
 565:	75 e9                	jne    550 <strcmp+0x20>
 567:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 569:	29 c8                	sub    %ecx,%eax
}
 56b:	5b                   	pop    %ebx
 56c:	5d                   	pop    %ebp
 56d:	c3                   	ret    
 56e:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
 571:	31 c0                	xor    %eax,%eax
 573:	eb f4                	jmp    569 <strcmp+0x39>
 575:	0f b6 cb             	movzbl %bl,%ecx
 578:	eb ef                	jmp    569 <strcmp+0x39>
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000580 <strlen>:

uint
strlen(const char *s)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 586:	80 39 00             	cmpb   $0x0,(%ecx)
 589:	74 12                	je     59d <strlen+0x1d>
 58b:	31 d2                	xor    %edx,%edx
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	83 c2 01             	add    $0x1,%edx
 593:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 597:	89 d0                	mov    %edx,%eax
 599:	75 f5                	jne    590 <strlen+0x10>
    ;
  return n;
}
 59b:	5d                   	pop    %ebp
 59c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 59d:	31 c0                	xor    %eax,%eax
}
 59f:	5d                   	pop    %ebp
 5a0:	c3                   	ret    
 5a1:	eb 0d                	jmp    5b0 <memset>
 5a3:	90                   	nop
 5a4:	90                   	nop
 5a5:	90                   	nop
 5a6:	90                   	nop
 5a7:	90                   	nop
 5a8:	90                   	nop
 5a9:	90                   	nop
 5aa:	90                   	nop
 5ab:	90                   	nop
 5ac:	90                   	nop
 5ad:	90                   	nop
 5ae:	90                   	nop
 5af:	90                   	nop

000005b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	8b 55 08             	mov    0x8(%ebp),%edx
 5b6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bd:	89 d7                	mov    %edx,%edi
 5bf:	fc                   	cld    
 5c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5c2:	89 d0                	mov    %edx,%eax
 5c4:	5f                   	pop    %edi
 5c5:	5d                   	pop    %ebp
 5c6:	c3                   	ret    
 5c7:	89 f6                	mov    %esi,%esi
 5c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005d0 <strchr>:

char*
strchr(const char *s, char c)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	53                   	push   %ebx
 5d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 5da:	0f b6 18             	movzbl (%eax),%ebx
 5dd:	84 db                	test   %bl,%bl
 5df:	74 1d                	je     5fe <strchr+0x2e>
    if(*s == c)
 5e1:	38 d3                	cmp    %dl,%bl
 5e3:	89 d1                	mov    %edx,%ecx
 5e5:	75 0d                	jne    5f4 <strchr+0x24>
 5e7:	eb 17                	jmp    600 <strchr+0x30>
 5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f0:	38 ca                	cmp    %cl,%dl
 5f2:	74 0c                	je     600 <strchr+0x30>
  for(; *s; s++)
 5f4:	83 c0 01             	add    $0x1,%eax
 5f7:	0f b6 10             	movzbl (%eax),%edx
 5fa:	84 d2                	test   %dl,%dl
 5fc:	75 f2                	jne    5f0 <strchr+0x20>
      return (char*)s;
  return 0;
 5fe:	31 c0                	xor    %eax,%eax
}
 600:	5b                   	pop    %ebx
 601:	5d                   	pop    %ebp
 602:	c3                   	ret    
 603:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000610 <gets>:

char*
gets(char *buf, int max)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 615:	31 f6                	xor    %esi,%esi
{
 617:	53                   	push   %ebx
 618:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 61b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 61e:	eb 31                	jmp    651 <gets+0x41>
    cc = read(0, &c, 1);
 620:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 627:	00 
 628:	89 7c 24 04          	mov    %edi,0x4(%esp)
 62c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 633:	e8 02 01 00 00       	call   73a <read>
    if(cc < 1)
 638:	85 c0                	test   %eax,%eax
 63a:	7e 1d                	jle    659 <gets+0x49>
      break;
    buf[i++] = c;
 63c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 640:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 642:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 645:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 647:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 64b:	74 0c                	je     659 <gets+0x49>
 64d:	3c 0a                	cmp    $0xa,%al
 64f:	74 08                	je     659 <gets+0x49>
  for(i=0; i+1 < max; ){
 651:	8d 5e 01             	lea    0x1(%esi),%ebx
 654:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 657:	7c c7                	jl     620 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 659:	8b 45 08             	mov    0x8(%ebp),%eax
 65c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 660:	83 c4 2c             	add    $0x2c,%esp
 663:	5b                   	pop    %ebx
 664:	5e                   	pop    %esi
 665:	5f                   	pop    %edi
 666:	5d                   	pop    %ebp
 667:	c3                   	ret    
 668:	90                   	nop
 669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000670 <stat>:

int
stat(const char *n, struct stat *st)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	56                   	push   %esi
 674:	53                   	push   %ebx
 675:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 678:	8b 45 08             	mov    0x8(%ebp),%eax
 67b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 682:	00 
 683:	89 04 24             	mov    %eax,(%esp)
 686:	e8 d7 00 00 00       	call   762 <open>
  if(fd < 0)
 68b:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 68d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 68f:	78 27                	js     6b8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 691:	8b 45 0c             	mov    0xc(%ebp),%eax
 694:	89 1c 24             	mov    %ebx,(%esp)
 697:	89 44 24 04          	mov    %eax,0x4(%esp)
 69b:	e8 da 00 00 00       	call   77a <fstat>
  close(fd);
 6a0:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6a3:	89 c6                	mov    %eax,%esi
  close(fd);
 6a5:	e8 a0 00 00 00       	call   74a <close>
  return r;
 6aa:	89 f0                	mov    %esi,%eax
}
 6ac:	83 c4 10             	add    $0x10,%esp
 6af:	5b                   	pop    %ebx
 6b0:	5e                   	pop    %esi
 6b1:	5d                   	pop    %ebp
 6b2:	c3                   	ret    
 6b3:	90                   	nop
 6b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 6b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6bd:	eb ed                	jmp    6ac <stat+0x3c>
 6bf:	90                   	nop

000006c0 <atoi>:

int
atoi(const char *s)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 6c6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6c7:	0f be 11             	movsbl (%ecx),%edx
 6ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 6cd:	3c 09                	cmp    $0x9,%al
  n = 0;
 6cf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 6d4:	77 17                	ja     6ed <atoi+0x2d>
 6d6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 6d8:	83 c1 01             	add    $0x1,%ecx
 6db:	8d 04 80             	lea    (%eax,%eax,4),%eax
 6de:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 6e2:	0f be 11             	movsbl (%ecx),%edx
 6e5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 6e8:	80 fb 09             	cmp    $0x9,%bl
 6eb:	76 eb                	jbe    6d8 <atoi+0x18>
  return n;
}
 6ed:	5b                   	pop    %ebx
 6ee:	5d                   	pop    %ebp
 6ef:	c3                   	ret    

000006f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6f0:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6f1:	31 d2                	xor    %edx,%edx
{
 6f3:	89 e5                	mov    %esp,%ebp
 6f5:	56                   	push   %esi
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	53                   	push   %ebx
 6fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 700:	85 db                	test   %ebx,%ebx
 702:	7e 12                	jle    716 <memmove+0x26>
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 708:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 70c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 70f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 712:	39 da                	cmp    %ebx,%edx
 714:	75 f2                	jne    708 <memmove+0x18>
  return vdst;
}
 716:	5b                   	pop    %ebx
 717:	5e                   	pop    %esi
 718:	5d                   	pop    %ebp
 719:	c3                   	ret    

0000071a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 71a:	b8 01 00 00 00       	mov    $0x1,%eax
 71f:	cd 40                	int    $0x40
 721:	c3                   	ret    

00000722 <exit>:
SYSCALL(exit)
 722:	b8 02 00 00 00       	mov    $0x2,%eax
 727:	cd 40                	int    $0x40
 729:	c3                   	ret    

0000072a <wait>:
SYSCALL(wait)
 72a:	b8 03 00 00 00       	mov    $0x3,%eax
 72f:	cd 40                	int    $0x40
 731:	c3                   	ret    

00000732 <pipe>:
SYSCALL(pipe)
 732:	b8 04 00 00 00       	mov    $0x4,%eax
 737:	cd 40                	int    $0x40
 739:	c3                   	ret    

0000073a <read>:
SYSCALL(read)
 73a:	b8 05 00 00 00       	mov    $0x5,%eax
 73f:	cd 40                	int    $0x40
 741:	c3                   	ret    

00000742 <write>:
SYSCALL(write)
 742:	b8 10 00 00 00       	mov    $0x10,%eax
 747:	cd 40                	int    $0x40
 749:	c3                   	ret    

0000074a <close>:
SYSCALL(close)
 74a:	b8 15 00 00 00       	mov    $0x15,%eax
 74f:	cd 40                	int    $0x40
 751:	c3                   	ret    

00000752 <kill>:
SYSCALL(kill)
 752:	b8 06 00 00 00       	mov    $0x6,%eax
 757:	cd 40                	int    $0x40
 759:	c3                   	ret    

0000075a <exec>:
SYSCALL(exec)
 75a:	b8 07 00 00 00       	mov    $0x7,%eax
 75f:	cd 40                	int    $0x40
 761:	c3                   	ret    

00000762 <open>:
SYSCALL(open)
 762:	b8 0f 00 00 00       	mov    $0xf,%eax
 767:	cd 40                	int    $0x40
 769:	c3                   	ret    

0000076a <mknod>:
SYSCALL(mknod)
 76a:	b8 11 00 00 00       	mov    $0x11,%eax
 76f:	cd 40                	int    $0x40
 771:	c3                   	ret    

00000772 <unlink>:
SYSCALL(unlink)
 772:	b8 12 00 00 00       	mov    $0x12,%eax
 777:	cd 40                	int    $0x40
 779:	c3                   	ret    

0000077a <fstat>:
SYSCALL(fstat)
 77a:	b8 08 00 00 00       	mov    $0x8,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <link>:
SYSCALL(link)
 782:	b8 13 00 00 00       	mov    $0x13,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <mkdir>:
SYSCALL(mkdir)
 78a:	b8 14 00 00 00       	mov    $0x14,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <chdir>:
SYSCALL(chdir)
 792:	b8 09 00 00 00       	mov    $0x9,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <dup>:
SYSCALL(dup)
 79a:	b8 0a 00 00 00       	mov    $0xa,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <getpid>:
SYSCALL(getpid)
 7a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <sbrk>:
SYSCALL(sbrk)
 7aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <sleep>:
SYSCALL(sleep)
 7b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <uptime>:
SYSCALL(uptime)
 7ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <exitS>:
SYSCALL(exitS)
 7c2:	b8 16 00 00 00       	mov    $0x16,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <waitS>:
SYSCALL(waitS)
 7ca:	b8 17 00 00 00       	mov    $0x17,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <waitpid>:
SYSCALL(waitpid)
 7d2:	b8 18 00 00 00       	mov    $0x18,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <setpriority>:
SYSCALL(setpriority)
 7da:	b8 19 00 00 00       	mov    $0x19,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    
 7e2:	66 90                	xchg   %ax,%ax
 7e4:	66 90                	xchg   %ax,%ax
 7e6:	66 90                	xchg   %ax,%ax
 7e8:	66 90                	xchg   %ax,%ax
 7ea:	66 90                	xchg   %ax,%ax
 7ec:	66 90                	xchg   %ax,%ax
 7ee:	66 90                	xchg   %ax,%ax

000007f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	57                   	push   %edi
 7f4:	56                   	push   %esi
 7f5:	89 c6                	mov    %eax,%esi
 7f7:	53                   	push   %ebx
 7f8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7fe:	85 db                	test   %ebx,%ebx
 800:	74 09                	je     80b <printint+0x1b>
 802:	89 d0                	mov    %edx,%eax
 804:	c1 e8 1f             	shr    $0x1f,%eax
 807:	84 c0                	test   %al,%al
 809:	75 75                	jne    880 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 80b:	89 d0                	mov    %edx,%eax
  neg = 0;
 80d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 814:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 817:	31 ff                	xor    %edi,%edi
 819:	89 ce                	mov    %ecx,%esi
 81b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 81e:	eb 02                	jmp    822 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 820:	89 cf                	mov    %ecx,%edi
 822:	31 d2                	xor    %edx,%edx
 824:	f7 f6                	div    %esi
 826:	8d 4f 01             	lea    0x1(%edi),%ecx
 829:	0f b6 92 09 0f 00 00 	movzbl 0xf09(%edx),%edx
  }while((x /= base) != 0);
 830:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 832:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 835:	75 e9                	jne    820 <printint+0x30>
  if(neg)
 837:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 83a:	89 c8                	mov    %ecx,%eax
 83c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 83f:	85 d2                	test   %edx,%edx
 841:	74 08                	je     84b <printint+0x5b>
    buf[i++] = '-';
 843:	8d 4f 02             	lea    0x2(%edi),%ecx
 846:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 84b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 84e:	66 90                	xchg   %ax,%ax
 850:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 855:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 858:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 85f:	00 
 860:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 864:	89 34 24             	mov    %esi,(%esp)
 867:	88 45 d7             	mov    %al,-0x29(%ebp)
 86a:	e8 d3 fe ff ff       	call   742 <write>
  while(--i >= 0)
 86f:	83 ff ff             	cmp    $0xffffffff,%edi
 872:	75 dc                	jne    850 <printint+0x60>
    putc(fd, buf[i]);
}
 874:	83 c4 4c             	add    $0x4c,%esp
 877:	5b                   	pop    %ebx
 878:	5e                   	pop    %esi
 879:	5f                   	pop    %edi
 87a:	5d                   	pop    %ebp
 87b:	c3                   	ret    
 87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 880:	89 d0                	mov    %edx,%eax
 882:	f7 d8                	neg    %eax
    neg = 1;
 884:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 88b:	eb 87                	jmp    814 <printint+0x24>
 88d:	8d 76 00             	lea    0x0(%esi),%esi

00000890 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 894:	31 ff                	xor    %edi,%edi
{
 896:	56                   	push   %esi
 897:	53                   	push   %ebx
 898:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 89b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 89e:	8d 45 10             	lea    0x10(%ebp),%eax
{
 8a1:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 8a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 8a7:	0f b6 13             	movzbl (%ebx),%edx
 8aa:	83 c3 01             	add    $0x1,%ebx
 8ad:	84 d2                	test   %dl,%dl
 8af:	75 39                	jne    8ea <printf+0x5a>
 8b1:	e9 c2 00 00 00       	jmp    978 <printf+0xe8>
 8b6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 8b8:	83 fa 25             	cmp    $0x25,%edx
 8bb:	0f 84 bf 00 00 00    	je     980 <printf+0xf0>
  write(fd, &c, 1);
 8c1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 8c4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8cb:	00 
 8cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d0:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 8d3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 8d6:	e8 67 fe ff ff       	call   742 <write>
 8db:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 8de:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 8e2:	84 d2                	test   %dl,%dl
 8e4:	0f 84 8e 00 00 00    	je     978 <printf+0xe8>
    if(state == 0){
 8ea:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 8ec:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 8ef:	74 c7                	je     8b8 <printf+0x28>
      }
    } else if(state == '%'){
 8f1:	83 ff 25             	cmp    $0x25,%edi
 8f4:	75 e5                	jne    8db <printf+0x4b>
      if(c == 'd'){
 8f6:	83 fa 64             	cmp    $0x64,%edx
 8f9:	0f 84 31 01 00 00    	je     a30 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 8ff:	25 f7 00 00 00       	and    $0xf7,%eax
 904:	83 f8 70             	cmp    $0x70,%eax
 907:	0f 84 83 00 00 00    	je     990 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 90d:	83 fa 73             	cmp    $0x73,%edx
 910:	0f 84 a2 00 00 00    	je     9b8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 916:	83 fa 63             	cmp    $0x63,%edx
 919:	0f 84 35 01 00 00    	je     a54 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 91f:	83 fa 25             	cmp    $0x25,%edx
 922:	0f 84 e0 00 00 00    	je     a08 <printf+0x178>
  write(fd, &c, 1);
 928:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 92b:	83 c3 01             	add    $0x1,%ebx
 92e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 935:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 936:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 938:	89 44 24 04          	mov    %eax,0x4(%esp)
 93c:	89 34 24             	mov    %esi,(%esp)
 93f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 942:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 946:	e8 f7 fd ff ff       	call   742 <write>
        putc(fd, c);
 94b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 94e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 951:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 958:	00 
 959:	89 44 24 04          	mov    %eax,0x4(%esp)
 95d:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 960:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 963:	e8 da fd ff ff       	call   742 <write>
  for(i = 0; fmt[i]; i++){
 968:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 96c:	84 d2                	test   %dl,%dl
 96e:	0f 85 76 ff ff ff    	jne    8ea <printf+0x5a>
 974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 978:	83 c4 3c             	add    $0x3c,%esp
 97b:	5b                   	pop    %ebx
 97c:	5e                   	pop    %esi
 97d:	5f                   	pop    %edi
 97e:	5d                   	pop    %ebp
 97f:	c3                   	ret    
        state = '%';
 980:	bf 25 00 00 00       	mov    $0x25,%edi
 985:	e9 51 ff ff ff       	jmp    8db <printf+0x4b>
 98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 990:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 993:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 998:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 99a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 9a1:	8b 10                	mov    (%eax),%edx
 9a3:	89 f0                	mov    %esi,%eax
 9a5:	e8 46 fe ff ff       	call   7f0 <printint>
        ap++;
 9aa:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 9ae:	e9 28 ff ff ff       	jmp    8db <printf+0x4b>
 9b3:	90                   	nop
 9b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 9b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 9bb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 9bf:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 9c1:	b8 02 0f 00 00       	mov    $0xf02,%eax
 9c6:	85 ff                	test   %edi,%edi
 9c8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 9cb:	0f b6 07             	movzbl (%edi),%eax
 9ce:	84 c0                	test   %al,%al
 9d0:	74 2a                	je     9fc <printf+0x16c>
 9d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9d8:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 9db:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 9de:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 9e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 9e8:	00 
 9e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ed:	89 34 24             	mov    %esi,(%esp)
 9f0:	e8 4d fd ff ff       	call   742 <write>
        while(*s != 0){
 9f5:	0f b6 07             	movzbl (%edi),%eax
 9f8:	84 c0                	test   %al,%al
 9fa:	75 dc                	jne    9d8 <printf+0x148>
      state = 0;
 9fc:	31 ff                	xor    %edi,%edi
 9fe:	e9 d8 fe ff ff       	jmp    8db <printf+0x4b>
 a03:	90                   	nop
 a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 a08:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 a0b:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 a0d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 a14:	00 
 a15:	89 44 24 04          	mov    %eax,0x4(%esp)
 a19:	89 34 24             	mov    %esi,(%esp)
 a1c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 a20:	e8 1d fd ff ff       	call   742 <write>
 a25:	e9 b1 fe ff ff       	jmp    8db <printf+0x4b>
 a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 a30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 a33:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 a38:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 a3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a42:	8b 10                	mov    (%eax),%edx
 a44:	89 f0                	mov    %esi,%eax
 a46:	e8 a5 fd ff ff       	call   7f0 <printint>
        ap++;
 a4b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 a4f:	e9 87 fe ff ff       	jmp    8db <printf+0x4b>
        putc(fd, *ap);
 a54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 a57:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 a59:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 a5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 a62:	00 
 a63:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 a66:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 a69:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
 a70:	e8 cd fc ff ff       	call   742 <write>
        ap++;
 a75:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 a79:	e9 5d fe ff ff       	jmp    8db <printf+0x4b>
 a7e:	66 90                	xchg   %ax,%ax

00000a80 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a80:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a81:	a1 10 12 00 00       	mov    0x1210,%eax
{
 a86:	89 e5                	mov    %esp,%ebp
 a88:	57                   	push   %edi
 a89:	56                   	push   %esi
 a8a:	53                   	push   %ebx
 a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a8e:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 a90:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a93:	39 d0                	cmp    %edx,%eax
 a95:	72 11                	jb     aa8 <free+0x28>
 a97:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a98:	39 c8                	cmp    %ecx,%eax
 a9a:	72 04                	jb     aa0 <free+0x20>
 a9c:	39 ca                	cmp    %ecx,%edx
 a9e:	72 10                	jb     ab0 <free+0x30>
 aa0:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa4:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa6:	73 f0                	jae    a98 <free+0x18>
 aa8:	39 ca                	cmp    %ecx,%edx
 aaa:	72 04                	jb     ab0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aac:	39 c8                	cmp    %ecx,%eax
 aae:	72 f0                	jb     aa0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ab0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 ab3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 ab6:	39 cf                	cmp    %ecx,%edi
 ab8:	74 1e                	je     ad8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 aba:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 abd:	8b 48 04             	mov    0x4(%eax),%ecx
 ac0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 ac3:	39 f2                	cmp    %esi,%edx
 ac5:	74 28                	je     aef <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 ac7:	89 10                	mov    %edx,(%eax)
  freep = p;
 ac9:	a3 10 12 00 00       	mov    %eax,0x1210
}
 ace:	5b                   	pop    %ebx
 acf:	5e                   	pop    %esi
 ad0:	5f                   	pop    %edi
 ad1:	5d                   	pop    %ebp
 ad2:	c3                   	ret    
 ad3:	90                   	nop
 ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 ad8:	03 71 04             	add    0x4(%ecx),%esi
 adb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ade:	8b 08                	mov    (%eax),%ecx
 ae0:	8b 09                	mov    (%ecx),%ecx
 ae2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ae5:	8b 48 04             	mov    0x4(%eax),%ecx
 ae8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 aeb:	39 f2                	cmp    %esi,%edx
 aed:	75 d8                	jne    ac7 <free+0x47>
    p->s.size += bp->s.size;
 aef:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 af2:	a3 10 12 00 00       	mov    %eax,0x1210
    p->s.size += bp->s.size;
 af7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 afa:	8b 53 f8             	mov    -0x8(%ebx),%edx
 afd:	89 10                	mov    %edx,(%eax)
}
 aff:	5b                   	pop    %ebx
 b00:	5e                   	pop    %esi
 b01:	5f                   	pop    %edi
 b02:	5d                   	pop    %ebp
 b03:	c3                   	ret    
 b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000b10 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b10:	55                   	push   %ebp
 b11:	89 e5                	mov    %esp,%ebp
 b13:	57                   	push   %edi
 b14:	56                   	push   %esi
 b15:	53                   	push   %ebx
 b16:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b19:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b1c:	8b 1d 10 12 00 00    	mov    0x1210,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b22:	8d 48 07             	lea    0x7(%eax),%ecx
 b25:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 b28:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b2a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 b2d:	0f 84 9b 00 00 00    	je     bce <malloc+0xbe>
 b33:	8b 13                	mov    (%ebx),%edx
 b35:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b38:	39 fe                	cmp    %edi,%esi
 b3a:	76 64                	jbe    ba0 <malloc+0x90>
 b3c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 b43:	bb 00 80 00 00       	mov    $0x8000,%ebx
 b48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 b4b:	eb 0e                	jmp    b5b <malloc+0x4b>
 b4d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b50:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b52:	8b 78 04             	mov    0x4(%eax),%edi
 b55:	39 fe                	cmp    %edi,%esi
 b57:	76 4f                	jbe    ba8 <malloc+0x98>
 b59:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b5b:	3b 15 10 12 00 00    	cmp    0x1210,%edx
 b61:	75 ed                	jne    b50 <malloc+0x40>
  if(nu < 4096)
 b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b66:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 b6c:	bf 00 10 00 00       	mov    $0x1000,%edi
 b71:	0f 43 fe             	cmovae %esi,%edi
 b74:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 b77:	89 04 24             	mov    %eax,(%esp)
 b7a:	e8 2b fc ff ff       	call   7aa <sbrk>
  if(p == (char*)-1)
 b7f:	83 f8 ff             	cmp    $0xffffffff,%eax
 b82:	74 18                	je     b9c <malloc+0x8c>
  hp->s.size = nu;
 b84:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 b87:	83 c0 08             	add    $0x8,%eax
 b8a:	89 04 24             	mov    %eax,(%esp)
 b8d:	e8 ee fe ff ff       	call   a80 <free>
  return freep;
 b92:	8b 15 10 12 00 00    	mov    0x1210,%edx
      if((p = morecore(nunits)) == 0)
 b98:	85 d2                	test   %edx,%edx
 b9a:	75 b4                	jne    b50 <malloc+0x40>
        return 0;
 b9c:	31 c0                	xor    %eax,%eax
 b9e:	eb 20                	jmp    bc0 <malloc+0xb0>
    if(p->s.size >= nunits){
 ba0:	89 d0                	mov    %edx,%eax
 ba2:	89 da                	mov    %ebx,%edx
 ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 ba8:	39 fe                	cmp    %edi,%esi
 baa:	74 1c                	je     bc8 <malloc+0xb8>
        p->s.size -= nunits;
 bac:	29 f7                	sub    %esi,%edi
 bae:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 bb1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 bb4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 bb7:	89 15 10 12 00 00    	mov    %edx,0x1210
      return (void*)(p + 1);
 bbd:	83 c0 08             	add    $0x8,%eax
  }
}
 bc0:	83 c4 1c             	add    $0x1c,%esp
 bc3:	5b                   	pop    %ebx
 bc4:	5e                   	pop    %esi
 bc5:	5f                   	pop    %edi
 bc6:	5d                   	pop    %ebp
 bc7:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 bc8:	8b 08                	mov    (%eax),%ecx
 bca:	89 0a                	mov    %ecx,(%edx)
 bcc:	eb e9                	jmp    bb7 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 bce:	c7 05 10 12 00 00 14 	movl   $0x1214,0x1210
 bd5:	12 00 00 
    base.s.size = 0;
 bd8:	ba 14 12 00 00       	mov    $0x1214,%edx
    base.s.ptr = freep = prevp = &base;
 bdd:	c7 05 14 12 00 00 14 	movl   $0x1214,0x1214
 be4:	12 00 00 
    base.s.size = 0;
 be7:	c7 05 18 12 00 00 00 	movl   $0x0,0x1218
 bee:	00 00 00 
 bf1:	e9 46 ff ff ff       	jmp    b3c <malloc+0x2c>
