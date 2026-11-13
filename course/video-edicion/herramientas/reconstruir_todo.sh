#!/bin/zsh
# Reconstrucción completa (ronda 2) en el orden correcto. Requiere Resolve abierto con el proyecto. Para y avisa al primer fallo.
set -e; setopt pipefail   # con pipefail un "| tail" ya no oculta el fallo del script (revisión 2026-11-13)
LOG=03-analisis/verificacion/ultimo-reconstruir; mkdir -p $LOG
cd ~/Movies/Capdesis-Curso-Vim; H=03-analisis/herramientas; V=.venv/bin/python
export RESOLVE_SCRIPT_API="/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting"
export RESOLVE_SCRIPT_LIB="/Applications/DaVinci Resolve/DaVinci Resolve.app/Contents/Libraries/Fusion/fusionscript.so"
export PYTHONPATH="$RESOLVE_SCRIPT_API/Modules/"
CLIPS=${1:?"uso: reconstruir_todo.sh clips-vN capas-ver   (carpeta NUEVA, E34; la última usada está en estructura.json)"}; : ${2:?"falta la versión de capas de tarjetas, p. ej. v4"}
echo "== items"; python3 -I $H/items_timeline.py
echo "== logo"; $V -I $H/colocar_logo.py
echo "== capas teclas"; python3 -I $H/generar_capas_teclas.py 1 2 3 4 5
echo "== plan tarjetas"; $V -I $H/plan_animaciones_v2.py
echo "== capas tarjetas"; python3 -I $H/capas_tarjetas.py $2
echo "== fusion tarjetas"; python3 $H/animaciones_fusion.py --v2 | tail -2
echo "== clips"; python3 -I $H/cortar_animaciones.py $CLIPS --v2 | tail -1
echo "== estructura"; python3 -I $H/plan_estructura.py
echo "== renombrar líneas"; python3 - <<'PY'
import DaVinciResolveScript as dvr, time
r=dvr.scriptapp("Resolve"); pm=r.GetProjectManager(); p=pm.GetCurrentProject(); r.OpenPage("edit"); tag=time.strftime("%H%M")
for i in range(1,p.GetTimelineCount()+1):
    t=p.GetTimelineByIndex(i)
    if t.GetName() in [f"Parte {k}" for k in range(1,6)]: t.SetName(t.GetName()+f" (previa {tag})")
pm.SaveProject()
PY
echo "== montaje"; python3 $H/resolve_externo.py 1 2 3 4 5 > $LOG/montaje.log; grep -E "LISTO|SOLAPE|Error" $LOG/montaje.log || true   # el log completo queda en $LOG
echo "== render"; python3 $H/render_final.py | tail -1
echo "== audio"; python3 -I $H/finalizar_audio.py | tail -1
# Verificadores: se corren TODOS aunque uno falle (para ver todos los problemas) y al final se decide.
# Cada uno sale con código != 0 si encuentra algo (REVISAR, caja, texto, unión...). Nada de "|| true".
FALLOS=()
ver() { echo "-- $1"; "${@:2}" > $LOG/$1.log 2>&1 || FALLOS+=$1; tail -3 $LOG/$1.log; }
echo "== verificar"
ver exports $V -I $H/verificar_exports.py
ver uniones python3 -I $H/verificar_uniones.py
ver candidatos $V -I $H/verificar_candidatos.py
ver cajas $V -I $H/buscar_cajas_negras.py --final
ver capas $V -I $H/verificar_capas.py
ver textos python3 -I $H/verificar_textos_tarjetas.py
ver zoom_comandos python3 -I $H/verificar_zoom_comandos.py
echo "== clips y reporte"; python3 -I $H/clips_promo.py | tail -1
ver reporte python3 -I $H/reporte.py
if (( ${#FALLOS} )); then echo "NO LISTO. Fallaron: ${FALLOS[*]} (logs en $LOG/)"; exit 1; fi
echo "TODO LISTO (todos los verificadores en 0 y reporte APROBADO)"
