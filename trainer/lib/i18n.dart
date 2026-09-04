class T {
  const T(this.es);
  final bool es;

  String get app => es ? 'CAPDESIS Practice' : 'CAPDESIS Practice';
  String get typewriter => es ? 'Mecanografía' : 'Typewriter';
  String get vim => es ? 'Vim' : 'Vim';
  String get about => es ? 'Acerca de' : 'About';
  String get lang => es ? 'Español' : 'English';
  String get next => es ? 'Siguiente' : 'Next';
  String get reset => es ? 'Reiniciar' : 'Reset';
  String get check => es ? 'Comprobar' : 'Check';
  String get ok => es ? 'Hecho' : 'Done';
  String get notYet => es ? 'Aún no' : 'Not yet';
  String get wpm => es ? 'PPM' : 'WPM';
  String get acc => es ? 'Precisión' : 'Accuracy';
  String get modeN => es ? 'NORMAL' : 'NORMAL';
  String get modeI => es ? 'INSERTAR' : 'INSERT';
  String get subset => es
      ? 'Esto no es Neovim. Solo el subconjunto de Vim listado abajo, cubierto por tests.'
      : 'This is not Neovim. Only the Vim subset listed below, covered by tests.';
  String get keys => es
      ? 'h j k l · 0 ^ \$ · w e b · gg G · { } · i a I A o O · Esc · x X D C J · dd dw diw ciw · % (misma línea) · yy p · u · f t F T ; · >> << · conteos'
      : 'h j k l · 0 ^ \$ · w e b · gg G · { } · i a I A o O · Esc · x X D C J · dd dw diw ciw · % (same line) · yy p · u · f t F T ; · >> << · counts';
  String get copy =>
      'Copyright © 2026 CAPDESIS / chochy2001. MIT License. Free to download.';
  String get unsigned => es
      ? 'Builds sin firma: Windows puede mostrar SmartScreen; en macOS usa clic derecho → Abrir.'
      : 'Unsigned builds: Windows may show SmartScreen; on macOS use Right-click → Open.';
  String get typeHint => es
      ? 'Escribe el código tal cual. No uses Vim aquí: es un ejercicio de teclado.'
      : 'Type the code as shown. No Vim here: this is a keyboard drill.';
  String get vimHint => es
      ? 'El cursor empieza donde indica el ejercicio. No hay flechas a propósito.'
      : 'The cursor starts where the exercise says. Arrow keys are ignored on purpose.';
}
