<pre>
[root tmp]# cat temp.sh
#!/bin/bash

DATE='date +"%Y%m%d%H%M%S"'

echo ${DATE}
eval ${DATE}

[root tmp]# bash temp.sh
date +"%Y%m%d%H%M%S"
20190527150019
[root tmp]#
</pre>
