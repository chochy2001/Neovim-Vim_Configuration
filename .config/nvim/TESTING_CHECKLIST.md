# 🧪 KEYBINDING TESTING CHECKLIST | LISTA DE PRUEBAS COMPLETA

> **Objetivo**: Probar TODOS los keybindings de manera sistemática
> **Total a probar**: 13 nuevos + 20 críticos existentes = 33 mappings

---

## 🆕 **NUEVOS MAPPINGS AGREGADOS (13) - PRIORIDAD ALTA**

### 🔍 **TELESCOPE QUICK ACCESS (3)**
- [ ] `<leader><leader>` → `:action GotoFile`
  - **Test**: Presionar `<Space><Space>`
  - **Esperado**: Abrir diálogo "Go to File"
  - **Status**: ⏳ PENDING

- [ ] `<leader>fd` → `:action GotoFile`
  - **Test**: Presionar `<Space>fd`
  - **Esperado**: Abrir diálogo "Go to File"
  - **Status**: ⏳ PENDING

- [ ] `<leader>.` → `:action GotoFile`
  - **Test**: Presionar `<Space>.`
  - **Esperado**: Abrir diálogo "Go to File"
  - **Status**: ⏳ PENDING

### 🌳 **NEO-TREE FOCUS & WINDOW (3)**
- [ ] `<leader>pf` → `:action ActivateProjectToolWindow`
  - **Test**: Presionar `<Space>pf`
  - **Esperado**: Abrir/enfocar panel Project
  - **Status**: ⏳ PENDING

- [ ] `<leader>we` → `:action NextSplitter`
  - **Test**: Presionar `<Space>we` (con splits abiertos)
  - **Esperado**: Mover focus al siguiente splitter
  - **Status**: ⏳ PENDING

- [ ] `<leader>wt` → `:action PrevSplitter`
  - **Test**: Presionar `<Space>wt` (con splits abiertos)
  - **Esperado**: Mover focus al splitter anterior
  - **Status**: ⏳ PENDING

### 📦 **BUFFER MANAGEMENT (1)**
- [ ] `<leader>bP` → `:action PreviousTab`
  - **Test**: Presionar `<Space>bP` (con múltiples tabs)
  - **Esperado**: Ir al tab anterior
  - **Status**: ⏳ PENDING

### 🌿 **GIT OPERATIONS (4)**
- [ ] `<leader>gds` → `:action Vcs.ShowDiff`
  - **Test**: Presionar `<Space>gds` (en archivo con cambios)
  - **Esperado**: Mostrar diff del archivo
  - **Status**: ⏳ PENDING

- [ ] `<leader>gd` → `:action GotoDeclaration`
  - **Test**: Presionar `<Space>gd` (en símbolo)
  - **Esperado**: Ir a declaración/definición
  - **Status**: ⏳ PENDING

- [ ] `<leader>cp` → `:action Annotate`
  - **Test**: Presionar `<Space>cp`
  - **Esperado**: Mostrar Git blame annotations
  - **Status**: ⏳ PENDING

- [ ] `<leader>cn` → `:action Annotate`
  - **Test**: Presionar `<Space>cn`
  - **Esperado**: Mostrar Git blame annotations
  - **Status**: ⏳ PENDING

### 🔢 **HARPOON MARKS (2)**
- [ ] `<leader>ma` → `:action AddToFavorites`
  - **Test**: Presionar `<Space>ma`
  - **Esperado**: Agregar archivo a favoritos
  - **Status**: ⏳ PENDING

- [ ] `<leader>mm` → `:action RecentFiles`
  - **Test**: Presionar `<Space>mm`
  - **Esperado**: Mostrar archivos recientes
  - **Status**: ⏳ PENDING

---

## ✅ **MAPPINGS CRÍTICOS EXISTENTES (20) - VERIFICACIÓN**

### 🔍 **TELESCOPE CORE (5)**
- [ ] `<leader>ff` → `:action GotoFile`
  - **Test**: `<Space>ff` | **Expected**: Go to File dialog | **Status**: ⏳

- [ ] `<leader>fg` → `:action FindInPath`
  - **Test**: `<Space>fg` | **Expected**: Find in Path dialog | **Status**: ⏳

- [ ] `<leader>fo` → `:action RecentFiles`
  - **Test**: `<Space>fo` | **Expected**: Recent Files dialog | **Status**: ⏳

- [ ] `<leader>fb` → `:action Switcher`
  - **Test**: `<Space>fb` | **Expected**: Buffer switcher | **Status**: ⏳

- [ ] `,,` → `:action GotoFile`
  - **Test**: `,,` | **Expected**: Go to File dialog | **Status**: ⏳

### 📦 **BUFFER NAVIGATION (4)**
- [ ] `<S-l>` → `:action NextTab`
  - **Test**: `Shift+L` | **Expected**: Next tab | **Status**: ⏳

- [ ] `<S-h>` → `:action PreviousTab`
  - **Test**: `Shift+H` | **Expected**: Previous tab | **Status**: ⏳

- [ ] `<leader>bn` → `:action NextTab`
  - **Test**: `<Space>bn` | **Expected**: Next tab | **Status**: ⏳

- [ ] `<leader>bp` → `:action PreviousTab`
  - **Test**: `<Space>bp` | **Expected**: Previous tab | **Status**: ⏳

### 🌿 **GIT BLAME TOGGLE (2)**
- [ ] `<leader>gv` → `:action Annotate`
  - **Test**: `<Space>gv` (presionar 2 veces)
  - **Expected**: Show blame → Hide blame (TOGGLE)
  - **Status**: ⏳

- [ ] `<leader>gB` → `:action Annotate`
  - **Test**: `<Space>gB` | **Expected**: Show Git blame | **Status**: ⏳

### 🚀 **FLUTTER (3)**
- [ ] `<leader>Fs` → `:action Flutter.Start`
  - **Test**: `<Space>Fs` (en proyecto Flutter)
  - **Expected**: Start Flutter app | **Status**: ⏳

- [ ] `<leader>FD` → `:action Flutter.SelectDevice`
  - **Test**: `<Space>FD` | **Expected**: Select Flutter device | **Status**: ⏳

- [ ] `<leader>Fe` → `:action Flutter.StartEmulator`
  - **Test**: `<Space>Fe` | **Expected**: Start emulator | **Status**: ⏳

### 🧪 **TESTING (3)**
- [ ] `<leader>T` → `:action RunClass`
  - **Test**: `<Space>T` | **Expected**: Run nearest test | **Status**: ⏳

- [ ] `<leader>Tf` → `:action RunClass`
  - **Test**: `<Space>Tf` | **Expected**: Run file tests | **Status**: ⏳

- [ ] `<leader>Ta` → `:action RunAllTestsInProject`
  - **Test**: `<Space>Ta` | **Expected**: Run all tests | **Status**: ⏳

### 🔧 **LSP (3)**
- [ ] `gd` → `:action GotoDeclaration`
  - **Test**: `gd` (sin Space) | **Expected**: Go to definition | **Status**: ⏳

- [ ] `<leader>ca` → `:action ShowIntentionActions`
  - **Test**: `<Space>ca` | **Expected**: Show code actions | **Status**: ⏳

- [ ] `<leader>rn` → `:action RenameElement`
  - **Test**: `<Space>rn` | **Expected**: Rename symbol | **Status**: ⏳

---

## 🚨 **TESTING METHODOLOGY | METODOLOGÍA DE PRUEBAS**

### **Setup Required:**
1. ✅ Abrir IntelliJ IDEA con IdeaVim habilitado
2. ✅ Cargar proyecto con archivos Git (para testing Git commands)
3. ✅ Tener múltiples tabs/archivos abiertos
4. ✅ Archivo con código para testing LSP
5. ✅ `:source ~/.ideavimrc` para recargar configuración

### **Testing Process:**
1. **🎯 Individual Testing**: Probar cada mapping uno por uno
2. **📝 Document Results**: Marcar ✅/❌ para cada uno
3. **🔍 Debug Failed**: Investigar los que fallen
4. **🔧 Fix Issues**: Corregir action IDs incorrectos
5. **📋 Final Report**: Resumen de éxito/fallo

### **Result Tracking:**
- ✅ **WORKS**: Funciona perfectamente
- ⚠️ **PARTIAL**: Funciona pero comportamiento diferente
- ❌ **FAILED**: No funciona / error
- 🔍 **NEEDS_CHECK**: Requiere verificación adicional

---

## 📊 **QUICK PROGRESS TRACKER**

| Category | Total | Tested | ✅ Works | ❌ Failed | ⚠️ Partial |
|----------|-------|--------|----------|-----------|------------|
| **NEW Telescope** | 3 | 0 | 0 | 0 | 0 |
| **NEW Neo-tree** | 3 | 0 | 0 | 0 | 0 |
| **NEW Buffer** | 1 | 0 | 0 | 0 | 0 |
| **NEW Git** | 4 | 0 | 0 | 0 | 0 |
| **NEW Harpoon** | 2 | 0 | 0 | 0 | 0 |
| **EXISTING Critical** | 20 | 0 | 0 | 0 | 0 |
| **TOTAL** | **33** | **0** | **0** | **0** | **0** |

---

## 🎯 **NEXT ACTIONS:**

1. **🚀 START TESTING**: Abrir IntelliJ IDEA
2. **📝 UPDATE STATUS**: Marcar cada resultado
3. **🔧 FIX ISSUES**: Corregir los que fallen
4. **📋 FINAL REPORT**: Documento de resultados
5. **📚 UPDATE README**: Con comandos 100% verificados

**🔥 READY TO START TESTING! 🔥**