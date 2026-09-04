# CAPDESIS Practice

Offline desktop trainer: keyboard drills on real-looking code, plus a **tested subset of Vim**. It is **not** Neovim.

Copyright © 2026 CAPDESIS / chochy2001. MIT License (see `/LICENSE`). Free to download and modify.

## English

### What it is

- **Typewriter** — Dart, Go, Python, TypeScript, HTML, SQL, Lua, Bash, PHP. WPM/accuracy. No Vim in this tab.
- **Vim** — 13 katas. Each has a `solve` sequence asserted in `flutter test`. Commands: hjkl, 0^$, web, gg G, {}, insert, x X D C J, dd dw diw ciw, % (same line), yy p, u, f t F T ;, >>, counts. Not Neovim.

### What it is not

- Not a website. Not a full Vim/Neovim emulator (no macros, visual block, plugins, LSP).
- Unsigned installers: Windows SmartScreen / macOS Gatekeeper may warn. Linux needs GTK 3.

### Run from source

```bash
cd trainer
flutter pub get
flutter test
flutter run -d windows    # or macos / linux
```

### Release builds (unsigned)

```bash
flutter build windows --release
flutter build linux --release
flutter build macos --release
```

GitHub Actions (tag `v*`): `.github/workflows/desktop-release.yml`.

---

## Español

Entrenador de escritorio sin red: mecanografía sobre código, y un **subconjunto de Vim con tests**. No es Neovim.

Gratis bajo MIT. Los instaladores de CI **no van firmados**.
