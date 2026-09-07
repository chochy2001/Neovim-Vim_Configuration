# Validación de la revisión

Fecha: **6 de septiembre de 2026**. Plataforma ejecutada: Windows x64,
Neovim **0.12.5**, Flutter **3.47.2**, Dart **3.13.2**.
Este documento registra pruebas concretas, su alcance y cómo repetirlas.
Las decisiones técnicas se apoyan en [SOURCES.md](SOURCES.md).

## Resultados

| Comprobación | Resultado |
|---|---|
| Regresiones de configuración | 9 pruebas pasan |
| Integración cargando todos los plugins | 7 comprobaciones pasan |
| Instalación de plugins desde cero en estado aislado | Pasa; restaura el lockfile y carga los plugins |
| Parsers instalados | 27 bibliotecas cargan, producen árboles y compilan sus consultas |
| Formateadores reales | StyLua/Lua y Prettier/JSON modifican el texto exactamente como se espera |
| LSP en archivos reales | 15 servidores: cliente único, adjunto y petición respondida |
| Referencia de edición | 50 casos coinciden con Neovim en texto, cursor y modo, incluidos los 13 ejercicios |
| Entrenador | 88 tests pasan; análisis sin incidencias; formato Dart correcto |
| Cobertura del entrenador | 768/819 líneas: 93,77%; mínimo de CI 90%, sin excluir la interfaz |
| Verificador de cobertura | 6 tests Python pasan; rechaza informes vacíos, incompletos, inconsistentes y umbrales incumplidos |
| Compilación de escritorio | Windows release generado correctamente |
| Vim clásico | Arranque básico con el Vim de Git for Windows, sin vim-plug instalado |
| Herramientas Mason de la configuración | 16 versiones coinciden con el registro actualizado; Astro actualizado a 2.16.16 |
| Material del curso | PDF de 17 páginas regenerado, texto/enlaces comprobados y páginas inspeccionadas; diapositivas comprobadas en Chrome |

Los tests LSP se ejecutaron sobre archivos del propio repo (configuración Lua,
trainer Dart, scripts Python, pubspec YAML, fixtures JSON y diapositivas HTML) y
archivos locales existentes de Go, C++, TOML, TypeScript, Astro, CSS, Bash, PHP
y Dockerfile, sin modificarlos. Servidores comprobados: `lua_ls`, `dartls`,
`pyright`, `yamlls`, `jsonls`, `html`, `gopls`, `clangd`, `taplo`, `vtsls`,
`astro`, `cssls`, `bashls`, `intelephense` y `dockerls`.

En las diapositivas se comprobaron la carga, N/P, flecha derecha y el retorno
circular entre primera/última, además de la composición de las pantallas de
introducción e historia. No se publicaron contenidos en Udemy.

La verificación distingue el arranque de la carga diferida, la presencia de un
cliente de su respuesta efectiva y las fuentes registradas de los clientes de
formato realmente adjuntos.

## Repetir las pruebas

Desde la raíz, con Neovim, Node y Python en PATH:

```sh
python scripts/verify.py
python scripts/verify.py --tools
python scripts/vim_reference.py --check
```

`verify.py` crea config/cache/datos/estado en un directorio temporal corto.
Reutiliza plugins, Mason y parsers instalados mediante enlaces; desactiva
descargas automáticas y no utiliza sesiones del usuario. Guarda un log por
suite y muestra su ubicación. Para otra instalación: `--data RUTA`.
Node permite ejecutar una prueba real con rutas que contienen espacios,
apóstrofos y signos de dólar.

`--tools` exige parsers, StyLua y Prettier ya instalados. Comprueba formato en un
proyecto temporal propio: Prettier respeta los patrones de `.gitignore`, incluso
al recibir texto por stdin. No se desactiva esa protección para conseguir un
resultado verde.

Para comprobar una instalación independiente desde cero, con red:

```sh
python scripts/verify.py --install
```

Esto prueba bootstrap, restauración e integración de plugins. No acredita la
instalación de cada SDK, servidor, parser y depurador opcional. El log de
instalación se conserva en el sandbox.

Para comprobar clientes LSP ya instalados:

```sh
python scripts/verify.py --lsp-file lua_ls=.config/nvim/init.lua --lsp-file dartls=trainer/lib/main.dart --lsp-file pyright=scripts/verify.py
python scripts/verify.py --lsp-file yamlls=trainer/pubspec.yaml --lsp-file jsonls=trainer/test/fixtures/neovim.json --lsp-file html=course/udemy/slides-intro.html
# Go: añade --lsp-file gopls=RUTA_A_UN_ARCHIVO_REAL_DEL_PROYECTO
```

Se espera inicialización, se deja completar `didOpen`, se exige un solo cliente
y se envía `textDocument/documentSymbol`. Un timeout, respuesta con error o
`window/logMessage` de nivel Error falla la prueba. Un aviso upstream no se
convierte automáticamente en un defecto de la configuración.

Entrenador:

```sh
cd trainer
flutter pub get
flutter analyze
dart format --output=none --set-exit-if-changed lib test
flutter test --coverage
python ../scripts/check_coverage.py --min 90
flutter build windows --release
```

Los fixtures contienen texto, cursor y modo producidos por Neovim limpio. Antes
de la corrección, 17 de los 41 casos revelaban diferencias del motor: conteos,
cancelación, `cw`, `cc`, deshacer, pegado y movimientos entre líneas, entre otros.
Las aserciones comparan resultados exactos; no basta con un prefijo del texto.
La ampliación a 50 casos detectó y corrigió `ciw` seguido de deshacer en un
búfer vacío, y añadió `<BS>` a la interpretación de secuencias. Se prueba
también el modo devuelto por Neovim. La cobertura creció de 80,42% a 93,77%
con interacciones de teclado, importación, cancelación, eliminación y límites
de archivos/carpetas. Solo se sustituye el diálogo nativo del selector; se leen
archivos temporales reales.

El umbral usa el porcentaje sin redondear y exige que estén presentes todos los
archivos Dart de `trainer/lib`; no usa exclusiones para elevar el resultado.
Para probar el propio verificador desde la raíz:

```sh
python -m unittest discover -s tests -p "test_*.py"
```

Documentación y PDF:

```sh
python -m pip install -r requirements-docs.txt
python scripts/build_course_pdf.py
python scripts/check_docs.py
```

El PDF incorpora la huella SHA-256 del Markdown normalizado a LF. La prueba
rechaza un PDF desactualizado, caracteres de sustitución y enlaces locales
rotos. La inspección visual se hace aparte, renderizando páginas con Poppler;
no se deduce calidad visual solo de extraer texto.

## Correcciones y mantenimiento

- APIs de Neovim intactas: compatibilidad de git-conflict aislada en su módulo.
- Tree-sitter se carga al inicio según upstream. Se reparó una instalación
  incompleta sin metadatos de revisión; se validaron bibliotecas y consultas.
- Mason prepara PATH antes de detectar servidores y habilita solo los configurados.
  Dart pertenece a flutter-tools; reiniciar un proyecto no detiene los demás.
- Formato con un único cliente adjunto; cerrar buffers no descarta cambios.
- Selección de IA por caracteres/líneas/bloques; el usuario revisa y pega antes
  de enviar. No se realizaron peticiones a servicios de IA durante las pruebas.
- Ejecución con rutas protegidas y compilación condicionada al éxito; el
  comando renderizado evita la expansión adicional de variables de code_runner.
- file_picker 12, importaciones normalizadas y motor de prácticas corregido.
- Se retiraron del índice de Git 13 gitlinks sin `.gitmodules`, la copia de
  vim-plug, el historial netrw y `.zshrc`. Las copias locales se conservaron.
  Esto no reescribe el historial Git.

El lockfile de lazy **ya estaba versionado**. Se quitó una regla de ignorado
contradictoria y se actualizaron sus revisiones, además de añadir cmp-buffer.
Mason y los SDK externos no quedan fijados por ese archivo.

`flutter pub outdated` no deja actualizaciones resolubles pendientes tras
`flutter pub upgrade` (incluido `meta` 1.19.0). `material_color_utilities`
0.13.0 y `test_api` 0.7.12 permanecen restringidos por la versión de Flutter;
sus versiones publicadas más nuevas no se fuerzan con overrides.

## Alcance pendiente de otros entornos

- La revisión inicial `12a376f` pasó la matriz CI Linux/macOS/Windows, el
  entrenador y la documentación en [GitHub Actions](https://github.com/chochy2001/Neovim-Vim_Configuration/actions/runs/34083835237).
  Cada push vuelve a validar el commit publicado; el estado actual está en
  [validate](https://github.com/chochy2001/Neovim-Vim_Configuration/actions/workflows/validate.yml).
- La compilación nativa Linux/macOS y las acciones de JetBrains requieren sus
  entornos respectivos. El arranque de Vim básico no certifica sus plugins legados.
- Los LSP no enumerados arriba, las sesiones de depuración, los SDK adicionales
  y los flujos autenticados de GitHub/Copilot/CLI necesitan pruebas específicas.
- El entrenador implementa un subconjunto de Vim; 50 ejemplos no equivalen a
  conformidad completa con todo Vim ni con toda la edición Unicode.
- Comparar declaraciones de mapas detecta propietarios repetidos en los specs;
  no demuestra que ningún plugin cree sobrescrituras dinámicas en otro estado.

Estas limitaciones delimitan la evidencia; no se presenta el resultado como
una garantía universal de ausencia de errores.
