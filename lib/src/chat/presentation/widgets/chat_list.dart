import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/common/providers/message_reply_controller.dart';
import 'package:whatsapp/core/common/views/loading_screen.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/extensions/date_extensions.dart';
import 'package:whatsapp/src/chat/controller/chat_controller.dart';
import 'package:whatsapp/src/chat/models/message.dart';
import 'package:whatsapp/src/chat/presentation/widgets/day_chip.dart';
import 'package:whatsapp/src/chat/presentation/widgets/my_message_card.dart';
import 'package:whatsapp/src/chat/presentation/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({
    required this.receiverIdentifierText,
    required this.receiverUID,
    super.key,
  });

  final String receiverUID;
  final String receiverIdentifierText;

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final messageScrollController = ScrollController();
  final auth = FirebaseAuth.instance;

  void swipeToReply({
    required String message,
    required bool isMe,
    required MediaType mediaType,
  }) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message: message,
            isMe: isMe,
            mediaType: mediaType,
          ),
        );
  }

  void scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // scroll to the bottom
      while (messageScrollController.position.pixels !=
          messageScrollController.position.maxScrollExtent) {
        messageScrollController
            .jumpTo(messageScrollController.position.maxScrollExtent);

        await SchedulerBinding.instance.endOfFrame;
      }
    });
  }

  @override
  void dispose() {
    messageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).getChats(widget.receiverUID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        scrollToBottom();
        return ListView.builder(
          itemCount: snapshot.data!.length,
          controller: messageScrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final message = snapshot.data![index];
            final previousMessage =
                index > 0 ? snapshot.data![index - 1] : null;

            final currentUserId = auth.currentUser!.uid;

            final useNormalCard = previousMessage != null &&
                previousMessage.senderId == message.senderId &&
                previousMessage.timeSent.isSameDay(message.timeSent);

            final isFromNewDay = previousMessage != null &&
                !previousMessage.timeSent.isSameDay(message.timeSent);

            final myMessageCard = MyMessageCard(
              message: message,
              date: message.timeSent.time,
              mediaType: message.mediaType,
              repliedText: message.repliedMessage,
              userIdentifierText: message.repliedTo == auth.currentUser!.uid
                  ? 'Me'
                  : message.repliedTo,
              replyMediaType: message.repliedMediaType,
              receiverIdentifierText: widget.receiverIdentifierText,
              onLeftSwipe: () {
                swipeToReply(
                  message: message.text,
                  isMe: true,
                  mediaType: message.mediaType,
                );
              },
              useNormalCard:
                  useNormalCard || message.mediaType == MediaType.AUDIO,
            );

            final senderMessageCard = SenderMessageCard(
              message: message,
              date: message.timeSent.time,
              mediaType: message.mediaType,
              repliedText: message.repliedMessage,
              userIdentifierText: message.repliedTo == auth.currentUser!.uid
                  ? 'Me'
                  : message.repliedTo,
              replyMediaType: message.repliedMediaType,
              receiverIdentifierText: widget.receiverIdentifierText,
              onRightSwipe: () {
                swipeToReply(
                  message: message.text,
                  isMe: false,
                  mediaType: message.mediaType,
                );
              },
              useNormalCard:
                  useNormalCard || message.mediaType == MediaType.AUDIO,
            );

            if (!message.isSeen && message.receiverId == currentUserId) {
              ref.read(chatControllerProvider).setChatSeen(
                    context: context,
                    receiverUId: widget.receiverUID,
                    messageId: message.messageId,
                  );
            }

            if (message.senderId == currentUserId) {
              if (isFromNewDay) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    DayChip(date: message.timeSent),
                    const SizedBox(height: 10),
                    myMessageCard,
                  ],
                );
              }
              return myMessageCard;
            }
            if (isFromNewDay) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  DayChip(date: message.timeSent),
                  const SizedBox(height: 10),
                  senderMessageCard,
                ],
              );
            }
            return senderMessageCard;
          },
        );
      },
    );
  }
}
