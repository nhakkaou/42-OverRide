# level06

we start by checking our binary `level06` we found that ask for a username and a password so we try to run it and see what happens

```bash
level06@OverRide:~$ ./level06
***********************************
*		level06		  *
***********************************
-> Enter Login: mourad
***********************************
***** NEW ACCOUNT DETECTED ********
***********************************
-> Enter Serial: 123456
```

let try to debug it with gdb and see what happens, we have a `main` function and a `auth` function , the `main` function ask for a username and a password and then call the `auth` function with the username and the password as arguments and then check the return value of the `auth` function if it's 0 it print `Authenticated` and run system with /bin/sh as argument.
let deep dive into the `auth` function and see what happens exactly

in the auth function they take the login and encrypt it and then compare it with the serial number if it's equal it return 0 else it return 1 . let use gdb and see the password generated using gdb.

```bash
   0x080487b5 <+109>:   call   0x80485f0 <ptrace@plt>
   0x080487ba <+114>:   cmp    eax,0xffffffff
```

first we need to bypass the `ptrace` to contunie debugging the binary , we can do that by setting the `ptrace` return value to 0 in the `auth ` function.

let break at the `cmp` instruction and see the password generated i will use `mourad` as username and `123456789` as password

```bash
=> 0x8048866 <auth+286>:	cmp    eax,DWORD PTR [ebp-0x10]
   0x8048869 <auth+289>:	je     0x8048872 <auth+298>
   0x804886b <auth+291>:	mov    eax,0x1
   0x8048870 <auth+296>:	jmp    0x8048877 <auth+303>
   0x8048872 <auth+298>:	mov    eax,0x0


Breakpoint 2, 0x08048866 in auth ()
(gdb) info registers eax
eax            0x75bcd15	123456789
(gdb) x/wd $ebp-0x10
0xffffd678:	6232836

```

so the password for login `mourad` is `6232836` let try it

```bash
level06@OverRide:~$ ./level06
***********************************
*		level06		  *
***********************************
-> Enter Login: mourad
***********************************
***** NEW ACCOUNT DETECTED ********
***********************************
-> Enter Serial: 6232836
Authenticated!
$ whoami
level07
$ cat /home/users/level07/.pass
GbcPDRgsFK77LNnnuh7QyFYA2942Gp8yKj9KrWD8
```
