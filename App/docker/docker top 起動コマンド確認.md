<pre>
[root~]# docker run -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
Unable to find image 'ubuntu:14.04' locally
14.04: Pulling from library/ubuntu
a7344f52cb74: Pull complete
515c9bb51536: Pull complete
e1eabe0537eb: Pull complete
4701f1215c13: Pull complete
Digest: sha256:2f7c79927b346e436cc14c92bd4e5bd778c3bd7037f35bc639ac1589a7acfa90
Status: Downloaded newer image for ubuntu:14.04
acfdbec666a9c4082ed6f32636e43d69505540036df54814a91ad4036b2fxxxx
[root~]# docker container ls
CONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS              PORTS                   NAMES
acfdbec666a9        ubuntu:14.04                "/bin/sh -c 'while..."   19 seconds ago      Up 18 seconds                               unruffled_darwin
[root~]# docker container top unruffled_darwin
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                3161                3044                0                   14:40               ?                   00:00:00            /bin/sh -c while true; do echo hello world; sleep 1; done
root                3368                3161                0                   14:41               ?                   00:00:00            sleep 1
[root~]# docker container logs unruffled_darwin
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
hello world
[root~]#
</pre>
