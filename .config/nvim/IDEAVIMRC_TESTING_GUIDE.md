# 🧪 **Guía Completa de Testing para .ideavimrc**

## 📋 **Todos los 148 Comandos Sincronizados para Verificar**

### 🎯 **Instrucciones de Testing:**
1. **Abrir IntelliJ IDEA/Android Studio**
2. **Verificar que IdeaVim está habilitado** (Settings → Plugins → IdeaVim)
3. **Confirmar que `.ideavimrc` está cargado** (debería mostrar números de línea y configuración)
4. **Probar cada comando** según el contexto indicado
5. **Marcar ✅ los que funcionan, ❌ los que no**

---

## 🔧 **1. Configuración Básica y Navegación Core**

### **Mapeos Fundamentales**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `jj` | Salir de modo inserción | En modo INSERT, escribir `jj` | Debe salir a modo NORMAL sin abrir búsqueda | ⬜ |
| `<leader><space>` | Ocultar ventana activa | Con ventana/panel abierto, `<space><space>` | Oculta la ventana/panel actual | ⬜ |

### **Navegación Básica**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>b` | Ir hacia atrás (historial) | Navegar entre archivos, luego `<space>b` | Va al archivo anterior | ⬜ |
| `<leader>f` | Ir hacia adelante (historial) | Después de `<leader>b`, probar `<space>f` | Va al archivo siguiente | ⬜ |

### **Navegación entre Ventanas**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>wh` | Ir a ventana izquierda | Con splits abiertos, `<space>wh` | Cursor va a ventana izquierda | ⬜ |
| `<leader>wj` | Ir a ventana abajo | Con splits abiertos, `<space>wj` | Cursor va a ventana inferior | ⬜ |
| `<leader>wk` | Ir a ventana arriba | Con splits abiertos, `<space>wk` | Cursor va a ventana superior | ⬜ |
| `<leader>wl` | Ir a ventana derecha | Con splits abiertos, `<space>wl` | Cursor va a ventana derecha | ⬜ |

### **Edición de Texto**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `Alt+j` | Mover línea abajo | En cualquier línea, `Alt+j` | Línea se mueve hacia abajo | ⬜ |
| `Alt+k` | Mover línea arriba | En cualquier línea, `Alt+k` | Línea se mueve hacia arriba | ⬜ |
| `>` | Indentar selección | Seleccionar texto, presionar `>` | Texto se indenta a la derecha | ⬜ |
| `<` | Des-indentar selección | Seleccionar texto, presionar `<` | Texto se indenta a la izquierda | ⬜ |

---

## 🔭 **2. Telescope - Búsqueda y Navegación (10 comandos)**

### **Comandos Principales de Búsqueda**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>ff` | **COMANDO PRINCIPAL** - Find Files | `<space>ff` en proyecto | Abre diálogo "Go to File" | ⬜ |
| `<leader>fg` | Buscar texto en proyecto | `<space>fg` | Abre "Find in Path" | ⬜ |
| `<leader>fo` | Archivos recientes | `<space>fo` | Abre "Recent Files" | ⬜ |
| `<leader>fb` | Cambiar entre buffers | `<space>fb` | Abre "Switcher" (Ctrl+Tab) | ⬜ |
| `<leader>fh` | Buscar en ayuda | `<space>fh` | Abre "Help Topics" | ⬜ |
| `<leader>fc` | Buscar comandos | `<space>fc` | Abre "Go to Action" (Ctrl+Shift+A) | ⬜ |
| `<leader>fk` | Buscar keymaps/actions | `<space>fk` | Abre "Go to Action" (Ctrl+Shift+A) | ⬜ |
| `<leader>ps` | Buscar símbolos | `<space>ps` | Abre "Go to Symbol" | ⬜ |

### **Accesos Rápidos Alternativos**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader><leader>` | Quick find files | `<space><space>` | Same as `<leader>ff` | ⬜ |
| `<leader>.` | Quick find files | `<space>.` | Same as `<leader>ff` | ⬜ |
| `,,` | Quick find files | `,,` (coma doble) | Same as `<leader>ff` | ⬜ |

---

## 📂 **3. Neo-tree - Navegación de Proyecto (4 comandos)**

| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>pv` | **COMANDO PRINCIPAL** - Toggle project tree | `<space>pv` | Abre/cierra Project Tool Window | ⬜ |
| `<leader>fr` | Revelar archivo actual en árbol | Con archivo abierto, `<space>fr` | Selecciona archivo actual en project tree | ⬜ |
| `<leader>we` | Focus editor window | `<space>we` | Enfoca siguiente splitter | ⬜ |
| `<leader>wt` | Focus tree window | `<space>wt` | Enfoca splitter anterior | ⬜ |

---

## 📌 **4. Harpoon - Marcas Rápidas (15 comandos)**

### **Gestión de Marcas**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>ma` | Agregar bookmark | En cualquier archivo, `<space>ma` | Toggle bookmark en línea actual | ⬜ |
| `<leader>mm` | Toggle harpoon menu | `<space>mm` | Abre ventana de Bookmarks reales | ⬜ |
| `<leader>mb` | Mostrar bookmarks | `<space>mb` | Abre ventana de bookmarks | ⬜ |
| `<leader>mp` | Harpoon anterior | `<space>mp` | Va a tab anterior | ⬜ |
| `<leader>mn` | Harpoon siguiente | `<space>mn` | Va a tab siguiente | ⬜ |

### **Navegación Directa**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>1` | Ir a marca 1 | Crear marca con `m1`, luego `<space>1` | Va a marca 1 | ⬜ |
| `<leader>2` | Ir a marca 2 | Crear marca con `m2`, luego `<space>2` | Va a marca 2 | ⬜ |
| `<leader>3` | Ir a marca 3 | Crear marca con `m3`, luego `<space>3` | Va a marca 3 | ⬜ |
| `<leader>4` | Ir a marca 4 | Crear marca con `m4`, luego `<space>4` | Va a marca 4 | ⬜ |
| `<leader>5` | Ir a marca 5 | Crear marca con `m5`, luego `<space>5` | Va a marca 5 | ⬜ |
| `<leader>6` | Ir a marca 6 | Crear marca con `m6`, luego `<space>6` | Va a marca 6 | ⬜ |
| `<leader>7` | Ir a marca 7 | Crear marca con `m7`, luego `<space>7` | Va a marca 7 | ⬜ |
| `<leader>8` | Ir a marca 8 | Crear marca con `m8`, luego `<space>8` | Va a marca 8 | ⬜ |
| `<leader>9` | Ir a marca 9 | Crear marca con `m9`, luego `<space>9` | Va a marca 9 | ⬜ |

---

## ⚡ **5. Buffer y Tab Management (12 comandos)**

### **Navegación de Buffers/Tabs**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `Shift+l` | **PRINCIPAL** - Siguiente tab | Con múltiples tabs, `Shift+l` | Va a siguiente tab | ⬜ |
| `Shift+h` | **PRINCIPAL** - Tab anterior | Con múltiples tabs, `Shift+h` | Va a tab anterior | ⬜ |
| `<leader>bn` | Buffer siguiente | `<space>bn` | Mismo que `Shift+l` | ⬜ |
| `<leader>bp` | Buffer anterior | `<space>bp` | Mismo que `Shift+h` | ⬜ |

### **Gestión de Tabs**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>bd` | Cerrar buffer actual | `<space>bd` | Cierra tab actual | ⬜ |
| `<leader>bl` | Cerrar tabs a la derecha | `<space>bl` | Cierra todos los tabs a la derecha | ⬜ |
| `<leader>bh` | Cerrar tabs a la izquierda | `<space>bh` | Cierra todos los tabs a la izquierda | ⬜ |
| `<leader>to` | Cerrar otros tabs | `<space>to` | Cierra todos los tabs excepto actual | ⬜ |

### **Navegación entre Splits**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<space>l` | Siguiente split | Con splits, `<space>l` | Va a siguiente splitter | ⬜ |
| `<space>h` | Split anterior | Con splits, `<space>h` | Va a splitter anterior | ⬜ |

---

## 💻 **6. Terminal Integrada (4 comandos)**

| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>tt` | **PRINCIPAL** - Activate terminal | `<space>tt` | Abre/enfoca Terminal Tool Window | ⬜ |
| `<leader>th` | Terminal horizontal (ventana abajo) | `<space>th` | Abre terminal en ventana inferior | ⬜ |
| `<leader>tv` | Terminal en directorio actual | `<space>tv` | Abre nueva terminal en directorio actual | ⬜ |
| `<leader>tf` | Nueva sesión terminal | `<space>tf` | Abre nueva sesión de terminal | ⬜ |

**Nota**: En terminal mode, usar `Esc Esc` (doble escape) para volver al editor.

---

## 🔄 **7. Git/VCS Operations (30 comandos)**

### **Comandos Git Principales**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>gs` | **PRINCIPAL** - Git status | `<space>gs` | Abre Version Control Tool Window | ⬜ |
| `<leader>gc` | Git commit | `<space>gc` | Abre diálogo de commit | ⬜ |
| `<leader>gps` | Git push | `<space>gps` | Ejecuta git push | ⬜ |
| `<leader>gpl` | Git pull | `<space>gpl` | Ejecuta git pull/update | ⬜ |

### **Git Blame y Historial**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>gv` | **CRÍTICO** - Git blame toggle | `<space>gv` | Muestra/oculta git blame en gutter | ⬜ |
| `<leader>gl` | Git log/historial archivo | `<space>gl` | Abre historial del archivo actual | ⬜ |
| `<leader>gC` | Git historial detallado | `<space>gC` | Abre detalles de historial Git | ⬜ |

### **Navegación Git Hunks**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>gn` | Siguiente hunk | En archivo modificado, `<space>gn` | Va al siguiente cambio | ⬜ |
| `<leader>gN` | Hunk anterior | En archivo modificado, `<space>gN` | Va al cambio anterior | ⬜ |

### **GitSigns Operations**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>hs` | Shelve changes | En archivo modificado, `<space>hs` | Envía cambios a shelve | ⬜ |
| `<leader>ga` | Git shelve (alternativo) | `<space>ga` | Mismo que `<leader>hs` | ⬜ |
| `<leader>hr` | Reset hunk | En archivo modificado, `<space>hr` | Revierte cambios en línea | ⬜ |
| `<leader>hu` | Undo stage hunk | `<space>hu` | Revierte staging de cambios | ⬜ |
| `<leader>hR` | Reset buffer | `<space>hR` | Revierte todos los cambios del archivo | ⬜ |

### **Diffview Operations**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>gdo` | Open diffview | `<space>gdo` | Abre diff con versión anterior | ⬜ |
| `<leader>gdc` | Close diffview | `<space>gdc` | Cierra diff/content actual | ⬜ |
| `<leader>gdd` | Show local changes | `<space>gdd` | Muestra cambios locales del proyecto | ⬜ |
| `<leader>gds` | Git diff split | `<space>gds` | Abre diff en split | ⬜ |

### **Git Conflict Resolution**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>co` | Choose ours | En conflicto merge, `<space>co` | Acepta versión local | ⬜ |
| `<leader>ct` | Choose theirs | En conflicto merge, `<space>ct` | Acepta versión remota | ⬜ |
| `<leader>cb` | Choose both | En conflicto merge, `<space>cb` | Acepta ambas versiones | ⬜ |
| `<leader>c0` | Choose none | En conflicto merge, `<space>c0` | Rechaza ambas versiones | ⬜ |

### **Git Operations Adicionales**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>gf` | Git fetch | `<space>gf` | Ejecuta git fetch | ⬜ |
| `<leader>gb` | Git branches | `<space>gb` | Abre popup de branches | ⬜ |
| `<leader>gcb` | Compare with branch | `<space>gcb` | Compara con otra rama | ⬜ |

---

## 🔧 **8. LSP y Desarrollo (16 comandos)**

### **Navegación LSP Básica**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `K` | **PRINCIPAL** - Show documentation | Cursor en función/variable, `K` | Muestra documentación popup | ⬜ |
| `gd` | **PRINCIPAL** - Go to definition | Cursor en función, `gd` | Va a definición | ⬜ |
| `gi` | Go to implementation | Cursor en interface, `gi` | Va a implementación | ⬜ |
| `go` | Go to type definition | Cursor en variable, `go` | Va a definición del tipo (CORREGIDO) | ⬜ |
| `gr` | Find references | Cursor en símbolo, `gr` | Muestra todas las referencias | ⬜ |
| `gs` | Parameter info | Cursor en llamada función, `gs` | Muestra info de parámetros | ⬜ |

### **⚠️ LSP con Leader Key - ELIMINADOS**
**Comandos duplicados eliminados**: `<leader>gD`, `<leader>gi`, `<leader>gr`, `<leader>gT`, `<leader>lh`, `<leader>ls`
**Usar directamente**: `gd`, `gi`, `gr`, `go`, `K`, `gs` (más eficientes sin leader)

### **Acciones de Código**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>ca` | **PRINCIPAL** - Code actions | Cursor en error/warning, `<space>ca` | Muestra menú de quick fixes | ⬜ |
| `<leader>rn` | **PRINCIPAL** - Rename symbol | Cursor en variable, `<space>rn` | Permite renombrar símbolo | ⬜ |
| `<leader>lf` | **PRINCIPAL** - Optimize imports | `<space>lf` | Optimiza imports y respeta ktlint del proyecto | ⬜ |
| `<leader>lw` | List workspace bookmarks | `<space>lw` | Muestra panel de bookmarks del workspace | ⬜ |

---

## 🔧 **9. Trouble - Diagnósticos y Errores (6 comandos)**

| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>xx` | **PRINCIPAL** - Toggle Trouble | `<space>xx` | Abre Problems View | ⬜ |
| `<leader>xw` | Workspace diagnostics | `<space>xw` | Mismo que `<leader>xx` | ⬜ |
| `<leader>xd` | Document diagnostics | `<space>xd` | Mismo que `<leader>xx` | ⬜ |
| `<leader>xl` | Location list | `<space>xl` | Mismo que `<leader>xx` | ⬜ |
| `<leader>xq` | Quickfix list | `<space>xq` | Mismo que `<leader>xx` | ⬜ |
| `<leader>xn` | Siguiente error | `<space>xn` | Va al siguiente error | ⬜ |
| `<leader>xp` | Error anterior | `<space>xp` | Va al error anterior | ⬜ |

---

## 📱 **10. Flutter Development (9 comandos)**

| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>Fs` | **PRINCIPAL** - Flutter start | En proyecto Flutter, `<space>Fs` | Ejecuta aplicación (Run) | ⬜ |
| `<leader>Fr` | Flutter hot reload | Con Flutter corriendo, `<space>Fr` | Hace hot reload (Cmd+\) | ⬜ |
| `<leader>FR` | Flutter hot restart | Con Flutter corriendo, `<space>FR` | Hace hot restart (Shift+Cmd+\) | ⬜ |
| `<leader>Fq` | Flutter quit/stop | Con Flutter corriendo, `<space>Fq` | Para la aplicación (Stop) | ⬜ |
| `<leader>Fd` | Flutter DevTools | `<space>Fd` | Abre Flutter DevTools | ⬜ |
| `<leader>FD` | Flutter devices | `<space>FD` | Abre selector de dispositivos | ⬜ |
| `<leader>Fe` | Flutter emulators | `<space>Fe` | Abre AVD Manager | ⬜ |
| `<leader>Fo` | Flutter outline | `<space>Fo` | Abre Structure tool window | ⬜ |
| `<leader>Fc` | Flutter clear log | `<space>Fc` | Limpia logcat console | ⬜ |

---

## 🧪 **11. Testing Commands (4 comandos)**

| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>T` | **PRINCIPAL** - Run/Test class | En archivo, `<space>T` | Ejecuta clase actual (también funciona para test) | ⬜ |
| `<leader>Tf` | Run/Test file | `<space>Tf` | Ejecuta configuración actual | ⬜ |
| `<leader>Ta` | Test all suite | `<space>Ta` | Ejecuta todos los tests del proyecto | ⬜ |
| `<leader>Tl` | Test last | `<space>Tl` | Re-ejecuta último test/run | ⬜ |

---

## 🏗️ **12. Build y Run Commands (8 comandos)**

### **Ejecución**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>rr` | **PRINCIPAL** - Run class | `<space>rr` | Ejecuta clase actual | ⬜ |
| `<leader>rd` | Debug | `<space>rd` | Inicia debug | ⬜ |
| `<leader>rs` | Stop | `<space>rs` | Para ejecución actual | ⬜ |
| `<leader>rb` | Build project | `<space>rb` | Sincroniza/build proyecto Android | ⬜ |
| `<leader>rp` | Run project | `<space>rp` | Ejecuta proyecto completo | ⬜ |

### **Overseer/Task Management**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>oo` | Toggle run window | `<space>oo` | Abre Run Tool Window | ⬜ |
| `<leader>oi` | Edit configurations | `<space>oi` | Abre configuraciones de ejecución | ⬜ |
| `<leader>oq` | Quick run action | `<space>oq` | Ejecuta clase actual | ⬜ |

---

## 🪟 **13. Window y Split Management (10 comandos)**

### **Crear Splits**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>sv` | Split vertical | `<space>sv` | Crea split vertical | ⬜ |
| `<leader>sh` | Split horizontal | `<space>sh` | Crea split horizontal | ⬜ |
| `<leader>sr` | Split right | `<space>sr` | Mismo que `<leader>sv` | ⬜ |
| `<leader>sc` | Close split | `<space>sc` | Cierra split actual | ⬜ |
| `<leader>so` | Close all splits | `<space>so` | Cierra todos los splits excepto actual | ⬜ |
| `<leader>_` | Maximize split | `<space>_` | Maximiza/restaura split actual | ⬜ |

### **Window Movement**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>wm` | Move window | Con splits, `<space>wm` | Mueve editor a grupo opuesto | ⬜ |
| `<leader>ws` | Swap window | Con splits, `<space>ws` | Mueve editor a grupo de tabs opuesto | ⬜ |

---

## 📋 **14. Utilidades y Comandos Especiales (12 comandos)**

### **Plegado/Folding**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>za` | Toggle fold | En código con bloques, `<space>za` | Alterna plegado | ⬜ |
| `<leader>zR` | Expand all | `<space>zR` | Expande todos los folds | ⬜ |
| `<leader>zM` | Collapse all | `<space>zM` | Colapsa todos los folds | ⬜ |
| `<leader>zr` | Expand region | `<space>zr` | Expande región actual | ⬜ |
| `<leader>zm` | Collapse region | `<space>zm` | Colapsa región actual | ⬜ |

### **Comentarios**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `gcc` | Toggle line comment | En línea de código, `gcc` | Comenta/descomenta línea | ⬜ |
| `gc` | Comment selection | Seleccionar texto, `gc` | Comenta/descomenta selección | ⬜ |

### **Historial y Sesiones**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>u` | Show local history | `<space>u` | Abre historial local del archivo | ⬜ |
| `<leader>qs` | Restore session | `<space>qs` | Restaura sesión guardada | ⬜ |
| `<leader>ql` | Restore last session | `<space>ql` | Restaura última sesión | ⬜ |
| `<leader>qd` | Don't save session | `<space>qd` | No guarda sesión actual | ⬜ |

### **Project Management**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>fp` | Find projects | `<space>fp` | Abre manager de proyectos recientes | ⬜ |
| `<leader>zz` | Zen mode/Full screen | `<space>zz` | Toggle modo fullscreen | ⬜ |

### **Vistas Rápidas**
| Comando | Qué hace | Contexto para probar | Resultado esperado |
|---------|----------|---------------------|-------------------|
| `<leader>I` | Quick implementations | Cursor en interface, `<space>I` | Muestra implementaciones rápidas | ⬜ |

---

## ✅ **Hoja de Resultados - Resumen por Categorías**

### **Estadísticas de Testing:**
- **Configuración Básica:** ___/4 funcionando
- **Telescope (Búsqueda):** ___/12 funcionando
- **Neo-tree (Proyecto):** ___/4 funcionando
- **Harpoon (Marcas):** ___/15 funcionando
- **Buffer Management:** ___/12 funcionando
- **Terminal:** ___/4 funcionando
- **Git Operations:** ___/30 funcionando
- **LSP y Desarrollo:** ___/16 funcionando
- **Trouble (Errores):** ___/7 funcionando
- **Flutter Development:** ___/8 funcionando
- **Testing:** ___/4 funcionando
- **Build y Run:** ___/8 funcionando
- **Window Management:** ___/8 funcionando
- **Utilidades:** ___/14 funcionando

### **🎯 TOTAL ESPERADO: 141 comandos funcionando** *(7 comandos duplicados eliminados)*

---

## 🚨 **Comandos Críticos que DEBEN Funcionar:**

### **🔥 Top Priority (Si estos fallan, hay problema serio):**
1. `<leader>ff` - Find Files ⬜
2. `<leader>fg` - Find in Path ⬜
3. `<leader>gv` - Git Blame Toggle ⬜
4. `<leader>pv` - Toggle Project Tree ⬜
5. `K` - Show Documentation ⬜
6. `gd` - Go to Definition ⬜
7. `<leader>ca` - Code Actions ⬜

### **🔶 High Priority:**
- `<leader>gs` - Git Status ⬜
- `<leader>rn` - Rename Symbol ⬜
- `<leader>xx` - Problems View ⬜
- `Shift+h/l` - Tab Navigation ⬜

---

## 📝 **Notas de Testing:**
- Algunos comandos requieren contexto específico (ej: Flutter commands necesitan proyecto Flutter)
- Git commands necesitan repositorio git inicializado
- LSP commands necesitan archivos con código válido
- Ciertos comandos pueden tener comportamiento ligeramente diferente pero funcional

## 🔧 **Cambios v4.1 - Correcciones Post-Testing:**
- ✅ **jj arreglado** - Ya no abre búsqueda, solo sale de insert mode
- ✅ **<space><space>** - Cambiado a HideActiveWindow
- ✅ **<leader>fk** - Cambiado a GotoAction (buscar acciones)
- ✅ **<leader>mm** - Cambiado a ShowBookmarks reales
- ✅ **Terminal Escape** - Doble Esc para volver al editor
- ✅ **Git Shelve** - <leader>hs/ga ahora usan shelve en lugar de staging
- ✅ **Flutter Actions** - Actualizados con acciones reales de Android Studio
- ✅ **LSP Duplicados** - Eliminados 6 comandos redundantes con leader
- ✅ **Format** - <leader>lf ahora optimiza imports y respeta ktlint
- ❌ **gB eliminado** - Solo usar <leader>gv para git blame
- 🔧 **Total**: 141 comandos (7 duplicados eliminados)

**¡Marca ✅ los que funcionan y ❌ los que no para tener un reporte completo!** 🧪