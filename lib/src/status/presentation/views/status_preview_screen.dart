import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/src/status/controller/status_controller.dart';

class StatusPreviewScreen extends ConsumerWidget {
  const StatusPreviewScreen({
    required this.file,
    super.key,
  });

  final File file;

  static const id = '/confirm-status';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        onPressed: () async {
          final navigator = Navigator.of(context);
          await ref.read(statusControllerProvider).uploadStatus(
                context: context,
                statusImage: file,
              );
          navigator.pop();

        },
        child: const Icon(Icons.done, color: Colors.white),
      ),
    );
  }
}
