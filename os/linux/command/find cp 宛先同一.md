<pre>
$ ls -1 | grep XXX | xargs -I{} cp "{}" ./Destination
$ fine . -type f -name "*XXX*" | xargs -I{} cp "{}" ../Destination
</pre>
