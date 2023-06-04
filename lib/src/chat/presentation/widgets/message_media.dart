// ignore_for_file: no_default_cases

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/src/chat/models/message.dart';
import 'package:whatsapp/src/chat/presentation/widgets/audio_player.dart';
import 'package:whatsapp/src/chat/presentation/widgets/file_viewer.dart';
import 'package:whatsapp/src/chat/presentation/widgets/text_viewer.dart';
import 'package:whatsapp/src/chat/presentation/widgets/video_player.dart';

class MessageMedia extends StatelessWidget {
  const MessageMedia({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    switch (message.mediaType) {
      case MediaType.TEXT:
        return TextViewer(message);
      case MediaType.IMAGE:
      case MediaType.GIF:
        return CachedNetworkImage(imageUrl: message.text, height: 200);
      case MediaType.AUDIO:
        return AudioPlayer(audioURL: message.text);
      case MediaType.VIDEO:
        return VideoPlayer(videoURL: message.text);
      case MediaType.FILE:
        return FileViewer(message: message);
    }
  }
}
