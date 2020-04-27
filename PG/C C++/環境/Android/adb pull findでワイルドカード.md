<pre>
$ adb shell find . -type f -name *.txt | xargs -n 1 adb pull
$ adb shell find /sdcard/DCIM -type f -iname "*.jpg" | xargs -I{} -n 1 adb pull {} ./JPG
</pre>
