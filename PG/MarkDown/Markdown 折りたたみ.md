引用<br/>
[markdownの「折りたたみ」の機能](https://masalib.hatenablog.com/entry/2018/07/19/193000 "https://masalib.hatenablog.com/entry/2018/07/19/193000")<br/>

## イントロ
イントロ

## 折りたたみのmarkdownの例
<pre>
&lt;details&gt;&lt;summary&gt;クリックすると展開されます&lt;/summary&gt;
&lt;pre&gt;
const puppeteer = require('puppeteer');
puppeteer.launch().then(async browser => {
  const page = await browser.newPage();
  await page.setViewport({ width: 1280, height: 800 })
  await page.goto('https://www.aymen-loukil.com');
  await browser.close();
});
&lt;/pre&gt;
&lt;/details&gt;
</pre>

## 折りたたみの例
<details><summary>クリックすると展開されます</summary>
<pre>
const puppeteer = require('puppeteer');
puppeteer.launch().then(async browser => {
  const page = await browser.newPage();
  await page.setViewport({ width: 1280, height: 800 })
  await page.goto('https://www.aymen-loukil.com');
  await browser.close();
});
</pre>
</details>

## 折りたたみの例2
<pre>
&lt;details&gt;&lt;summary&gt;目次（クリックすると展開されます）&lt;/summary&gt;

[contents](#contents)

&lt;/details&gt;
</pre>
<br/>
<br/>

実例<br/>
<details><summary>目次（クリックすると展開されます）</summary>

[イントロ](#イントロ)<br/>
[折りたたみのmarkdownの例](#折りたたみのmarkdownの例)<br/>
[折りたたみの例](#折りたたみの例)<br/>
[折りたたみの例2](#折りたたみの例2)<br/>

</details>
