import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:whatsapp/core/enums/media_type.dart';

extension StringExt on String {
  String get onlyNumbers {
    return toNumericString(this);
  }

  String get capitalize {
    if (trim().isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get titleCase {
    if (trim().isEmpty) return this;
    return split(' ').map<String>((e) => e.capitalize).toList().join(' ');
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
      default:
        return MediaType.TEXT;
    }
  }
}
