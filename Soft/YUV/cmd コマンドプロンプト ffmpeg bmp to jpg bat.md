<pre>
&gt; ffmpeg.exe -i "xxx.bmp" "xxx.jpg"
</pre>

<pre>
@echo off
md "%~dp0\output"

setlocal enabledelayedexpansion
set x=%*
for %%f in (!x!) do (
echo ■処理ファイル「%%~f」
"ffmpeg.exeのファイルパス" -i %%f "%~dp0\output\%%~nf.jpg"
echo 完了しました。
echo.
)
endlocal

echo ★終了します。
pause
goto :EOF
</pre>

<pre>
@echo off
md "%~dp0\output"

setlocal enabledelayedexpansion
set x=%*
for %%f in (!x!) do (
echo ■処理ファイル「%%~f」
ren "%%~nxf" "file%%~xf"
"ffmpeg.exeのファイルパス" -i "file%%~xf" "%~dp0\output\%%~nf.jpg"
ren "file%%~xf" "%%~nxf"
echo 完了しました。
echo.
)
endlocal

echo ★終了します。
pause
goto :EOF
</pre>
