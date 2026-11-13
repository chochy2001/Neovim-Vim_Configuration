"""Transcribe un video a JSON (palabras con tiempos) y TXT.

Uso:
  ~/Movies/Capdesis-Curso-Vim/.venv/bin/python -I transcribir.py <video> <salida-sin-extension>
"""
import os
# Modelo de Whisper: si existe la copia local (.modelos/whisper-large-v3-turbo), se usa sin red. Si no, se descarga
# de Hugging Face en CADA ejecución (~2 min): no queda en ~/.cache. Ver COMO-EDITAR-CURSOS.md E58.
_ML = os.path.expanduser("~/Movies/Capdesis-Curso-Vim/.modelos/whisper-large-v3-turbo")
MODELO_WHISPER = _ML if os.path.isfile(f"{_ML}/config.json") else "mlx-community/whisper-large-v3-turbo"
import json
import sys

import mlx_whisper

video, out = sys.argv[1], sys.argv[2]
result = mlx_whisper.transcribe(
    video,
    path_or_hf_repo=MODELO_WHISPER,
    language="es",
    word_timestamps=True,
)
with open(out + ".json", "w", encoding="utf-8") as f:
    json.dump(result, f, ensure_ascii=False, indent=1)
with open(out + ".txt", "w", encoding="utf-8") as f:
    f.write(result["text"].strip() + "\n")
words = sum(len(s.get("words", [])) for s in result["segments"])
print(f"{out}: {len(result['segments'])} segmentos, {words} palabras")
