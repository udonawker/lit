<pre>
[root]# docker container stats --no-stream=true $(docker container ls --format={{.Names}})
CONTAINER                     CPU %               MEM USAGE / LIMIT       MEM %               NET I/O             BLOCK I/O           PIDS
container1                    2.79%               5.902 MiB / 125.4 GiB   0.00%               0 B / 0 B           34.2 MB / 0 B       11
container2                    3.06%               30.23 MiB / 125.4 GiB   0.02%               0 B / 0 B           24.5 MB / 0 B       60
container3                    3.13%               28.2 MiB / 125.4 GiB    0.02%               0 B / 0 B           24.5 MB / 0 B       61
...
</pre>
