# level03

In the binary program called level03, there is a prompt asking for a password. If the password provided is incorrect, the program displays the message "Invalid Password!" and terminates.

```bash

level03@OverRide:~$ ./level03
***********************************
*		level03		**
***********************************
Password:1232

Invalid Password
```
Let's begin our analysis of the binary using gdb to explore its functionality. We have identified three functions:  decrypt, and test, in addition to the main function.


```bash
(gdb) info function
...
*********************
0x08048540  _start
0x08048570  __do_global_dtors_aux
0x080485d0  frame_dummy
0x080485f4  clear_stdin
0x08048617  get_unum
0x0804864f  prog_timeout
0x08048660  decrypt
0x08048747  test
0x0804885a  main
********************
...
```

Within the binary's main function, the user is prompted to input a password. Once the password is entered, the program invokes the test function to evaluate a condition. In this case, the condition involves subtracting the password from 322424845 (0x1337d00d).

If the result of this subtraction is less than 0x15 (21 in dicimal), the program proceeds to execute the decrypt function, passing the obtained result as an argument for decrypting the password.

In the decrypt function, there is a loop that iterates over the characters of the string ``"Q}|u`sfg~sf{}|a"``. Each character is XORed with the argument passed to the function. The resulting value is then compared with the string "Congratulations!". If the XORed value matches the `"Congratulations!"` string, the system function is executed with the argument "/bin/sh" to spawn a shell.

To find the correct password, we need to determine the value that, when subtracted from `322424845` (0x1337d00d), yields a result less than `0x15` (21 in decimal). Once we have this value, we can pass it to the decrypt function, perform XOR operations on each character, and check if the resulting string matches "Congratulations!".


To find the value, we can use the XOR operation in reverse. We know that "Q" XOR unknown_value should equal "C". By performing the XOR operation between the ASCII values of "Q" and "C", we can find the unknown_value:

```python
>>> ord("Q") ^ ord("C")
18
```
our value is 18, so let calculate the password:

```python
>>> 322424845 - 18
322424827
```
let run the binary with the password:

```bash
level03@OverRide:~$ ./level03
***********************************
*		level03		**
***********************************
Password:322424827
$ whoami
level04
$ cat /home/users/level04/.pass
kgv3tkEb9h2mLkRsPkXRfc2mHbjMxQzvb2FrgKkf
```
as you can see, we got the password for the next level.