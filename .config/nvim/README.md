# Arquitectura

Instalación: [README raíz](../../README.md). Atajos: [WORKFLOW.md](../../WORKFLOW.md).
Se evita duplicar sus tablas para mantener una sola referencia.

| Archivo | Responsabilidad |
|---|---|
| `init.lua` | Versión, opciones, bootstrap comprobado de lazy, modo offline |
| `lazy-lock.json` | Revisiones versionadas de plugins |
| `lua/vim-options.lua` | Opciones, shell, undo persistente, mapas nativos |
| `lua/plugins/*.lua` | Specs por función y disparadores de carga |
| `lua/lsp-utils.lua` | Estado LSP y reinicio Dart mediante flutter-tools |
| `lua/formatting.lua` | Elegir un cliente de formato adjunto |
| `lua/ai-terminals.lua` | Selección visual, prompts y terminales IA |
| `lua/terminals.lua` | Terminales opcionales y parada de un job elegido |
| `lua/runner.lua` | Comandos de archivos sueltos y quoting por shell |
| `lua/compat/git-conflict.lua` | Adaptador local de APIs de git-conflict 2.1 |

## Orden de carga

1. Opciones y leader antes de registrar atajos.
2. Tema, iconos y nvim-treesitter al inicio. Tree-sitter es una excepción deliberada:
   upstream no soporta su carga diferida.
3. Al abrir archivos, Mason configura el PATH antes de lspconfig.
4. Se habilitan los servidores configurados con ejecutable disponible. Dart lo
   gestiona flutter-tools; no se eliminan clientes de otros proyectos.
5. Eventos/atajos cargan el resto. Los mapas `keys` funcionan desde la primera pulsación.

El adaptador de git-conflict conserva `vim.validate` y las APIs globales.
Revisar si sigue haciendo falta al cambiar esa dependencia.
Los errores de autenticación se muestran.

## Verificación

Desde la raíz: `python scripts/verify.py`. Aísla configuración, caché y sesiones;
reutiliza plugins/herramientas instalados sin actualizarlos. `--install` permite
instalarlos en el entorno temporal. Ver [VALIDATION](../../docs/VALIDATION.md)
y [SOURCES](../../docs/SOURCES.md).
