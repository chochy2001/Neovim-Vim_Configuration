# CAPDESIS Practice

Entrenador de escritorio para acompañar [el curso](../COURSE.md): mecanografía
sobre código y un subconjunto de edición Vim. Funciona sin servicios remotos.

## Prácticas

- **Mecanografía:** ejemplos en 20 lenguajes, selección de varios archivos o una
  carpeta. Los archivos importados se guardan solo en RAM, no se ejecutan ni suben.
  Máximo 40 archivos de 12 KiB, profundidad de carpetas 6; se omiten directorios
  de dependencias, compilación y control de versiones. BOM y finales CRLF se
  normalizan. Los chips permiten descartar archivos.
- **Vim:** 13 katas con texto inicial, objetivo, pista y secuencia de solución.
  La comprobación exige el texto exacto y estar en modo Normal.
- **Evaluación:** el entrenador sirve para practicar. El proyecto final del curso
  se realiza en Neovim real; completar las katas no acredita dominio de todo Vim.

El motor admite movimientos sencillos (`hjkl`, `0^$`, `web`, `gg`, `G`,
`{}`, búsquedas `f/t/F/T`), operadores, algunos objetos de texto, conteos,
inserción, pegado y deshacer. No implementa macros, modo Visual, plugins, LSP ni
todas las reglas de Unicode/anchura visual de Vim. Los objetos y emparejamientos
son simplificados. El alcance preciso está en los casos de prueba.

## Desarrollo y validación

Referencia validada: **Flutter 3.47.2 / Dart 3.13.2**, con dependencias resueltas en
`pubspec.lock`. `file_picker` 12 utiliza API estática y devuelve una lista vacía
al cancelar.

```sh
cd trainer
flutter pub get
flutter analyze
dart format --output=none --set-exit-if-changed lib test
flutter test
flutter run -d windows
```

Para macOS/Linux cambia el dispositivo; cada compilación necesita el SDK nativo
de su sistema. La compilación Windows requiere Visual Studio con desarrollo de
escritorio C++.

```sh
flutter build windows --release
# En sus respectivos sistemas:
flutter build macos --release
flutter build linux --release
```

Los 69 tests incluyen importación, interacción de widgets y 41 comparaciones
con resultados de **Neovim real** (28 casos de borde y las 13 katas).
No se calcula el resultado esperado usando el propio motor.

Desde la raíz del repositorio, con Neovim y Dart en PATH:

```sh
python scripts/vim_reference.py --check
# Solo para regenerar tras revisar conscientemente los cambios de semántica:
python scripts/vim_reference.py
```

`--check` compara los fixtures versionados sin modificarlos. Una actualización
requiere revisar texto, cursor y modo resultantes. Los tests originales se
conservan como regresiones complementarias.

CI: [validación](../.github/workflows/validate.yml) en pushes/PRs y
[compilaciones de escritorio](../.github/workflows/desktop-release.yml) con tags
`v*`. Los paquetes no están firmados. Resultados y límites comprobados:
[VALIDATION.md](../docs/VALIDATION.md).

## English

Offline desktop keyboard trainer with 20 built-in language samples and 13 Vim
katas. Imported files stay in memory; they are neither executed nor uploaded.
The Vim engine is a deliberately limited subset, checked against 41 fixtures
produced by real Neovim, with 69 tests in total. See the commands above to run,
test, regenerate reference fixtures and build on each native desktop platform.

MIT. Copyright © 2026 CAPDESIS / chochy2001. [License](../LICENSE).
