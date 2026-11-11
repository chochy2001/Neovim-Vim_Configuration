// Generated from deck.json by scripts/build_slides.py. Do not edit.
window.DECK = {
 "version": "1.0.0",
 "title": "Neovim desde cero",
 "modules": [
  {
   "id": "m00",
   "number": "00",
   "title": "Bienvenida",
   "promise": "Que es Vim, como funciona este curso y como estudiar.",
   "image": "img/00-bienvenida.jpg",
   "introduces": [],
   "slides": [
    {
     "type": "title",
     "id": "m00-title",
     "number": "00",
     "heading": "Neovim desde cero",
     "promise": "Aprende a editar texto de forma eficiente con el editor modal por excelencia.",
     "image": "img/00-bienvenida.jpg"
    },
    {
     "type": "concept",
     "id": "m00-que-es",
     "heading": "Que es Vim y Neovim",
     "bullets": [
      "Vim nacio en 1991 como sucesor de vi. Neovim (desde 2014) lo moderniza con Lua, plugins y LSP.",
      "El mismo motor modal con una API más potente y una comunidad activa.",
      "Funciona en cualquier terminal, en servidores SSH, contenedores y sin ratón.",
      "Los mismos atajos sirven en VS Code, IntelliJ, Android Studio (con IdeaVim) y más."
     ],
     "notes": "Vim tiene más de 30 años y sigue siendo uno de los editores más usados porque resuelve un problema concreto: editar texto con el teclado de la forma más directa posible. Neovim lo moderniza sin perder lo que lo hace útil. Esta configuración añade LSP, Telescope, terminales integrados y agentes de IA, pero la base es Vim puro."
    },
    {
     "type": "concept",
     "id": "m00-por-que",
     "heading": "Por que aprenderlo",
     "bullets": [
      "Cuando los comandos se vuelven reflejos, editar es más rápido que con cualquier editor clásico.",
      "Funciona igual en tu Mac, en un servidor Linux y en una Raspberry Pi.",
      "Las habilidades no caducan: Vim existe desde 1991 y seguira existiendo.",
      "Un editor que se adapta al programador, no al reves."
     ],
     "notes": "Al principio Vim parece difícil porque es diferente a lo que conocemos. Pero cuando los movimientos se vuelven automáticos, editar código se convierte en algo fluido y casi pensado. Vale la pena el tiempo de aprendizaje inicial. La clave es la practica espaciada: 15 minutos al día durante dos semanas son más efectivos que un fin de semana entero."
    },
    {
     "type": "concept",
     "id": "m00-como",
     "heading": "Como funciona este curso",
     "bullets": [
      "El profesor presenta cada módulo con estas diapositivas (lo que ves ahora).",
      "El alumno practica en la página de ejercicios del navegador (sin instalar nada).",
      "Desde el módulo 8, se usa la configuración real del repositorio.",
      "Cada sesión se centra en un tema; no memorices: practica."
     ],
     "notes": "El curso esta disenado para ser progresivo. Cada módulo construye sobre el anterior. Los módulos 0 a 7 ensenian Vim nativo, que funciona en cualquier instalación. Los módulos 8 a 13 ensenian esta configuración concreta. No hace falta tener Neovim instalado para los primeros siete módulos: la página de ejercicios funciona en el navegador."
    },
    {
     "type": "concept",
     "id": "m00-estudio",
     "heading": "Modo de estudio",
     "bullets": [
      "15 minutos al día son suficientes para empezar. La practica espaciada funciona mejor que las maratones.",
      "Haz el tutor completo al menos una vez: nvim --clean +Tutor",
      "Practica mecanografía con hjkl antes de editar código (keybr.com, monkeytype.com).",
      "Usa nvim --clean para los módulos 1 al 7: aprende sin atajos de la config."
     ],
     "notes": "El error más comun es intentar aprender demasiado de una vez. Este curso esta pensado para sesiones cortas y frecuentes. nvim --clean abre Neovim sin ningún archivo de configuración, lo que permite aprender los comandos nativos sin que los atajos de esta config interfieran. Cuando algo no funcione como esperas, prueba primero con --clean para saber si es Vim o la config."
    },
    {
     "type": "practice",
     "id": "m00-practice",
     "heading": "Comienza la practica",
     "lesson": "lesson-1",
     "url": "../../practice/index.html#lesson-1",
     "public_url": "https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-1"
    },
    {
     "type": "summary",
     "id": "m00-summary",
     "heading": "Lo que veremos en este curso",
     "bullets": [
      "Módulos 1 a 4: modos, movimientos, gramática y objetos de texto.",
      "Módulos 5 y 6: búsqueda, sustitución, registros y macros.",
      "Módulo 7: buffers, ventanas, pestañas y terminales.",
      "Módulos 8 a 11: instalar y usar esta config como IDE con IA.",
      "Módulos 12 y 13: IdeaVim y diagnóstico."
     ]
    }
   ]
  },
  {
   "id": "m01",
   "number": "01",
   "title": "Modos y sobrevivir",
   "promise": "Entra, edita, guarda y sal sin pánico.",
   "image": "img/01-modos.jpg",
   "introduces": [
    "i",
    "a",
    "I",
    "A",
    "o",
    "O",
    "Esc",
    "jj",
    ":w",
    ":q",
    ":wq",
    ":q!",
    "ZZ",
    "ZQ",
    ":help",
    ":Tutor"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m01-title",
     "number": "01",
     "heading": "Modos y sobrevivir",
     "promise": "Entra, edita, guarda y sal sin pánico.",
     "image": "img/01-modos.jpg"
    },
    {
     "type": "concept",
     "id": "m01-modal",
     "heading": "El editor modal",
     "bullets": [
      "La misma tecla hace cosas distintas según el modo. Eso no es un bug, es la potencia de Vim.",
      "Normal: te mueves por el archivo y ejecutas comandos. Es el modo de descanso.",
      "Insertar: escribes texto como en cualquier editor. Sales con Esc (o jj en esta config).",
      "Visual: seleccionas texto. Línea de comandos: guardas, buscas, pides ayuda."
     ],
     "notes": "Esta es la diferencia fundamental entre Vim y un editor clásico. En un bloc de notas, 'a' siempre escribe 'a'. En Vim, 'a' en modo Normal entra a Insertar y pone el cursor después del carácter actual. Puede parecer extrano al principio, pero cuando los modos se interiorizan, cada tecla se convierte en una orden precisa. Si te pierdes en cualquier momento: Esc Esc. Dos veces siempre devuelve a Normal."
    },
    {
     "type": "keys",
     "id": "m01-modos-tabla",
     "heading": "Los cuatro modos principales",
     "rows": [
      {
       "key": "Normal",
       "action": "Al abrir Neovim, o con Esc. Sirve para moverse y dar órdenes."
      },
      {
       "key": "Insertar",
       "action": "Con i, a, I, A, o, O. Sirve para escribir texto."
      },
      {
       "key": "Visual",
       "action": "Con v (carácter), V (línea), Ctrl-v (bloque). Sirve para seleccionar."
      },
      {
       "key": "Línea de comandos",
       "action": "Con : / ? Sirve para guardar, buscar y pedir ayuda."
      }
     ]
    },
    {
     "type": "keys",
     "id": "m01-entrar",
     "heading": "Entrar en modo Insertar",
     "rows": [
      {
       "key": "i",
       "action": "Insertar antes del cursor"
      },
      {
       "key": "a",
       "action": "Insertar después del cursor"
      },
      {
       "key": "I",
       "action": "Insertar al primer carácter no espacio de la línea"
      },
      {
       "key": "A",
       "action": "Insertar al final de la línea"
      },
      {
       "key": "o",
       "action": "Línea nueva debajo, ya en Insertar"
      },
      {
       "key": "O",
       "action": "Línea nueva encima, ya en Insertar"
      },
      {
       "key": "<Esc> o jj",
       "action": "Volver a Normal (jj es un atajo de esta config)"
      }
     ]
    },
    {
     "type": "demo",
     "id": "m01-demo-insert",
     "heading": "Insertar al inicio con I",
     "start": "todo",
     "cursor": [
      0,
      0
     ],
     "keys": "I//<Esc>",
     "result": {
      "text": "//todo",
      "cursor": [
       0,
       1
      ]
     },
     "say": "I va al primer carácter no espacio de la línea y entra en modo Insertar."
    },
    {
     "type": "demo",
     "id": "m01-demo-i",
     "heading": "i: insertar antes del cursor",
     "say": "i entra en modo Insertar justo antes del carácter bajo el cursor.",
     "start": "world",
     "cursor": [
      0,
      0
     ],
     "keys": "i!<Esc>",
     "result": {
      "text": "!world",
      "cursor": [
       0,
       0
      ]
     }
    },
    {
     "type": "demo",
     "id": "m01-demo-a",
     "heading": "a: insertar después del cursor",
     "say": "a entra en modo Insertar justo después del carácter bajo el cursor.",
     "start": "world",
     "cursor": [
      0,
      4
     ],
     "keys": "a!<Esc>",
     "result": {
      "text": "world!",
      "cursor": [
       0,
       5
      ]
     }
    },
    {
     "type": "demo",
     "id": "m01-demo-o",
     "heading": "o: línea nueva debajo",
     "say": "o abre una nueva línea debajo de la actual y entra en modo Insertar.",
     "start": "first",
     "cursor": [
      0,
      0
     ],
     "keys": "osecond<Esc>",
     "result": {
      "text": "first\nsecond",
      "cursor": [
       1,
       5
      ]
     }
    },
    {
     "type": "keys",
     "id": "m01-guardar",
     "heading": "Guardar y salir",
     "rows": [
      {
       "key": ":w",
       "action": "Guardar (write)"
      },
      {
       "key": ":q",
       "action": "Salir si no hay cambios sin guardar"
      },
      {
       "key": ":wq",
       "action": "Guardar y salir (siempre escribe aunque no haya cambios)"
      },
      {
       "key": "ZZ o :x",
       "action": "Guardar y salir solo si hay cambios pendientes"
      },
      {
       "key": ":q!",
       "action": "Salir descartando los cambios"
      },
      {
       "key": ":e!",
       "action": "Recargar el archivo del disco"
      },
      {
       "key": ":help x",
       "action": "Buscar la tecla x en el manual"
      },
      {
       "key": ":Tutor",
       "action": "Tutorial interactivo de Vim"
      }
     ]
    },
    {
     "type": "concept",
     "id": "m01-help",
     "heading": ":help y :Tutor",
     "bullets": [
      ":help es la documentación completa de Vim. Funciona sin internet.",
      ":Tutor abre un tutorial interactivo. Hazlo entero al menos una vez.",
      ":help x busca la tecla x. :help :w busca el comando :w.",
      "Dentro del help, Ctrl-] sigue un enlace y Ctrl-o vuelve atrás."
     ],
     "notes": ":help es la forma más directa de aclarar dudas sobre cualquier tecla o comando. No hace falta memorizar todo: saber buscar en :help es suficiente. El tutorial :Tutor lleva unos 30 minutos y cubre los fundamentos. Aburre un poco, pero funciona: después del tutor tienes una base solida para los siguientes módulos."
    },
    {
     "type": "practice",
     "id": "m01-practice",
     "heading": "Practica: modos y primeras teclas",
     "lesson": "lesson-1",
     "url": "../../practice/index.html#lesson-1",
     "public_url": "https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-1"
    },
    {
     "type": "summary",
     "id": "m01-summary",
     "heading": "Resumen del módulo 01",
     "bullets": [
      "Vim es modal: la misma tecla hace cosas distintas en Normal, Insertar y Visual.",
      "Entrar en Insertar: i a I A o O. Salir: Esc (o jj).",
      "Guardar: :w. Salir: :q. :wq siempre escribe; ZZ (y :x) solo si hay cambios. Descartar: :q!",
      "El manual: :help. El tutorial: :Tutor. Si te pierdes: Esc Esc."
     ],
     "cheatcode": "i a I A o O  ->  Insertar   |   Esc / jj  ->  Normal   |   :wq  ->  guardar y salir"
    }
   ]
  },
  {
   "id": "m02",
   "number": "02",
   "title": "Moverse sin flechas",
   "promise": "Navega cualquier archivo a la velocidad del pensamiento.",
   "image": "img/02-moverse.jpg",
   "introduces": [
    "h",
    "j",
    "k",
    "l",
    "w",
    "b",
    "e",
    "W",
    "B",
    "E",
    "0",
    "^",
    "$",
    "gg",
    "G",
    "{",
    "}",
    "f",
    "t",
    "F",
    "T",
    ";",
    ",",
    "%",
    "3gg"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m02-title",
     "number": "02",
     "heading": "Moverse sin flechas",
     "promise": "Navega cualquier archivo a la velocidad del pensamiento.",
     "image": "img/02-moverse.jpg"
    },
    {
     "type": "concept",
     "id": "m02-hjkl",
     "heading": "h j k l: el diamante de movimiento",
     "bullets": [
      "h izquierda, l derecha, k arriba, j abajo. Siempre en la fila central del teclado.",
      "Las flechas funcionan, pero te sacan la mano de las letras. hjkl no.",
      "Con un número delante multiplicas: 5j baja cinco líneas, 3l avanza tres caracteres.",
      "No tienes que memorizar la disposición: practica y se vuelve automático."
     ],
     "notes": "El truco para aprender hjkl es desactivar las flechas durante una semana. Suena duro, pero funciona. Al principio es lento, después es más rápido que llegar al cursor. La disposición h-j-k-l tiene lógica: j parece una flecha hacia abajo, k apunta arriba, h esta a la izquierda y l a la derecha."
    },
    {
     "type": "keys",
     "id": "m02-palabras",
     "heading": "Movimientos por palabra",
     "rows": [
      {
       "key": "w",
       "action": "Inicio de la siguiente palabra"
      },
      {
       "key": "b",
       "action": "Inicio de la palabra anterior"
      },
      {
       "key": "e",
       "action": "Final de la palabra actual o siguiente"
      },
      {
       "key": "W B E",
       "action": "Lo mismo, pero saltando puntuación (WORD)"
      },
      {
       "key": "0",
       "action": "Inicio absoluto de la línea"
      },
      {
       "key": "^",
       "action": "Primer carácter no espacio de la línea"
      },
      {
       "key": "$",
       "action": "Final de la línea"
      }
     ]
    },
    {
     "type": "keys",
     "id": "m02-lineas",
     "heading": "Línea, párrafo y archivo",
     "rows": [
      {
       "key": "gg",
       "action": "Primera línea del archivo"
      },
      {
       "key": "G",
       "action": "Última línea del archivo"
      },
      {
       "key": "3gg",
       "action": "Ir a la línea 3 (número + gg)"
      },
      {
       "key": "{ }",
       "action": "Párrafo anterior / siguiente"
      },
      {
       "key": "%",
       "action": "Saltar al paréntesis, corchete o llave que hace pareja"
      }
     ]
    },
    {
     "type": "keys",
     "id": "m02-buscar-linea",
     "heading": "Buscar carácter en la línea actual",
     "rows": [
      {
       "key": "fx",
       "action": "Ir al primer x hacia adelante en la línea"
      },
      {
       "key": "tx",
       "action": "Ir justo antes del primer x hacia adelante"
      },
      {
       "key": "Fx Tx",
       "action": "Lo mismo hacia atrás"
      },
      {
       "key": ";",
       "action": "Repetir el último f/t en el mismo sentido"
      },
      {
       "key": ",",
       "action": "Repetir el último f/t en sentido contrario"
      }
     ]
    },
    {
     "type": "concept",
     "id": "m02-conteos",
     "heading": "Conteos: multiplicar cualquier movimiento",
     "bullets": [
      "Escribe un número antes de casi cualquier movimiento para repetirlo.",
      "5j baja cinco líneas. 3w avanza tres palabras. 2fX salta a la segunda X.",
      "10G va a la línea 10. 20l avanza veinte caracteres.",
      "Si te equivocas con el conteo, Esc lo cancela."
     ],
     "notes": "Los conteos son una de las cosas que hacen Vim rápido. En lugar de pulsar j cinco veces, escribes 5j. En lugar de buscar la segunda X con fx y luego ;, escribes 2fX directamente. Al principio usaras pocos conteos, pero con la practica se vuelven naturales."
    },
    {
     "type": "demo",
     "id": "m02-demo-hjkl",
     "heading": "Moverme con l (dos pasos)",
     "start": "abc",
     "cursor": [
      0,
      0
     ],
     "keys": "ll",
     "result": {
      "text": "abc",
      "cursor": [
       0,
       2
      ]
     },
     "say": "l mueve un carácter a la derecha. Con un número delante se multiplica."
    },
    {
     "type": "demo",
     "id": "m02-demo-find",
     "heading": "2fX: buscar la segunda X",
     "start": "aXbXcX",
     "cursor": [
      0,
      0
     ],
     "keys": "2fX",
     "result": {
      "text": "aXbXcX",
      "cursor": [
       0,
       3
      ]
     },
     "say": "2fX busca la segunda X hacia adelante en la línea actual."
    },
    {
     "type": "demo",
     "id": "m02-demo-w",
     "heading": "2w: avanzar dos palabras",
     "say": "Un número antes del movimiento lo multiplica: 2w salta a la tercera palabra.",
     "start": "one two three",
     "cursor": [
      0,
      0
     ],
     "keys": "2w",
     "result": {
      "text": "one two three",
      "cursor": [
       0,
       8
      ]
     }
    },
    {
     "type": "demo",
     "id": "m02-demo-pct",
     "heading": "%: saltar al paréntesis que hace pareja",
     "say": "% salta entre paréntesis, corchetes y llaves que se corresponden.",
     "start": "fn(x)",
     "cursor": [
      0,
      2
     ],
     "keys": "%",
     "result": {
      "text": "fn(x)",
      "cursor": [
       0,
       4
      ]
     }
    },
    {
     "type": "practice",
     "id": "m02-practice",
     "heading": "Practica: moverse sin flechas",
     "lesson": "lesson-2",
     "url": "../../practice/index.html#lesson-2",
     "public_url": "https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-2"
    },
    {
     "type": "summary",
     "id": "m02-summary",
     "heading": "Resumen del módulo 02",
     "bullets": [
      "hjkl mueven carácter a carácter. Un número delante los multiplica.",
      "w b e por palabras. 0 ^ $ para los extremos de la línea.",
      "gg primera línea, G última, Ngg la línea N.",
      "fx busca x en la línea. ; repite la búsqueda, , va al reves.",
      "{ } por párrafos. % salta a la pareja de paréntesis o llave."
     ],
     "cheatcode": "gg / G  |  Ngg  |  w b e  |  f t ; ,  |  { }  |  %"
    }
   ]
  },
  {
   "id": "m03",
   "number": "03",
   "title": "La gramática",
   "promise": "Operador + movimiento: la formula que lo hace todo.",
   "image": "img/03-gramatica.jpg",
   "introduces": [
    "d",
    "c",
    "y",
    "dd",
    "cc",
    "yy",
    "x",
    "X",
    "D",
    "C",
    "p",
    "P",
    "J",
    "r",
    ".",
    "u",
    "<C-r>"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m03-title",
     "number": "03",
     "heading": "La gramática",
     "promise": "Operador + movimiento: la formula que lo hace todo.",
     "image": "img/03-gramatica.jpg"
    },
    {
     "type": "concept",
     "id": "m03-gramatica",
     "heading": "Operador + movimiento",
     "bullets": [
      "Un operador espera un movimiento (o un objeto de texto) para saber donde actuar.",
      "dw: borrar (d) + hasta la siguiente palabra (w). d$ borra hasta el final de la línea.",
      "cw: cambiar (c) + hasta el final de la palabra (actúa como ce, no como dw). Entra en Insertar.",
      "yy, dd, cc actúan sobre la línea completa (es un shortcut del operador doble)."
     ],
     "notes": "Esta es la base de toda la edición en Vim. Un operador (d, c, y) solo dice 'que' hacer. Necesita un movimiento para saber 'donde'. Esta combinación es infinitamente extensible: d más cualquier movimiento que aprendas siempre funciona. Cuando en el módulo siguiente aprendas objetos de texto, podrás combinarlos con los mismos operadores."
    },
    {
     "type": "keys",
     "id": "m03-operadores",
     "heading": "Los tres operadores principales",
     "rows": [
      {
       "key": "d",
       "action": "Borrar (delete). El texto borrado va al registro sin nombre."
      },
      {
       "key": "c",
       "action": "Cambiar (change). Borra y entra en modo Insertar."
      },
      {
       "key": "y",
       "action": "Copiar (yank). El texto copiado va al registro 0 y al sin nombre."
      },
      {
       "key": "dd cc yy",
       "action": "Operar sobre la línea completa"
      },
      {
       "key": "D C Y",
       "action": "Borrar/cambiar/copiar hasta el final de la línea (Neovim: Y = y$, no yy)"
      },
      {
       "key": "p P",
       "action": "Pegar después / antes del cursor"
      }
     ]
    },
    {
     "type": "keys",
     "id": "m03-atajos",
     "heading": "Atajos rápidos y comandos esenciales",
     "rows": [
      {
       "key": "x",
       "action": "Borrar el carácter bajo el cursor"
      },
      {
       "key": "r + letra",
       "action": "Reemplazar el carácter actual sin entrar en Insertar"
      },
      {
       "key": "J",
       "action": "Unir esta línea con la siguiente (join)"
      },
      {
       "key": ".",
       "action": "Repetir el último cambio"
      },
      {
       "key": "u",
       "action": "Deshacer (undo)"
      },
      {
       "key": "<C-r>",
       "action": "Rehacer (redo)"
      }
     ]
    },
    {
     "type": "demo",
     "id": "m03-demo-dw",
     "heading": "dw: borrar hasta la siguiente palabra",
     "start": "remove remaining text",
     "cursor": [
      0,
      0
     ],
     "keys": "dw",
     "result": {
      "text": "remaining text",
      "cursor": [
       0,
       0
      ]
     },
     "say": "dw incluye el espacio que sigue a la palabra. cw actúa como ce: solo hasta el final."
    },
    {
     "type": "demo",
     "id": "m03-demo-cw",
     "heading": "cw: cambiar la primera palabra",
     "start": "old new",
     "cursor": [
      0,
      0
     ],
     "keys": "cwNEW<Esc>",
     "result": {
      "text": "NEW new",
      "cursor": [
       0,
       2
      ]
     },
     "say": "cw actúa como ce: elimina hasta el final de la palabra, no hasta la siguiente."
    },
    {
     "type": "demo",
     "id": "m03-demo-x",
     "heading": "x: borrar el carácter bajo el cursor",
     "say": "x elimina un único carácter en la posición del cursor sin entrar en Insertar.",
     "start": "hat",
     "cursor": [
      0,
      1
     ],
     "keys": "x",
     "result": {
      "text": "ht",
      "cursor": [
       0,
       1
      ]
     }
    },
    {
     "type": "demo",
     "id": "m03-demo-dd",
     "heading": "dd: borrar la línea completa",
     "say": "dd borra toda la línea y la guarda en el registro para pegar con p.",
     "start": "delete me\nkeep me",
     "cursor": [
      0,
      0
     ],
     "keys": "dd",
     "result": {
      "text": "keep me",
      "cursor": [
       0,
       0
      ]
     }
    },
    {
     "type": "demo",
     "id": "m03-demo-r",
     "heading": "r: reemplazar un carácter",
     "say": "r sustituye el carácter bajo el cursor con la siguiente tecla, sin Insertar.",
     "start": "hat",
     "cursor": [
      0,
      0
     ],
     "keys": "rb",
     "result": {
      "text": "bat",
      "cursor": [
       0,
       0
      ]
     }
    },
    {
     "type": "concept",
     "id": "m03-punto",
     "heading": "El punto (.) repite el último cambio",
     "bullets": [
      "Después de cualquier cambio (c, d, x, r...), el punto lo repite exactamente.",
      "cw + nuevo texto + Esc. Muévete a otra palabra. Punto: repite el cambio.",
      "Es uno de los comandos más poderosos: hace que las acciones sean componibles.",
      "Consejo: disenha tus cambios para poder repetirlos con . en más sitios."
     ],
     "notes": "El punto es una de las joyas de Vim. Cuando haces un cambio, Vim lo recuerda. Con . lo repites en el siguiente lugar. Esto cambia la forma de trabajar: en lugar de hacer el mismo cambio diez veces a mano, lo haces una vez y repites con . Funciona con cualquier cambio, desde x hasta secuencias largas de cw + texto."
    },
    {
     "type": "practice",
     "id": "m03-practice",
     "heading": "Practica: la gramática",
     "lesson": "lesson-3",
     "url": "../../practice/index.html#lesson-3",
     "public_url": "https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-3"
    },
    {
     "type": "summary",
     "id": "m03-summary",
     "heading": "Resumen del módulo 03",
     "bullets": [
      "d c y son los tres operadores: borrar, cambiar, copiar.",
      "Operador + movimiento = acción precisa. dd cc yy actúan sobre la línea.",
      "p pega después, P antes. x borra el carácter. r lo reemplaza.",
      "u deshace, Ctrl-r rehace. . repite el último cambio."
     ],
     "cheatcode": "dw  cw  yw  |  dd  cc  yy  |  p  P  |  .  u  Ctrl-r"
    }
   ]
  },
  {
   "id": "m04",
   "number": "04",
   "title": "Objetos de texto",
   "promise": "Opera sobre palabras, cadenas y bloques de una vez.",
   "image": "img/04-objetos-texto.jpg",
   "introduces": [
    "iw",
    "aw",
    "i\"",
    "a\"",
    "i(",
    "a(",
    "i{",
    "a{",
    ">>",
    "<<",
    "v",
    "V"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m04-title",
     "number": "04",
     "heading": "Objetos de texto",
     "promise": "Opera sobre palabras, cadenas y bloques de una vez.",
     "image": "img/04-objetos-texto.jpg"
    },
    {
     "type": "concept",
     "id": "m04-que-son",
     "heading": "Que es un objeto de texto",
     "bullets": [
      "Un movimiento va en una sola dirección. Un objeto rodea el cursor.",
      "i (inner, interior) opera dentro del delimitador, sin incluirlo.",
      "a (around, alrededor) incluye el delimitador y el espacio adyacente.",
      "Se combinan con cualquier operador: d, c, y, > ..."
     ],
     "notes": "Los objetos de texto son la otra mitad de la gramática de Vim. Con movimientos podias decir 'borra desde aquí hasta la siguiente palabra'. Con objetos puedes decir 'borra esta palabra entera, donde sea que este el cursor dentro de ella'. ciw cambia la palabra bajo el cursor sin importar si estas en el primer o el último carácter."
    },
    {
     "type": "keys",
     "id": "m04-tabla",
     "heading": "Objetos de texto más usados",
     "rows": [
      {
       "key": "iw aw",
       "action": "Palabra interior / con el espacio adyacente"
      },
      {
       "key": "i\" a\"",
       "action": "Dentro de comillas dobles / con las comillas"
      },
      {
       "key": "i' a'",
       "action": "Dentro de comillas simples / con las comillas"
      },
      {
       "key": "i( a(",
       "action": "Dentro de paréntesis / con los paréntesis (también ib ab)"
      },
      {
       "key": "i{ a{",
       "action": "Dentro de llaves / con las llaves (también iB aB)"
      },
      {
       "key": "i[ a[",
       "action": "Dentro de corchetes / con los corchetes"
      }
     ]
    },
    {
     "type": "demo",
     "id": "m04-demo-ciw",
     "heading": "ciw: cambiar la palabra interior",
     "start": "say NOPE now",
     "cursor": [
      0,
      4
     ],
     "keys": "ciwok<Esc>",
     "result": {
      "text": "say ok now",
      "cursor": [
       0,
       5
      ]
     },
     "say": "ciw opera desde cualquier posición dentro de la palabra."
    },
    {
     "type": "demo",
     "id": "m04-demo-ciquote",
     "heading": "ci\": cambiar el texto entre comillas",
     "start": "msg = \"no\";",
     "cursor": [
      0,
      8
     ],
     "keys": "ci\"yes<Esc>",
     "result": {
      "text": "msg = \"yes\";",
      "cursor": [
       0,
       9
      ]
     },
     "say": "ci\" borra el contenido entre comillas y entra en modo Insertar."
    },
    {
     "type": "demo",
     "id": "m04-demo-diw",
     "heading": "diw: borrar la palabra interior",
     "say": "iw (inner word) selecciona la palabra exacta, sin el espacio adyacente.",
     "start": "say hello world",
     "cursor": [
      0,
      4
     ],
     "keys": "diw",
     "result": {
      "text": "say  world",
      "cursor": [
       0,
       4
      ]
     }
    },
    {
     "type": "demo",
     "id": "m04-demo-daw",
     "heading": "daw: borrar la palabra con el espacio",
     "say": "aw (around word) incluye un espacio adyacente: sin doble espacio al borrar.",
     "start": "say hello world",
     "cursor": [
      0,
      4
     ],
     "keys": "daw",
     "result": {
      "text": "say world",
      "cursor": [
       0,
       4
      ]
     }
    },
    {
     "type": "demo",
     "id": "m04-demo-dip",
     "heading": "di(: borrar el interior de un paréntesis",
     "say": "i( opera dentro de los paréntesis sin borrarlos.",
     "start": "fn(arg)",
     "cursor": [
      0,
      4
     ],
     "keys": "di(",
     "result": {
      "text": "fn()",
      "cursor": [
       0,
       3
      ]
     }
    },
    {
     "type": "demo",
     "id": "m04-demo-daqt",
     "heading": "di\": borrar el interior de las comillas",
     "say": "i\" opera dentro de las comillas dobles; las comillas quedan intactas.",
     "start": "say \"hello\" there",
     "cursor": [
      0,
      5
     ],
     "keys": "di\"",
     "result": {
      "text": "say \"\" there",
      "cursor": [
       0,
       5
      ]
     }
    },
    {
     "type": "concept",
     "id": "m04-visual",
     "heading": "Modo Visual e indentación",
     "bullets": [
      "v selecciona carácter a carácter. V selecciona líneas. Ctrl-v selecciona columnas.",
      "Con la selección hecha: d borra, c cambia, y copia, > indenta, < desindenta.",
      ">> indenta la línea actual. << la desindenta. En esta config, mantienen la selección.",
      "o dentro de visual salta al otro extremo de la selección."
     ],
     "notes": "El modo visual es útil cuando un operador + objeto no es suficientemente preciso. También es el modo de aprendizaje: puedes ver que vas a operar antes de hacerlo. Con la practica tendrás más confianza en los operadores directos. >> y << son los operadores de indentación: funcionan igual con un movimiento, por ejemplo >G indenta desde aquí hasta el final del archivo."
    },
    {
     "type": "practice",
     "id": "m04-practice",
     "heading": "Practica: objetos de texto",
     "lesson": "lesson-4",
     "url": "../../practice/index.html#lesson-4",
     "public_url": "https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-4"
    },
    {
     "type": "summary",
     "id": "m04-summary",
     "heading": "Resumen del módulo 04",
     "bullets": [
      "i (inner) opera dentro del delimitador. a (around) lo incluye.",
      "Las tres recetas del día a día: ciw, ci\", ci{",
      "v Visual, V líneas, Ctrl-v columnas. Luego d c y > < actúan.",
      ">> indenta, << desindenta. Con número: 3>> indenta tres líneas."
     ],
     "cheatcode": "ciw  ci\"  ci(  ci{  |  diw  da\"  |  >>  <<"
    }
   ]
  },
  {
   "id": "m05",
   "number": "05",
   "title": "Buscar y sustituir",
   "promise": "Encuentra cualquier texto y reemplazalo en todo el archivo.",
   "image": "img/05-buscar.jpg",
   "introduces": [
    "/",
    "?",
    "n",
    "N",
    "*",
    "#",
    ":s",
    ":%s"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m05-title",
     "number": "05",
     "heading": "Buscar y sustituir",
     "promise": "Encuentra cualquier texto y reemplazalo en todo el archivo.",
     "image": "img/05-buscar.jpg"
    },
    {
     "type": "concept",
     "id": "m05-buscar",
     "heading": "Búsqueda hacia adelante y hacia atrás",
     "bullets": [
      "/patrón Enter busca hacia adelante. ?patrón Enter busca hacia atrás.",
      "n va al siguiente resultado. N va al anterior.",
      "* busca la palabra bajo el cursor hacia adelante. # hacia atrás.",
      "En esta config, n y N también centran la pantalla en el resultado."
     ],
     "notes": "La búsqueda en Vim usa expresiones regulares por defecto. Para buscar texto literal con caracteres especiales, puedes usar /\\Vtexto (very nomagic). Para los usos habituales no hace falta: /function Enter ya encuentra lo que buscas. Después de terminar la búsqueda, :nohl o doble líder quita el resaltado."
    },
    {
     "type": "keys",
     "id": "m05-buscar-tabla",
     "heading": "Teclas de búsqueda",
     "rows": [
      {
       "key": "/patron",
       "action": "Buscar hacia adelante. Enter para confirmar."
      },
      {
       "key": "?patron",
       "action": "Buscar hacia atrás. Enter para confirmar."
      },
      {
       "key": "n",
       "action": "Siguiente coincidencia (en el sentido de la búsqueda)"
      },
      {
       "key": "N",
       "action": "Coincidencia anterior"
      },
      {
       "key": "*",
       "action": "Buscar la palabra bajo el cursor hacia adelante"
      },
      {
       "key": "#",
       "action": "Buscar la palabra bajo el cursor hacia atrás"
      }
     ]
    },
    {
     "type": "concept",
     "id": "m05-sustituir",
     "heading": "Sustitución con :s y :%s",
     "bullets": [
      ":s/viejo/nuevo/ sustituye la primera ocurrencia en la línea actual.",
      ":s/viejo/nuevo/g sustituye todas las ocurrencias de la línea actual.",
      ":%s/viejo/nuevo/g sustituye en todo el archivo.",
      ":%s/viejo/nuevo/gc pregunta confirmación en cada sustitución."
     ],
     "notes": "El % es el rango 'todo el archivo'. Otros rangos: :5,10s actúa en las líneas 5 a 10. :'<,'>s actúa en la selección visual (el rango se rellena solo si vienes de Visual). La bandera g significa 'todas las coincidencias de la línea' y es la más usada. La bandera c pide confirmación: útil cuando no estas seguro de que todas las coincidencias deban cambiar."
    },
    {
     "type": "keys",
     "id": "m05-sustituir-tabla",
     "heading": "Variantes de sustitución",
     "rows": [
      {
       "key": ":s/v/n/",
       "action": "Primera ocurrencia en la línea actual"
      },
      {
       "key": ":s/v/n/g",
       "action": "Todas en la línea actual"
      },
      {
       "key": ":%s/v/n/g",
       "action": "Todas en el archivo"
      },
      {
       "key": ":%s/v/n/gc",
       "action": "Todas en el archivo, con confirmación"
      },
      {
       "key": ":%s/v/n/gi",
       "action": "Todas en el archivo, sin distinción de mayúsculas"
      }
     ]
    },
    {
     "type": "practice",
     "id": "m05-practice",
     "heading": "Practica: buscar y sustituir (referencia)",
     "lesson": "lesson-5",
     "url": "../../practice/index.html#lesson-5",
     "public_url": "https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-5"
    },
    {
     "type": "summary",
     "id": "m05-summary",
     "heading": "Resumen del módulo 05",
     "bullets": [
      "/texto Enter busca hacia adelante. ?texto hacia atrás. n / N navegan.",
      "* busca la palabra bajo el cursor. # va hacia atrás.",
      ":%s/viejo/nuevo/g sustituye en todo el archivo.",
      "La bandera c pide confirmación. i ignora mayúsculas."
     ],
     "cheatcode": "/patrón  n N  *  #  |  :%s/v/n/g  :%s/v/n/gc"
    }
   ]
  },
  {
   "id": "m06",
   "number": "06",
   "title": "Registros y macros",
   "promise": "Guarda texto en cajones y automatiza tareas repetitivas.",
   "image": "img/06-registros-macros.jpg",
   "introduces": [
    "\"a",
    ":reg",
    "qa",
    "@a",
    "@@"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m06-title",
     "number": "06",
     "heading": "Registros y macros",
     "promise": "Guarda texto en cajones y automatiza tareas repetitivas.",
     "image": "img/06-registros-macros.jpg"
    },
    {
     "type": "concept",
     "id": "m06-registros",
     "heading": "Que son los registros",
     "bullets": [
      "Un registro es un 'cajon' donde Vim guarda texto copiado o borrado.",
      "\" (sin nombre): el último yank o borrado. 0: solo yanks, sin borrados.",
      "a-z: los tuyos para guardar lo que quieras. \"+: el portapapeles del sistema.",
      "\"_: el agujero negro. \"_dd borra sin tocar el registro sin nombre."
     ],
     "notes": "El registro sin nombre es el que usa p por defecto. Si haces dd y luego yy, el dd machaca lo que habia en el registro sin nombre. El registro 0 siempre tiene el último yank, sin importar cuantos borrados hayas hecho después. Los registros a-z son ideales para guardar fragmentos de código que necesitas pegar varias veces."
    },
    {
     "type": "keys",
     "id": "m06-usar-reg",
     "heading": "Usar registros con nombre",
     "rows": [
      {
       "key": "\"ayy",
       "action": "Copiar la línea al registro a"
      },
      {
       "key": "\"ap",
       "action": "Pegar el contenido del registro a"
      },
      {
       "key": "\"+y",
       "action": "Copiar al portapapeles del sistema"
      },
      {
       "key": "\"+p",
       "action": "Pegar del portapapeles del sistema"
      },
      {
       "key": ":reg",
       "action": "Ver el contenido de todos los registros"
      },
      {
       "key": "\"_dd",
       "action": "Borrar sin modificar el registro sin nombre"
      }
     ]
    },
    {
     "type": "concept",
     "id": "m06-macros",
     "heading": "Macros: grabar y reproducir",
     "bullets": [
      "qa empieza a grabar en el registro a. Todo lo que hagas queda grabado.",
      "q (en Normal) para la grabación.",
      "@a reproduce la macro del registro a. @@ repite la última macro.",
      "5@a reproduce la macro cinco veces. Útil para listas o transformaciones en bloque."
     ],
     "notes": "Las macros son uno de los poderes ocultos de Vim. La idea es: haces una tarea una vez mientras grabas, y luego la repites tantas veces como necesites. El truco para que funcionen bien en un archivo es que el movimiento al final de la macro deje el cursor en la posición correcta para la siguiente iteración. Por ejemplo: termina la macro con j para bajar una línea, y @@ o 10@a aplicara el cambio a 10 líneas consecutivas."
    },
    {
     "type": "keys",
     "id": "m06-macro-keys",
     "heading": "Grabar y reproducir una macro",
     "rows": [
      {
       "key": "qa",
       "action": "Empezar a grabar en el registro a (cualquier letra)"
      },
      {
       "key": "q",
       "action": "Parar la grabación (en modo Normal)"
      },
      {
       "key": "@a",
       "action": "Reproducir la macro del registro a"
      },
      {
       "key": "@@",
       "action": "Reproducir la última macro ejecutada"
      },
      {
       "key": "5@a",
       "action": "Reproducir la macro cinco veces"
      }
     ]
    },
    {
     "type": "demo",
     "id": "m06-demo-reg",
     "heading": "\"ayy luego \"ap: copiar al registro a y pegar",
     "start": "hello",
     "cursor": [
      0,
      0
     ],
     "keys": "\"ayy\"ap",
     "result": {
      "text": "hello\nhello",
      "cursor": [
       1,
       0
      ]
     },
     "say": "\"ayy copia la línea al registro a. \"ap pega el contenido del registro."
    },
    {
     "type": "practice",
     "id": "m06-practice",
     "heading": "Practica: registros y macros (referencia)",
     "lesson": "lesson-6",
     "url": "../../practice/index.html#lesson-6",
     "public_url": "https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-6"
    },
    {
     "type": "summary",
     "id": "m06-summary",
     "heading": "Resumen del módulo 06",
     "bullets": [
      "\"ayy copia al registro a. \"ap pega. \"+y y \"+p usan el portapapeles del SO.",
      ":reg muestra todos los registros. \"_ es el agujero negro.",
      "qa graba macro en a. q para. @a reproduce. @@ repite. 5@a repite cinco veces.",
      "Disenha la macro para que el cursor quede listo para la siguiente iteración."
     ],
     "cheatcode": "\"ayy  \"ap  :reg  |  qa ... q  @a  @@  5@a"
    }
   ]
  },
  {
   "id": "m07",
   "number": "07",
   "title": "Buffers, ventanas, pestañas y terminales",
   "promise": "Trabaja con varios archivos y terminales al mismo tiempo.",
   "image": "img/07-ventanas-terminales.jpg",
   "introduces": [
    ":e",
    ":ls",
    ":b",
    ":bd",
    ":sp",
    ":vsp",
    "Ctrl-w"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m07-title",
     "number": "07",
     "heading": "Buffers, ventanas, pestañas y terminales",
     "promise": "Trabaja con varios archivos y terminales al mismo tiempo.",
     "image": "img/07-ventanas-terminales.jpg"
    },
    {
     "type": "concept",
     "id": "m07-conceptos",
     "heading": "Buffer, ventana y pestaña",
     "bullets": [
      "Buffer: un archivo cargado en memoria. Puede no estar visible en ninguna ventana.",
      "Ventana: un hueco en la pantalla que muestra un buffer. El mismo buffer puede verse en dos ventanas.",
      "Pestaña: un conjunto de ventanas. Útil para separar contextos de trabajo.",
      ":ls lista los buffers abiertos. El número delante es el ID."
     ],
     "notes": "La distinción entre buffer y ventana es importante. Cuando haces :e nuevo.txt, creas un buffer. Cuando haces Ctrl-w v, creas una nueva ventana que puede mostrar cualquier buffer. No tienes que cerrar un buffer para abrir otro. Puedes tener 20 buffers abiertos y solo dos ventanas visibles. :ls te muestra todos los buffers y te permite saltar entre ellos."
    },
    {
     "type": "keys",
     "id": "m07-buffers",
     "heading": "Gestionar buffers",
     "rows": [
      {
       "key": ":e archivo",
       "action": "Abrir o crear un buffer para ese archivo"
      },
      {
       "key": ":ls",
       "action": "Listar los buffers abiertos"
      },
      {
       "key": ":b2",
       "action": "Ir al buffer número 2"
      },
      {
       "key": ":bn :bp",
       "action": "Buffer siguiente / anterior"
      },
      {
       "key": ":bd",
       "action": "Cerrar (borrar) el buffer actual"
      }
     ]
    },
    {
     "type": "keys",
     "id": "m07-ventanas",
     "heading": "Dividir ventanas (Ctrl-w)",
     "rows": [
      {
       "key": "<C-w>s",
       "action": "Dividir horizontalmente"
      },
      {
       "key": "<C-w>v",
       "action": "Dividir verticalmente"
      },
      {
       "key": "<C-w>h/j/k/l",
       "action": "Moverse a la ventana izquierda/abajo/arriba/derecha"
      },
      {
       "key": "<C-w>c",
       "action": "Cerrar la ventana actual"
      },
      {
       "key": "<C-w>o",
       "action": "Cerrar todas las demas ventanas"
      }
     ]
    },
    {
     "type": "concept",
     "id": "m07-terminales",
     "heading": "Terminales con esta config",
     "bullets": [
      "<leader>tv abre un terminal a la derecha. <leader>th lo abre abajo.",
      "2 <leader>tv abre un segundo terminal a la derecha.",
      "<leader>ta oculta o muestra todos los terminales sin cerrar sus procesos.",
      "jj sale del modo terminal y vuelve a Normal (igual que en modos de texto)."
     ],
     "notes": "Esta config tiene un sistema de terminales tipo tmux. Puedes tener varios terminales abiertos con números: 1leader tv, 2leader tv, 3leader tv... y ocultar/mostrar todos con <leader>ta. Dentro del terminal, jj vuelve a modo Normal y Ctrl-h/j/k/l cambia de ventana como si fueran paneles de tmux. El proceso del terminal sigue corriendo aunque lo ocultes."
    },
    {
     "type": "config",
     "id": "m07-config",
     "heading": "Prueba estos atajos de esta config",
     "rows": [
      {
       "key": "<leader>tv",
       "mode": "Normal",
       "desc": "Terminal split on the right (`2<leader>tv` = terminal 2)"
      },
      {
       "key": "<leader>th",
       "mode": "Normal",
       "desc": "Terminal split at the bottom (`3<leader>th` = terminal 3)"
      },
      {
       "key": "<leader>ta",
       "mode": "Normal",
       "desc": "Show / hide all terminals"
      },
      {
       "key": "<leader>tl",
       "mode": "Normal",
       "desc": "Pick a terminal from a list"
      },
      {
       "key": "jj",
       "mode": "Terminal",
       "desc": "Exit terminal mode"
      },
      {
       "key": "<S-l>",
       "mode": "Normal",
       "desc": "Next buffer (quick)"
      },
      {
       "key": "<S-h>",
       "mode": "Normal",
       "desc": "Previous buffer (quick)"
      },
      {
       "key": "<leader>bn",
       "mode": "Normal",
       "desc": "Next buffer"
      },
      {
       "key": "<leader>bp",
       "mode": "Normal",
       "desc": "Previous buffer"
      },
      {
       "key": "<leader>bd",
       "mode": "Normal",
       "desc": "Close buffer"
      },
      {
       "key": "<leader>sv",
       "mode": "Normal",
       "desc": "Split vertical"
      },
      {
       "key": "<leader>sh",
       "mode": "Normal",
       "desc": "Split horizontal"
      }
     ]
    },
    {
     "type": "practice",
     "id": "m07-practice",
     "heading": "Practica: buffers, ventanas y terminales",
     "lesson": "lesson-7",
     "url": "../../practice/index.html#lesson-7",
     "public_url": "https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-7"
    },
    {
     "type": "summary",
     "id": "m07-summary",
     "heading": "Resumen del módulo 07",
     "bullets": [
      "Buffer: archivo en memoria. Ventana: vista de un buffer. Pestaña: grupo de ventanas.",
      ":e archivo abre. :ls lista. :bn :bp navegan. :bd cierra.",
      "Ctrl-w v/s divide. Ctrl-w h/j/k/l cambia de ventana.",
      "<leader>tv terminal derecha. <leader>th abajo. jj sale del modo terminal.",
      "<leader>ta oculta/muestra todos los terminales sin cerrar los procesos."
     ],
     "cheatcode": ":e :ls :bn :bp :bd  |  Ctrl-w v/s/h/j/k/l  |  SPC tv th ta  |  jj"
    }
   ]
  },
  {
   "id": "m08",
   "number": "08",
   "title": "Instalar esta configuración",
   "promise": "De cero a un Neovim con LSP, plugins y agentes de IA.",
   "image": "img/08-instalar.jpg",
   "introduces": [],
   "slides": [
    {
     "type": "title",
     "id": "m08-title",
     "number": "08",
     "heading": "Instalar esta configuración",
     "promise": "De cero a un Neovim con LSP, plugins y agentes de IA.",
     "image": "img/08-instalar.jpg"
    },
    {
     "type": "concept",
     "id": "m08-requisitos",
     "heading": "Requisitos antes de instalar",
     "bullets": [
      "Neovim 0.12 o más reciente. Versión de referencia del curso: 0.12.6.",
      "Git, Node.js 22+, ripgrep (rg) y fd para búsquedas.",
      "Nerd Font instalada en el terminal: JetBrainsMono Nerd Font Mono.",
      "tree-sitter CLI >= 0.26.1 y un compilador C (xcode-select en Mac, GCC en Linux, Developer PowerShell en Windows)."
     ],
     "notes": "Sin Nerd Font los iconos aparecen como recuadros con signos de interrogación. Es el problema más comun al instalar. La fuente se instala en el sistema operativo y se selecciona en el emulador de terminal, no en Neovim. En Windows, asegurate de usar una Developer PowerShell para tree-sitter: necesita cl.exe en el PATH."
    },
    {
     "type": "concept",
     "id": "m08-windows",
     "heading": "Instalar en Windows",
     "bullets": [
      "winget install Neovim.Neovim Git.Git DEVCOM.JetBrainsMonoNerdFont",
      "git clone https://github.com/chochy2001/Neovim-Vim_Configuration.git $HOME/Neovim-Vim_Configuration",
      "New-Item -ItemType Junction -Path \"$env:LOCALAPPDATA/nvim\" -Target \"$HOME/Neovim-Vim_Configuration/.config/nvim\"",
      "Selecciona JetBrainsMono NFM en el terminal y cierra para aplicar la fuente."
     ],
     "notes": "En Windows se usa una Junction (enlace de directorio) en lugar de un symlink, porque los symlinks necesitan permisos de administrador. La Junction de LOCALAPPDATA/nvim apunta a la subcarpeta .config/nvim del repositorio clonado, no al repositorio entero. Instala también tree-sitter con los binarios oficiales o cargo install tree-sitter-cli."
    },
    {
     "type": "concept",
     "id": "m08-macos",
     "heading": "Instalar en macOS y Linux",
     "bullets": [
      "Instala Neovim, Git, Node, ripgrep y fd con brew (Mac) o el gestor de paquetes.",
      "git clone https://github.com/chochy2001/Neovim-Vim_Configuration.git ~/Neovim-Vim_Configuration",
      "mkdir -p ~/.config && ln -s ~/Neovim-Vim_Configuration/.config/nvim ~/.config/nvim",
      "ln -s ~/Neovim-Vim_Configuration/.ideavimrc ~/.ideavimrc"
     ],
     "notes": "El symlink apunta a la subcarpeta .config/nvim, no al repositorio completo. Si ya tienes una configuración en ~/.config/nvim, haz una copia de seguridad antes. En macOS ejecuta xcode-select --install para el compilador de tree-sitter. En Linux instala gcc o clang. No clones el repositorio dentro de ~/.config/nvim: haz el symlink."
    },
    {
     "type": "concept",
     "id": "m08-arranque",
     "heading": "Primer arranque y verificación",
     "bullets": [
      "Abre nvim (sin argumentos). lazy.nvim instala los plugins automáticamente. Espera.",
      ":Lazy muestra el estado de los plugins. :Mason instala servidores LSP en segundo plano.",
      "Comprueba el arranque: nvim --headless \"+lua print('boot-ok')\" +qa",
      "Si sale boot-ok sin errores, la config base funciona. :checkhealth da más detalles."
     ],
     "notes": "La primera vez que abras Neovim con esta config tardara unos minutos: lazy.nvim descarga todos los plugins, tree-sitter compila los parsers y Mason puede instalar algunos servidores LSP. No toques nada mientras lo hace. Si algo falla, :Lazy y :Mason muestran los errores. En instalaciones sin internet, usa NVIM_OFFLINE=1 para desactivar las descargas automáticas."
    },
    {
     "type": "concept",
     "id": "m08-fuentes",
     "heading": "Nerd Font e iconos",
     "bullets": [
      "Los iconos en la barra de estado, el árbol de archivos y los diagnósticos necesitan Nerd Font.",
      "Instala JetBrainsMono Nerd Font y selecciona la variante Mono en tu terminal.",
      "Sin la fuente los iconos aparecen como recuadros: es un problema del terminal, no de Neovim.",
      "Alternativa: NVIM_NERD_FONT=0 nvim usa letras (E W I H) en lugar de iconos."
     ],
     "notes": "La variante Mono es importante: las variantes normales tienen glifos de ancho doble que se superponen en algunos terminales. En Warp, Windows Terminal y kitty la fuente se configura en la sección de apariencia de las preferencias. En herdr la fuente viene del terminal que lo contiene. Si tras instalar la fuente siguen los recuadros, cierra y vuelve a abrir el terminal."
    },
    {
     "type": "practice",
     "id": "m08-practice",
     "heading": "Practica: instala y verifica tu config",
     "lesson": "lesson-8",
     "url": "../../practice/index.html#lesson-8",
     "public_url": "https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-8"
    },
    {
     "type": "summary",
     "id": "m08-summary",
     "heading": "Resumen del módulo 08",
     "bullets": [
      "Neovim 0.12+, Node 22+, ripgrep, Nerd Font y tree-sitter CLI.",
      "Clona el repo y crea un symlink (o junction en Windows) a .config/nvim.",
      "Primera vez: nvim espera a lazy.nvim. :Lazy y :Mason instalan el resto.",
      "Comprueba: nvim --headless '+lua print(boot-ok)' +qa",
      "Sin Nerd Font: iconos como recuadros. Configura la fuente en el terminal."
     ]
    }
   ]
  },
  {
   "id": "m09",
   "number": "09",
   "title": "Neovim como IDE",
   "promise": "Telescope, LSP, Git integrado y Markdown renderizado.",
   "image": "img/09-ide.jpg",
   "introduces": [
    "<leader>ff",
    "<leader>fg",
    "<leader>pv",
    "gd",
    "K",
    "<leader>rn",
    "<leader>ca",
    "<leader>fm",
    "<leader>gs",
    "<leader>gsa"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m09-title",
     "number": "09",
     "heading": "Neovim como IDE con esta config",
     "promise": "Telescope, LSP, Git integrado y Markdown renderizado.",
     "image": "img/09-ide.jpg"
    },
    {
     "type": "concept",
     "id": "m09-telescope",
     "heading": "Telescope: buscar archivos y texto",
     "bullets": [
      "<leader>ff abre el buscador de archivos difuso. Escribe parte del nombre.",
      "<leader>fg busca texto en todos los archivos (necesitas ripgrep).",
      "<leader>fo muestra archivos recientes. <leader>fb lista los buffers abiertos.",
      "Espacio dos veces limpia el resaltado de búsqueda. No abre el buscador."
     ],
     "notes": "Telescope es la forma más rápida de navegar proyectos grandes. <leader>ff con parte del nombre del archivo es suficiente para cualquier proyecto. <leader>fg busca el texto que escribes en todos los archivos del directorio. Cuando which-key muestre el menú (pulsa Espacio y espera), veras todos los prefijos disponibles."
    },
    {
     "type": "concept",
     "id": "m09-arbol",
     "heading": "Árbol de archivos y navegación",
     "bullets": [
      "<leader>pv abre o cierra el árbol de archivos (Neo-tree).",
      "<leader>fr muestra el archivo actual en el árbol.",
      "- o <leader>oe abre oil.nvim: edita el directorio como si fuera un buffer.",
      "Espacio y espera muestra which-key: el índice de todos los atajos."
     ],
     "notes": "Neo-tree muestra la estructura del proyecto. Oil.nvim es diferente: te deja renombrar, mover y borrar archivos simplemente editando el texto del buffer del directorio, como si fuera un archivo de texto. Para renombrar un archivo con oil, abrelo, edita el nombre y guarda con :w. Para borrarlo, borra la línea y guarda."
    },
    {
     "type": "concept",
     "id": "m09-lsp",
     "heading": "LSP: inteligencia del código",
     "bullets": [
      "gd va a la definición del símbolo bajo el cursor. Ctrl-o vuelve atrás.",
      "K muestra la documentación del símbolo (hover).",
      "<leader>rn renombra el símbolo en todo el proyecto.",
      "<leader>fm formatea el archivo con el formateador del lenguaje."
     ],
     "notes": "El LSP necesita que el servidor del lenguaje este instalado. :Mason muestra los servidores disponibles e instalados. Para Dart y Flutter, el servidor se configura automáticamente con flutter-tools, no con Mason. :checkhealth vim.lsp muestra que servidores están activos en el buffer actual. gd añade una entrada al historial de saltos: Ctrl-o vuelve atrás y Ctrl-i adelante."
    },
    {
     "type": "concept",
     "id": "m09-git",
     "heading": "Git integrado y Markdown",
     "bullets": [
      "<leader>gs abre el estado de Git. <leader>gc hace commit. <leader>gp hace push.",
      "<leader>gn / <leader>gnp navegan hunks (cambios individuales).",
      "<leader>gsa prepara un hunk para el commit. <leader>gsr lo descarta.",
      "<leader>tm alterna entre Markdown renderizado y texto crudo."
     ],
     "notes": "El flujo de Git con esta config es: <leader>gs para ver el estado, <leader>gn para navegar los hunks, <leader>gsa para preparar (stage) los que quieres, <leader>gc para escribir el mensaje de commit. Para un diff visual completo usa <leader>gdo (diffview). <leader>tg abre LazyGit en un terminal integrado, que es un TUI completo para Git."
    },
    {
     "type": "config",
     "id": "m09-config",
     "heading": "Prueba estos atajos de IDE",
     "rows": [
      {
       "key": "<leader>ff",
       "mode": "Normal",
       "desc": "Find files"
      },
      {
       "key": "<leader>fg",
       "mode": "Normal",
       "desc": "Live grep (search in files)"
      },
      {
       "key": "<leader>pv",
       "mode": "Normal",
       "desc": "Toggle file tree"
      },
      {
       "key": "gd",
       "mode": "Normal",
       "desc": "Go to definition (configured on LspAttach)"
      },
      {
       "key": "K",
       "mode": "Normal",
       "desc": "Hover documentation"
      },
      {
       "key": "<leader>rn",
       "mode": "Normal",
       "desc": "Rename symbol"
      },
      {
       "key": "<leader>ca",
       "mode": "Normal/Visual",
       "desc": "Code action"
      },
      {
       "key": "<leader>fm",
       "mode": "Normal",
       "desc": "Format (one attached none-ls client with an applicable source, otherwise one attached LSP)"
      },
      {
       "key": "<leader>gs",
       "mode": "Normal",
       "desc": "Git status"
      },
      {
       "key": "<leader>gn",
       "mode": "Normal",
       "desc": "Next hunk"
      },
      {
       "key": "<leader>gsa",
       "mode": "Normal",
       "desc": "Stage hunk"
      },
      {
       "key": "<leader>gc",
       "mode": "Normal",
       "desc": "Git commit"
      },
      {
       "key": "<leader>tm",
       "mode": "Normal",
       "desc": "Markdown: rendered (headings, tables, code) / raw"
      }
     ]
    },
    {
     "type": "summary",
     "id": "m09-summary",
     "heading": "Resumen del módulo 09",
     "bullets": [
      "<leader>ff busca archivos. <leader>fg busca texto. <leader>pv árbol.",
      "gd definición. K documentación. <leader>rn renombra. <leader>fm formatea.",
      "<leader>gs Git status. <leader>gn hunk siguiente. <leader>gsa prepara hunk.",
      "<leader>tm alterna Markdown renderizado / crudo.",
      "Espacio + esperar muestra which-key: el índice completo de atajos."
     ]
    }
   ]
  },
  {
   "id": "m10",
   "number": "10",
   "title": "IA con Neovim",
   "promise": "Diez agentes de IA directamente en tu editor.",
   "image": "img/10-ia.jpg",
   "introduces": [
    "<leader>aa",
    "<leader>as"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m10-title",
     "number": "10",
     "heading": "IA con Neovim",
     "promise": "Diez agentes de IA directamente en tu editor.",
     "image": "img/10-ia.jpg"
    },
    {
     "type": "concept",
     "id": "m10-agentes",
     "heading": "Agentes de IA disponibles",
     "bullets": [
      "<leader>aa opencode. <leader>ax codex. <leader>ac claude. <leader>ag gemini.",
      "<leader>ak grok. <leader>ap copilot CLI. <leader>am muse. <leader>au cursor-agent.",
      "<leader>an agy (antigravity). <leader>ai kimi.",
      "Cada agente se abre en un terminal integrado. Usa tus propias suscripciones, sin API keys."
     ],
     "notes": "Esta config no usa API keys: cada agente usa las credenciales de tu cuenta. opencode, codex, claude, gemini, grok y copilot se instalan como CLIs independientes. Si un CLI no esta instalado, el atajo muestra el comando de instalación en lugar de fallar. Los agentes ven el mismo repositorio que Neovim porque se abren en el mismo directorio."
    },
    {
     "type": "concept",
     "id": "m10-flujo",
     "heading": "Flujo de trabajo con agentes",
     "bullets": [
      "Selecciona código con v o V, luego <leader>as para preparar la selección.",
      "Elige el agente, escribe la instrucción. El prompt va al portapapeles y al registro a.",
      "Pega en el terminal del agente cuando este listo. Revisa y envía.",
      "El archivo modificado por el agente se recarga automáticamente en Neovim."
     ],
     "notes": "El flujo completo es: 1) selecciona el código relevante con V o v, 2) <leader>as abre el selector de agente, 3) escribe la instrucción (refactoriza, explica, añade tests...), 4) el agente se abre y el prompt esta en el portapapeles, 5) pegas en el agente con Ctrl-V o Cmd-V, 6) cuando el agente termina y guarda el archivo, Neovim lo recarga automáticamente. No necesitas cambiar de ventana."
    },
    {
     "type": "concept",
     "id": "m10-herdr",
     "heading": "herdr y paneles multiples",
     "bullets": [
      "herdr es un multiplexor de terminales. Neovim en un panel, agentes en otros.",
      "Cada agente lee AGENTS.md (Claude por CLAUDE.md, Gemini por GEMINI.md).",
      "Cuando un agente guarda un archivo, Neovim lo recarga en menos de 0.1 s.",
      "Revisa los cambios con <leader>gsp (preview de hunk) o <leader>gdo (diffview)."
     ],
     "notes": "herdr es similar a tmux pero más simple. El prefijo es Ctrl-b. Con Neovim en un panel y opencode en otro, puedes ver los cambios del agente en tiempo real sin mover el foco. <leader>gsr descarta un hunk si el agente hizo algo incorrecto. Los archivos AGENTS.md y CLAUDE.md son el contexto del proyecto que los agentes leen automáticamente."
    },
    {
     "type": "concept",
     "id": "m10-reload",
     "heading": "Recarga automática de archivos",
     "bullets": [
      "Cuando un agente edita un archivo en disco, Neovim lo detecta y lo recarga.",
      "Un buffer con cambios sin guardar no se sobreescribe: recibes un aviso.",
      ":e! acepta la versión del disco. :w conserva la tuya.",
      "La vigilancia usa lua/external-changes.lua con checktime en varios eventos."
     ],
     "notes": "La recarga automática es uno de los detalles que hacen comodo trabajar con agentes. Neovim vigila todos los archivos abiertos y cuando uno cambia en disco lo recarga. Si tienes cambios sin guardar, el archivo no se sobreescribe y recibes un mensaje de advertencia. Decides: :e! toma la versión del agente, :w conserva la tuya. Esto evita perder trabajo por accident."
    },
    {
     "type": "concept",
     "id": "m10-flujo-dia",
     "heading": "El flujo de un día con IA",
     "bullets": [
      "1. <leader>fp abre un proyecto reciente; <leader>ff busca un archivo dentro.",
      "2. <leader>pv abre el árbol; Enter abre, <leader>pv lo cierra.",
      "3. Lee el código: gd va a la definición, K muestra la documentación, gR lista referencias, Ctrl-o vuelve.",
      "4. Selecciona con V lo que el agente necesita; <leader>as abre el selector y escribe la instrucción.",
      "5. El archivo modificado se recarga solo en Neovim; sin acción extra.",
      "6. Revisa: <leader>gsp muestra el hunk; <leader>gdo el diff completo; <leader>gsr deshace un bloque."
     ],
     "notes": "Este es el ciclo completo de un día de trabajo con IA en Neovim. No necesitas cambiar de ventana ni copiar código a mano: el agente esta en el mismo repositorio. <leader>gsr descarta un hunk si el agente hizo algo incorrecto. La recarga automática funciona porque Neovim tiene un autocmd que ejecuta checktime cuando el buffer vuelve al foco."
    },
    {
     "type": "config",
     "id": "m10-config",
     "heading": "Prueba estos atajos de IA",
     "rows": [
      {
       "key": "<leader>aa",
       "mode": "Normal",
       "desc": "opencode terminal"
      },
      {
       "key": "<leader>ax",
       "mode": "Normal",
       "desc": "codex terminal"
      },
      {
       "key": "<leader>ac",
       "mode": "Normal",
       "desc": "claude terminal"
      },
      {
       "key": "<leader>ag",
       "mode": "Normal",
       "desc": "gemini terminal"
      },
      {
       "key": "<leader>ak",
       "mode": "Normal",
       "desc": "grok terminal"
      },
      {
       "key": "<leader>am",
       "mode": "Normal",
       "desc": "muse terminal"
      },
      {
       "key": "<leader>as",
       "mode": "Visual",
       "desc": "Prepare selection for an agent (picker + instruction)"
      },
      {
       "key": "<leader>cc",
       "mode": "Normal",
       "desc": "Toggle chat window"
      },
      {
       "key": "<leader>ce",
       "mode": "Normal/Visual",
       "desc": "Explain selected code"
      },
      {
       "key": "<leader>cf",
       "mode": "Normal/Visual",
       "desc": "Fix code"
      }
     ]
    },
    {
     "type": "summary",
     "id": "m10-summary",
     "heading": "Resumen del módulo 10",
     "bullets": [
      "Diez agentes de IA: <leader>aa-ai. Cada uno abre un terminal integrado.",
      "<leader>as prepara la selección para cualquier agente con instrucción.",
      "Los archivos editados por agentes se recargan solos en Neovim.",
      "herdr permite tener Neovim y los agentes en paneles separados del mismo terminal.",
      "AGENTS.md / CLAUDE.md / GEMINI.md son el contexto del proyecto para los agentes."
     ]
    }
   ]
  },
  {
   "id": "m11",
   "number": "11",
   "title": "Plugins de este repositorio",
   "promise": "Cuando usar cada plugin, no el catálogo entero.",
   "image": "img/11-plugins.jpg",
   "introduces": [
    "gcc",
    "gc",
    "s",
    "<leader>ma",
    "<leader>xx"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m11-title",
     "number": "11",
     "heading": "Plugins de este repositorio",
     "promise": "Cuando usar cada plugin, no el catálogo entero.",
     "image": "img/11-plugins.jpg"
    },
    {
     "type": "concept",
     "id": "m11-comments",
     "heading": "Comentarios y envolturas (Comment + Surround)",
     "bullets": [
      "gcc comenta o descomenta la línea actual. gc en visual comenta la selección.",
      "ysiw\" rodea la palabra con comillas. ds\" quita las comillas. cs\"' cambia \" por '.",
      "En visual, S envuelve la selección (S es surround, no Flash en visual).",
      "Estos atajos funcionan con cualquier delimitador: ( [ { ` ..."
     ],
     "notes": "Comment.nvim detecta el tipo de comentario según el lenguaje del archivo. En Lua usa -- , en Python usa # y en HTML usa <!-- -->. Surround.nvim es más potente de lo que parece: ysiw( rodea con paréntesis dejando un espacio, ysiw) sin espacio. cs({ cambia paréntesis por llaves. Los delimitadores funcionan igual que los objetos de texto: i y a."
    },
    {
     "type": "concept",
     "id": "m11-nav",
     "heading": "Navegación avanzada (Flash y Harpoon)",
     "bullets": [
      "s en Normal/Visual salta a cualquier carácter de la pantalla con dos teclas.",
      "<leader>ma marca el archivo actual en Harpoon. leader 1-9 salta al marcado.",
      "<leader>mh muestra la lista de Harpoon. Es tu lista de archivos frecuentes.",
      "Harpoon es mejor que los recientes: tu eliges que entra, no el editor."
     ],
     "notes": "Flash es una alternativa a easymotion: escribe s y luego los primeros dos caracteres del destino, y Flash muestra etiquetas de una o dos letras para saltar directamente. Es mucho más rápido que buscar con / o usar muchos w. Harpoon guarda una lista persistente de archivos importantes del proyecto. <leader>ma añade el archivo actual, y leader 1 salta al primero de la lista, leader 2 al segundo, etc."
    },
    {
     "type": "concept",
     "id": "m11-trouble",
     "heading": "Diagnósticos con Trouble",
     "bullets": [
      "<leader>xx abre el panel de Trouble con todos los errores y advertencias.",
      "<leader>xn va al siguiente error. <leader>xp al anterior.",
      "<leader>xw lista todos los diagnósticos del workspace (todos los archivos).",
      "gR en LSP muestra todas las referencias del símbolo en Trouble."
     ],
     "notes": "Trouble es una lista de diagnósticos más usable que la lista de quickfix nativa. Muestra errores del LSP, warnings, TODOs y resultados de búsqueda en un panel lateral. <leader>xn y xp son más rápidos que scrollear el panel. Para ver solo los TODOs del proyecto usa <leader>xt. Los diagnósticos de LSP aparecen en la barra de estado y en el texto inline; Trouble los agrupa todos."
    },
    {
     "type": "concept",
     "id": "m11-undo",
     "heading": "Undotree, Telescope y más",
     "bullets": [
      "<leader>u en Normal abre el árbol de historial de deshacer (undotree).",
      "<leader>sr busca y reemplaza en varios archivos con grug-far (como sed pero visual).",
      "<leader>fk lista todos los atajos registrados en Telescope. Es el índice completo.",
      ":Telescope keymaps hace lo mismo desde la línea de comandos."
     ],
     "notes": "El árbol de deshacer de Vim es más potente que un historial lineal: guarda ramas. Si deshaces y luego haces un cambio diferente, la rama anterior no desaparece. <leader>u muestra ese árbol y te permite saltar a cualquier estado anterior. Grug-far es como un sed visual: busca en todos los archivos y muestra los reemplazos antes de confirmarlos."
    },
    {
     "type": "config",
     "id": "m11-config",
     "heading": "Prueba estos plugins",
     "rows": [
      {
       "key": "gcc",
       "mode": "Normal",
       "desc": "Toggle line comment"
      },
      {
       "key": "gc",
       "mode": "Visual",
       "desc": "Toggle comment on selection"
      },
      {
       "key": "s",
       "mode": "Normal/Visual/Operator",
       "desc": "Flash: jump to any character"
      },
      {
       "key": "<leader>ma",
       "mode": "Normal",
       "desc": "Add file to harpoon"
      },
      {
       "key": "<leader>mh",
       "mode": "Normal",
       "desc": "Toggle harpoon UI"
      },
      {
       "key": "<leader>1 - <leader>9",
       "mode": "Normal",
       "desc": "Jump to mark 1-9"
      },
      {
       "key": "<leader>xx",
       "mode": "Normal",
       "desc": "Toggle trouble"
      },
      {
       "key": "<leader>xn",
       "mode": "Normal",
       "desc": "Next error/diagnostic"
      },
      {
       "key": "<leader>xp",
       "mode": "Normal",
       "desc": "Previous error/diagnostic"
      },
      {
       "key": "<leader>u",
       "mode": "Normal",
       "desc": "Toggle undo tree"
      },
      {
       "key": "<leader>sr",
       "mode": "Normal/Visual",
       "desc": "Search and replace (grug-far)"
      }
     ]
    },
    {
     "type": "summary",
     "id": "m11-summary",
     "heading": "Resumen del módulo 11",
     "bullets": [
      "gcc comenta la línea. Surround: ysiw\" rodea, ds\" quita, cs\"' cambia.",
      "s salta a cualquier carácter de la pantalla (Flash).",
      "<leader>ma marca un archivo en Harpoon. leader 1-9 salta.",
      "<leader>xx abre Trouble. <leader>xn / xp navegan errores.",
      "<leader>u abre el árbol de historial de deshacer."
     ]
    }
   ]
  },
  {
   "id": "m12",
   "number": "12",
   "title": "IdeaVim",
   "promise": "Los mismos atajos en IntelliJ y Android Studio.",
   "image": "img/12-ideavim.jpg",
   "introduces": [],
   "slides": [
    {
     "type": "title",
     "id": "m12-title",
     "number": "12",
     "heading": "IdeaVim",
     "promise": "Los mismos atajos en IntelliJ y Android Studio.",
     "image": "img/12-ideavim.jpg"
    },
    {
     "type": "concept",
     "id": "m12-que-es",
     "heading": "Que es IdeaVim",
     "bullets": [
      "IdeaVim es un plugin para IntelliJ Platform (IntelliJ, Android Studio, GoLand, etc.).",
      "Añade los modos Vim dentro del IDE: Normal, Insertar, Visual y Línea de comandos.",
      "Los atajos de Neovim se mapean a acciones del IDE con nmap ... <Action>(id).",
      "No es un Neovim embebido: comparte los modos pero no los plugins de Lua."
     ],
     "notes": "IdeaVim permite usar los modos de Vim en cualquier IDE de la familia IntelliJ sin instalar Neovim. Es útil cuando el proyecto requiere el IDE (por ejemplo, Android Studio para Flutter o Kotlin). Los atajos del .ideavimrc de este repositorio están pensados para ser lo más parecidos posible a los de Neovim, usando las mismas teclas donde hay una acción equivalente en el IDE."
    },
    {
     "type": "concept",
     "id": "m12-instalar",
     "heading": "Instalar y configurar",
     "bullets": [
      "Instala el plugin IdeaVim desde el marketplace del IDE.",
      "Activa Vim en el IDE: menú Tools -> Vim.",
      "Copia .ideavimrc a tu carpeta personal (~/.ideavimrc en Mac/Linux).",
      "Recarga con :source ~/.ideavimrc sin reiniciar el IDE."
     ],
     "notes": "El archivo .ideavimrc de este repositorio tiene un enlace simbolico en la carpeta personal. Cuando actualizas el repositorio con git pull, el .ideavimrc se actualiza automáticamente. Para ver todas las acciones disponibles en el IDE, escribe :actionlist en la línea de comandos de IdeaVim. Las acciones varian según el IDE y los plugins instalados."
    },
    {
     "type": "concept",
     "id": "m12-modos",
     "heading": "Los mismos modos en el IDE",
     "bullets": [
      "Normal, Insertar y Visual funcionan exactamente igual que en Neovim.",
      "hjkl, w b e, 0 ^ $, gg G, f t ; , d c y p . u funcionan de inmediato.",
      "Los atajos con <leader>Espacio mapean a acciones del IDE.",
      "jj sale de Insertar, igual que en Neovim."
     ],
     "notes": "La base de Vim (modos, movimientos, operadores, objetos de texto) funciona igual en IdeaVim que en Neovim. Lo que cambia son los atajos de los plugins: en lugar de Telescope, el IDE tiene su propio buscador; en lugar de LSP nativo, usa el analisis del IDE. Los atajos del .ideavimrc mapean a las acciones del IDE con la misma tecla cuando es posible."
    },
    {
     "type": "concept",
     "id": "m12-atajos",
     "heading": "Atajos compartidos",
     "bullets": [
      "<leader>ff busca archivos (SearchEverywhere del IDE). <leader>fg busca texto.",
      "gd va a la definición. K muestra la documentación. <leader>rn renombra.",
      "<leader>gs abre el panel de control de versiones del IDE.",
      "<leader>rn renombra en todo el proyecto con el refactor del IDE."
     ],
     "notes": "No todos los atajos de Neovim tienen equivalente en IdeaVim. Los que no existen simplemente no están en el .ideavimrc. Los atajos de IA (<leader>a*) y CopilotChat (<leader>c*) no están en IdeaVim porque son terminales integrados, no acciones del IDE. Para saber que atajos están mapeados, abre el .ideavimrc o escribe :actionlist en IdeaVim para ver las acciones disponibles."
    },
    {
     "type": "config",
     "id": "m12-config",
     "heading": "Atajos compartidos entre Neovim e IdeaVim",
     "rows": [
      {
       "key": "<leader>ff",
       "mode": "Normal",
       "desc": "Find files"
      },
      {
       "key": "<leader>fg",
       "mode": "Normal",
       "desc": "Live grep (search in files)"
      },
      {
       "key": "gd",
       "mode": "Normal",
       "desc": "Go to definition (configured on LspAttach)"
      },
      {
       "key": "K",
       "mode": "Normal",
       "desc": "Hover documentation"
      },
      {
       "key": "<leader>rn",
       "mode": "Normal",
       "desc": "Rename symbol"
      },
      {
       "key": "<leader>ca",
       "mode": "Normal/Visual",
       "desc": "Code action"
      },
      {
       "key": "<leader>gs",
       "mode": "Normal",
       "desc": "Git status"
      },
      {
       "key": "gcc",
       "mode": "Normal",
       "desc": "Toggle line comment"
      },
      {
       "key": "<leader>xx",
       "mode": "Normal",
       "desc": "Toggle trouble"
      }
     ]
    },
    {
     "type": "summary",
     "id": "m12-summary",
     "heading": "Resumen del módulo 12",
     "bullets": [
      "IdeaVim añade los modos Vim a IntelliJ, Android Studio y GoLand.",
      "Instala el plugin, activa Vim en Tools -> Vim, copia .ideavimrc.",
      "Los modos y atajos básicos de Vim funcionan igual.",
      "Los atajos con <leader>mapean a acciones del IDE.",
      "<leader>a* y CopilotChat no están en IdeaVim (son terminales de Neovim)."
     ]
    }
   ]
  },
  {
   "id": "m13",
   "number": "13",
   "title": "Cuando algo falla",
   "promise": "Diagnostica y resuelve los problemas más comunes.",
   "image": "img/13-diagnostico.jpg",
   "introduces": [
    ":checkhealth",
    ":Lazy",
    ":Mason"
   ],
   "slides": [
    {
     "type": "title",
     "id": "m13-title",
     "number": "13",
     "heading": "Cuando algo falla",
     "promise": "Diagnostica y resuelve los problemas más comunes.",
     "image": "img/13-diagnostico.jpg"
    },
    {
     "type": "concept",
     "id": "m13-checkhealth",
     "heading": ":checkhealth: el primer diagnóstico",
     "bullets": [
      ":checkhealth ejecuta todos los chequeos de salud de Neovim y los plugins.",
      ":checkhealth vim.lsp muestra que servidores LSP están activos en el buffer.",
      ":checkhealth nvim-treesitter muestra que parsers están compilados.",
      "Los errores en rojo son problemas reales. Los warnings en amarillo son opcionales."
     ],
     "notes": "Cuando algo no funciona, :checkhealth es el primer lugar donde mirar. Cada plugin puede registrar su propio chequeo. Los resultados muestran que dependencias faltan o tienen versiones incorrectas. Para el LSP especificamente, :checkhealth vim.lsp en el buffer donde deberia funcionar el LSP muestra si hay un servidor activo y que archivos no-ls o LSP están disponibles."
    },
    {
     "type": "concept",
     "id": "m13-lazy",
     "heading": ":Lazy y :Mason",
     "bullets": [
      ":Lazy abre el gestor de plugins. Los plugins en rojo fallaron al instalarse.",
      ":Lazy restore vuelve a las versiones del lockfile. :Lazy update actualiza.",
      ":Mason gestiona servidores LSP, formateadores y linters externos.",
      ":Mason instala las herramientas que el LSP necesita pero que no están en el sistema."
     ],
     "notes": "La mayoria de los problemas se resuelven con :Lazy (plugins) o :Mason (herramientas externas). Si un plugin falla, :Lazy muestra el error. Si el autocompletado no aparece, el servidor LSP del lenguaje probablemente no esta instalado: :Mason lo muestra. Para Dart y Flutter el servidor es especial: se gestiona con flutter-tools, no con Mason, y necesita el Flutter SDK en el PATH."
    },
    {
     "type": "concept",
     "id": "m13-iconos",
     "heading": "Iconos como recuadros y otros problemas",
     "bullets": [
      "Iconos como recuadros: la fuente del terminal no es una Nerd Font. Configura JetBrainsMono NFM.",
      "El atajo no responde: espera 300 ms (timeoutlen). :Telescope keymaps busca el atajo.",
      "E37 al salir: hay cambios sin guardar. Usa :wq para guardar o :q! para descartar.",
      "El LSP esta mudo para Dart: Flutter en PATH. No dupliques dartls con :LspRestartDart."
     ],
     "notes": "El problema de los iconos siempre es la fuente del terminal. Neovim no puede cambiar la fuente. Tiene que ser la variante Mono de JetBrainsMono Nerd Font para que los glifos no se superpongan. El timeout de 300 ms es el tiempo que espera Neovim antes de decidir que un prefijo esta completo. Si pulsas <leader>ff muy rápido, puede que no lo registre."
    },
    {
     "type": "keys",
     "id": "m13-tabla",
     "heading": "Tabla de problemas comunes",
     "rows": [
      {
       "key": "Recuadros con ?",
       "action": "Fuente del terminal: instala JetBrainsMono Nerd Font Mono"
      },
      {
       "key": "Plugin en rojo",
       "action": ":Lazy (ver el error y reinstalar)"
      },
      {
       "key": "Completar vacio",
       "action": ":Mason y :checkhealth vim.lsp"
      },
      {
       "key": "Dart / Flutter mudo",
       "action": "Flutter en PATH. :LspRestartDart. No duplicar dartls."
      },
      {
       "key": "Atajo no responde",
       "action": "Espera 300 ms. :Telescope keymaps para buscar el atajo."
      },
      {
       "key": ":messages",
       "action": "Ver mensajes recientes de Neovim (útiles para diagnosticar)"
      }
     ]
    },
    {
     "type": "config",
     "id": "m13-config",
     "heading": "Atajos de diagnóstico y errores",
     "rows": [
      {
       "key": "<leader>xx",
       "mode": "Normal",
       "desc": "Toggle trouble"
      },
      {
       "key": "<leader>xd",
       "mode": "Normal",
       "desc": "Document diagnostics"
      },
      {
       "key": "<leader>xw",
       "mode": "Normal",
       "desc": "Workspace diagnostics"
      },
      {
       "key": "<leader>xn",
       "mode": "Normal",
       "desc": "Next error/diagnostic"
      },
      {
       "key": "<leader>xp",
       "mode": "Normal",
       "desc": "Previous error/diagnostic"
      },
      {
       "key": "<leader>fk",
       "mode": "Normal",
       "desc": "Keymaps"
      },
      {
       "key": "gR",
       "mode": "Normal",
       "desc": "References in Trouble"
      }
     ]
    },
    {
     "type": "summary",
     "id": "m13-summary",
     "heading": "Resumen del módulo 13",
     "bullets": [
      ":checkhealth es el primer diagnóstico. :checkhealth vim.lsp para el LSP.",
      ":Lazy gestiona plugins. :Mason gestiona herramientas externas.",
      "Iconos como recuadros: configura JetBrainsMono NFM en el terminal.",
      ":messages muestra los mensajes recientes de Neovim.",
      "<leader>xx abre Trouble con todos los diagnósticos del documento o proyecto."
     ]
    }
   ]
  }
 ]
};
