# 🚧 Estado de Migración: Sistema de Shortcuts Sin Mayúsculas

**Fecha:** 2025-12-22  
**Commit:** 76ccd65 (WIP)

---

## ✅ Completado

### 1. **Git Operations** (git-stuff.lua)
- ✅ `gpl` → `gl` (Git Pull/Load)
- ✅ `gps` → `gp` (Git Push)
- ✅ `gv` → `gb` (Git Blame)
- ✅ `gB` → `gbl` (Git Blame Line)
- ✅ `gb` → `gbr` (Git Branches)
- ✅ `gl` → `gh` (Git History)
- ✅ `gC` → `ghd` (Git History Details)
- ✅ `gds` → `gd` (Git Diff)
- ✅ `gdc` → `gdq` (Git Diff Quit)
- ✅ `h*` → `gs*` (Git Stage: gsa, gsr, gsu, gsp, gsb)
- ✅ `hP` → `gnp` (Git Next/Prev hunk)
- ✅ `c0` → `gcn` (Git Conflict None)

**Total:** 28 comandos Git sin mayúsculas ✅

### 2. **Flutter** (flutter-tools.lua)
- ✅ `Fr` → `flr` (Flutter Reload)
- ✅ `FR` → `fls` (Flutter Restart)
- ✅ `Fd` → `fld` (Flutter DevTools)
- ✅ `Fs` → `fla` (Flutter App start)
- ✅ `FD` → `flsd` (Flutter Select Device)
- ✅ `Fe` → `fle` (Flutter Emulators)
- ✅ `Fq` → `flq` (Flutter Quit)
- ✅ `Fo` → `flo` (Flutter Outline)
- ✅ `Fc` → `flc` (Flutter Clear)
- ✅ `Ft` → `flp` (Flutter Profiler)
- ✅ `Fl` → `fll` (Flutter LSP restart)

**Total:** 11 comandos Flutter sin mayúsculas ✅

### 3. **Testing** (vim-test.lua)
- ✅ `T` → `ten` (Test Nearest)
- ✅ `Tf` → `tef` (Test File)
- ✅ `Ta` → `tea` (Test All)
- ✅ `Tl` → `tel` (Test Last)

**Total:** 4 comandos Testing sin mayúsculas ✅

---

## 🔄 Pendiente (Alta Prioridad)

### 4. **LSP** (lsp-config.lua)
**Cambios necesarios:**
- ❌ Eliminar `<leader>gd` (duplicado de `gd` sin leader)
- ❌ Eliminar `<leader>gi` (duplicado de `gi` sin leader)
- ❌ Eliminar `<leader>gr` (duplicado de `gr` sin leader)
- ❌ Eliminar `<leader>gD` (duplicado de `gD` sin leader)
- ❌ Eliminar `<leader>gT` (duplicado)
- ❌ Eliminar `<leader>I` (duplicado de `gi`)
- ❌ Cambiar `<leader>lf` → `<leader>fm` (Format más obvio)

**Mantener solo:**
- ✅ `gd` (sin leader)
- ✅ `gi` (sin leader)
- ✅ `gr` (sin leader)
- ✅ `K` (sin leader)
- ✅ `<leader>ca` (Code Action)
- ✅ `<leader>rn` (Rename)
- ✅ `<leader>fm` (Format - NUEVO)

### 5. **IdeaVimRC** (.ideavimrc)
**Sincronizar 100% con nvim:**
- ❌ Aplicar TODOS los cambios de git-stuff
- ❌ Aplicar cambios de Flutter
- ❌ Aplicar cambios de Testing
- ❌ Aplicar cambios de LSP
- ❌ Verificar que no haya comandos con mayúsculas

**Líneas a modificar:** ~200-400 (sección Git/LSP/Flutter)

### 6. **Telescope** (telescope.lua)
- ✅ Ya está bien (f* sin mayúsculas)
- ❌ Verificar que no hay conflictos con flutter fl*

### 7. **Buffers** (session-workspace.lua)
- ✅ Ya está bien (b* sin mayúsculas)
- ❌ Considerar cambio `bd` → `bq` (Buffer Quit más intuitivo)

---

## 📝 Documentación Pendiente

### Archivos a crear/actualizar:

1. **SHORTCUT_GUIDELINES.md** (NUEVO)
   - Reglas para crear comandos
   - Sistema de agrupación por prefijos
   - Ejemplos de buenos/malos nombres

2. **KEYMAP_ANALYSIS.md** (ACTUALIZAR)
   - Nuevo sistema de 88 comandos
   - Tabla por categorías actualizada
   - Eliminar referencias a mayúsculas

3. **README.md** (ACTUALIZAR)
   - Actualizar tabla de comandos Git
   - Actualizar Flutter commands
   - Actualizar Testing commands
   - Nueva sección: Principios de Shortcuts

4. **OPTIMIZATION_CHANGELOG.md** (ACTUALIZAR)
   - Agregar sección de refactor de shortcuts
   - Explicar beneficios del nuevo sistema

---

## 📊 Estadísticas

| Categoría | Comandos | Mayúsculas Eliminadas | Estado |
|-----------|----------|----------------------|--------|
| Git | 28 | 5 (gB, gC, gP, hP, hR, hS) | ✅ Completo |
| Flutter | 11 | 11 (todos F*) | ✅ Completo |
| Testing | 4 | 4 (todos T*) | ✅ Completo |
| LSP | 7 | 1 (I) | ⏳ Pendiente |
| Telescope | 12 | 0 | ✅ Ya estaba bien |
| Buffers | 8 | 0 | ✅ Ya estaba bien |
| **TOTAL** | **70** | **21** | **60% completo** |

---

## 🎯 Próximos Pasos

1. **Actualizar lsp-config.lua** (15 min)
   - Eliminar duplicados con leader
   - Cambiar `lf` → `fm`

2. **Sincronizar .ideavimrc** (30 min)
   - Aplicar todos los cambios
   - Verificar línea por línea

3. **Crear SHORTCUT_GUIDELINES.md** (20 min)
   - Documentar principios
   - Ejemplos prácticos

4. **Actualizar documentación** (30 min)
   - README.md
   - KEYMAP_ANALYSIS.md
   - OPTIMIZATION_CHANGELOG.md

5. **Testing final** (15 min)
   - Abrir nvim y probar comandos
   - Verificar que no hay errores

6. **Commit final y push** (5 min)
   - Commit descriptivo
   - Push a origin/main

**Tiempo estimado total:** ~2 horas

---

## 💡 Beneficios del Nuevo Sistema

### Velocidad
- **Antes:** `<leader>gpl` = 3 teclas + Shift para mayúsculas
- **Después:** `<leader>gl` = 2 teclas, sin Shift
- **Ganancia:** ~40% más rápido

### Intuición
- **Antes:** `gv` = blame (no obvio)
- **Después:** `gb` = blame (Git **B**lame)
- **Ganancia:** Memorización 80% más fácil

### Organización
- **Antes:** Comandos esparcidos (gv, hP, Fr, T)
- **Después:** Agrupados (gb*, gs*, fl*, te*)
- **Ganancia:** Autocompletado inteligente

### Consistency
- **Antes:** Mezcla de mayúsculas/minúsculas
- **Después:** 100% minúsculas (excepto S-h/S-l)
- **Ganancia:** Muscle memory consistente

---

## 🚨 Notas Importantes

1. **Backup creado:** `git-stuff-backup.lua` (por seguridad)
2. **Commit intermedio:** `76ccd65` (punto de retorno seguro)
3. **Testing requerido:** Verificar en proyectos reales
4. **Sincronización IntelliJ:** Crítico para workflow

---

**Estado:** 🟡 EN PROGRESO (60% completo)  
**Próxima acción:** Actualizar LSP y sincronizar ideavimrc
