import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/common/providers/message_reply_controller.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/extensions/media_type_extensions.dart';
import 'package:whatsapp/core/res/colors.dart';

class ReplyPreview extends ConsumerWidget {
  const ReplyPreview({
    super.key,
    required this.isMe,
    this.receiverIdentifierText,
  });

  final bool isMe;
  final String? receiverIdentifierText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: mobileChatBoxColorDarker,
          border: Border(
            left: BorderSide(
              color: isMe ? Colors.blueAccent : Colors.purpleAccent,
              width: 5,
            ),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    messageReply!.isMe ? 'Me' : receiverIdentifierText!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.blueAccent : Colors.purpleAccent,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(messageReplyProvider.notifier)
                        .update((state) => null);
                  },
                  child: const Icon(Icons.close, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              messageReply.mediaType == MediaType.TEXT
                  ? messageReply.message
                  : messageReply.mediaType.emojify,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
