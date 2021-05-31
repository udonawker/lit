## [ansible-docをつかってコンソールからmoduleの詳細を確認する](https://www.kabegiwablog.com/entry/2018/03/01/090000)

copyについて調べてる<br>
```
$ ansible-doc copy
> COPY    (/usr/lib/python2.7/site-packages/ansible/modules/files/copy.py)

        The `copy' module copies a file from the local or remote machine to a location on the remote machine. Use the [fetch] module to copy
        files from remote locations to the local box. If you need variable interpolation in copied files, use the [template] module. For Windows
        targets, use the [win_copy] module instead.

  * note: This module has a corresponding action plugin.

OPTIONS (= is mandatory):

- attributes
        Attributes the file or directory should have. To get supported flags look at the man page for `chattr' on the target system. This string
        should contain the attributes in the same order as the one displayed by `lsattr'.
        (Aliases: attr)[Default: None]
        version_added: 2.3

- backup
        Create a backup file including the timestamp information so you can get the original file back if you somehow clobbered it incorrectly.
        [Default: no]
        type: bool
        version_added: 0.7

- content
        When used instead of `src', sets the contents of a file directly to the specified value. For anything advanced or with formatting also
        look at the template module.
        [Default: (null)]
        version_added: 1.1
~~~省略~~~
```
