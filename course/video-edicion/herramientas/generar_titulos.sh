#!/bin/bash
# Genera intro (4 s) y cierre (4 s) animados, 1920x1080 60 fps, ProRes 422 HQ, para cada parte.
# Logo con sus colores originales (no recolorear, sin halo ni sombra).
# Iconos: Android Studio y JetBrains salen de los .icns locales (uso nominativo); "Vim" e "IdeaVim" son etiquetas de texto. Texto con CoreText (texto_png.swift).
set -euo pipefail
B=~/Movies/Capdesis-Curso-Vim
H=$B/03-analisis/herramientas
T=$B/04-davinci/titulos; mkdir -p "$T"; cd "$T"
LOGO=$B/04-davinci/overlays/capdesis_logo_original.png
FONDO=$T/generadas/fondo-tarjeta.png   # generado con Codex (sin texto ni marcas de agua)
MUSICA=$T/musica-cortinilla-4s.wav    # sintetizada con ffmpeg: sin derechos de terceros
NAVY=303163; ORANGE=0xE0A64A; GRIS=6B6E8F
txt() { swift "$H/texto_png.swift" "$1" "$2" "$3" "$4" "$5" >/dev/null; }
txt "Curso de Vim" t-curso.png AvenirNext-Bold 110 $NAVY
txt "Capdesis Academy" t-academy.png AvenirNext-Medium 40 $GRIS
txt "Curso completo gratis en" t-cierre1.png AvenirNext-DemiBold 64 $NAVY
txt "academy.capdesis.com" t-cierre2.png AvenirNext-Bold 92 $NAVY
txt "Practica cada lección en la web" t-cierre3.png AvenirNext-Medium 44 $GRIS
HERRAMIENTAS=("Android Studio · VS Code" "VS Code · Android Studio" "Android Studio" "Android Studio" "Android Studio · navegador")
TITULOS=("Modos y movimientos" "Insertar, pegar y buscar" "Buscar caracteres y borrar" "Objetos de texto" "Ventanas y líneas")
ANIM="fps=60,format=rgba"
for i in 1 2 3 4 5; do
  txt "Parte $i · ${TITULOS[$((i-1))]}" t-p$i.png AvenirNext-DemiBold 58 $NAVY
  txt "Grabado en ${HERRAMIENTAS[$((i-1))]}" iconos/t-ides-$i.png AvenirNext-Medium 34 $GRIS
  ffmpeg -v error -y -loop 1 -framerate 60 -t 4 -i "$FONDO" \
    -loop 1 -t 4 -i "$LOGO" -loop 1 -t 4 -i t-curso.png -loop 1 -t 4 -i t-p$i.png -loop 1 -t 4 -i t-academy.png \
    -filter_complex "\
[1:v]scale=340:340:flags=lanczos,$ANIM,fade=t=in:st=0.15:d=0.6:alpha=1[l];\
[2:v]$ANIM,fade=t=in:st=0.45:d=0.6:alpha=1[t1];\
[3:v]$ANIM,fade=t=in:st=0.8:d=0.6:alpha=1[t2];\
[4:v]$ANIM,fade=t=in:st=1.1:d=0.6:alpha=1[t3];\
[0:v]scale=w='trunc(1920*(1+0.03*t/4)/2)*2':h='trunc(1080*(1+0.03*t/4)/2)*2':eval=frame,crop=1920:1080,fps=60[bg];\
[bg][l]overlay=x=250:y=370:shortest=1[a];\
[a][t1]overlay=x='650+max(0,40*(1-(t-0.45)/0.6))':y=385:shortest=1[b];\
[b][t2]overlay=x=654:y=545:shortest=1[c];\
[c]drawbox=x=660:y=650:w=140:h=8:color=$ORANGE:t=fill:enable='gte(t,0.8)'[d];\
[d][t3]overlay=x=654:y=675:shortest=1[e];\
[6:v]$ANIM,fade=t=in:st=1.4:d=0.5:alpha=1[c1];[7:v]$ANIM,fade=t=in:st=1.5:d=0.5:alpha=1[c2];\
[8:v]scale=76:76,$ANIM,fade=t=in:st=1.6:d=0.5:alpha=1[i1];[9:v]scale=76:76,$ANIM,fade=t=in:st=1.7:d=0.5:alpha=1[i2];\
[10:v]$ANIM,fade=t=in:st=1.8:d=0.5:alpha=1[t4];\
[e][c1]overlay=x=654:y=770:shortest=1[f];[f][c2]overlay=x=790:y=770:shortest=1[g];\
[g][i1]overlay=x=1011:y=770:shortest=1[h];[h][i2]overlay=x=1103:y=770:shortest=1[k];\
[k][t4]overlay=x=654:y=862:shortest=1,format=yuv422p10le[out]" \
    -i "$MUSICA" -loop 1 -t 4 -i "$T/iconos/chip-vim.png" -loop 1 -t 4 -i "$T/iconos/chip-ideavim.png" \
    -loop 1 -t 4 -i "$T/iconos/android-studio.png" -loop 1 -t 4 -i "$T/iconos/jetbrains.png" -loop 1 -t 4 -i "$T/iconos/t-ides-$i.png" \
    -map "[out]" -map 5:a -c:v prores_ks -profile:v 3 -r 60 -c:a pcm_s24le -t 4 intro-parte-$i.mov
done
ffmpeg -v error -y -loop 1 -framerate 60 -t 4 -i "$FONDO" \
  -loop 1 -t 4 -i "$LOGO" -loop 1 -t 4 -i t-cierre1.png -loop 1 -t 4 -i t-cierre2.png -loop 1 -t 4 -i t-cierre3.png \
  -filter_complex "\
[1:v]scale=300:300:flags=lanczos,$ANIM,fade=t=in:st=0.1:d=0.5:alpha=1[l];\
[2:v]$ANIM,fade=t=in:st=0.3:d=0.5:alpha=1[t1];\
[3:v]$ANIM,fade=t=in:st=0.55:d=0.5:alpha=1[t2];\
[4:v]$ANIM,fade=t=in:st=0.9:d=0.5:alpha=1[t3];\
[0:v]scale=w='trunc(1920*(1+0.03*t/4)/2)*2':h='trunc(1080*(1+0.03*t/4)/2)*2':eval=frame,crop=1920:1080,fps=60[bg];\
[bg][l]overlay=x=(W-w)/2:y=150:shortest=1[a];\
[a][t1]overlay=x=(W-w)/2:y=500:shortest=1[b];\
[b][t2]overlay=x=(W-w)/2:y=585:shortest=1[c];\
[c][t3]overlay=x=(W-w)/2:y=730:shortest=1,format=yuv422p10le[out]" \
  -i "$MUSICA" -map "[out]" -map 5:a -c:v prores_ks -profile:v 3 -r 60 -c:a pcm_s24le -t 4 cierre.mov
# silencio de 4 s (AAC no: PCM) para que la pista de audio sea continua
ffmpeg -v error -y -f lavfi -i "anullsrc=r=48000:cl=stereo" -t 4 -c:a pcm_s24le silencio-4s.wav
for f in intro-parte-1.mov cierre.mov; do ffmpeg -v error -y -ss 3.5 -i $f -frames:v 1 ${f%.mov}-muestra.png; done
ls -la *.mov *.wav
