引用[PHPでロギング](https://www.hiro345.net/blogs/hiro345/archives/5507.html "PHPでロギング")

<pre>
PHPでロギングをするにはいくつか方法があります。

PHPで提供されているものに、error_log() があります。これを使う例は次のようになります。「error」という文字列を出力するだけの単純なものです。error_log.php として保存します。

<?php
error_log("error");
?>
動作確認をするには、コマンドラインで実行します。

$ php -f error_log.php
error
Webブラウザでアクセスしたときは、Apacheのエラーログ（CentOSでは/var/log/httpd/error_log）に出力されます。どこに出力されるかはphp.ini（CentOSでは /etc/php.ini）の設定にもよります。

どの処理が実行されたかよりも、変数の値がどうなっているのかを知りたい場合は、var_dump()を使います。このファイルをvar_dump.phpとして保存します。

<?php
$s = 'Hello';
var_dump($s);
?>
「php -f var_dump.php」のようにコマンドラインから実行したり、var_dump.php へWebブラウザからアクセスしたりすると、次のような結果になります。

string(5) "Hello" 
Apache Log4phpを使うという方法もあります。インストールは簡単です。

apache-log4php-2.0.0-incubating-src.tar.gz をダウンロード
展開（ tar xzf apache-log4php-2.0.0-incubating-src.tar.gz ）
「apache-log4php-2.0.0-incubating/src/main/php」を「log4php」という名前で配備
ここでは、次のようにしました。

+- log4php/
+- simple/
   +- simple.php
simple/simple.php は次のようにしました。log4phpのLogger.phpを使うようにしています。

<?php
require_once('../log4php/Logger.php');
echo "Hello PHP\n";
$logger = Logger::getLogger('main');
$logger->info("log4php info");
$logger->warn("log4php warn");

echo "Logger done\n";
?>

これを「php -f simple.php」のようにコマンドラインで実行すると、次のようになります。

Hello PHP
Sat Oct 16 10:50:20 2010,607 [24562] INFO main - log4php info
Sat Oct 16 10:50:20 2010,611 [24562] WARN main - log4php warn
Logger done
Webブラウザへ表示するためには、LoggerAppenderEchoを使います。次のような構成でファイルを用意してみます。

+- log4php
+- sample.log4php
  +- SampleLogger.class.php
  +- log4php.properties
設定ファイルlog4php.propertiesは次の通りです。appenderのdefaultとして、LoggerAppenderEchoを指定します。

log4php.appender.default = LoggerAppenderEcho
log4php.appender.default.layout = LoggerLayoutSimple
log4php.rootLogger = DEBUG, default
この設定ファイルを取り込むサンプルプログラムSampleLogger.class.phpは次のようになります。

<?php
require_once('../log4php/Logger.php');
Logger::configure('./log4php.properties');
class SampleLogger {
   private $logger;
   public function __construct() {
       $this->logger = Logger::getLogger('main');
       $this->logger->debug('log4php debug');
       echo "\n<br />SampleLogger constructed";
   }
}

echo "\n<br />SampleLogger begin\n";
$logger = Logger::getLogger('main');
$logger->info('log4php info');
$sample_logger = new SampleLogger();
echo "\n<br />SampleLogger end\n";
?>

sample.log4phpをカレントディレクトリとして「php -f SampleLogger.class.php」とすると次のような結果になります。WebブラウザからSampleLogger.class.phpを開いても同様な結果となります（ソースを開いて中身が同じことを確認できます）。

<br />SampleLogger begin
INFO - log4php info
DEBUG - log4php debug
<br />SampleLogger constructed
<br />SampleLogger end

Apache HTTP Serverのエラーログを見たりするよりは、Apache log4phpのLoggerAppenderEcho、LoggerAppenderFile、LoggerAppenderDailyFileあたりを使った方がよい場面もあるでしょう。appenderについては、「log4php – Apache log4php Appenders」にヘルプがあります。適材適所で採用を決めたいところです。

ちなみに、log4phpがうまく動作しない場合は、error_log()やvar_dump()を使って原因を突き止めましょう。
</pre>
