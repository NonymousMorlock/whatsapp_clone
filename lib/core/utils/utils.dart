import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static final _imagePicker = ImagePicker();

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
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) return File(pickedImage.path);
      return null;
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return null;
    }
  }

  static Future<File?> pickVideo(BuildContext context) async {
    try {
      final pickedVideo = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedVideo != null) return File(pickedVideo.path);
      return null;
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return null;
    }
  }

  static Future<GiphyGif?> pickGIF(BuildContext context) async {
    try {
      return Giphy.getGif(
        context: context,
        apiKey: 'EJCRaAwC21Mvhv3t3hjCZMTK'
            'gRs3EJLx',
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return null;
    }
  }
}
