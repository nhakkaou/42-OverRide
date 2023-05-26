# Level 07

We start by testing the exuctable file so this executable in the first step show this menu

```
----------------------------------------------------
  Welcome to wil's crappy number storage service!
----------------------------------------------------
 Commands:
    store - store a number into the data storage
    read  - read a number from the data storage
    quit  - exit the program
----------------------------------------------------
   wil has reserved some storage :>
----------------------------------------------------

Input command:
```

We Have 3 cases the first one for storing an element and the second read from this buffer and the last one for leaving the program

we Try to store an element and read it:

```
Input command: store
 Number: 111111111111111111111111111111
 Index: 2
 Completed store command successfully
 Input command: read
 Index: 2
 Number at data[2] is 4294967295
 Completed read  command successfully
Input command:
```

we found that the maximum number can store is `4294967295` lets start using GDB

in the first part in the main function

```
   0x08048735 <+18>:    mov    DWORD PTR [esp+0x1c],eax
   0x08048739 <+22>:    mov    eax,DWORD PTR [ebp+0x10]
   0x0804873c <+25>:    mov    DWORD PTR [esp+0x18],eax
   0x08048740 <+29>:    mov    eax,gs:0x14
   0x08048746 <+35>:    mov    DWORD PTR [esp+0x1cc],eax
   0x0804874d <+42>:    xor    eax,eax
   0x0804874f <+44>:    mov    DWORD PTR [esp+0x1b4],0x0
   0x0804875a <+55>:    mov    DWORD PTR [esp+0x1b8],0x0
   0x08048765 <+66>:    mov    DWORD PTR [esp+0x1bc],0x0
   0x08048770 <+77>:    mov    DWORD PTR [esp+0x1c0],0x0
   0x0804877b <+88>:    mov    DWORD PTR [esp+0x1c4],0x0
   0x08048786 <+99>:    mov    DWORD PTR [esp+0x1c8],0x0
   0x08048791 <+110>:   lea    ebx,[esp+0x24]
   0x08048795 <+114>:   mov    eax,0x0
   0x0804879a <+119>:   mov    edx,0x64
   0x0804879f <+124>:   mov    edi,ebx
   0x080487a1 <+126>:   mov    ecx,edx
   0x080487a3 <+128>:   rep stos DWORD PTR es:[edi],eax
   0x080487a5 <+130>:   jmp    0x80487ea <main+199>
   0x080487a7 <+132>:   mov    eax,DWORD PTR [esp+0x1c]
   0x080487ab <+136>:   mov    eax,DWORD PTR [eax]
   0x080487ad <+138>:   mov    DWORD PTR [esp+0x14],0xffffffff
   0x080487b5 <+146>:   mov    edx,eax
   0x080487b7 <+148>:   mov    eax,0x0
   0x080487bc <+153>:   mov    ecx,DWORD PTR [esp+0x14]
   0x080487c0 <+157>:   mov    edi,edx
   0x080487c2 <+159>:   repnz scas al,BYTE PTR es:[edi]
   0x080487c4 <+161>:   mov    eax,ecx
   0x080487c6 <+163>:   not    eax
   0x080487c8 <+165>:   lea    edx,[eax-0x1]
   0x080487cb <+168>:   mov    eax,DWORD PTR [esp+0x1c]
   0x080487cf <+172>:   mov    eax,DWORD PTR [eax]
   0x080487d1 <+174>:   mov    DWORD PTR [esp+0x8],edx
   0x080487d5 <+178>:   mov    DWORD PTR [esp+0x4],0x0
   0x080487dd <+186>:   mov    DWORD PTR [esp],eax
   0x080487e0 <+189>:   call   0x80484f0 <memset@plt>
   0x080487e5 <+194>:   add    DWORD PTR [esp+0x1c],0x4
   0x080487ea <+199>:   mov    eax,DWORD PTR [esp+0x1c]
   0x080487ee <+203>:   mov    eax,DWORD PTR [eax]
   0x080487f0 <+205>:   test   eax,eax
   0x080487f2 <+207>:   jne    0x80487a7 <main+132>
   0x080487f4 <+209>:   jmp    0x8048839 <main+278>
   0x080487f6 <+211>:   mov    eax,DWORD PTR [esp+0x18]
   0x080487fa <+215>:   mov    eax,DWORD PTR [eax]
   0x080487fc <+217>:   mov    DWORD PTR [esp+0x14],0xffffffff
   0x08048804 <+225>:   mov    edx,eax
   0x08048806 <+227>:   mov    eax,0x0
   0x0804880b <+232>:   mov    ecx,DWORD PTR [esp+0x14]
   0x0804880f <+236>:   mov    edi,edx
   0x08048811 <+238>:   repnz scas al,BYTE PTR es:[edi]
   0x08048813 <+240>:   mov    eax,ecx
   0x08048815 <+242>:   not    eax
   0x08048817 <+244>:   lea    edx,[eax-0x1]
   0x0804881a <+247>:   mov    eax,DWORD PTR [esp+0x18]
   0x0804881e <+251>:   mov    eax,DWORD PTR [eax]
   0x08048820 <+253>:   mov    DWORD PTR [esp+0x8],edx
   0x08048824 <+257>:   mov    DWORD PTR [esp+0x4],0x0
   0x0804882c <+265>:   mov    DWORD PTR [esp],eax
   0x0804882f <+268>:   call   0x80484f0 <memset@plt>
   0x08048834 <+273>:   add    DWORD PTR [esp+0x18],0x4
   0x08048839 <+278>:   mov    eax,DWORD PTR [esp+0x18]
   0x0804883d <+282>:   mov    eax,DWORD PTR [eax]
   ...
```

this program clear the Argument and Env Variables we put a break point in the line <+288> we check te stack and we got:

```
0xffffd530:     0xffffd8d0      0x00000000      0x0000001b      0xf7fdc714
0xffffd540:     0x00000098      0xffffffff      0xffffd7bc      0xffffd7b8
0xffffd550:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd560:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd570:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd580:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd590:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd5a0:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd5b0:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd5c0:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd5d0:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd5e0:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd5f0:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd600:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd610:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd620:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd630:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd640:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd650:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd660:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd670:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd680:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd690:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd6a0:     0x00000000      0x00000000      0x00000000      0x00000000
0xffffd6b0:     0x00000000      0x00000000      0x00000000      0x00000000
```

after that there's loop that compare the input with `store`, `read`, `quit` lets start check te store first

```
   0x08048901 <+478>:   mov    eax,0x8048d61 // "store"
   0x08048906 <+483>:   mov    ecx,0x4
   0x0804890b <+488>:   mov    esi,edx
   0x0804890d <+490>:   mov    edi,eax
   0x0804890f <+492>:   repz cmps BYTE PTR ds:[esi],BYTE PTR es:[edi] // looks like strcmp
   0x08048911 <+494>:   seta   dl
   0x08048914 <+497>:   setb   al
   0x08048917 <+500>:   mov    ecx,edx
   0x08048919 <+502>:   sub    cl,al
   0x0804891b <+504>:   mov    eax,ecx
   0x0804891d <+506>:   movsx  eax,al
   0x08048920 <+509>:   test   eax,eax
   0x08048922 <+511>:   jne    0x8048939 <main+534>
   0x08048924 <+513>:   lea    eax,[esp+0x24]
   0x08048928 <+517>:   mov    DWORD PTR [esp],eax
   0x0804892b <+520>:   call   0x80486d7 <read_number>  // Here we found this function that read number
   0x08048930 <+525>:   mov    DWORD PTR [esp+0x1b4],eax
   0x08048937 <+532>:   jmp    0x8048965 <main+578>
   0x08048939 <+534>:   lea    eax,[esp+0x1b8]
   0x08048940 <+541>:   mov    edx,eax
   0x08048942 <+543>:   mov    eax,0x8048d66
   0x08048947 <+548>:   mov    ecx,0x4
   0x0804894c <+553>:   mov    esi,edx
   0x0804894e <+555>:   mov    edi,eax
```

in this section there's another function `read_number()` lets disass this function

```
Dump of assembler code for function read_number:
   0x080486d7 <+0>:     push   ebp
   0x080486d8 <+1>:     mov    ebp,esp
   0x080486da <+3>:     sub    esp,0x28
   0x080486dd <+6>:     mov    DWORD PTR [ebp-0xc],0x0
   0x080486e4 <+13>:    mov    eax,0x8048add
   0x080486e9 <+18>:    mov    DWORD PTR [esp],eax
   0x080486ec <+21>:    call   0x8048470 <printf@plt>
   0x080486f1 <+26>:    call   0x80485e7 <get_unum>
   0x080486f6 <+31>:    mov    DWORD PTR [ebp-0xc],eax
   0x080486f9 <+34>:    mov    eax,DWORD PTR [ebp-0xc]
   0x080486fc <+37>:    shl    eax,0x2
   0x080486ff <+40>:    add    eax,DWORD PTR [ebp+0x8]
   0x08048702 <+43>:    mov    edx,DWORD PTR [eax]
   0x08048704 <+45>:    mov    eax,0x8048b1b
   0x08048709 <+50>:    mov    DWORD PTR [esp+0x8],edx
   0x0804870d <+54>:    mov    edx,DWORD PTR [ebp-0xc]
   0x08048710 <+57>:    mov    DWORD PTR [esp+0x4],edx
   0x08048714 <+61>:    mov    DWORD PTR [esp],eax
   0x08048717 <+64>:    call   0x8048470 <printf@plt>
   0x0804871c <+69>:    mov    eax,0x0
   0x08048721 <+74>:    leave
   0x08048722 <+75>:    ret
End of assembler dump.
```
