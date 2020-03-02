[vim対応する括弧内の文字列を削除する](https://sevenb.jp/wordpress/ura/2017/02/14/vim%E5%AF%BE%E5%BF%9C%E3%81%99%E3%82%8B%E6%8B%AC%E5%BC%A7%E5%86%85%E3%81%AE%E6%96%87%E5%AD%97%E5%88%97%E3%82%92%E5%89%8A%E9%99%A4%E3%81%99%E3%82%8B/)<br/>

di&lt;括弧終わり記号&gt;<br/>
例: (xxxx yyyy zzz)で括弧内を削除する<br/>
<pre>
di)
</pre>
結果<br/>
(xxxx yyyy zzz) → ()<br/>
<br/>
例:[xxx yyy zzz]で括弧内を削除する<br/>
<pre>
di]
</pre>
結果<br/>
[ xxx yyy zzz] → []<br/>

<br/>
おまけ: &lt;div&gt;xxx yyy zzz&lt;/div&gt;のタグ間文字列を削除する<br/>
<pre>
dit
</pre>
結果<br/>
&lt;div&gt;xxx yyy zzz&lt;/div&gt; → &lt;div&gt;&lt;/div&gt;
