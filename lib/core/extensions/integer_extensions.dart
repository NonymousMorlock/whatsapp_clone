import 'dart:math';

import 'package:whatsapp/core/extensions/double_extensions.dart';

extension IntExt on int {
  static const int bytesInKilobyte = 1024;

  String get formatFileSize {
    if (this < bytesInKilobyte) {
      return '$this B';
    } else {
      final exp = (log(this) / log(bytesInKilobyte)).floor();
      final size =
          double.parse((this / pow(bytesInKilobyte, exp)).toStringAsFixed(2));
      final unit = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'][exp];
      return '${size.conditionalDecimal} $unit';
    }
  }
}
