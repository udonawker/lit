## [LinuC 2.04.1makeによるソースコードからのビルドとインストール](https://linuc.org/study/samples/2649/?hm_ct=3eb824ddc0011d34ef2a9dee409b1391&hm_cv=3f25211b47622df5e60f618ed4840d13&hm_cs=3405646265fcc645dc30868.60445446&hm_mid=m9t4t)

```
[root@f73f4487175b ~]# git clone https://github.com/taro/katacoda・・・・git cloneコマンドによるデータ取得
Cloning into 'katacoda'...
remote: Enumerating objects: 161, done.
remote: Counting objects: 100% (161/161), done.
remote: Compressing objects: 100% (105/105), done.
remote: Total 161 (delta 58), reused 142 (delta 39), pack-reused 0
Receiving objects: 100% (161/161), 16.68 KiB | 0 bytes/s, done.
Resolving deltas: 100% (58/58), done.
[root@f73f4487175b ~]# ls
katacoda
[root@f73f4487175b ~]# cd katacoda/

[root@f73f4487175b katacoda]# git pull・・・・git pullコマンドによる差分データ取得
remote: Enumerating objects: 9, done.
remote: Counting objects: 100% (9/9), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 5 (delta 3), reused 5 (delta 3), pack-reused 0
Unpacking objects: 100% (5/5), done.
From https://github.com/taro/katacoda
   9949c6e..2ef0b3e  master     -> origin/master
Updating 9949c6e..2ef0b3e
Fast-forward
 Courses/nginx_web/intro.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

[root@f73f4487175b katacoda]# git branch -a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/master
[root@f73f4487175b katacoda]# git branch add_func_a・・・・git branchコマンドによるブランチ追加
[root@f73f4487175b katacoda]# git branch -a・・・・git branchコマンドによるブランチ一覧表示
  add_func_a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/master

[root@f73f4487175b katacoda]# git checkout add_func_a・・・・git checkoutコマンドによるブランチ切替
Switched to branch 'add_func_a'
[root@f73f4487175b katacoda]# git branch -a
* add_func_a
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/master

[root@f73f4487175b katacoda]# git log・・・・git logコマンドによる更新履歴確認
commit 2ef0b3eac85e461b76b733d69bf643ba6bc02264
Author: taro <taro@gmail.com>
Date:   Sun Apr 4 20:48:53 2021 +0900

    version1.0.0 release

[root@f73f4487175b katacoda]# git config --global user.email taro@gmail.com・・・・git configコマンドによるgit設定追加
[root@f73f4487175b katacoda]# git config --global user.name taro

[root@f73f4487175b katacoda]# git tag -a v1.0.0 2ef0b3eac85e461b76b733d69bf643ba6bc02264・・・・git tagコマンドによるタグ追加
[root@f73f4487175b katacoda]# git tag・・・・git tagコマンドによるタグ一覧表示
v1.0.0
v0.9
v0.8
v0.7
[root@f73f4487175b katacoda]# git tag -l
v1.0.0
v0.9
v0.8
v0.7
[root@f73f4487175b katacoda]# git tag -l v0*・・・・git tagコマンドによるフィルターをかけたタグ一覧表示
v0.9
v0.8
v0.7
[root@f73f4487175b katacoda]# git show v1.0.0・・・・git showコマンドによるタグ内容の詳細確認
tag v1.0.0
Tagger: taro <taro@gmail.com>
Date:   Sun Apr 4 12:00:10 2021 +0000

Version 1.0.0 release

commit 2ef0b3eac85e461b76b733d69bf643ba6bc02264
Author: taro <taro@gmail.com>
Date:   Sun Apr 4 20:48:53 2021 +0900

    version1.0.0 release

diff --git a/Courses/nginx/intro.md b/Courses/nginx/intro.md
index ad226ec..6865cf7 100644
--- a/Courses/nginx/intro.md
+++ b/Courses/nginx/intro.md
@@ -1,3 +1,3 @@
-USER=jiro  
+USER=taro  
```
