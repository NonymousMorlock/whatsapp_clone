import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusPreviewScreen extends ConsumerWidget {
  const StatusPreviewScreen({
    required this.file,
    super.key,
  });

  final File file;

  static const id = '/confirm-status';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Placeholder(
      child: Icon(Icons.comment),
    );
  }
}
