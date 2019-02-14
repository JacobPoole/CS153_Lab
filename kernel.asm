
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 2e 10 80       	mov    $0x80102e00,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 20 71 10 	movl   $0x80107120,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 00 44 00 00       	call   80104460 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 27 71 10 	movl   $0x80107127,0x4(%esp)
8010009b:	80 
8010009c:	e8 8f 42 00 00       	call   80104330 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 e5 44 00 00       	call   801045d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 da 44 00 00       	call   80104640 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 ff 41 00 00       	call   80104370 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 b2 1f 00 00       	call   80102130 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 2e 71 10 80 	movl   $0x8010712e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 5b 42 00 00       	call   80104410 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 3f 71 10 80 	movl   $0x8010713f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 1a 42 00 00       	call   80104410 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ce 41 00 00       	call   801043d0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 c2 43 00 00       	call   801045d0 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 eb 43 00 00       	jmp    80104640 <release>
    panic("brelse");
80100255:	c7 04 24 46 71 10 80 	movl   $0x80107146,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 19 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 3d 43 00 00       	call   801045d0 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 13 34 00 00       	call   801036c0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 e8 3a 00 00       	call   80103db0 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 2a 43 00 00       	call   80104640 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 13 00 00       	call   801016c0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 0c 43 00 00       	call   80104640 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 13 00 00       	call   801016c0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 f5 23 00 00       	call   80102770 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 4d 71 10 80 	movl   $0x8010714d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 dc 76 10 80 	movl   $0x801076dc,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 cc 40 00 00       	call   80104480 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 61 71 10 80 	movl   $0x80107161,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 72 58 00 00       	call   80105c80 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 c2 57 00 00       	call   80105c80 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 b6 57 00 00       	call   80105c80 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 aa 57 00 00       	call   80105c80 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 2f 42 00 00       	call   80104730 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 72 41 00 00       	call   80104690 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 65 71 10 80 	movl   $0x80107165,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 90 71 10 80 	movzbl -0x7fef8e70(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 99 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 bd 3f 00 00       	call   801045d0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 05 40 00 00       	call   80104640 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 48 3f 00 00       	call   80104640 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 78 71 10 80       	mov    $0x80107178,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 34 3e 00 00       	call   801045d0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 7f 71 10 80 	movl   $0x8010717f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 06 3e 00 00       	call   801045d0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 14 3e 00 00       	call   80104640 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 b9 38 00 00       	call   80104170 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 34 39 00 00       	jmp    80104260 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 88 71 10 	movl   $0x80107188,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 f6 3a 00 00       	call   80104460 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 24 19 00 00       	call   801022c0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 0f 2d 00 00       	call   801036c0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 64 21 00 00       	call   80102b20 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 49 15 00 00       	call   80101f10 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 e7 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 75 0f 00 00       	call   80101970 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 18 0f 00 00       	call   80101920 <iunlockput>
    end_op();
80100a08:	e8 83 21 00 00       	call   80102b90 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 3f 64 00 00       	call   80106e70 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 dd 0e 00 00       	call   80101970 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 09 62 00 00       	call   80106ce0 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 08 61 00 00       	call   80106c20 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 c2 62 00 00       	call   80106df0 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 e5 0d 00 00       	call   80101920 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 4b 20 00 00       	call   80102b90 <end_op>
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 6f 61 00 00       	call   80106ce0 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 67 62 00 00       	call   80106df0 <freevm>
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b93:	e8 f8 1f 00 00       	call   80102b90 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 a1 71 10 80 	movl   $0x801071a1,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 53 63 00 00       	call   80106f20 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 aa 3c 00 00       	call   801048b0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 99 3c 00 00       	call   801048b0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 4a 64 00 00       	call   80107080 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 d7 63 00 00       	call   80107080 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 7a 3b 00 00       	call   80104870 <safestrcpy>
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 6c 5d 00 00       	call   80106a90 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 c4 60 00 00       	call   80106df0 <freevm>
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 ad 71 10 	movl   $0x801071ad,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 f6 36 00 00       	call   80104460 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 48 38 00 00       	call   801045d0 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 8b 38 00 00       	call   80104640 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 74 38 00 00       	call   80104640 <release>
}
80100dcc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 da 37 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 31 38 00 00       	call   80104640 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
    panic("filedup");
80100e17:	c7 04 24 b4 71 10 80 	movl   $0x801071b4,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 88 37 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e6b:	e9 d0 37 00 00       	jmp    80104640 <release>
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e8f:	e8 ac 37 00 00       	call   80104640 <release>
  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 b8 23 00 00       	call   80103270 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ec0:	e8 5b 1c 00 00       	call   80102b20 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 10 09 00 00       	call   801017e0 <iput>
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
    end_op();
80100ed7:	e9 b4 1c 00 00       	jmp    80102b90 <end_op>
    panic("fileclose");
80100edc:	c7 04 24 bc 71 10 80 	movl   $0x801071bc,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 b6 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 24 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 79 08 00 00       	call   801017a0 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 51 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 e7 09 00 00       	call   80101970 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 03 08 00 00       	call   801017a0 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fb5:	e9 36 24 00 00       	jmp    801033f0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
  panic("fileread");
80100fc7:	c7 04 24 c6 71 10 80 	movl   $0x801071c6,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 67 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101039:	e8 52 1b 00 00       	call   80102b90 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101063:	e8 b8 1a 00 00       	call   80102b20 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 4d 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 de 09 00 00       	call   80101a70 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 fc 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010a4:	e8 e7 1a 00 00       	call   80102b90 <end_op>
      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 1f 22 00 00       	jmp    80103300 <pipewrite>
        panic("short filewrite");
801010e1:	c7 04 24 cf 71 10 80 	movl   $0x801071cf,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010ed:	c7 04 24 d5 71 10 80 	movl   $0x801071d5,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 2c             	sub    $0x2c,%esp
80101109:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010110c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101111:	85 c0                	test   %eax,%eax
80101113:	0f 84 8c 00 00 00    	je     801011a5 <balloc+0xa5>
80101119:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101120:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101123:	89 f0                	mov    %esi,%eax
80101125:	c1 f8 0c             	sar    $0xc,%eax
80101128:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010112e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101135:	89 04 24             	mov    %eax,(%esp)
80101138:	e8 93 ef ff ff       	call   801000d0 <bread>
8010113d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101140:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101148:	31 c0                	xor    %eax,%eax
8010114a:	eb 33                	jmp    8010117f <balloc+0x7f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101150:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101153:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101155:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	bf 01 00 00 00       	mov    $0x1,%edi
80101162:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101164:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101169:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116b:	0f b6 fb             	movzbl %bl,%edi
8010116e:	85 cf                	test   %ecx,%edi
80101170:	74 46                	je     801011b8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101172:	83 c0 01             	add    $0x1,%eax
80101175:	83 c6 01             	add    $0x1,%esi
80101178:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117d:	74 05                	je     80101184 <balloc+0x84>
8010117f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101182:	72 cc                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 51 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010118f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010119f:	0f 82 7b ff ff ff    	jb     80101120 <balloc+0x20>
  }
  panic("balloc: out of blocks");
801011a5:	c7 04 24 df 71 10 80 	movl   $0x801071df,(%esp)
801011ac:	e8 af f1 ff ff       	call   80100360 <panic>
801011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	09 d9                	or     %ebx,%ecx
801011ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011bd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011c1:	89 1c 24             	mov    %ebx,(%esp)
801011c4:	e8 f7 1a 00 00       	call   80102cc0 <log_write>
        brelse(bp);
801011c9:	89 1c 24             	mov    %ebx,(%esp)
801011cc:	e8 0f f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011d8:	89 04 24             	mov    %eax,(%esp)
801011db:	e8 f0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011e7:	00 
801011e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ef:	00 
  bp = bread(dev, bno);
801011f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 93 34 00 00       	call   80104690 <memset>
  log_write(bp);
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 bb 1a 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101205:	89 1c 24             	mov    %ebx,(%esp)
80101208:	e8 d3 ef ff ff       	call   801001e0 <brelse>
}
8010120d:	83 c4 2c             	add    $0x2c,%esp
80101210:	89 f0                	mov    %esi,%eax
80101212:	5b                   	pop    %ebx
80101213:	5e                   	pop    %esi
80101214:	5f                   	pop    %edi
80101215:	5d                   	pop    %ebp
80101216:	c3                   	ret    
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	89 c7                	mov    %eax,%edi
80101226:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101227:	31 f6                	xor    %esi,%esi
{
80101229:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010122f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101232:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010123c:	e8 8f 33 00 00       	call   801045d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 14                	jmp    8010125a <iget+0x3a>
80101246:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101248:	85 f6                	test   %esi,%esi
8010124a:	74 3c                	je     80101288 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101252:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101258:	74 46                	je     801012a0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010125d:	85 c9                	test   %ecx,%ecx
8010125f:	7e e7                	jle    80101248 <iget+0x28>
80101261:	39 3b                	cmp    %edi,(%ebx)
80101263:	75 e3                	jne    80101248 <iget+0x28>
80101265:	39 53 04             	cmp    %edx,0x4(%ebx)
80101268:	75 de                	jne    80101248 <iget+0x28>
      ip->ref++;
8010126a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010126d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010126f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101276:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101279:	e8 c2 33 00 00       	call   80104640 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127e:	83 c4 1c             	add    $0x1c,%esp
80101281:	89 f0                	mov    %esi,%eax
80101283:	5b                   	pop    %ebx
80101284:	5e                   	pop    %esi
80101285:	5f                   	pop    %edi
80101286:	5d                   	pop    %ebp
80101287:	c3                   	ret    
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101299:	75 bf                	jne    8010125a <iget+0x3a>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 29                	je     801012cd <iget+0xad>
  ip->dev = dev;
801012a4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012a9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012be:	e8 7d 33 00 00       	call   80104640 <release>
}
801012c3:	83 c4 1c             	add    $0x1c,%esp
801012c6:	89 f0                	mov    %esi,%eax
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
801012cc:	c3                   	ret    
    panic("iget: no inodes");
801012cd:	c7 04 24 f5 71 10 80 	movl   $0x801071f5,(%esp)
801012d4:	e8 87 f0 ff ff       	call   80100360 <panic>
801012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c3                	mov    %eax,%ebx
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 66                	je     80101360 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	83 c4 1c             	add    $0x1c,%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101308:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010130b:	83 fe 7f             	cmp    $0x7f,%esi
8010130e:	77 77                	ja     80101387 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101310:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 5e                	je     80101378 <bmap+0x98>
    bp = bread(ip->dev, addr);
8010131a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131e:	8b 03                	mov    (%ebx),%eax
80101320:	89 04 24             	mov    %eax,(%esp)
80101323:	e8 a8 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101328:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
8010132c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010132e:	8b 32                	mov    (%edx),%esi
80101330:	85 f6                	test   %esi,%esi
80101332:	75 19                	jne    8010134d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101334:	8b 03                	mov    (%ebx),%eax
80101336:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101339:	e8 c2 fd ff ff       	call   80101100 <balloc>
8010133e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101341:	89 02                	mov    %eax,(%edx)
80101343:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101345:	89 3c 24             	mov    %edi,(%esp)
80101348:	e8 73 19 00 00       	call   80102cc0 <log_write>
    brelse(bp);
8010134d:	89 3c 24             	mov    %edi,(%esp)
80101350:	e8 8b ee ff ff       	call   801001e0 <brelse>
}
80101355:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101358:	89 f0                	mov    %esi,%eax
}
8010135a:	5b                   	pop    %ebx
8010135b:	5e                   	pop    %esi
8010135c:	5f                   	pop    %edi
8010135d:	5d                   	pop    %ebp
8010135e:	c3                   	ret    
8010135f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101360:	8b 03                	mov    (%ebx),%eax
80101362:	e8 99 fd ff ff       	call   80101100 <balloc>
80101367:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010136a:	83 c4 1c             	add    $0x1c,%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101378:	8b 03                	mov    (%ebx),%eax
8010137a:	e8 81 fd ff ff       	call   80101100 <balloc>
8010137f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101385:	eb 93                	jmp    8010131a <bmap+0x3a>
  panic("bmap: out of range");
80101387:	c7 04 24 05 72 10 80 	movl   $0x80107205,(%esp)
8010138e:	e8 cd ef ff ff       	call   80100360 <panic>
80101393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <readsb>:
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	56                   	push   %esi
801013a4:	53                   	push   %ebx
801013a5:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013b2:	00 
{
801013b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013b6:	89 04 24             	mov    %eax,(%esp)
801013b9:	e8 12 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013be:	89 34 24             	mov    %esi,(%esp)
801013c1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013c8:	00 
  bp = bread(dev, 1);
801013c9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013cb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d2:	e8 59 33 00 00       	call   80104730 <memmove>
  brelse(bp);
801013d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	5b                   	pop    %ebx
801013de:	5e                   	pop    %esi
801013df:	5d                   	pop    %ebp
  brelse(bp);
801013e0:	e9 fb ed ff ff       	jmp    801001e0 <brelse>
801013e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 d7                	mov    %edx,%edi
801013f6:	56                   	push   %esi
801013f7:	53                   	push   %ebx
801013f8:	89 c3                	mov    %eax,%ebx
801013fa:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
801013fd:	89 04 24             	mov    %eax,(%esp)
80101400:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101407:	80 
80101408:	e8 93 ff ff ff       	call   801013a0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010140d:	89 fa                	mov    %edi,%edx
8010140f:	c1 ea 0c             	shr    $0xc,%edx
80101412:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101418:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
8010141b:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101420:	89 54 24 04          	mov    %edx,0x4(%esp)
80101424:	e8 a7 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101429:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
8010142b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101431:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101433:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101436:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101439:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010143b:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
8010143d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101442:	0f b6 c8             	movzbl %al,%ecx
80101445:	85 d9                	test   %ebx,%ecx
80101447:	74 20                	je     80101469 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101449:	f7 d3                	not    %ebx
8010144b:	21 c3                	and    %eax,%ebx
8010144d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 67 18 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101459:	89 34 24             	mov    %esi,(%esp)
8010145c:	e8 7f ed ff ff       	call   801001e0 <brelse>
}
80101461:	83 c4 1c             	add    $0x1c,%esp
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
    panic("freeing free block");
80101469:	c7 04 24 18 72 10 80 	movl   $0x80107218,(%esp)
80101470:	e8 eb ee ff ff       	call   80100360 <panic>
80101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010148c:	c7 44 24 04 2b 72 10 	movl   $0x8010722b,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 c0 2f 00 00       	call   80104460 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 32 72 10 	movl   $0x80107232,0x4(%esp)
801014b0:	80 
801014b1:	e8 7a 2e 00 00       	call   80104330 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bc:	75 e2                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014c8:	80 
801014c9:	89 04 24             	mov    %eax,(%esp)
801014cc:	e8 cf fe ff ff       	call   801013a0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014d1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014d6:	c7 04 24 98 72 10 80 	movl   $0x80107298,(%esp)
801014dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ea:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014fc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101501:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101505:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010150a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010150e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101513:	89 44 24 04          	mov    %eax,0x4(%esp)
80101517:	e8 34 f1 ff ff       	call   80100650 <cprintf>
}
8010151c:	83 c4 24             	add    $0x24,%esp
8010151f:	5b                   	pop    %ebx
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101543:	8b 7d 08             	mov    0x8(%ebp),%edi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 a2 00 00 00    	jbe    801015f1 <ialloc+0xc1>
8010154f:	be 01 00 00 00       	mov    $0x1,%esi
80101554:	bb 01 00 00 00       	mov    $0x1,%ebx
80101559:	eb 1a                	jmp    80101575 <ialloc+0x45>
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101560:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101566:	e8 75 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010156b:	89 de                	mov    %ebx,%esi
8010156d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101573:	73 7c                	jae    801015f1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	89 44 24 04          	mov    %eax,0x4(%esp)
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 f0                	mov    %esi,%eax
80101590:	83 e0 07             	and    $0x7,%eax
80101593:	c1 e0 06             	shl    $0x6,%eax
80101596:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010159e:	75 c0                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a0:	89 0c 24             	mov    %ecx,(%esp)
801015a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	e8 d2 30 00 00       	call   80104690 <memset>
      dip->type = type;
801015be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015cb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ce:	89 14 24             	mov    %edx,(%esp)
801015d1:	e8 ea 16 00 00       	call   80102cc0 <log_write>
      brelse(bp);
801015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015d9:	89 14 24             	mov    %edx,(%esp)
801015dc:	e8 ff eb ff ff       	call   801001e0 <brelse>
}
801015e1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015e4:	89 f2                	mov    %esi,%edx
}
801015e6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015e7:	89 f8                	mov    %edi,%eax
}
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
      return iget(dev, inum);
801015ec:	e9 2f fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015f1:	c7 04 24 38 72 10 80 	movl   $0x80107238,(%esp)
801015f8:	e8 63 ed ff ff       	call   80100360 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010161a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 a7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101629:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010162c:	83 e2 07             	and    $0x7,%edx
8010162f:	c1 e2 06             	shl    $0x6,%edx
80101632:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101636:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101638:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010163f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101643:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101647:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010164b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010164f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101653:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101657:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010165b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010165e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101665:	89 14 24             	mov    %edx,(%esp)
80101668:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166f:	00 
80101670:	e8 bb 30 00 00       	call   80104730 <memmove>
  log_write(bp);
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 43 16 00 00       	call   80102cc0 <log_write>
  brelse(bp);
8010167d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101680:	83 c4 10             	add    $0x10,%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
  brelse(bp);
80101686:	e9 55 eb ff ff       	jmp    801001e0 <brelse>
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 2a 2f 00 00       	call   801045d0 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 8a 2f 00 00       	call   80104640 <release>
}
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b3 00 00 00    	je     80101786 <ilock+0xc6>
801016d3:	8b 53 08             	mov    0x8(%ebx),%edx
801016d6:	85 d2                	test   %edx,%edx
801016d8:	0f 8e a8 00 00 00    	jle    80101786 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 87 2c 00 00       	call   80104370 <acquiresleep>
  if(ip->valid == 0){
801016e9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ec:	85 c0                	test   %eax,%eax
801016ee:	74 08                	je     801016f8 <ilock+0x38>
}
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5d                   	pop    %ebp
801016f6:	c3                   	ret    
801016f7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101712:	8b 53 04             	mov    0x4(%ebx),%edx
80101715:	83 e2 07             	and    $0x7,%edx
80101718:	c1 e2 06             	shl    $0x6,%edx
8010171b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101721:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101724:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101727:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010172b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010172f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101733:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101737:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010173b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010173f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101743:	8b 42 fc             	mov    -0x4(%edx),%eax
80101746:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101749:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010174c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 d0 2f 00 00       	call   80104730 <memmove>
    brelse(bp);
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 76 ff ff ff    	jne    801016f0 <ilock+0x30>
      panic("ilock: no type");
8010177a:	c7 04 24 50 72 10 80 	movl   $0x80107250,(%esp)
80101781:	e8 da eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101786:	c7 04 24 4a 72 10 80 	movl   $0x8010724a,(%esp)
8010178d:	e8 ce eb ff ff       	call   80100360 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	83 ec 10             	sub    $0x10,%esp
801017a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017ab:	85 db                	test   %ebx,%ebx
801017ad:	74 24                	je     801017d3 <iunlock+0x33>
801017af:	8d 73 0c             	lea    0xc(%ebx),%esi
801017b2:	89 34 24             	mov    %esi,(%esp)
801017b5:	e8 56 2c 00 00       	call   80104410 <holdingsleep>
801017ba:	85 c0                	test   %eax,%eax
801017bc:	74 15                	je     801017d3 <iunlock+0x33>
801017be:	8b 43 08             	mov    0x8(%ebx),%eax
801017c1:	85 c0                	test   %eax,%eax
801017c3:	7e 0e                	jle    801017d3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017c5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	5b                   	pop    %ebx
801017cc:	5e                   	pop    %esi
801017cd:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ce:	e9 fd 2b 00 00       	jmp    801043d0 <releasesleep>
    panic("iunlock");
801017d3:	c7 04 24 5f 72 10 80 	movl   $0x8010725f,(%esp)
801017da:	e8 81 eb ff ff       	call   80100360 <panic>
801017df:	90                   	nop

801017e0 <iput>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 1c             	sub    $0x1c,%esp
801017e9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ec:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ef:	89 3c 24             	mov    %edi,(%esp)
801017f2:	e8 79 2b 00 00       	call   80104370 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017fa:	85 d2                	test   %edx,%edx
801017fc:	74 07                	je     80101805 <iput+0x25>
801017fe:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101803:	74 2b                	je     80101830 <iput+0x50>
  releasesleep(&ip->lock);
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 c3 2b 00 00       	call   801043d0 <releasesleep>
  acquire(&icache.lock);
8010180d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101814:	e8 b7 2d 00 00       	call   801045d0 <acquire>
  ip->ref--;
80101819:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010181d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101824:	83 c4 1c             	add    $0x1c,%esp
80101827:	5b                   	pop    %ebx
80101828:	5e                   	pop    %esi
80101829:	5f                   	pop    %edi
8010182a:	5d                   	pop    %ebp
  release(&icache.lock);
8010182b:	e9 10 2e 00 00       	jmp    80104640 <release>
    acquire(&icache.lock);
80101830:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101837:	e8 94 2d 00 00       	call   801045d0 <acquire>
    int r = ip->ref;
8010183c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010183f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101846:	e8 f5 2d 00 00       	call   80104640 <release>
    if(r == 1){
8010184b:	83 fb 01             	cmp    $0x1,%ebx
8010184e:	75 b5                	jne    80101805 <iput+0x25>
80101850:	8d 4e 30             	lea    0x30(%esi),%ecx
80101853:	89 f3                	mov    %esi,%ebx
80101855:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x87>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fb                	cmp    %edi,%ebx
80101865:	74 19                	je     80101880 <iput+0xa0>
    if(ip->addrs[i]){
80101867:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010186a:	85 d2                	test   %edx,%edx
8010186c:	74 f2                	je     80101860 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010186e:	8b 06                	mov    (%esi),%eax
80101870:	e8 7b fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101875:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010187c:	eb e2                	jmp    80101860 <iput+0x80>
8010187e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 2b                	jne    801018b8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010188d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101894:	89 34 24             	mov    %esi,(%esp)
80101897:	e8 64 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
8010189c:	31 c0                	xor    %eax,%eax
8010189e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018a2:	89 34 24             	mov    %esi,(%esp)
801018a5:	e8 56 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018aa:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018b1:	e9 4f ff ff ff       	jmp    80101805 <iput+0x25>
801018b6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018bc:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018be:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	89 04 24             	mov    %eax,(%esp)
801018c3:	e8 08 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018cb:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018d1:	89 cf                	mov    %ecx,%edi
801018d3:	31 c0                	xor    %eax,%eax
801018d5:	eb 0e                	jmp    801018e5 <iput+0x105>
801018d7:	90                   	nop
801018d8:	83 c3 01             	add    $0x1,%ebx
801018db:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018e1:	89 d8                	mov    %ebx,%eax
801018e3:	74 10                	je     801018f5 <iput+0x115>
      if(a[j])
801018e5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018e8:	85 d2                	test   %edx,%edx
801018ea:	74 ec                	je     801018d8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018ec:	8b 06                	mov    (%esi),%eax
801018ee:	e8 fd fa ff ff       	call   801013f0 <bfree>
801018f3:	eb e3                	jmp    801018d8 <iput+0xf8>
    brelse(bp);
801018f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018fb:	89 04 24             	mov    %eax,(%esp)
801018fe:	e8 dd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101903:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101909:	8b 06                	mov    (%esi),%eax
8010190b:	e8 e0 fa ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101910:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101917:	00 00 00 
8010191a:	e9 6e ff ff ff       	jmp    8010188d <iput+0xad>
8010191f:	90                   	nop

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 14             	sub    $0x14,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	89 1c 24             	mov    %ebx,(%esp)
8010192d:	e8 6e fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101932:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101935:	83 c4 14             	add    $0x14,%esp
80101938:	5b                   	pop    %ebx
80101939:	5d                   	pop    %ebp
  iput(ip);
8010193a:	e9 a1 fe ff ff       	jmp    801017e0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 2c             	sub    $0x2c,%esp
80101979:	8b 45 0c             	mov    0xc(%ebp),%eax
8010197c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010197f:	8b 75 10             	mov    0x10(%ebp),%esi
80101982:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101985:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101988:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010198d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101990:	0f 84 aa 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101996:	8b 47 58             	mov    0x58(%edi),%eax
80101999:	39 f0                	cmp    %esi,%eax
8010199b:	0f 82 c7 00 00 00    	jb     80101a68 <readi+0xf8>
801019a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019a4:	89 da                	mov    %ebx,%edx
801019a6:	01 f2                	add    %esi,%edx
801019a8:	0f 82 ba 00 00 00    	jb     80101a68 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ae:	89 c1                	mov    %eax,%ecx
801019b0:	29 f1                	sub    %esi,%ecx
801019b2:	39 d0                	cmp    %edx,%eax
801019b4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b7:	31 c0                	xor    %eax,%eax
801019b9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019be:	74 70                	je     80101a30 <readi+0xc0>
801019c0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019c3:	89 c7                	mov    %eax,%edi
801019c5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019cb:	89 f2                	mov    %esi,%edx
801019cd:	c1 ea 09             	shr    $0x9,%edx
801019d0:	89 d8                	mov    %ebx,%eax
801019d2:	e8 09 f9 ff ff       	call   801012e0 <bmap>
801019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019db:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019dd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e2:	89 04 24             	mov    %eax,(%esp)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019ed:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ef:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019f1:	89 f0                	mov    %esi,%eax
801019f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019fe:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a0e:	01 df                	add    %ebx,%edi
80101a10:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a15:	89 04 24             	mov    %eax,(%esp)
80101a18:	e8 13 2d 00 00       	call   80104730 <memmove>
    brelse(bp);
80101a1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a20:	89 14 24             	mov    %edx,(%esp)
80101a23:	e8 b8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a2e:	77 98                	ja     801019c8 <readi+0x58>
  }
  return n;
80101a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a33:	83 c4 2c             	add    $0x2c,%esp
80101a36:	5b                   	pop    %ebx
80101a37:	5e                   	pop    %esi
80101a38:	5f                   	pop    %edi
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 1e                	ja     80101a68 <readi+0xf8>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 13                	je     80101a68 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a58:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a5b:	83 c4 2c             	add    $0x2c,%esp
80101a5e:	5b                   	pop    %ebx
80101a5f:	5e                   	pop    %esi
80101a60:	5f                   	pop    %edi
80101a61:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a62:	ff e0                	jmp    *%eax
80101a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a6d:	eb c4                	jmp    80101a33 <readi+0xc3>
80101a6f:	90                   	nop

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 2c             	sub    $0x2c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a90:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 e3 00 00 00    	jb     80101b88 <writei+0x118>
80101aa5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aa8:	89 c8                	mov    %ecx,%eax
80101aaa:	01 f0                	add    %esi,%eax
80101aac:	0f 82 d6 00 00 00    	jb     80101b88 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab7:	0f 87 cb 00 00 00    	ja     80101b88 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101abd:	85 c9                	test   %ecx,%ecx
80101abf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ac6:	74 77                	je     80101b3f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101acb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101acd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad2:	c1 ea 09             	shr    $0x9,%edx
80101ad5:	89 f8                	mov    %edi,%eax
80101ad7:	e8 04 f8 ff ff       	call   801012e0 <bmap>
80101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ae0:	8b 07                	mov    (%edi),%eax
80101ae2:	89 04 24             	mov    %eax,(%esp)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aed:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af5:	89 f0                	mov    %esi,%eax
80101af7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afc:	29 c3                	sub    %eax,%ebx
80101afe:	39 cb                	cmp    %ecx,%ebx
80101b00:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b07:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b09:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b0d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 17 2c 00 00       	call   80104730 <memmove>
    log_write(bp);
80101b19:	89 3c 24             	mov    %edi,(%esp)
80101b1c:	e8 9f 11 00 00       	call   80102cc0 <log_write>
    brelse(bp);
80101b21:	89 3c 24             	mov    %edi,(%esp)
80101b24:	e8 b7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b2f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b32:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b35:	77 91                	ja     80101ac8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b37:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3d:	72 39                	jb     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b42:	83 c4 2c             	add    $0x2c,%esp
80101b45:	5b                   	pop    %ebx
80101b46:	5e                   	pop    %esi
80101b47:	5f                   	pop    %edi
80101b48:	5d                   	pop    %ebp
80101b49:	c3                   	ret    
80101b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 2e                	ja     80101b88 <writei+0x118>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 23                	je     80101b88 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b7e:	89 04 24             	mov    %eax,(%esp)
80101b81:	e8 7a fa ff ff       	call   80101600 <iupdate>
80101b86:	eb b7                	jmp    80101b3f <writei+0xcf>
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b90:	5b                   	pop    %ebx
80101b91:	5e                   	pop    %esi
80101b92:	5f                   	pop    %edi
80101b93:	5d                   	pop    %ebp
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bb0:	00 
80101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	89 04 24             	mov    %eax,(%esp)
80101bbb:	e8 f0 2b 00 00       	call   801047b0 <strncmp>
}
80101bc0:	c9                   	leave  
80101bc1:	c3                   	ret    
80101bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 2c             	sub    $0x2c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 97 00 00 00    	jne    80101c7e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	75 0d                	jne    80101c00 <dirlookup+0x30>
80101bf3:	eb 73                	jmp    80101c68 <dirlookup+0x98>
80101bf5:	8d 76 00             	lea    0x0(%esi),%esi
80101bf8:	83 c7 10             	add    $0x10,%edi
80101bfb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bfe:	76 68                	jbe    80101c68 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c00:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c07:	00 
80101c08:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c0c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c10:	89 1c 24             	mov    %ebx,(%esp)
80101c13:	e8 58 fd ff ff       	call   80101970 <readi>
80101c18:	83 f8 10             	cmp    $0x10,%eax
80101c1b:	75 55                	jne    80101c72 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c22:	74 d4                	je     80101bf8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c35:	00 
80101c36:	89 04 24             	mov    %eax,(%esp)
80101c39:	e8 72 2b 00 00       	call   801047b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c3e:	85 c0                	test   %eax,%eax
80101c40:	75 b6                	jne    80101bf8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c42:	8b 45 10             	mov    0x10(%ebp),%eax
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 05                	je     80101c4e <dirlookup+0x7e>
        *poff = off;
80101c49:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c4e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c52:	8b 03                	mov    (%ebx),%eax
80101c54:	e8 c7 f5 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101c59:	83 c4 2c             	add    $0x2c,%esp
80101c5c:	5b                   	pop    %ebx
80101c5d:	5e                   	pop    %esi
80101c5e:	5f                   	pop    %edi
80101c5f:	5d                   	pop    %ebp
80101c60:	c3                   	ret    
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c6b:	31 c0                	xor    %eax,%eax
}
80101c6d:	5b                   	pop    %ebx
80101c6e:	5e                   	pop    %esi
80101c6f:	5f                   	pop    %edi
80101c70:	5d                   	pop    %ebp
80101c71:	c3                   	ret    
      panic("dirlookup read");
80101c72:	c7 04 24 79 72 10 80 	movl   $0x80107279,(%esp)
80101c79:	e8 e2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c7e:	c7 04 24 67 72 10 80 	movl   $0x80107267,(%esp)
80101c85:	e8 d6 e6 ff ff       	call   80100360 <panic>
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	89 cf                	mov    %ecx,%edi
80101c96:	56                   	push   %esi
80101c97:	53                   	push   %ebx
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ca3:	0f 84 51 01 00 00    	je     80101dfa <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 12 1a 00 00       	call   801036c0 <myproc>
80101cae:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 13 29 00 00       	call   801045d0 <acquire>
  ip->ref++;
80101cbd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 73 29 00 00       	call   80104640 <release>
80101ccd:	eb 04                	jmp    80101cd3 <namex+0x43>
80101ccf:	90                   	nop
    path++;
80101cd0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cd3:	0f b6 03             	movzbl (%ebx),%eax
80101cd6:	3c 2f                	cmp    $0x2f,%al
80101cd8:	74 f6                	je     80101cd0 <namex+0x40>
  if(*path == 0)
80101cda:	84 c0                	test   %al,%al
80101cdc:	0f 84 ed 00 00 00    	je     80101dcf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101ce2:	0f b6 03             	movzbl (%ebx),%eax
80101ce5:	89 da                	mov    %ebx,%edx
80101ce7:	84 c0                	test   %al,%al
80101ce9:	0f 84 b1 00 00 00    	je     80101da0 <namex+0x110>
80101cef:	3c 2f                	cmp    $0x2f,%al
80101cf1:	75 0f                	jne    80101d02 <namex+0x72>
80101cf3:	e9 a8 00 00 00       	jmp    80101da0 <namex+0x110>
80101cf8:	3c 2f                	cmp    $0x2f,%al
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d00:	74 0a                	je     80101d0c <namex+0x7c>
    path++;
80101d02:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d05:	0f b6 02             	movzbl (%edx),%eax
80101d08:	84 c0                	test   %al,%al
80101d0a:	75 ec                	jne    80101cf8 <namex+0x68>
80101d0c:	89 d1                	mov    %edx,%ecx
80101d0e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d10:	83 f9 0d             	cmp    $0xd,%ecx
80101d13:	0f 8e 8f 00 00 00    	jle    80101da8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d1d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d24:	00 
80101d25:	89 3c 24             	mov    %edi,(%esp)
80101d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d2b:	e8 00 2a 00 00       	call   80104730 <memmove>
    path++;
80101d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d33:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d35:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d38:	75 0e                	jne    80101d48 <namex+0xb8>
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	89 34 24             	mov    %esi,(%esp)
80101d4b:	e8 70 f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d50:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d55:	0f 85 85 00 00 00    	jne    80101de0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d5e:	85 d2                	test   %edx,%edx
80101d60:	74 09                	je     80101d6b <namex+0xdb>
80101d62:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d65:	0f 84 a5 00 00 00    	je     80101e10 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d72:	00 
80101d73:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 51 fe ff ff       	call   80101bd0 <dirlookup>
80101d7f:	85 c0                	test   %eax,%eax
80101d81:	74 5d                	je     80101de0 <namex+0x150>
  iunlock(ip);
80101d83:	89 34 24             	mov    %esi,(%esp)
80101d86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d89:	e8 12 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	89 c6                	mov    %eax,%esi
80101d9b:	e9 33 ff ff ff       	jmp    80101cd3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101da0:	31 c9                	xor    %ecx,%ecx
80101da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101da8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101db0:	89 3c 24             	mov    %edi,(%esp)
80101db3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db9:	e8 72 29 00 00       	call   80104730 <memmove>
    name[len] = 0;
80101dbe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dc8:	89 d3                	mov    %edx,%ebx
80101dca:	e9 66 ff ff ff       	jmp    80101d35 <namex+0xa5>
  }
  if(nameiparent){
80101dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dd2:	85 c0                	test   %eax,%eax
80101dd4:	75 4c                	jne    80101e22 <namex+0x192>
80101dd6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd8:	83 c4 2c             	add    $0x2c,%esp
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
  iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 b8 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101de8:	89 34 24             	mov    %esi,(%esp)
80101deb:	e8 f0 f9 ff ff       	call   801017e0 <iput>
}
80101df0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101df3:	31 c0                	xor    %eax,%eax
}
80101df5:	5b                   	pop    %ebx
80101df6:	5e                   	pop    %esi
80101df7:	5f                   	pop    %edi
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dfa:	ba 01 00 00 00       	mov    $0x1,%edx
80101dff:	b8 01 00 00 00       	mov    $0x1,%eax
80101e04:	e8 17 f4 ff ff       	call   80101220 <iget>
80101e09:	89 c6                	mov    %eax,%esi
80101e0b:	e9 c3 fe ff ff       	jmp    80101cd3 <namex+0x43>
      iunlock(ip);
80101e10:	89 34 24             	mov    %esi,(%esp)
80101e13:	e8 88 f9 ff ff       	call   801017a0 <iunlock>
}
80101e18:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e1b:	89 f0                	mov    %esi,%eax
}
80101e1d:	5b                   	pop    %ebx
80101e1e:	5e                   	pop    %esi
80101e1f:	5f                   	pop    %edi
80101e20:	5d                   	pop    %ebp
80101e21:	c3                   	ret    
    iput(ip);
80101e22:	89 34 24             	mov    %esi,(%esp)
80101e25:	e8 b6 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e2a:	31 c0                	xor    %eax,%eax
80101e2c:	eb aa                	jmp    80101dd8 <namex+0x148>
80101e2e:	66 90                	xchg   %ax,%ax

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 2c             	sub    $0x2c,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e46:	00 
80101e47:	89 1c 24             	mov    %ebx,(%esp)
80101e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e4e:	e8 7d fd ff ff       	call   80101bd0 <dirlookup>
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 8b 00 00 00    	jne    80101ee6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e5e:	31 ff                	xor    %edi,%edi
80101e60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e63:	85 c0                	test   %eax,%eax
80101e65:	75 13                	jne    80101e7a <dirlink+0x4a>
80101e67:	eb 35                	jmp    80101e9e <dirlink+0x6e>
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e70:	8d 57 10             	lea    0x10(%edi),%edx
80101e73:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e76:	89 d7                	mov    %edx,%edi
80101e78:	76 24                	jbe    80101e9e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e7a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e81:	00 
80101e82:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e86:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e8a:	89 1c 24             	mov    %ebx,(%esp)
80101e8d:	e8 de fa ff ff       	call   80101970 <readi>
80101e92:	83 f8 10             	cmp    $0x10,%eax
80101e95:	75 5e                	jne    80101ef5 <dirlink+0xc5>
    if(de.inum == 0)
80101e97:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9c:	75 d2                	jne    80101e70 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ea8:	00 
80101ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ead:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb0:	89 04 24             	mov    %eax,(%esp)
80101eb3:	e8 68 29 00 00       	call   80104820 <strncpy>
  de.inum = inum;
80101eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ec2:	00 
80101ec3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ecb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101ece:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ed2:	e8 99 fb ff ff       	call   80101a70 <writei>
80101ed7:	83 f8 10             	cmp    $0x10,%eax
80101eda:	75 25                	jne    80101f01 <dirlink+0xd1>
  return 0;
80101edc:	31 c0                	xor    %eax,%eax
}
80101ede:	83 c4 2c             	add    $0x2c,%esp
80101ee1:	5b                   	pop    %ebx
80101ee2:	5e                   	pop    %esi
80101ee3:	5f                   	pop    %edi
80101ee4:	5d                   	pop    %ebp
80101ee5:	c3                   	ret    
    iput(ip);
80101ee6:	89 04 24             	mov    %eax,(%esp)
80101ee9:	e8 f2 f8 ff ff       	call   801017e0 <iput>
    return -1;
80101eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef3:	eb e9                	jmp    80101ede <dirlink+0xae>
      panic("dirlink read");
80101ef5:	c7 04 24 88 72 10 80 	movl   $0x80107288,(%esp)
80101efc:	e8 5f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f01:	c7 04 24 ae 78 10 80 	movl   $0x801078ae,(%esp)
80101f08:	e8 53 e4 ff ff       	call   80100360 <panic>
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi

80101f10 <namei>:

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	56                   	push   %esi
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	53                   	push   %ebx
80101f57:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f5a:	85 c0                	test   %eax,%eax
80101f5c:	0f 84 99 00 00 00    	je     80101ffb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f62:	8b 48 08             	mov    0x8(%eax),%ecx
80101f65:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f6b:	0f 87 7e 00 00 00    	ja     80101fef <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f76:	66 90                	xchg   %ax,%ax
80101f78:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f79:	83 e0 c0             	and    $0xffffffc0,%eax
80101f7c:	3c 40                	cmp    $0x40,%al
80101f7e:	75 f8                	jne    80101f78 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f80:	31 db                	xor    %ebx,%ebx
80101f82:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ee                   	out    %al,(%dx)
80101f8a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f94:	ee                   	out    %al,(%dx)
80101f95:	0f b6 c1             	movzbl %cl,%eax
80101f98:	b2 f3                	mov    $0xf3,%dl
80101f9a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f9b:	89 c8                	mov    %ecx,%eax
80101f9d:	b2 f4                	mov    $0xf4,%dl
80101f9f:	c1 f8 08             	sar    $0x8,%eax
80101fa2:	ee                   	out    %al,(%dx)
80101fa3:	b2 f5                	mov    $0xf5,%dl
80101fa5:	89 d8                	mov    %ebx,%eax
80101fa7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fa8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fac:	b2 f6                	mov    $0xf6,%dl
80101fae:	83 e0 01             	and    $0x1,%eax
80101fb1:	c1 e0 04             	shl    $0x4,%eax
80101fb4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fb7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fb8:	f6 06 04             	testb  $0x4,(%esi)
80101fbb:	75 13                	jne    80101fd0 <idestart+0x80>
80101fbd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
80101fcf:	90                   	nop
80101fd0:	b2 f7                	mov    $0xf7,%dl
80101fd2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fd7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fdd:	83 c6 5c             	add    $0x5c,%esi
80101fe0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fe5:	fc                   	cld    
80101fe6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
    panic("incorrect blockno");
80101fef:	c7 04 24 f4 72 10 80 	movl   $0x801072f4,(%esp)
80101ff6:	e8 65 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101ffb:	c7 04 24 eb 72 10 80 	movl   $0x801072eb,(%esp)
80102002:	e8 59 e3 ff ff       	call   80100360 <panic>
80102007:	89 f6                	mov    %esi,%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102016:	c7 44 24 04 06 73 10 	movl   $0x80107306,0x4(%esp)
8010201d:	80 
8010201e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102025:	e8 36 24 00 00       	call   80104460 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010202a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010202f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102036:	83 e8 01             	sub    $0x1,%eax
80102039:	89 44 24 04          	mov    %eax,0x4(%esp)
8010203d:	e8 7e 02 00 00       	call   801022c0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102042:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102047:	90                   	nop
80102048:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102049:	83 e0 c0             	and    $0xffffffc0,%eax
8010204c:	3c 40                	cmp    $0x40,%al
8010204e:	75 f8                	jne    80102048 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102050:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102055:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205a:	ee                   	out    %al,(%dx)
8010205b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102060:	b2 f7                	mov    $0xf7,%dl
80102062:	eb 09                	jmp    8010206d <ideinit+0x5d>
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102068:	83 e9 01             	sub    $0x1,%ecx
8010206b:	74 0f                	je     8010207c <ideinit+0x6c>
8010206d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010206e:	84 c0                	test   %al,%al
80102070:	74 f6                	je     80102068 <ideinit+0x58>
      havedisk1 = 1;
80102072:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102079:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010207c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102081:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102086:	ee                   	out    %al,(%dx)
}
80102087:	c9                   	leave  
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020a0:	e8 2b 25 00 00       	call   801045d0 <acquire>

  if((b = idequeue) == 0){
801020a5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020ab:	85 db                	test   %ebx,%ebx
801020ad:	74 30                	je     801020df <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020af:	8b 43 58             	mov    0x58(%ebx),%eax
801020b2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b7:	8b 33                	mov    (%ebx),%esi
801020b9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020bf:	74 37                	je     801020f8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020c1:	83 e6 fb             	and    $0xfffffffb,%esi
801020c4:	83 ce 02             	or     $0x2,%esi
801020c7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020c9:	89 1c 24             	mov    %ebx,(%esp)
801020cc:	e8 9f 20 00 00       	call   80104170 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 05                	je     801020df <ideintr+0x4f>
    idestart(idequeue);
801020da:	e8 71 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
801020df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020e6:	e8 55 25 00 00       	call   80104640 <release>

  release(&idelock);
}
801020eb:	83 c4 1c             	add    $0x1c,%esp
801020ee:	5b                   	pop    %ebx
801020ef:	5e                   	pop    %esi
801020f0:	5f                   	pop    %edi
801020f1:	5d                   	pop    %ebp
801020f2:	c3                   	ret    
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020fd:	8d 76 00             	lea    0x0(%esi),%esi
80102100:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	89 c1                	mov    %eax,%ecx
80102103:	83 e1 c0             	and    $0xffffffc0,%ecx
80102106:	80 f9 40             	cmp    $0x40,%cl
80102109:	75 f5                	jne    80102100 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010210b:	a8 21                	test   $0x21,%al
8010210d:	75 b2                	jne    801020c1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010210f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102112:	b9 80 00 00 00       	mov    $0x80,%ecx
80102117:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211c:	fc                   	cld    
8010211d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010211f:	8b 33                	mov    (%ebx),%esi
80102121:	eb 9e                	jmp    801020c1 <ideintr+0x31>
80102123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 14             	sub    $0x14,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	89 04 24             	mov    %eax,(%esp)
80102140:	e8 cb 22 00 00       	call   80104410 <holdingsleep>
80102145:	85 c0                	test   %eax,%eax
80102147:	0f 84 9e 00 00 00    	je     801021eb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214d:	8b 03                	mov    (%ebx),%eax
8010214f:	83 e0 06             	and    $0x6,%eax
80102152:	83 f8 02             	cmp    $0x2,%eax
80102155:	0f 84 a8 00 00 00    	je     80102203 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215b:	8b 53 04             	mov    0x4(%ebx),%edx
8010215e:	85 d2                	test   %edx,%edx
80102160:	74 0d                	je     8010216f <iderw+0x3f>
80102162:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102167:	85 c0                	test   %eax,%eax
80102169:	0f 84 88 00 00 00    	je     801021f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010216f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102176:	e8 55 24 00 00       	call   801045d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102180:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102187:	85 c0                	test   %eax,%eax
80102189:	75 07                	jne    80102192 <iderw+0x62>
8010218b:	eb 4e                	jmp    801021db <iderw+0xab>
8010218d:	8d 76 00             	lea    0x0(%esi),%esi
80102190:	89 d0                	mov    %edx,%eax
80102192:	8b 50 58             	mov    0x58(%eax),%edx
80102195:	85 d2                	test   %edx,%edx
80102197:	75 f7                	jne    80102190 <iderw+0x60>
80102199:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010219c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010219e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021a4:	74 3c                	je     801021e2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a6:	8b 03                	mov    (%ebx),%eax
801021a8:	83 e0 06             	and    $0x6,%eax
801021ab:	83 f8 02             	cmp    $0x2,%eax
801021ae:	74 1a                	je     801021ca <iderw+0x9a>
    sleep(b, &idelock);
801021b0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021b7:	80 
801021b8:	89 1c 24             	mov    %ebx,(%esp)
801021bb:	e8 f0 1b 00 00       	call   80103db0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c0:	8b 13                	mov    (%ebx),%edx
801021c2:	83 e2 06             	and    $0x6,%edx
801021c5:	83 fa 02             	cmp    $0x2,%edx
801021c8:	75 e6                	jne    801021b0 <iderw+0x80>
  }


  release(&idelock);
801021ca:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021d1:	83 c4 14             	add    $0x14,%esp
801021d4:	5b                   	pop    %ebx
801021d5:	5d                   	pop    %ebp
  release(&idelock);
801021d6:	e9 65 24 00 00       	jmp    80104640 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021e0:	eb ba                	jmp    8010219c <iderw+0x6c>
    idestart(b);
801021e2:	89 d8                	mov    %ebx,%eax
801021e4:	e8 67 fd ff ff       	call   80101f50 <idestart>
801021e9:	eb bb                	jmp    801021a6 <iderw+0x76>
    panic("iderw: buf not locked");
801021eb:	c7 04 24 0a 73 10 80 	movl   $0x8010730a,(%esp)
801021f2:	e8 69 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021f7:	c7 04 24 35 73 10 80 	movl   $0x80107335,(%esp)
801021fe:	e8 5d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102203:	c7 04 24 20 73 10 80 	movl   $0x80107320,(%esp)
8010220a:	e8 51 e1 ff ff       	call   80100360 <panic>
8010220f:	90                   	nop

80102210 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	56                   	push   %esi
80102214:	53                   	push   %ebx
80102215:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102218:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010221f:	00 c0 fe 
  ioapic->reg = reg;
80102222:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102229:	00 00 00 
  return ioapic->data;
8010222c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102232:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102235:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010223b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102241:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102248:	c1 e8 10             	shr    $0x10,%eax
8010224b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010224e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102251:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102254:	39 c2                	cmp    %eax,%edx
80102256:	74 12                	je     8010226a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102258:	c7 04 24 54 73 10 80 	movl   $0x80107354,(%esp)
8010225f:	e8 ec e3 ff ff       	call   80100650 <cprintf>
80102264:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010226a:	ba 10 00 00 00       	mov    $0x10,%edx
8010226f:	31 c0                	xor    %eax,%eax
80102271:	eb 07                	jmp    8010227a <ioapicinit+0x6a>
80102273:	90                   	nop
80102274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102278:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010227a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010227c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102282:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102285:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010228b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010228e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102291:	8d 4a 01             	lea    0x1(%edx),%ecx
80102294:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102297:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102299:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010229f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022a1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022a8:	7d ce                	jge    80102278 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	5b                   	pop    %ebx
801022ae:	5e                   	pop    %esi
801022af:	5d                   	pop    %ebp
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ioapicenable>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 55 08             	mov    0x8(%ebp),%edx
801022c6:	53                   	push   %ebx
801022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ca:	8d 5a 20             	lea    0x20(%edx),%ebx
801022cd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022d1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022da:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022dc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022e5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022e8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ea:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022f0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022f3:	5b                   	pop    %ebx
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	66 90                	xchg   %ax,%ax
801022f8:	66 90                	xchg   %ax,%ax
801022fa:	66 90                	xchg   %ax,%ax
801022fc:	66 90                	xchg   %ax,%ax
801022fe:	66 90                	xchg   %ax,%ax

80102300 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 14             	sub    $0x14,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010230a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102310:	75 7c                	jne    8010238e <kfree+0x8e>
80102312:	81 fb a8 57 11 80    	cmp    $0x801157a8,%ebx
80102318:	72 74                	jb     8010238e <kfree+0x8e>
8010231a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102320:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102325:	77 67                	ja     8010238e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102327:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010232e:	00 
8010232f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102336:	00 
80102337:	89 1c 24             	mov    %ebx,(%esp)
8010233a:	e8 51 23 00 00       	call   80104690 <memset>

  if(kmem.use_lock)
8010233f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102345:	85 d2                	test   %edx,%edx
80102347:	75 37                	jne    80102380 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102349:	a1 78 26 11 80       	mov    0x80112678,%eax
8010234e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102350:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102355:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010235b:	85 c0                	test   %eax,%eax
8010235d:	75 09                	jne    80102368 <kfree+0x68>
    release(&kmem.lock);
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
80102364:	c3                   	ret    
80102365:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102368:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
    release(&kmem.lock);
80102374:	e9 c7 22 00 00       	jmp    80104640 <release>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102380:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102387:	e8 44 22 00 00       	call   801045d0 <acquire>
8010238c:	eb bb                	jmp    80102349 <kfree+0x49>
    panic("kfree");
8010238e:	c7 04 24 86 73 10 80 	movl   $0x80107386,(%esp)
80102395:	e8 c6 df ff ff       	call   80100360 <panic>
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023a8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023c0:	39 de                	cmp    %ebx,%esi
801023c2:	73 08                	jae    801023cc <freerange+0x2c>
801023c4:	eb 18                	jmp    801023de <freerange+0x3e>
801023c6:	66 90                	xchg   %ax,%ax
801023c8:	89 da                	mov    %ebx,%edx
801023ca:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023cc:	89 14 24             	mov    %edx,(%esp)
801023cf:	e8 2c ff ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023da:	39 f0                	cmp    %esi,%eax
801023dc:	76 ea                	jbe    801023c8 <freerange+0x28>
}
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	5b                   	pop    %ebx
801023e2:	5e                   	pop    %esi
801023e3:	5d                   	pop    %ebp
801023e4:	c3                   	ret    
801023e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	83 ec 10             	sub    $0x10,%esp
801023f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023fb:	c7 44 24 04 8c 73 10 	movl   $0x8010738c,0x4(%esp)
80102402:	80 
80102403:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010240a:	e8 51 20 00 00       	call   80104460 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102412:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102419:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102422:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102428:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010242e:	39 de                	cmp    %ebx,%esi
80102430:	73 0a                	jae    8010243c <kinit1+0x4c>
80102432:	eb 1a                	jmp    8010244e <kinit1+0x5e>
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102438:	89 da                	mov    %ebx,%edx
8010243a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010243c:	89 14 24             	mov    %edx,(%esp)
8010243f:	e8 bc fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102444:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010244a:	39 c6                	cmp    %eax,%esi
8010244c:	73 ea                	jae    80102438 <kinit1+0x48>
}
8010244e:	83 c4 10             	add    $0x10,%esp
80102451:	5b                   	pop    %ebx
80102452:	5e                   	pop    %esi
80102453:	5d                   	pop    %ebp
80102454:	c3                   	ret    
80102455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102468:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010246b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102474:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 08                	jae    8010248c <kinit2+0x2c>
80102484:	eb 18                	jmp    8010249e <kinit2+0x3e>
80102486:	66 90                	xchg   %ax,%ax
80102488:	89 da                	mov    %ebx,%edx
8010248a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010248c:	89 14 24             	mov    %edx,(%esp)
8010248f:	e8 6c fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102494:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010249a:	39 c6                	cmp    %eax,%esi
8010249c:	73 ea                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
8010249e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024a5:	00 00 00 
}
801024a8:	83 c4 10             	add    $0x10,%esp
801024ab:	5b                   	pop    %ebx
801024ac:	5e                   	pop    %esi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret    
801024af:	90                   	nop

801024b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024bc:	85 c0                	test   %eax,%eax
801024be:	75 30                	jne    801024f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024c6:	85 db                	test   %ebx,%ebx
801024c8:	74 08                	je     801024d2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ca:	8b 13                	mov    (%ebx),%edx
801024cc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024d2:	85 c0                	test   %eax,%eax
801024d4:	74 0c                	je     801024e2 <kalloc+0x32>
    release(&kmem.lock);
801024d6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024dd:	e8 5e 21 00 00       	call   80104640 <release>
  return (char*)r;
}
801024e2:	83 c4 14             	add    $0x14,%esp
801024e5:	89 d8                	mov    %ebx,%eax
801024e7:	5b                   	pop    %ebx
801024e8:	5d                   	pop    %ebp
801024e9:	c3                   	ret    
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024f0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024f7:	e8 d4 20 00 00       	call   801045d0 <acquire>
801024fc:	a1 74 26 11 80       	mov    0x80112674,%eax
80102501:	eb bd                	jmp    801024c0 <kalloc+0x10>
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102510:	ba 64 00 00 00       	mov    $0x64,%edx
80102515:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102516:	a8 01                	test   $0x1,%al
80102518:	0f 84 ba 00 00 00    	je     801025d8 <kbdgetc+0xc8>
8010251e:	b2 60                	mov    $0x60,%dl
80102520:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102521:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102524:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010252a:	0f 84 88 00 00 00    	je     801025b8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102530:	84 c0                	test   %al,%al
80102532:	79 2c                	jns    80102560 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102534:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010253a:	f6 c2 40             	test   $0x40,%dl
8010253d:	75 05                	jne    80102544 <kbdgetc+0x34>
8010253f:	89 c1                	mov    %eax,%ecx
80102541:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102544:	0f b6 81 c0 74 10 80 	movzbl -0x7fef8b40(%ecx),%eax
8010254b:	83 c8 40             	or     $0x40,%eax
8010254e:	0f b6 c0             	movzbl %al,%eax
80102551:	f7 d0                	not    %eax
80102553:	21 d0                	and    %edx,%eax
80102555:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010255a:	31 c0                	xor    %eax,%eax
8010255c:	c3                   	ret    
8010255d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010256a:	f6 c3 40             	test   $0x40,%bl
8010256d:	74 09                	je     80102578 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102572:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102575:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102578:	0f b6 91 c0 74 10 80 	movzbl -0x7fef8b40(%ecx),%edx
  shift ^= togglecode[data];
8010257f:	0f b6 81 c0 73 10 80 	movzbl -0x7fef8c40(%ecx),%eax
  shift |= shiftcode[data];
80102586:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102588:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010258a:	89 d0                	mov    %edx,%eax
8010258c:	83 e0 03             	and    $0x3,%eax
8010258f:	8b 04 85 a0 73 10 80 	mov    -0x7fef8c60(,%eax,4),%eax
  shift ^= togglecode[data];
80102596:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010259c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010259f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025a3:	74 0b                	je     801025b0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a8:	83 fa 19             	cmp    $0x19,%edx
801025ab:	77 1b                	ja     801025c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025ad:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b0:	5b                   	pop    %ebx
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	90                   	nop
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025b8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025bf:	31 c0                	xor    %eax,%eax
801025c1:	c3                   	ret    
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025cb:	8d 50 20             	lea    0x20(%eax),%edx
801025ce:	83 f9 19             	cmp    $0x19,%ecx
801025d1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025d4:	eb da                	jmp    801025b0 <kbdgetc+0xa0>
801025d6:	66 90                	xchg   %ax,%ax
    return -1;
801025d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025e6:	c7 04 24 10 25 10 80 	movl   $0x80102510,(%esp)
801025ed:	e8 be e1 ff ff       	call   801007b0 <consoleintr>
}
801025f2:	c9                   	leave  
801025f3:	c3                   	ret    
801025f4:	66 90                	xchg   %ax,%ax
801025f6:	66 90                	xchg   %ax,%ax
801025f8:	66 90                	xchg   %ax,%ax
801025fa:	66 90                	xchg   %ax,%ax
801025fc:	66 90                	xchg   %ax,%ax
801025fe:	66 90                	xchg   %ax,%ax

80102600 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
80102600:	55                   	push   %ebp
80102601:	89 c1                	mov    %eax,%ecx
80102603:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102605:	ba 70 00 00 00       	mov    $0x70,%edx
8010260a:	53                   	push   %ebx
8010260b:	31 c0                	xor    %eax,%eax
8010260d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010260e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102616:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 01                	mov    %eax,(%ecx)
8010261d:	b8 02 00 00 00       	mov    $0x2,%eax
80102622:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102623:	89 da                	mov    %ebx,%edx
80102625:	ec                   	in     (%dx),%al
80102626:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102629:	b2 70                	mov    $0x70,%dl
8010262b:	89 41 04             	mov    %eax,0x4(%ecx)
8010262e:	b8 04 00 00 00       	mov    $0x4,%eax
80102633:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102634:	89 da                	mov    %ebx,%edx
80102636:	ec                   	in     (%dx),%al
80102637:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263a:	b2 70                	mov    $0x70,%dl
8010263c:	89 41 08             	mov    %eax,0x8(%ecx)
8010263f:	b8 07 00 00 00       	mov    $0x7,%eax
80102644:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102645:	89 da                	mov    %ebx,%edx
80102647:	ec                   	in     (%dx),%al
80102648:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264b:	b2 70                	mov    $0x70,%dl
8010264d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102650:	b8 08 00 00 00       	mov    $0x8,%eax
80102655:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102656:	89 da                	mov    %ebx,%edx
80102658:	ec                   	in     (%dx),%al
80102659:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265c:	b2 70                	mov    $0x70,%dl
8010265e:	89 41 10             	mov    %eax,0x10(%ecx)
80102661:	b8 09 00 00 00       	mov    $0x9,%eax
80102666:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102667:	89 da                	mov    %ebx,%edx
80102669:	ec                   	in     (%dx),%al
8010266a:	0f b6 d8             	movzbl %al,%ebx
8010266d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102670:	5b                   	pop    %ebx
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <lapicinit>:
  if(!lapic)
80102680:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102688:	85 c0                	test   %eax,%eax
8010268a:	0f 84 c0 00 00 00    	je     80102750 <lapicinit+0xd0>
  lapic[index] = value;
80102690:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102697:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026de:	8b 50 30             	mov    0x30(%eax),%edx
801026e1:	c1 ea 10             	shr    $0x10,%edx
801026e4:	80 fa 03             	cmp    $0x3,%dl
801026e7:	77 6f                	ja     80102758 <lapicinit+0xd8>
  lapic[index] = value;
801026e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102700:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102703:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102710:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102717:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102724:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102727:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010272a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102731:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102734:	8b 50 20             	mov    0x20(%eax),%edx
80102737:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102738:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010273e:	80 e6 10             	and    $0x10,%dh
80102741:	75 f5                	jne    80102738 <lapicinit+0xb8>
  lapic[index] = value;
80102743:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102750:	5d                   	pop    %ebp
80102751:	c3                   	ret    
80102752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102758:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010275f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102762:	8b 50 20             	mov    0x20(%eax),%edx
80102765:	eb 82                	jmp    801026e9 <lapicinit+0x69>
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:
  if (!lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0c                	je     80102788 <lapicid+0x18>
  return lapic[ID] >> 24;
8010277c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010277f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102780:	c1 e8 18             	shr    $0x18,%eax
}
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102788:	31 c0                	xor    %eax,%eax
}
8010278a:	5d                   	pop    %ebp
8010278b:	c3                   	ret    
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <lapiceoi>:
  if(lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:
{
801027c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	89 e5                	mov    %esp,%ebp
801027c8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	b2 71                	mov    $0x71,%dl
801027dc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027dd:	31 c0                	xor    %eax,%eax
801027df:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027e5:	89 d8                	mov    %ebx,%eax
801027e7:	c1 e8 04             	shr    $0x4,%eax
801027ea:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801027f5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801027fb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102801:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102804:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010280b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102818:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102827:	89 da                	mov    %ebx,%edx
80102829:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010282c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102832:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102835:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010283e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 40 20             	mov    0x20(%eax),%eax
}
80102847:	5b                   	pop    %ebx
80102848:	5d                   	pop    %ebp
80102849:	c3                   	ret    
8010284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102850 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	ba 70 00 00 00       	mov    $0x70,%edx
80102856:	89 e5                	mov    %esp,%ebp
80102858:	b8 0b 00 00 00       	mov    $0xb,%eax
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	b2 71                	mov    $0x71,%dl
80102866:	ec                   	in     (%dx),%al
80102867:	88 45 b7             	mov    %al,-0x49(%ebp)
8010286a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010286d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102871:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010287d:	89 d8                	mov    %ebx,%eax
8010287f:	e8 7c fd ff ff       	call   80102600 <fill_rtcdate>
80102884:	b8 0a 00 00 00       	mov    $0xa,%eax
80102889:	89 f2                	mov    %esi,%edx
8010288b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	ba 71 00 00 00       	mov    $0x71,%edx
80102891:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102892:	84 c0                	test   %al,%al
80102894:	78 e7                	js     8010287d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102896:	89 f8                	mov    %edi,%eax
80102898:	e8 63 fd ff ff       	call   80102600 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010289d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028a4:	00 
801028a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028a9:	89 1c 24             	mov    %ebx,(%esp)
801028ac:	e8 2f 1e 00 00       	call   801046e0 <memcmp>
801028b1:	85 c0                	test   %eax,%eax
801028b3:	75 c3                	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028b5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028b9:	75 78                	jne    80102933 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028be:	89 c2                	mov    %eax,%edx
801028c0:	83 e0 0f             	and    $0xf,%eax
801028c3:	c1 ea 04             	shr    $0x4,%edx
801028c6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028c9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028cc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028d2:	89 c2                	mov    %eax,%edx
801028d4:	83 e0 0f             	and    $0xf,%eax
801028d7:	c1 ea 04             	shr    $0x4,%edx
801028da:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028dd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028e6:	89 c2                	mov    %eax,%edx
801028e8:	83 e0 0f             	and    $0xf,%eax
801028eb:	c1 ea 04             	shr    $0x4,%edx
801028ee:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028fa:	89 c2                	mov    %eax,%edx
801028fc:	83 e0 0f             	and    $0xf,%eax
801028ff:	c1 ea 04             	shr    $0x4,%edx
80102902:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102905:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102908:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010290b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010290e:	89 c2                	mov    %eax,%edx
80102910:	83 e0 0f             	and    $0xf,%eax
80102913:	c1 ea 04             	shr    $0x4,%edx
80102916:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102919:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010291f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102922:	89 c2                	mov    %eax,%edx
80102924:	83 e0 0f             	and    $0xf,%eax
80102927:	c1 ea 04             	shr    $0x4,%edx
8010292a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102930:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102933:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102936:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102939:	89 01                	mov    %eax,(%ecx)
8010293b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010293e:	89 41 04             	mov    %eax,0x4(%ecx)
80102941:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102944:	89 41 08             	mov    %eax,0x8(%ecx)
80102947:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010294a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010294d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102950:	89 41 10             	mov    %eax,0x10(%ecx)
80102953:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102956:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102959:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102960:	83 c4 4c             	add    $0x4c,%esp
80102963:	5b                   	pop    %ebx
80102964:	5e                   	pop    %esi
80102965:	5f                   	pop    %edi
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    
80102968:	66 90                	xchg   %ax,%ax
8010296a:	66 90                	xchg   %ax,%ax
8010296c:	66 90                	xchg   %ax,%ax
8010296e:	66 90                	xchg   %ax,%ax

80102970 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	57                   	push   %edi
80102974:	56                   	push   %esi
80102975:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102976:	31 db                	xor    %ebx,%ebx
{
80102978:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010297b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102980:	85 c0                	test   %eax,%eax
80102982:	7e 78                	jle    801029fc <install_trans+0x8c>
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102988:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010298d:	01 d8                	add    %ebx,%eax
8010298f:	83 c0 01             	add    $0x1,%eax
80102992:	89 44 24 04          	mov    %eax,0x4(%esp)
80102996:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010299b:	89 04 24             	mov    %eax,(%esp)
8010299e:	e8 2d d7 ff ff       	call   801000d0 <bread>
801029a3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029ac:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029af:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029b8:	89 04 24             	mov    %eax,(%esp)
801029bb:	e8 10 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029c7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029c8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ca:	8d 47 5c             	lea    0x5c(%edi),%eax
801029cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029d4:	89 04 24             	mov    %eax,(%esp)
801029d7:	e8 54 1d 00 00       	call   80104730 <memmove>
    bwrite(dbuf);  // write dst to disk
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 bc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029e4:	89 3c 24             	mov    %edi,(%esp)
801029e7:	e8 f4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029ec:	89 34 24             	mov    %esi,(%esp)
801029ef:	e8 ec d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029f4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029fa:	7f 8c                	jg     80102988 <install_trans+0x18>
  }
}
801029fc:	83 c4 1c             	add    $0x1c,%esp
801029ff:	5b                   	pop    %ebx
80102a00:	5e                   	pop    %esi
80102a01:	5f                   	pop    %edi
80102a02:	5d                   	pop    %ebp
80102a03:	c3                   	ret    
80102a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	57                   	push   %edi
80102a14:	56                   	push   %esi
80102a15:	53                   	push   %ebx
80102a16:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a19:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a22:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a27:	89 04 24             	mov    %eax,(%esp)
80102a2a:	e8 a1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a2f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a35:	31 d2                	xor    %edx,%edx
80102a37:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a39:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a3b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a3e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a41:	7e 17                	jle    80102a5a <write_head+0x4a>
80102a43:	90                   	nop
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a48:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a4f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a53:	83 c2 01             	add    $0x1,%edx
80102a56:	39 da                	cmp    %ebx,%edx
80102a58:	75 ee                	jne    80102a48 <write_head+0x38>
  }
  bwrite(buf);
80102a5a:	89 3c 24             	mov    %edi,(%esp)
80102a5d:	e8 3e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a62:	89 3c 24             	mov    %edi,(%esp)
80102a65:	e8 76 d7 ff ff       	call   801001e0 <brelse>
}
80102a6a:	83 c4 1c             	add    $0x1c,%esp
80102a6d:	5b                   	pop    %ebx
80102a6e:	5e                   	pop    %esi
80102a6f:	5f                   	pop    %edi
80102a70:	5d                   	pop    %ebp
80102a71:	c3                   	ret    
80102a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <initlog>:
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	56                   	push   %esi
80102a84:	53                   	push   %ebx
80102a85:	83 ec 30             	sub    $0x30,%esp
80102a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a8b:	c7 44 24 04 c0 75 10 	movl   $0x801075c0,0x4(%esp)
80102a92:	80 
80102a93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a9a:	e8 c1 19 00 00       	call   80104460 <initlock>
  readsb(dev, &sb);
80102a9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa6:	89 1c 24             	mov    %ebx,(%esp)
80102aa9:	e8 f2 e8 ff ff       	call   801013a0 <readsb>
  log.start = sb.logstart;
80102aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ab1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102ab4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102ab7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102ac1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ac7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102acc:	e8 ff d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ad1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102ad3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ad6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102adb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	7e 17                	jle    80102afa <initlog+0x7a>
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ae8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102aec:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102af3:	83 c2 01             	add    $0x1,%edx
80102af6:	39 da                	cmp    %ebx,%edx
80102af8:	75 ee                	jne    80102ae8 <initlog+0x68>
  brelse(buf);
80102afa:	89 04 24             	mov    %eax,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b02:	e8 69 fe ff ff       	call   80102970 <install_trans>
  log.lh.n = 0;
80102b07:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b0e:	00 00 00 
  write_head(); // clear the log
80102b11:	e8 fa fe ff ff       	call   80102a10 <write_head>
}
80102b16:	83 c4 30             	add    $0x30,%esp
80102b19:	5b                   	pop    %ebx
80102b1a:	5e                   	pop    %esi
80102b1b:	5d                   	pop    %ebp
80102b1c:	c3                   	ret    
80102b1d:	8d 76 00             	lea    0x0(%esi),%esi

80102b20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b26:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b2d:	e8 9e 1a 00 00       	call   801045d0 <acquire>
80102b32:	eb 18                	jmp    80102b4c <begin_op+0x2c>
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b38:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b3f:	80 
80102b40:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b47:	e8 64 12 00 00       	call   80103db0 <sleep>
    if(log.committing){
80102b4c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b51:	85 c0                	test   %eax,%eax
80102b53:	75 e3                	jne    80102b38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b55:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b5a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b60:	83 c0 01             	add    $0x1,%eax
80102b63:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b66:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b69:	83 fa 1e             	cmp    $0x1e,%edx
80102b6c:	7f ca                	jg     80102b38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b6e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b75:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b7a:	e8 c1 1a 00 00       	call   80104640 <release>
      break;
    }
  }
}
80102b7f:	c9                   	leave  
80102b80:	c3                   	ret    
80102b81:	eb 0d                	jmp    80102b90 <end_op>
80102b83:	90                   	nop
80102b84:	90                   	nop
80102b85:	90                   	nop
80102b86:	90                   	nop
80102b87:	90                   	nop
80102b88:	90                   	nop
80102b89:	90                   	nop
80102b8a:	90                   	nop
80102b8b:	90                   	nop
80102b8c:	90                   	nop
80102b8d:	90                   	nop
80102b8e:	90                   	nop
80102b8f:	90                   	nop

80102b90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b99:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ba0:	e8 2b 1a 00 00       	call   801045d0 <acquire>
  log.outstanding -= 1;
80102ba5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102baa:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102bb0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bb3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bb5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bba:	0f 85 f3 00 00 00    	jne    80102cb3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bc0:	85 c0                	test   %eax,%eax
80102bc2:	0f 85 cb 00 00 00    	jne    80102c93 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bc8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bcf:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102bd1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bd8:	00 00 00 
  release(&log.lock);
80102bdb:	e8 60 1a 00 00       	call   80104640 <release>
  if (log.lh.n > 0) {
80102be0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102be5:	85 c0                	test   %eax,%eax
80102be7:	0f 8e 90 00 00 00    	jle    80102c7d <end_op+0xed>
80102bed:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bf0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bf5:	01 d8                	add    %ebx,%eax
80102bf7:	83 c0 01             	add    $0x1,%eax
80102bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfe:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c03:	89 04 24             	mov    %eax,(%esp)
80102c06:	e8 c5 d4 ff ff       	call   801000d0 <bread>
80102c0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c0d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c14:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c20:	89 04 24             	mov    %eax,(%esp)
80102c23:	e8 a8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c28:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c2f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c30:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c32:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c35:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c39:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3c:	89 04 24             	mov    %eax,(%esp)
80102c3f:	e8 ec 1a 00 00       	call   80104730 <memmove>
    bwrite(to);  // write the log
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 54 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c4c:	89 3c 24             	mov    %edi,(%esp)
80102c4f:	e8 8c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c54:	89 34 24             	mov    %esi,(%esp)
80102c57:	e8 84 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c5c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c62:	7c 8c                	jl     80102bf0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c64:	e8 a7 fd ff ff       	call   80102a10 <write_head>
    install_trans(); // Now install writes to home locations
80102c69:	e8 02 fd ff ff       	call   80102970 <install_trans>
    log.lh.n = 0;
80102c6e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c75:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c78:	e8 93 fd ff ff       	call   80102a10 <write_head>
    acquire(&log.lock);
80102c7d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c84:	e8 47 19 00 00       	call   801045d0 <acquire>
    log.committing = 0;
80102c89:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c90:	00 00 00 
    wakeup(&log);
80102c93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c9a:	e8 d1 14 00 00       	call   80104170 <wakeup>
    release(&log.lock);
80102c9f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca6:	e8 95 19 00 00       	call   80104640 <release>
}
80102cab:	83 c4 1c             	add    $0x1c,%esp
80102cae:	5b                   	pop    %ebx
80102caf:	5e                   	pop    %esi
80102cb0:	5f                   	pop    %edi
80102cb1:	5d                   	pop    %ebp
80102cb2:	c3                   	ret    
    panic("log.committing");
80102cb3:	c7 04 24 c4 75 10 80 	movl   $0x801075c4,(%esp)
80102cba:	e8 a1 d6 ff ff       	call   80100360 <panic>
80102cbf:	90                   	nop

80102cc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cc7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102ccc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ccf:	83 f8 1d             	cmp    $0x1d,%eax
80102cd2:	0f 8f 98 00 00 00    	jg     80102d70 <log_write+0xb0>
80102cd8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cde:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102ce1:	39 d0                	cmp    %edx,%eax
80102ce3:	0f 8d 87 00 00 00    	jge    80102d70 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ce9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cee:	85 c0                	test   %eax,%eax
80102cf0:	0f 8e 86 00 00 00    	jle    80102d7c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cf6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cfd:	e8 ce 18 00 00       	call   801045d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d02:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d08:	83 fa 00             	cmp    $0x0,%edx
80102d0b:	7e 54                	jle    80102d61 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d0d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d10:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d12:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d18:	75 0f                	jne    80102d29 <log_write+0x69>
80102d1a:	eb 3c                	jmp    80102d58 <log_write+0x98>
80102d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d20:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d27:	74 2f                	je     80102d58 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d29:	83 c0 01             	add    $0x1,%eax
80102d2c:	39 d0                	cmp    %edx,%eax
80102d2e:	75 f0                	jne    80102d20 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d30:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d37:	83 c2 01             	add    $0x1,%edx
80102d3a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d40:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d43:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d4a:	83 c4 14             	add    $0x14,%esp
80102d4d:	5b                   	pop    %ebx
80102d4e:	5d                   	pop    %ebp
  release(&log.lock);
80102d4f:	e9 ec 18 00 00       	jmp    80104640 <release>
80102d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d58:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d5f:	eb df                	jmp    80102d40 <log_write+0x80>
80102d61:	8b 43 08             	mov    0x8(%ebx),%eax
80102d64:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d69:	75 d5                	jne    80102d40 <log_write+0x80>
80102d6b:	eb ca                	jmp    80102d37 <log_write+0x77>
80102d6d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d70:	c7 04 24 d3 75 10 80 	movl   $0x801075d3,(%esp)
80102d77:	e8 e4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d7c:	c7 04 24 e9 75 10 80 	movl   $0x801075e9,(%esp)
80102d83:	e8 d8 d5 ff ff       	call   80100360 <panic>
80102d88:	66 90                	xchg   %ax,%ax
80102d8a:	66 90                	xchg   %ax,%ax
80102d8c:	66 90                	xchg   %ax,%ax
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d97:	e8 04 09 00 00       	call   801036a0 <cpuid>
80102d9c:	89 c3                	mov    %eax,%ebx
80102d9e:	e8 fd 08 00 00       	call   801036a0 <cpuid>
80102da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102da7:	c7 04 24 04 76 10 80 	movl   $0x80107604,(%esp)
80102dae:	89 44 24 04          	mov    %eax,0x4(%esp)
80102db2:	e8 99 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102db7:	e8 f4 2b 00 00       	call   801059b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dbc:	e8 5f 08 00 00       	call   80103620 <mycpu>
80102dc1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dc3:	b8 01 00 00 00       	mov    $0x1,%eax
80102dc8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dcf:	e8 ac 0b 00 00       	call   80103980 <scheduler>
80102dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102de0 <mpenter>:
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102de6:	e8 85 3c 00 00       	call   80106a70 <switchkvm>
  seginit();
80102deb:	e8 c0 3b 00 00       	call   801069b0 <seginit>
  lapicinit();
80102df0:	e8 8b f8 ff ff       	call   80102680 <lapicinit>
  mpmain();
80102df5:	e8 96 ff ff ff       	call   80102d90 <mpmain>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <main>:
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e04:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e09:	83 e4 f0             	and    $0xfffffff0,%esp
80102e0c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e0f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e16:	80 
80102e17:	c7 04 24 a8 57 11 80 	movl   $0x801157a8,(%esp)
80102e1e:	e8 cd f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102e23:	e8 d8 40 00 00       	call   80106f00 <kvmalloc>
  mpinit();        // detect other processors
80102e28:	e8 73 01 00 00       	call   80102fa0 <mpinit>
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e30:	e8 4b f8 ff ff       	call   80102680 <lapicinit>
  seginit();       // segment descriptors
80102e35:	e8 76 3b 00 00       	call   801069b0 <seginit>
  picinit();       // disable pic
80102e3a:	e8 21 03 00 00       	call   80103160 <picinit>
80102e3f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e40:	e8 cb f3 ff ff       	call   80102210 <ioapicinit>
  consoleinit();   // console hardware
80102e45:	e8 06 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e4a:	e8 81 2e 00 00       	call   80105cd0 <uartinit>
80102e4f:	90                   	nop
  pinit();         // process table
80102e50:	e8 ab 07 00 00       	call   80103600 <pinit>
  tvinit();        // trap vectors
80102e55:	e8 b6 2a 00 00       	call   80105910 <tvinit>
  binit();         // buffer cache
80102e5a:	e8 e1 d1 ff ff       	call   80100040 <binit>
80102e5f:	90                   	nop
  fileinit();      // file table
80102e60:	e8 eb de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102e65:	e8 a6 f1 ff ff       	call   80102010 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e6a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e71:	00 
80102e72:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e79:	80 
80102e7a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e81:	e8 aa 18 00 00       	call   80104730 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e86:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e8d:	00 00 00 
80102e90:	05 80 27 11 80       	add    $0x80112780,%eax
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	76 6a                	jbe    80102f03 <main+0x103>
80102e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ea0:	e8 7b 07 00 00       	call   80103620 <mycpu>
80102ea5:	39 d8                	cmp    %ebx,%eax
80102ea7:	74 41                	je     80102eea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ea9:	e8 02 f6 ff ff       	call   801024b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102eae:	c7 05 f8 6f 00 80 e0 	movl   $0x80102de0,0x80006ff8
80102eb5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102eb8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ebf:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ec2:	05 00 10 00 00       	add    $0x1000,%eax
80102ec7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102ecc:	0f b6 03             	movzbl (%ebx),%eax
80102ecf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ed6:	00 
80102ed7:	89 04 24             	mov    %eax,(%esp)
80102eda:	e8 e1 f8 ff ff       	call   801027c0 <lapicstartap>
80102edf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ee0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	74 f6                	je     80102ee0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102eea:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ef1:	00 00 00 
80102ef4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102efa:	05 80 27 11 80       	add    $0x80112780,%eax
80102eff:	39 c3                	cmp    %eax,%ebx
80102f01:	72 9d                	jb     80102ea0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f03:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f0a:	8e 
80102f0b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f12:	e8 49 f5 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102f17:	e8 d4 07 00 00       	call   801036f0 <userinit>
  mpmain();        // finish this processor's setup
80102f1c:	e8 6f fe ff ff       	call   80102d90 <mpmain>
80102f21:	66 90                	xchg   %ax,%ax
80102f23:	66 90                	xchg   %ax,%ax
80102f25:	66 90                	xchg   %ax,%ax
80102f27:	66 90                	xchg   %ax,%ax
80102f29:	66 90                	xchg   %ax,%ax
80102f2b:	66 90                	xchg   %ax,%ax
80102f2d:	66 90                	xchg   %ax,%ax
80102f2f:	90                   	nop

80102f30 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f34:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f3a:	53                   	push   %ebx
  e = addr+len;
80102f3b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f3e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f41:	39 de                	cmp    %ebx,%esi
80102f43:	73 3c                	jae    80102f81 <mpsearch1+0x51>
80102f45:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f48:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f4f:	00 
80102f50:	c7 44 24 04 18 76 10 	movl   $0x80107618,0x4(%esp)
80102f57:	80 
80102f58:	89 34 24             	mov    %esi,(%esp)
80102f5b:	e8 80 17 00 00       	call   801046e0 <memcmp>
80102f60:	85 c0                	test   %eax,%eax
80102f62:	75 16                	jne    80102f7a <mpsearch1+0x4a>
80102f64:	31 c9                	xor    %ecx,%ecx
80102f66:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f68:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f6c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f6f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f71:	83 fa 10             	cmp    $0x10,%edx
80102f74:	75 f2                	jne    80102f68 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f76:	84 c9                	test   %cl,%cl
80102f78:	74 10                	je     80102f8a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f7a:	83 c6 10             	add    $0x10,%esi
80102f7d:	39 f3                	cmp    %esi,%ebx
80102f7f:	77 c7                	ja     80102f48 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f81:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f84:	31 c0                	xor    %eax,%eax
}
80102f86:	5b                   	pop    %ebx
80102f87:	5e                   	pop    %esi
80102f88:	5d                   	pop    %ebp
80102f89:	c3                   	ret    
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	89 f0                	mov    %esi,%eax
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5d                   	pop    %ebp
80102f92:	c3                   	ret    
80102f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fa9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fb0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fb7:	c1 e0 08             	shl    $0x8,%eax
80102fba:	09 d0                	or     %edx,%eax
80102fbc:	c1 e0 04             	shl    $0x4,%eax
80102fbf:	85 c0                	test   %eax,%eax
80102fc1:	75 1b                	jne    80102fde <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fc3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fd1:	c1 e0 08             	shl    $0x8,%eax
80102fd4:	09 d0                	or     %edx,%eax
80102fd6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fd9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fde:	ba 00 04 00 00       	mov    $0x400,%edx
80102fe3:	e8 48 ff ff ff       	call   80102f30 <mpsearch1>
80102fe8:	85 c0                	test   %eax,%eax
80102fea:	89 c7                	mov    %eax,%edi
80102fec:	0f 84 22 01 00 00    	je     80103114 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ff2:	8b 77 04             	mov    0x4(%edi),%esi
80102ff5:	85 f6                	test   %esi,%esi
80102ff7:	0f 84 30 01 00 00    	je     8010312d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ffd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103003:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010300a:	00 
8010300b:	c7 44 24 04 1d 76 10 	movl   $0x8010761d,0x4(%esp)
80103012:	80 
80103013:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103019:	e8 c2 16 00 00       	call   801046e0 <memcmp>
8010301e:	85 c0                	test   %eax,%eax
80103020:	0f 85 07 01 00 00    	jne    8010312d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103026:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010302d:	3c 04                	cmp    $0x4,%al
8010302f:	0f 85 0b 01 00 00    	jne    80103140 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103035:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010303c:	85 c0                	test   %eax,%eax
8010303e:	74 21                	je     80103061 <mpinit+0xc1>
  sum = 0;
80103040:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103042:	31 d2                	xor    %edx,%edx
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103048:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010304f:	80 
  for(i=0; i<len; i++)
80103050:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103053:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103055:	39 d0                	cmp    %edx,%eax
80103057:	7f ef                	jg     80103048 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103059:	84 c9                	test   %cl,%cl
8010305b:	0f 85 cc 00 00 00    	jne    8010312d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103064:	85 c0                	test   %eax,%eax
80103066:	0f 84 c1 00 00 00    	je     8010312d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010306c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103072:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103077:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010307c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103083:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103089:	03 55 e4             	add    -0x1c(%ebp),%edx
8010308c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103090:	39 c2                	cmp    %eax,%edx
80103092:	76 1b                	jbe    801030af <mpinit+0x10f>
80103094:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103097:	80 f9 04             	cmp    $0x4,%cl
8010309a:	77 74                	ja     80103110 <mpinit+0x170>
8010309c:	ff 24 8d 5c 76 10 80 	jmp    *-0x7fef89a4(,%ecx,4)
801030a3:	90                   	nop
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030a8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030ab:	39 c2                	cmp    %eax,%edx
801030ad:	77 e5                	ja     80103094 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030af:	85 db                	test   %ebx,%ebx
801030b1:	0f 84 93 00 00 00    	je     8010314a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030b7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030bb:	74 12                	je     801030cf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030bd:	ba 22 00 00 00       	mov    $0x22,%edx
801030c2:	b8 70 00 00 00       	mov    $0x70,%eax
801030c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c8:	b2 23                	mov    $0x23,%dl
801030ca:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030cb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ce:	ee                   	out    %al,(%dx)
  }
}
801030cf:	83 c4 1c             	add    $0x1c,%esp
801030d2:	5b                   	pop    %ebx
801030d3:	5e                   	pop    %esi
801030d4:	5f                   	pop    %edi
801030d5:	5d                   	pop    %ebp
801030d6:	c3                   	ret    
801030d7:	90                   	nop
      if(ncpu < NCPU) {
801030d8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030de:	83 fe 07             	cmp    $0x7,%esi
801030e1:	7f 17                	jg     801030fa <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030e3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030e7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030ed:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030f4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
801030fa:	83 c0 14             	add    $0x14,%eax
      continue;
801030fd:	eb 91                	jmp    80103090 <mpinit+0xf0>
801030ff:	90                   	nop
      ioapicid = ioapic->apicno;
80103100:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103104:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103107:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010310d:	eb 81                	jmp    80103090 <mpinit+0xf0>
8010310f:	90                   	nop
      ismp = 0;
80103110:	31 db                	xor    %ebx,%ebx
80103112:	eb 83                	jmp    80103097 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103114:	ba 00 00 01 00       	mov    $0x10000,%edx
80103119:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010311e:	e8 0d fe ff ff       	call   80102f30 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103123:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103125:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103127:	0f 85 c5 fe ff ff    	jne    80102ff2 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010312d:	c7 04 24 22 76 10 80 	movl   $0x80107622,(%esp)
80103134:	e8 27 d2 ff ff       	call   80100360 <panic>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103140:	3c 01                	cmp    $0x1,%al
80103142:	0f 84 ed fe ff ff    	je     80103035 <mpinit+0x95>
80103148:	eb e3                	jmp    8010312d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010314a:	c7 04 24 3c 76 10 80 	movl   $0x8010763c,(%esp)
80103151:	e8 0a d2 ff ff       	call   80100360 <panic>
80103156:	66 90                	xchg   %ax,%ax
80103158:	66 90                	xchg   %ax,%ax
8010315a:	66 90                	xchg   %ax,%ax
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103160:	55                   	push   %ebp
80103161:	ba 21 00 00 00       	mov    $0x21,%edx
80103166:	89 e5                	mov    %esp,%ebp
80103168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010316d:	ee                   	out    %al,(%dx)
8010316e:	b2 a1                	mov    $0xa1,%dl
80103170:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103171:	5d                   	pop    %ebp
80103172:	c3                   	ret    
80103173:	66 90                	xchg   %ax,%ax
80103175:	66 90                	xchg   %ax,%ax
80103177:	66 90                	xchg   %ax,%ax
80103179:	66 90                	xchg   %ax,%ax
8010317b:	66 90                	xchg   %ax,%ax
8010317d:	66 90                	xchg   %ax,%ax
8010317f:	90                   	nop

80103180 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 1c             	sub    $0x1c,%esp
80103189:	8b 75 08             	mov    0x8(%ebp),%esi
8010318c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010318f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103195:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010319b:	e8 d0 db ff ff       	call   80100d70 <filealloc>
801031a0:	85 c0                	test   %eax,%eax
801031a2:	89 06                	mov    %eax,(%esi)
801031a4:	0f 84 a4 00 00 00    	je     8010324e <pipealloc+0xce>
801031aa:	e8 c1 db ff ff       	call   80100d70 <filealloc>
801031af:	85 c0                	test   %eax,%eax
801031b1:	89 03                	mov    %eax,(%ebx)
801031b3:	0f 84 87 00 00 00    	je     80103240 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031b9:	e8 f2 f2 ff ff       	call   801024b0 <kalloc>
801031be:	85 c0                	test   %eax,%eax
801031c0:	89 c7                	mov    %eax,%edi
801031c2:	74 7c                	je     80103240 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031c4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031cb:	00 00 00 
  p->writeopen = 1;
801031ce:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031d5:	00 00 00 
  p->nwrite = 0;
801031d8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031df:	00 00 00 
  p->nread = 0;
801031e2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031e9:	00 00 00 
  initlock(&p->lock, "pipe");
801031ec:	89 04 24             	mov    %eax,(%esp)
801031ef:	c7 44 24 04 70 76 10 	movl   $0x80107670,0x4(%esp)
801031f6:	80 
801031f7:	e8 64 12 00 00       	call   80104460 <initlock>
  (*f0)->type = FD_PIPE;
801031fc:	8b 06                	mov    (%esi),%eax
801031fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103204:	8b 06                	mov    (%esi),%eax
80103206:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010320a:	8b 06                	mov    (%esi),%eax
8010320c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103210:	8b 06                	mov    (%esi),%eax
80103212:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103215:	8b 03                	mov    (%ebx),%eax
80103217:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010321d:	8b 03                	mov    (%ebx),%eax
8010321f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103223:	8b 03                	mov    (%ebx),%eax
80103225:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103229:	8b 03                	mov    (%ebx),%eax
  return 0;
8010322b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010322d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103230:	83 c4 1c             	add    $0x1c,%esp
80103233:	89 d8                	mov    %ebx,%eax
80103235:	5b                   	pop    %ebx
80103236:	5e                   	pop    %esi
80103237:	5f                   	pop    %edi
80103238:	5d                   	pop    %ebp
80103239:	c3                   	ret    
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103240:	8b 06                	mov    (%esi),%eax
80103242:	85 c0                	test   %eax,%eax
80103244:	74 08                	je     8010324e <pipealloc+0xce>
    fileclose(*f0);
80103246:	89 04 24             	mov    %eax,(%esp)
80103249:	e8 e2 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010324e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103250:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103255:	85 c0                	test   %eax,%eax
80103257:	74 d7                	je     80103230 <pipealloc+0xb0>
    fileclose(*f1);
80103259:	89 04 24             	mov    %eax,(%esp)
8010325c:	e8 cf db ff ff       	call   80100e30 <fileclose>
}
80103261:	83 c4 1c             	add    $0x1c,%esp
80103264:	89 d8                	mov    %ebx,%eax
80103266:	5b                   	pop    %ebx
80103267:	5e                   	pop    %esi
80103268:	5f                   	pop    %edi
80103269:	5d                   	pop    %ebp
8010326a:	c3                   	ret    
8010326b:	90                   	nop
8010326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103270 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	56                   	push   %esi
80103274:	53                   	push   %ebx
80103275:	83 ec 10             	sub    $0x10,%esp
80103278:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010327e:	89 1c 24             	mov    %ebx,(%esp)
80103281:	e8 4a 13 00 00       	call   801045d0 <acquire>
  if(writable){
80103286:	85 f6                	test   %esi,%esi
80103288:	74 3e                	je     801032c8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010328a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103290:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103297:	00 00 00 
    wakeup(&p->nread);
8010329a:	89 04 24             	mov    %eax,(%esp)
8010329d:	e8 ce 0e 00 00       	call   80104170 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032a2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032a8:	85 d2                	test   %edx,%edx
801032aa:	75 0a                	jne    801032b6 <pipeclose+0x46>
801032ac:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 32                	je     801032e8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	5b                   	pop    %ebx
801032bd:	5e                   	pop    %esi
801032be:	5d                   	pop    %ebp
    release(&p->lock);
801032bf:	e9 7c 13 00 00       	jmp    80104640 <release>
801032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032c8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032ce:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032d5:	00 00 00 
    wakeup(&p->nwrite);
801032d8:	89 04 24             	mov    %eax,(%esp)
801032db:	e8 90 0e 00 00       	call   80104170 <wakeup>
801032e0:	eb c0                	jmp    801032a2 <pipeclose+0x32>
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032e8:	89 1c 24             	mov    %ebx,(%esp)
801032eb:	e8 50 13 00 00       	call   80104640 <release>
    kfree((char*)p);
801032f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032f3:	83 c4 10             	add    $0x10,%esp
801032f6:	5b                   	pop    %ebx
801032f7:	5e                   	pop    %esi
801032f8:	5d                   	pop    %ebp
    kfree((char*)p);
801032f9:	e9 02 f0 ff ff       	jmp    80102300 <kfree>
801032fe:	66 90                	xchg   %ax,%ax

80103300 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 1c             	sub    $0x1c,%esp
80103309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010330c:	89 1c 24             	mov    %ebx,(%esp)
8010330f:	e8 bc 12 00 00       	call   801045d0 <acquire>
  for(i = 0; i < n; i++){
80103314:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103317:	85 c9                	test   %ecx,%ecx
80103319:	0f 8e b2 00 00 00    	jle    801033d1 <pipewrite+0xd1>
8010331f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103322:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103328:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010332e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103334:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103337:	03 4d 10             	add    0x10(%ebp),%ecx
8010333a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010333d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103343:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103349:	39 c8                	cmp    %ecx,%eax
8010334b:	74 38                	je     80103385 <pipewrite+0x85>
8010334d:	eb 55                	jmp    801033a4 <pipewrite+0xa4>
8010334f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103350:	e8 6b 03 00 00       	call   801036c0 <myproc>
80103355:	8b 40 24             	mov    0x24(%eax),%eax
80103358:	85 c0                	test   %eax,%eax
8010335a:	75 33                	jne    8010338f <pipewrite+0x8f>
      wakeup(&p->nread);
8010335c:	89 3c 24             	mov    %edi,(%esp)
8010335f:	e8 0c 0e 00 00       	call   80104170 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103364:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103368:	89 34 24             	mov    %esi,(%esp)
8010336b:	e8 40 0a 00 00       	call   80103db0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103370:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103376:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010337c:	05 00 02 00 00       	add    $0x200,%eax
80103381:	39 c2                	cmp    %eax,%edx
80103383:	75 23                	jne    801033a8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103385:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338b:	85 d2                	test   %edx,%edx
8010338d:	75 c1                	jne    80103350 <pipewrite+0x50>
        release(&p->lock);
8010338f:	89 1c 24             	mov    %ebx,(%esp)
80103392:	e8 a9 12 00 00       	call   80104640 <release>
        return -1;
80103397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010339c:	83 c4 1c             	add    $0x1c,%esp
8010339f:	5b                   	pop    %ebx
801033a0:	5e                   	pop    %esi
801033a1:	5f                   	pop    %edi
801033a2:	5d                   	pop    %ebp
801033a3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033a4:	89 c2                	mov    %eax,%edx
801033a6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033ab:	8d 42 01             	lea    0x1(%edx),%eax
801033ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033b4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033be:	0f b6 09             	movzbl (%ecx),%ecx
801033c1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033c5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033c8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033cb:	0f 85 6c ff ff ff    	jne    8010333d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033d1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033d7:	89 04 24             	mov    %eax,(%esp)
801033da:	e8 91 0d 00 00       	call   80104170 <wakeup>
  release(&p->lock);
801033df:	89 1c 24             	mov    %ebx,(%esp)
801033e2:	e8 59 12 00 00       	call   80104640 <release>
  return n;
801033e7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ea:	eb b0                	jmp    8010339c <pipewrite+0x9c>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 1c             	sub    $0x1c,%esp
801033f9:	8b 75 08             	mov    0x8(%ebp),%esi
801033fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033ff:	89 34 24             	mov    %esi,(%esp)
80103402:	e8 c9 11 00 00       	call   801045d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103407:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010340d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103413:	75 5b                	jne    80103470 <piperead+0x80>
80103415:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010341b:	85 db                	test   %ebx,%ebx
8010341d:	74 51                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010341f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103425:	eb 25                	jmp    8010344c <piperead+0x5c>
80103427:	90                   	nop
80103428:	89 74 24 04          	mov    %esi,0x4(%esp)
8010342c:	89 1c 24             	mov    %ebx,(%esp)
8010342f:	e8 7c 09 00 00       	call   80103db0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103434:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010343a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103440:	75 2e                	jne    80103470 <piperead+0x80>
80103442:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103448:	85 d2                	test   %edx,%edx
8010344a:	74 24                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
8010344c:	e8 6f 02 00 00       	call   801036c0 <myproc>
80103451:	8b 48 24             	mov    0x24(%eax),%ecx
80103454:	85 c9                	test   %ecx,%ecx
80103456:	74 d0                	je     80103428 <piperead+0x38>
      release(&p->lock);
80103458:	89 34 24             	mov    %esi,(%esp)
8010345b:	e8 e0 11 00 00       	call   80104640 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103460:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103468:	5b                   	pop    %ebx
80103469:	5e                   	pop    %esi
8010346a:	5f                   	pop    %edi
8010346b:	5d                   	pop    %ebp
8010346c:	c3                   	ret    
8010346d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103470:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103473:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103475:	85 d2                	test   %edx,%edx
80103477:	7f 2b                	jg     801034a4 <piperead+0xb4>
80103479:	eb 31                	jmp    801034ac <piperead+0xbc>
8010347b:	90                   	nop
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103480:	8d 48 01             	lea    0x1(%eax),%ecx
80103483:	25 ff 01 00 00       	and    $0x1ff,%eax
80103488:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010348e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103493:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103496:	83 c3 01             	add    $0x1,%ebx
80103499:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010349c:	74 0e                	je     801034ac <piperead+0xbc>
    if(p->nread == p->nwrite)
8010349e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034aa:	75 d4                	jne    80103480 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034ac:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034b2:	89 04 24             	mov    %eax,(%esp)
801034b5:	e8 b6 0c 00 00       	call   80104170 <wakeup>
  release(&p->lock);
801034ba:	89 34 24             	mov    %esi,(%esp)
801034bd:	e8 7e 11 00 00       	call   80104640 <release>
}
801034c2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034c5:	89 d8                	mov    %ebx,%eax
}
801034c7:	5b                   	pop    %ebx
801034c8:	5e                   	pop    %esi
801034c9:	5f                   	pop    %edi
801034ca:	5d                   	pop    %ebp
801034cb:	c3                   	ret    
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034d9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034dc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034e3:	e8 e8 10 00 00       	call   801045d0 <acquire>
801034e8:	eb 18                	jmp    80103502 <allocproc+0x32>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801034f6:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801034fc:	0f 84 86 00 00 00    	je     80103588 <allocproc+0xb8>
    if(p->state == UNUSED)
80103502:	8b 43 0c             	mov    0xc(%ebx),%eax
80103505:	85 c0                	test   %eax,%eax
80103507:	75 e7                	jne    801034f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103509:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = 10;

  release(&ptable.lock);
8010350e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
80103515:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 10;
8010351c:	c7 83 84 00 00 00 0a 	movl   $0xa,0x84(%ebx)
80103523:	00 00 00 
  p->pid = nextpid++;
80103526:	8d 50 01             	lea    0x1(%eax),%edx
80103529:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010352f:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103532:	e8 09 11 00 00       	call   80104640 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103537:	e8 74 ef ff ff       	call   801024b0 <kalloc>
8010353c:	85 c0                	test   %eax,%eax
8010353e:	89 43 08             	mov    %eax,0x8(%ebx)
80103541:	74 59                	je     8010359c <allocproc+0xcc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103543:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103549:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010354e:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103551:	c7 40 14 05 59 10 80 	movl   $0x80105905,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103558:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010355f:	00 
80103560:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103567:	00 
80103568:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010356b:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010356e:	e8 1d 11 00 00       	call   80104690 <memset>
  p->context->eip = (uint)forkret;
80103573:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103576:	c7 40 10 b0 35 10 80 	movl   $0x801035b0,0x10(%eax)

  return p;
8010357d:	89 d8                	mov    %ebx,%eax
}
8010357f:	83 c4 14             	add    $0x14,%esp
80103582:	5b                   	pop    %ebx
80103583:	5d                   	pop    %ebp
80103584:	c3                   	ret    
80103585:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103588:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010358f:	e8 ac 10 00 00       	call   80104640 <release>
}
80103594:	83 c4 14             	add    $0x14,%esp
  return 0;
80103597:	31 c0                	xor    %eax,%eax
}
80103599:	5b                   	pop    %ebx
8010359a:	5d                   	pop    %ebp
8010359b:	c3                   	ret    
    p->state = UNUSED;
8010359c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035a3:	eb da                	jmp    8010357f <allocproc+0xaf>
801035a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035b6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035bd:	e8 7e 10 00 00       	call   80104640 <release>

  if (first) {
801035c2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035c7:	85 c0                	test   %eax,%eax
801035c9:	75 05                	jne    801035d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035cb:	c9                   	leave  
801035cc:	c3                   	ret    
801035cd:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035d7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035de:	00 00 00 
    iinit(ROOTDEV);
801035e1:	e8 9a de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801035e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035ed:	e8 8e f4 ff ff       	call   80102a80 <initlog>
}
801035f2:	c9                   	leave  
801035f3:	c3                   	ret    
801035f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103600 <pinit>:
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103606:	c7 44 24 04 75 76 10 	movl   $0x80107675,0x4(%esp)
8010360d:	80 
8010360e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103615:	e8 46 0e 00 00       	call   80104460 <initlock>
}
8010361a:	c9                   	leave  
8010361b:	c3                   	ret    
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103620 <mycpu>:
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	56                   	push   %esi
80103624:	53                   	push   %ebx
80103625:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103628:	9c                   	pushf  
80103629:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010362a:	f6 c4 02             	test   $0x2,%ah
8010362d:	75 57                	jne    80103686 <mycpu+0x66>
  apicid = lapicid();
8010362f:	e8 3c f1 ff ff       	call   80102770 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103634:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010363a:	85 f6                	test   %esi,%esi
8010363c:	7e 3c                	jle    8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010363e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103645:	39 c2                	cmp    %eax,%edx
80103647:	74 2d                	je     80103676 <mycpu+0x56>
80103649:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010364e:	31 d2                	xor    %edx,%edx
80103650:	83 c2 01             	add    $0x1,%edx
80103653:	39 f2                	cmp    %esi,%edx
80103655:	74 23                	je     8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103657:	0f b6 19             	movzbl (%ecx),%ebx
8010365a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103660:	39 c3                	cmp    %eax,%ebx
80103662:	75 ec                	jne    80103650 <mycpu+0x30>
      return &cpus[i];
80103664:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010366a:	83 c4 10             	add    $0x10,%esp
8010366d:	5b                   	pop    %ebx
8010366e:	5e                   	pop    %esi
8010366f:	5d                   	pop    %ebp
      return &cpus[i];
80103670:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103675:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103676:	31 d2                	xor    %edx,%edx
80103678:	eb ea                	jmp    80103664 <mycpu+0x44>
  panic("unknown apicid\n");
8010367a:	c7 04 24 7c 76 10 80 	movl   $0x8010767c,(%esp)
80103681:	e8 da cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103686:	c7 04 24 88 77 10 80 	movl   $0x80107788,(%esp)
8010368d:	e8 ce cc ff ff       	call   80100360 <panic>
80103692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036a0 <cpuid>:
cpuid() {
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036a6:	e8 75 ff ff ff       	call   80103620 <mycpu>
}
801036ab:	c9                   	leave  
  return mycpu()-cpus;
801036ac:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036b1:	c1 f8 04             	sar    $0x4,%eax
801036b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ba:	c3                   	ret    
801036bb:	90                   	nop
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036c0 <myproc>:
myproc(void) {
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036c7:	e8 14 0e 00 00       	call   801044e0 <pushcli>
  c = mycpu();
801036cc:	e8 4f ff ff ff       	call   80103620 <mycpu>
  p = c->proc;
801036d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036d7:	e8 44 0e 00 00       	call   80104520 <popcli>
}
801036dc:	83 c4 04             	add    $0x4,%esp
801036df:	89 d8                	mov    %ebx,%eax
801036e1:	5b                   	pop    %ebx
801036e2:	5d                   	pop    %ebp
801036e3:	c3                   	ret    
801036e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036f0 <userinit>:
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801036f7:	e8 d4 fd ff ff       	call   801034d0 <allocproc>
801036fc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801036fe:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103703:	e8 68 37 00 00       	call   80106e70 <setupkvm>
80103708:	85 c0                	test   %eax,%eax
8010370a:	89 43 04             	mov    %eax,0x4(%ebx)
8010370d:	0f 84 d4 00 00 00    	je     801037e7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103713:	89 04 24             	mov    %eax,(%esp)
80103716:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010371d:	00 
8010371e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103725:	80 
80103726:	e8 75 34 00 00       	call   80106ba0 <inituvm>
  p->sz = PGSIZE;
8010372b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103731:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103738:	00 
80103739:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103740:	00 
80103741:	8b 43 18             	mov    0x18(%ebx),%eax
80103744:	89 04 24             	mov    %eax,(%esp)
80103747:	e8 44 0f 00 00       	call   80104690 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010374c:	8b 43 18             	mov    0x18(%ebx),%eax
8010374f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103754:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103759:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010375d:	8b 43 18             	mov    0x18(%ebx),%eax
80103760:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103764:	8b 43 18             	mov    0x18(%ebx),%eax
80103767:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010376b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010376f:	8b 43 18             	mov    0x18(%ebx),%eax
80103772:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103776:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010377a:	8b 43 18             	mov    0x18(%ebx),%eax
8010377d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103784:	8b 43 18             	mov    0x18(%ebx),%eax
80103787:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010378e:	8b 43 18             	mov    0x18(%ebx),%eax
80103791:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103798:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010379b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037a2:	00 
801037a3:	c7 44 24 04 a5 76 10 	movl   $0x801076a5,0x4(%esp)
801037aa:	80 
801037ab:	89 04 24             	mov    %eax,(%esp)
801037ae:	e8 bd 10 00 00       	call   80104870 <safestrcpy>
  p->cwd = namei("/");
801037b3:	c7 04 24 ae 76 10 80 	movl   $0x801076ae,(%esp)
801037ba:	e8 51 e7 ff ff       	call   80101f10 <namei>
801037bf:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037c2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037c9:	e8 02 0e 00 00       	call   801045d0 <acquire>
  p->state = RUNNABLE;
801037ce:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037d5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037dc:	e8 5f 0e 00 00       	call   80104640 <release>
}
801037e1:	83 c4 14             	add    $0x14,%esp
801037e4:	5b                   	pop    %ebx
801037e5:	5d                   	pop    %ebp
801037e6:	c3                   	ret    
    panic("userinit: out of memory?");
801037e7:	c7 04 24 8c 76 10 80 	movl   $0x8010768c,(%esp)
801037ee:	e8 6d cb ff ff       	call   80100360 <panic>
801037f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <growproc>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	83 ec 10             	sub    $0x10,%esp
80103808:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010380b:	e8 b0 fe ff ff       	call   801036c0 <myproc>
  if(n > 0){
80103810:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103813:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103815:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103817:	7e 2f                	jle    80103848 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103819:	01 c6                	add    %eax,%esi
8010381b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010381f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103823:	8b 43 04             	mov    0x4(%ebx),%eax
80103826:	89 04 24             	mov    %eax,(%esp)
80103829:	e8 b2 34 00 00       	call   80106ce0 <allocuvm>
8010382e:	85 c0                	test   %eax,%eax
80103830:	74 36                	je     80103868 <growproc+0x68>
  curproc->sz = sz;
80103832:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103834:	89 1c 24             	mov    %ebx,(%esp)
80103837:	e8 54 32 00 00       	call   80106a90 <switchuvm>
  return 0;
8010383c:	31 c0                	xor    %eax,%eax
}
8010383e:	83 c4 10             	add    $0x10,%esp
80103841:	5b                   	pop    %ebx
80103842:	5e                   	pop    %esi
80103843:	5d                   	pop    %ebp
80103844:	c3                   	ret    
80103845:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103848:	74 e8                	je     80103832 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010384a:	01 c6                	add    %eax,%esi
8010384c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103850:	89 44 24 04          	mov    %eax,0x4(%esp)
80103854:	8b 43 04             	mov    0x4(%ebx),%eax
80103857:	89 04 24             	mov    %eax,(%esp)
8010385a:	e8 71 35 00 00       	call   80106dd0 <deallocuvm>
8010385f:	85 c0                	test   %eax,%eax
80103861:	75 cf                	jne    80103832 <growproc+0x32>
80103863:	90                   	nop
80103864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010386d:	eb cf                	jmp    8010383e <growproc+0x3e>
8010386f:	90                   	nop

80103870 <fork>:
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	57                   	push   %edi
80103874:	56                   	push   %esi
80103875:	53                   	push   %ebx
80103876:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103879:	e8 42 fe ff ff       	call   801036c0 <myproc>
8010387e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103880:	e8 4b fc ff ff       	call   801034d0 <allocproc>
80103885:	85 c0                	test   %eax,%eax
80103887:	89 c7                	mov    %eax,%edi
80103889:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010388c:	0f 84 bc 00 00 00    	je     8010394e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103892:	8b 03                	mov    (%ebx),%eax
80103894:	89 44 24 04          	mov    %eax,0x4(%esp)
80103898:	8b 43 04             	mov    0x4(%ebx),%eax
8010389b:	89 04 24             	mov    %eax,(%esp)
8010389e:	e8 ad 36 00 00       	call   80106f50 <copyuvm>
801038a3:	85 c0                	test   %eax,%eax
801038a5:	89 47 04             	mov    %eax,0x4(%edi)
801038a8:	0f 84 a7 00 00 00    	je     80103955 <fork+0xe5>
  np->sz = curproc->sz;
801038ae:	8b 03                	mov    (%ebx),%eax
801038b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038b3:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801038b5:	8b 79 18             	mov    0x18(%ecx),%edi
801038b8:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
801038ba:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038bd:	8b 73 18             	mov    0x18(%ebx),%esi
801038c0:	b9 13 00 00 00       	mov    $0x13,%ecx
801038c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038c7:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038c9:	8b 40 18             	mov    0x18(%eax),%eax
801038cc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038d3:	90                   	nop
801038d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801038d8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038dc:	85 c0                	test   %eax,%eax
801038de:	74 0f                	je     801038ef <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038e0:	89 04 24             	mov    %eax,(%esp)
801038e3:	e8 f8 d4 ff ff       	call   80100de0 <filedup>
801038e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038eb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038ef:	83 c6 01             	add    $0x1,%esi
801038f2:	83 fe 10             	cmp    $0x10,%esi
801038f5:	75 e1                	jne    801038d8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
801038f7:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038fa:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801038fd:	89 04 24             	mov    %eax,(%esp)
80103900:	e8 8b dd ff ff       	call   80101690 <idup>
80103905:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103908:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010390b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010390e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103912:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103919:	00 
8010391a:	89 04 24             	mov    %eax,(%esp)
8010391d:	e8 4e 0f 00 00       	call   80104870 <safestrcpy>
  pid = np->pid;
80103922:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103925:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010392c:	e8 9f 0c 00 00       	call   801045d0 <acquire>
  np->state = RUNNABLE;
80103931:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103938:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010393f:	e8 fc 0c 00 00       	call   80104640 <release>
  return pid;
80103944:	89 d8                	mov    %ebx,%eax
}
80103946:	83 c4 1c             	add    $0x1c,%esp
80103949:	5b                   	pop    %ebx
8010394a:	5e                   	pop    %esi
8010394b:	5f                   	pop    %edi
8010394c:	5d                   	pop    %ebp
8010394d:	c3                   	ret    
    return -1;
8010394e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103953:	eb f1                	jmp    80103946 <fork+0xd6>
    kfree(np->kstack);
80103955:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103958:	8b 47 08             	mov    0x8(%edi),%eax
8010395b:	89 04 24             	mov    %eax,(%esp)
8010395e:	e8 9d e9 ff ff       	call   80102300 <kfree>
    return -1;
80103963:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103968:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010396f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103976:	eb ce                	jmp    80103946 <fork+0xd6>
80103978:	90                   	nop
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103980 <scheduler>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103989:	e8 92 fc ff ff       	call   80103620 <mycpu>
8010398e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103990:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103997:	00 00 00 
8010399a:	8d 78 04             	lea    0x4(%eax),%edi
8010399d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039a0:	fb                   	sti    
    acquire(&ptable.lock);
801039a1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
801039ad:	e8 1e 0c 00 00       	call   801045d0 <acquire>
801039b2:	eb 12                	jmp    801039c6 <scheduler+0x46>
801039b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801039be:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801039c4:	74 4a                	je     80103a10 <scheduler+0x90>
      if(p->state != RUNNABLE)
801039c6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039ca:	75 ec                	jne    801039b8 <scheduler+0x38>
      c->proc = p;
801039cc:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039d2:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d5:	81 c3 88 00 00 00    	add    $0x88,%ebx
      switchuvm(p);
801039db:	e8 b0 30 00 00       	call   80106a90 <switchuvm>
      swtch(&(c->scheduler), p->context);
801039e0:	8b 43 94             	mov    -0x6c(%ebx),%eax
      p->state = RUNNING;
801039e3:	c7 43 84 04 00 00 00 	movl   $0x4,-0x7c(%ebx)
      swtch(&(c->scheduler), p->context);
801039ea:	89 3c 24             	mov    %edi,(%esp)
801039ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801039f1:	e8 d5 0e 00 00       	call   801048cb <swtch>
      switchkvm();
801039f6:	e8 75 30 00 00       	call   80106a70 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039fb:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
      c->proc = 0;
80103a01:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a08:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a0b:	75 b9                	jne    801039c6 <scheduler+0x46>
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80103a10:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a17:	e8 24 0c 00 00       	call   80104640 <release>
  }
80103a1c:	eb 82                	jmp    801039a0 <scheduler+0x20>
80103a1e:	66 90                	xchg   %ax,%ax

80103a20 <setpriority>:
void setpriority(int prior){
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
80103a25:	83 ec 10             	sub    $0x10,%esp
80103a28:	8b 5d 08             	mov    0x8(%ebp),%ebx
   struct proc *curproc = myproc();
80103a2b:	e8 90 fc ff ff       	call   801036c0 <myproc>
   curproc->priority = prior;
80103a30:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
   struct proc *curproc = myproc();
80103a36:	89 c6                	mov    %eax,%esi
   cprintf("curr_priority = %d \n", prior);
80103a38:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103a3c:	c7 04 24 b0 76 10 80 	movl   $0x801076b0,(%esp)
80103a43:	e8 08 cc ff ff       	call   80100650 <cprintf>
   cprintf("curproc->priority = %d \n", curproc->priority);
80103a48:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
80103a4e:	c7 04 24 c5 76 10 80 	movl   $0x801076c5,(%esp)
80103a55:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a59:	e8 f2 cb ff ff       	call   80100650 <cprintf>
}
80103a5e:	83 c4 10             	add    $0x10,%esp
80103a61:	5b                   	pop    %ebx
80103a62:	5e                   	pop    %esi
80103a63:	5d                   	pop    %ebp
80103a64:	c3                   	ret    
80103a65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a70 <sched>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	56                   	push   %esi
80103a74:	53                   	push   %ebx
80103a75:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a78:	e8 43 fc ff ff       	call   801036c0 <myproc>
  if(!holding(&ptable.lock))
80103a7d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a84:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a86:	e8 05 0b 00 00       	call   80104590 <holding>
80103a8b:	85 c0                	test   %eax,%eax
80103a8d:	74 4f                	je     80103ade <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a8f:	e8 8c fb ff ff       	call   80103620 <mycpu>
80103a94:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a9b:	75 65                	jne    80103b02 <sched+0x92>
  if(p->state == RUNNING)
80103a9d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103aa1:	74 53                	je     80103af6 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103aa3:	9c                   	pushf  
80103aa4:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103aa5:	f6 c4 02             	test   $0x2,%ah
80103aa8:	75 40                	jne    80103aea <sched+0x7a>
  intena = mycpu()->intena;
80103aaa:	e8 71 fb ff ff       	call   80103620 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103aaf:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ab2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ab8:	e8 63 fb ff ff       	call   80103620 <mycpu>
80103abd:	8b 40 04             	mov    0x4(%eax),%eax
80103ac0:	89 1c 24             	mov    %ebx,(%esp)
80103ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ac7:	e8 ff 0d 00 00       	call   801048cb <swtch>
  mycpu()->intena = intena;
80103acc:	e8 4f fb ff ff       	call   80103620 <mycpu>
80103ad1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ad7:	83 c4 10             	add    $0x10,%esp
80103ada:	5b                   	pop    %ebx
80103adb:	5e                   	pop    %esi
80103adc:	5d                   	pop    %ebp
80103add:	c3                   	ret    
    panic("sched ptable.lock");
80103ade:	c7 04 24 de 76 10 80 	movl   $0x801076de,(%esp)
80103ae5:	e8 76 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103aea:	c7 04 24 0a 77 10 80 	movl   $0x8010770a,(%esp)
80103af1:	e8 6a c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103af6:	c7 04 24 fc 76 10 80 	movl   $0x801076fc,(%esp)
80103afd:	e8 5e c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103b02:	c7 04 24 f0 76 10 80 	movl   $0x801076f0,(%esp)
80103b09:	e8 52 c8 ff ff       	call   80100360 <panic>
80103b0e:	66 90                	xchg   %ax,%ax

80103b10 <exit>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
  if(curproc == initproc)
80103b14:	31 f6                	xor    %esi,%esi
{
80103b16:	53                   	push   %ebx
80103b17:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b1a:	e8 a1 fb ff ff       	call   801036c0 <myproc>
  if(curproc == initproc)
80103b1f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103b25:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103b27:	0f 84 fd 00 00 00    	je     80103c2a <exit+0x11a>
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103b30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b34:	85 c0                	test   %eax,%eax
80103b36:	74 10                	je     80103b48 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b38:	89 04 24             	mov    %eax,(%esp)
80103b3b:	e8 f0 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103b40:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b47:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103b48:	83 c6 01             	add    $0x1,%esi
80103b4b:	83 fe 10             	cmp    $0x10,%esi
80103b4e:	75 e0                	jne    80103b30 <exit+0x20>
  begin_op();
80103b50:	e8 cb ef ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103b55:	8b 43 68             	mov    0x68(%ebx),%eax
80103b58:	89 04 24             	mov    %eax,(%esp)
80103b5b:	e8 80 dc ff ff       	call   801017e0 <iput>
  end_op();
80103b60:	e8 2b f0 ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103b65:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103b6c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b73:	e8 58 0a 00 00       	call   801045d0 <acquire>
  wakeup1(curproc->parent);
80103b78:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b7b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b80:	eb 14                	jmp    80103b96 <exit+0x86>
80103b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b88:	81 c2 88 00 00 00    	add    $0x88,%edx
80103b8e:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103b94:	74 20                	je     80103bb6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103b96:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b9a:	75 ec                	jne    80103b88 <exit+0x78>
80103b9c:	3b 42 20             	cmp    0x20(%edx),%eax
80103b9f:	75 e7                	jne    80103b88 <exit+0x78>
      p->state = RUNNABLE;
80103ba1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ba8:	81 c2 88 00 00 00    	add    $0x88,%edx
80103bae:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103bb4:	75 e0                	jne    80103b96 <exit+0x86>
      p->parent = initproc;
80103bb6:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103bbb:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103bc0:	eb 14                	jmp    80103bd6 <exit+0xc6>
80103bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bc8:	81 c1 88 00 00 00    	add    $0x88,%ecx
80103bce:	81 f9 54 4f 11 80    	cmp    $0x80114f54,%ecx
80103bd4:	74 3c                	je     80103c12 <exit+0x102>
    if(p->parent == curproc){
80103bd6:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103bd9:	75 ed                	jne    80103bc8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103bdb:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103bdf:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103be2:	75 e4                	jne    80103bc8 <exit+0xb8>
80103be4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103be9:	eb 13                	jmp    80103bfe <exit+0xee>
80103beb:	90                   	nop
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bf0:	81 c2 88 00 00 00    	add    $0x88,%edx
80103bf6:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103bfc:	74 ca                	je     80103bc8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103bfe:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c02:	75 ec                	jne    80103bf0 <exit+0xe0>
80103c04:	3b 42 20             	cmp    0x20(%edx),%eax
80103c07:	75 e7                	jne    80103bf0 <exit+0xe0>
      p->state = RUNNABLE;
80103c09:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c10:	eb de                	jmp    80103bf0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103c12:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103c19:	e8 52 fe ff ff       	call   80103a70 <sched>
  panic("zombie exit");
80103c1e:	c7 04 24 2b 77 10 80 	movl   $0x8010772b,(%esp)
80103c25:	e8 36 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103c2a:	c7 04 24 1e 77 10 80 	movl   $0x8010771e,(%esp)
80103c31:	e8 2a c7 ff ff       	call   80100360 <panic>
80103c36:	8d 76 00             	lea    0x0(%esi),%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c40 <exitS>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
  if(curproc == initproc)
80103c44:	31 f6                	xor    %esi,%esi
{
80103c46:	53                   	push   %ebx
80103c47:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103c4a:	e8 71 fa ff ff       	call   801036c0 <myproc>
80103c4f:	89 c3                	mov    %eax,%ebx
  curproc->status = curr_status;
80103c51:	8b 45 08             	mov    0x8(%ebp),%eax
  if(curproc == initproc)
80103c54:	3b 1d b8 a5 10 80    	cmp    0x8010a5b8,%ebx
  curproc->status = curr_status;
80103c5a:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if(curproc == initproc)
80103c5d:	0f 84 ff 00 00 00    	je     80103d62 <exitS+0x122>
80103c63:	90                   	nop
80103c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103c68:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c6c:	85 c0                	test   %eax,%eax
80103c6e:	74 10                	je     80103c80 <exitS+0x40>
      fileclose(curproc->ofile[fd]);
80103c70:	89 04 24             	mov    %eax,(%esp)
80103c73:	e8 b8 d1 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103c78:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103c7f:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103c80:	83 c6 01             	add    $0x1,%esi
80103c83:	83 fe 10             	cmp    $0x10,%esi
80103c86:	75 e0                	jne    80103c68 <exitS+0x28>
  begin_op();
80103c88:	e8 93 ee ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103c8d:	8b 43 68             	mov    0x68(%ebx),%eax
80103c90:	89 04 24             	mov    %eax,(%esp)
80103c93:	e8 48 db ff ff       	call   801017e0 <iput>
  end_op();
80103c98:	e8 f3 ee ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103c9d:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103ca4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cab:	e8 20 09 00 00       	call   801045d0 <acquire>
  wakeup1(curproc->parent);
80103cb0:	8b 43 14             	mov    0x14(%ebx),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cb3:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103cb8:	eb 14                	jmp    80103cce <exitS+0x8e>
80103cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cc0:	81 c2 88 00 00 00    	add    $0x88,%edx
80103cc6:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103ccc:	74 20                	je     80103cee <exitS+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103cce:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103cd2:	75 ec                	jne    80103cc0 <exitS+0x80>
80103cd4:	3b 42 20             	cmp    0x20(%edx),%eax
80103cd7:	75 e7                	jne    80103cc0 <exitS+0x80>
      p->state = RUNNABLE;
80103cd9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce0:	81 c2 88 00 00 00    	add    $0x88,%edx
80103ce6:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103cec:	75 e0                	jne    80103cce <exitS+0x8e>
      p->parent = initproc;
80103cee:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103cf3:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103cf8:	eb 14                	jmp    80103d0e <exitS+0xce>
80103cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d00:	81 c1 88 00 00 00    	add    $0x88,%ecx
80103d06:	81 f9 54 4f 11 80    	cmp    $0x80114f54,%ecx
80103d0c:	74 3c                	je     80103d4a <exitS+0x10a>
    if(p->parent == curproc){
80103d0e:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103d11:	75 ed                	jne    80103d00 <exitS+0xc0>
      if(p->state == ZOMBIE)
80103d13:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103d17:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103d1a:	75 e4                	jne    80103d00 <exitS+0xc0>
80103d1c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d21:	eb 13                	jmp    80103d36 <exitS+0xf6>
80103d23:	90                   	nop
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d28:	81 c2 88 00 00 00    	add    $0x88,%edx
80103d2e:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103d34:	74 ca                	je     80103d00 <exitS+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d36:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103d3a:	75 ec                	jne    80103d28 <exitS+0xe8>
80103d3c:	3b 42 20             	cmp    0x20(%edx),%eax
80103d3f:	75 e7                	jne    80103d28 <exitS+0xe8>
      p->state = RUNNABLE;
80103d41:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103d48:	eb de                	jmp    80103d28 <exitS+0xe8>
  curproc->state = ZOMBIE;
80103d4a:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103d51:	e8 1a fd ff ff       	call   80103a70 <sched>
  panic("zombie exit");
80103d56:	c7 04 24 2b 77 10 80 	movl   $0x8010772b,(%esp)
80103d5d:	e8 fe c5 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103d62:	c7 04 24 1e 77 10 80 	movl   $0x8010771e,(%esp)
80103d69:	e8 f2 c5 ff ff       	call   80100360 <panic>
80103d6e:	66 90                	xchg   %ax,%ax

80103d70 <yield>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d76:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d7d:	e8 4e 08 00 00       	call   801045d0 <acquire>
  myproc()->state = RUNNABLE;
80103d82:	e8 39 f9 ff ff       	call   801036c0 <myproc>
80103d87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103d8e:	e8 dd fc ff ff       	call   80103a70 <sched>
  release(&ptable.lock);
80103d93:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d9a:	e8 a1 08 00 00       	call   80104640 <release>
}
80103d9f:	c9                   	leave  
80103da0:	c3                   	ret    
80103da1:	eb 0d                	jmp    80103db0 <sleep>
80103da3:	90                   	nop
80103da4:	90                   	nop
80103da5:	90                   	nop
80103da6:	90                   	nop
80103da7:	90                   	nop
80103da8:	90                   	nop
80103da9:	90                   	nop
80103daa:	90                   	nop
80103dab:	90                   	nop
80103dac:	90                   	nop
80103dad:	90                   	nop
80103dae:	90                   	nop
80103daf:	90                   	nop

80103db0 <sleep>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 1c             	sub    $0x1c,%esp
80103db9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103dbf:	e8 fc f8 ff ff       	call   801036c0 <myproc>
  if(p == 0)
80103dc4:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103dc6:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103dc8:	0f 84 7c 00 00 00    	je     80103e4a <sleep+0x9a>
  if(lk == 0)
80103dce:	85 f6                	test   %esi,%esi
80103dd0:	74 6c                	je     80103e3e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103dd2:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103dd8:	74 46                	je     80103e20 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103dda:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103de1:	e8 ea 07 00 00       	call   801045d0 <acquire>
    release(lk);
80103de6:	89 34 24             	mov    %esi,(%esp)
80103de9:	e8 52 08 00 00       	call   80104640 <release>
  p->chan = chan;
80103dee:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103df1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103df8:	e8 73 fc ff ff       	call   80103a70 <sched>
  p->chan = 0;
80103dfd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e04:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e0b:	e8 30 08 00 00       	call   80104640 <release>
    acquire(lk);
80103e10:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103e13:	83 c4 1c             	add    $0x1c,%esp
80103e16:	5b                   	pop    %ebx
80103e17:	5e                   	pop    %esi
80103e18:	5f                   	pop    %edi
80103e19:	5d                   	pop    %ebp
    acquire(lk);
80103e1a:	e9 b1 07 00 00       	jmp    801045d0 <acquire>
80103e1f:	90                   	nop
  p->chan = chan;
80103e20:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103e23:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e2a:	e8 41 fc ff ff       	call   80103a70 <sched>
  p->chan = 0;
80103e2f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e36:	83 c4 1c             	add    $0x1c,%esp
80103e39:	5b                   	pop    %ebx
80103e3a:	5e                   	pop    %esi
80103e3b:	5f                   	pop    %edi
80103e3c:	5d                   	pop    %ebp
80103e3d:	c3                   	ret    
    panic("sleep without lk");
80103e3e:	c7 04 24 3d 77 10 80 	movl   $0x8010773d,(%esp)
80103e45:	e8 16 c5 ff ff       	call   80100360 <panic>
    panic("sleep");
80103e4a:	c7 04 24 37 77 10 80 	movl   $0x80107737,(%esp)
80103e51:	e8 0a c5 ff ff       	call   80100360 <panic>
80103e56:	8d 76 00             	lea    0x0(%esi),%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e60 <wait>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	56                   	push   %esi
80103e64:	53                   	push   %ebx
80103e65:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103e68:	e8 53 f8 ff ff       	call   801036c0 <myproc>
  acquire(&ptable.lock);
80103e6d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103e74:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103e76:	e8 55 07 00 00       	call   801045d0 <acquire>
    havekids = 0;
80103e7b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e7d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103e82:	eb 12                	jmp    80103e96 <wait+0x36>
80103e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e88:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103e8e:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103e94:	74 22                	je     80103eb8 <wait+0x58>
      if(p->parent != curproc)
80103e96:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e99:	75 ed                	jne    80103e88 <wait+0x28>
      if(p->state == ZOMBIE){
80103e9b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e9f:	74 34                	je     80103ed5 <wait+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea1:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80103ea7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eac:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103eb2:	75 e2                	jne    80103e96 <wait+0x36>
80103eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80103eb8:	85 c0                	test   %eax,%eax
80103eba:	74 6e                	je     80103f2a <wait+0xca>
80103ebc:	8b 46 24             	mov    0x24(%esi),%eax
80103ebf:	85 c0                	test   %eax,%eax
80103ec1:	75 67                	jne    80103f2a <wait+0xca>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103ec3:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103eca:	80 
80103ecb:	89 34 24             	mov    %esi,(%esp)
80103ece:	e8 dd fe ff ff       	call   80103db0 <sleep>
  }
80103ed3:	eb a6                	jmp    80103e7b <wait+0x1b>
        kfree(p->kstack);
80103ed5:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103ed8:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103edb:	89 04 24             	mov    %eax,(%esp)
80103ede:	e8 1d e4 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80103ee3:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103ee6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103eed:	89 04 24             	mov    %eax,(%esp)
80103ef0:	e8 fb 2e 00 00       	call   80106df0 <freevm>
        release(&ptable.lock);
80103ef5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103efc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f03:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f0a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f0e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f15:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f1c:	e8 1f 07 00 00       	call   80104640 <release>
}
80103f21:	83 c4 10             	add    $0x10,%esp
	return pid;
80103f24:	89 f0                	mov    %esi,%eax
}
80103f26:	5b                   	pop    %ebx
80103f27:	5e                   	pop    %esi
80103f28:	5d                   	pop    %ebp
80103f29:	c3                   	ret    
      release(&ptable.lock);
80103f2a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f31:	e8 0a 07 00 00       	call   80104640 <release>
}
80103f36:	83 c4 10             	add    $0x10,%esp
      return -1;
80103f39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f3e:	5b                   	pop    %ebx
80103f3f:	5e                   	pop    %esi
80103f40:	5d                   	pop    %ebp
80103f41:	c3                   	ret    
80103f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f50 <waitS>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	56                   	push   %esi
80103f54:	53                   	push   %ebx
80103f55:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103f58:	e8 63 f7 ff ff       	call   801036c0 <myproc>
  acquire(&ptable.lock);
80103f5d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103f64:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103f66:	e8 65 06 00 00       	call   801045d0 <acquire>
    havekids = 0;
80103f6b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f72:	eb 12                	jmp    80103f86 <waitS+0x36>
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f78:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103f7e:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103f84:	74 22                	je     80103fa8 <waitS+0x58>
      if(p->parent != curproc)
80103f86:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f89:	75 ed                	jne    80103f78 <waitS+0x28>
      if(p->state == ZOMBIE){
80103f8b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f8f:	74 34                	je     80103fc5 <waitS+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f91:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80103f97:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103fa2:	75 e2                	jne    80103f86 <waitS+0x36>
80103fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80103fa8:	85 c0                	test   %eax,%eax
80103faa:	74 76                	je     80104022 <waitS+0xd2>
80103fac:	8b 46 24             	mov    0x24(%esi),%eax
80103faf:	85 c0                	test   %eax,%eax
80103fb1:	75 6f                	jne    80104022 <waitS+0xd2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103fb3:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103fba:	80 
80103fbb:	89 34 24             	mov    %esi,(%esp)
80103fbe:	e8 ed fd ff ff       	call   80103db0 <sleep>
  }
80103fc3:	eb a6                	jmp    80103f6b <waitS+0x1b>
        kfree(p->kstack);
80103fc5:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103fc8:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fcb:	89 04 24             	mov    %eax,(%esp)
80103fce:	e8 2d e3 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80103fd3:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103fd6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fdd:	89 04 24             	mov    %eax,(%esp)
80103fe0:	e8 0b 2e 00 00       	call   80106df0 <freevm>
        release(&ptable.lock);
80103fe5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103fec:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103ff3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103ffa:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ffe:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104005:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010400c:	e8 2f 06 00 00       	call   80104640 <release>
	*status = p->status;
80104011:	8b 45 08             	mov    0x8(%ebp),%eax
80104014:	8b 53 7c             	mov    0x7c(%ebx),%edx
80104017:	89 10                	mov    %edx,(%eax)
}
80104019:	83 c4 10             	add    $0x10,%esp
	return pid;
8010401c:	89 f0                	mov    %esi,%eax
}
8010401e:	5b                   	pop    %ebx
8010401f:	5e                   	pop    %esi
80104020:	5d                   	pop    %ebp
80104021:	c3                   	ret    
      release(&ptable.lock);
80104022:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104029:	e8 12 06 00 00       	call   80104640 <release>
}
8010402e:	83 c4 10             	add    $0x10,%esp
      return -1;
80104031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104036:	5b                   	pop    %ebx
80104037:	5e                   	pop    %esi
80104038:	5d                   	pop    %ebp
80104039:	c3                   	ret    
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104040 <waitpid>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	53                   	push   %ebx
80104046:	83 ec 1c             	sub    $0x1c,%esp
80104049:	8b 55 08             	mov    0x8(%ebp),%edx
8010404c:	8b 7d 10             	mov    0x10(%ebp),%edi
8010404f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct proc *curproc = myproc();
80104052:	e8 69 f6 ff ff       	call   801036c0 <myproc>
  acquire(&ptable.lock);
80104057:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
8010405e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&ptable.lock);
80104061:	e8 6a 05 00 00       	call   801045d0 <acquire>
80104066:	8b 55 e0             	mov    -0x20(%ebp),%edx
    havekids = 0;
80104069:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010406b:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104070:	eb 14                	jmp    80104086 <waitpid+0x46>
80104072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104078:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010407e:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80104084:	74 29                	je     801040af <waitpid+0x6f>
      if(p->pid != curr_pid)
80104086:	8b 73 10             	mov    0x10(%ebx),%esi
80104089:	39 d6                	cmp    %edx,%esi
8010408b:	75 eb                	jne    80104078 <waitpid+0x38>
      if(p->state == ZOMBIE){
8010408d:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104091:	74 4d                	je     801040e0 <waitpid+0xa0>
      else if(options == 1){
80104093:	83 ff 01             	cmp    $0x1,%edi
80104096:	0f 84 a6 00 00 00    	je     80104142 <waitpid+0x102>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010409c:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
801040a2:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040a7:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801040ad:	75 d7                	jne    80104086 <waitpid+0x46>
    if(!havekids || curproc->killed){
801040af:	85 c0                	test   %eax,%eax
801040b1:	0f 84 a3 00 00 00    	je     8010415a <waitpid+0x11a>
801040b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801040ba:	8b 40 24             	mov    0x24(%eax),%eax
801040bd:	85 c0                	test   %eax,%eax
801040bf:	0f 85 95 00 00 00    	jne    8010415a <waitpid+0x11a>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801040c8:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
801040cf:	80 
801040d0:	89 55 e0             	mov    %edx,-0x20(%ebp)
801040d3:	89 04 24             	mov    %eax,(%esp)
801040d6:	e8 d5 fc ff ff       	call   80103db0 <sleep>
  }
801040db:	8b 55 e0             	mov    -0x20(%ebp),%edx
801040de:	eb 89                	jmp    80104069 <waitpid+0x29>
        kfree(p->kstack);
801040e0:	8b 43 08             	mov    0x8(%ebx),%eax
801040e3:	89 04 24             	mov    %eax,(%esp)
801040e6:	e8 15 e2 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
801040eb:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
801040ee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040f5:	89 04 24             	mov    %eax,(%esp)
801040f8:	e8 f3 2c 00 00       	call   80106df0 <freevm>
        release(&ptable.lock);
801040fd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104104:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010410b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104112:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104116:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010411d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104124:	e8 17 05 00 00       	call   80104640 <release>
	if(status == 0){
80104129:	8b 55 0c             	mov    0xc(%ebp),%edx
8010412c:	85 d2                	test   %edx,%edx
8010412e:	74 08                	je     80104138 <waitpid+0xf8>
           *status = p->status;
80104130:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104133:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104136:	89 01                	mov    %eax,(%ecx)
}
80104138:	83 c4 1c             	add    $0x1c,%esp
8010413b:	89 f0                	mov    %esi,%eax
8010413d:	5b                   	pop    %ebx
8010413e:	5e                   	pop    %esi
8010413f:	5f                   	pop    %edi
80104140:	5d                   	pop    %ebp
80104141:	c3                   	ret    
	release(&ptable.lock);
80104142:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
	return 0;
80104149:	31 f6                	xor    %esi,%esi
	release(&ptable.lock);
8010414b:	e8 f0 04 00 00       	call   80104640 <release>
}
80104150:	83 c4 1c             	add    $0x1c,%esp
80104153:	89 f0                	mov    %esi,%eax
80104155:	5b                   	pop    %ebx
80104156:	5e                   	pop    %esi
80104157:	5f                   	pop    %edi
80104158:	5d                   	pop    %ebp
80104159:	c3                   	ret    
      release(&ptable.lock);
8010415a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
      return -1;
80104161:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104166:	e8 d5 04 00 00       	call   80104640 <release>
      return -1;
8010416b:	eb cb                	jmp    80104138 <waitpid+0xf8>
8010416d:	8d 76 00             	lea    0x0(%esi),%esi

80104170 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 14             	sub    $0x14,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010417a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104181:	e8 4a 04 00 00       	call   801045d0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104186:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010418b:	eb 0f                	jmp    8010419c <wakeup+0x2c>
8010418d:	8d 76 00             	lea    0x0(%esi),%esi
80104190:	05 88 00 00 00       	add    $0x88,%eax
80104195:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
8010419a:	74 24                	je     801041c0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
8010419c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041a0:	75 ee                	jne    80104190 <wakeup+0x20>
801041a2:	3b 58 20             	cmp    0x20(%eax),%ebx
801041a5:	75 e9                	jne    80104190 <wakeup+0x20>
      p->state = RUNNABLE;
801041a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ae:	05 88 00 00 00       	add    $0x88,%eax
801041b3:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801041b8:	75 e2                	jne    8010419c <wakeup+0x2c>
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wakeup1(chan);
  release(&ptable.lock);
801041c0:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801041c7:	83 c4 14             	add    $0x14,%esp
801041ca:	5b                   	pop    %ebx
801041cb:	5d                   	pop    %ebp
  release(&ptable.lock);
801041cc:	e9 6f 04 00 00       	jmp    80104640 <release>
801041d1:	eb 0d                	jmp    801041e0 <kill>
801041d3:	90                   	nop
801041d4:	90                   	nop
801041d5:	90                   	nop
801041d6:	90                   	nop
801041d7:	90                   	nop
801041d8:	90                   	nop
801041d9:	90                   	nop
801041da:	90                   	nop
801041db:	90                   	nop
801041dc:	90                   	nop
801041dd:	90                   	nop
801041de:	90                   	nop
801041df:	90                   	nop

801041e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 14             	sub    $0x14,%esp
801041e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801041f1:	e8 da 03 00 00       	call   801045d0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041fb:	eb 0f                	jmp    8010420c <kill+0x2c>
801041fd:	8d 76 00             	lea    0x0(%esi),%esi
80104200:	05 88 00 00 00       	add    $0x88,%eax
80104205:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
8010420a:	74 3c                	je     80104248 <kill+0x68>
    if(p->pid == pid){
8010420c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010420f:	75 ef                	jne    80104200 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104211:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104215:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010421c:	74 1a                	je     80104238 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010421e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104225:	e8 16 04 00 00       	call   80104640 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010422a:	83 c4 14             	add    $0x14,%esp
      return 0;
8010422d:	31 c0                	xor    %eax,%eax
}
8010422f:	5b                   	pop    %ebx
80104230:	5d                   	pop    %ebp
80104231:	c3                   	ret    
80104232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->state = RUNNABLE;
80104238:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010423f:	eb dd                	jmp    8010421e <kill+0x3e>
80104241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104248:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010424f:	e8 ec 03 00 00       	call   80104640 <release>
}
80104254:	83 c4 14             	add    $0x14,%esp
  return -1;
80104257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010425c:	5b                   	pop    %ebx
8010425d:	5d                   	pop    %ebp
8010425e:	c3                   	ret    
8010425f:	90                   	nop

80104260 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	57                   	push   %edi
80104264:	56                   	push   %esi
80104265:	53                   	push   %ebx
80104266:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010426b:	83 ec 4c             	sub    $0x4c,%esp
8010426e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104271:	eb 23                	jmp    80104296 <procdump+0x36>
80104273:	90                   	nop
80104274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104278:	c7 04 24 dc 76 10 80 	movl   $0x801076dc,(%esp)
8010427f:	e8 cc c3 ff ff       	call   80100650 <cprintf>
80104284:	81 c3 88 00 00 00    	add    $0x88,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010428a:	81 fb c0 4f 11 80    	cmp    $0x80114fc0,%ebx
80104290:	0f 84 8a 00 00 00    	je     80104320 <procdump+0xc0>
    if(p->state == UNUSED)
80104296:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104299:	85 c0                	test   %eax,%eax
8010429b:	74 e7                	je     80104284 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010429d:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801042a0:	ba 4e 77 10 80       	mov    $0x8010774e,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042a5:	77 11                	ja     801042b8 <procdump+0x58>
801042a7:	8b 14 85 b0 77 10 80 	mov    -0x7fef8850(,%eax,4),%edx
      state = "???";
801042ae:	b8 4e 77 10 80       	mov    $0x8010774e,%eax
801042b3:	85 d2                	test   %edx,%edx
801042b5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042b8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801042bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801042bf:	89 54 24 08          	mov    %edx,0x8(%esp)
801042c3:	c7 04 24 52 77 10 80 	movl   $0x80107752,(%esp)
801042ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801042ce:	e8 7d c3 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
801042d3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042d7:	75 9f                	jne    80104278 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042d9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801042e0:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042e3:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042e6:	8b 40 0c             	mov    0xc(%eax),%eax
801042e9:	83 c0 08             	add    $0x8,%eax
801042ec:	89 04 24             	mov    %eax,(%esp)
801042ef:	e8 8c 01 00 00       	call   80104480 <getcallerpcs>
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801042f8:	8b 17                	mov    (%edi),%edx
801042fa:	85 d2                	test   %edx,%edx
801042fc:	0f 84 76 ff ff ff    	je     80104278 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104302:	89 54 24 04          	mov    %edx,0x4(%esp)
80104306:	83 c7 04             	add    $0x4,%edi
80104309:	c7 04 24 61 71 10 80 	movl   $0x80107161,(%esp)
80104310:	e8 3b c3 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104315:	39 f7                	cmp    %esi,%edi
80104317:	75 df                	jne    801042f8 <procdump+0x98>
80104319:	e9 5a ff ff ff       	jmp    80104278 <procdump+0x18>
8010431e:	66 90                	xchg   %ax,%ax
  }
}
80104320:	83 c4 4c             	add    $0x4c,%esp
80104323:	5b                   	pop    %ebx
80104324:	5e                   	pop    %esi
80104325:	5f                   	pop    %edi
80104326:	5d                   	pop    %ebp
80104327:	c3                   	ret    
80104328:	66 90                	xchg   %ax,%ax
8010432a:	66 90                	xchg   %ax,%ax
8010432c:	66 90                	xchg   %ax,%ax
8010432e:	66 90                	xchg   %ax,%ax

80104330 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 14             	sub    $0x14,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010433a:	c7 44 24 04 c8 77 10 	movl   $0x801077c8,0x4(%esp)
80104341:	80 
80104342:	8d 43 04             	lea    0x4(%ebx),%eax
80104345:	89 04 24             	mov    %eax,(%esp)
80104348:	e8 13 01 00 00       	call   80104460 <initlock>
  lk->name = name;
8010434d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104350:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104356:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010435d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104360:	83 c4 14             	add    $0x14,%esp
80104363:	5b                   	pop    %ebx
80104364:	5d                   	pop    %ebp
80104365:	c3                   	ret    
80104366:	8d 76 00             	lea    0x0(%esi),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104370 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	83 ec 10             	sub    $0x10,%esp
80104378:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010437b:	8d 73 04             	lea    0x4(%ebx),%esi
8010437e:	89 34 24             	mov    %esi,(%esp)
80104381:	e8 4a 02 00 00       	call   801045d0 <acquire>
  while (lk->locked) {
80104386:	8b 13                	mov    (%ebx),%edx
80104388:	85 d2                	test   %edx,%edx
8010438a:	74 16                	je     801043a2 <acquiresleep+0x32>
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104390:	89 74 24 04          	mov    %esi,0x4(%esp)
80104394:	89 1c 24             	mov    %ebx,(%esp)
80104397:	e8 14 fa ff ff       	call   80103db0 <sleep>
  while (lk->locked) {
8010439c:	8b 03                	mov    (%ebx),%eax
8010439e:	85 c0                	test   %eax,%eax
801043a0:	75 ee                	jne    80104390 <acquiresleep+0x20>
  }
  lk->locked = 1;
801043a2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043a8:	e8 13 f3 ff ff       	call   801036c0 <myproc>
801043ad:	8b 40 10             	mov    0x10(%eax),%eax
801043b0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043b3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043b6:	83 c4 10             	add    $0x10,%esp
801043b9:	5b                   	pop    %ebx
801043ba:	5e                   	pop    %esi
801043bb:	5d                   	pop    %ebp
  release(&lk->lk);
801043bc:	e9 7f 02 00 00       	jmp    80104640 <release>
801043c1:	eb 0d                	jmp    801043d0 <releasesleep>
801043c3:	90                   	nop
801043c4:	90                   	nop
801043c5:	90                   	nop
801043c6:	90                   	nop
801043c7:	90                   	nop
801043c8:	90                   	nop
801043c9:	90                   	nop
801043ca:	90                   	nop
801043cb:	90                   	nop
801043cc:	90                   	nop
801043cd:	90                   	nop
801043ce:	90                   	nop
801043cf:	90                   	nop

801043d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
801043d5:	83 ec 10             	sub    $0x10,%esp
801043d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043db:	8d 73 04             	lea    0x4(%ebx),%esi
801043de:	89 34 24             	mov    %esi,(%esp)
801043e1:	e8 ea 01 00 00       	call   801045d0 <acquire>
  lk->locked = 0;
801043e6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043ec:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043f3:	89 1c 24             	mov    %ebx,(%esp)
801043f6:	e8 75 fd ff ff       	call   80104170 <wakeup>
  release(&lk->lk);
801043fb:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043fe:	83 c4 10             	add    $0x10,%esp
80104401:	5b                   	pop    %ebx
80104402:	5e                   	pop    %esi
80104403:	5d                   	pop    %ebp
  release(&lk->lk);
80104404:	e9 37 02 00 00       	jmp    80104640 <release>
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104410 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
80104414:	31 ff                	xor    %edi,%edi
{
80104416:	56                   	push   %esi
80104417:	53                   	push   %ebx
80104418:	83 ec 1c             	sub    $0x1c,%esp
8010441b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010441e:	8d 73 04             	lea    0x4(%ebx),%esi
80104421:	89 34 24             	mov    %esi,(%esp)
80104424:	e8 a7 01 00 00       	call   801045d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104429:	8b 03                	mov    (%ebx),%eax
8010442b:	85 c0                	test   %eax,%eax
8010442d:	74 13                	je     80104442 <holdingsleep+0x32>
8010442f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104432:	e8 89 f2 ff ff       	call   801036c0 <myproc>
80104437:	3b 58 10             	cmp    0x10(%eax),%ebx
8010443a:	0f 94 c0             	sete   %al
8010443d:	0f b6 c0             	movzbl %al,%eax
80104440:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104442:	89 34 24             	mov    %esi,(%esp)
80104445:	e8 f6 01 00 00       	call   80104640 <release>
  return r;
}
8010444a:	83 c4 1c             	add    $0x1c,%esp
8010444d:	89 f8                	mov    %edi,%eax
8010444f:	5b                   	pop    %ebx
80104450:	5e                   	pop    %esi
80104451:	5f                   	pop    %edi
80104452:	5d                   	pop    %ebp
80104453:	c3                   	ret    
80104454:	66 90                	xchg   %ax,%ax
80104456:	66 90                	xchg   %ax,%ax
80104458:	66 90                	xchg   %ax,%ax
8010445a:	66 90                	xchg   %ax,%ax
8010445c:	66 90                	xchg   %ax,%ax
8010445e:	66 90                	xchg   %ax,%ax

80104460 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104466:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010446f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104472:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104479:	5d                   	pop    %ebp
8010447a:	c3                   	ret    
8010447b:	90                   	nop
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104483:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104486:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104489:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010448a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010448d:	31 c0                	xor    %eax,%eax
8010448f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104490:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104496:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010449c:	77 1a                	ja     801044b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010449e:	8b 5a 04             	mov    0x4(%edx),%ebx
801044a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801044a4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801044a7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801044a9:	83 f8 0a             	cmp    $0xa,%eax
801044ac:	75 e2                	jne    80104490 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044ae:	5b                   	pop    %ebx
801044af:	5d                   	pop    %ebp
801044b0:	c3                   	ret    
801044b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801044b8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801044bf:	83 c0 01             	add    $0x1,%eax
801044c2:	83 f8 0a             	cmp    $0xa,%eax
801044c5:	74 e7                	je     801044ae <getcallerpcs+0x2e>
    pcs[i] = 0;
801044c7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801044ce:	83 c0 01             	add    $0x1,%eax
801044d1:	83 f8 0a             	cmp    $0xa,%eax
801044d4:	75 e2                	jne    801044b8 <getcallerpcs+0x38>
801044d6:	eb d6                	jmp    801044ae <getcallerpcs+0x2e>
801044d8:	90                   	nop
801044d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 04             	sub    $0x4,%esp
801044e7:	9c                   	pushf  
801044e8:	5b                   	pop    %ebx
  asm volatile("cli");
801044e9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044ea:	e8 31 f1 ff ff       	call   80103620 <mycpu>
801044ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044f5:	85 c0                	test   %eax,%eax
801044f7:	75 11                	jne    8010450a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801044f9:	e8 22 f1 ff ff       	call   80103620 <mycpu>
801044fe:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104504:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010450a:	e8 11 f1 ff ff       	call   80103620 <mycpu>
8010450f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104516:	83 c4 04             	add    $0x4,%esp
80104519:	5b                   	pop    %ebx
8010451a:	5d                   	pop    %ebp
8010451b:	c3                   	ret    
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <popcli>:

void
popcli(void)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104526:	9c                   	pushf  
80104527:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104528:	f6 c4 02             	test   $0x2,%ah
8010452b:	75 49                	jne    80104576 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010452d:	e8 ee f0 ff ff       	call   80103620 <mycpu>
80104532:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104538:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010453b:	85 d2                	test   %edx,%edx
8010453d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104543:	78 25                	js     8010456a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104545:	e8 d6 f0 ff ff       	call   80103620 <mycpu>
8010454a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104550:	85 d2                	test   %edx,%edx
80104552:	74 04                	je     80104558 <popcli+0x38>
    sti();
}
80104554:	c9                   	leave  
80104555:	c3                   	ret    
80104556:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104558:	e8 c3 f0 ff ff       	call   80103620 <mycpu>
8010455d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104563:	85 c0                	test   %eax,%eax
80104565:	74 ed                	je     80104554 <popcli+0x34>
  asm volatile("sti");
80104567:	fb                   	sti    
}
80104568:	c9                   	leave  
80104569:	c3                   	ret    
    panic("popcli");
8010456a:	c7 04 24 ea 77 10 80 	movl   $0x801077ea,(%esp)
80104571:	e8 ea bd ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104576:	c7 04 24 d3 77 10 80 	movl   $0x801077d3,(%esp)
8010457d:	e8 de bd ff ff       	call   80100360 <panic>
80104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <holding>:
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
  r = lock->locked && lock->cpu == mycpu();
80104594:	31 f6                	xor    %esi,%esi
{
80104596:	53                   	push   %ebx
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010459a:	e8 41 ff ff ff       	call   801044e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010459f:	8b 03                	mov    (%ebx),%eax
801045a1:	85 c0                	test   %eax,%eax
801045a3:	74 12                	je     801045b7 <holding+0x27>
801045a5:	8b 5b 08             	mov    0x8(%ebx),%ebx
801045a8:	e8 73 f0 ff ff       	call   80103620 <mycpu>
801045ad:	39 c3                	cmp    %eax,%ebx
801045af:	0f 94 c0             	sete   %al
801045b2:	0f b6 c0             	movzbl %al,%eax
801045b5:	89 c6                	mov    %eax,%esi
  popcli();
801045b7:	e8 64 ff ff ff       	call   80104520 <popcli>
}
801045bc:	89 f0                	mov    %esi,%eax
801045be:	5b                   	pop    %ebx
801045bf:	5e                   	pop    %esi
801045c0:	5d                   	pop    %ebp
801045c1:	c3                   	ret    
801045c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <acquire>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801045d7:	e8 04 ff ff ff       	call   801044e0 <pushcli>
  if(holding(lk))
801045dc:	8b 45 08             	mov    0x8(%ebp),%eax
801045df:	89 04 24             	mov    %eax,(%esp)
801045e2:	e8 a9 ff ff ff       	call   80104590 <holding>
801045e7:	85 c0                	test   %eax,%eax
801045e9:	75 3a                	jne    80104625 <acquire+0x55>
  asm volatile("lock; xchgl %0, %1" :
801045eb:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
801045f0:	8b 55 08             	mov    0x8(%ebp),%edx
801045f3:	89 c8                	mov    %ecx,%eax
801045f5:	f0 87 02             	lock xchg %eax,(%edx)
801045f8:	85 c0                	test   %eax,%eax
801045fa:	75 f4                	jne    801045f0 <acquire+0x20>
  __sync_synchronize();
801045fc:	0f ae f0             	mfence 
  lk->cpu = mycpu();
801045ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104602:	e8 19 f0 ff ff       	call   80103620 <mycpu>
80104607:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010460a:	8b 45 08             	mov    0x8(%ebp),%eax
8010460d:	83 c0 0c             	add    $0xc,%eax
80104610:	89 44 24 04          	mov    %eax,0x4(%esp)
80104614:	8d 45 08             	lea    0x8(%ebp),%eax
80104617:	89 04 24             	mov    %eax,(%esp)
8010461a:	e8 61 fe ff ff       	call   80104480 <getcallerpcs>
}
8010461f:	83 c4 14             	add    $0x14,%esp
80104622:	5b                   	pop    %ebx
80104623:	5d                   	pop    %ebp
80104624:	c3                   	ret    
    panic("acquire");
80104625:	c7 04 24 f1 77 10 80 	movl   $0x801077f1,(%esp)
8010462c:	e8 2f bd ff ff       	call   80100360 <panic>
80104631:	eb 0d                	jmp    80104640 <release>
80104633:	90                   	nop
80104634:	90                   	nop
80104635:	90                   	nop
80104636:	90                   	nop
80104637:	90                   	nop
80104638:	90                   	nop
80104639:	90                   	nop
8010463a:	90                   	nop
8010463b:	90                   	nop
8010463c:	90                   	nop
8010463d:	90                   	nop
8010463e:	90                   	nop
8010463f:	90                   	nop

80104640 <release>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	53                   	push   %ebx
80104644:	83 ec 14             	sub    $0x14,%esp
80104647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010464a:	89 1c 24             	mov    %ebx,(%esp)
8010464d:	e8 3e ff ff ff       	call   80104590 <holding>
80104652:	85 c0                	test   %eax,%eax
80104654:	74 21                	je     80104677 <release+0x37>
  lk->pcs[0] = 0;
80104656:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010465d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104664:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104667:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010466d:	83 c4 14             	add    $0x14,%esp
80104670:	5b                   	pop    %ebx
80104671:	5d                   	pop    %ebp
  popcli();
80104672:	e9 a9 fe ff ff       	jmp    80104520 <popcli>
    panic("release");
80104677:	c7 04 24 f9 77 10 80 	movl   $0x801077f9,(%esp)
8010467e:	e8 dd bc ff ff       	call   80100360 <panic>
80104683:	66 90                	xchg   %ax,%ax
80104685:	66 90                	xchg   %ax,%ax
80104687:	66 90                	xchg   %ax,%ax
80104689:	66 90                	xchg   %ax,%ax
8010468b:	66 90                	xchg   %ax,%ax
8010468d:	66 90                	xchg   %ax,%ax
8010468f:	90                   	nop

80104690 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	8b 55 08             	mov    0x8(%ebp),%edx
80104696:	57                   	push   %edi
80104697:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010469a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010469b:	f6 c2 03             	test   $0x3,%dl
8010469e:	75 05                	jne    801046a5 <memset+0x15>
801046a0:	f6 c1 03             	test   $0x3,%cl
801046a3:	74 13                	je     801046b8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801046a5:	89 d7                	mov    %edx,%edi
801046a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801046aa:	fc                   	cld    
801046ab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801046ad:	5b                   	pop    %ebx
801046ae:	89 d0                	mov    %edx,%eax
801046b0:	5f                   	pop    %edi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801046b8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046bc:	c1 e9 02             	shr    $0x2,%ecx
801046bf:	89 f8                	mov    %edi,%eax
801046c1:	89 fb                	mov    %edi,%ebx
801046c3:	c1 e0 18             	shl    $0x18,%eax
801046c6:	c1 e3 10             	shl    $0x10,%ebx
801046c9:	09 d8                	or     %ebx,%eax
801046cb:	09 f8                	or     %edi,%eax
801046cd:	c1 e7 08             	shl    $0x8,%edi
801046d0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046d2:	89 d7                	mov    %edx,%edi
801046d4:	fc                   	cld    
801046d5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801046d7:	5b                   	pop    %ebx
801046d8:	89 d0                	mov    %edx,%eax
801046da:	5f                   	pop    %edi
801046db:	5d                   	pop    %ebp
801046dc:	c3                   	ret    
801046dd:	8d 76 00             	lea    0x0(%esi),%esi

801046e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	8b 45 10             	mov    0x10(%ebp),%eax
801046e6:	57                   	push   %edi
801046e7:	56                   	push   %esi
801046e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801046eb:	53                   	push   %ebx
801046ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046ef:	85 c0                	test   %eax,%eax
801046f1:	8d 78 ff             	lea    -0x1(%eax),%edi
801046f4:	74 26                	je     8010471c <memcmp+0x3c>
    if(*s1 != *s2)
801046f6:	0f b6 03             	movzbl (%ebx),%eax
801046f9:	31 d2                	xor    %edx,%edx
801046fb:	0f b6 0e             	movzbl (%esi),%ecx
801046fe:	38 c8                	cmp    %cl,%al
80104700:	74 16                	je     80104718 <memcmp+0x38>
80104702:	eb 24                	jmp    80104728 <memcmp+0x48>
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104708:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010470d:	83 c2 01             	add    $0x1,%edx
80104710:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104714:	38 c8                	cmp    %cl,%al
80104716:	75 10                	jne    80104728 <memcmp+0x48>
  while(n-- > 0){
80104718:	39 fa                	cmp    %edi,%edx
8010471a:	75 ec                	jne    80104708 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010471c:	5b                   	pop    %ebx
  return 0;
8010471d:	31 c0                	xor    %eax,%eax
}
8010471f:	5e                   	pop    %esi
80104720:	5f                   	pop    %edi
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    
80104723:	90                   	nop
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104728:	5b                   	pop    %ebx
      return *s1 - *s2;
80104729:	29 c8                	sub    %ecx,%eax
}
8010472b:	5e                   	pop    %esi
8010472c:	5f                   	pop    %edi
8010472d:	5d                   	pop    %ebp
8010472e:	c3                   	ret    
8010472f:	90                   	nop

80104730 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	8b 45 08             	mov    0x8(%ebp),%eax
80104737:	56                   	push   %esi
80104738:	8b 75 0c             	mov    0xc(%ebp),%esi
8010473b:	53                   	push   %ebx
8010473c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010473f:	39 c6                	cmp    %eax,%esi
80104741:	73 35                	jae    80104778 <memmove+0x48>
80104743:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104746:	39 c8                	cmp    %ecx,%eax
80104748:	73 2e                	jae    80104778 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010474a:	85 db                	test   %ebx,%ebx
    d += n;
8010474c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010474f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104752:	74 1b                	je     8010476f <memmove+0x3f>
80104754:	f7 db                	neg    %ebx
80104756:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104759:	01 fb                	add    %edi,%ebx
8010475b:	90                   	nop
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104760:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104764:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104767:	83 ea 01             	sub    $0x1,%edx
8010476a:	83 fa ff             	cmp    $0xffffffff,%edx
8010476d:	75 f1                	jne    80104760 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010476f:	5b                   	pop    %ebx
80104770:	5e                   	pop    %esi
80104771:	5f                   	pop    %edi
80104772:	5d                   	pop    %ebp
80104773:	c3                   	ret    
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104778:	31 d2                	xor    %edx,%edx
8010477a:	85 db                	test   %ebx,%ebx
8010477c:	74 f1                	je     8010476f <memmove+0x3f>
8010477e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104780:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104784:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104787:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010478a:	39 da                	cmp    %ebx,%edx
8010478c:	75 f2                	jne    80104780 <memmove+0x50>
}
8010478e:	5b                   	pop    %ebx
8010478f:	5e                   	pop    %esi
80104790:	5f                   	pop    %edi
80104791:	5d                   	pop    %ebp
80104792:	c3                   	ret    
80104793:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801047a3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801047a4:	eb 8a                	jmp    80104730 <memmove>
801047a6:	8d 76 00             	lea    0x0(%esi),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	8b 75 10             	mov    0x10(%ebp),%esi
801047b7:	53                   	push   %ebx
801047b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801047be:	85 f6                	test   %esi,%esi
801047c0:	74 30                	je     801047f2 <strncmp+0x42>
801047c2:	0f b6 01             	movzbl (%ecx),%eax
801047c5:	84 c0                	test   %al,%al
801047c7:	74 2f                	je     801047f8 <strncmp+0x48>
801047c9:	0f b6 13             	movzbl (%ebx),%edx
801047cc:	38 d0                	cmp    %dl,%al
801047ce:	75 46                	jne    80104816 <strncmp+0x66>
801047d0:	8d 51 01             	lea    0x1(%ecx),%edx
801047d3:	01 ce                	add    %ecx,%esi
801047d5:	eb 14                	jmp    801047eb <strncmp+0x3b>
801047d7:	90                   	nop
801047d8:	0f b6 02             	movzbl (%edx),%eax
801047db:	84 c0                	test   %al,%al
801047dd:	74 31                	je     80104810 <strncmp+0x60>
801047df:	0f b6 19             	movzbl (%ecx),%ebx
801047e2:	83 c2 01             	add    $0x1,%edx
801047e5:	38 d8                	cmp    %bl,%al
801047e7:	75 17                	jne    80104800 <strncmp+0x50>
    n--, p++, q++;
801047e9:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
801047eb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801047ed:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
801047f0:	75 e6                	jne    801047d8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801047f2:	5b                   	pop    %ebx
    return 0;
801047f3:	31 c0                	xor    %eax,%eax
}
801047f5:	5e                   	pop    %esi
801047f6:	5d                   	pop    %ebp
801047f7:	c3                   	ret    
801047f8:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
801047fb:	31 c0                	xor    %eax,%eax
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104800:	0f b6 d3             	movzbl %bl,%edx
80104803:	29 d0                	sub    %edx,%eax
}
80104805:	5b                   	pop    %ebx
80104806:	5e                   	pop    %esi
80104807:	5d                   	pop    %ebp
80104808:	c3                   	ret    
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104810:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104814:	eb ea                	jmp    80104800 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104816:	89 d3                	mov    %edx,%ebx
80104818:	eb e6                	jmp    80104800 <strncmp+0x50>
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104820 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	8b 45 08             	mov    0x8(%ebp),%eax
80104826:	56                   	push   %esi
80104827:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010482a:	53                   	push   %ebx
8010482b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010482e:	89 c2                	mov    %eax,%edx
80104830:	eb 19                	jmp    8010484b <strncpy+0x2b>
80104832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104838:	83 c3 01             	add    $0x1,%ebx
8010483b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010483f:	83 c2 01             	add    $0x1,%edx
80104842:	84 c9                	test   %cl,%cl
80104844:	88 4a ff             	mov    %cl,-0x1(%edx)
80104847:	74 09                	je     80104852 <strncpy+0x32>
80104849:	89 f1                	mov    %esi,%ecx
8010484b:	85 c9                	test   %ecx,%ecx
8010484d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104850:	7f e6                	jg     80104838 <strncpy+0x18>
    ;
  while(n-- > 0)
80104852:	31 c9                	xor    %ecx,%ecx
80104854:	85 f6                	test   %esi,%esi
80104856:	7e 0f                	jle    80104867 <strncpy+0x47>
    *s++ = 0;
80104858:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010485c:	89 f3                	mov    %esi,%ebx
8010485e:	83 c1 01             	add    $0x1,%ecx
80104861:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104863:	85 db                	test   %ebx,%ebx
80104865:	7f f1                	jg     80104858 <strncpy+0x38>
  return os;
}
80104867:	5b                   	pop    %ebx
80104868:	5e                   	pop    %esi
80104869:	5d                   	pop    %ebp
8010486a:	c3                   	ret    
8010486b:	90                   	nop
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104876:	56                   	push   %esi
80104877:	8b 45 08             	mov    0x8(%ebp),%eax
8010487a:	53                   	push   %ebx
8010487b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010487e:	85 c9                	test   %ecx,%ecx
80104880:	7e 26                	jle    801048a8 <safestrcpy+0x38>
80104882:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104886:	89 c1                	mov    %eax,%ecx
80104888:	eb 17                	jmp    801048a1 <safestrcpy+0x31>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104890:	83 c2 01             	add    $0x1,%edx
80104893:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104897:	83 c1 01             	add    $0x1,%ecx
8010489a:	84 db                	test   %bl,%bl
8010489c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010489f:	74 04                	je     801048a5 <safestrcpy+0x35>
801048a1:	39 f2                	cmp    %esi,%edx
801048a3:	75 eb                	jne    80104890 <safestrcpy+0x20>
    ;
  *s = 0;
801048a5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801048a8:	5b                   	pop    %ebx
801048a9:	5e                   	pop    %esi
801048aa:	5d                   	pop    %ebp
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048b0 <strlen>:

int
strlen(const char *s)
{
801048b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048b1:	31 c0                	xor    %eax,%eax
{
801048b3:	89 e5                	mov    %esp,%ebp
801048b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048b8:	80 3a 00             	cmpb   $0x0,(%edx)
801048bb:	74 0c                	je     801048c9 <strlen+0x19>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
801048c0:	83 c0 01             	add    $0x1,%eax
801048c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048c7:	75 f7                	jne    801048c0 <strlen+0x10>
    ;
  return n;
}
801048c9:	5d                   	pop    %ebp
801048ca:	c3                   	ret    

801048cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048d3:	55                   	push   %ebp
  pushl %ebx
801048d4:	53                   	push   %ebx
  pushl %esi
801048d5:	56                   	push   %esi
  pushl %edi
801048d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048d9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048db:	5f                   	pop    %edi
  popl %esi
801048dc:	5e                   	pop    %esi
  popl %ebx
801048dd:	5b                   	pop    %ebx
  popl %ebp
801048de:	5d                   	pop    %ebp
  ret
801048df:	c3                   	ret    

801048e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 04             	sub    $0x4,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048ea:	e8 d1 ed ff ff       	call   801036c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ef:	8b 00                	mov    (%eax),%eax
801048f1:	39 d8                	cmp    %ebx,%eax
801048f3:	76 1b                	jbe    80104910 <fetchint+0x30>
801048f5:	8d 53 04             	lea    0x4(%ebx),%edx
801048f8:	39 d0                	cmp    %edx,%eax
801048fa:	72 14                	jb     80104910 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ff:	8b 13                	mov    (%ebx),%edx
80104901:	89 10                	mov    %edx,(%eax)
  return 0;
80104903:	31 c0                	xor    %eax,%eax
}
80104905:	83 c4 04             	add    $0x4,%esp
80104908:	5b                   	pop    %ebx
80104909:	5d                   	pop    %ebp
8010490a:	c3                   	ret    
8010490b:	90                   	nop
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104915:	eb ee                	jmp    80104905 <fetchint+0x25>
80104917:	89 f6                	mov    %esi,%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 04             	sub    $0x4,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010492a:	e8 91 ed ff ff       	call   801036c0 <myproc>

  if(addr >= curproc->sz)
8010492f:	39 18                	cmp    %ebx,(%eax)
80104931:	76 26                	jbe    80104959 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104936:	89 da                	mov    %ebx,%edx
80104938:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010493a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010493c:	39 c3                	cmp    %eax,%ebx
8010493e:	73 19                	jae    80104959 <fetchstr+0x39>
    if(*s == 0)
80104940:	80 3b 00             	cmpb   $0x0,(%ebx)
80104943:	75 0d                	jne    80104952 <fetchstr+0x32>
80104945:	eb 21                	jmp    80104968 <fetchstr+0x48>
80104947:	90                   	nop
80104948:	80 3a 00             	cmpb   $0x0,(%edx)
8010494b:	90                   	nop
8010494c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104950:	74 16                	je     80104968 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104952:	83 c2 01             	add    $0x1,%edx
80104955:	39 d0                	cmp    %edx,%eax
80104957:	77 ef                	ja     80104948 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
80104959:	83 c4 04             	add    $0x4,%esp
    return -1;
8010495c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104961:	5b                   	pop    %ebx
80104962:	5d                   	pop    %ebp
80104963:	c3                   	ret    
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104968:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010496b:	89 d0                	mov    %edx,%eax
8010496d:	29 d8                	sub    %ebx,%eax
}
8010496f:	5b                   	pop    %ebx
80104970:	5d                   	pop    %ebp
80104971:	c3                   	ret    
80104972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	8b 75 0c             	mov    0xc(%ebp),%esi
80104987:	53                   	push   %ebx
80104988:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010498b:	e8 30 ed ff ff       	call   801036c0 <myproc>
80104990:	89 75 0c             	mov    %esi,0xc(%ebp)
80104993:	8b 40 18             	mov    0x18(%eax),%eax
80104996:	8b 40 44             	mov    0x44(%eax),%eax
80104999:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010499d:	89 45 08             	mov    %eax,0x8(%ebp)
}
801049a0:	5b                   	pop    %ebx
801049a1:	5e                   	pop    %esi
801049a2:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049a3:	e9 38 ff ff ff       	jmp    801048e0 <fetchint>
801049a8:	90                   	nop
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	83 ec 20             	sub    $0x20,%esp
801049b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801049bb:	e8 00 ed ff ff       	call   801036c0 <myproc>
801049c0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801049c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801049c9:	8b 45 08             	mov    0x8(%ebp),%eax
801049cc:	89 04 24             	mov    %eax,(%esp)
801049cf:	e8 ac ff ff ff       	call   80104980 <argint>
801049d4:	85 c0                	test   %eax,%eax
801049d6:	78 28                	js     80104a00 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049d8:	85 db                	test   %ebx,%ebx
801049da:	78 24                	js     80104a00 <argptr+0x50>
801049dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049df:	8b 06                	mov    (%esi),%eax
801049e1:	39 c2                	cmp    %eax,%edx
801049e3:	73 1b                	jae    80104a00 <argptr+0x50>
801049e5:	01 d3                	add    %edx,%ebx
801049e7:	39 d8                	cmp    %ebx,%eax
801049e9:	72 15                	jb     80104a00 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801049eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ee:	89 10                	mov    %edx,(%eax)
  return 0;
}
801049f0:	83 c4 20             	add    $0x20,%esp
  return 0;
801049f3:	31 c0                	xor    %eax,%eax
}
801049f5:	5b                   	pop    %ebx
801049f6:	5e                   	pop    %esi
801049f7:	5d                   	pop    %ebp
801049f8:	c3                   	ret    
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a00:	83 c4 20             	add    $0x20,%esp
    return -1;
80104a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a08:	5b                   	pop    %ebx
80104a09:	5e                   	pop    %esi
80104a0a:	5d                   	pop    %ebp
80104a0b:	c3                   	ret    
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a19:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a1d:	8b 45 08             	mov    0x8(%ebp),%eax
80104a20:	89 04 24             	mov    %eax,(%esp)
80104a23:	e8 58 ff ff ff       	call   80104980 <argint>
80104a28:	85 c0                	test   %eax,%eax
80104a2a:	78 14                	js     80104a40 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a36:	89 04 24             	mov    %eax,(%esp)
80104a39:	e8 e2 fe ff ff       	call   80104920 <fetchstr>
}
80104a3e:	c9                   	leave  
80104a3f:	c3                   	ret    
    return -1;
80104a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a45:	c9                   	leave  
80104a46:	c3                   	ret    
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <syscall>:

};

void
syscall(void)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104a58:	e8 63 ec ff ff       	call   801036c0 <myproc>

  num = curproc->tf->eax;
80104a5d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104a60:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104a62:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a65:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a68:	83 fa 18             	cmp    $0x18,%edx
80104a6b:	77 1b                	ja     80104a88 <syscall+0x38>
80104a6d:	8b 14 85 20 78 10 80 	mov    -0x7fef87e0(,%eax,4),%edx
80104a74:	85 d2                	test   %edx,%edx
80104a76:	74 10                	je     80104a88 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104a78:	ff d2                	call   *%edx
80104a7a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	5b                   	pop    %ebx
80104a81:	5e                   	pop    %esi
80104a82:	5d                   	pop    %ebp
80104a83:	c3                   	ret    
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104a88:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
80104a8c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104a8f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104a93:	8b 43 10             	mov    0x10(%ebx),%eax
80104a96:	c7 04 24 01 78 10 80 	movl   $0x80107801,(%esp)
80104a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa1:	e8 aa bb ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104aa6:	8b 43 18             	mov    0x18(%ebx),%eax
80104aa9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ab0:	83 c4 10             	add    $0x10,%esp
80104ab3:	5b                   	pop    %ebx
80104ab4:	5e                   	pop    %esi
80104ab5:	5d                   	pop    %ebp
80104ab6:	c3                   	ret    
80104ab7:	66 90                	xchg   %ax,%ax
80104ab9:	66 90                	xchg   %ax,%ax
80104abb:	66 90                	xchg   %ax,%ax
80104abd:	66 90                	xchg   %ax,%ax
80104abf:	90                   	nop

80104ac0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	89 c3                	mov    %eax,%ebx
80104ac6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104ac9:	e8 f2 eb ff ff       	call   801036c0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80104ace:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104ad0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104ad4:	85 c9                	test   %ecx,%ecx
80104ad6:	74 18                	je     80104af0 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104ad8:	83 c2 01             	add    $0x1,%edx
80104adb:	83 fa 10             	cmp    $0x10,%edx
80104ade:	75 f0                	jne    80104ad0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104ae0:	83 c4 04             	add    $0x4,%esp
  return -1;
80104ae3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ae8:	5b                   	pop    %ebx
80104ae9:	5d                   	pop    %ebp
80104aea:	c3                   	ret    
80104aeb:	90                   	nop
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104af0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104af4:	83 c4 04             	add    $0x4,%esp
      return fd;
80104af7:	89 d0                	mov    %edx,%eax
}
80104af9:	5b                   	pop    %ebx
80104afa:	5d                   	pop    %ebp
80104afb:	c3                   	ret    
80104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
80104b06:	83 ec 4c             	sub    $0x4c,%esp
80104b09:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104b0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b0f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104b12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104b16:	89 04 24             	mov    %eax,(%esp)
{
80104b19:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104b1c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b1f:	e8 0c d4 ff ff       	call   80101f30 <nameiparent>
80104b24:	85 c0                	test   %eax,%eax
80104b26:	89 c7                	mov    %eax,%edi
80104b28:	0f 84 da 00 00 00    	je     80104c08 <create+0x108>
    return 0;
  ilock(dp);
80104b2e:	89 04 24             	mov    %eax,(%esp)
80104b31:	e8 8a cb ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104b36:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b39:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b3d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104b41:	89 3c 24             	mov    %edi,(%esp)
80104b44:	e8 87 d0 ff ff       	call   80101bd0 <dirlookup>
80104b49:	85 c0                	test   %eax,%eax
80104b4b:	89 c6                	mov    %eax,%esi
80104b4d:	74 41                	je     80104b90 <create+0x90>
    iunlockput(dp);
80104b4f:	89 3c 24             	mov    %edi,(%esp)
80104b52:	e8 c9 cd ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104b57:	89 34 24             	mov    %esi,(%esp)
80104b5a:	e8 61 cb ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b5f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104b64:	75 12                	jne    80104b78 <create+0x78>
80104b66:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b6b:	89 f0                	mov    %esi,%eax
80104b6d:	75 09                	jne    80104b78 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b6f:	83 c4 4c             	add    $0x4c,%esp
80104b72:	5b                   	pop    %ebx
80104b73:	5e                   	pop    %esi
80104b74:	5f                   	pop    %edi
80104b75:	5d                   	pop    %ebp
80104b76:	c3                   	ret    
80104b77:	90                   	nop
    iunlockput(ip);
80104b78:	89 34 24             	mov    %esi,(%esp)
80104b7b:	e8 a0 cd ff ff       	call   80101920 <iunlockput>
}
80104b80:	83 c4 4c             	add    $0x4c,%esp
    return 0;
80104b83:	31 c0                	xor    %eax,%eax
}
80104b85:	5b                   	pop    %ebx
80104b86:	5e                   	pop    %esi
80104b87:	5f                   	pop    %edi
80104b88:	5d                   	pop    %ebp
80104b89:	c3                   	ret    
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104b90:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b94:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b98:	8b 07                	mov    (%edi),%eax
80104b9a:	89 04 24             	mov    %eax,(%esp)
80104b9d:	e8 8e c9 ff ff       	call   80101530 <ialloc>
80104ba2:	85 c0                	test   %eax,%eax
80104ba4:	89 c6                	mov    %eax,%esi
80104ba6:	0f 84 bf 00 00 00    	je     80104c6b <create+0x16b>
  ilock(ip);
80104bac:	89 04 24             	mov    %eax,(%esp)
80104baf:	e8 0c cb ff ff       	call   801016c0 <ilock>
  ip->major = major;
80104bb4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104bb8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bbc:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104bc0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104bc4:	b8 01 00 00 00       	mov    $0x1,%eax
80104bc9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bcd:	89 34 24             	mov    %esi,(%esp)
80104bd0:	e8 2b ca ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bd5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104bda:	74 34                	je     80104c10 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104bdc:	8b 46 04             	mov    0x4(%esi),%eax
80104bdf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104be3:	89 3c 24             	mov    %edi,(%esp)
80104be6:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bea:	e8 41 d2 ff ff       	call   80101e30 <dirlink>
80104bef:	85 c0                	test   %eax,%eax
80104bf1:	78 6c                	js     80104c5f <create+0x15f>
  iunlockput(dp);
80104bf3:	89 3c 24             	mov    %edi,(%esp)
80104bf6:	e8 25 cd ff ff       	call   80101920 <iunlockput>
}
80104bfb:	83 c4 4c             	add    $0x4c,%esp
  return ip;
80104bfe:	89 f0                	mov    %esi,%eax
}
80104c00:	5b                   	pop    %ebx
80104c01:	5e                   	pop    %esi
80104c02:	5f                   	pop    %edi
80104c03:	5d                   	pop    %ebp
80104c04:	c3                   	ret    
80104c05:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104c08:	31 c0                	xor    %eax,%eax
80104c0a:	e9 60 ff ff ff       	jmp    80104b6f <create+0x6f>
80104c0f:	90                   	nop
    dp->nlink++;  // for ".."
80104c10:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104c15:	89 3c 24             	mov    %edi,(%esp)
80104c18:	e8 e3 c9 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c1d:	8b 46 04             	mov    0x4(%esi),%eax
80104c20:	c7 44 24 04 a4 78 10 	movl   $0x801078a4,0x4(%esp)
80104c27:	80 
80104c28:	89 34 24             	mov    %esi,(%esp)
80104c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c2f:	e8 fc d1 ff ff       	call   80101e30 <dirlink>
80104c34:	85 c0                	test   %eax,%eax
80104c36:	78 1b                	js     80104c53 <create+0x153>
80104c38:	8b 47 04             	mov    0x4(%edi),%eax
80104c3b:	c7 44 24 04 a3 78 10 	movl   $0x801078a3,0x4(%esp)
80104c42:	80 
80104c43:	89 34 24             	mov    %esi,(%esp)
80104c46:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c4a:	e8 e1 d1 ff ff       	call   80101e30 <dirlink>
80104c4f:	85 c0                	test   %eax,%eax
80104c51:	79 89                	jns    80104bdc <create+0xdc>
      panic("create dots");
80104c53:	c7 04 24 97 78 10 80 	movl   $0x80107897,(%esp)
80104c5a:	e8 01 b7 ff ff       	call   80100360 <panic>
    panic("create: dirlink");
80104c5f:	c7 04 24 a6 78 10 80 	movl   $0x801078a6,(%esp)
80104c66:	e8 f5 b6 ff ff       	call   80100360 <panic>
    panic("create: ialloc");
80104c6b:	c7 04 24 88 78 10 80 	movl   $0x80107888,(%esp)
80104c72:	e8 e9 b6 ff ff       	call   80100360 <panic>
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	89 c6                	mov    %eax,%esi
80104c86:	53                   	push   %ebx
80104c87:	89 d3                	mov    %edx,%ebx
80104c89:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
80104c8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c9a:	e8 e1 fc ff ff       	call   80104980 <argint>
80104c9f:	85 c0                	test   %eax,%eax
80104ca1:	78 2d                	js     80104cd0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ca3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ca7:	77 27                	ja     80104cd0 <argfd.constprop.0+0x50>
80104ca9:	e8 12 ea ff ff       	call   801036c0 <myproc>
80104cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cb1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104cb5:	85 c0                	test   %eax,%eax
80104cb7:	74 17                	je     80104cd0 <argfd.constprop.0+0x50>
  if(pfd)
80104cb9:	85 f6                	test   %esi,%esi
80104cbb:	74 02                	je     80104cbf <argfd.constprop.0+0x3f>
    *pfd = fd;
80104cbd:	89 16                	mov    %edx,(%esi)
  if(pf)
80104cbf:	85 db                	test   %ebx,%ebx
80104cc1:	74 1d                	je     80104ce0 <argfd.constprop.0+0x60>
    *pf = f;
80104cc3:	89 03                	mov    %eax,(%ebx)
  return 0;
80104cc5:	31 c0                	xor    %eax,%eax
}
80104cc7:	83 c4 20             	add    $0x20,%esp
80104cca:	5b                   	pop    %ebx
80104ccb:	5e                   	pop    %esi
80104ccc:	5d                   	pop    %ebp
80104ccd:	c3                   	ret    
80104cce:	66 90                	xchg   %ax,%ax
80104cd0:	83 c4 20             	add    $0x20,%esp
    return -1;
80104cd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cd8:	5b                   	pop    %ebx
80104cd9:	5e                   	pop    %esi
80104cda:	5d                   	pop    %ebp
80104cdb:	c3                   	ret    
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104ce0:	31 c0                	xor    %eax,%eax
80104ce2:	eb e3                	jmp    80104cc7 <argfd.constprop.0+0x47>
80104ce4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104cf0 <sys_dup>:
{
80104cf0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104cf1:	31 c0                	xor    %eax,%eax
{
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	53                   	push   %ebx
80104cf6:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104cf9:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104cfc:	e8 7f ff ff ff       	call   80104c80 <argfd.constprop.0>
80104d01:	85 c0                	test   %eax,%eax
80104d03:	78 23                	js     80104d28 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d08:	e8 b3 fd ff ff       	call   80104ac0 <fdalloc>
80104d0d:	85 c0                	test   %eax,%eax
80104d0f:	89 c3                	mov    %eax,%ebx
80104d11:	78 15                	js     80104d28 <sys_dup+0x38>
  filedup(f);
80104d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d16:	89 04 24             	mov    %eax,(%esp)
80104d19:	e8 c2 c0 ff ff       	call   80100de0 <filedup>
  return fd;
80104d1e:	89 d8                	mov    %ebx,%eax
}
80104d20:	83 c4 24             	add    $0x24,%esp
80104d23:	5b                   	pop    %ebx
80104d24:	5d                   	pop    %ebp
80104d25:	c3                   	ret    
80104d26:	66 90                	xchg   %ax,%ax
    return -1;
80104d28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d2d:	eb f1                	jmp    80104d20 <sys_dup+0x30>
80104d2f:	90                   	nop

80104d30 <sys_read>:
{
80104d30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d31:	31 c0                	xor    %eax,%eax
{
80104d33:	89 e5                	mov    %esp,%ebp
80104d35:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d3b:	e8 40 ff ff ff       	call   80104c80 <argfd.constprop.0>
80104d40:	85 c0                	test   %eax,%eax
80104d42:	78 54                	js     80104d98 <sys_read+0x68>
80104d44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d47:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d4b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104d52:	e8 29 fc ff ff       	call   80104980 <argint>
80104d57:	85 c0                	test   %eax,%eax
80104d59:	78 3d                	js     80104d98 <sys_read+0x68>
80104d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d65:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d70:	e8 3b fc ff ff       	call   801049b0 <argptr>
80104d75:	85 c0                	test   %eax,%eax
80104d77:	78 1f                	js     80104d98 <sys_read+0x68>
  return fileread(f, p, n);
80104d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d7c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d83:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d8a:	89 04 24             	mov    %eax,(%esp)
80104d8d:	e8 ae c1 ff ff       	call   80100f40 <fileread>
}
80104d92:	c9                   	leave  
80104d93:	c3                   	ret    
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d9d:	c9                   	leave  
80104d9e:	c3                   	ret    
80104d9f:	90                   	nop

80104da0 <sys_write>:
{
80104da0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da1:	31 c0                	xor    %eax,%eax
{
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dab:	e8 d0 fe ff ff       	call   80104c80 <argfd.constprop.0>
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 54                	js     80104e08 <sys_write+0x68>
80104db4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104db7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dbb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104dc2:	e8 b9 fb ff ff       	call   80104980 <argint>
80104dc7:	85 c0                	test   %eax,%eax
80104dc9:	78 3d                	js     80104e08 <sys_write+0x68>
80104dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104dd5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104dd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104de0:	e8 cb fb ff ff       	call   801049b0 <argptr>
80104de5:	85 c0                	test   %eax,%eax
80104de7:	78 1f                	js     80104e08 <sys_write+0x68>
  return filewrite(f, p, n);
80104de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dec:	89 44 24 08          	mov    %eax,0x8(%esp)
80104df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104dfa:	89 04 24             	mov    %eax,(%esp)
80104dfd:	e8 de c1 ff ff       	call   80100fe0 <filewrite>
}
80104e02:	c9                   	leave  
80104e03:	c3                   	ret    
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e0d:	c9                   	leave  
80104e0e:	c3                   	ret    
80104e0f:	90                   	nop

80104e10 <sys_close>:
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104e16:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e19:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e1c:	e8 5f fe ff ff       	call   80104c80 <argfd.constprop.0>
80104e21:	85 c0                	test   %eax,%eax
80104e23:	78 23                	js     80104e48 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104e25:	e8 96 e8 ff ff       	call   801036c0 <myproc>
80104e2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e2d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e34:	00 
  fileclose(f);
80104e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e38:	89 04 24             	mov    %eax,(%esp)
80104e3b:	e8 f0 bf ff ff       	call   80100e30 <fileclose>
  return 0;
80104e40:	31 c0                	xor    %eax,%eax
}
80104e42:	c9                   	leave  
80104e43:	c3                   	ret    
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e4d:	c9                   	leave  
80104e4e:	c3                   	ret    
80104e4f:	90                   	nop

80104e50 <sys_fstat>:
{
80104e50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e51:	31 c0                	xor    %eax,%eax
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e58:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e5b:	e8 20 fe ff ff       	call   80104c80 <argfd.constprop.0>
80104e60:	85 c0                	test   %eax,%eax
80104e62:	78 34                	js     80104e98 <sys_fstat+0x48>
80104e64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e67:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104e6e:	00 
80104e6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e7a:	e8 31 fb ff ff       	call   801049b0 <argptr>
80104e7f:	85 c0                	test   %eax,%eax
80104e81:	78 15                	js     80104e98 <sys_fstat+0x48>
  return filestat(f, st);
80104e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e86:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e8d:	89 04 24             	mov    %eax,(%esp)
80104e90:	e8 5b c0 ff ff       	call   80100ef0 <filestat>
}
80104e95:	c9                   	leave  
80104e96:	c3                   	ret    
80104e97:	90                   	nop
    return -1;
80104e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e9d:	c9                   	leave  
80104e9e:	c3                   	ret    
80104e9f:	90                   	nop

80104ea0 <sys_link>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	56                   	push   %esi
80104ea5:	53                   	push   %ebx
80104ea6:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ea9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104eac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104eb7:	e8 54 fb ff ff       	call   80104a10 <argstr>
80104ebc:	85 c0                	test   %eax,%eax
80104ebe:	0f 88 e6 00 00 00    	js     80104faa <sys_link+0x10a>
80104ec4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ecb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ed2:	e8 39 fb ff ff       	call   80104a10 <argstr>
80104ed7:	85 c0                	test   %eax,%eax
80104ed9:	0f 88 cb 00 00 00    	js     80104faa <sys_link+0x10a>
  begin_op();
80104edf:	e8 3c dc ff ff       	call   80102b20 <begin_op>
  if((ip = namei(old)) == 0){
80104ee4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ee7:	89 04 24             	mov    %eax,(%esp)
80104eea:	e8 21 d0 ff ff       	call   80101f10 <namei>
80104eef:	85 c0                	test   %eax,%eax
80104ef1:	89 c3                	mov    %eax,%ebx
80104ef3:	0f 84 ac 00 00 00    	je     80104fa5 <sys_link+0x105>
  ilock(ip);
80104ef9:	89 04 24             	mov    %eax,(%esp)
80104efc:	e8 bf c7 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80104f01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f06:	0f 84 91 00 00 00    	je     80104f9d <sys_link+0xfd>
  ip->nlink++;
80104f0c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f11:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f14:	89 1c 24             	mov    %ebx,(%esp)
80104f17:	e8 e4 c6 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80104f1c:	89 1c 24             	mov    %ebx,(%esp)
80104f1f:	e8 7c c8 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f24:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104f27:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104f2b:	89 04 24             	mov    %eax,(%esp)
80104f2e:	e8 fd cf ff ff       	call   80101f30 <nameiparent>
80104f33:	85 c0                	test   %eax,%eax
80104f35:	89 c6                	mov    %eax,%esi
80104f37:	74 4f                	je     80104f88 <sys_link+0xe8>
  ilock(dp);
80104f39:	89 04 24             	mov    %eax,(%esp)
80104f3c:	e8 7f c7 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f41:	8b 03                	mov    (%ebx),%eax
80104f43:	39 06                	cmp    %eax,(%esi)
80104f45:	75 39                	jne    80104f80 <sys_link+0xe0>
80104f47:	8b 43 04             	mov    0x4(%ebx),%eax
80104f4a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104f4e:	89 34 24             	mov    %esi,(%esp)
80104f51:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f55:	e8 d6 ce ff ff       	call   80101e30 <dirlink>
80104f5a:	85 c0                	test   %eax,%eax
80104f5c:	78 22                	js     80104f80 <sys_link+0xe0>
  iunlockput(dp);
80104f5e:	89 34 24             	mov    %esi,(%esp)
80104f61:	e8 ba c9 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104f66:	89 1c 24             	mov    %ebx,(%esp)
80104f69:	e8 72 c8 ff ff       	call   801017e0 <iput>
  end_op();
80104f6e:	e8 1d dc ff ff       	call   80102b90 <end_op>
}
80104f73:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104f76:	31 c0                	xor    %eax,%eax
}
80104f78:	5b                   	pop    %ebx
80104f79:	5e                   	pop    %esi
80104f7a:	5f                   	pop    %edi
80104f7b:	5d                   	pop    %ebp
80104f7c:	c3                   	ret    
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f80:	89 34 24             	mov    %esi,(%esp)
80104f83:	e8 98 c9 ff ff       	call   80101920 <iunlockput>
  ilock(ip);
80104f88:	89 1c 24             	mov    %ebx,(%esp)
80104f8b:	e8 30 c7 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
80104f90:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f95:	89 1c 24             	mov    %ebx,(%esp)
80104f98:	e8 63 c6 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104f9d:	89 1c 24             	mov    %ebx,(%esp)
80104fa0:	e8 7b c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104fa5:	e8 e6 db ff ff       	call   80102b90 <end_op>
}
80104faa:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104fad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fb2:	5b                   	pop    %ebx
80104fb3:	5e                   	pop    %esi
80104fb4:	5f                   	pop    %edi
80104fb5:	5d                   	pop    %ebp
80104fb6:	c3                   	ret    
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <sys_unlink>:
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	57                   	push   %edi
80104fc4:	56                   	push   %esi
80104fc5:	53                   	push   %ebx
80104fc6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104fc9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104fcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fd7:	e8 34 fa ff ff       	call   80104a10 <argstr>
80104fdc:	85 c0                	test   %eax,%eax
80104fde:	0f 88 76 01 00 00    	js     8010515a <sys_unlink+0x19a>
  begin_op();
80104fe4:	e8 37 db ff ff       	call   80102b20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104fe9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104fec:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104fef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104ff3:	89 04 24             	mov    %eax,(%esp)
80104ff6:	e8 35 cf ff ff       	call   80101f30 <nameiparent>
80104ffb:	85 c0                	test   %eax,%eax
80104ffd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105000:	0f 84 4f 01 00 00    	je     80105155 <sys_unlink+0x195>
  ilock(dp);
80105006:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105009:	89 34 24             	mov    %esi,(%esp)
8010500c:	e8 af c6 ff ff       	call   801016c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105011:	c7 44 24 04 a4 78 10 	movl   $0x801078a4,0x4(%esp)
80105018:	80 
80105019:	89 1c 24             	mov    %ebx,(%esp)
8010501c:	e8 7f cb ff ff       	call   80101ba0 <namecmp>
80105021:	85 c0                	test   %eax,%eax
80105023:	0f 84 21 01 00 00    	je     8010514a <sys_unlink+0x18a>
80105029:	c7 44 24 04 a3 78 10 	movl   $0x801078a3,0x4(%esp)
80105030:	80 
80105031:	89 1c 24             	mov    %ebx,(%esp)
80105034:	e8 67 cb ff ff       	call   80101ba0 <namecmp>
80105039:	85 c0                	test   %eax,%eax
8010503b:	0f 84 09 01 00 00    	je     8010514a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105041:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105044:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105048:	89 44 24 08          	mov    %eax,0x8(%esp)
8010504c:	89 34 24             	mov    %esi,(%esp)
8010504f:	e8 7c cb ff ff       	call   80101bd0 <dirlookup>
80105054:	85 c0                	test   %eax,%eax
80105056:	89 c3                	mov    %eax,%ebx
80105058:	0f 84 ec 00 00 00    	je     8010514a <sys_unlink+0x18a>
  ilock(ip);
8010505e:	89 04 24             	mov    %eax,(%esp)
80105061:	e8 5a c6 ff ff       	call   801016c0 <ilock>
  if(ip->nlink < 1)
80105066:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010506b:	0f 8e 24 01 00 00    	jle    80105195 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105071:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105076:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105079:	74 7d                	je     801050f8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
8010507b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105082:	00 
80105083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010508a:	00 
8010508b:	89 34 24             	mov    %esi,(%esp)
8010508e:	e8 fd f5 ff ff       	call   80104690 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105093:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105096:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010509d:	00 
8010509e:	89 74 24 04          	mov    %esi,0x4(%esp)
801050a2:	89 44 24 08          	mov    %eax,0x8(%esp)
801050a6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801050a9:	89 04 24             	mov    %eax,(%esp)
801050ac:	e8 bf c9 ff ff       	call   80101a70 <writei>
801050b1:	83 f8 10             	cmp    $0x10,%eax
801050b4:	0f 85 cf 00 00 00    	jne    80105189 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801050ba:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050bf:	0f 84 a3 00 00 00    	je     80105168 <sys_unlink+0x1a8>
  iunlockput(dp);
801050c5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801050c8:	89 04 24             	mov    %eax,(%esp)
801050cb:	e8 50 c8 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
801050d0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050d5:	89 1c 24             	mov    %ebx,(%esp)
801050d8:	e8 23 c5 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
801050dd:	89 1c 24             	mov    %ebx,(%esp)
801050e0:	e8 3b c8 ff ff       	call   80101920 <iunlockput>
  end_op();
801050e5:	e8 a6 da ff ff       	call   80102b90 <end_op>
}
801050ea:	83 c4 5c             	add    $0x5c,%esp
  return 0;
801050ed:	31 c0                	xor    %eax,%eax
}
801050ef:	5b                   	pop    %ebx
801050f0:	5e                   	pop    %esi
801050f1:	5f                   	pop    %edi
801050f2:	5d                   	pop    %ebp
801050f3:	c3                   	ret    
801050f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050f8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050fc:	0f 86 79 ff ff ff    	jbe    8010507b <sys_unlink+0xbb>
80105102:	bf 20 00 00 00       	mov    $0x20,%edi
80105107:	eb 15                	jmp    8010511e <sys_unlink+0x15e>
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105110:	8d 57 10             	lea    0x10(%edi),%edx
80105113:	3b 53 58             	cmp    0x58(%ebx),%edx
80105116:	0f 83 5f ff ff ff    	jae    8010507b <sys_unlink+0xbb>
8010511c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010511e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105125:	00 
80105126:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010512a:	89 74 24 04          	mov    %esi,0x4(%esp)
8010512e:	89 1c 24             	mov    %ebx,(%esp)
80105131:	e8 3a c8 ff ff       	call   80101970 <readi>
80105136:	83 f8 10             	cmp    $0x10,%eax
80105139:	75 42                	jne    8010517d <sys_unlink+0x1bd>
    if(de.inum != 0)
8010513b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105140:	74 ce                	je     80105110 <sys_unlink+0x150>
    iunlockput(ip);
80105142:	89 1c 24             	mov    %ebx,(%esp)
80105145:	e8 d6 c7 ff ff       	call   80101920 <iunlockput>
  iunlockput(dp);
8010514a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010514d:	89 04 24             	mov    %eax,(%esp)
80105150:	e8 cb c7 ff ff       	call   80101920 <iunlockput>
  end_op();
80105155:	e8 36 da ff ff       	call   80102b90 <end_op>
}
8010515a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
8010515d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105162:	5b                   	pop    %ebx
80105163:	5e                   	pop    %esi
80105164:	5f                   	pop    %edi
80105165:	5d                   	pop    %ebp
80105166:	c3                   	ret    
80105167:	90                   	nop
    dp->nlink--;
80105168:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010516b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105170:	89 04 24             	mov    %eax,(%esp)
80105173:	e8 88 c4 ff ff       	call   80101600 <iupdate>
80105178:	e9 48 ff ff ff       	jmp    801050c5 <sys_unlink+0x105>
      panic("isdirempty: readi");
8010517d:	c7 04 24 c8 78 10 80 	movl   $0x801078c8,(%esp)
80105184:	e8 d7 b1 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80105189:	c7 04 24 da 78 10 80 	movl   $0x801078da,(%esp)
80105190:	e8 cb b1 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80105195:	c7 04 24 b6 78 10 80 	movl   $0x801078b6,(%esp)
8010519c:	e8 bf b1 ff ff       	call   80100360 <panic>
801051a1:	eb 0d                	jmp    801051b0 <sys_open>
801051a3:	90                   	nop
801051a4:	90                   	nop
801051a5:	90                   	nop
801051a6:	90                   	nop
801051a7:	90                   	nop
801051a8:	90                   	nop
801051a9:	90                   	nop
801051aa:	90                   	nop
801051ab:	90                   	nop
801051ac:	90                   	nop
801051ad:	90                   	nop
801051ae:	90                   	nop
801051af:	90                   	nop

801051b0 <sys_open>:

int
sys_open(void)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
801051b6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051b9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801051bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801051c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051c7:	e8 44 f8 ff ff       	call   80104a10 <argstr>
801051cc:	85 c0                	test   %eax,%eax
801051ce:	0f 88 d1 00 00 00    	js     801052a5 <sys_open+0xf5>
801051d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801051d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801051db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051e2:	e8 99 f7 ff ff       	call   80104980 <argint>
801051e7:	85 c0                	test   %eax,%eax
801051e9:	0f 88 b6 00 00 00    	js     801052a5 <sys_open+0xf5>
    return -1;

  begin_op();
801051ef:	e8 2c d9 ff ff       	call   80102b20 <begin_op>

  if(omode & O_CREATE){
801051f4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801051f8:	0f 85 82 00 00 00    	jne    80105280 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801051fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105201:	89 04 24             	mov    %eax,(%esp)
80105204:	e8 07 cd ff ff       	call   80101f10 <namei>
80105209:	85 c0                	test   %eax,%eax
8010520b:	89 c6                	mov    %eax,%esi
8010520d:	0f 84 8d 00 00 00    	je     801052a0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80105213:	89 04 24             	mov    %eax,(%esp)
80105216:	e8 a5 c4 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010521b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105220:	0f 84 92 00 00 00    	je     801052b8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105226:	e8 45 bb ff ff       	call   80100d70 <filealloc>
8010522b:	85 c0                	test   %eax,%eax
8010522d:	89 c3                	mov    %eax,%ebx
8010522f:	0f 84 93 00 00 00    	je     801052c8 <sys_open+0x118>
80105235:	e8 86 f8 ff ff       	call   80104ac0 <fdalloc>
8010523a:	85 c0                	test   %eax,%eax
8010523c:	89 c7                	mov    %eax,%edi
8010523e:	0f 88 94 00 00 00    	js     801052d8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105244:	89 34 24             	mov    %esi,(%esp)
80105247:	e8 54 c5 ff ff       	call   801017a0 <iunlock>
  end_op();
8010524c:	e8 3f d9 ff ff       	call   80102b90 <end_op>

  f->type = FD_INODE;
80105251:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
8010525a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010525d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80105264:	89 c2                	mov    %eax,%edx
80105266:	83 e2 01             	and    $0x1,%edx
80105269:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010526c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
8010526e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80105271:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105273:	0f 95 43 09          	setne  0x9(%ebx)
}
80105277:	83 c4 2c             	add    $0x2c,%esp
8010527a:	5b                   	pop    %ebx
8010527b:	5e                   	pop    %esi
8010527c:	5f                   	pop    %edi
8010527d:	5d                   	pop    %ebp
8010527e:	c3                   	ret    
8010527f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80105280:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105283:	31 c9                	xor    %ecx,%ecx
80105285:	ba 02 00 00 00       	mov    $0x2,%edx
8010528a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105291:	e8 6a f8 ff ff       	call   80104b00 <create>
    if(ip == 0){
80105296:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105298:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010529a:	75 8a                	jne    80105226 <sys_open+0x76>
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801052a0:	e8 eb d8 ff ff       	call   80102b90 <end_op>
}
801052a5:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801052a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ad:	5b                   	pop    %ebx
801052ae:	5e                   	pop    %esi
801052af:	5f                   	pop    %edi
801052b0:	5d                   	pop    %ebp
801052b1:	c3                   	ret    
801052b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801052b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801052bb:	85 c0                	test   %eax,%eax
801052bd:	0f 84 63 ff ff ff    	je     80105226 <sys_open+0x76>
801052c3:	90                   	nop
801052c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
801052c8:	89 34 24             	mov    %esi,(%esp)
801052cb:	e8 50 c6 ff ff       	call   80101920 <iunlockput>
801052d0:	eb ce                	jmp    801052a0 <sys_open+0xf0>
801052d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
801052d8:	89 1c 24             	mov    %ebx,(%esp)
801052db:	e8 50 bb ff ff       	call   80100e30 <fileclose>
801052e0:	eb e6                	jmp    801052c8 <sys_open+0x118>
801052e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052f6:	e8 25 d8 ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105302:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105309:	e8 02 f7 ff ff       	call   80104a10 <argstr>
8010530e:	85 c0                	test   %eax,%eax
80105310:	78 2e                	js     80105340 <sys_mkdir+0x50>
80105312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105315:	31 c9                	xor    %ecx,%ecx
80105317:	ba 01 00 00 00       	mov    $0x1,%edx
8010531c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105323:	e8 d8 f7 ff ff       	call   80104b00 <create>
80105328:	85 c0                	test   %eax,%eax
8010532a:	74 14                	je     80105340 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010532c:	89 04 24             	mov    %eax,(%esp)
8010532f:	e8 ec c5 ff ff       	call   80101920 <iunlockput>
  end_op();
80105334:	e8 57 d8 ff ff       	call   80102b90 <end_op>
  return 0;
80105339:	31 c0                	xor    %eax,%eax
}
8010533b:	c9                   	leave  
8010533c:	c3                   	ret    
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105340:	e8 4b d8 ff ff       	call   80102b90 <end_op>
    return -1;
80105345:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010534a:	c9                   	leave  
8010534b:	c3                   	ret    
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105350 <sys_mknod>:

int
sys_mknod(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105356:	e8 c5 d7 ff ff       	call   80102b20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010535b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010535e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105362:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105369:	e8 a2 f6 ff ff       	call   80104a10 <argstr>
8010536e:	85 c0                	test   %eax,%eax
80105370:	78 5e                	js     801053d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105372:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105375:	89 44 24 04          	mov    %eax,0x4(%esp)
80105379:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105380:	e8 fb f5 ff ff       	call   80104980 <argint>
  if((argstr(0, &path)) < 0 ||
80105385:	85 c0                	test   %eax,%eax
80105387:	78 47                	js     801053d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105389:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010538c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105390:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105397:	e8 e4 f5 ff ff       	call   80104980 <argint>
     argint(1, &major) < 0 ||
8010539c:	85 c0                	test   %eax,%eax
8010539e:	78 30                	js     801053d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801053a0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801053a4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801053a9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801053ad:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
801053b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053b3:	e8 48 f7 ff ff       	call   80104b00 <create>
801053b8:	85 c0                	test   %eax,%eax
801053ba:	74 14                	je     801053d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053bc:	89 04 24             	mov    %eax,(%esp)
801053bf:	e8 5c c5 ff ff       	call   80101920 <iunlockput>
  end_op();
801053c4:	e8 c7 d7 ff ff       	call   80102b90 <end_op>
  return 0;
801053c9:	31 c0                	xor    %eax,%eax
}
801053cb:	c9                   	leave  
801053cc:	c3                   	ret    
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
801053d0:	e8 bb d7 ff ff       	call   80102b90 <end_op>
    return -1;
801053d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053da:	c9                   	leave  
801053db:	c3                   	ret    
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <sys_chdir>:

int
sys_chdir(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
801053e5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801053e8:	e8 d3 e2 ff ff       	call   801036c0 <myproc>
801053ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801053ef:	e8 2c d7 ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801053fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105402:	e8 09 f6 ff ff       	call   80104a10 <argstr>
80105407:	85 c0                	test   %eax,%eax
80105409:	78 4a                	js     80105455 <sys_chdir+0x75>
8010540b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010540e:	89 04 24             	mov    %eax,(%esp)
80105411:	e8 fa ca ff ff       	call   80101f10 <namei>
80105416:	85 c0                	test   %eax,%eax
80105418:	89 c3                	mov    %eax,%ebx
8010541a:	74 39                	je     80105455 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010541c:	89 04 24             	mov    %eax,(%esp)
8010541f:	e8 9c c2 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105424:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105429:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010542c:	75 22                	jne    80105450 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010542e:	e8 6d c3 ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105433:	8b 46 68             	mov    0x68(%esi),%eax
80105436:	89 04 24             	mov    %eax,(%esp)
80105439:	e8 a2 c3 ff ff       	call   801017e0 <iput>
  end_op();
8010543e:	e8 4d d7 ff ff       	call   80102b90 <end_op>
  curproc->cwd = ip;
  return 0;
80105443:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105445:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105448:	83 c4 20             	add    $0x20,%esp
8010544b:	5b                   	pop    %ebx
8010544c:	5e                   	pop    %esi
8010544d:	5d                   	pop    %ebp
8010544e:	c3                   	ret    
8010544f:	90                   	nop
    iunlockput(ip);
80105450:	e8 cb c4 ff ff       	call   80101920 <iunlockput>
    end_op();
80105455:	e8 36 d7 ff ff       	call   80102b90 <end_op>
}
8010545a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010545d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105462:	5b                   	pop    %ebx
80105463:	5e                   	pop    %esi
80105464:	5d                   	pop    %ebp
80105465:	c3                   	ret    
80105466:	8d 76 00             	lea    0x0(%esi),%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <sys_exec>:

int
sys_exec(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
80105475:	53                   	push   %ebx
80105476:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010547c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105482:	89 44 24 04          	mov    %eax,0x4(%esp)
80105486:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010548d:	e8 7e f5 ff ff       	call   80104a10 <argstr>
80105492:	85 c0                	test   %eax,%eax
80105494:	0f 88 84 00 00 00    	js     8010551e <sys_exec+0xae>
8010549a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801054a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801054a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054ab:	e8 d0 f4 ff ff       	call   80104980 <argint>
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 6a                	js     8010551e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801054b4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801054ba:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801054bc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801054c3:	00 
801054c4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801054ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054d1:	00 
801054d2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801054d8:	89 04 24             	mov    %eax,(%esp)
801054db:	e8 b0 f1 ff ff       	call   80104690 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054e0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801054ea:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801054ed:	89 04 24             	mov    %eax,(%esp)
801054f0:	e8 eb f3 ff ff       	call   801048e0 <fetchint>
801054f5:	85 c0                	test   %eax,%eax
801054f7:	78 25                	js     8010551e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801054f9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054ff:	85 c0                	test   %eax,%eax
80105501:	74 2d                	je     80105530 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105503:	89 74 24 04          	mov    %esi,0x4(%esp)
80105507:	89 04 24             	mov    %eax,(%esp)
8010550a:	e8 11 f4 ff ff       	call   80104920 <fetchstr>
8010550f:	85 c0                	test   %eax,%eax
80105511:	78 0b                	js     8010551e <sys_exec+0xae>
  for(i=0;; i++){
80105513:	83 c3 01             	add    $0x1,%ebx
80105516:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105519:	83 fb 20             	cmp    $0x20,%ebx
8010551c:	75 c2                	jne    801054e0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010551e:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105524:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105529:	5b                   	pop    %ebx
8010552a:	5e                   	pop    %esi
8010552b:	5f                   	pop    %edi
8010552c:	5d                   	pop    %ebp
8010552d:	c3                   	ret    
8010552e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105530:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105536:	89 44 24 04          	mov    %eax,0x4(%esp)
8010553a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105540:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105547:	00 00 00 00 
  return exec(path, argv);
8010554b:	89 04 24             	mov    %eax,(%esp)
8010554e:	e8 4d b4 ff ff       	call   801009a0 <exec>
}
80105553:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105559:	5b                   	pop    %ebx
8010555a:	5e                   	pop    %esi
8010555b:	5f                   	pop    %edi
8010555c:	5d                   	pop    %ebp
8010555d:	c3                   	ret    
8010555e:	66 90                	xchg   %ax,%ax

80105560 <sys_pipe>:

int
sys_pipe(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	53                   	push   %ebx
80105564:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105567:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010556a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105571:	00 
80105572:	89 44 24 04          	mov    %eax,0x4(%esp)
80105576:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010557d:	e8 2e f4 ff ff       	call   801049b0 <argptr>
80105582:	85 c0                	test   %eax,%eax
80105584:	78 6d                	js     801055f3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105586:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105589:	89 44 24 04          	mov    %eax,0x4(%esp)
8010558d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105590:	89 04 24             	mov    %eax,(%esp)
80105593:	e8 e8 db ff ff       	call   80103180 <pipealloc>
80105598:	85 c0                	test   %eax,%eax
8010559a:	78 57                	js     801055f3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010559c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010559f:	e8 1c f5 ff ff       	call   80104ac0 <fdalloc>
801055a4:	85 c0                	test   %eax,%eax
801055a6:	89 c3                	mov    %eax,%ebx
801055a8:	78 33                	js     801055dd <sys_pipe+0x7d>
801055aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ad:	e8 0e f5 ff ff       	call   80104ac0 <fdalloc>
801055b2:	85 c0                	test   %eax,%eax
801055b4:	78 1a                	js     801055d0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801055b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801055b9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801055bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801055be:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801055c1:	83 c4 24             	add    $0x24,%esp
  return 0;
801055c4:	31 c0                	xor    %eax,%eax
}
801055c6:	5b                   	pop    %ebx
801055c7:	5d                   	pop    %ebp
801055c8:	c3                   	ret    
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801055d0:	e8 eb e0 ff ff       	call   801036c0 <myproc>
801055d5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801055dc:	00 
    fileclose(rf);
801055dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055e0:	89 04 24             	mov    %eax,(%esp)
801055e3:	e8 48 b8 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
801055e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055eb:	89 04 24             	mov    %eax,(%esp)
801055ee:	e8 3d b8 ff ff       	call   80100e30 <fileclose>
}
801055f3:	83 c4 24             	add    $0x24,%esp
    return -1;
801055f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055fb:	5b                   	pop    %ebx
801055fc:	5d                   	pop    %ebp
801055fd:	c3                   	ret    
801055fe:	66 90                	xchg   %ax,%ax

80105600 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105603:	5d                   	pop    %ebp
  return fork();
80105604:	e9 67 e2 ff ff       	jmp    80103870 <fork>
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_exit>:

int
sys_exit(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 08             	sub    $0x8,%esp
  exit();
80105616:	e8 f5 e4 ff ff       	call   80103b10 <exit>
  return 0;  // not reached
}
8010561b:	31 c0                	xor    %eax,%eax
8010561d:	c9                   	leave  
8010561e:	c3                   	ret    
8010561f:	90                   	nop

80105620 <sys_exitS>:

int
sys_exitS(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 28             	sub    $0x28,%esp
  int status;
 
  if(argint(0, &status) < 0)
80105626:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105629:	89 44 24 04          	mov    %eax,0x4(%esp)
8010562d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105634:	e8 47 f3 ff ff       	call   80104980 <argint>
80105639:	85 c0                	test   %eax,%eax
8010563b:	78 13                	js     80105650 <sys_exitS+0x30>
    return -1;
  exitS(status);
8010563d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105640:	89 04 24             	mov    %eax,(%esp)
80105643:	e8 f8 e5 ff ff       	call   80103c40 <exitS>
  return 0;  // not reached
80105648:	31 c0                	xor    %eax,%eax
}
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <sys_wait>:


int
sys_wait(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105663:	5d                   	pop    %ebp
  return wait();
80105664:	e9 f7 e7 ff ff       	jmp    80103e60 <wait>
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_waitS>:

int
sys_waitS(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 28             	sub    $0x28,%esp
  int *wait_status;

  if(argptr(0,(void*)&wait_status ,sizeof(*wait_status)) < 0)
80105676:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105679:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105680:	00 
80105681:	89 44 24 04          	mov    %eax,0x4(%esp)
80105685:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010568c:	e8 1f f3 ff ff       	call   801049b0 <argptr>
80105691:	85 c0                	test   %eax,%eax
80105693:	78 13                	js     801056a8 <sys_waitS+0x38>
     return -1;
  return waitS(wait_status);
80105695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105698:	89 04 24             	mov    %eax,(%esp)
8010569b:	e8 b0 e8 ff ff       	call   80103f50 <waitS>
}
801056a0:	c9                   	leave  
801056a1:	c3                   	ret    
801056a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     return -1;
801056a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ad:	c9                   	leave  
801056ae:	c3                   	ret    
801056af:	90                   	nop

801056b0 <sys_waitpid>:

int sys_waitpid(void){
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	83 ec 28             	sub    $0x28,%esp
  int *wait_status;
  int pid;
  int options;

  if(argint(0, &pid) < 0)
801056b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801056bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056c4:	e8 b7 f2 ff ff       	call   80104980 <argint>
801056c9:	85 c0                	test   %eax,%eax
801056cb:	78 53                	js     80105720 <sys_waitpid+0x70>
    return -1;

  if(argptr(1,(void*)&wait_status ,sizeof(*wait_status)) < 0)
801056cd:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056d0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801056d7:	00 
801056d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801056dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056e3:	e8 c8 f2 ff ff       	call   801049b0 <argptr>
801056e8:	85 c0                	test   %eax,%eax
801056ea:	78 34                	js     80105720 <sys_waitpid+0x70>
     return -1;

  if(argint(2, &options) < 0)
801056ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801056f3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801056fa:	e8 81 f2 ff ff       	call   80104980 <argint>
801056ff:	85 c0                	test   %eax,%eax
80105701:	78 1d                	js     80105720 <sys_waitpid+0x70>
     return -1;

  return waitpid(pid,wait_status,options); 
80105703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105706:	89 44 24 08          	mov    %eax,0x8(%esp)
8010570a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010570d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105711:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105714:	89 04 24             	mov    %eax,(%esp)
80105717:	e8 24 e9 ff ff       	call   80104040 <waitpid>

}
8010571c:	c9                   	leave  
8010571d:	c3                   	ret    
8010571e:	66 90                	xchg   %ax,%ax
    return -1;
80105720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105725:	c9                   	leave  
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_setpriority>:
int sys_setpriority(void){
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 28             	sub    $0x28,%esp
   int new_priority;

   if(argint(0, &new_priority) < 0)
80105736:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105739:	89 44 24 04          	mov    %eax,0x4(%esp)
8010573d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105744:	e8 37 f2 ff ff       	call   80104980 <argint>
80105749:	85 c0                	test   %eax,%eax
8010574b:	78 13                	js     80105760 <sys_setpriority+0x30>
      return -1;
   setpriority(new_priority);
8010574d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105750:	89 04 24             	mov    %eax,(%esp)
80105753:	e8 c8 e2 ff ff       	call   80103a20 <setpriority>
   return 0;
80105758:	31 c0                	xor    %eax,%eax
}
8010575a:	c9                   	leave  
8010575b:	c3                   	ret    
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80105760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105765:	c9                   	leave  
80105766:	c3                   	ret    
80105767:	89 f6                	mov    %esi,%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105770 <sys_kill>:


int
sys_kill(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105776:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105779:	89 44 24 04          	mov    %eax,0x4(%esp)
8010577d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105784:	e8 f7 f1 ff ff       	call   80104980 <argint>
80105789:	85 c0                	test   %eax,%eax
8010578b:	78 13                	js     801057a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010578d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105790:	89 04 24             	mov    %eax,(%esp)
80105793:	e8 48 ea ff ff       	call   801041e0 <kill>
}
80105798:	c9                   	leave  
80105799:	c3                   	ret    
8010579a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057b0 <sys_getpid>:

int
sys_getpid(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057b6:	e8 05 df ff ff       	call   801036c0 <myproc>
801057bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801057be:	c9                   	leave  
801057bf:	c3                   	ret    

801057c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	53                   	push   %ebx
801057c4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057d5:	e8 a6 f1 ff ff       	call   80104980 <argint>
801057da:	85 c0                	test   %eax,%eax
801057dc:	78 22                	js     80105800 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057de:	e8 dd de ff ff       	call   801036c0 <myproc>
  if(growproc(n) < 0)
801057e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
801057e6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057e8:	89 14 24             	mov    %edx,(%esp)
801057eb:	e8 10 e0 ff ff       	call   80103800 <growproc>
801057f0:	85 c0                	test   %eax,%eax
801057f2:	78 0c                	js     80105800 <sys_sbrk+0x40>
    return -1;
  return addr;
801057f4:	89 d8                	mov    %ebx,%eax
}
801057f6:	83 c4 24             	add    $0x24,%esp
801057f9:	5b                   	pop    %ebx
801057fa:	5d                   	pop    %ebp
801057fb:	c3                   	ret    
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105805:	eb ef                	jmp    801057f6 <sys_sbrk+0x36>
80105807:	89 f6                	mov    %esi,%esi
80105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105810 <sys_sleep>:

int
sys_sleep(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	53                   	push   %ebx
80105814:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105817:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010581a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010581e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105825:	e8 56 f1 ff ff       	call   80104980 <argint>
8010582a:	85 c0                	test   %eax,%eax
8010582c:	78 7e                	js     801058ac <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010582e:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105835:	e8 96 ed ff ff       	call   801045d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010583a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010583d:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  while(ticks - ticks0 < n){
80105843:	85 d2                	test   %edx,%edx
80105845:	75 29                	jne    80105870 <sys_sleep+0x60>
80105847:	eb 4f                	jmp    80105898 <sys_sleep+0x88>
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105850:	c7 44 24 04 60 4f 11 	movl   $0x80114f60,0x4(%esp)
80105857:	80 
80105858:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
8010585f:	e8 4c e5 ff ff       	call   80103db0 <sleep>
  while(ticks - ticks0 < n){
80105864:	a1 a0 57 11 80       	mov    0x801157a0,%eax
80105869:	29 d8                	sub    %ebx,%eax
8010586b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010586e:	73 28                	jae    80105898 <sys_sleep+0x88>
    if(myproc()->killed){
80105870:	e8 4b de ff ff       	call   801036c0 <myproc>
80105875:	8b 40 24             	mov    0x24(%eax),%eax
80105878:	85 c0                	test   %eax,%eax
8010587a:	74 d4                	je     80105850 <sys_sleep+0x40>
      release(&tickslock);
8010587c:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105883:	e8 b8 ed ff ff       	call   80104640 <release>
      return -1;
80105888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010588d:	83 c4 24             	add    $0x24,%esp
80105890:	5b                   	pop    %ebx
80105891:	5d                   	pop    %ebp
80105892:	c3                   	ret    
80105893:	90                   	nop
80105894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105898:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
8010589f:	e8 9c ed ff ff       	call   80104640 <release>
}
801058a4:	83 c4 24             	add    $0x24,%esp
  return 0;
801058a7:	31 c0                	xor    %eax,%eax
}
801058a9:	5b                   	pop    %ebx
801058aa:	5d                   	pop    %ebp
801058ab:	c3                   	ret    
    return -1;
801058ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b1:	eb da                	jmp    8010588d <sys_sleep+0x7d>
801058b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	53                   	push   %ebx
801058c4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801058c7:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
801058ce:	e8 fd ec ff ff       	call   801045d0 <acquire>
  xticks = ticks;
801058d3:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  release(&tickslock);
801058d9:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
801058e0:	e8 5b ed ff ff       	call   80104640 <release>
  return xticks;
}
801058e5:	83 c4 14             	add    $0x14,%esp
801058e8:	89 d8                	mov    %ebx,%eax
801058ea:	5b                   	pop    %ebx
801058eb:	5d                   	pop    %ebp
801058ec:	c3                   	ret    

801058ed <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ed:	1e                   	push   %ds
  pushl %es
801058ee:	06                   	push   %es
  pushl %fs
801058ef:	0f a0                	push   %fs
  pushl %gs
801058f1:	0f a8                	push   %gs
  pushal
801058f3:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058f4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058f8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058fa:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058fc:	54                   	push   %esp
  call trap
801058fd:	e8 de 00 00 00       	call   801059e0 <trap>
  addl $4, %esp
80105902:	83 c4 04             	add    $0x4,%esp

80105905 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105905:	61                   	popa   
  popl %gs
80105906:	0f a9                	pop    %gs
  popl %fs
80105908:	0f a1                	pop    %fs
  popl %es
8010590a:	07                   	pop    %es
  popl %ds
8010590b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010590c:	83 c4 08             	add    $0x8,%esp
  iret
8010590f:	cf                   	iret   

80105910 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105910:	31 c0                	xor    %eax,%eax
80105912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105918:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010591f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105924:	66 89 0c c5 a2 4f 11 	mov    %cx,-0x7feeb05e(,%eax,8)
8010592b:	80 
8010592c:	c6 04 c5 a4 4f 11 80 	movb   $0x0,-0x7feeb05c(,%eax,8)
80105933:	00 
80105934:	c6 04 c5 a5 4f 11 80 	movb   $0x8e,-0x7feeb05b(,%eax,8)
8010593b:	8e 
8010593c:	66 89 14 c5 a0 4f 11 	mov    %dx,-0x7feeb060(,%eax,8)
80105943:	80 
80105944:	c1 ea 10             	shr    $0x10,%edx
80105947:	66 89 14 c5 a6 4f 11 	mov    %dx,-0x7feeb05a(,%eax,8)
8010594e:	80 
  for(i = 0; i < 256; i++)
8010594f:	83 c0 01             	add    $0x1,%eax
80105952:	3d 00 01 00 00       	cmp    $0x100,%eax
80105957:	75 bf                	jne    80105918 <tvinit+0x8>
{
80105959:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010595a:	ba 08 00 00 00       	mov    $0x8,%edx
{
8010595f:	89 e5                	mov    %esp,%ebp
80105961:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105964:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105969:	c7 44 24 04 e9 78 10 	movl   $0x801078e9,0x4(%esp)
80105970:	80 
80105971:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105978:	66 89 15 a2 51 11 80 	mov    %dx,0x801151a2
8010597f:	66 a3 a0 51 11 80    	mov    %ax,0x801151a0
80105985:	c1 e8 10             	shr    $0x10,%eax
80105988:	c6 05 a4 51 11 80 00 	movb   $0x0,0x801151a4
8010598f:	c6 05 a5 51 11 80 ef 	movb   $0xef,0x801151a5
80105996:	66 a3 a6 51 11 80    	mov    %ax,0x801151a6
  initlock(&tickslock, "time");
8010599c:	e8 bf ea ff ff       	call   80104460 <initlock>
}
801059a1:	c9                   	leave  
801059a2:	c3                   	ret    
801059a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059b0 <idtinit>:

void
idtinit(void)
{
801059b0:	55                   	push   %ebp
  pd[0] = size-1;
801059b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059b6:	89 e5                	mov    %esp,%ebp
801059b8:	83 ec 10             	sub    $0x10,%esp
801059bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059bf:	b8 a0 4f 11 80       	mov    $0x80114fa0,%eax
801059c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059c8:	c1 e8 10             	shr    $0x10,%eax
801059cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
801059e5:	53                   	push   %ebx
801059e6:	83 ec 3c             	sub    $0x3c,%esp
801059e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059ec:	8b 43 30             	mov    0x30(%ebx),%eax
801059ef:	83 f8 40             	cmp    $0x40,%eax
801059f2:	0f 84 a0 01 00 00    	je     80105b98 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059f8:	83 e8 20             	sub    $0x20,%eax
801059fb:	83 f8 1f             	cmp    $0x1f,%eax
801059fe:	77 08                	ja     80105a08 <trap+0x28>
80105a00:	ff 24 85 90 79 10 80 	jmp    *-0x7fef8670(,%eax,4)
80105a07:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a08:	e8 b3 dc ff ff       	call   801036c0 <myproc>
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	90                   	nop
80105a10:	0f 84 fa 01 00 00    	je     80105c10 <trap+0x230>
80105a16:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a1a:	0f 84 f0 01 00 00    	je     80105c10 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a20:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a23:	8b 53 38             	mov    0x38(%ebx),%edx
80105a26:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105a29:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105a2c:	e8 6f dc ff ff       	call   801036a0 <cpuid>
80105a31:	8b 73 30             	mov    0x30(%ebx),%esi
80105a34:	89 c7                	mov    %eax,%edi
80105a36:	8b 43 34             	mov    0x34(%ebx),%eax
80105a39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a3c:	e8 7f dc ff ff       	call   801036c0 <myproc>
80105a41:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a44:	e8 77 dc ff ff       	call   801036c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a49:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a4c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a50:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a53:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a56:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105a5a:	89 54 24 18          	mov    %edx,0x18(%esp)
80105a5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105a61:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a64:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a68:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a6c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105a70:	8b 40 10             	mov    0x10(%eax),%eax
80105a73:	c7 04 24 4c 79 10 80 	movl   $0x8010794c,(%esp)
80105a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a7e:	e8 cd ab ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a83:	e8 38 dc ff ff       	call   801036c0 <myproc>
80105a88:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105a8f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a90:	e8 2b dc ff ff       	call   801036c0 <myproc>
80105a95:	85 c0                	test   %eax,%eax
80105a97:	74 0c                	je     80105aa5 <trap+0xc5>
80105a99:	e8 22 dc ff ff       	call   801036c0 <myproc>
80105a9e:	8b 50 24             	mov    0x24(%eax),%edx
80105aa1:	85 d2                	test   %edx,%edx
80105aa3:	75 4b                	jne    80105af0 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105aa5:	e8 16 dc ff ff       	call   801036c0 <myproc>
80105aaa:	85 c0                	test   %eax,%eax
80105aac:	74 0d                	je     80105abb <trap+0xdb>
80105aae:	66 90                	xchg   %ax,%ax
80105ab0:	e8 0b dc ff ff       	call   801036c0 <myproc>
80105ab5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ab9:	74 4d                	je     80105b08 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105abb:	e8 00 dc ff ff       	call   801036c0 <myproc>
80105ac0:	85 c0                	test   %eax,%eax
80105ac2:	74 1d                	je     80105ae1 <trap+0x101>
80105ac4:	e8 f7 db ff ff       	call   801036c0 <myproc>
80105ac9:	8b 40 24             	mov    0x24(%eax),%eax
80105acc:	85 c0                	test   %eax,%eax
80105ace:	74 11                	je     80105ae1 <trap+0x101>
80105ad0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ad4:	83 e0 03             	and    $0x3,%eax
80105ad7:	66 83 f8 03          	cmp    $0x3,%ax
80105adb:	0f 84 e8 00 00 00    	je     80105bc9 <trap+0x1e9>
    exit();
}
80105ae1:	83 c4 3c             	add    $0x3c,%esp
80105ae4:	5b                   	pop    %ebx
80105ae5:	5e                   	pop    %esi
80105ae6:	5f                   	pop    %edi
80105ae7:	5d                   	pop    %ebp
80105ae8:	c3                   	ret    
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105af0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105af4:	83 e0 03             	and    $0x3,%eax
80105af7:	66 83 f8 03          	cmp    $0x3,%ax
80105afb:	75 a8                	jne    80105aa5 <trap+0xc5>
    exit();
80105afd:	e8 0e e0 ff ff       	call   80103b10 <exit>
80105b02:	eb a1                	jmp    80105aa5 <trap+0xc5>
80105b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105b08:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b10:	75 a9                	jne    80105abb <trap+0xdb>
    yield();
80105b12:	e8 59 e2 ff ff       	call   80103d70 <yield>
80105b17:	eb a2                	jmp    80105abb <trap+0xdb>
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105b20:	e8 7b db ff ff       	call   801036a0 <cpuid>
80105b25:	85 c0                	test   %eax,%eax
80105b27:	0f 84 b3 00 00 00    	je     80105be0 <trap+0x200>
80105b2d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105b30:	e8 5b cc ff ff       	call   80102790 <lapiceoi>
    break;
80105b35:	e9 56 ff ff ff       	jmp    80105a90 <trap+0xb0>
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105b40:	e8 9b ca ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
80105b45:	e8 46 cc ff ff       	call   80102790 <lapiceoi>
    break;
80105b4a:	e9 41 ff ff ff       	jmp    80105a90 <trap+0xb0>
80105b4f:	90                   	nop
    uartintr();
80105b50:	e8 1b 02 00 00       	call   80105d70 <uartintr>
    lapiceoi();
80105b55:	e8 36 cc ff ff       	call   80102790 <lapiceoi>
    break;
80105b5a:	e9 31 ff ff ff       	jmp    80105a90 <trap+0xb0>
80105b5f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b60:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b63:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b67:	e8 34 db ff ff       	call   801036a0 <cpuid>
80105b6c:	c7 04 24 f4 78 10 80 	movl   $0x801078f4,(%esp)
80105b73:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105b77:	89 74 24 08          	mov    %esi,0x8(%esp)
80105b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b7f:	e8 cc aa ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105b84:	e8 07 cc ff ff       	call   80102790 <lapiceoi>
    break;
80105b89:	e9 02 ff ff ff       	jmp    80105a90 <trap+0xb0>
80105b8e:	66 90                	xchg   %ax,%ax
    ideintr();
80105b90:	e8 fb c4 ff ff       	call   80102090 <ideintr>
80105b95:	eb 96                	jmp    80105b2d <trap+0x14d>
80105b97:	90                   	nop
80105b98:	90                   	nop
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ba0:	e8 1b db ff ff       	call   801036c0 <myproc>
80105ba5:	8b 70 24             	mov    0x24(%eax),%esi
80105ba8:	85 f6                	test   %esi,%esi
80105baa:	75 2c                	jne    80105bd8 <trap+0x1f8>
    myproc()->tf = tf;
80105bac:	e8 0f db ff ff       	call   801036c0 <myproc>
80105bb1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105bb4:	e8 97 ee ff ff       	call   80104a50 <syscall>
    if(myproc()->killed)
80105bb9:	e8 02 db ff ff       	call   801036c0 <myproc>
80105bbe:	8b 48 24             	mov    0x24(%eax),%ecx
80105bc1:	85 c9                	test   %ecx,%ecx
80105bc3:	0f 84 18 ff ff ff    	je     80105ae1 <trap+0x101>
}
80105bc9:	83 c4 3c             	add    $0x3c,%esp
80105bcc:	5b                   	pop    %ebx
80105bcd:	5e                   	pop    %esi
80105bce:	5f                   	pop    %edi
80105bcf:	5d                   	pop    %ebp
      exit();
80105bd0:	e9 3b df ff ff       	jmp    80103b10 <exit>
80105bd5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105bd8:	e8 33 df ff ff       	call   80103b10 <exit>
80105bdd:	eb cd                	jmp    80105bac <trap+0x1cc>
80105bdf:	90                   	nop
      acquire(&tickslock);
80105be0:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105be7:	e8 e4 e9 ff ff       	call   801045d0 <acquire>
      wakeup(&ticks);
80105bec:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
      ticks++;
80105bf3:	83 05 a0 57 11 80 01 	addl   $0x1,0x801157a0
      wakeup(&ticks);
80105bfa:	e8 71 e5 ff ff       	call   80104170 <wakeup>
      release(&tickslock);
80105bff:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105c06:	e8 35 ea ff ff       	call   80104640 <release>
80105c0b:	e9 1d ff ff ff       	jmp    80105b2d <trap+0x14d>
80105c10:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c13:	8b 73 38             	mov    0x38(%ebx),%esi
80105c16:	e8 85 da ff ff       	call   801036a0 <cpuid>
80105c1b:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105c1f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105c23:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c27:	8b 43 30             	mov    0x30(%ebx),%eax
80105c2a:	c7 04 24 18 79 10 80 	movl   $0x80107918,(%esp)
80105c31:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c35:	e8 16 aa ff ff       	call   80100650 <cprintf>
      panic("trap");
80105c3a:	c7 04 24 ee 78 10 80 	movl   $0x801078ee,(%esp)
80105c41:	e8 1a a7 ff ff       	call   80100360 <panic>
80105c46:	66 90                	xchg   %ax,%ax
80105c48:	66 90                	xchg   %ax,%ax
80105c4a:	66 90                	xchg   %ax,%ax
80105c4c:	66 90                	xchg   %ax,%ax
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c50:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105c55:	55                   	push   %ebp
80105c56:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c58:	85 c0                	test   %eax,%eax
80105c5a:	74 14                	je     80105c70 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c5c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c61:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c62:	a8 01                	test   $0x1,%al
80105c64:	74 0a                	je     80105c70 <uartgetc+0x20>
80105c66:	b2 f8                	mov    $0xf8,%dl
80105c68:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c69:	0f b6 c0             	movzbl %al,%eax
}
80105c6c:	5d                   	pop    %ebp
80105c6d:	c3                   	ret    
80105c6e:	66 90                	xchg   %ax,%ax
    return -1;
80105c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c75:	5d                   	pop    %ebp
80105c76:	c3                   	ret    
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <uartputc>:
  if(!uart)
80105c80:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105c85:	85 c0                	test   %eax,%eax
80105c87:	74 3f                	je     80105cc8 <uartputc+0x48>
{
80105c89:	55                   	push   %ebp
80105c8a:	89 e5                	mov    %esp,%ebp
80105c8c:	56                   	push   %esi
80105c8d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c92:	53                   	push   %ebx
  if(!uart)
80105c93:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105c98:	83 ec 10             	sub    $0x10,%esp
80105c9b:	eb 14                	jmp    80105cb1 <uartputc+0x31>
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105ca0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105ca7:	e8 04 cb ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cac:	83 eb 01             	sub    $0x1,%ebx
80105caf:	74 07                	je     80105cb8 <uartputc+0x38>
80105cb1:	89 f2                	mov    %esi,%edx
80105cb3:	ec                   	in     (%dx),%al
80105cb4:	a8 20                	test   $0x20,%al
80105cb6:	74 e8                	je     80105ca0 <uartputc+0x20>
  outb(COM1+0, c);
80105cb8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cbc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cc1:	ee                   	out    %al,(%dx)
}
80105cc2:	83 c4 10             	add    $0x10,%esp
80105cc5:	5b                   	pop    %ebx
80105cc6:	5e                   	pop    %esi
80105cc7:	5d                   	pop    %ebp
80105cc8:	f3 c3                	repz ret 
80105cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cd0 <uartinit>:
{
80105cd0:	55                   	push   %ebp
80105cd1:	31 c9                	xor    %ecx,%ecx
80105cd3:	89 e5                	mov    %esp,%ebp
80105cd5:	89 c8                	mov    %ecx,%eax
80105cd7:	57                   	push   %edi
80105cd8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105cdd:	56                   	push   %esi
80105cde:	89 fa                	mov    %edi,%edx
80105ce0:	53                   	push   %ebx
80105ce1:	83 ec 1c             	sub    $0x1c,%esp
80105ce4:	ee                   	out    %al,(%dx)
80105ce5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105cea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105cef:	89 f2                	mov    %esi,%edx
80105cf1:	ee                   	out    %al,(%dx)
80105cf2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cf7:	b2 f8                	mov    $0xf8,%dl
80105cf9:	ee                   	out    %al,(%dx)
80105cfa:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105cff:	89 c8                	mov    %ecx,%eax
80105d01:	89 da                	mov    %ebx,%edx
80105d03:	ee                   	out    %al,(%dx)
80105d04:	b8 03 00 00 00       	mov    $0x3,%eax
80105d09:	89 f2                	mov    %esi,%edx
80105d0b:	ee                   	out    %al,(%dx)
80105d0c:	b2 fc                	mov    $0xfc,%dl
80105d0e:	89 c8                	mov    %ecx,%eax
80105d10:	ee                   	out    %al,(%dx)
80105d11:	b8 01 00 00 00       	mov    $0x1,%eax
80105d16:	89 da                	mov    %ebx,%edx
80105d18:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d19:	b2 fd                	mov    $0xfd,%dl
80105d1b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d1c:	3c ff                	cmp    $0xff,%al
80105d1e:	74 42                	je     80105d62 <uartinit+0x92>
  uart = 1;
80105d20:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d27:	00 00 00 
80105d2a:	89 fa                	mov    %edi,%edx
80105d2c:	ec                   	in     (%dx),%al
80105d2d:	b2 f8                	mov    $0xf8,%dl
80105d2f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d37:	00 
  for(p="xv6...\n"; *p; p++)
80105d38:	bb 10 7a 10 80       	mov    $0x80107a10,%ebx
  ioapicenable(IRQ_COM1, 0);
80105d3d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105d44:	e8 77 c5 ff ff       	call   801022c0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105d49:	b8 78 00 00 00       	mov    $0x78,%eax
80105d4e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105d50:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105d53:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105d56:	e8 25 ff ff ff       	call   80105c80 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105d5b:	0f be 03             	movsbl (%ebx),%eax
80105d5e:	84 c0                	test   %al,%al
80105d60:	75 ee                	jne    80105d50 <uartinit+0x80>
}
80105d62:	83 c4 1c             	add    $0x1c,%esp
80105d65:	5b                   	pop    %ebx
80105d66:	5e                   	pop    %esi
80105d67:	5f                   	pop    %edi
80105d68:	5d                   	pop    %ebp
80105d69:	c3                   	ret    
80105d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d70 <uartintr>:

void
uartintr(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105d76:	c7 04 24 50 5c 10 80 	movl   $0x80105c50,(%esp)
80105d7d:	e8 2e aa ff ff       	call   801007b0 <consoleintr>
}
80105d82:	c9                   	leave  
80105d83:	c3                   	ret    

80105d84 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d84:	6a 00                	push   $0x0
  pushl $0
80105d86:	6a 00                	push   $0x0
  jmp alltraps
80105d88:	e9 60 fb ff ff       	jmp    801058ed <alltraps>

80105d8d <vector1>:
.globl vector1
vector1:
  pushl $0
80105d8d:	6a 00                	push   $0x0
  pushl $1
80105d8f:	6a 01                	push   $0x1
  jmp alltraps
80105d91:	e9 57 fb ff ff       	jmp    801058ed <alltraps>

80105d96 <vector2>:
.globl vector2
vector2:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $2
80105d98:	6a 02                	push   $0x2
  jmp alltraps
80105d9a:	e9 4e fb ff ff       	jmp    801058ed <alltraps>

80105d9f <vector3>:
.globl vector3
vector3:
  pushl $0
80105d9f:	6a 00                	push   $0x0
  pushl $3
80105da1:	6a 03                	push   $0x3
  jmp alltraps
80105da3:	e9 45 fb ff ff       	jmp    801058ed <alltraps>

80105da8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105da8:	6a 00                	push   $0x0
  pushl $4
80105daa:	6a 04                	push   $0x4
  jmp alltraps
80105dac:	e9 3c fb ff ff       	jmp    801058ed <alltraps>

80105db1 <vector5>:
.globl vector5
vector5:
  pushl $0
80105db1:	6a 00                	push   $0x0
  pushl $5
80105db3:	6a 05                	push   $0x5
  jmp alltraps
80105db5:	e9 33 fb ff ff       	jmp    801058ed <alltraps>

80105dba <vector6>:
.globl vector6
vector6:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $6
80105dbc:	6a 06                	push   $0x6
  jmp alltraps
80105dbe:	e9 2a fb ff ff       	jmp    801058ed <alltraps>

80105dc3 <vector7>:
.globl vector7
vector7:
  pushl $0
80105dc3:	6a 00                	push   $0x0
  pushl $7
80105dc5:	6a 07                	push   $0x7
  jmp alltraps
80105dc7:	e9 21 fb ff ff       	jmp    801058ed <alltraps>

80105dcc <vector8>:
.globl vector8
vector8:
  pushl $8
80105dcc:	6a 08                	push   $0x8
  jmp alltraps
80105dce:	e9 1a fb ff ff       	jmp    801058ed <alltraps>

80105dd3 <vector9>:
.globl vector9
vector9:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $9
80105dd5:	6a 09                	push   $0x9
  jmp alltraps
80105dd7:	e9 11 fb ff ff       	jmp    801058ed <alltraps>

80105ddc <vector10>:
.globl vector10
vector10:
  pushl $10
80105ddc:	6a 0a                	push   $0xa
  jmp alltraps
80105dde:	e9 0a fb ff ff       	jmp    801058ed <alltraps>

80105de3 <vector11>:
.globl vector11
vector11:
  pushl $11
80105de3:	6a 0b                	push   $0xb
  jmp alltraps
80105de5:	e9 03 fb ff ff       	jmp    801058ed <alltraps>

80105dea <vector12>:
.globl vector12
vector12:
  pushl $12
80105dea:	6a 0c                	push   $0xc
  jmp alltraps
80105dec:	e9 fc fa ff ff       	jmp    801058ed <alltraps>

80105df1 <vector13>:
.globl vector13
vector13:
  pushl $13
80105df1:	6a 0d                	push   $0xd
  jmp alltraps
80105df3:	e9 f5 fa ff ff       	jmp    801058ed <alltraps>

80105df8 <vector14>:
.globl vector14
vector14:
  pushl $14
80105df8:	6a 0e                	push   $0xe
  jmp alltraps
80105dfa:	e9 ee fa ff ff       	jmp    801058ed <alltraps>

80105dff <vector15>:
.globl vector15
vector15:
  pushl $0
80105dff:	6a 00                	push   $0x0
  pushl $15
80105e01:	6a 0f                	push   $0xf
  jmp alltraps
80105e03:	e9 e5 fa ff ff       	jmp    801058ed <alltraps>

80105e08 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e08:	6a 00                	push   $0x0
  pushl $16
80105e0a:	6a 10                	push   $0x10
  jmp alltraps
80105e0c:	e9 dc fa ff ff       	jmp    801058ed <alltraps>

80105e11 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e11:	6a 11                	push   $0x11
  jmp alltraps
80105e13:	e9 d5 fa ff ff       	jmp    801058ed <alltraps>

80105e18 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $18
80105e1a:	6a 12                	push   $0x12
  jmp alltraps
80105e1c:	e9 cc fa ff ff       	jmp    801058ed <alltraps>

80105e21 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $19
80105e23:	6a 13                	push   $0x13
  jmp alltraps
80105e25:	e9 c3 fa ff ff       	jmp    801058ed <alltraps>

80105e2a <vector20>:
.globl vector20
vector20:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $20
80105e2c:	6a 14                	push   $0x14
  jmp alltraps
80105e2e:	e9 ba fa ff ff       	jmp    801058ed <alltraps>

80105e33 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $21
80105e35:	6a 15                	push   $0x15
  jmp alltraps
80105e37:	e9 b1 fa ff ff       	jmp    801058ed <alltraps>

80105e3c <vector22>:
.globl vector22
vector22:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $22
80105e3e:	6a 16                	push   $0x16
  jmp alltraps
80105e40:	e9 a8 fa ff ff       	jmp    801058ed <alltraps>

80105e45 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $23
80105e47:	6a 17                	push   $0x17
  jmp alltraps
80105e49:	e9 9f fa ff ff       	jmp    801058ed <alltraps>

80105e4e <vector24>:
.globl vector24
vector24:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $24
80105e50:	6a 18                	push   $0x18
  jmp alltraps
80105e52:	e9 96 fa ff ff       	jmp    801058ed <alltraps>

80105e57 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $25
80105e59:	6a 19                	push   $0x19
  jmp alltraps
80105e5b:	e9 8d fa ff ff       	jmp    801058ed <alltraps>

80105e60 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $26
80105e62:	6a 1a                	push   $0x1a
  jmp alltraps
80105e64:	e9 84 fa ff ff       	jmp    801058ed <alltraps>

80105e69 <vector27>:
.globl vector27
vector27:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $27
80105e6b:	6a 1b                	push   $0x1b
  jmp alltraps
80105e6d:	e9 7b fa ff ff       	jmp    801058ed <alltraps>

80105e72 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $28
80105e74:	6a 1c                	push   $0x1c
  jmp alltraps
80105e76:	e9 72 fa ff ff       	jmp    801058ed <alltraps>

80105e7b <vector29>:
.globl vector29
vector29:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $29
80105e7d:	6a 1d                	push   $0x1d
  jmp alltraps
80105e7f:	e9 69 fa ff ff       	jmp    801058ed <alltraps>

80105e84 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $30
80105e86:	6a 1e                	push   $0x1e
  jmp alltraps
80105e88:	e9 60 fa ff ff       	jmp    801058ed <alltraps>

80105e8d <vector31>:
.globl vector31
vector31:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $31
80105e8f:	6a 1f                	push   $0x1f
  jmp alltraps
80105e91:	e9 57 fa ff ff       	jmp    801058ed <alltraps>

80105e96 <vector32>:
.globl vector32
vector32:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $32
80105e98:	6a 20                	push   $0x20
  jmp alltraps
80105e9a:	e9 4e fa ff ff       	jmp    801058ed <alltraps>

80105e9f <vector33>:
.globl vector33
vector33:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $33
80105ea1:	6a 21                	push   $0x21
  jmp alltraps
80105ea3:	e9 45 fa ff ff       	jmp    801058ed <alltraps>

80105ea8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $34
80105eaa:	6a 22                	push   $0x22
  jmp alltraps
80105eac:	e9 3c fa ff ff       	jmp    801058ed <alltraps>

80105eb1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $35
80105eb3:	6a 23                	push   $0x23
  jmp alltraps
80105eb5:	e9 33 fa ff ff       	jmp    801058ed <alltraps>

80105eba <vector36>:
.globl vector36
vector36:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $36
80105ebc:	6a 24                	push   $0x24
  jmp alltraps
80105ebe:	e9 2a fa ff ff       	jmp    801058ed <alltraps>

80105ec3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $37
80105ec5:	6a 25                	push   $0x25
  jmp alltraps
80105ec7:	e9 21 fa ff ff       	jmp    801058ed <alltraps>

80105ecc <vector38>:
.globl vector38
vector38:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $38
80105ece:	6a 26                	push   $0x26
  jmp alltraps
80105ed0:	e9 18 fa ff ff       	jmp    801058ed <alltraps>

80105ed5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $39
80105ed7:	6a 27                	push   $0x27
  jmp alltraps
80105ed9:	e9 0f fa ff ff       	jmp    801058ed <alltraps>

80105ede <vector40>:
.globl vector40
vector40:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $40
80105ee0:	6a 28                	push   $0x28
  jmp alltraps
80105ee2:	e9 06 fa ff ff       	jmp    801058ed <alltraps>

80105ee7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $41
80105ee9:	6a 29                	push   $0x29
  jmp alltraps
80105eeb:	e9 fd f9 ff ff       	jmp    801058ed <alltraps>

80105ef0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $42
80105ef2:	6a 2a                	push   $0x2a
  jmp alltraps
80105ef4:	e9 f4 f9 ff ff       	jmp    801058ed <alltraps>

80105ef9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $43
80105efb:	6a 2b                	push   $0x2b
  jmp alltraps
80105efd:	e9 eb f9 ff ff       	jmp    801058ed <alltraps>

80105f02 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $44
80105f04:	6a 2c                	push   $0x2c
  jmp alltraps
80105f06:	e9 e2 f9 ff ff       	jmp    801058ed <alltraps>

80105f0b <vector45>:
.globl vector45
vector45:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $45
80105f0d:	6a 2d                	push   $0x2d
  jmp alltraps
80105f0f:	e9 d9 f9 ff ff       	jmp    801058ed <alltraps>

80105f14 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $46
80105f16:	6a 2e                	push   $0x2e
  jmp alltraps
80105f18:	e9 d0 f9 ff ff       	jmp    801058ed <alltraps>

80105f1d <vector47>:
.globl vector47
vector47:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $47
80105f1f:	6a 2f                	push   $0x2f
  jmp alltraps
80105f21:	e9 c7 f9 ff ff       	jmp    801058ed <alltraps>

80105f26 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $48
80105f28:	6a 30                	push   $0x30
  jmp alltraps
80105f2a:	e9 be f9 ff ff       	jmp    801058ed <alltraps>

80105f2f <vector49>:
.globl vector49
vector49:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $49
80105f31:	6a 31                	push   $0x31
  jmp alltraps
80105f33:	e9 b5 f9 ff ff       	jmp    801058ed <alltraps>

80105f38 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $50
80105f3a:	6a 32                	push   $0x32
  jmp alltraps
80105f3c:	e9 ac f9 ff ff       	jmp    801058ed <alltraps>

80105f41 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $51
80105f43:	6a 33                	push   $0x33
  jmp alltraps
80105f45:	e9 a3 f9 ff ff       	jmp    801058ed <alltraps>

80105f4a <vector52>:
.globl vector52
vector52:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $52
80105f4c:	6a 34                	push   $0x34
  jmp alltraps
80105f4e:	e9 9a f9 ff ff       	jmp    801058ed <alltraps>

80105f53 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $53
80105f55:	6a 35                	push   $0x35
  jmp alltraps
80105f57:	e9 91 f9 ff ff       	jmp    801058ed <alltraps>

80105f5c <vector54>:
.globl vector54
vector54:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $54
80105f5e:	6a 36                	push   $0x36
  jmp alltraps
80105f60:	e9 88 f9 ff ff       	jmp    801058ed <alltraps>

80105f65 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $55
80105f67:	6a 37                	push   $0x37
  jmp alltraps
80105f69:	e9 7f f9 ff ff       	jmp    801058ed <alltraps>

80105f6e <vector56>:
.globl vector56
vector56:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $56
80105f70:	6a 38                	push   $0x38
  jmp alltraps
80105f72:	e9 76 f9 ff ff       	jmp    801058ed <alltraps>

80105f77 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $57
80105f79:	6a 39                	push   $0x39
  jmp alltraps
80105f7b:	e9 6d f9 ff ff       	jmp    801058ed <alltraps>

80105f80 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $58
80105f82:	6a 3a                	push   $0x3a
  jmp alltraps
80105f84:	e9 64 f9 ff ff       	jmp    801058ed <alltraps>

80105f89 <vector59>:
.globl vector59
vector59:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $59
80105f8b:	6a 3b                	push   $0x3b
  jmp alltraps
80105f8d:	e9 5b f9 ff ff       	jmp    801058ed <alltraps>

80105f92 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $60
80105f94:	6a 3c                	push   $0x3c
  jmp alltraps
80105f96:	e9 52 f9 ff ff       	jmp    801058ed <alltraps>

80105f9b <vector61>:
.globl vector61
vector61:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $61
80105f9d:	6a 3d                	push   $0x3d
  jmp alltraps
80105f9f:	e9 49 f9 ff ff       	jmp    801058ed <alltraps>

80105fa4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $62
80105fa6:	6a 3e                	push   $0x3e
  jmp alltraps
80105fa8:	e9 40 f9 ff ff       	jmp    801058ed <alltraps>

80105fad <vector63>:
.globl vector63
vector63:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $63
80105faf:	6a 3f                	push   $0x3f
  jmp alltraps
80105fb1:	e9 37 f9 ff ff       	jmp    801058ed <alltraps>

80105fb6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $64
80105fb8:	6a 40                	push   $0x40
  jmp alltraps
80105fba:	e9 2e f9 ff ff       	jmp    801058ed <alltraps>

80105fbf <vector65>:
.globl vector65
vector65:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $65
80105fc1:	6a 41                	push   $0x41
  jmp alltraps
80105fc3:	e9 25 f9 ff ff       	jmp    801058ed <alltraps>

80105fc8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $66
80105fca:	6a 42                	push   $0x42
  jmp alltraps
80105fcc:	e9 1c f9 ff ff       	jmp    801058ed <alltraps>

80105fd1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $67
80105fd3:	6a 43                	push   $0x43
  jmp alltraps
80105fd5:	e9 13 f9 ff ff       	jmp    801058ed <alltraps>

80105fda <vector68>:
.globl vector68
vector68:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $68
80105fdc:	6a 44                	push   $0x44
  jmp alltraps
80105fde:	e9 0a f9 ff ff       	jmp    801058ed <alltraps>

80105fe3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $69
80105fe5:	6a 45                	push   $0x45
  jmp alltraps
80105fe7:	e9 01 f9 ff ff       	jmp    801058ed <alltraps>

80105fec <vector70>:
.globl vector70
vector70:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $70
80105fee:	6a 46                	push   $0x46
  jmp alltraps
80105ff0:	e9 f8 f8 ff ff       	jmp    801058ed <alltraps>

80105ff5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $71
80105ff7:	6a 47                	push   $0x47
  jmp alltraps
80105ff9:	e9 ef f8 ff ff       	jmp    801058ed <alltraps>

80105ffe <vector72>:
.globl vector72
vector72:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $72
80106000:	6a 48                	push   $0x48
  jmp alltraps
80106002:	e9 e6 f8 ff ff       	jmp    801058ed <alltraps>

80106007 <vector73>:
.globl vector73
vector73:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $73
80106009:	6a 49                	push   $0x49
  jmp alltraps
8010600b:	e9 dd f8 ff ff       	jmp    801058ed <alltraps>

80106010 <vector74>:
.globl vector74
vector74:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $74
80106012:	6a 4a                	push   $0x4a
  jmp alltraps
80106014:	e9 d4 f8 ff ff       	jmp    801058ed <alltraps>

80106019 <vector75>:
.globl vector75
vector75:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $75
8010601b:	6a 4b                	push   $0x4b
  jmp alltraps
8010601d:	e9 cb f8 ff ff       	jmp    801058ed <alltraps>

80106022 <vector76>:
.globl vector76
vector76:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $76
80106024:	6a 4c                	push   $0x4c
  jmp alltraps
80106026:	e9 c2 f8 ff ff       	jmp    801058ed <alltraps>

8010602b <vector77>:
.globl vector77
vector77:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $77
8010602d:	6a 4d                	push   $0x4d
  jmp alltraps
8010602f:	e9 b9 f8 ff ff       	jmp    801058ed <alltraps>

80106034 <vector78>:
.globl vector78
vector78:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $78
80106036:	6a 4e                	push   $0x4e
  jmp alltraps
80106038:	e9 b0 f8 ff ff       	jmp    801058ed <alltraps>

8010603d <vector79>:
.globl vector79
vector79:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $79
8010603f:	6a 4f                	push   $0x4f
  jmp alltraps
80106041:	e9 a7 f8 ff ff       	jmp    801058ed <alltraps>

80106046 <vector80>:
.globl vector80
vector80:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $80
80106048:	6a 50                	push   $0x50
  jmp alltraps
8010604a:	e9 9e f8 ff ff       	jmp    801058ed <alltraps>

8010604f <vector81>:
.globl vector81
vector81:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $81
80106051:	6a 51                	push   $0x51
  jmp alltraps
80106053:	e9 95 f8 ff ff       	jmp    801058ed <alltraps>

80106058 <vector82>:
.globl vector82
vector82:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $82
8010605a:	6a 52                	push   $0x52
  jmp alltraps
8010605c:	e9 8c f8 ff ff       	jmp    801058ed <alltraps>

80106061 <vector83>:
.globl vector83
vector83:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $83
80106063:	6a 53                	push   $0x53
  jmp alltraps
80106065:	e9 83 f8 ff ff       	jmp    801058ed <alltraps>

8010606a <vector84>:
.globl vector84
vector84:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $84
8010606c:	6a 54                	push   $0x54
  jmp alltraps
8010606e:	e9 7a f8 ff ff       	jmp    801058ed <alltraps>

80106073 <vector85>:
.globl vector85
vector85:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $85
80106075:	6a 55                	push   $0x55
  jmp alltraps
80106077:	e9 71 f8 ff ff       	jmp    801058ed <alltraps>

8010607c <vector86>:
.globl vector86
vector86:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $86
8010607e:	6a 56                	push   $0x56
  jmp alltraps
80106080:	e9 68 f8 ff ff       	jmp    801058ed <alltraps>

80106085 <vector87>:
.globl vector87
vector87:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $87
80106087:	6a 57                	push   $0x57
  jmp alltraps
80106089:	e9 5f f8 ff ff       	jmp    801058ed <alltraps>

8010608e <vector88>:
.globl vector88
vector88:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $88
80106090:	6a 58                	push   $0x58
  jmp alltraps
80106092:	e9 56 f8 ff ff       	jmp    801058ed <alltraps>

80106097 <vector89>:
.globl vector89
vector89:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $89
80106099:	6a 59                	push   $0x59
  jmp alltraps
8010609b:	e9 4d f8 ff ff       	jmp    801058ed <alltraps>

801060a0 <vector90>:
.globl vector90
vector90:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $90
801060a2:	6a 5a                	push   $0x5a
  jmp alltraps
801060a4:	e9 44 f8 ff ff       	jmp    801058ed <alltraps>

801060a9 <vector91>:
.globl vector91
vector91:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $91
801060ab:	6a 5b                	push   $0x5b
  jmp alltraps
801060ad:	e9 3b f8 ff ff       	jmp    801058ed <alltraps>

801060b2 <vector92>:
.globl vector92
vector92:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $92
801060b4:	6a 5c                	push   $0x5c
  jmp alltraps
801060b6:	e9 32 f8 ff ff       	jmp    801058ed <alltraps>

801060bb <vector93>:
.globl vector93
vector93:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $93
801060bd:	6a 5d                	push   $0x5d
  jmp alltraps
801060bf:	e9 29 f8 ff ff       	jmp    801058ed <alltraps>

801060c4 <vector94>:
.globl vector94
vector94:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $94
801060c6:	6a 5e                	push   $0x5e
  jmp alltraps
801060c8:	e9 20 f8 ff ff       	jmp    801058ed <alltraps>

801060cd <vector95>:
.globl vector95
vector95:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $95
801060cf:	6a 5f                	push   $0x5f
  jmp alltraps
801060d1:	e9 17 f8 ff ff       	jmp    801058ed <alltraps>

801060d6 <vector96>:
.globl vector96
vector96:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $96
801060d8:	6a 60                	push   $0x60
  jmp alltraps
801060da:	e9 0e f8 ff ff       	jmp    801058ed <alltraps>

801060df <vector97>:
.globl vector97
vector97:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $97
801060e1:	6a 61                	push   $0x61
  jmp alltraps
801060e3:	e9 05 f8 ff ff       	jmp    801058ed <alltraps>

801060e8 <vector98>:
.globl vector98
vector98:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $98
801060ea:	6a 62                	push   $0x62
  jmp alltraps
801060ec:	e9 fc f7 ff ff       	jmp    801058ed <alltraps>

801060f1 <vector99>:
.globl vector99
vector99:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $99
801060f3:	6a 63                	push   $0x63
  jmp alltraps
801060f5:	e9 f3 f7 ff ff       	jmp    801058ed <alltraps>

801060fa <vector100>:
.globl vector100
vector100:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $100
801060fc:	6a 64                	push   $0x64
  jmp alltraps
801060fe:	e9 ea f7 ff ff       	jmp    801058ed <alltraps>

80106103 <vector101>:
.globl vector101
vector101:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $101
80106105:	6a 65                	push   $0x65
  jmp alltraps
80106107:	e9 e1 f7 ff ff       	jmp    801058ed <alltraps>

8010610c <vector102>:
.globl vector102
vector102:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $102
8010610e:	6a 66                	push   $0x66
  jmp alltraps
80106110:	e9 d8 f7 ff ff       	jmp    801058ed <alltraps>

80106115 <vector103>:
.globl vector103
vector103:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $103
80106117:	6a 67                	push   $0x67
  jmp alltraps
80106119:	e9 cf f7 ff ff       	jmp    801058ed <alltraps>

8010611e <vector104>:
.globl vector104
vector104:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $104
80106120:	6a 68                	push   $0x68
  jmp alltraps
80106122:	e9 c6 f7 ff ff       	jmp    801058ed <alltraps>

80106127 <vector105>:
.globl vector105
vector105:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $105
80106129:	6a 69                	push   $0x69
  jmp alltraps
8010612b:	e9 bd f7 ff ff       	jmp    801058ed <alltraps>

80106130 <vector106>:
.globl vector106
vector106:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $106
80106132:	6a 6a                	push   $0x6a
  jmp alltraps
80106134:	e9 b4 f7 ff ff       	jmp    801058ed <alltraps>

80106139 <vector107>:
.globl vector107
vector107:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $107
8010613b:	6a 6b                	push   $0x6b
  jmp alltraps
8010613d:	e9 ab f7 ff ff       	jmp    801058ed <alltraps>

80106142 <vector108>:
.globl vector108
vector108:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $108
80106144:	6a 6c                	push   $0x6c
  jmp alltraps
80106146:	e9 a2 f7 ff ff       	jmp    801058ed <alltraps>

8010614b <vector109>:
.globl vector109
vector109:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $109
8010614d:	6a 6d                	push   $0x6d
  jmp alltraps
8010614f:	e9 99 f7 ff ff       	jmp    801058ed <alltraps>

80106154 <vector110>:
.globl vector110
vector110:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $110
80106156:	6a 6e                	push   $0x6e
  jmp alltraps
80106158:	e9 90 f7 ff ff       	jmp    801058ed <alltraps>

8010615d <vector111>:
.globl vector111
vector111:
  pushl $0
8010615d:	6a 00                	push   $0x0
  pushl $111
8010615f:	6a 6f                	push   $0x6f
  jmp alltraps
80106161:	e9 87 f7 ff ff       	jmp    801058ed <alltraps>

80106166 <vector112>:
.globl vector112
vector112:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $112
80106168:	6a 70                	push   $0x70
  jmp alltraps
8010616a:	e9 7e f7 ff ff       	jmp    801058ed <alltraps>

8010616f <vector113>:
.globl vector113
vector113:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $113
80106171:	6a 71                	push   $0x71
  jmp alltraps
80106173:	e9 75 f7 ff ff       	jmp    801058ed <alltraps>

80106178 <vector114>:
.globl vector114
vector114:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $114
8010617a:	6a 72                	push   $0x72
  jmp alltraps
8010617c:	e9 6c f7 ff ff       	jmp    801058ed <alltraps>

80106181 <vector115>:
.globl vector115
vector115:
  pushl $0
80106181:	6a 00                	push   $0x0
  pushl $115
80106183:	6a 73                	push   $0x73
  jmp alltraps
80106185:	e9 63 f7 ff ff       	jmp    801058ed <alltraps>

8010618a <vector116>:
.globl vector116
vector116:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $116
8010618c:	6a 74                	push   $0x74
  jmp alltraps
8010618e:	e9 5a f7 ff ff       	jmp    801058ed <alltraps>

80106193 <vector117>:
.globl vector117
vector117:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $117
80106195:	6a 75                	push   $0x75
  jmp alltraps
80106197:	e9 51 f7 ff ff       	jmp    801058ed <alltraps>

8010619c <vector118>:
.globl vector118
vector118:
  pushl $0
8010619c:	6a 00                	push   $0x0
  pushl $118
8010619e:	6a 76                	push   $0x76
  jmp alltraps
801061a0:	e9 48 f7 ff ff       	jmp    801058ed <alltraps>

801061a5 <vector119>:
.globl vector119
vector119:
  pushl $0
801061a5:	6a 00                	push   $0x0
  pushl $119
801061a7:	6a 77                	push   $0x77
  jmp alltraps
801061a9:	e9 3f f7 ff ff       	jmp    801058ed <alltraps>

801061ae <vector120>:
.globl vector120
vector120:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $120
801061b0:	6a 78                	push   $0x78
  jmp alltraps
801061b2:	e9 36 f7 ff ff       	jmp    801058ed <alltraps>

801061b7 <vector121>:
.globl vector121
vector121:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $121
801061b9:	6a 79                	push   $0x79
  jmp alltraps
801061bb:	e9 2d f7 ff ff       	jmp    801058ed <alltraps>

801061c0 <vector122>:
.globl vector122
vector122:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $122
801061c2:	6a 7a                	push   $0x7a
  jmp alltraps
801061c4:	e9 24 f7 ff ff       	jmp    801058ed <alltraps>

801061c9 <vector123>:
.globl vector123
vector123:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $123
801061cb:	6a 7b                	push   $0x7b
  jmp alltraps
801061cd:	e9 1b f7 ff ff       	jmp    801058ed <alltraps>

801061d2 <vector124>:
.globl vector124
vector124:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $124
801061d4:	6a 7c                	push   $0x7c
  jmp alltraps
801061d6:	e9 12 f7 ff ff       	jmp    801058ed <alltraps>

801061db <vector125>:
.globl vector125
vector125:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $125
801061dd:	6a 7d                	push   $0x7d
  jmp alltraps
801061df:	e9 09 f7 ff ff       	jmp    801058ed <alltraps>

801061e4 <vector126>:
.globl vector126
vector126:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $126
801061e6:	6a 7e                	push   $0x7e
  jmp alltraps
801061e8:	e9 00 f7 ff ff       	jmp    801058ed <alltraps>

801061ed <vector127>:
.globl vector127
vector127:
  pushl $0
801061ed:	6a 00                	push   $0x0
  pushl $127
801061ef:	6a 7f                	push   $0x7f
  jmp alltraps
801061f1:	e9 f7 f6 ff ff       	jmp    801058ed <alltraps>

801061f6 <vector128>:
.globl vector128
vector128:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $128
801061f8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801061fd:	e9 eb f6 ff ff       	jmp    801058ed <alltraps>

80106202 <vector129>:
.globl vector129
vector129:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $129
80106204:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106209:	e9 df f6 ff ff       	jmp    801058ed <alltraps>

8010620e <vector130>:
.globl vector130
vector130:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $130
80106210:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106215:	e9 d3 f6 ff ff       	jmp    801058ed <alltraps>

8010621a <vector131>:
.globl vector131
vector131:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $131
8010621c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106221:	e9 c7 f6 ff ff       	jmp    801058ed <alltraps>

80106226 <vector132>:
.globl vector132
vector132:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $132
80106228:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010622d:	e9 bb f6 ff ff       	jmp    801058ed <alltraps>

80106232 <vector133>:
.globl vector133
vector133:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $133
80106234:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106239:	e9 af f6 ff ff       	jmp    801058ed <alltraps>

8010623e <vector134>:
.globl vector134
vector134:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $134
80106240:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106245:	e9 a3 f6 ff ff       	jmp    801058ed <alltraps>

8010624a <vector135>:
.globl vector135
vector135:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $135
8010624c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106251:	e9 97 f6 ff ff       	jmp    801058ed <alltraps>

80106256 <vector136>:
.globl vector136
vector136:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $136
80106258:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010625d:	e9 8b f6 ff ff       	jmp    801058ed <alltraps>

80106262 <vector137>:
.globl vector137
vector137:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $137
80106264:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106269:	e9 7f f6 ff ff       	jmp    801058ed <alltraps>

8010626e <vector138>:
.globl vector138
vector138:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $138
80106270:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106275:	e9 73 f6 ff ff       	jmp    801058ed <alltraps>

8010627a <vector139>:
.globl vector139
vector139:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $139
8010627c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106281:	e9 67 f6 ff ff       	jmp    801058ed <alltraps>

80106286 <vector140>:
.globl vector140
vector140:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $140
80106288:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010628d:	e9 5b f6 ff ff       	jmp    801058ed <alltraps>

80106292 <vector141>:
.globl vector141
vector141:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $141
80106294:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106299:	e9 4f f6 ff ff       	jmp    801058ed <alltraps>

8010629e <vector142>:
.globl vector142
vector142:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $142
801062a0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062a5:	e9 43 f6 ff ff       	jmp    801058ed <alltraps>

801062aa <vector143>:
.globl vector143
vector143:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $143
801062ac:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062b1:	e9 37 f6 ff ff       	jmp    801058ed <alltraps>

801062b6 <vector144>:
.globl vector144
vector144:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $144
801062b8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062bd:	e9 2b f6 ff ff       	jmp    801058ed <alltraps>

801062c2 <vector145>:
.globl vector145
vector145:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $145
801062c4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062c9:	e9 1f f6 ff ff       	jmp    801058ed <alltraps>

801062ce <vector146>:
.globl vector146
vector146:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $146
801062d0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062d5:	e9 13 f6 ff ff       	jmp    801058ed <alltraps>

801062da <vector147>:
.globl vector147
vector147:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $147
801062dc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801062e1:	e9 07 f6 ff ff       	jmp    801058ed <alltraps>

801062e6 <vector148>:
.globl vector148
vector148:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $148
801062e8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801062ed:	e9 fb f5 ff ff       	jmp    801058ed <alltraps>

801062f2 <vector149>:
.globl vector149
vector149:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $149
801062f4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801062f9:	e9 ef f5 ff ff       	jmp    801058ed <alltraps>

801062fe <vector150>:
.globl vector150
vector150:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $150
80106300:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106305:	e9 e3 f5 ff ff       	jmp    801058ed <alltraps>

8010630a <vector151>:
.globl vector151
vector151:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $151
8010630c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106311:	e9 d7 f5 ff ff       	jmp    801058ed <alltraps>

80106316 <vector152>:
.globl vector152
vector152:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $152
80106318:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010631d:	e9 cb f5 ff ff       	jmp    801058ed <alltraps>

80106322 <vector153>:
.globl vector153
vector153:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $153
80106324:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106329:	e9 bf f5 ff ff       	jmp    801058ed <alltraps>

8010632e <vector154>:
.globl vector154
vector154:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $154
80106330:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106335:	e9 b3 f5 ff ff       	jmp    801058ed <alltraps>

8010633a <vector155>:
.globl vector155
vector155:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $155
8010633c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106341:	e9 a7 f5 ff ff       	jmp    801058ed <alltraps>

80106346 <vector156>:
.globl vector156
vector156:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $156
80106348:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010634d:	e9 9b f5 ff ff       	jmp    801058ed <alltraps>

80106352 <vector157>:
.globl vector157
vector157:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $157
80106354:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106359:	e9 8f f5 ff ff       	jmp    801058ed <alltraps>

8010635e <vector158>:
.globl vector158
vector158:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $158
80106360:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106365:	e9 83 f5 ff ff       	jmp    801058ed <alltraps>

8010636a <vector159>:
.globl vector159
vector159:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $159
8010636c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106371:	e9 77 f5 ff ff       	jmp    801058ed <alltraps>

80106376 <vector160>:
.globl vector160
vector160:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $160
80106378:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010637d:	e9 6b f5 ff ff       	jmp    801058ed <alltraps>

80106382 <vector161>:
.globl vector161
vector161:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $161
80106384:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106389:	e9 5f f5 ff ff       	jmp    801058ed <alltraps>

8010638e <vector162>:
.globl vector162
vector162:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $162
80106390:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106395:	e9 53 f5 ff ff       	jmp    801058ed <alltraps>

8010639a <vector163>:
.globl vector163
vector163:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $163
8010639c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063a1:	e9 47 f5 ff ff       	jmp    801058ed <alltraps>

801063a6 <vector164>:
.globl vector164
vector164:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $164
801063a8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063ad:	e9 3b f5 ff ff       	jmp    801058ed <alltraps>

801063b2 <vector165>:
.globl vector165
vector165:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $165
801063b4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063b9:	e9 2f f5 ff ff       	jmp    801058ed <alltraps>

801063be <vector166>:
.globl vector166
vector166:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $166
801063c0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063c5:	e9 23 f5 ff ff       	jmp    801058ed <alltraps>

801063ca <vector167>:
.globl vector167
vector167:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $167
801063cc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063d1:	e9 17 f5 ff ff       	jmp    801058ed <alltraps>

801063d6 <vector168>:
.globl vector168
vector168:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $168
801063d8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063dd:	e9 0b f5 ff ff       	jmp    801058ed <alltraps>

801063e2 <vector169>:
.globl vector169
vector169:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $169
801063e4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801063e9:	e9 ff f4 ff ff       	jmp    801058ed <alltraps>

801063ee <vector170>:
.globl vector170
vector170:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $170
801063f0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801063f5:	e9 f3 f4 ff ff       	jmp    801058ed <alltraps>

801063fa <vector171>:
.globl vector171
vector171:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $171
801063fc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106401:	e9 e7 f4 ff ff       	jmp    801058ed <alltraps>

80106406 <vector172>:
.globl vector172
vector172:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $172
80106408:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010640d:	e9 db f4 ff ff       	jmp    801058ed <alltraps>

80106412 <vector173>:
.globl vector173
vector173:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $173
80106414:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106419:	e9 cf f4 ff ff       	jmp    801058ed <alltraps>

8010641e <vector174>:
.globl vector174
vector174:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $174
80106420:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106425:	e9 c3 f4 ff ff       	jmp    801058ed <alltraps>

8010642a <vector175>:
.globl vector175
vector175:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $175
8010642c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106431:	e9 b7 f4 ff ff       	jmp    801058ed <alltraps>

80106436 <vector176>:
.globl vector176
vector176:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $176
80106438:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010643d:	e9 ab f4 ff ff       	jmp    801058ed <alltraps>

80106442 <vector177>:
.globl vector177
vector177:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $177
80106444:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106449:	e9 9f f4 ff ff       	jmp    801058ed <alltraps>

8010644e <vector178>:
.globl vector178
vector178:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $178
80106450:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106455:	e9 93 f4 ff ff       	jmp    801058ed <alltraps>

8010645a <vector179>:
.globl vector179
vector179:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $179
8010645c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106461:	e9 87 f4 ff ff       	jmp    801058ed <alltraps>

80106466 <vector180>:
.globl vector180
vector180:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $180
80106468:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010646d:	e9 7b f4 ff ff       	jmp    801058ed <alltraps>

80106472 <vector181>:
.globl vector181
vector181:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $181
80106474:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106479:	e9 6f f4 ff ff       	jmp    801058ed <alltraps>

8010647e <vector182>:
.globl vector182
vector182:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $182
80106480:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106485:	e9 63 f4 ff ff       	jmp    801058ed <alltraps>

8010648a <vector183>:
.globl vector183
vector183:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $183
8010648c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106491:	e9 57 f4 ff ff       	jmp    801058ed <alltraps>

80106496 <vector184>:
.globl vector184
vector184:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $184
80106498:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010649d:	e9 4b f4 ff ff       	jmp    801058ed <alltraps>

801064a2 <vector185>:
.globl vector185
vector185:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $185
801064a4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064a9:	e9 3f f4 ff ff       	jmp    801058ed <alltraps>

801064ae <vector186>:
.globl vector186
vector186:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $186
801064b0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064b5:	e9 33 f4 ff ff       	jmp    801058ed <alltraps>

801064ba <vector187>:
.globl vector187
vector187:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $187
801064bc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064c1:	e9 27 f4 ff ff       	jmp    801058ed <alltraps>

801064c6 <vector188>:
.globl vector188
vector188:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $188
801064c8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064cd:	e9 1b f4 ff ff       	jmp    801058ed <alltraps>

801064d2 <vector189>:
.globl vector189
vector189:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $189
801064d4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064d9:	e9 0f f4 ff ff       	jmp    801058ed <alltraps>

801064de <vector190>:
.globl vector190
vector190:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $190
801064e0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801064e5:	e9 03 f4 ff ff       	jmp    801058ed <alltraps>

801064ea <vector191>:
.globl vector191
vector191:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $191
801064ec:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801064f1:	e9 f7 f3 ff ff       	jmp    801058ed <alltraps>

801064f6 <vector192>:
.globl vector192
vector192:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $192
801064f8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801064fd:	e9 eb f3 ff ff       	jmp    801058ed <alltraps>

80106502 <vector193>:
.globl vector193
vector193:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $193
80106504:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106509:	e9 df f3 ff ff       	jmp    801058ed <alltraps>

8010650e <vector194>:
.globl vector194
vector194:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $194
80106510:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106515:	e9 d3 f3 ff ff       	jmp    801058ed <alltraps>

8010651a <vector195>:
.globl vector195
vector195:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $195
8010651c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106521:	e9 c7 f3 ff ff       	jmp    801058ed <alltraps>

80106526 <vector196>:
.globl vector196
vector196:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $196
80106528:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010652d:	e9 bb f3 ff ff       	jmp    801058ed <alltraps>

80106532 <vector197>:
.globl vector197
vector197:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $197
80106534:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106539:	e9 af f3 ff ff       	jmp    801058ed <alltraps>

8010653e <vector198>:
.globl vector198
vector198:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $198
80106540:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106545:	e9 a3 f3 ff ff       	jmp    801058ed <alltraps>

8010654a <vector199>:
.globl vector199
vector199:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $199
8010654c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106551:	e9 97 f3 ff ff       	jmp    801058ed <alltraps>

80106556 <vector200>:
.globl vector200
vector200:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $200
80106558:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010655d:	e9 8b f3 ff ff       	jmp    801058ed <alltraps>

80106562 <vector201>:
.globl vector201
vector201:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $201
80106564:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106569:	e9 7f f3 ff ff       	jmp    801058ed <alltraps>

8010656e <vector202>:
.globl vector202
vector202:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $202
80106570:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106575:	e9 73 f3 ff ff       	jmp    801058ed <alltraps>

8010657a <vector203>:
.globl vector203
vector203:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $203
8010657c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106581:	e9 67 f3 ff ff       	jmp    801058ed <alltraps>

80106586 <vector204>:
.globl vector204
vector204:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $204
80106588:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010658d:	e9 5b f3 ff ff       	jmp    801058ed <alltraps>

80106592 <vector205>:
.globl vector205
vector205:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $205
80106594:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106599:	e9 4f f3 ff ff       	jmp    801058ed <alltraps>

8010659e <vector206>:
.globl vector206
vector206:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $206
801065a0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065a5:	e9 43 f3 ff ff       	jmp    801058ed <alltraps>

801065aa <vector207>:
.globl vector207
vector207:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $207
801065ac:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065b1:	e9 37 f3 ff ff       	jmp    801058ed <alltraps>

801065b6 <vector208>:
.globl vector208
vector208:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $208
801065b8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065bd:	e9 2b f3 ff ff       	jmp    801058ed <alltraps>

801065c2 <vector209>:
.globl vector209
vector209:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $209
801065c4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065c9:	e9 1f f3 ff ff       	jmp    801058ed <alltraps>

801065ce <vector210>:
.globl vector210
vector210:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $210
801065d0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065d5:	e9 13 f3 ff ff       	jmp    801058ed <alltraps>

801065da <vector211>:
.globl vector211
vector211:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $211
801065dc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801065e1:	e9 07 f3 ff ff       	jmp    801058ed <alltraps>

801065e6 <vector212>:
.globl vector212
vector212:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $212
801065e8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801065ed:	e9 fb f2 ff ff       	jmp    801058ed <alltraps>

801065f2 <vector213>:
.globl vector213
vector213:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $213
801065f4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801065f9:	e9 ef f2 ff ff       	jmp    801058ed <alltraps>

801065fe <vector214>:
.globl vector214
vector214:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $214
80106600:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106605:	e9 e3 f2 ff ff       	jmp    801058ed <alltraps>

8010660a <vector215>:
.globl vector215
vector215:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $215
8010660c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106611:	e9 d7 f2 ff ff       	jmp    801058ed <alltraps>

80106616 <vector216>:
.globl vector216
vector216:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $216
80106618:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010661d:	e9 cb f2 ff ff       	jmp    801058ed <alltraps>

80106622 <vector217>:
.globl vector217
vector217:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $217
80106624:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106629:	e9 bf f2 ff ff       	jmp    801058ed <alltraps>

8010662e <vector218>:
.globl vector218
vector218:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $218
80106630:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106635:	e9 b3 f2 ff ff       	jmp    801058ed <alltraps>

8010663a <vector219>:
.globl vector219
vector219:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $219
8010663c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106641:	e9 a7 f2 ff ff       	jmp    801058ed <alltraps>

80106646 <vector220>:
.globl vector220
vector220:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $220
80106648:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010664d:	e9 9b f2 ff ff       	jmp    801058ed <alltraps>

80106652 <vector221>:
.globl vector221
vector221:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $221
80106654:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106659:	e9 8f f2 ff ff       	jmp    801058ed <alltraps>

8010665e <vector222>:
.globl vector222
vector222:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $222
80106660:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106665:	e9 83 f2 ff ff       	jmp    801058ed <alltraps>

8010666a <vector223>:
.globl vector223
vector223:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $223
8010666c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106671:	e9 77 f2 ff ff       	jmp    801058ed <alltraps>

80106676 <vector224>:
.globl vector224
vector224:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $224
80106678:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010667d:	e9 6b f2 ff ff       	jmp    801058ed <alltraps>

80106682 <vector225>:
.globl vector225
vector225:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $225
80106684:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106689:	e9 5f f2 ff ff       	jmp    801058ed <alltraps>

8010668e <vector226>:
.globl vector226
vector226:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $226
80106690:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106695:	e9 53 f2 ff ff       	jmp    801058ed <alltraps>

8010669a <vector227>:
.globl vector227
vector227:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $227
8010669c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066a1:	e9 47 f2 ff ff       	jmp    801058ed <alltraps>

801066a6 <vector228>:
.globl vector228
vector228:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $228
801066a8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066ad:	e9 3b f2 ff ff       	jmp    801058ed <alltraps>

801066b2 <vector229>:
.globl vector229
vector229:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $229
801066b4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066b9:	e9 2f f2 ff ff       	jmp    801058ed <alltraps>

801066be <vector230>:
.globl vector230
vector230:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $230
801066c0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066c5:	e9 23 f2 ff ff       	jmp    801058ed <alltraps>

801066ca <vector231>:
.globl vector231
vector231:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $231
801066cc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066d1:	e9 17 f2 ff ff       	jmp    801058ed <alltraps>

801066d6 <vector232>:
.globl vector232
vector232:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $232
801066d8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066dd:	e9 0b f2 ff ff       	jmp    801058ed <alltraps>

801066e2 <vector233>:
.globl vector233
vector233:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $233
801066e4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801066e9:	e9 ff f1 ff ff       	jmp    801058ed <alltraps>

801066ee <vector234>:
.globl vector234
vector234:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $234
801066f0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801066f5:	e9 f3 f1 ff ff       	jmp    801058ed <alltraps>

801066fa <vector235>:
.globl vector235
vector235:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $235
801066fc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106701:	e9 e7 f1 ff ff       	jmp    801058ed <alltraps>

80106706 <vector236>:
.globl vector236
vector236:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $236
80106708:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010670d:	e9 db f1 ff ff       	jmp    801058ed <alltraps>

80106712 <vector237>:
.globl vector237
vector237:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $237
80106714:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106719:	e9 cf f1 ff ff       	jmp    801058ed <alltraps>

8010671e <vector238>:
.globl vector238
vector238:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $238
80106720:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106725:	e9 c3 f1 ff ff       	jmp    801058ed <alltraps>

8010672a <vector239>:
.globl vector239
vector239:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $239
8010672c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106731:	e9 b7 f1 ff ff       	jmp    801058ed <alltraps>

80106736 <vector240>:
.globl vector240
vector240:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $240
80106738:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010673d:	e9 ab f1 ff ff       	jmp    801058ed <alltraps>

80106742 <vector241>:
.globl vector241
vector241:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $241
80106744:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106749:	e9 9f f1 ff ff       	jmp    801058ed <alltraps>

8010674e <vector242>:
.globl vector242
vector242:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $242
80106750:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106755:	e9 93 f1 ff ff       	jmp    801058ed <alltraps>

8010675a <vector243>:
.globl vector243
vector243:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $243
8010675c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106761:	e9 87 f1 ff ff       	jmp    801058ed <alltraps>

80106766 <vector244>:
.globl vector244
vector244:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $244
80106768:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010676d:	e9 7b f1 ff ff       	jmp    801058ed <alltraps>

80106772 <vector245>:
.globl vector245
vector245:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $245
80106774:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106779:	e9 6f f1 ff ff       	jmp    801058ed <alltraps>

8010677e <vector246>:
.globl vector246
vector246:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $246
80106780:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106785:	e9 63 f1 ff ff       	jmp    801058ed <alltraps>

8010678a <vector247>:
.globl vector247
vector247:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $247
8010678c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106791:	e9 57 f1 ff ff       	jmp    801058ed <alltraps>

80106796 <vector248>:
.globl vector248
vector248:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $248
80106798:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010679d:	e9 4b f1 ff ff       	jmp    801058ed <alltraps>

801067a2 <vector249>:
.globl vector249
vector249:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $249
801067a4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067a9:	e9 3f f1 ff ff       	jmp    801058ed <alltraps>

801067ae <vector250>:
.globl vector250
vector250:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $250
801067b0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067b5:	e9 33 f1 ff ff       	jmp    801058ed <alltraps>

801067ba <vector251>:
.globl vector251
vector251:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $251
801067bc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067c1:	e9 27 f1 ff ff       	jmp    801058ed <alltraps>

801067c6 <vector252>:
.globl vector252
vector252:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $252
801067c8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067cd:	e9 1b f1 ff ff       	jmp    801058ed <alltraps>

801067d2 <vector253>:
.globl vector253
vector253:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $253
801067d4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067d9:	e9 0f f1 ff ff       	jmp    801058ed <alltraps>

801067de <vector254>:
.globl vector254
vector254:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $254
801067e0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801067e5:	e9 03 f1 ff ff       	jmp    801058ed <alltraps>

801067ea <vector255>:
.globl vector255
vector255:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $255
801067ec:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801067f1:	e9 f7 f0 ff ff       	jmp    801058ed <alltraps>
801067f6:	66 90                	xchg   %ax,%ax
801067f8:	66 90                	xchg   %ax,%ax
801067fa:	66 90                	xchg   %ax,%ax
801067fc:	66 90                	xchg   %ax,%ax
801067fe:	66 90                	xchg   %ax,%ax

80106800 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	57                   	push   %edi
80106804:	56                   	push   %esi
80106805:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106807:	c1 ea 16             	shr    $0x16,%edx
{
8010680a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010680b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010680e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106811:	8b 1f                	mov    (%edi),%ebx
80106813:	f6 c3 01             	test   $0x1,%bl
80106816:	74 28                	je     80106840 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106818:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010681e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106824:	c1 ee 0a             	shr    $0xa,%esi
}
80106827:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010682a:	89 f2                	mov    %esi,%edx
8010682c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106832:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106835:	5b                   	pop    %ebx
80106836:	5e                   	pop    %esi
80106837:	5f                   	pop    %edi
80106838:	5d                   	pop    %ebp
80106839:	c3                   	ret    
8010683a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106840:	85 c9                	test   %ecx,%ecx
80106842:	74 34                	je     80106878 <walkpgdir+0x78>
80106844:	e8 67 bc ff ff       	call   801024b0 <kalloc>
80106849:	85 c0                	test   %eax,%eax
8010684b:	89 c3                	mov    %eax,%ebx
8010684d:	74 29                	je     80106878 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
8010684f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106856:	00 
80106857:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010685e:	00 
8010685f:	89 04 24             	mov    %eax,(%esp)
80106862:	e8 29 de ff ff       	call   80104690 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106867:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010686d:	83 c8 07             	or     $0x7,%eax
80106870:	89 07                	mov    %eax,(%edi)
80106872:	eb b0                	jmp    80106824 <walkpgdir+0x24>
80106874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80106878:	83 c4 1c             	add    $0x1c,%esp
      return 0;
8010687b:	31 c0                	xor    %eax,%eax
}
8010687d:	5b                   	pop    %ebx
8010687e:	5e                   	pop    %esi
8010687f:	5f                   	pop    %edi
80106880:	5d                   	pop    %ebp
80106881:	c3                   	ret    
80106882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106890 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106896:	89 d3                	mov    %edx,%ebx
{
80106898:	83 ec 1c             	sub    $0x1c,%esp
8010689b:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
8010689e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801068a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068a7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801068ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801068ae:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068b2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801068b9:	29 df                	sub    %ebx,%edi
801068bb:	eb 18                	jmp    801068d5 <mappages+0x45>
801068bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
801068c0:	f6 00 01             	testb  $0x1,(%eax)
801068c3:	75 3d                	jne    80106902 <mappages+0x72>
    *pte = pa | perm | PTE_P;
801068c5:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
801068c8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801068cb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801068cd:	74 29                	je     801068f8 <mappages+0x68>
      break;
    a += PGSIZE;
801068cf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068d8:	b9 01 00 00 00       	mov    $0x1,%ecx
801068dd:	89 da                	mov    %ebx,%edx
801068df:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801068e2:	e8 19 ff ff ff       	call   80106800 <walkpgdir>
801068e7:	85 c0                	test   %eax,%eax
801068e9:	75 d5                	jne    801068c0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801068eb:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801068ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068f3:	5b                   	pop    %ebx
801068f4:	5e                   	pop    %esi
801068f5:	5f                   	pop    %edi
801068f6:	5d                   	pop    %ebp
801068f7:	c3                   	ret    
801068f8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801068fb:	31 c0                	xor    %eax,%eax
}
801068fd:	5b                   	pop    %ebx
801068fe:	5e                   	pop    %esi
801068ff:	5f                   	pop    %edi
80106900:	5d                   	pop    %ebp
80106901:	c3                   	ret    
      panic("remap");
80106902:	c7 04 24 18 7a 10 80 	movl   $0x80107a18,(%esp)
80106909:	e8 52 9a ff ff       	call   80100360 <panic>
8010690e:	66 90                	xchg   %ax,%ax

80106910 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	89 c7                	mov    %eax,%edi
80106916:	56                   	push   %esi
80106917:	89 d6                	mov    %edx,%esi
80106919:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010691a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106920:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106923:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106929:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010692b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010692e:	72 3b                	jb     8010696b <deallocuvm.part.0+0x5b>
80106930:	eb 5e                	jmp    80106990 <deallocuvm.part.0+0x80>
80106932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106938:	8b 10                	mov    (%eax),%edx
8010693a:	f6 c2 01             	test   $0x1,%dl
8010693d:	74 22                	je     80106961 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010693f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106945:	74 54                	je     8010699b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106947:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010694d:	89 14 24             	mov    %edx,(%esp)
80106950:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106953:	e8 a8 b9 ff ff       	call   80102300 <kfree>
      *pte = 0;
80106958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010695b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106961:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106967:	39 f3                	cmp    %esi,%ebx
80106969:	73 25                	jae    80106990 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010696b:	31 c9                	xor    %ecx,%ecx
8010696d:	89 da                	mov    %ebx,%edx
8010696f:	89 f8                	mov    %edi,%eax
80106971:	e8 8a fe ff ff       	call   80106800 <walkpgdir>
    if(!pte)
80106976:	85 c0                	test   %eax,%eax
80106978:	75 be                	jne    80106938 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010697a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106980:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106986:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010698c:	39 f3                	cmp    %esi,%ebx
8010698e:	72 db                	jb     8010696b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106990:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106993:	83 c4 1c             	add    $0x1c,%esp
80106996:	5b                   	pop    %ebx
80106997:	5e                   	pop    %esi
80106998:	5f                   	pop    %edi
80106999:	5d                   	pop    %ebp
8010699a:	c3                   	ret    
        panic("kfree");
8010699b:	c7 04 24 86 73 10 80 	movl   $0x80107386,(%esp)
801069a2:	e8 b9 99 ff ff       	call   80100360 <panic>
801069a7:	89 f6                	mov    %esi,%esi
801069a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069b0 <seginit>:
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069b6:	e8 e5 cc ff ff       	call   801036a0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069bb:	31 c9                	xor    %ecx,%ecx
801069bd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
801069c2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069c8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069cd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069d1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
801069d6:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069d9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069dd:	31 c9                	xor    %ecx,%ecx
801069df:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069e3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069e8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069ec:	31 c9                	xor    %ecx,%ecx
801069ee:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069f2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069f7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069fb:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069fd:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106a01:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a05:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106a09:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a0d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106a11:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a15:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106a19:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
80106a1d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106a21:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a26:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
80106a2a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a2e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106a32:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a36:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
80106a3a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a3e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106a42:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106a46:	c6 40 27 00          	movb   $0x0,0x27(%eax)
80106a4a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106a4e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a52:	c1 e8 10             	shr    $0x10,%eax
80106a55:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a59:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a5c:	0f 01 10             	lgdtl  (%eax)
}
80106a5f:	c9                   	leave  
80106a60:	c3                   	ret    
80106a61:	eb 0d                	jmp    80106a70 <switchkvm>
80106a63:	90                   	nop
80106a64:	90                   	nop
80106a65:	90                   	nop
80106a66:	90                   	nop
80106a67:	90                   	nop
80106a68:	90                   	nop
80106a69:	90                   	nop
80106a6a:	90                   	nop
80106a6b:	90                   	nop
80106a6c:	90                   	nop
80106a6d:	90                   	nop
80106a6e:	90                   	nop
80106a6f:	90                   	nop

80106a70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a70:	a1 a4 57 11 80       	mov    0x801157a4,%eax
{
80106a75:	55                   	push   %ebp
80106a76:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a78:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a7d:	0f 22 d8             	mov    %eax,%cr3
}
80106a80:	5d                   	pop    %ebp
80106a81:	c3                   	ret    
80106a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a90 <switchuvm>:
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
80106a96:	83 ec 1c             	sub    $0x1c,%esp
80106a99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a9c:	85 f6                	test   %esi,%esi
80106a9e:	0f 84 cd 00 00 00    	je     80106b71 <switchuvm+0xe1>
  if(p->kstack == 0)
80106aa4:	8b 46 08             	mov    0x8(%esi),%eax
80106aa7:	85 c0                	test   %eax,%eax
80106aa9:	0f 84 da 00 00 00    	je     80106b89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106aaf:	8b 7e 04             	mov    0x4(%esi),%edi
80106ab2:	85 ff                	test   %edi,%edi
80106ab4:	0f 84 c3 00 00 00    	je     80106b7d <switchuvm+0xed>
  pushcli();
80106aba:	e8 21 da ff ff       	call   801044e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106abf:	e8 5c cb ff ff       	call   80103620 <mycpu>
80106ac4:	89 c3                	mov    %eax,%ebx
80106ac6:	e8 55 cb ff ff       	call   80103620 <mycpu>
80106acb:	89 c7                	mov    %eax,%edi
80106acd:	e8 4e cb ff ff       	call   80103620 <mycpu>
80106ad2:	83 c7 08             	add    $0x8,%edi
80106ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ad8:	e8 43 cb ff ff       	call   80103620 <mycpu>
80106add:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ae0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ae5:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106aec:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106af3:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106afa:	83 c1 08             	add    $0x8,%ecx
80106afd:	c1 e9 10             	shr    $0x10,%ecx
80106b00:	83 c0 08             	add    $0x8,%eax
80106b03:	c1 e8 18             	shr    $0x18,%eax
80106b06:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b0c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106b13:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b19:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b1e:	e8 fd ca ff ff       	call   80103620 <mycpu>
80106b23:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b2a:	e8 f1 ca ff ff       	call   80103620 <mycpu>
80106b2f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106b34:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b38:	e8 e3 ca ff ff       	call   80103620 <mycpu>
80106b3d:	8b 56 08             	mov    0x8(%esi),%edx
80106b40:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106b46:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b49:	e8 d2 ca ff ff       	call   80103620 <mycpu>
80106b4e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b52:	b8 28 00 00 00       	mov    $0x28,%eax
80106b57:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b5a:	8b 46 04             	mov    0x4(%esi),%eax
80106b5d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b62:	0f 22 d8             	mov    %eax,%cr3
}
80106b65:	83 c4 1c             	add    $0x1c,%esp
80106b68:	5b                   	pop    %ebx
80106b69:	5e                   	pop    %esi
80106b6a:	5f                   	pop    %edi
80106b6b:	5d                   	pop    %ebp
  popcli();
80106b6c:	e9 af d9 ff ff       	jmp    80104520 <popcli>
    panic("switchuvm: no process");
80106b71:	c7 04 24 1e 7a 10 80 	movl   $0x80107a1e,(%esp)
80106b78:	e8 e3 97 ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
80106b7d:	c7 04 24 49 7a 10 80 	movl   $0x80107a49,(%esp)
80106b84:	e8 d7 97 ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106b89:	c7 04 24 34 7a 10 80 	movl   $0x80107a34,(%esp)
80106b90:	e8 cb 97 ff ff       	call   80100360 <panic>
80106b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ba0 <inituvm>:
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
80106ba6:	83 ec 1c             	sub    $0x1c,%esp
80106ba9:	8b 75 10             	mov    0x10(%ebp),%esi
80106bac:	8b 45 08             	mov    0x8(%ebp),%eax
80106baf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106bb2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106bb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106bbb:	77 54                	ja     80106c11 <inituvm+0x71>
  mem = kalloc();
80106bbd:	e8 ee b8 ff ff       	call   801024b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106bc2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bc9:	00 
80106bca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bd1:	00 
  mem = kalloc();
80106bd2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106bd4:	89 04 24             	mov    %eax,(%esp)
80106bd7:	e8 b4 da ff ff       	call   80104690 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106bdc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106be2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106be7:	89 04 24             	mov    %eax,(%esp)
80106bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bed:	31 d2                	xor    %edx,%edx
80106bef:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106bf6:	00 
80106bf7:	e8 94 fc ff ff       	call   80106890 <mappages>
  memmove(mem, init, sz);
80106bfc:	89 75 10             	mov    %esi,0x10(%ebp)
80106bff:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c02:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c05:	83 c4 1c             	add    $0x1c,%esp
80106c08:	5b                   	pop    %ebx
80106c09:	5e                   	pop    %esi
80106c0a:	5f                   	pop    %edi
80106c0b:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c0c:	e9 1f db ff ff       	jmp    80104730 <memmove>
    panic("inituvm: more than a page");
80106c11:	c7 04 24 5d 7a 10 80 	movl   $0x80107a5d,(%esp)
80106c18:	e8 43 97 ff ff       	call   80100360 <panic>
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi

80106c20 <loaduvm>:
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106c29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106c30:	0f 85 98 00 00 00    	jne    80106cce <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106c36:	8b 75 18             	mov    0x18(%ebp),%esi
80106c39:	31 db                	xor    %ebx,%ebx
80106c3b:	85 f6                	test   %esi,%esi
80106c3d:	75 1a                	jne    80106c59 <loaduvm+0x39>
80106c3f:	eb 77                	jmp    80106cb8 <loaduvm+0x98>
80106c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106c54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106c57:	76 5f                	jbe    80106cb8 <loaduvm+0x98>
80106c59:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c5c:	31 c9                	xor    %ecx,%ecx
80106c5e:	8b 45 08             	mov    0x8(%ebp),%eax
80106c61:	01 da                	add    %ebx,%edx
80106c63:	e8 98 fb ff ff       	call   80106800 <walkpgdir>
80106c68:	85 c0                	test   %eax,%eax
80106c6a:	74 56                	je     80106cc2 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
80106c6c:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
80106c6e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106c73:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106c76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
80106c7b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106c81:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c84:	05 00 00 00 80       	add    $0x80000000,%eax
80106c89:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c8d:	8b 45 10             	mov    0x10(%ebp),%eax
80106c90:	01 d9                	add    %ebx,%ecx
80106c92:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106c96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106c9a:	89 04 24             	mov    %eax,(%esp)
80106c9d:	e8 ce ac ff ff       	call   80101970 <readi>
80106ca2:	39 f8                	cmp    %edi,%eax
80106ca4:	74 a2                	je     80106c48 <loaduvm+0x28>
}
80106ca6:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cae:	5b                   	pop    %ebx
80106caf:	5e                   	pop    %esi
80106cb0:	5f                   	pop    %edi
80106cb1:	5d                   	pop    %ebp
80106cb2:	c3                   	ret    
80106cb3:	90                   	nop
80106cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cb8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106cbb:	31 c0                	xor    %eax,%eax
}
80106cbd:	5b                   	pop    %ebx
80106cbe:	5e                   	pop    %esi
80106cbf:	5f                   	pop    %edi
80106cc0:	5d                   	pop    %ebp
80106cc1:	c3                   	ret    
      panic("loaduvm: address should exist");
80106cc2:	c7 04 24 77 7a 10 80 	movl   $0x80107a77,(%esp)
80106cc9:	e8 92 96 ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
80106cce:	c7 04 24 18 7b 10 80 	movl   $0x80107b18,(%esp)
80106cd5:	e8 86 96 ff ff       	call   80100360 <panic>
80106cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ce0 <allocuvm>:
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 1c             	sub    $0x1c,%esp
80106ce9:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106cec:	85 ff                	test   %edi,%edi
80106cee:	0f 88 7e 00 00 00    	js     80106d72 <allocuvm+0x92>
  if(newsz < oldsz)
80106cf4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106cfa:	72 78                	jb     80106d74 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
80106cfc:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d02:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106d08:	39 df                	cmp    %ebx,%edi
80106d0a:	77 4a                	ja     80106d56 <allocuvm+0x76>
80106d0c:	eb 72                	jmp    80106d80 <allocuvm+0xa0>
80106d0e:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
80106d10:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d17:	00 
80106d18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106d1f:	00 
80106d20:	89 04 24             	mov    %eax,(%esp)
80106d23:	e8 68 d9 ff ff       	call   80104690 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d28:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d2e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d33:	89 04 24             	mov    %eax,(%esp)
80106d36:	8b 45 08             	mov    0x8(%ebp),%eax
80106d39:	89 da                	mov    %ebx,%edx
80106d3b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106d42:	00 
80106d43:	e8 48 fb ff ff       	call   80106890 <mappages>
80106d48:	85 c0                	test   %eax,%eax
80106d4a:	78 44                	js     80106d90 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
80106d4c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d52:	39 df                	cmp    %ebx,%edi
80106d54:	76 2a                	jbe    80106d80 <allocuvm+0xa0>
    mem = kalloc();
80106d56:	e8 55 b7 ff ff       	call   801024b0 <kalloc>
    if(mem == 0){
80106d5b:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106d5d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106d5f:	75 af                	jne    80106d10 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106d61:	c7 04 24 95 7a 10 80 	movl   $0x80107a95,(%esp)
80106d68:	e8 e3 98 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106d6d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d70:	77 48                	ja     80106dba <allocuvm+0xda>
      return 0;
80106d72:	31 c0                	xor    %eax,%eax
}
80106d74:	83 c4 1c             	add    $0x1c,%esp
80106d77:	5b                   	pop    %ebx
80106d78:	5e                   	pop    %esi
80106d79:	5f                   	pop    %edi
80106d7a:	5d                   	pop    %ebp
80106d7b:	c3                   	ret    
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d80:	83 c4 1c             	add    $0x1c,%esp
80106d83:	89 f8                	mov    %edi,%eax
80106d85:	5b                   	pop    %ebx
80106d86:	5e                   	pop    %esi
80106d87:	5f                   	pop    %edi
80106d88:	5d                   	pop    %ebp
80106d89:	c3                   	ret    
80106d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106d90:	c7 04 24 ad 7a 10 80 	movl   $0x80107aad,(%esp)
80106d97:	e8 b4 98 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106d9c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d9f:	76 0d                	jbe    80106dae <allocuvm+0xce>
80106da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106da4:	89 fa                	mov    %edi,%edx
80106da6:	8b 45 08             	mov    0x8(%ebp),%eax
80106da9:	e8 62 fb ff ff       	call   80106910 <deallocuvm.part.0>
      kfree(mem);
80106dae:	89 34 24             	mov    %esi,(%esp)
80106db1:	e8 4a b5 ff ff       	call   80102300 <kfree>
      return 0;
80106db6:	31 c0                	xor    %eax,%eax
80106db8:	eb ba                	jmp    80106d74 <allocuvm+0x94>
80106dba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dbd:	89 fa                	mov    %edi,%edx
80106dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc2:	e8 49 fb ff ff       	call   80106910 <deallocuvm.part.0>
      return 0;
80106dc7:	31 c0                	xor    %eax,%eax
80106dc9:	eb a9                	jmp    80106d74 <allocuvm+0x94>
80106dcb:	90                   	nop
80106dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106dd0 <deallocuvm>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106ddc:	39 d1                	cmp    %edx,%ecx
80106dde:	73 08                	jae    80106de8 <deallocuvm+0x18>
}
80106de0:	5d                   	pop    %ebp
80106de1:	e9 2a fb ff ff       	jmp    80106910 <deallocuvm.part.0>
80106de6:	66 90                	xchg   %ax,%ax
80106de8:	89 d0                	mov    %edx,%eax
80106dea:	5d                   	pop    %ebp
80106deb:	c3                   	ret    
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106df0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	56                   	push   %esi
80106df4:	53                   	push   %ebx
80106df5:	83 ec 10             	sub    $0x10,%esp
80106df8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106dfb:	85 f6                	test   %esi,%esi
80106dfd:	74 59                	je     80106e58 <freevm+0x68>
80106dff:	31 c9                	xor    %ecx,%ecx
80106e01:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e06:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e08:	31 db                	xor    %ebx,%ebx
80106e0a:	e8 01 fb ff ff       	call   80106910 <deallocuvm.part.0>
80106e0f:	eb 12                	jmp    80106e23 <freevm+0x33>
80106e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e18:	83 c3 01             	add    $0x1,%ebx
80106e1b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106e21:	74 27                	je     80106e4a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e23:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106e26:	f6 c2 01             	test   $0x1,%dl
80106e29:	74 ed                	je     80106e18 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e2b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106e31:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e34:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106e3a:	89 14 24             	mov    %edx,(%esp)
80106e3d:	e8 be b4 ff ff       	call   80102300 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106e42:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106e48:	75 d9                	jne    80106e23 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106e4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e4d:	83 c4 10             	add    $0x10,%esp
80106e50:	5b                   	pop    %ebx
80106e51:	5e                   	pop    %esi
80106e52:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106e53:	e9 a8 b4 ff ff       	jmp    80102300 <kfree>
    panic("freevm: no pgdir");
80106e58:	c7 04 24 c9 7a 10 80 	movl   $0x80107ac9,(%esp)
80106e5f:	e8 fc 94 ff ff       	call   80100360 <panic>
80106e64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e70 <setupkvm>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	56                   	push   %esi
80106e74:	53                   	push   %ebx
80106e75:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106e78:	e8 33 b6 ff ff       	call   801024b0 <kalloc>
80106e7d:	85 c0                	test   %eax,%eax
80106e7f:	89 c6                	mov    %eax,%esi
80106e81:	74 6d                	je     80106ef0 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
80106e83:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106e8a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e8b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106e90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e97:	00 
80106e98:	89 04 24             	mov    %eax,(%esp)
80106e9b:	e8 f0 d7 ff ff       	call   80104690 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ea0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106ea3:	8b 43 04             	mov    0x4(%ebx),%eax
80106ea6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ea9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106ead:	8b 13                	mov    (%ebx),%edx
80106eaf:	89 04 24             	mov    %eax,(%esp)
80106eb2:	29 c1                	sub    %eax,%ecx
80106eb4:	89 f0                	mov    %esi,%eax
80106eb6:	e8 d5 f9 ff ff       	call   80106890 <mappages>
80106ebb:	85 c0                	test   %eax,%eax
80106ebd:	78 19                	js     80106ed8 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ebf:	83 c3 10             	add    $0x10,%ebx
80106ec2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ec8:	72 d6                	jb     80106ea0 <setupkvm+0x30>
80106eca:	89 f0                	mov    %esi,%eax
}
80106ecc:	83 c4 10             	add    $0x10,%esp
80106ecf:	5b                   	pop    %ebx
80106ed0:	5e                   	pop    %esi
80106ed1:	5d                   	pop    %ebp
80106ed2:	c3                   	ret    
80106ed3:	90                   	nop
80106ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106ed8:	89 34 24             	mov    %esi,(%esp)
80106edb:	e8 10 ff ff ff       	call   80106df0 <freevm>
}
80106ee0:	83 c4 10             	add    $0x10,%esp
      return 0;
80106ee3:	31 c0                	xor    %eax,%eax
}
80106ee5:	5b                   	pop    %ebx
80106ee6:	5e                   	pop    %esi
80106ee7:	5d                   	pop    %ebp
80106ee8:	c3                   	ret    
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106ef0:	31 c0                	xor    %eax,%eax
80106ef2:	eb d8                	jmp    80106ecc <setupkvm+0x5c>
80106ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f00 <kvmalloc>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f06:	e8 65 ff ff ff       	call   80106e70 <setupkvm>
80106f0b:	a3 a4 57 11 80       	mov    %eax,0x801157a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f10:	05 00 00 00 80       	add    $0x80000000,%eax
80106f15:	0f 22 d8             	mov    %eax,%cr3
}
80106f18:	c9                   	leave  
80106f19:	c3                   	ret    
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f20 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f21:	31 c9                	xor    %ecx,%ecx
{
80106f23:	89 e5                	mov    %esp,%ebp
80106f25:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2e:	e8 cd f8 ff ff       	call   80106800 <walkpgdir>
  if(pte == 0)
80106f33:	85 c0                	test   %eax,%eax
80106f35:	74 05                	je     80106f3c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106f37:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f3a:	c9                   	leave  
80106f3b:	c3                   	ret    
    panic("clearpteu");
80106f3c:	c7 04 24 da 7a 10 80 	movl   $0x80107ada,(%esp)
80106f43:	e8 18 94 ff ff       	call   80100360 <panic>
80106f48:	90                   	nop
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
80106f56:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f59:	e8 12 ff ff ff       	call   80106e70 <setupkvm>
80106f5e:	85 c0                	test   %eax,%eax
80106f60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f63:	0f 84 b9 00 00 00    	je     80107022 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f69:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f6c:	85 c0                	test   %eax,%eax
80106f6e:	0f 84 94 00 00 00    	je     80107008 <copyuvm+0xb8>
80106f74:	31 ff                	xor    %edi,%edi
80106f76:	eb 48                	jmp    80106fc0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f78:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106f7e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106f85:	00 
80106f86:	89 74 24 04          	mov    %esi,0x4(%esp)
80106f8a:	89 04 24             	mov    %eax,(%esp)
80106f8d:	e8 9e d7 ff ff       	call   80104730 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f95:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f9a:	89 fa                	mov    %edi,%edx
80106f9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fa0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fa6:	89 04 24             	mov    %eax,(%esp)
80106fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fac:	e8 df f8 ff ff       	call   80106890 <mappages>
80106fb1:	85 c0                	test   %eax,%eax
80106fb3:	78 63                	js     80107018 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106fb5:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106fbb:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106fbe:	76 48                	jbe    80107008 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc3:	31 c9                	xor    %ecx,%ecx
80106fc5:	89 fa                	mov    %edi,%edx
80106fc7:	e8 34 f8 ff ff       	call   80106800 <walkpgdir>
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	74 62                	je     80107032 <copyuvm+0xe2>
    if(!(*pte & PTE_P))
80106fd0:	8b 00                	mov    (%eax),%eax
80106fd2:	a8 01                	test   $0x1,%al
80106fd4:	74 50                	je     80107026 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106fd6:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106fd8:	25 ff 0f 00 00       	and    $0xfff,%eax
80106fdd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106fe0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106fe6:	e8 c5 b4 ff ff       	call   801024b0 <kalloc>
80106feb:	85 c0                	test   %eax,%eax
80106fed:	89 c3                	mov    %eax,%ebx
80106fef:	75 87                	jne    80106f78 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ff4:	89 04 24             	mov    %eax,(%esp)
80106ff7:	e8 f4 fd ff ff       	call   80106df0 <freevm>
  return 0;
80106ffc:	31 c0                	xor    %eax,%eax
}
80106ffe:	83 c4 2c             	add    $0x2c,%esp
80107001:	5b                   	pop    %ebx
80107002:	5e                   	pop    %esi
80107003:	5f                   	pop    %edi
80107004:	5d                   	pop    %ebp
80107005:	c3                   	ret    
80107006:	66 90                	xchg   %ax,%ax
80107008:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010700b:	83 c4 2c             	add    $0x2c,%esp
8010700e:	5b                   	pop    %ebx
8010700f:	5e                   	pop    %esi
80107010:	5f                   	pop    %edi
80107011:	5d                   	pop    %ebp
80107012:	c3                   	ret    
80107013:	90                   	nop
80107014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107018:	89 1c 24             	mov    %ebx,(%esp)
8010701b:	e8 e0 b2 ff ff       	call   80102300 <kfree>
      goto bad;
80107020:	eb cf                	jmp    80106ff1 <copyuvm+0xa1>
    return 0;
80107022:	31 c0                	xor    %eax,%eax
80107024:	eb d8                	jmp    80106ffe <copyuvm+0xae>
      panic("copyuvm: page not present");
80107026:	c7 04 24 fe 7a 10 80 	movl   $0x80107afe,(%esp)
8010702d:	e8 2e 93 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80107032:	c7 04 24 e4 7a 10 80 	movl   $0x80107ae4,(%esp)
80107039:	e8 22 93 ff ff       	call   80100360 <panic>
8010703e:	66 90                	xchg   %ax,%ax

80107040 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107040:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107041:	31 c9                	xor    %ecx,%ecx
{
80107043:	89 e5                	mov    %esp,%ebp
80107045:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107048:	8b 55 0c             	mov    0xc(%ebp),%edx
8010704b:	8b 45 08             	mov    0x8(%ebp),%eax
8010704e:	e8 ad f7 ff ff       	call   80106800 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107053:	8b 00                	mov    (%eax),%eax
80107055:	89 c2                	mov    %eax,%edx
80107057:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
8010705a:	83 fa 05             	cmp    $0x5,%edx
8010705d:	75 11                	jne    80107070 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010705f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107064:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107069:	c9                   	leave  
8010706a:	c3                   	ret    
8010706b:	90                   	nop
8010706c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80107070:	31 c0                	xor    %eax,%eax
}
80107072:	c9                   	leave  
80107073:	c3                   	ret    
80107074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010707a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107080 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 1c             	sub    $0x1c,%esp
80107089:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010708c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010708f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107092:	85 db                	test   %ebx,%ebx
80107094:	75 3a                	jne    801070d0 <copyout+0x50>
80107096:	eb 68                	jmp    80107100 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107098:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010709b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010709d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
801070a1:	29 ca                	sub    %ecx,%edx
801070a3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801070a9:	39 da                	cmp    %ebx,%edx
801070ab:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
801070ae:	29 f1                	sub    %esi,%ecx
801070b0:	01 c8                	add    %ecx,%eax
801070b2:	89 54 24 08          	mov    %edx,0x8(%esp)
801070b6:	89 04 24             	mov    %eax,(%esp)
801070b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801070bc:	e8 6f d6 ff ff       	call   80104730 <memmove>
    len -= n;
    buf += n;
801070c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
801070c4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
801070ca:	01 d7                	add    %edx,%edi
  while(len > 0){
801070cc:	29 d3                	sub    %edx,%ebx
801070ce:	74 30                	je     80107100 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
801070d0:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
801070d3:	89 ce                	mov    %ecx,%esi
801070d5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801070db:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
801070df:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801070e2:	89 04 24             	mov    %eax,(%esp)
801070e5:	e8 56 ff ff ff       	call   80107040 <uva2ka>
    if(pa0 == 0)
801070ea:	85 c0                	test   %eax,%eax
801070ec:	75 aa                	jne    80107098 <copyout+0x18>
  }
  return 0;
}
801070ee:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801070f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070f6:	5b                   	pop    %ebx
801070f7:	5e                   	pop    %esi
801070f8:	5f                   	pop    %edi
801070f9:	5d                   	pop    %ebp
801070fa:	c3                   	ret    
801070fb:	90                   	nop
801070fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107100:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80107103:	31 c0                	xor    %eax,%eax
}
80107105:	5b                   	pop    %ebx
80107106:	5e                   	pop    %esi
80107107:	5f                   	pop    %edi
80107108:	5d                   	pop    %ebp
80107109:	c3                   	ret    
