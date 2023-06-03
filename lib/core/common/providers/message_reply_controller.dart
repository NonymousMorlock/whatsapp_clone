import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/enums/media_type.dart';

class MessageReply {
  const MessageReply({
    required this.message,
    required this.isMe,
    required this.mediaType,
  });

  @override
  String toString() {
    return 'MessageReply{message: $message, isMe: $isMe, '
        'mediaType: $mediaType}';
  }

  final String message;
  final bool isMe;
  final MediaType mediaType;
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
