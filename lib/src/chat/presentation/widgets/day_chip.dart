import 'package:flutter/material.dart';
import 'package:whatsapp/core/extensions/date_extensions.dart';
import 'package:whatsapp/core/extensions/string_extensions.dart';

class DayChip extends StatelessWidget {
  const DayChip({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Chip(
        label: Text(
          date.dayAgo.titleCase,
          style: TextStyle(color: Colors.grey[300]),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        backgroundColor: Colors.grey.shade700,
      ),
    );
  }
}
