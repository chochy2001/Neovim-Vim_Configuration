import 'dart:convert';

import '../trainer/lib/data/content.dart';

void main() {
  print(
    jsonEncode(
      katas
          .map(
            (k) => {
              'id': 'kata-${k.id}',
              'start': k.start,
              'row': k.row,
              'col': k.col,
              'keys': k.solve,
              'kataExpected': k.expect,
              'kataColumn': k.expectCol,
            },
          )
          .toList(),
    ),
  );
}
