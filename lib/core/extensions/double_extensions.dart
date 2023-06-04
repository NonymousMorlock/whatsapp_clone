import 'package:intl/intl.dart';

extension DoubleExt on double {
  String get conditionalDecimal {
    return NumberFormat('#,##0.##').format(this);
  }
}
