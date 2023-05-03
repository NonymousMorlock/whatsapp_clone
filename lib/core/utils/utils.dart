import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static void showSnackBar({
    required BuildContext context,
    required String content,
  }) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
        ),
      );
  }

  static void showLoadingDialog({
    required BuildContext context,
    String? loadingMessage,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(loadingMessage ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  static Future<File?> pickImage(BuildContext context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if(pickedImage != null) return File(pickedImage.path);
      return null;
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return null;
    }
  }
}
