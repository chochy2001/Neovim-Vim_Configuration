# Buenas prácticas DaVinci Resolve 21.1 para screencasts de código (1080p60)

Fecha de la investigación: 2026-11-11. Investigación solo de lectura: no se tocó Resolve, ni otros archivos, ni git.

## Cómo leer las fuentes

- **[M p.N]**: manual oficial local `DaVinci Resolve Manual.pdf` (21.1), página PDF N.
- **[S: clase.método]**: stub `DaVinciResolveScript.pyi` (API de scripting).
- **[W: URL]**: fuente web.
- **Criterio del proyecto**: sin fuente externa. Es una recomendación nuestra.

## Resumen rápido

- Grabar a 2K o 4K y entregar a 1080p da margen de zoom sin perder nitidez. Super Scale solo es de Studio [M p.288].
- Ajustes de entrega para YouTube 1080p60: H.264, AAC-LC, 48 kHz, 12 Mbps SDR para 60 fps [W: support.google.com/youtube/answer/1722171].
- Loudness: el manual cita -14 LUFS como objetivo de YouTube [M p.4060]. Nuestra regla de curso es -16 LUFS y pico real de -1.5 dBTP.
- La API cubre casi todo el render, el CDL, el audio y los transcripts. No cubre keyframes ni cortes por bisturí [S: Project, TimelineItem, Timeline].
- Lo que más falla en la práctica es el silencio: el transcript marca silencios como `(...)`, pero el corte sigue siendo manual o externo [S: TranscriptionWord].

---

## 1. Importar medios (página Media)

**Qué hacer**
- Organizar en bins por curso, módulo y tipo (grabaciones crudas, audio, logos, plantillas) [criterio del proyecto].
- Usar Proxy solo si el equipo va lento. Proxy sirve para editar; el render final usa el original [M p.98, p.207].
- Optimized Media "hornea" efectos como Super Scale y acelera la reproducción [M p.288].
- Timeline a 1920x1080, 60 fps, 48 kHz [M p.161 para 48 kHz; S: ProjectSettings.timelineFrameRate].

**Qué evitar**
- Mezclar 1080p30 y 1080p60 en el mismo timeline sin decidir cómo se tratan. Ver `timelineFrameRateMismatchBehavior` [S: ProjectSettings] [criterio del proyecto].
- Dejar los proxies como fuente del render (opción "Use Proxy Media" del preset YouTube) [M p.4105].

**Valores para screencasts**
- Grabación: 2560x1440 o 3840x2160 a 60 fps si el equipo lo permite. Si no, 1920x1080 a 60 fps [criterio del proyecto].
- Timeline: 1920x1080, 60 fps.
- Ingesta de datos: Video (rango 16-235) salvo que la grabación sea Full (0-255). Verificar con ffprobe antes de decidir [M p.159, p.143; criterio del proyecto].

**Por qué grabar en 2K o 4K**
- Con el zoom en un timeline de 1080p, el píxel crudo se amplía. A 2x sale borroso [M p.430; criterio del proyecto].
- Si el origen es 4K, un zoom de 1.5x a 2x sale nítido al entregar 1080p, porque el render reduce la imagen.
- Super Scale (2-4x, Enhanced) aumenta la resolución del clip. Pesa mucho y suele quitar el tiempo real. Úsalo con Optimized Media o con caché [M p.287-288].

**Super Scale: uso con criterio**
- Solo para clips que se amplían mucho. No lo actives en todo [M p.288].
- Sharpness en Low o Medium. Con Noise Reduction se controla el grano [M p.288].

**API**
- Crear timeline, importar y organizar: **sí** [S: MediaPool.ImportMedia, CreateTimelineFromClips, MoveClips, AddSubFolder].
- Proxy: **sí**, parcial. `MediaPoolItem.LinkProxyMedia / UnlinkProxyMedia` [S: MediaPoolItem].
- Optimized Media: **parcial**. Solo se ve en la configuración del proyecto; no hay método directo [S: ProjectSettings perfOptimizedResolutionRatio].

---

## 2. Cut y Edit: cortes, silencios, transiciones

**Silencios (regla del operador: cortar solo si no habla y no hay nada en pantalla)**
- Usar Ripple Delete Silence (Clip > Audio Operations) en Cut o Edit. Ajustes: Threshold, Pre Head, Post Tail, Minimum to Trip [M p.773].
- En el curso no se usa: los silencios se cortan con `plan_cortes.py` (ver COMO-EDITAR-CURSOS.md, sección 5).
- Revisar siempre las marcas rojas antes de pulsar Remove [M p.773].
- Pre Head y Post Tail son el margen para no cortar dentro de una palabra [M p.773].
- Por eso la regla del operador "no cortar dentro de una palabra" se verifica con el transcript, no solo con el umbral [criterio del proyecto].

**Repeticiones y errores**
- Quitar las versiones malas dejando la última buena: ripple delete [M p.773].
- Repasos a propósito: no tocar [requisito del operador].

**J/L cuts**
- Las ediciones split (J o L) extienden el audio bajo el video de otro clip [M p.728].
- Para screencast sirven para que la voz entre antes de cambiar la pantalla. Usar con poca frecuencia [criterio del proyecto].

**Transiciones**
- Por defecto, la transición estándar es un cross dissolve de 1 s [M p.762, p.759].
- Recomendado para screencasts: corte seco por defecto. Si hace falta disolver, 6-12 fotogramas (0.1-0.2 s a 60 fps) [criterio del proyecto].
- Smooth Cut sirve para tapar cortes en entrevistas, no en pantallas [M p.758].
- Evitar transiciones vistosas (wipes, zooms de transición) [criterio del proyecto].

**API**
- Cortar un clip completo: **sí**, `Timeline.DeleteClips(items, rippleDelete=True)` [S: Timeline.DeleteClips].
- Cortar por rangos o con bisturí: **no**. El stub no tiene Split ni Blade [S: revisado].
- Silencios: **parcial**. `MediaPoolItem.TranscribeAudio` + `GetTranscription` marca silencios como `(...)` con timecodes por palabra [S: Transcription, TranscriptionWord]. Después hay que cortar con la GUI o fuera de Resolve.
- Transiciones: **sí**, `TimelineItem.AddTransition({type, position, alignment, duration: frames})` [S: TransitionOptions].
- Quitar silencios con `Ripple Delete Silence` desde la API: **no** existe método en el stub.

---

## 3. Zooms

**Qué hacer**
- Zoom en cada clic, apertura de menú o zona pequeña. Así se sabe dónde se hace clic (regla del operador).
- Usar Dynamic Zoom (Inspector o controles en Viewer). Tiene Ease: Linear, Ease In, Ease Out, Ease In and Out [M p.430, p.768].
- Cuando haga falta un encuadre que siga algo en movimiento, Smart Reframe (Studio) [M p.735].
- Transform (Zoom, Position, Anchor) para ajustes exactos [M p.735].

**Valores recomendados para screencasts**
- Zoom suave: máximo 1.5x [requisito del operador]. En el curso: 1.25x en clics y 1.5x en el plan. El 1.15x es una sugerencia nuestra, no se usa.
- 2x solo en la barra inferior de la parte 2 [requisito del operador].
- Rampa de entrada y salida: 0.5 a 0.8 s, con Ease In and Out [criterio del proyecto].
- Legibilidad en móvil: el texto del código debe seguir siendo legible con el encuadre final. Como guía, 1080p en móvil con código de 16 px mínimo tras el zoom [criterio del proyecto].

**Qué evitar**
- Zooms bruscos (Linear o sin rampa) [requisito del operador].
- Zoom mayor de 1.5x sobre material 1080p (2x solo en la barra inferior de la parte 2) [requisito del operador].
- Tapar el logo al hacer zoom: moverlo a una zona libre [requisito del operador].

**API**
- Zoom, pan y tilt estáticos: **sí**, `TimelineItem.SetProperties({ZoomX, ZoomY, Pan, Tilt, DynamicZoomEnabled, DynamicZoomEase})` [S: TimelineItemProperties].
- Keyframes (rampas, ease animado): **no**. `TimelineItemProperties` no expone keyframes. Hay `SetSpeed` con `StretchKeyframesToFit`, pero no escribe keyframes de transform [S: SpeedOptions].
- Smart Reframe: **sí, sin parámetros**, `TimelineItem.SmartReframe()` [S: TimelineItem.SmartReframe]. El resultado hay que revisarlo a ojo.
- Estabilización: `TimelineItem.Stabilize()` [S: TimelineItem.Stabilize].

---

## 4. Fusion: títulos, lower thirds, intro/outro, desenfoques

**Títulos animados (Text+)**
- Los títulos Text (Fusion) se previsualizan con Hover Scrub [M p.762].
- Usar pocos títulos animados. Fondo sobrio [criterio del proyecto].
- Tipografía usada en el curso: Avenir Next (`generar_titulos.sh`). Monoespaciada no se usa.

**Lower thirds y logo**
- Lower third: una capa de texto en la parte inferior, con fondo semitransparente, sin cubrir el código [criterio del proyecto].
- Logo siempre visible, arriba a la derecha por defecto, colores originales, sin recolorear [requisito del operador].

**Intro y cierre**
- Usado en el curso: intro de 4 s y cierre de 4 s (`generar_titulos.sh`). Las cifras de criterio anteriores (3-5 s y 5-8 s) no se aplican. Ver COMO-EDITAR-CURSOS.md, sección 18.

**Desenfoque para privacidad**
- Tapar rutas locales, correos, tokens y proyectos de clientes [requisito del operador].
- En Fusion: nodo Blur con máscara (rectángulo o polígono) para tapar una zona concreta [M p.1386-1394; índice p.79 Rotoscoping with Masks].
- Hacerlo en Fusion fijando la máscara a la zona; revisar fotograma a fotograma en los cambios de zoom [criterio del proyecto].

**API**
- Insertar título Fusion en timeline: **sí**, `Timeline.InsertFusionTitleIntoTimeline(titleName)` [S: Timeline].
- Añadir comp Fusion a un clip: **sí**, `TimelineItem.AddFusionComp()` [S: TimelineItem.AddFusionComp].
- Importar comp Fusion (.comp) desde archivo: **sí**, `TimelineItem.ImportFusionComp(path)` [S: TimelineItem.ImportFusionComp].
- Animar el Text+ con keyframes desde la API: **no** (sin keyframes en el stub). Crear la animación en la GUI y guardar el .comp, o importar un .comp ya hecho [criterio del proyecto].
- Máscaras con blur: **parcial**, `TimelineItem.CreateMagicMask(mode)` para la detección automática [S: TimelineItem.CreateMagicMask]. El blur fino se hace en la GUI.

---

## 5. Color: corrección para captura de pantalla

**Qué hacer**
- Timeline Color Space: Rec.709, gamma Rec.709 Gamma 2.4 [M p.184, p.226, p.230].
- Corrección primaria suave: contraste leve y saturación natural. Texto del código nítido y legible [requisito del operador].
- Nodos: nodo 1 corrección primaria, nodo 2 ajuste del fondo si hace falta, nodo 3 opcional [criterio del proyecto].

**Niveles de datos**
- Monitor: Video para monitores Rec.709; Full solo si el monitor soporta rango completo [M p.143].
- Ingesta: `Data Levels` define el rango al importar (Video o Full). Un error aquí tiñe la imagen y hace que el texto pierda contraste [M p.159].
- Las grabaciones de escritorio suelen venir en rango Full. Revisar con ffprobe (`color_range`) antes de decidir [criterio del proyecto].

**Evitar**
- Desaturar el texto del código. Mantener saturación del fondo sin tocar el color de la sintaxis [requisito del operador].
- Subir mucho el contraste: pierde detalle en el texto fino.
- Recolorear el logo [requisito del operador].

**API**
- CDL por clip: **sí**, `TimelineItem.SetCDL({NodeIndex, Slope, Offset, Power, Saturation})` [S: CDL, TimelineItem.SetCDL].
- Grupos de color: **sí**, `Timeline.GetColorGroupsList / AddColorGroup / AssignToColorGroup` [S: Project].
- Nodos y LUT: **parcial**, `TimelineItem.GetNodeGraph`, `ExportLUT` [S: TimelineItem]. Crear nodos no está expuesto.
- Ajustar los niveles de ingesta por API: **no verificado**. Hay `videoDataLevels` en ProjectSettings [S: ProjectSettings], pero no lo probé; el valor por clip hay que confirmarlo en la GUI.

---

## 6. Fairlight: loudness, limitador, voz

**Objetivos de loudness**
- Curso: -16 LUFS integrados, pico real máximo -1.5 dBTP [requisito del operador].
- YouTube: el manual cita -14 LUFS [M p.4060, p.3968].
- Pico real -1 dBTP es la referencia de EBU R128 [W: en.wikipedia.org/wiki/EBU_R_128]. Nuestro límite de -1.5 dBTP es más seguro [criterio del proyecto].
- Conflicto a tener en cuenta: si el curso se publica solo en YouTube, -16 LUFS suena más bajo porque YouTube no sube el volumen (fuentes secundarias, no oficiales). Preguntar al operador si quiere -14 para YouTube [criterio del proyecto].

**Medidores**
- Usar el medidor de loudness de Fairlight (LUFS y true peak). El true peak usa BS.1770 [M p.1110, p.4054].
- Target Loudness Level se cambia para que el "0" del medidor sea -16 o -14 [M p.4060].

**Limitador**
- Limiter: limitador de true peak con anticipación de 64 muestras [M p.4037]. Ponerlo en el bus master con Threshold a -1.5 dBTP [criterio del proyecto].

**Voice Isolation y Dialogue Leveler (Studio)**
- Voice Isolation: quita ruido de fondo. El manual sugiere 70 a 80 para sonar natural [M p.774].
- En el curso: amount 25 (reducción ligera, requisito del operador). El valor 70 a 80 no se usa.
- Dialogue Leveler: iguala voces cuando el volumen varía mucho [M p.774].
- Sin música. Si hay música, bajarla [requisito del operador].

**Ajuste de volumen**
- Normalize Audio Levels: normaliza por clip según estándar de loudness o por true peak [M p.1110].
- Ajuste de 1 dB o 3 dB con atajos [M p.1110].

**API**
- Normalizar clips: **sí**, `Timeline.NormalizeAudioLevel(items, {normalizationMode, targetLoudness})`. Los modos vienen de `GetNormalizeAudioModes()` [S: Timeline.NormalizeAudioLevel, NormalizeAudioOptions].
- Voice Isolation: **sí**, `TimelineItem.SetVoiceIsolationState({isEnabled, amount})` y `Timeline.SetVoiceIsolationState(trackIndex, ...)` [S: TimelineItem, Timeline].
- Dialogue Leveler: **sí**, en `TimelineItem.SetProperties` con `AudioDialogueLevelerEnabled`, `AudioDialogueLevelerMode` [S: TimelineItemProperties].
- Limitador en bus master: **parcial**, `Project.ApplyFairlightPresetToCurrentTimeline(presetName)`. El preset hay que crearlo antes en la GUI [S: Project].
- Medición de LUFS: **no** en el stub. Medir con ffmpeg `loudnorm` o `ebur128` fuera de Resolve [criterio del proyecto].

---

## 7. Deliver: H.264/H.265 1080p60, bitrate, AAC

**Preset YouTube de Resolve**
- Preset YouTube 1080p: MP4, H.264, perfil High, audio AAC, Normalize Audio, Use Proxy Media [M p.4105].
- Desmarcar Use Proxy Media en la entrega final [criterio del proyecto].
- Normalize Audio del preset normaliza a la norma de YouTube (-14) [M p.4105]. Para el curso, usar -16 y no esta casilla, o revisar el resultado [criterio del proyecto].

**Bitrate (YouTube oficial)**
- 1080p a 60 fps (high frame rate): 12 Mbps SDR. A 24-30 fps: 8 Mbps [W: support.google.com/youtube/answer/1722171?hl=en].
- Audio: AAC-LC, 48 kHz, estéreo 384 kbps. Mínimo 128 kbps [W: support.google.com/youtube/answer/1722171?hl=en; W: support.google.com/youtube/answer/4603579?hl=en].
- Mantener la tasa de fotogramas de la grabación; no remuestrear [W: support.google.com/youtube/answer/1722171?hl=en].

**Valores de entrega para el curso**
- Contenedor MP4. Video H.264 High, 1920x1080, 60 fps [M p.4105; W: 1722171].
- Video: referencia de YouTube de unos 12 Mbps [W: 1722171]. `VideoQuality` NO lo fija (medido): el bitrate sale VBR. Medir con ffprobe y reportarlo.
- Audio del curso: AAC-LC, 48 kHz, 192 kb/s en `editado/` (lo que hace `finalizar_audio.py`). Clips de YouTube: 256 kb/s. La recomendación de 320 kb/s no se aplica; decisión pendiente (COMO-EDITAR-CURSOS.md, sección 18).
- H.265: no recomendado para YouTube en este flujo; H.264 es más compatible [criterio del proyecto].

**Trampas**
- Un render sin verificar puede salir con frame rate o bitrate distinto al pedido. Verificar con ffprobe después de cada render [criterio del proyecto].
- Renders que se quedan en cola o fallan: revisar `GetRenderJobStatus`.

**API (render por scripting)**
- Crear o cargar preset: **sí**, `Project.LoadRenderPreset(name)`, `GetRenderPresetList()` [S: Project].
- Ajustes de salida: **sí**, `Project.SetRenderSettings({FormatWidth, FormatHeight, FrameRate, VideoQuality, AudioCodec, AudioSampleRate, EncodingProfile, TargetDir, CustomName, ...})` [S: RenderSettings].
- Ciclo: `SetRenderSettings` -> `AddRenderJob` (devuelve `jobId`) -> `StartRendering([jobId])` -> `GetRenderJobStatus(jobId)` hasta `Complete` o `Failed` [S: Project].
- Trampa 1: `StartRendering` no bloquea. Esperar a que `IsRenderingInProgress()` sea False [S: Project].
- Trampa 2: los ajustes se aplican al crear el trabajo. Llamar `SetRenderSettings` antes de `AddRenderJob`, no después [criterio del proyecto].
- Trampa 3: `VideoQuality` acepta entero o 'Least'/'Low'/'Medium'/'High'/'Best'. La unidad del entero no está en el stub. Medido en el curso: 16000 no fija el bitrate (sale VBR) [S: RenderSettings.VideoQuality].
- Trampa 4: la API 21.0.4 añade opciones para handles, extents y data burn en `SetRenderSettings` [W: changelog Resolve 21.0.4 vía get_whats_new].
- Trampa 5: `Project.DeleteAllRenderJobs()` borra la cola de todos los trabajos. Úsalo con cuidado [S: Project].

---

## 8. Edición con IA o agentes: flujo y verificación

**Flujo recomendado**
1. Transcribir: `MediaPoolItem.TranscribeAudio()` y `GetTranscription()` [S: MediaPoolItem].
2. Plan: el agente propone cortes con timecodes, zooms y títulos. El plan va en un archivo, no en el timeline [criterio del proyecto].
3. Aplicar: `DeleteClips`, `SetProperties`, `InsertFusionTitleIntoTimeline`, según el plan [S: Timeline, TimelineItem].
4. Verificar: render real, ffprobe (fps, resolución, bitrate, LUFS, true peak), transcripción del export y fotogramas clave [requisito del operador].
5. Revisión por varios agentes, con reporte de lo aprobado y lo pendiente [requisito del operador].

**Cómo evitar falsos positivos**
- Un agente no puede "ver" si la pantalla cambia. Revisar los fotogramas antes y después de cada corte [criterio del proyecto].
- El transcript no marca cambios de pantalla. Un silencio con tecleo no es silencio [requisito del operador].
- Comparar el transcript del export con el original: si falta una palabra, el corte fue mal [criterio del proyecto].
- Medir, no suponer: loudness y true peak con ffmpeg (`ebur128`) sobre el export, no sobre el timeline [criterio del proyecto].
- Dejar el plan y las marcas reproducibles, para repetir la prueba [criterio del proyecto].

**API**
- Transcripción y silencios: **sí**, `TranscribeAudio`, `GetTranscription`, `(...)` = silencio [S: TranscriptionSegment].
- Detección de cambios de escena: **sí**, `Timeline.DetectSceneCuts()` [S: Timeline.DetectSceneCuts]. Útil para revisar cortes, no para decidirlos.
- Subtítulos automáticos: **sí**, `Timeline.CreateSubtitlesFromAudio(AutoCaptionSettings)` [S: Timeline].

---

## Lo que no se ha podido verificar

- Valor de `VideoQuality` en Mbps o kbps. Medido: 16000 no fija el bitrate. La unidad sigue sin confirmarse.
- Niveles de datos por clip desde la API. Solo se ha leído `videoDataLevels` en ProjectSettings.
- Loudness oficial de YouTube. Las fuentes encontradas son secundarias.
- Tamaño mínimo de texto para móvil. Es criterio del proyecto, no fuente.
- Novedades 21.0.x: el changelog cita Keyframe ease actions y RemoveMotionBlur, pero no revisé si el stub los expone.

## Fuentes

- [M] `/Applications/DaVinci Resolve/DaVinci Resolve Manual.pdf` (21.1), páginas citadas arriba.
- [S] `/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting/DaVinciResolveScript.pyi`
- [W] https://support.google.com/youtube/answer/1722171?hl=en
- [W] https://support.google.com/youtube/answer/4603579?hl=en
- [W] https://en.wikipedia.org/wiki/EBU_R_128 (secundaria; la ficha original es EBU R 128 v5)
- [W] get_whats_new de DaVinci Resolve Studio, versiones 21.0.1 a 21.0.4
