# ✅ COMANDOS CORREGIDOS Y LISTOS PARA PROBAR | CORRECTED COMMANDS READY TO TEST

> **Estado**: Post-corrección de acciones no funcionales
> **Total**: **113 comandos únicos corregidos**
> **Cambios**: 12 comandos corregidos + 2 comandos nuevos

---

## 🔥 **COMANDOS CORREGIDOS (12) - PROBAR ESTOS PRIMERO:**

### 🆕 **NUEVOS COMANDOS AGREGADOS (2)**

**📌 Acceso a Bookmarks:**
- `<leader>mb` → `:action ShowBookmarks`
  - **Contexto**: Después de crear bookmarks con `<leader>ma`
  - **Cómo usar**: `<Space>mb`
  - **Cuándo usar**: Ver lista de bookmarks creados
  - **Test**: Crea bookmark con `<Space>ma` → `<Space>mb` → debería mostrar bookmarks

**🪟 Split Right (más intuitivo):**
- `<leader>sr` → `:action SplitVertically`
  - **Contexto**: Con archivo abierto
  - **Cómo usar**: `<Space>sr`
  - **Cuándo usar**: Crear split a la derecha (más intuitivo que sv)
  - **Test**: En archivo → `<Space>sr` → debería crear split vertical

### 🌿 **GIT OPERATIONS CORREGIDOS (6)**

**36. `<leader>gn` → `:action VcsShowNextChangeMarker` (CORREGIDO)**
- **Contexto**: En archivo con cambios Git no commiteados
- **Test**: Modifica archivo → `<Space>gn` → debería ir al siguiente hunk

**37. `<leader>gN` → `:action VcsShowPrevChangeMarker` (CORREGIDO)**
- **Contexto**: En archivo con cambios Git no commiteados
- **Test**: Modifica archivo → `<Space>gN` → debería ir al hunk anterior

**38. `<leader>ga` → `:action Vcs.Add` (CORREGIDO)**
- **Contexto**: En proyecto Git con archivos modificados
- **Test**: Modifica archivo → `<Space>ga` → debería agregar a staging

**39. `<leader>gdo` → `:action Compare.LastVersion` (CORREGIDO)**
- **Contexto**: En archivo con cambios Git
- **Test**: Modifica archivo → `<Space>gdo` → debería mostrar diff

**44. `<leader>hR` → `:action ChangesView.Revert` (CORREGIDO)**
- **Contexto**: En archivo modificado
- **Test**: Modifica archivo → `<Space>hR` → debería revertir archivo

**45. `<leader>gdd` → `:action ActivateVersionControlToolWindow` (CORREGIDO)**
- **Contexto**: En proyecto Git con cambios
- **Test**: `<Space>gdd` → debería abrir panel Git

### 🔀 **FOLDING CORREGIDOS (5)**

**67. `<leader>za` → `:action ExpandCollapseToggleAction` (CORREGIDO)**
- **Contexto**: Cursor en región plegable
- **Test**: Cursor en método → `<Space>za` → debería toggle folding

**68. `<leader>zR` → `:action ExpandAllRegions` (CORREGIDO)**
- **Test**: `<Space>zR` → debería expandir todo

**69. `<leader>zM` → `:action CollapseAllRegions` (CORREGIDO)**
- **Test**: `<Space>zM` → debería colapsar todo

**70. `<leader>zr` → `:action ExpandRegion` (CORREGIDO)**
- **Test**: `<Space>zr` → debería expandir región actual

**71. `<leader>zm` → `:action CollapseRegion` (CORREGIDO)**
- **Test**: `<Space>zm` → debería colapsar región actual

### 🚀 **BUILD & RUN CORREGIDOS (2)**

**72. `<leader>rr` → `:action RunClass` (CORREGIDO)**
- **Contexto**: En clase con método main
- **Test**: En archivo con main → `<Space>rr` → debería ejecutar main (no tests)

**74. `<leader>rb` → `:action Android.SyncProject` (CORREGIDO)**
- **Contexto**: En proyecto Android
- **Test**: `<Space>rb` → debería hacer sync/build del proyecto Android

---

## ✅ **COMANDOS ELIMINADOS/CORREGIDOS:**

**❌ Duplicado eliminado:**
- `<leader>gu` → **REMOVIDO** (duplicaba `<leader>hu`)

---

## 📋 **LISTA COMPLETA FINAL DE 113 COMANDOS ÚNICOS:**

### 🔍 **BÚSQUEDA & NAVEGACIÓN (7 comandos)**
1. `,,` → `:action GotoFile`
2. `<leader>fg` → `:action FindInPath`
3. `<leader>fo` → `:action RecentFiles`
4. `<leader>fb` → `:action Switcher`
5. `<leader>fh` → `:action HelpTopics`
6. `<leader>fc` → `:action GotoAction`
7. `<leader>ps` → `:action GotoSymbol`

### 📁 **PROJECT & FILE EXPLORER (2 comandos)**
8. `<leader>pv` → `:action ActivateProjectToolWindow`
9. `<leader>fr` → `:action SelectInProjectView`

### 📌 **MARKS & BOOKMARKS (12 comandos)**
10. `<leader>mm` → `:action RecentFiles`
11. `<leader>ma` → `:action ToggleBookmark`
12. **🆕 `<leader>mb` → `:action ShowBookmarks`** (NUEVO)
13. `<leader>1` → `'1`
14. `<leader>2` → `'2`
15. `<leader>3` → `'3`
16. `<leader>4` → `'4`
17. `<leader>5` → `'5`
18. `<leader>6` → `'6`
19. `<leader>7` → `'7`
20. `<leader>8` → `'8`
21. `<leader>9` → `'9`

### 📦 **BUFFER & WINDOW MANAGEMENT (8 comandos)**
22. `<S-l>` → `:action NextTab`
23. `<S-h>` → `:action PreviousTab`
24. `<space>l` → `:action NextSplitter`
25. `<space>h` → `:action PrevSplitter`
26. `<leader>bd` → `:action CloseContent`
27. `<leader>bl` → `:action CloseAllToTheRight`
28. `<leader>bh` → `:action CloseAllToTheLeft`
29. `<leader>to` → `:action CloseAllEditorsButActive`

### 💻 **TERMINAL (1 comando)**
30. `<leader>tt` → `:action ActivateTerminalToolWindow`

### 🌿 **GIT OPERATIONS (23 comandos) - 6 CORREGIDOS**
31. `<leader>gs` → `:action ActivateVersionControlToolWindow`
32. `<leader>gc` → `:action CheckinProject`
33. `<leader>gpl` → `:action Vcs.UpdateProject`
34. `<leader>gps` → `:action Vcs.Push`
35. `<leader>gl` → `:action Vcs.ShowTabbedFileHistory`
36. `<leader>gv` → `:action Annotate`
37. **✅ `<leader>gn` → `:action VcsShowNextChangeMarker`** (CORREGIDO)
38. **✅ `<leader>gN` → `:action VcsShowPrevChangeMarker`** (CORREGIDO)
39. **✅ `<leader>ga` → `:action Vcs.Add`** (CORREGIDO)
40. **✅ `<leader>gdo` → `:action Compare.LastVersion`** (CORREGIDO)
41. `<leader>gf` → `:action Git.Fetch`
42. `<leader>gb` → `:action Git.Branches`
43. `<leader>gC` → `:action Vcs.ShowHistoryForBlock`
44. `<leader>hu` → `:action Vcs.RollbackChangedLines`
45. **✅ `<leader>hR` → `:action ChangesView.Revert`** (CORREGIDO)
46. **✅ `<leader>gdd` → `:action ActivateVersionControlToolWindow`** (CORREGIDO)
47. `<leader>gdc` → `:action CloseContent`
48. `<leader>co` → `:action ChooseOurs`
49. `<leader>ct` → `:action ChooseTheirs`
50. `<leader>cb` → `:action ChooseBoth`
51. `<leader>c0` → `:action ChooseNone`
52. `<leader>gcb` → `:action Git.CompareWithBranch`
53. `<leader>gds` → `:action Compare.SameVersion`

### 🔧 **LSP & CODE INTELLIGENCE (10 comandos)**
54. `gd` → `:action GotoDeclaration`
55. `gi` → `:action GotoImplementation`
56. `gr` → `:action FindUsages`
57. `go` → `:action GotoTypeDeclaration` ✅ (funciona sin leader)
58. `K` → `:action QuickJavaDoc`
59. `gs` → `:action ParameterInfo`
60. `<leader>ca` → `:action ShowIntentionActions`
61. `<leader>lf` → `:action ReformatCode`
62. `<leader>lw` → `:action ShowBookmarks`
63. `<leader>rn` → `:action RenameElement`

### 🚨 **DIAGNOSTICS & PROBLEMS (3 comandos)**
64. `<leader>xx` → `:action ActivateProblemsViewToolWindow`
65. `<leader>xn` → `:action GotoNextError`
66. `<leader>xp` → `:action GotoPreviousError`

### 🔀 **FOLDING (5 comandos) - TODOS CORREGIDOS**
67. **✅ `<leader>za` → `:action ExpandCollapseToggleAction`** (CORREGIDO)
68. **✅ `<leader>zR` → `:action ExpandAllRegions`** (CORREGIDO)
69. **✅ `<leader>zM` → `:action CollapseAllRegions`** (CORREGIDO)
70. **✅ `<leader>zr` → `:action ExpandRegion`** (CORREGIDO)
71. **✅ `<leader>zm` → `:action CollapseRegion`** (CORREGIDO)

### 🚀 **BUILD & RUN (3 comandos) - 2 CORREGIDOS**
72. **✅ `<leader>rr` → `:action RunClass`** (CORREGIDO - ejecuta main, no tests)
73. `<leader>rs` → `:action Stop`
74. **✅ `<leader>rb` → `:action Android.SyncProject`** (CORREGIDO - Android sync/build)

### 🪟 **WINDOW & SPLIT MANAGEMENT (14 comandos) - 1 NUEVO**
75. `<leader>sv` → `:action SplitVertically`
76. `<leader>sh` → `:action SplitHorizontally`
77. **🆕 `<leader>sr` → `:action SplitVertically`** (NUEVO - split right más intuitivo)
78. `<leader>sc` → `:action Unsplit`
79. `<leader>so` → `:action UnsplitAll`
80. `<leader>_` → `:action MaximizeEditorInSplit`
81. `<leader>wh` → `<C-w>h`
82. `<leader>wj` → `<C-w>j`
83. `<leader>wk` → `<C-w>k`
84. `<leader>wl` → `<C-w>l`
85. `<leader>we` → `:action NextSplitter`
86. `<leader>wt` → `:action PrevSplitter`
87. `<leader>wm` → `:action MoveEditorToOppositeTabGroup`
88. `<leader>ws` → `:action MoveTabToOppositeTabGroup`

### 📱 **FLUTTER DEVELOPMENT (7 comandos)**
89. `<leader>Fr` → `:action Flutter.HotReload`
90. `<leader>FR` → `:action Flutter.HotRestart`
91. `<leader>Fq` → `:action Flutter.Stop`
92. `<leader>Fd` → `:action Flutter.OpenDevTools`
93. `<leader>FD` → `:action RunConfiguration`
94. `<leader>Fo` → `:action Flutter.Outline`
95. `<leader>Fc` → `:action Flutter.ClearLog`

### 🧪 **TESTING (1 comando)**
96. `<leader>T` → `:action RunClass`

### 📋 **TASK MANAGEMENT (2 comandos)**
97. `<leader>oo` → `:action ActivateRunToolWindow`
98. `<leader>oi` → `:action EditConfigurations`

### 📊 **SESSION & MISC (9 comandos)**
99. `<leader>qs` → `:action RestoreSession`
100. `<leader>ql` → `:action RestoreLastSession`
101. `<leader>qd` → `:action StopSession`
102. `<leader>I` → `:action QuickImplementations`
103. `<leader>u` → `:action LocalHistory.ShowHistory`
104. `<leader>fp` → `:action ManageRecentProjects`
105. `<leader>zz` → `:action ToggleFullScreen`
106. `<leader>rp` → `:action RunProject`
107. `<leader>oq` → `:action RunClass`

### 📝 **NAVEGACIÓN & MISC (10 comandos)**
108. `<leader><space>` → `:nohlsearch`
109. `<leader>b` → `:action Back`
110. `<leader>f` → `:action Forward`
111. `gcc` → `:action CommentByLineComment`
112. `n` → `nzz`
113. `N` → `Nzz`
114. `*` → `*zz`
115. `#` → `#zz`
116. `g*` → `g*zz`
117. `g#` → `g#zz`

---

## 🎯 **COMANDOS PRIORITARIOS PARA PROBAR:**

### **1. NUEVOS (2 comandos):**
- `<leader>mb` - Ver bookmarks
- `<leader>sr` - Split right

### **2. GIT CORREGIDOS (6 comandos):**
- `<leader>gn` - Next hunk
- `<leader>gN` - Previous hunk
- `<leader>ga` - Git add
- `<leader>gdo` - Show diff
- `<leader>hR` - Revert file
- `<leader>gdd` - Git panel

### **3. FOLDING CORREGIDOS (5 comandos):**
- `<leader>za` - Toggle fold
- `<leader>zR` - Expand all
- `<leader>zM` - Collapse all
- `<leader>zr` - Expand region
- `<leader>zm` - Collapse region

### **4. BUILD CORREGIDOS (2 comandos):**
- `<leader>rr` - Run main (no tests)
- `<leader>rb` - Android sync/build

---

## 🧪 **METODOLOGÍA DE TESTING:**

### **Preparación:**
1. Abre Android Studio con IdeaVim habilitado
2. `:source ~/.ideavimrc` para recargar configuración
3. Carga proyecto Android con Git

### **Testing Prioritario:**
1. **Probar los 15 comandos corregidos primero**
2. **Reportar**: ✅ Funciona / ❌ Sigue sin funcionar
3. **Si falla**: Usar `:actionlist` para investigar acción correcta

### **Formato Reporte:**
```
CORREGIDOS:
✅ <leader>mb - Bookmarks funciona
❌ <leader>gn - Sigue sin funcionar
✅ <leader>za - Folding funciona
```

**¡Configuración corregida y optimizada lista para testing! 🚀**

**Próximo paso**: Probar los 15 comandos corregidos y reportar resultados.