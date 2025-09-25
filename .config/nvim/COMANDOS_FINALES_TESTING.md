# 🧪 **Lista Final de Comandos para Testing v4.2**

## ✅ **PROBLEMAS RESUELTOS:**

1. ✅ **`jj` arreglado** - `inoremap jj <Esc>` (no abre búsqueda)
2. ✅ **`<space><space>` corregido** - `:nohl<CR>` (limpia highlight)
3. ✅ **Terminal Escape** - `Esc Esc` usa `<C-\><C-n>` (funciona)
4. ✅ **Terminal diferenciado:**
   - `<leader>tt` - ActivateTerminalToolWindow (principal)
   - `<leader>tv` - OpenTerminalInSplitter (split vertical)
   - `<leader>tf` - Terminal.NewSession (nueva sesión)
5. ✅ **9 duplicados eliminados**

---

## 🎯 **COMANDOS CRÍTICOS QUE DEBES PROBAR PRIMERO:**

### **🔥 TOP PRIORITY (Si fallan, hay problema serio):**
1. `jj` - Salir de INSERT mode ⬜
2. `<space><space>` - Limpiar búsqueda highlight ⬜
3. `<space>ff` - Find Files ⬜
4. `<space>fg` - Find in Path ⬜
5. `<space>gv` - Git Blame Toggle ⬜
6. `<space>mm` - Mostrar Bookmarks ⬜
7. `<space>tt` - Terminal principal ⬜
8. `Esc Esc` - Salir de terminal ⬜

---

## 📋 **COMANDOS POR CATEGORÍA**

### **🔧 1. Configuración Básica (3 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `jj` | Salir de INSERT | En modo INSERT, escribir `jj` ⬜ |
| `<leader><space>` | Limpiar highlight | Buscar `/algo`, luego `<space><space>` ⬜ |
| `<leader>b` | Go back | Navegar archivos, `<space>b` ⬜ |
| `<leader>f` | Go forward | Después de back, `<space>f` ⬜ |

### **🔭 2. Telescope - Búsqueda (11 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>ff` | **PRINCIPAL** Find Files | `<space>ff` ⬜ |
| `<leader>fg` | Find in Path (grep) | `<space>fg` ⬜ |
| `<leader>fo` | Recent Files | `<space>fo` ⬜ |
| `<leader>fb` | Switch buffers | `<space>fb` ⬜ |
| `<leader>fh` | Help topics | `<space>fh` ⬜ |
| `<leader>fc` | Find commands/actions | `<space>fc` ⬜ |
| `<leader>fr` | Reveal in project | `<space>fr` ⬜ |
| `<leader>ps` | Find symbols | `<space>ps` ⬜ |
| `<leader>fp` | Find projects | `<space>fp` ⬜ |
| `<leader><leader>` | Quick files | `<space><space>` (sin espacio entre) ⬜ |
| `<leader>.` | Quick files alt | `<space>.` ⬜ |

### **📂 3. Proyecto y Navegación (4 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>pv` | **PRINCIPAL** Toggle project | `<space>pv` ⬜ |
| `<leader>wh/j/k/l` | Navigate windows | Con splits, `<space>wh` etc ⬜ |
| `<leader>we` | Focus next splitter | `<space>we` ⬜ |
| `<leader>wt` | Focus prev splitter | `<space>wt` ⬜ |

### **📌 4. Bookmarks/Harpoon (12 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>ma` | Add bookmark | `<space>ma` ⬜ |
| `<leader>mm` | **CORREGIDO** Show bookmarks | `<space>mm` ⬜ |
| `<leader>1-9` | Go to mark | Crear `m1`, luego `<space>1` ⬜ |

### **⚡ 5. Buffer Management (6 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `Shift+h` | **PRINCIPAL** Previous tab | `Shift+h` ⬜ |
| `Shift+l` | **PRINCIPAL** Next tab | `Shift+l` ⬜ |
| `<leader>bn` | Next tab (leader) | `<space>bn` ⬜ |
| `<leader>bp` | Previous tab (leader) | `<space>bp` ⬜ |
| `<leader>bd` | Close tab | `<space>bd` ⬜ |
| `<leader>bl/bh` | Close tabs left/right | `<space>bl` ⬜ |

### **💻 6. Terminal (3 comandos) - CORREGIDOS**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>tt` | **PRINCIPAL** Terminal | `<space>tt` ⬜ |
| `<leader>tv` | **CORREGIDO** Terminal split | `<space>tv` ⬜ |
| `<leader>tf` | **CORREGIDO** New terminal | `<space>tf` ⬜ |
| `Esc Esc` | **CORREGIDO** Exit terminal | En terminal, `Esc Esc` ⬜ |

### **🔄 7. Git Operations (22 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>gs` | Git status | `<space>gs` ⬜ |
| `<leader>gc` | Git commit | `<space>gc` ⬜ |
| `<leader>gv` | **CRÍTICO** Git blame | `<space>gv` ⬜ |
| `<leader>gps` | Git push | `<space>gps` ⬜ |
| `<leader>gpl` | Git pull | `<space>gpl` ⬜ |
| `<leader>gf` | Git fetch | `<space>gf` ⬜ |
| `<leader>gb` | Git branches | `<space>gb` ⬜ |
| `<leader>hs` | **CORREGIDO** Shelve changes | `<space>hs` ⬜ |
| `<leader>ga` | **CORREGIDO** Git shelve | `<space>ga` ⬜ |
| `<leader>hr` | Reset hunk | `<space>hr` ⬜ |
| `<leader>gn/gN` | Next/Prev hunk | `<space>gn` ⬜ |

### **🔧 8. LSP & Development (8 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `K` | **PRINCIPAL** Show docs | Cursor en función, `K` ⬜ |
| `gd` | **PRINCIPAL** Go definition | Cursor en función, `gd` ⬜ |
| `gi` | Go implementation | `gi` ⬜ |
| `gr` | Find references | `gr` ⬜ |
| `<leader>ca` | **PRINCIPAL** Code actions | `<space>ca` ⬜ |
| `<leader>rn` | **PRINCIPAL** Rename | `<space>rn` ⬜ |
| `<leader>lf` | **CORREGIDO** Optimize imports | `<space>lf` ⬜ |
| `<leader>lw` | Show bookmarks | `<space>lw` ⬜ |

### **🔧 9. Trouble/Errors (6 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>xx` | **PRINCIPAL** Problems view | `<space>xx` ⬜ |
| `<leader>xw/xd/xl/xq` | Problems variants | `<space>xw` ⬜ |
| `<leader>xn/xp` | Next/prev error | `<space>xn` ⬜ |

### **📱 10. Flutter (9 comandos) - CORREGIDOS**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>Fs` | **CORREGIDO** Flutter start | `<space>Fs` ⬜ |
| `<leader>Fr` | **CORREGIDO** Hot reload | `<space>Fr` ⬜ |
| `<leader>FR` | **CORREGIDO** Hot restart | `<space>FR` ⬜ |
| `<leader>Fq` | **CORREGIDO** Flutter stop | `<space>Fq` ⬜ |
| `<leader>Fd` | Flutter DevTools | `<space>Fd` ⬜ |
| `<leader>FD` | Flutter devices | `<space>FD` ⬜ |
| `<leader>Fe` | Flutter emulators | `<space>Fe` ⬜ |
| `<leader>Fo` | Flutter outline | `<space>Fo` ⬜ |
| `<leader>Fc` | Flutter clear log | `<space>Fc` ⬜ |

### **🧪 11. Testing/Running (5 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>T` | **PRINCIPAL** Run class | `<space>T` ⬜ |
| `<leader>Tf` | **CORREGIDO** Run file | `<space>Tf` ⬜ |
| `<leader>Ta` | Run all tests | `<space>Ta` ⬜ |
| `<leader>Tl` | Rerun last | `<space>Tl` ⬜ |
| `<leader>rr` | Run class alt | `<space>rr` ⬜ |

### **🪟 12. Window Management (6 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>sv/sh` | Split vertical/horizontal | `<space>sv` ⬜ |
| `<leader>sc/so` | Close split/all splits | `<space>sc` ⬜ |
| `<leader>wm` | Move editor opposite | `<space>wm` ⬜ |
| `<leader>_` | Maximize split | `<space>_` ⬜ |

### **📋 13. Utilidades (8 comandos)**
| Comando | Qué hace | Prueba |
|---------|----------|---------|
| `<leader>u` | Local history | `<space>u` ⬜ |
| `gcc` | Toggle line comment | `gcc` ⬜ |
| `<leader>za/zR/zM` | Folding | `<space>za` ⬜ |
| `<leader>zz` | Fullscreen | `<space>zz` ⬜ |

---

## 📊 **ESTADÍSTICAS FINALES:**

### **Total de Comandos Funcionales: 132**
- **Configuración Básica:** 4
- **Telescope/Búsqueda:** 11
- **Proyecto/Navegación:** 4
- **Bookmarks/Harpoon:** 12
- **Buffer Management:** 6
- **Terminal:** 4
- **Git Operations:** 22
- **LSP & Development:** 8
- **Trouble/Errors:** 6
- **Flutter:** 9
- **Testing/Running:** 5
- **Window Management:** 6
- **Utilidades:** 8

### **⚠️ COMANDOS ELIMINADOS (9 duplicados):**
- ❌ `<leader>fk` (usar `<leader>fc`)
- ❌ `<leader>mb` (usar `<leader>mm`)
- ❌ `<leader>ws` (usar `<leader>wm`)
- ❌ `<leader>th` (usar `<leader>tt`)
- ❌ `<leader>hu` (usar `<leader>hr`)
- ❌ `<leader>sr` (usar `<leader>sv`)
- ❌ `<leader>mn` (usar `<leader>bn`)
- ❌ `<leader>mp` (usar `<leader>bp`)
- ❌ `<leader>oq` (usar `<leader>T`)

---

## ✅ **TESTING CHECKLIST:**

**Marcar ✅ los que funcionan, ❌ los que no:**

### **🔥 CRÍTICOS (deben funcionar):**
- [ ] `jj` sale de INSERT sin búsqueda
- [ ] `<space><space>` limpia highlight
- [ ] `<space>ff` abre Find Files
- [ ] `<space>gv` muestra Git blame
- [ ] `<space>mm` muestra bookmarks reales
- [ ] `Esc Esc` sale de terminal

### **⚡ IMPORTANTES:**
- [ ] `<space>fg` busca texto
- [ ] `<space>ca` code actions
- [ ] `<space>tt` terminal
- [ ] `<space>pv` project tree

**¡Probar todos los 132 comandos sistemáticamente!** 🧪