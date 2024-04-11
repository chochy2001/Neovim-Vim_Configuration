# Mi Configuración de Vim y Comandos Clave

Este repositorio contiene mi configuración personal de Vim y una lista de comandos clave que encuentro útiles en mi flujo de trabajo diario. Espero que esta información te sea valiosa y puedas incorporar algunos de estos comandos en tu propio uso de Vim.

## Contribuciones

¡Las contribuciones son bienvenidas! Si tienes comandos adicionales, trucos o mejoras para la configuración que crees que otros podrían encontrar útiles, no dudes en abrir un Pull Request. Estaré encantado de revisar y fusionar las contribuciones que puedan beneficiar a la comunidad.

## Usa mi Configuración

Si encuentras mi configuración de Vim útil, siéntete libre de copiarla y usarla como base para tu propia configuración. Puedes clonar este repositorio y copiar los archivos de configuración relevantes a tu propio entorno de Vim.

```bash
git clone https://github.com/tu-usuario/tu-repositorio.git
cd tu-repositorio
cp .vimrc ~/.vimrc
```

Recuerda que puedes personalizar la configuración según tus propias preferencias y necesidades.

## Comandos Clave de Vim

A continuación, encontrarás una lista de comandos clave de Vim que cubren diversos aspectos de la edición, navegación y manipulación de texto. Dominar estos comandos te ayudará a ser más eficiente y productivo al trabajar con Vim.

### Configuración Básica

- `:set scrolloff=8`: Establece un margen de desplazamiento suave de 8 líneas.
- `:set number`: Muestra los números de línea.
- `:set relativenumber`: Muestra los números de línea relativos a la línea actual.
- `:set norelativenumber`: Desactiva los números de línea relativos.

### Navegación de Archivos

- `:Vex`: Abre un árbol de directorios en una ventana dividida verticalmente.
- `let mapleader = " "`: Establece la tecla líder en la barra espaciadora.
- `nnoremap <leader>pv :Vex<CR>`: Abre el árbol de directorios con `<leader>pv`.

### Marcado de Archivos

- `m[letra mayúscula]`: Marca un archivo con una letra mayúscula.
- `'[letra mayúscula]`: Salta a un archivo marcado.

### Búsqueda de Archivos

- `:GFiles`: Abre una ventana de búsqueda de archivos.
- `Ctrl-n`: Navega hacia abajo en la lista de archivos.
- `Ctrl-p`: Navega hacia arriba en la lista de archivos.

### Navegación entre Ventanas Divididas

- `Ctrl-w w`: Salta a la siguiente ventana en orden.
- `Ctrl-w h`: Mueve el cursor a la ventana de la izquierda.
- `Ctrl-w j`: Mueve el cursor a la ventana de abajo.
- `Ctrl-w k`: Mueve el cursor a la ventana de arriba.
- `Ctrl-w l`: Mueve el cursor a la ventana de la derecha.

### Búsqueda y Resaltado

- `/patrón`: Busca un patrón específico.
- `:set hls ic`: Resalta todas las coincidencias de la búsqueda actual.
- `:set nohls`: Elimina el resaltado de búsqueda.

### Sustitución de Texto

- `:s/foo/baz`: Reemplaza la primera aparición de "foo" con "baz" en la línea actual.
- `:s/foo/baz/g`: Reemplaza todas las apariciones de "foo" con "baz" en la línea actual.
- `:s/foo/baz/gc`: Reemplaza todas las apariciones de "foo" con "baz" en la línea actual, con confirmación.
- `:%s/foo/bar/gc`: Realiza una sustitución global de "foo" con "bar", con confirmación.

### Movimiento y Selección

- `{`: Mueve hacia atrás a la línea en blanco anterior.
- `}`: Mueve hacia adelante a la siguiente línea en blanco.
- `0`: Mueve al principio de la línea en el modo normal.
- `$`: Mueve al final de la línea en el modo normal.
- `_`: Mueve al primer carácter no en blanco de la línea.
- `vi(`: Selecciona el texto dentro de los paréntesis.
- `ci(`: Elimina el texto dentro de los paréntesis y entra en el modo de inserción.
- `va"`: Selecciona el texto y las comillas que lo rodean.

### Navegación entre Buffers

- `:bp` o `:bprevious`: Va al buffer anterior en la lista de buffers.
- `:bn` o `:bnext`: Va al siguiente buffer en la lista de buffers.
- `:ls` o `:buffers`: Muestra una lista de todos los buffers abiertos.

### Aplicar Comandos a Múltiples Líneas

- `Ctrl-v`: Ingresa al modo de selección de bloque visual.
- `:[rango]normal [comando]`: Aplica un comando a las líneas seleccionadas.

### Selección y Edición con Múltiples Cursores

- `Ctrl-v`: Ingresa al modo de selección de bloque visual.
- `Ctrl-i`: Entra en el modo de inserción para editar las instancias seleccionadas.

### Incremento y Decremento de Números

- `Ctrl-a`: Incrementa el número bajo el cursor.
- `Ctrl-x`: Decrementa el número bajo el cursor.
- `g Ctrl-a`: Incrementa secuencialmente los números seleccionados.

### Ajustar la Selección Visual

- `o`: Cambia el cursor al otro extremo de la selección.
- `O`: Mueve el cursor al otro extremo de la selección en la dirección opuesta.

Espero que encuentres estos comandos útiles y que te ayuden a mejorar tu flujo de trabajo en Vim. Si tienes alguna pregunta o sugerencia, no dudes en abrir un issue o contactarme.

¡Feliz edición con Vim!
