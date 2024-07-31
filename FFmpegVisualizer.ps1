$file="03 音轨03.wav"
$durationMatch=ffmpeg -i "$file" 2>&1 | Select-String "Duration: (.+)," | Select-Object -First 1
$totalTime=$durationMatch.Matches.Groups[1].Value -Replace ":", "\:"
ffmpeg -i "$file" -filter_complex "[0:a]showwaves=s=1920x1080:mode=line:split_channels=1:colors=white[vis];[vis]drawtext=fontfile=C\\:/Windows/fonts/msyh.ttc:text='$file':x=10:y=10:box=1:boxborderw=2:fontsize=24[temp1];[temp1]drawtext=fontfile=C\\:/Windows/fonts/consola.ttf:text='%{pts\:hms} / $totalTime\ ':x=w-tw-10:y=10:box=1:boxborderw=2:fontsize=24[out]"-map "[out]" -map 0:a -c:v h264_nvenc -preset:v p7 -tune:v hq -rc:v vbr -cq:v 19 -b:v 0 -profile:v high -c:a copy -y "$file.mov"
