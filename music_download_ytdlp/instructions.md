# Download playlist videos

If you want to download all videos in the public youtube playlist as mp3 then paste the following code into the terminal by replacing the `playlist_link` with your link: 

```bash
yt-dlp -x --audio-format mp3 --audio-quality 0 -o "%(playlist_index)s - %(title)s.%(ext)s" "playlist_link"
```

example: 

```bash
yt-dlp -x --audio-format mp3 --audio-quality 0 -o "%(playlist_index)s - %(title)s.%(ext)s" "https://youtube.com/playlist?list=PLtFyYgqZRI7N5s0k05uwC8B9eIc6D-vsL"
```

# Download single videos

If you want to download single video as an mp3 file then use the following code: 

```bash
yt-dlp -x --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s" "video_link"
```

example: 

```bash
yt-dlp -x --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s" "https://youtu.be/Gda677ZkZzg"
```

