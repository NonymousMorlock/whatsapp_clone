import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/src/chat/models/message.dart';
import 'package:whatsapp/src/chat/presentation/widgets/normal_message_card.dart';
import 'package:whatsapp/src/chat/presentation/widgets/sender_message_card_child.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.mediaType,
    this.useNormalCard = false,
    required this.onRightSwipe,
    this.repliedText,
    this.userIdentifierText,
    this.replyMediaType,
    required this.receiverIdentifierText,
  });

  final Message message;
  final String date;
  final MediaType mediaType;
  final bool useNormalCard;
  final VoidCallback onRightSwipe;
  final String? repliedText;
  final String? userIdentifierText;
  final MediaType? replyMediaType;
  final String receiverIdentifierText;

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: !useNormalCard && mediaType == MediaType.TEXT
              ? ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                  backGroundColor: senderMessageColor,
                  elevation: 0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: SenderMessageCardChild(
                    message: message,
                    mediaType: mediaType,
                    date: date,
                    receiverIdentifierText: receiverIdentifierText,
                  ),
                )
              : NormalMessageCard(
                  padding: const EdgeInsets.only(left: 10),
                  colour: senderMessageColor,
                  child: SenderMessageCardChild(
                    message: message,
                    mediaType: mediaType,
                    date: date,
                    receiverIdentifierText: receiverIdentifierText,
                  ),
                ),
        ),
      ),
    );
  }
}
