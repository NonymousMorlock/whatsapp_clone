import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:whatsapp/core/enums/media_type.dart';

extension StringExt on String {
  static final _urlRegex =
      RegExp(r'(?:(?:https?|ftp)://)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

  String get onlyNumbers {
    return toNumericString(this);
  }

  String get extension => split('.').last;

  String get name {
    final split = this.split('.')..removeLast();
    return split.join('.');
  }

  String get capitalize {
    if (trim().isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get titleCase {
    if (trim().isEmpty) return this;
    return split(' ').map<String>((e) => e.capitalize).toList().join(' ');
  }

  String? get extractLink {
    final matches = _urlRegex.allMatches(this);

    if (matches.isEmpty) {
      return null;
    }

    final firstMatch = matches.first;
    return firstMatch.group(0);
  }

  MediaType get toMediaType {
    switch (this) {
      case 'text':
        return MediaType.TEXT;
      case 'image':
        return MediaType.IMAGE;
      case 'audio':
        return MediaType.AUDIO;
      case 'video':
        return MediaType.VIDEO;
      case 'gif':
        return MediaType.GIF;
      case 'file':
        return MediaType.FILE;
      default:
        return MediaType.TEXT;
    }
  }
}
