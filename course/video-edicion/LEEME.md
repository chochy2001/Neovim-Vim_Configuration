# LEEME: edición del curso Vim con DaVinci Resolve y MCP

Guía para el operador. Todo lo que hace el agente sale de `~/Movies/Capdesis-Curso-Vim/`. Los originales en `01-crudo/` no se tocan.

## Qué hay en esta carpeta

| Ruta | Qué es |
|---|---|
| `01-crudo/` | Los 5 vídeos originales (solo lectura). |
| `03-analisis/transcripts/` | Transcripción en español con marcas de tiempo por palabra (`.json`, `.srt`, `.txt`). |
| `03-analisis/silencios/` | Silencios medidos por parte y rangos de "tiempo muerto" con 0.25 s de relleno. |
| `03-analisis/edicion/` | Lista de decisiones de edición (`parte-N.json` y `parte-N.md`). |
| `03-analisis/zoom-plan.md` y `frames/` | Plan de zoom y fotogramas de prueba. |
| `03-analisis/mapa-del-curso.md` | Qué enseña cada parte, mapeado a los módulos m00 a m13. |
| `03-analisis/RESUMEN.md` | Totales y cifras. |
| `04-davinci/davinci-resolve-mcp/` | Servidor MCP, clonado a commit `d35e814` (versión 5.2.2, licencia MIT). |
| `04-davinci/.venv-mcp/` | Entorno de Python 3.12 para el servidor MCP. |
| `04-davinci/PROMPTS.md` | Prompts para el agente de edición, en orden. |
| `05-exportados/` | Aquí saldrán los vídeos finales (vacío por ahora). |

## Qué se instaló y con qué versión

- DaVinci Resolve: en este Mac hay **21.1.0** (`/Applications/DaVinci Resolve`). La versión 21.2 Studio que estás instalando todavía no está verificada por el servidor.
- Servidor MCP: `samuelgursky/davinci-resolve-mcp` commit `d35e814ba4405e2cb4e5b2202ceea4215f2f954e` (v5.2.2, MIT). Probado por el autor con Studio 19.1.3, 20.3.2 y 21.0.2 (y free 21.0.3 y 21.0.4 por puente). **No hay prueba oficial con 21.1 ni 21.2.**
- Python del servidor: 3.12.13 (uv). Paquetes: `mcp` 1.30.0 (la versión 2.x no es compatible, según el propio repo), `pyaaf2` 1.7.1.
- Transcripción: `mlx-whisper` 0.4.3, modelo `mlx-community/whisper-large-v3-turbo`, en `~/Movies/Capdesis-Curso-Vim/.venv`.
- ffmpeg: 9.0.2 (`/opt/homebrew/bin/ffmpeg`).

## Paso a paso

### 1. Preparar Resolve
1. Instala DaVinci Resolve **Studio** (21.2 o la que tengas). El scripting externo para Python solo funciona en Studio desde Resolve 21.1; la edición free no sirve para esto.
2. Abre Resolve.
3. Ve a **DaVinci Resolve > Preferences > System > General** y pon **External scripting using** en **Local**. Aplica y cierra Preferencias.
4. No hace falta que abras ningún proyecto todavía: el agente lo crea.

### 2. Conectar el MCP al cliente

Ninguno de estos comandos se ha ejecutado. No se ha tocado `~/.claude`, `~/.codex` ni `~/.cursor`. Copia lo que necesites.

**Claude Code (ámbito de usuario).** Ejecuta esto en la terminal:

```sh
claude mcp add davinci-resolve --scope user \
  -e "RESOLVE_SCRIPT_API=/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting" \
  -e "RESOLVE_SCRIPT_LIB=/Applications/DaVinci Resolve/DaVinci Resolve.app/Contents/Libraries/Fusion/fusionscript.so" \
  -e "PYTHONPATH=/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules" \
  -e "DAVINCI_RESOLVE_MCP_UPDATE_CHECK=0" \
  -- $HOME/Movies/Capdesis-Curso-Vim/04-davinci/.venv-mcp/bin/python \
     $HOME/Movies/Capdesis-Curso-Vim/04-davinci/davinci-resolve-mcp/src/server.py
```

Comprueba con `claude mcp list` que aparece `davinci-resolve`. Si ya existía una entrada con ese nombre, bórrala con `claude mcp remove davinci-resolve --scope user` antes de añadirla.

**Codex CLI.** Añade a `~/.codex/config.toml` (o `$CODEX_HOME/config.toml`). Si ya existe `[mcp_servers.davinci-resolve]`, reemplázala:

Sustituye `<TU_HOME>` por tu carpeta de usuario (en JSON/TOML no vale `~` ni `$HOME`).

```toml
[mcp_servers.davinci-resolve]
command = "<TU_HOME>/Movies/Capdesis-Curso-Vim/04-davinci/.venv-mcp/bin/python"
args = ["<TU_HOME>/Movies/Capdesis-Curso-Vim/04-davinci/davinci-resolve-mcp/src/server.py"]
env = { RESOLVE_SCRIPT_API = "/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting", RESOLVE_SCRIPT_LIB = "/Applications/DaVinci Resolve/DaVinci Resolve.app/Contents/Libraries/Fusion/fusionscript.so", PYTHONPATH = "/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules", DAVINCI_RESOLVE_MCP_UPDATE_CHECK = "0" }
```

**Cursor.** Añade dentro de `mcpServers` en `~/.cursor/mcp.json` (no reemplaces el resto del archivo):

```json
"davinci-resolve": {
  "command": "<TU_HOME>/Movies/Capdesis-Curso-Vim/04-davinci/.venv-mcp/bin/python",
  "args": ["<TU_HOME>/Movies/Capdesis-Curso-Vim/04-davinci/davinci-resolve-mcp/src/server.py"],
  "env": {
    "RESOLVE_SCRIPT_API": "/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting",
    "RESOLVE_SCRIPT_LIB": "/Applications/DaVinci Resolve/DaVinci Resolve.app/Contents/Libraries/Fusion/fusionscript.so",
    "PYTHONPATH": "/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules",
    "DAVINCI_RESOLVE_MCP_UPDATE_CHECK": "0"
  }
}
```

Las rutas tienen que ser absolutas (Codex no expande `~`).

### 3. Ejecutar los prompts
1. Con Resolve abierto y el MCP conectado, abre el agente de edición.
2. Copia los prompts de `04-davinci/PROMPTS.md` **en orden**: (a), luego (b) para cada parte, (c), (d), (e) y (f). Puedes añadir el extra de promoción al final.
3. En (b), el agente te enseñará una lista de cortes "medium" antes de aplicarlos. Tú decides cada id.
4. Revisa cada paso antes de pasar al siguiente. Si el agente no encuentra el MCP, para y mira la sección de solución de problemas.

### 4. Dónde salen los resultados
- Vídeos finales: `~/Movies/Capdesis-Curso-Vim/05-exportados/` (`01-...mp4` a `05-...mp4`; las promos en `05-exportados/promo/`).
- Listas de cortes aplicados: `03-analisis/edicion/aplicados-parte-N.json`.
- Zooms de verificación: `03-analisis/frames/zooms-verificacion/`.
- Transcripción del export y diferencias: `03-analisis/verificacion/`.
- Duraciones medidas con ffprobe: `05-exportados/verificacion-ffprobe.txt`.

### 5. Cómo verificar
- Abre cada archivo de `05-exportados/` y mira los cortes y los zooms con tus ojos. Los cortes de confianza alta son propuestas; el vídeo manda.
- Revisa el informe del paso (f): cada parte acaba en APROBADO, APROBADO CON AVISOS o NO APROBADO. No te fíes de un "aprobado" que no tenga la tabla de diferencias detrás.
- Comprueba el sonido con los auriculares: ruido de fondo, cortes secos y ningún corte dentro de una palabra.

### Solución de problemas (MCP)
- El MCP no responde o las herramientas fallan al llamar a Resolve: casi siempre es que Resolve no está abierto o el scripting no está en "Local". Revisa el paso 1. (El texto exacto del error no está verificado; el servidor devuelve el error de Resolve tal cual.)
- Resolve abierto pero sin conexión: mira la edición (Studio) y la preferencia "Local". En la versión free no hay scripting externo.
- Error de Python: el MCP debe correr con `04-davinci/.venv-mcp/bin/python` (3.12). Con Python 3.15 del sistema no está verificado.
- Ejecuta `04-davinci/davinci-resolve-mcp/scripts/doctor.py` con el Python del venv para un diagnóstico (hace solo lectura).

## Qué se hizo y qué falta

**Hecho y verificado por comando:**
- Transcripción en español, marcas por palabra, de las 5 partes: 8,982 palabras (`03-analisis/transcripts/`).
- Silencios con ffmpeg `silencedetect`, umbral por parte medido (P10 del ruido + 20 dB), y 0.25 s de relleno en los rangos de tiempo muerto.
- Lista de decisiones de edición (`edicion/parte-N.json` y `.md`) con marcas de tiempo a 60 fps, palabras antes y después, motivo y confianza. Ningún corte cae dentro de una palabra (comprobado por script).
- Análisis de movimiento de pantalla (webcam excluida) y plan de zoom: 19 propuestas con rectángulo en píxeles, escala, easing y duración, más 4 fotogramas de prueba.
- Mapa del curso frente a `deck.json` (m00 a m13): qué cubren los vídeos, qué falta y qué está desactualizado.
- Servidor MCP instalado a commit fijado. Arranca con Resolve cerrado y responde con 37 herramientas compuestas (`setup`, `project_manager`, `media_pool`, `timeline`, `timeline_item`, `render`, etc.).
- Prompts (a) a (f) y el extra de promoción.

**Pendiente (requiere a ti o a Resolve abierto):**
- Ninguna llamada real a Resolve se ha probado. Falta confirmar la conexión con Resolve Studio 21.2 abierto y scripting en "Local".
- Ningún corte ni zoom ha sido visto en vídeo por una persona. Los cortes "high" son candidatos: revisa 3 o 4 antes de confiar en el resto.
- Los cortes "medium" (la mayoría) necesitan tu decisión.
- Decisión de audio: el objetivo principal es -16 LUFS para YouTube. Si quieres -14 LUFS también para la versión principal, dímelo.
- Revisa los datos visibles en pantalla antes de publicar: la barra de título muestra una ruta local del proyecto de demo (`F:\formulae_calculo_pro`). Es el proyecto de la grabación, no un dato personal, pero conviene ocultarlo o no mostrarlo.
- Whisper confunde términos técnicos (Esc como "Skip", IdeaVim como "BIM", JetBrains como "JETURINGS"). No uses la transcripción tal cual en subtítulos o descripciones sin corregirla.
- La transcripción usa `condition_on_previous_text=False`; no se ha medido la tasa de error de palabras (WER). Solo la cobertura de las palabras que aparecen en el vídeo.
