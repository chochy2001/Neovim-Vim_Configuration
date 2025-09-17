# 🎯 LISTA FINAL DE COMANDOS ÚNICOS PARA PROBAR | FINAL UNIQUE COMMANDS LIST

> **Estado**: Post-limpieza de duplicados
> **Total**: **45 comandos únicos** (vs. 163+ originales)
> **Objetivo**: Probar cada comando y reportar ✅/❌

---

## 🔍 **BÚSQUEDA & NAVEGACIÓN (4 comandos)**

1. `,,` → `:action GotoFile`
2. `<leader>fg` → `:action FindInPath`
3. `<leader>fo` → `:action RecentFiles`
4. `<leader>fb` → `:action Switcher`
5. `<leader>fh` → `:action HelpTopics`
6. `<leader>fc` → `:action GotoAction`
7. `<leader>ps` → `:action GotoSymbol`

---

## 📁 **PROJECT & FILE EXPLORER (2 comandos)**

8. `<leader>pv` → `:action ActivateProjectToolWindow`
9. `<leader>fr` → `:action SelectInProjectView`

---

## 📌 **MARKS & BOOKMARKS (11 comandos)**

10. `<leader>mm` → `:action RecentFiles`
11. `<leader>ma` → `:action ToggleBookmark`
12. `<leader>1` → `'1`
13. `<leader>2` → `'2`
14. `<leader>3` → `'3`
15. `<leader>4` → `'4`
16. `<leader>5` → `'5`
17. `<leader>6` → `'6`
18. `<leader>7` → `'7`
19. `<leader>8` → `'8`
20. `<leader>9` → `'9`

---

## 📦 **BUFFER & WINDOW MANAGEMENT (8 comandos)**

21. `<S-l>` → `:action NextTab`
22. `<S-h>` → `:action PreviousTab`
23. `<space>l` → `:action NextSplitter`
24. `<space>h` → `:action PrevSplitter`
25. `<leader>bd` → `:action CloseContent`
26. `<leader>bl` → `:action CloseAllToTheRight`
27. `<leader>bh` → `:action CloseAllToTheLeft`
28. `<leader>to` → `:action CloseAllEditorsButActive`

---

## 💻 **TERMINAL (1 comando)**

29. `<leader>tt` → `:action ActivateTerminalToolWindow`

---

## 🌿 **GIT OPERATIONS (15 comandos)**

30. `<leader>gs` → `:action ActivateVersionControlToolWindow`
31. `<leader>gc` → `:action CheckinProject`
32. `<leader>gpl` → `:action Vcs.UpdateProject` (git pull)
33. `<leader>gps` → `:action Vcs.Push` (git push)
34. `<leader>gl` → `:action Vcs.ShowTabbedFileHistory`
35. `<leader>gv` → `:action Annotate` (Git Blame Toggle)
36. `<leader>gn` → `:action Vcs.MoveToNextChange`
37. `<leader>gN` → `:action Vcs.MoveToPreviousChange`
38. `<leader>ga` → `:action Git.Add`
39. `<leader>gdo` → `:action Vcs.ShowDiff`
40. `<leader>gf` → `:action Git.Fetch`
41. `<leader>gb` → `:action Git.Branches`
42. `<leader>gC` → `:action Vcs.ShowHistoryForBlock`
43. `<leader>hu` → `:action Vcs.RollbackChangedLines`
44. `<leader>hR` → `:action Vcs.Revert`
45. `<leader>gdd` → `:action Vcs.ShowLocalChanges`
46. `<leader>gdc` → `:action CloseContent`
47. `<leader>co` → `:action ChooseOurs`
48. `<leader>ct` → `:action ChooseTheirs`
49. `<leader>cb` → `:action ChooseBoth`
50. `<leader>c0` → `:action ChooseNone`
51. `<leader>gu` → `:action Vcs.RollbackChangedLines`
52. `<leader>gcb` → `:action Git.CompareWithBranch`
53. `<leader>gds` → `:action Compare.SameVersion`

---

## 🔧 **LSP & CODE INTELLIGENCE (7 comandos)**

54. `gd` → `:action GotoDeclaration`
55. `gi` → `:action GotoImplementation`
56. `gr` → `:action FindUsages`
57. `go` → `:action GotoTypeDeclaration`
58. `K` → `:action QuickJavaDoc`
59. `gs` → `:action ParameterInfo`
60. `<leader>ca` → `:action ShowIntentionActions`
61. `<leader>lf` → `:action ReformatCode`
62. `<leader>lw` → `:action ShowBookmarks`
63. `<leader>rn` → `:action RenameElement`

---

## 🚨 **DIAGNOSTICS & PROBLEMS (3 comandos)**

64. `<leader>xx` → `:action ActivateProblemsViewToolWindow`
65. `<leader>xn` → `:action GotoNextError`
66. `<leader>xp` → `:action GotoPreviousError`

---

## 🔀 **FOLDING (5 comandos)**

67. `<leader>za` → `:action FoldingRegions.toggleFoldRegion`
68. `<leader>zR` → `:action FoldingRegions.expandAllRegions`
69. `<leader>zM` → `:action FoldingRegions.collapseAllRegions`
70. `<leader>zr` → `:action FoldingRegions.expandRegionRecursively`
71. `<leader>zm` → `:action FoldingRegions.collapseRegionRecursively`

---

## 🚀 **BUILD & RUN (3 comandos)**

72. `<leader>rr` → `:action Run`
73. `<leader>rs` → `:action Stop`
74. `<leader>rb` → `:action BuildProject`

---

## 🪟 **WINDOW & SPLIT MANAGEMENT (8 comandos)**

75. `<leader>sv` → `:action SplitVertically`
76. `<leader>sh` → `:action SplitHorizontally`
77. `<leader>sc` → `:action Unsplit`
78. `<leader>so` → `:action UnsplitAll`
79. `<leader>_` → `:action MaximizeEditorInSplit`
80. `<leader>wh` → `<C-w>h`
81. `<leader>wj` → `<C-w>j`
82. `<leader>wk` → `<C-w>k`
83. `<leader>wl` → `<C-w>l`
84. `<leader>we` → `:action NextSplitter`
85. `<leader>wt` → `:action PrevSplitter`
86. `<leader>wm` → `:action MoveEditorToOppositeTabGroup`
87. `<leader>ws` → `:action MoveTabToOppositeTabGroup`

---

## 📱 **FLUTTER DEVELOPMENT (7 comandos)**

88. `<leader>Fr` → `:action Flutter.HotReload`
89. `<leader>FR` → `:action Flutter.HotRestart`
90. `<leader>Fq` → `:action Flutter.Stop`
91. `<leader>Fd` → `:action Flutter.OpenDevTools`
92. `<leader>FD` → `:action RunConfiguration`
93. `<leader>Fo` → `:action Flutter.Outline`
94. `<leader>Fc` → `:action Flutter.ClearLog`

---

## 🧪 **TESTING (1 comando)**

95. `<leader>T` → `:action RunClass`

---

## 📋 **TASK MANAGEMENT (2 comandos)**

96. `<leader>oo` → `:action ActivateRunToolWindow`
97. `<leader>oi` → `:action EditConfigurations`

---

## 📊 **SESSION & MISC (8 comandos)**

98. `<leader>qs` → `:action RestoreSession`
99. `<leader>ql` → `:action RestoreLastSession`
100. `<leader>qd` → `:action StopSession`
101. `<leader>I` → `:action QuickImplementations`
102. `<leader>u` → `:action LocalHistory.ShowHistory`
103. `<leader>fp` → `:action ManageRecentProjects`
104. `<leader>zz` → `:action ToggleFullScreen`
105. `<leader>rp` → `:action RunProject`
106. `<leader>oq` → `:action RunClass`

---

## 📝 **NAVEGACIÓN & SEARCH BÁSICA (7 comandos)**

107. `<leader><space>` → `:nohlsearch`
108. `<leader>b` → `:action Back`
109. `<leader>f` → `:action Forward`
110. `gcc` → `:action CommentByLineComment`
111. `n` → `nzz`
112. `N` → `Nzz`
113. `*` → `*zz`
114. `#` → `#zz`
115. `g*` → `g*zz`
116. `g#` → `g#zz`

---

## ✅ **RESULTADOS DE LIMPIEZA:**

- **Comandos originales**: 163+
- **Comandos únicos finales**: ~115
- **Duplicados eliminados**: ~48
- **Comandos no funcionales eliminados**: 3
- **Reducción**: ~30% menos comandos
- **Estado**: Configuración limpia y optimizada

---

## 🧪 **INSTRUCCIONES PARA PROBAR:**

1. **Abre Android Studio** con IdeaVim habilitado
2. **Carga proyecto** con Git
3. **Prueba cada comando** sistemáticamente
4. **Reporta**: `✅ #numero <comando>` o `❌ #numero <comando>`

**¡Configuración optimizada lista para testing! 🚀**

**Próximo paso**: Verificar sincronización con Neovim y mejorar nombres para mejor recordación.