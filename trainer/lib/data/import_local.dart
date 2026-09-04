import 'dart:io';

import 'package:capdesis_practice/data/content.dart';

const skipDirNames = {
  '.git',
  '.svn',
  '.hg',
  'node_modules',
  '.dart_tool',
  'build',
  'dist',
  '.idea',
  '.vscode',
  'Pods',
  'vendor',
  '__pycache__',
  '.next',
  'target',
  '.gradle',
  'xcuserdata',
};

const maxFileBytes = 12 * 1024;
const maxFiles = 40;
const maxDepth = 6;

const langByExt = <String, String>{
  '.dart': 'Dart',
  '.go': 'Go',
  '.py': 'Python',
  '.ts': 'TypeScript',
  '.tsx': 'TypeScript',
  '.js': 'JavaScript',
  '.jsx': 'JavaScript',
  '.java': 'Java',
  '.kt': 'Kotlin',
  '.kts': 'Kotlin',
  '.swift': 'Swift',
  '.sql': 'SQL',
  '.html': 'HTML',
  '.htm': 'HTML',
  '.css': 'CSS',
  '.php': 'PHP',
  '.lua': 'Lua',
  '.sh': 'Bash',
  '.bash': 'Bash',
  '.c': 'C',
  '.h': 'C',
  '.cpp': 'C++',
  '.cc': 'C++',
  '.hpp': 'C++',
  '.rs': 'Rust',
  '.cs': 'C#',
  '.rb': 'Ruby',
  '.json': 'JSON',
  '.yaml': 'YAML',
  '.yml': 'YAML',
  '.toml': 'TOML',
  '.xml': 'XML',
};

String? languageFor(String path) {
  final i = path.lastIndexOf('.');
  if (i < 0) return null;
  return langByExt[path.substring(i).toLowerCase()];
}

bool skipDir(String name) => skipDirNames.contains(name);

Snippet? snippetFromPath(String path) {
  final lang = languageFor(path);
  if (lang == null) return null;
  final f = File(path);
  try {
    final len = f.lengthSync();
    if (len <= 0 || len > maxFileBytes) return null;
    final body = f.readAsStringSync();
    if (body.contains('\u0000')) return null;
    return Snippet(id: path, language: lang, body: body);
  } on FileSystemException {
    return null;
  }
}

List<Snippet> loadPaths(Iterable<String> paths) {
  final out = <Snippet>[];
  final seen = <String>{};
  for (final path in paths) {
    if (out.length >= maxFiles) break;
    if (!seen.add(path)) continue;
    final s = snippetFromPath(path);
    if (s != null) out.add(s);
  }
  return out;
}

/// Reads text files into memory only. Caller must drop the list to forget them.
Future<List<Snippet>> loadProjectFolder(String root) async {
  final out = <Snippet>[];
  await _walk(Directory(root), 0, out);
  return out;
}

Future<void> _walk(Directory dir, int depth, List<Snippet> out) async {
  if (out.length >= maxFiles || depth > maxDepth) return;
  late final List<FileSystemEntity> list;
  try {
    list = dir.listSync(followLinks: false);
  } on FileSystemException {
    return;
  }
  for (final e in list) {
    if (out.length >= maxFiles) return;
    final name = e.path.replaceAll('\\', '/').split('/').last;
    if (e is Directory) {
      if (skipDir(name) || name.startsWith('.')) continue;
      await _walk(e, depth + 1, out);
    } else if (e is File) {
      final s = snippetFromPath(e.path);
      if (s != null) out.add(s);
    }
  }
}
