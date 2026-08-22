# Introduction

In linux terminal, you can fastly download all type of files using wget, curl, aria2 and yt-dlp. I will tell the differences between these tools at the end, but let's now start with instructions.


# WGET 

Basic installation command: 

```bash
wget https://example.com/somefile.zip
```

**Stable & Resilient** method. This does not break the installation even when the internet goes out. It continues from where it is left when the internet reconnects.

```bash
wget -c --retry-connrefused --tries=inf --waitretry=5 https://example.com/bigfile.iso
```

In the above command: 
    - `-c`: corresponds to *continue*. If the internet is disconnected at 40%, it will start from here when connection is set up again.
    - `--retry-connrefused`: keeps trying to connecting
    - `--tries=inf`: tries to connect by infinite times. By default it is 20. 
    - `--waitretry=5`: sets waiting time to 5 seconds between retries in order to net get spammed and blocked by server.

    
If the file name or url name is messy, you can save the file with the custom name: 

```bash
wget -O my_custom_name.zip https://example.com/messy-url-string.zip
```


In order to download a list of links, you can use the following command: 

```bash
wget -i links.txt
```


# CURL

Pasting the `curl https://example.com/file.txt` will print the contents of the file into the terminal instead of saving it. So, add `-O` before the link to save it: 

```bash
curl -O https://example.com/somefile.zip
```

If you want to save the file with custom name, use the following: 

```bash
curl -o my_custom_name.zip https://example.com/somefile.zip
```

**Stable & Bulletproof** method. Suitable for unstable connections: 

```bash
curl -C - -O --retry 999 --retry-all-errors https://example.com/bigfile.iso
```

Many download links don't point directly to the file; they redirect you to a content delivery server. `wget` command automatically handles these, but `curl` requires extra paramater `-L` (Location): 

```bash 
curl -L -O https://example.com/redirect-link.zip
```

As default `curl` logs all steps into the terminal. If you want silence installation then use the following:

```bash
curl -s -# -O https://example.com/somefile.zip
```

- `-s`: silence
- `-#`: progress bar


If you want to see how large the file is then use the following:

```bash
curl -I https://example.com/massive_dataset.csv
```

- `I`: Head



# ARIA2 

`aria2` is the fastest way to download the files: 

```bash
aria2c -x 16 -s 16 https://example.com/massive_dataset.csv
```

- `-x 16`: opens 16 connections to the server. 
- `-s 16`: splits the file into 16 segments.


Most stable, resiliend and fastest method: 

```bash
aria2c -c -x 16 -s 16 --max-tries=0 --retry-wait=5 https://example.com/massive_dataset.csv
```

- `-c`: continue. if the terminal is closed or internet is disconnected, it will start from where it is left after the connection is set up again.
- `max-tries`: sets the number of retries to infinite.
- `--retry-wait=5`: 5 seconds between each retry to not blocked or spammed.


Download with custom name: 

```bash
aria2c -c -x 16 -s 16 --max-tries=0 --retry-wait=5 -o my_clean_data.csv https://example.com/messy-url-string.csv
```

Downloading from the text file of links:

```bash
aria2c -i links.txt
```

- `i`: input

or you can use:

```bash
aria2 -i -x 16 -s 16 links.txt
```


Download the links from the TXT file with custom name. You should design the TXT file with the following format: 

```txt
https://example.com/file1.zip
  out=my_custom_name.zip
https://example.com/movie.mp4
  out=vacation_video.mp4
```

Make sure that there is a space or TAB before each `out` paramater. Otherwise, it will throw error. After setting the links, run the following command: 

```bash 
aria2c -i batch.txt -c -x 16 -s 16
```

- `batch.txt`: TXT file name. you can give any.



# YT-DLP & FFMPEG

By default, yt-dlp standard downloads (`yt-dlp "youtube_link"`) saves the videos with the best possible quality but in mkv format. If you want to save it as mp4 format use the following command: 

```bash
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 "youtube_link"
```

Download a single video as mp3 file with the following command: 

```bash
yt-dlp -x --audio-format mp3 --audio-quality 0 "https://youtube.com/watch?v=YOUR_LINK"
```

- `-x`: extraction.
- `--audio-format mp3`: defines audio format.
-  `--audio-quality 0`: best possible mp3 quality.


Download playlist videos: 

```bash 
yt-dlp -o "%(playlist_index)s - %(title)s.%(ext)s" "https://youtube.com/playlist?list=YOUR_LINK"
```

- `-o "%(playlist_index)s - %(title)s.%(ext)s"`: clean names for each video.


Download playlist videos as mp3 files: 

```bash
yt-dlp -x --audio-format mp3 --audio-quality 0 -o "%(playlist_index)s - %(title)s.%(ext)s" "https://youtube.com/playlist?list=YOUR_LINK"
```


Download from a TXT file of links: 

```bash
yt-dlp -a links.txt
```


Download from a TXT file of links with custom name:

1. Firstly, prepare the links in your txt file as:

```text
first_video.mp4:  video_link1
second_video.mp4: video_link2
```

2. Then run the following fish script loop to download the links as videos:

```bash
while read -l line
    set name (echo $line | awk -F ': ' '{print $1}')
    set url (echo $line | awk -F ': ' '{print $2}')
    yt-dlp -o "$name" "$url"
end < links.txt
```

3. Or, run the following script to download the links as mp3: 

```bash
while read -l line
    set name (echo $line | awk -F ': ' '{print $1}')
    set url (echo $line | awk -F ': ' '{print $2}')
    yt-dlp -x --audio-format mp3 --audio-quality 0 -o "$name" "$url"
end < links.txt
```

- File name is considered as `links.txt`. You can give any. 
- Try to not leave empty line at the end of txt file. 


You can download the specified section (trim) of the YouTube videos with the following command: 

```bash
yt-dlp --download-sections "*01:15:00-01:20:00" "https://youtube.com/watch?v=YOUR_LINK"
```

or as mp3: 

```bash
yt-dlp --download-sections "*00:12:30-00:16:45" -x --audio-format mp3 --audio-quality 0 "https://youtube.com/watch?v=YOUR_LINK"
```


Additionally, you can download the videos with their subttiles: 

```bash
yt-dlp --write-subs --sub-langs en,tr "https://youtube.com/watch?v=YOUR_LINK"
```

- `--write-subs`: Downloads the official subtitles.

- `--sub-langs en,tr`: Specifies the languages (e.g., English and Turkish). If you want auto-generated subs, use `--write-auto-subs` instead.









    
    
    
    
    
































