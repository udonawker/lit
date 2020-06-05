[Convert raw RGB32 file to JPEG or PNG using FFmpeg - c++](https://android.developreference.com/article/13361515/Convert+raw+RGB32+file+to+JPEG+or+PNG+using+FFmpeg)<br>

<pre>
ffmpeg -f rawvideo -pixel_format rgba -video_size 320x240 -i input.raw output.png
</pre>
Since there is no header specifying the assumed video parameters you must specify them, as shown above, in order to be able to decode the data correctly.<br>
See ffmpeg -pix_fmts for a list of supported input pixel formats which may help you choose the appropriate -pixel_format.<br>

[Faster Thumbnail/Image Extraction from Video using FFMPEG?](https://android.developreference.com/article/13361515/Convert+raw+RGB32+file+to+JPEG+or+PNG+using+FFmpeg)<br>

<pre>
ffmpeg -i inputfile.mp4 -r 1 -t 12 image-%d.jpeg
ffmpeg -i inputfile.mp4 -r 1 -an -t 12 -s 512x288 -vsync 1 -threads 4 image-%d.jpeg
</pre>


[How to write YUV 420 video frames from RGB data using OpenCV or other image processing library?](https://android.developreference.com/article/24879470/How+to+write+YUV+420+video+frames+from+RGB+data+using+OpenCV+or+other+image+processing+library%3f)<br>

<pre>
cat data.rgb | ffmpeg -f rawvideo -pix_fmt rgb8 -s WIDTHxHEIGHT -i pipe:0 output.mov
</pre>
