import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/src/chat/presentation/widgets/audio_player.dart';
import 'package:whatsapp/src/chat/presentation/widgets/video_player.dart';

class MessageMedia extends StatelessWidget {
  const MessageMedia({
    required this.message,
    required this.mediaType,
    super.key,
  });

  final String message;
  final MediaType mediaType;

  @override
  Widget build(BuildContext context) {
    switch (mediaType) {
      case MediaType.TEXT:
        return Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
      case MediaType.IMAGE:
      case MediaType.GIF:
        return CachedNetworkImage(imageUrl: message, height: 200);
      case MediaType.AUDIO:
        return AudioPlayer(
          audioURL: message,
        );
      case MediaType.VIDEO:
        return VideoPlayer(videoURL: message);
    }
  }
}
