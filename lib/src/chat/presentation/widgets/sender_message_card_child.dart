import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/src/chat/models/message.dart';
import 'package:whatsapp/src/chat/presentation/widgets/chat_reply_tile.dart';
import 'package:whatsapp/src/chat/presentation/widgets/message_media.dart';

class SenderMessageCardChild extends StatelessWidget {
  const SenderMessageCardChild({
    required this.message,
    required this.mediaType,
    required this.date,
    required this.receiverIdentifierText,
    super.key,
  });

  final Message message;
  final MediaType mediaType;
  final String date;
  final String receiverIdentifierText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: mediaType == MediaType.TEXT
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
                      ? 'You'
                      : receiverIdentifierText,
                  message: message.repliedMessage!,
                  mediaType: message.repliedMediaType!,
                  tileColor: senderMessageColorDarker,
                )
              ],
              const SizedBox(height: 5),
              MessageMedia(message: message),
            ],
          ),
        ),
        Positioned(
          bottom: 2,
          right: 10,
          child: Text(
            date,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
