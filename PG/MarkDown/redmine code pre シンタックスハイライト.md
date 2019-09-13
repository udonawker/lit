引用<br/>
[Redmineのシンタックスハイライトの対応形式](http://blog.redmine.jp/articles/syntax-hilight/)<br/>

## シンタックスハイライトの利用方法

以下の例のように、ソースコードをcodeタグで囲み、さらにcodeタグの外側をpreタグで囲みます。<br/>
codeタグのclass属性はシンタックスハイライト対象のコードの種類を示します。<br/>
例では、C言語を指定しています。<br/>

<pre>
&lt;pre&gt;&lt;code class="c"&gt;
#include &lt;stdio.h&gt;
 
int main(void) {
    printf("Hello, World!\n");
 
    return 0;
}
&lt;/code>&lt;/pre&gt;
</pre>

## 対応形式とclass属性の値

|形式|class属性に指定する値|
|---|---|
|C|c, h|
|C++|cpp, cplusplus|
|Clojure|clj|
|CSS|css|
|Delphi|delphi, pascal|
|diff|diff|
|ERB|erb, rhtml, eruby|
|Groovy|groovy|
|HAML|haml|
|HTML|html, xhtml|
|Java|java|
|Javascript|java_script, ecma, ecmascript, ecma_script, javascript, js|
|JSON|json|
|PHP|php|
|plain text|plaintext, plain|
|Python|python|
|RHTML|rhtml|
|Ruby|ruby, irb|
|SQL|sql|
|XML|xml|
|YAML|yaml, yml|

※Redmine同梱のCodeRayのソースコードの一部 (vendor/plugins/coderay-0.9.2/lib/coderay/scanners/ 以下)を参照して作成。<br/>

## シンタックスハイライトの実行例

以下はC, CSS, diff, SQLに対してシンタックスハイライトを行った例です。<br/>

![シンタックスハイライトの実行例](http://blog.redmine.jp/assets/2010/10/18/syntax-highlight.png)
