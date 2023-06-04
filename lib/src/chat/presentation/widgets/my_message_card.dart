import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/src/chat/models/message.dart';
import 'package:whatsapp/src/chat/presentation/widgets/my_message_card_child.dart';
import 'package:whatsapp/src/chat/presentation/widgets/normal_message_card.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    this.useNormalCard = false,
    required this.onLeftSwipe,
    this.repliedText,
    this.userIdentifierText,
    this.replyMediaType,
    required this.receiverIdentifierText,
  });

  final Message message;
  final String date;
  final bool useNormalCard;
  final VoidCallback onLeftSwipe;
  final String? repliedText;
  final String? userIdentifierText;
  final MediaType? replyMediaType;
  final String receiverIdentifierText;

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: !useNormalCard && message.mediaType == MediaType.TEXT
              ? ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                  alignment: Alignment.topRight,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  backGroundColor: messageColor,
                  child: MyMessageCardChild(
                    message: message,
                    date: date,
                    receiverIdentifierText: receiverIdentifierText,
                  ),
                )
              : NormalMessageCard(
                  colour: messageColor,
                  padding: const EdgeInsets.only(right: 10),
                  child: MyMessageCardChild(
                    message: message,
                    date: date,
                    receiverIdentifierText: receiverIdentifierText,
                  ),
                ),
        ),
      ),
    );
  }
}
