[Gitで特定ファイルの変更履歴をみる](http://shuzo-kino.hateblo.jp/entry/2014/05/22/222251)<br>

ファイル<br>

<pre>
$ git log -p app/view/hoge/show.html.erb
</pre>
<pre>
commit xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Author: shuzo_kino <xxxxxx@gmail.com>
Date:   Mon Mar 31 10:53:56 2014 +0900

    コメント

diff --git a/app/views/hoge/show.html.erb b/app/views/hoge/show.html.erb
index 6fabd25..7e29303 100644
--- a/app/views/hoge/show.html.erb
+++ a/app/views/hoge/show.html.erb
 <p id="notice"></p>
-<%= link_to '一覧に戻る', hoges_path, class: "btn btn-large btn-primary"  %>
+<%= link_to_function "戻る", "history.back()", class: "btn btn-large btn-primary"  %>
 <% if user_signed_in? %>
   |   
 <%= link_to '編集', edit_hoge_path(@hoge), class: "btn"  %>
:
:
</pre>

ディレクトリ単位<br>

<pre>
$  git log -p app/views/hoges
</pre>
