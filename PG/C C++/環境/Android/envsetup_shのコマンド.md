[ソースを追うのに便利なenvsetup.shのコマンド](http://blog.hermit4.info/2010/08/envsetupsh.html)<br/>

**help**<br/>
helpを表示する(一部のコマンドのみ)<br/>
**get_abs_build_var**<br/>
Get the value of a build variable as an absolute path.<br/>
**get_build_var**<br/>
Get the exact value of a build variable.<br/>
**check_product**<br/>
**check to see if the supplied product is one we can build**<br/>
**check_variant**<br/>
**check to see if the supplied variant is valid**<br/>
**setpaths**<br/>
**printconfig**<br/>
**set_stuff_for_environment**<br/>
**set_sequence_number**<br/>
**settitle**<br/>
**choosesim**<br/>
**choosetype**<br/>
**chooseproduct**<br/>
**choosevariant**<br/>
**choosecombo**<br/>
**add_lunch_combo**<br/>
**print_lunch_menu**<br/>
**lunch**<br/>
**tapas**<br/>
Configures the build to build unbundled apps.Run tapas with one ore more app names (from LOCAL_PACKAGE_NAME)<br/>
**gettop**<br/>
topディレクトリを表示する<br/>
**m**<br/>
プロジェクトのトップディレクトリでmakeを行う。<br/>
**findmakefile**<br/>
現在のディレクトリを上に遡りながら、Android.mkファイルを見つける<br/>
**mm**<br/>
現在のディレクトリのAndroid.mk内のモジュールをトップディレクトリからmakeする<br/>
**mmm dirname**<br/>
dirnameで指定したディレクトリのAndroid.mk内のモジュールをトップディレクトリからmakeする<br/>
**croot**<br/>
トップディレクトリに移動する<br/>
**cproj**<br/>
ディレクトリを上に遡りAndroid.mkのあるディレクトリに移動する<br/>
**pid program**<br/>
adb接続した先のprogramのPIDを取得する<br/>
**systemstack**<br/>
systemstack - dump the current stack trace of all threads in the system process to the usual ANR traces file<br/>
**gdbclient [EXE] [PORT] [PROG]**<br/>
arm-eabi-gdbを起動し、各種シンボルを読み込んでgdbserverへ接続する<br/>
**sgrep PATTERN**<br/>
.*\.(c|h|cpp|S|java|xml|sh|mk)に対してPATTERNでgrepをかける<br/>
**jgrep PATTERN**<br/>
.*\.javaに対してPATTERNでgrepをかける<br/>
**cgrep PATTERN**<br/>
.*\.cに対してPATTERNでgrepをかける<br/>
**resgrep PATTERN**<br/>
*\.xmlに対してPATTERNでgrepをかける<br/>
**mgrep PATTERN**<br/>
.*/(Makefile|Makefile\..*|.*\.make|.*\.mak|.*\.mk)に対してPATTERNでgrepをかける<br/>
**treegrep PATTERN**<br/>
.*\.(c|h|cpp|S|java|xml)に対して、grep -iをかける<br/>
**getprebuilt**<br/>
ANDROID_PREBUILTS変数の値を取得する<br/>
**tracedmdump tracename**<br/>
tracenameのdmtraceを実行する<br/>
**runhat [ -d | -e | -s serial ] target-pid [output-file]**<br/>
communicate with a running device or emulator, set up necessary state,and run the hat command.<br/>
**getbugreports**<br/>
/sdcard/bugreportsのバグレポートファイルを取得する<br/>
**startviewserver**<br/>
**stopviewserver**<br/>
**isviewserverstarted**<br/>
**smoketest**<br/>
SmokeTestApp.apk SmokeTest.apkを再インストールし実行する？<br/>
**runtest args**<br/>
argsを引数として/development/testrunner/runtest.pyを実行する<br/>
**godir regexp**<br/>
PATTERNにマッチするディレクトリのリストを表示し、選択されたディレクトリに移動する<br/>
**set_java_home**<br/>
JAVA_HOME環境変数がない場合に固定値を設定する<br/>
