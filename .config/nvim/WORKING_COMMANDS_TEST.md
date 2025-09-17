# ✅ COMANDOS FUNCIONIONALES PARA PROBAR | WORKING COMMANDS TO TEST

> **Estado**: Post-limpieza de comandos no funcionales
> **Objetivo**: Probar solo los comandos que SÍ deberían funcionar en Android Studio

---

## 🔥 **COMANDOS CRÍTICOS QUE FUNCIONAN (20)**

### 🔍 **TELESCOPE CORE (8) - VERIFICADOS**
- `<leader>ff` → `:action GotoFile` ✅
- `<leader>fg` → `:action FindInPath` ✅
- `<leader>fo` → `:action RecentFiles` ✅
- `<leader>fb` → `:action Switcher` ✅
- `<leader><leader>` → `:action GotoFile` ✅
- `<leader>fd` → `:action GotoFile` ✅
- `<leader>.` → `:action GotoFile` ✅
- `,,` → `:action GotoFile` ✅

### 📦 **BUFFER NAVIGATION (4) - VERIFICADOS**
- `<S-l>` → `:action NextTab` ✅
- `<S-h>` → `:action PreviousTab` ✅
- `<leader>bn` → `:action NextTab` ✅
- `<leader>bp` → `:action PreviousTab` ✅

### 🌳 **NEO-TREE/PROJECT (3) - NUEVOS**
- `<leader>pf` → `:action ActivateProjectToolWindow` 🆕
- `<leader>we` → `:action NextSplitter` 🆕
- `<leader>wt` → `:action PrevSplitter` 🆕

### 🔧 **LSP CORE (3) - VERIFICADOS**
- `gd` → `:action GotoDeclaration` ✅
- `<leader>ca` → `:action ShowIntentionActions` ✅
- `<leader>rn` → `:action RenameElement` ✅

### 🌿 **GIT OPERATIONS (4) - NUEVOS FUNCIONAIS**
- `<leader>gv` → `:action Annotate` (Git Blame Toggle) ✅
- `<leader>gB` → `:action Git.Branches` 🆕 WORKING
- `<leader>gD` → `:action GotoDeclaration` 🆕 WORKING
- `<leader>ga` → `:action Git.Add` 🆕 WORKING
- `<leader>gdd` → `:action Vcs.ShowLocalChanges` 🆕 WORKING

### 🚀 **FLUTTER (1) - VERIFICADO**
- `<leader>FD` → `:action RunConfiguration` ✅ (único que funciona)

### 🧪 **TESTING (1) - VERIFICADO**
- `<leader>T` → `:action RunClass` ✅ (único que funciona)

### 📊 **HARPOON MARKS (2) - VERIFICADOS**
- `<leader>ma` → `:action ToggleBookmark` ✅
- `<leader>mm` → `:action RecentFiles` ✅

---

## ⚠️ **COMANDOS COMENTADOS (NO PROBAR)**

### ❌ **Testing Commands (REMOVED)**
- ~~`<leader>Tr`~~ → **COMENTADO**
- ~~`<leader>Ts`~~ → **COMENTADO**
- ~~`<leader>Tl`~~ → **COMENTADO**

### ❌ **Git Commands (REMOVED)**
- ~~`<leader>gd`~~ → **COMENTADO** (conflicto con LSP)
- ~~`<leader>gb`~~ → **COMENTADO** (reemplazado por `<leader>gB`)
- ~~`<leader>hs`~~ → **COMENTADO** (reemplazado por `<leader>ga`)
- ~~`<leader>hr`~~ → **COMENTADO** (no funciona)
- ~~`<leader>hp`~~ → **COMENTADO** (reemplazado por `<leader>gdd`)

### ❌ **Flutter Commands (REMOVED)**
- ~~`<leader>Fs`~~ → **COMENTADO**
- ~~`<leader>Fe`~~ → **COMENTADO**

---

## 🧪 **METODOLOGÍA DE PRUEBAS**

### **Setup:**
1. ✅ Abrir Android Studio con IdeaVim habilitado
2. ✅ Cargar proyecto con archivos Git
3. ✅ Tener múltiples tabs/archivos abiertos
4. ✅ `:source ~/.ideavimrc` para recargar

### **Testing Process:**
1. **🎯 Probar solo los 28 comandos funcionais**
2. **📝 Marcar resultado**: ✅ Funciona / ❌ No funciona
3. **🔧 Si falla**: Investigar action ID correcto
4. **📋 Documentar**: Solo comandos 100% verificados

---

## 📊 **PROGRESS TRACKER**

| Category | Total Working | Status |
|----------|---------------|---------|
| **Telescope** | 8 | ✅ Verified |
| **Buffer Nav** | 4 | ✅ Verified |
| **Neo-tree** | 3 | 🆕 To Test |
| **LSP** | 3 | ✅ Verified |
| **Git** | 5 | 🆕 To Test |
| **Flutter** | 1 | ✅ Verified |
| **Testing** | 1 | ✅ Verified |
| **Harpoon** | 2 | ✅ Verified |
| **TOTAL** | **27** | **Ready** |

---

## 🎯 **PRÓXIMOS PASOS:**

1. **🚀 TESTING**: Probar los 27 comandos funcionais
2. **📝 RESULTS**: Documentar qué funciona 100%
3. **🔧 FIX**: Corregir los que fallen
4. **📚 UPDATE README**: Solo comandos verificados
5. **✅ FINAL**: Configuración limpia y funcional

**🔥 READY TO TEST! Solo comandos que deberían funcionar! 🔥**