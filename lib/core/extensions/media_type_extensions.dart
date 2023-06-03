// ignore_for_file: no_default_cases

import 'package:whatsapp/core/enums/media_type.dart';

extension MediaTypeExt on MediaType {
  String get emojify {
    switch (this) {
      case MediaType.IMAGE:
        return '📷 Photo';
      case MediaType.VIDEO:
        return '📹 Video';
      case MediaType.AUDIO:
        return '🎧 Audio';
      case MediaType.GIF:
        return '📽 GIF';
      default:
        return '📷 Photo';
    }
  }
}
