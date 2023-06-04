import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/utils/constants.dart';

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

  static Future<void> openFile(
    BuildContext context, {
    required String url,
  }) async {
    await openLink(context, url: url, errorMessage: 'Could not open file');
  }

  static Future<void> openLink(
    BuildContext context, {
    required String url,
    String? errorMessage,
  }) async {
    void showSnack(String content) {
      showSnackBar(context: context, content: content);
    }

    if (!await launchUrl(Uri.parse(url))) {
      if (errorMessage == null) {
        showSnack('Could not launch $url');
      } else {
        showSnack(errorMessage);
      }
    }
  }

  static Future<(File?, MediaType?)?> pickImageOrVideo(
    BuildContext context,
  ) async {
    void showSnack(String content) {
      showSnackBar(context: context, content: content);
    }

    try {
      final pickedImageOrVideo = await FilePicker.platform.pickFiles(
        type: FileType.media,
      );
      if (pickedImageOrVideo != null) {
        final fileExtension = pickedImageOrVideo.files.single.extension;
        MediaType type;
        if (fileExtension == 'gif') {
          type = MediaType.GIF;
        }
        if (kImageExtensions.contains(fileExtension)) {
          type = MediaType.IMAGE;
        } else if (kVideoExtensions.contains(fileExtension)) {
          type = MediaType.VIDEO;
        } else {
          showSnack('Unsupported file type');
          return null;
        }
        return (File(pickedImageOrVideo.files.single.path!), type);
      }
      return null;
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return null;
    }
  }

  static Future<(File?, String?)?> pickDocument(BuildContext context) async {
    try {
      final pickedDocument = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: kFileExtensions,
      );
      if (pickedDocument != null) {
        final file = pickedDocument.files.single;
        final fileName = file.name;
        return (File(file.path!), fileName);
      }
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
        apiKey: 'EJCRaAwC21Mvhv3t3hjCZMTKgRs3EJLx',
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return null;
    }
  }
}
