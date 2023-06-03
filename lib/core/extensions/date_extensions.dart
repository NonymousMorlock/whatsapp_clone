import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 5) {
      return 'now';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      final plural = minutes > 1 ? 's' : '';
      return '$minutes minute$plural ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      final plural = hours > 1 ? 's' : '';
      return '$hours hour$plural ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      final plural = days == 1 ? '' : 's';
      return '$days day$plural ago';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      final plural = weeks == 1 ? '' : 's';
      return '$weeks week$plural ago';
    } else if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      final plural = months == 1 ? '' : 's';
      return '$months month$plural ago';
    } else {
      final years = difference.inDays ~/ 365;
      final plural = years == 1 ? '' : 's';
      return '$years year$plural ago';
    }
  }

  /// if it's today, return 'today', for yesterday, return yesterday, but
  /// from other days, return the day of the week
  String get dayAgo {
    final now = DateTime.now();

    if (isSameDay(now)) {
      return 'today';
    } else if (isSameDay(now.subtract(const Duration(days: 1)))) {
      return 'yesterday';
    } else {
      return DateFormat.EEEE().format(this);
    }
  }

  String get dateOrDayAgo {
    final now = DateTime.now();

    if (isSameDay(now)) {
      return time;
    } else if (isSameDay(now.subtract(const Duration(days: 1)))) {
      return 'yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(this);
    }
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String get time => DateFormat.Hm().format(this);
}
