# 📐 Directrices para Crear Shortcuts

**Versión:** 2.0  
**Fecha:** 2025-12-22  
**Sistema:** Sin Mayúsculas + Agrupación Lógica

---

## 🎯 Principios Fundamentales

### 1. **CERO Mayúsculas** ❌🔠
```vim
❌ MAL:  <leader>Fr  (requiere Shift)
✅ BIEN: <leader>flr (solo minúsculas)

❌ MAL:  <leader>gB  (requiere Shift)  
✅ BIEN: <leader>gbl (solo minúsculas)
```

**Excepción única:** `<S-h>` y `<S-l>` para buffers (convención Vim estándar)

---

### 2. **Agrupación por Prefijo** 🗂️
Comandos relacionados deben compartir prefijo:

```vim
✅ Git Blame:    gb, gbl, gbr, gbc  (bajo gb*)
✅ Git Stage:    gsa, gsr, gsu, gsp (bajo gs*)
✅ Git History:  gh, ghd           (bajo gh*)
✅ Flutter:      flr, fls, fld     (bajo fl*)
✅ Testing:      ten, tef, tea     (bajo te*)
```

**Beneficio:** Autocompletado inteligente + memorización fácil

---

### 3. **Nombre = Acción** 🎯
El shortcut debe ser mnemónico:

```vim
✅ BIEN: gb  = Git Blame
✅ BIEN: gc  = Git Commit  
✅ BIEN: gl  = Git Load/pull
✅ BIEN: gp  = Git Push
✅ BIEN: gsa = Git Stage Add

❌ MAL:  gv  = ¿Git... Voom? (no tiene sentido)
❌ MAL:  cx  = ¿? (no intuitivo)
```

---

### 4. **2 Teclas > 3 Teclas** ⚡
Siempre preferir menos teclas:

```vim
✅ MEJOR: gl  (2 teclas)
❌ PEOR:  gpl (3 teclas)

✅ MEJOR: gp  (2 teclas)
❌ PEOR:  gps (3 teclas)

✅ MEJOR: gb  (2 teclas)  
❌ PEOR:  gbl (3 teclas, pero necesario para especificar)
```

**Regla:** Usar 3+ teclas solo si evita conflictos

---

### 5. **Sin Duplicados** 🚫
Cada comando debe ser único:

```vim
❌ MAL:  gd (LSP) Y <leader>gd (Git)
✅ BIEN: gd (LSP), <leader>gd (Git) - SOLO si son diferentes contextos

❌ MAL:  gi (LSP) Y <leader>gi (LSP duplicado)
✅ BIEN: gi (LSP solo) - sin duplicado con leader
```

**Regla:** Un comando = una acción

---

## 📋 Sistema de Prefijos Establecido

### **`<leader>g*`** - Git Operations
```vim
Core:       gs, gc, gp, gl, gf
Blame:      gb, gbl, gbt
Branches:   gbr, gbc
History:    gh, ghd
Diff:       gd, gdo, gdq, gdl, gdh, gdf
Stage:      gsa, gsr, gsu, gsp, gsb
Navigation: gn, gnp
Conflicts:  gco, gct, gcb, gcn, gcp, gcnn
```
**Total: 28 comandos**

---

### **`<leader>f*`** - Find/Telescope
```vim
Main:    ff, fg, fo, fb, fh, fc, fk, fp, fr, fs
Quick:   ., ,,
```
**Total: 12 comandos**

---

### **`<leader>fl*`** - Flutter
```vim
flr, fls, fld, flq, fle, flsd, flo, flc, flp, fll, fla
```
**Total: 11 comandos**

---

### **`<leader>te*`** - Testing
```vim
ten, tef, tea, tel
```
**Total: 4 comandos**

---

### **`<leader>t*`** - Terminal
```vim
tf, th, tv, tg, tn, tp
```
**Total: 6 comandos**

---

### **`<leader>b*`** - Buffers
```vim
bd, bn, bp, bl, br, bq
Special: <S-h>, <S-l>
```
**Total: 8 comandos**

---

### **`<leader>p*`** - Project/Explorer
```vim
pv, pf, pe
```
**Total: 3 comandos**

---

### **`<leader>r*`** - Run/Debug
```vim
rr, rd, rs, rb, rn (rename)
```
**Total: 5 comandos**

---

### **`<leader>w*`** - Windows
```vim
wh, wj, wk, wl, ws
```
**Total: 5 comandos**

---

### **Sin Leader** - LSP Core (más rápido)
```vim
gd  = goto definition
gi  = goto implementation
gr  = goto references
K   = hover documentation
```
**Total: 4 comandos**

---

### **`<leader>*`** - LSP Actions
```vim
ca  = code action
rn  = rename
fm  = format
```
**Total: 3 comandos**

---

## ✅ Checklist al Crear un Nuevo Comando

Antes de agregar un shortcut, verifica:

- [ ] ¿Usa SOLO minúsculas? (sin Shift)
- [ ] ¿El nombre es mnemónico? (comando = acción)
- [ ] ¿Está agrupado con comandos relacionados?
- [ ] ¿Es el más corto posible? (2 > 3 teclas)
- [ ] ¿NO duplica otro comando existente?
- [ ] ¿Está documentado en este archivo?
- [ ] ¿Está sincronizado en nvim E ideavimrc?

---

## 🔧 Ejemplos Prácticos

### **Ejemplo 1: Agregar comando Git nuevo**

```vim
# Necesitas: Git stash

# ❌ MAL:
<leader>gS  (usa mayúscula)
<leader>x   (no relacionado con git)

# ✅ BIEN:
<leader>gst (Git STash)

# Razón:
- Minúsculas ✓
- Bajo g* (git) ✓  
- Obvio (st = stash) ✓
```

---

### **Ejemplo 2: Agregar comando Flutter nuevo**

```vim
# Necesitas: Flutter analyze

# ❌ MAL:
<leader>Fa  (usa mayúscula)
<leader>a   (no específico)

# ✅ BIEN:
<leader>fla (FLutter Analyze)

# Razón:
- Minúsculas ✓
- Bajo fl* (flutter) ✓
- 3 letras pero necesario ✓
```

---

### **Ejemplo 3: Evitar conflicto**

```vim
# Conflicto: gl ya es Git Pull
# Necesitas: Go to Last location

# ❌ MAL:
<leader>gl  (conflicto con git)

# ✅ BIEN:
<C-o>       (navegación Vim nativa)
<leader>gb  (Go Back - si no hay conflicto)

# Razón:
- Usa comandos nativos cuando sea posible
- Evita conflictos reales
```

---

## 🚫 Anti-Patrones (NO hacer)

### 1. **Mayúsculas Innecesarias**
```vim
❌ <leader>Fr  → flr  
❌ <leader>T   → ten
❌ <leader>gB  → gbl
```

### 2. **Nombres Crípticos**
```vim
❌ <leader>gv  (git... ¿qué?)
❌ <leader>cx  (¿qué hace?)
❌ <leader>zx  (sin contexto)
```

### 3. **Comandos Largos Sin Razón**
```vim
❌ <leader>gpl  → gl (pull)
❌ <leader>gps  → gp (push)
❌ <leader>gds  → gd (diff)
```

### 4. **Duplicados**
```vim
❌ gd Y <leader>gd (mismo comando LSP)
❌ gi Y <leader>I  (mismo comando LSP)
```

### 5. **Sin Agrupación**
```vim
❌ gb, hs, hR, hP  (hunks esparcidos)
✅ gb, gsa, gsr, gsb (hunks bajo gs*)
```

---

## 📊 Tabla de Decisión Rápida

| Pregunta | SÍ | NO |
|----------|----|----|
| ¿Usa mayúsculas? | ❌ Cambiar | ✅ OK |
| ¿Nombre obvio? | ✅ OK | ❌ Renombrar |
| ¿Agrupado lógicamente? | ✅ OK | ❌ Reorganizar |
| ¿Duplica otro comando? | ❌ Eliminar | ✅ OK |
| ¿2-3 teclas máximo? | ✅ OK | ❌ Acortar |

---

## 🔄 Proceso de Cambio

### Al modificar shortcuts existentes:

1. **Actualizar nvim:** `lua/plugins/*.lua`
2. **Sincronizar ideavimrc:** `~/.ideavimrc`
3. **Documentar:** Actualizar este archivo
4. **Actualizar tablas:** `KEYMAP_ANALYSIS.md`
5. **Testing:** Probar en ambos editores
6. **Commit:** Con changelog detallado

---

## 📝 Template para Documentar Nuevo Comando

```markdown
### Comando: <nombre>
**Shortcut:** `<leader>xyz`  
**Plugin:** nombre-plugin  
**Categoría:** Git/LSP/Flutter/etc  
**Acción:** Descripción breve  
**Lógica:** X-Y-Z = **X**xx **Y**yy **Z**zz

**Ejemplo:**
- nvim: `<leader>xyz`
- ideavimrc: `:action AccionIntelliJ`
```

---

## 🎓 Filosofía del Sistema

### **Velocidad**
- Menos teclas = más rápido
- Sin Shift = manos en posición home

### **Consistencia**
- 100% minúsculas (músculo memoria)
- Agrupación lógica (autocompletado)

### **Intuición**
- Nombres mnemónicos (fácil memorizar)
- Comando = acción (obvio qué hace)

### **Mantenibilidad**
- Sin duplicados (fácil auditar)
- Documentado (fácil extender)

---

## 🔗 Referencias

- `KEYMAP_ANALYSIS.md` - Lista completa de 88 comandos
- `SHORTCUT_MIGRATION_STATUS.md` - Estado de migración
- `README.md` - Documentación principal
- `OPTIMIZATION_CHANGELOG.md` - Historial de cambios

---

**🎯 Regla de Oro:** Si un comando no sigue estas directrices, debería ser refactorizado.

**📌 Mantra:** Minúsculas, Agrupadas, Obvias, Únicas, Cortas.
