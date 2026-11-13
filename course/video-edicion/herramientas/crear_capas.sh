#!/bin/bash
# Genera las capas fijas del curso (antes eran comandos sueltos):
#  - parches de privacidad por aplicación (PNG con alfa -> video qtrle 60 fps de 20 min)
#  - capa del logo (original, SIN recolorear, SIN halo ni sombra) arriba a la derecha
#  - cortinilla de 4 s sintetizada (sin derechos de terceros)
#  - tarjeta de 3 s para clips de YouTube
# Ajustar por curso: rectángulos de PATCH_* (medidos en fotogramas del crudo) y colores de fondo.
set -euo pipefail
B=~/Movies/Capdesis-Curso-Vim
O=$B/04-davinci/overlays; T=$B/04-davinci/titulos; mkdir -p "$O" "$T"
LOGO_SRC=~/Documents/Apps/capdesis-academy/web/public/images/logo/capdesis_logo.png
cp -n "$LOGO_SRC" "$O/capdesis_logo_original.png" || true
BASE="color=c=black@0.0:s=1920x1080:d=0.04,format=rgba"
# drawbox SOLO escribe alfa con replace=1
ffmpeg -v error -y -f lavfi -i "$BASE" -vf "drawbox=x=548:y=2:w=900:h=27:color=0x323433@1:t=fill:replace=1,drawbox=x=168:y=78:w=145:h=23:color=0x313433@1:t=fill:replace=1" -frames:v 1 -update 1 "$O/privacidad-androidstudio.png"
ffmpeg -v error -y -f lavfi -i "$BASE" -vf "drawbox=x=326:y=888:w=290:h=28:color=0x282B33@1:t=fill:replace=1" -frames:v 1 -update 1 "$O/privacidad-vscode.png"
ffmpeg -v error -y -f lavfi -i "$BASE" -vf "drawbox=x=0:y=66:w=1920:h=27:color=0x020202@1:t=fill:replace=1,drawbox=x=1700:y=36:w=180:h=26:color=0x020202@1:t=fill:replace=1" -frames:v 1 -update 1 "$O/privacidad-navegador.png"
ffmpeg -v error -y -i "$O/capdesis_logo_original.png" -vf "scale=120:120:flags=lanczos,format=rgba" -frames:v 1 -update 1 "$O/logo-capdesis-120.png"
ffmpeg -v error -y -f lavfi -i "$BASE" -i "$O/logo-capdesis-120.png" -filter_complex "[0:v][1:v]overlay=x=1920-120-16:y=8:format=auto,format=rgba" -frames:v 1 -update 1 "$O/logo-capa.png"
# capas largas como video con alfa (los Still se colocan a 24 fps y no cuadran a 60 fps)
for n in privacidad-androidstudio privacidad-vscode privacidad-navegador; do
  ffmpeg -v error -y -loop 1 -framerate 60 -i "$O/$n.png" -t 1200 -c:v qtrle -pix_fmt argb "$O/$n.mov"
done
ffmpeg -v error -y -loop 1 -framerate 60 -i "$O/logo-capa.png" -t 1200 -c:v qtrle -pix_fmt argb "$O/logo-capdesis.mov"
# cortinilla: acorde suave + arpegio, -24 LUFS (queda por debajo de la voz tras normalizar)
ffmpeg -v error -y -f lavfi -i "aevalsrc='0.06*(sin(2*PI*261.63*t)+sin(2*PI*329.63*t)+sin(2*PI*392.00*t)+0.7*sin(2*PI*493.88*t)+0.5*sin(2*PI*587.33*t))*min(1,t/0.8)*min(1,(4-t)/1.2)*(1+0.15*sin(2*PI*0.5*t))|0.06*(sin(2*PI*261.63*t+0.3)+sin(2*PI*329.63*t+0.2)+sin(2*PI*392.00*t+0.1)+0.7*sin(2*PI*493.88*t+0.4)+0.5*sin(2*PI*587.33*t))*min(1,t/0.8)*min(1,(4-t)/1.2)*(1+0.15*cos(2*PI*0.5*t))':s=48000:d=4" \
  -f lavfi -i "aevalsrc='0.18*sin(2*PI*if(lt(mod(t,2),0.25),523.25,if(lt(mod(t,2),0.5),659.25,if(lt(mod(t,2),0.75),783.99,1046.5)))*t)*exp(-6*mod(t,0.25))*lt(mod(t,2),1)*min(1,(4-t)/1.0)':s=48000:d=4" \
  -filter_complex "[1:a]pan=stereo|c0=c0|c1=c0,aecho=0.6:0.5:120:0.3[arp];[0:a][arp]amix=inputs=2:normalize=0,lowpass=f=6000,aformat=sample_fmts=s32:channel_layouts=stereo,loudnorm=I=-24:TP=-6:LRA=7,afade=t=out:st=3.4:d=0.6" \
  -t 4 -ar 48000 -c:a pcm_s24le "$T/musica-cortinilla-4s.wav"
# tarjeta de 3 s para clips (necesita t-cierre1/2.png de generar_titulos.sh y el fondo generado con Codex)
if [ -f "$T/t-cierre1.png" ] && [ -f "$T/generadas/fondo-tarjeta.png" ]; then
  ffmpeg -v error -y -loop 1 -framerate 60 -t 3 -i "$T/generadas/fondo-tarjeta.png" -loop 1 -t 3 -i "$O/capdesis_logo_original.png" -loop 1 -t 3 -i "$T/t-cierre1.png" -loop 1 -t 3 -i "$T/t-cierre2.png" \
    -filter_complex "[1:v]scale=300:300:flags=lanczos,fps=60,format=rgba,fade=t=in:st=0:d=0.3:alpha=1[l];[2:v]fps=60,format=rgba,fade=t=in:st=0.1:d=0.3:alpha=1[t1];[3:v]fps=60,format=rgba,fade=t=in:st=0.2:d=0.3:alpha=1[t2];[0:v]fps=60[bg];[bg][l]overlay=x=(W-w)/2:y=180:shortest=1[a];[a][t1]overlay=x=(W-w)/2:y=530:shortest=1[b];[b][t2]overlay=x=(W-w)/2:y=615:shortest=1,format=yuv420p[v]" \
    -map "[v]" -c:v libx264 -crf 16 -preset slow -r 60 -t 3 "$T/tarjeta-promo-3s.mp4"
fi
echo "capas listas"
