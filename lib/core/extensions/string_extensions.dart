
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

extension StringExt on String {
  String get onlyNumbers {
    return toNumericString(this);
  }
}
