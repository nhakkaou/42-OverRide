# Level01

when we run the file we found that they prompt two field username and password

```
level02@OverRide:~$ ./level02
===== [ Secure Access System v1.0 ] =====
/***************************************\
| You must login to access this system. |
\**************************************/
--[ Username: Hello
--[ Password: AAAA
*****************************************
Hello does not have access!
```

we start by disass the main and we found this time we have some new registers `rdx, rdi ..` are x86 64 registers

```
The 64-bit versions of the 'original' x86 registers are named:

rax - register a extended
rbx - register b extended
rcx - register c extended
rdx - register d extended
rbp - register base pointer (start of stack)
rsp - register stack pointer (current location in stack, growing downwards)
rsi - register source index (source for data copies)
rdi - register destination index (destination for data copies)
```

in the first part they try to fill rdi with 0 size 0xc

```
0x000000000040082c <+24>:	lea    rdx,[rbp-0x70]
   0x0000000000400830 <+28>:	mov    eax,0x0
   0x0000000000400835 <+33>:	mov    ecx,0xc
   0x000000000040083a <+38>:	mov    rdi,rdx
=> 0x000000000040083d <+41>:	rep stos QWORD PTR es:[rdi],rax
```

in the next steps from `<+41>` to `<+111>` they fill the memory by the value 0x0 and then they try to open ` "/home/users/level03/.pass"` because we use the gdb to disass this file gdb doesnt have the permission to open it i create a file locally and before the call fopen i set the file as a value of `rdi`

after they read the file they store how many characters read in `rbp-0xc` and then preare the params to passe them to the function ` size_t strcspn(const char *str1, const char *str2);` This function returns the number of characters in the initial segment of string str1 which are not in the string str2.
