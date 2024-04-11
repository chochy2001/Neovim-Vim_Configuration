**Comandos de Vim: Una Guía Fácil de Entender**

Vim es un editor de texto poderoso con una amplia gama de comandos que pueden ayudarte a ser más eficiente al escribir y editar código. A continuación, te presentamos una lista de comandos útiles de Vim junto con explicaciones detalladas sobre cómo usarlos.

**Configuración básica:**

1. `:set scrolloff=8`: Este comando establece un margen de desplazamiento suave de 8 líneas. Esto significa que cuando te desplazas hacia abajo en el archivo, Vim mantendrá 8 líneas visibles por encima y por debajo de la línea actual, lo que hace que el desplazamiento sea más suave y agradable a la vista.

2. `:set number`: Este comando muestra los números de línea en el lado izquierdo de la pantalla, lo que facilita la navegación y la referencia a líneas específicas.

3. `:set relativenumber`: Este comando muestra los números de línea relativos a la línea actual. La línea actual se muestra como 0, y las líneas anteriores y siguientes se numeran en relación a ella. Esto puede ser útil para comandos que involucran números de línea relativos.

4. `:set norelativenumber`: Este comando desactiva los números de línea relativos y vuelve a la numeración absoluta.

**Navegación de archivos:**

1. `:Vex`: Este comando abre un árbol de directorios en una ventana dividida verticalmente a la izquierda. Puedes usar este árbol para navegar y abrir archivos fácilmente.

2. `let mapleader = " "`: Esta línea establece la tecla líder en la barra espaciadora. La tecla líder se utiliza para crear atajos de teclado personalizados.

3. `nnoremap <leader>pv :Vex<CR>`: Este mapeo te permite abrir el árbol de directorios rápidamente presionando la barra espaciadora seguida de "pv" en el modo normal.

**Marcado de archivos:**

1. Abre el archivo deseado, por ejemplo, `src/sockets.c`, usando `:e src/sockets.c`.

2. Marca el archivo presionando `m` seguido de una letra mayúscula de tu elección. Por ejemplo, puedes usar `mG` para marcar `src/sockets.c` con la letra "G".

3. Repite el proceso con otros archivos, como `src/twitch.c` y `src/another.c`, usando diferentes letras mayúsculas para cada uno.

4. Para navegar rápidamente a un archivo marcado, simplemente presiona `'` seguido de la letra mayúscula que asignaste. Por ejemplo, si marcaste `src/sockets.c` con "G", puedes saltar a ese archivo presionando `'G`.

**Búsqueda de archivos:**

1. Ejecuta `:GFiles` para abrir una ventana de búsqueda de archivos. Puedes navegar por las opciones usando `Ctrl-n` para moverte hacia abajo y `Ctrl-p` para moverte hacia arriba.

**Navegación entre ventanas divididas:**

Cuando tienes la pantalla dividida con `:Vex` o `:Hex`, puedes usar los siguientes atajos para moverte entre las ventanas:

- `Ctrl-w w`: Salta a la siguiente ventana en orden. Si estás en la última ventana, volverá a la primera.
- `Ctrl-w h`: Mueve el cursor a la ventana de la izquierda.
- `Ctrl-w j`: Mueve el cursor a la ventana de abajo.
- `Ctrl-w k`: Mueve el cursor a la ventana de arriba.
- `Ctrl-w l`: Mueve el cursor a la ventana de la derecha.

**Búsqueda y resaltado:**

1. Para buscar un patrón, usa `/patrón`. Por ejemplo, `/nombreAbuscar` buscará "nombreAbuscar" en el archivo.

2. `:set hls ic` resalta todas las coincidencias de la búsqueda actual.

3. `:set nohls` elimina el resaltado de búsqueda.

4. Puedes usar expresiones regulares en tus búsquedas. Por ejemplo, `/err.\*or<CR>` buscará patrones que comiencen con "err" y terminen con "or", con cualquier cantidad de caracteres en el medio.

**Sustitución de texto:**

1. `:s/foo/baz<CR>` reemplaza la primera aparición de "foo" con "baz" en la línea actual.

2. `:s/foo/baz/g<CR>` reemplaza todas las apariciones de "foo" con "baz" en la línea actual.

3. `:s/foo/baz/gc<CR>` reemplaza todas las apariciones de "foo" con "baz" en la línea actual, pero pide confirmación para cada sustitución.

4. `:%s/foo/bar/gc` realiza una sustitución global (en todo el archivo) de "foo" con "bar", pidiendo confirmación para cada sustitución.

**Movimiento y selección:**

1. `{` te mueve hacia atrás a la línea en blanco anterior, mientras que `}` te mueve hacia adelante a la siguiente línea en blanco.

2. `0` te mueve al principio de la línea en el modo normal.

3. `$` te mueve al final de la línea en el modo normal.

4. `_` te mueve al primer carácter no en blanco de la línea.

5. `vi(` selecciona el texto dentro de los paréntesis. `ci(` elimina el texto dentro de los paréntesis y te pone en el modo de inserción. Esto funciona con otros delimitadores como `"` o `[`.

6. Para seleccionar el texto incluyendo los delimitadores, usa `va` en lugar de `vi`. Por ejemplo, `va"` seleccionará el texto y las comillas que lo rodean.

**Navegación entre buffers:**

1. `:bp` o `:bprevious` te lleva al buffer anterior en la lista de buffers.

2. `:bn` o `:bnext` te lleva al siguiente buffer en la lista de buffers.

3. `:ls` o `:buffers` muestra una lista de todos los buffers abiertos. Puedes cambiar a un buffer específico usando `:buffer <número>`.

**Aplicar comandos a múltiples líneas:**

1. Selecciona las líneas deseadas en el modo visual.

2. Presiona `:`

3. Escribe `normal` seguido del comando que deseas aplicar. Por ejemplo, si quieres insertar "var" al principio de cada línea seleccionada, puedes usar `:'<,'>normal Ivar`.

**Selección y edición con múltiples cursores:**

1. Coloca el cursor en una palabra y presiona `Ctrl-v` para ingresar al modo de selección de bloque visual.

2. Mueve el cursor hacia abajo para seleccionar las instancias de la palabra en las líneas siguientes.

3. Presiona `Ctrl-i` para entrar en el modo de inserción y editar todas las instancias seleccionadas simultáneamente.

4. Escribe el texto deseado y presiona `Esc` para aplicar los cambios.

**Incremento y decremento de números:**

1. Coloca el cursor sobre un número y presiona `Ctrl-a` para incrementarlo. Presiona `Ctrl-x` para decrementarlo.

2. Si tienes múltiples números seleccionados y deseas incrementarlos secuencialmente, selecciónalos en el modo visual y presiona `g Ctrl-a`.

**Ajustar la selección visual:**

1. En el modo de selección visual, presiona `o` para cambiar el cursor al otro extremo de la selección. Esto te permite ajustar fácilmente el inicio o el final de la selección.

2. Presiona `O` para mover el cursor al otro extremo de la selección en la dirección opuesta.

Espero que esta guía te resulte útil para comprender y utilizar estos comandos de Vim. Recuerda que la práctica constante es clave para dominar Vim y aprovechar al máximo su potencial. ¡Disfruta editando con Vim!
