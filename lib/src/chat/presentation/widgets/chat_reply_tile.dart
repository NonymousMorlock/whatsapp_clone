import 'package:flutter/material.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/extensions/media_type_extensions.dart';

class ChatReplyTile extends StatelessWidget {
  const ChatReplyTile({
    super.key,
    required this.isMe,
    required this.senderName,
    required this.message,
    required this.mediaType,
    required this.tileColor,
  });

  final bool isMe;
  final String senderName;
  final String message;
  final MediaType mediaType;
  final Color tileColor;

  // TODO(VIEW): Add a preview of the media type in a row alongside the message

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: tileColor,
          border: Border(
            left: BorderSide(
              color: isMe ? Colors.green : Colors.purpleAccent,
              width: 5,
            ),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              senderName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.green : Colors.purpleAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mediaType == MediaType.TEXT ? message : mediaType.emojify,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
