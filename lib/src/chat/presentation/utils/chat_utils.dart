import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/core/common/providers/message_reply_controller.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/chat/controller/chat_controller.dart';

class ChatUtils {
  static Future<void> sendFile({
    required WidgetRef ref,
    required BuildContext context,
    required File file,
    String? fileName,
    required MediaType mediaType,
    required String receiverUId,
    required String receiverIdentifierText,
    required Contact? contact,
  }) async {
    await ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          fileName: fileName,
          receiverUId: receiverUId,
          receiverIdentifierText: receiverIdentifierText,
          mediaType: mediaType,
          contact: contact,
        );
  }

  // TODO(VIDEO): Use FilePicker instead of ImagePicker
  static Future<void> sendImage(
    BuildContext context,
    void Function(File file, MediaType mediaType) send,
  ) async {
    final image = await Utils.pickImage(context);
    if (image != null) {
      send(image, MediaType.IMAGE);
    }
  }

  static Future<void> sendVideo(
    BuildContext context,
    void Function(File file, MediaType mediaType) send,
  ) async {
    final video = await Utils.pickVideo(context);
    if (video != null) {
      send(video, MediaType.VIDEO);
    }
  }

  static Future<void> clearReply(WidgetRef ref) async {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  static Future<void> sendMedia(
    BuildContext context,
    void Function(File file, MediaType mediaType) send,
  ) async {
    final media = await Utils.pickImageOrVideo(context);
    if (media != null) {
      final (file, mediaType) = media;
      if (file != null && mediaType != null) {
        send(file, mediaType);
      }
    }
  }

  static Future<void> sendDocument(
    BuildContext context,
    void Function(File file, MediaType mediaType, String fileName) send,
  ) async {
    final document = await Utils.pickDocument(context);
    if (document != null) {
      final (documentFile, fileName) = document;
      if (documentFile != null && fileName != null) {
        send(documentFile, MediaType.FILE, fileName);
      }
    }
  }

  static Future<void> sendGIF(
    BuildContext context,
    void Function(String url, MediaType mediaType) send,
  ) async {
    final gif = await Utils.pickGIF(context);
    if (gif != null) {
      send(gif.url, MediaType.GIF);
    }
  }

  static Future<bool> openAudio(FlutterSoundRecorder recorder) async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission denied');
    }
    await recorder.openRecorder();
    return true;
  }
}
