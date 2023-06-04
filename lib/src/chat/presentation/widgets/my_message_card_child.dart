import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/extensions/string_extensions.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/src/chat/models/message.dart';
import 'package:whatsapp/src/chat/presentation/widgets/chat_reply_tile.dart';
import 'package:whatsapp/src/chat/presentation/widgets/message_media.dart';

class MyMessageCardChild extends StatelessWidget {
  const MyMessageCardChild({
    required this.message,
    required this.date,
    super.key,
    required this.receiverIdentifierText,
  });

  final Message message;
  final String date;
  final String receiverIdentifierText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: message.mediaType == MediaType.TEXT &&
                  message.repliedMessage == null &&
                  message.text.extractLink == null
              ? const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                )
              : const EdgeInsets.only(
                  left: 5,
                  top: 5,
                  right: 5,
                  bottom: 25,
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.repliedMessage != null) ...[
                ChatReplyTile(
                  isMe: message.repliedTo ==
                      FirebaseAuth.instance.currentUser!.uid,
                  senderName: message.repliedTo ==
                          FirebaseAuth.instance.currentUser!.uid
                      ? 'Me'
                      : receiverIdentifierText,
                  message: message.repliedMessage!,
                  mediaType: message.repliedMediaType!,
                  tileColor: messageColorDarker,
                )
              ],
              const SizedBox(height: 5),
              MessageMedia(message: message),
            ],
          ),
        ),
        Positioned(
          bottom: 4,
          right: 10,
          child: Row(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                message.isSeen ? Icons.done_all : Icons.done,
                size: 20,
                color: message.isSeen ? Colors.blue : Colors.white60,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
