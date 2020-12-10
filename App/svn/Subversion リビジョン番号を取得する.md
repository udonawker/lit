## [Subversion リビジョン番号を取得する](https://kazunori-toybox.com/blog/dev/svn-info/)

<pre>
$ svn info
Path: .
Working Copy Root Path: D:\svn\test
URL: file:///D:/svn/repository/trunk
Relative URL: ^/trunk
Repository Root: file:///D:/svn/repository
Repository UUID: 5f7ae1be-0772-2147-8033-dd1a53259067
Revision: 1
Node Kind: directory
Schedule: normal
Last Changed Author: kazu
Last Changed Rev: 1
Last Changed Date: 2020-02-23 22:44:02 +0900 (日, 23 2 2020)
</pre>

--show-item オプション( Ver.1.9 ～ )<br>
<pre>
$ svn info --show-item revision
1
</pre>

