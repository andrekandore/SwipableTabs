ffmpeg -y -ss 0 -t 43 -i TabSwipeDemo.mp4 -vf fps=60,scale=480:-1:flags=lanczos,palettegen TabSwipeDemo.png
ffmpeg -ss 0 -t 43 -i TabSwipeDemo.mp4 -i TabSwipeDemo.png -filter_complex "fps=12,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" TabSwipeDemo.gif 

ffmpeg -y -ss 0 -t 43 -i TabBar.mp4 -vf fps=60,scale=1314:-1:flags=lanczos,palettegen TabBar.png
ffmpeg -ss 0 -t 43 -i TabBar.mp4 -i TabBar.png -filter_complex "fps=24,scale=1024:-1:flags=lanczos[x];[x][1:v]paletteuse" TabBar.gif 