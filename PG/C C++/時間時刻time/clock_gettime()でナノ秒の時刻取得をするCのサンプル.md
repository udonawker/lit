[Linuxのclock_gettime（）でナノ秒の時刻取得をするCのサンプル](http://nopipi.hatenablog.com/entry/2017/10/28/204748)<br/>
[時間情報の取得方法と扱い方](https://www.mm2d.net/main/prog/c/time-01.html)<br/>

<pre>
	struct timespec ts;
	struct tm tm;
	// 時刻の取得
	clock_gettime(CLOCK_REALTIME, &ts);  //時刻の取得
	localtime_r( &ts.tv_sec, &tm);       //取得時刻をローカル時間に変換
	// 出力
	printf("tv_sec=%ld  tv_nsec=%ld\n",ts.tv_sec,ts.tv_nsec);
	printf("%d/%02d/%02d %02d:%02d:%02d.%09ld\n",
		tm.tm_year+1900,
		tm.tm_mon+1,
		tm.tm_mday,
		tm.tm_hour,
		tm.tm_min,
		tm.tm_sec,
		ts.tv_nsec);
	return(0);
</pre>
