import 'dart:io';

import 'package:dart_style/dart_style.dart';

void main() {
  const filePath = 'lib/core/themes/app_images.dart';

  final file = File(filePath);
  if (!file.existsSync()) {
    print('File not found: $filePath');
    return;
  }

  String content = file.readAsStringSync();

  content = content.replaceAll(RegExp(r'^\s*///.*$', multiLine: true), '');

  content = content.replaceAllMapped(
    RegExp(r'(images|svgs)([A-Z]\w*)'),
    (match) {
      final name = match.group(2) ?? '';
      return _toCamelCase(name);
    },
  );

  try {
    final formatter = DartFormatter(
        languageVersion: DartFormatter.latestShortStyleLanguageVersion);
    content = formatter.format(content);
  } catch (e) {
    print('Error formatting code: $e');
    return;
  }

  file.writeAsStringSync(content);
  print('Updated and formatted file: $filePath');
}

String _toCamelCase(String text) {
  if (text.isEmpty) return text;

  return text[0].toLowerCase() + text.substring(1);
}

//! cd lib
//! cd core
//! cd themes
//! dart run update_assets.dart
