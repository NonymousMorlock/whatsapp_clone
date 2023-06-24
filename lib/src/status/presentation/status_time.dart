import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/extensions/date_extensions.dart';

class StatusTime extends StatefulWidget {
  const StatusTime({required this.time, super.key});

  final DateTime time;

  @override
  State<StatusTime> createState() => _StatusTimeState();
}

class _StatusTimeState extends State<StatusTime> {
  late Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.time.statusFormat,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    );
  }
}
