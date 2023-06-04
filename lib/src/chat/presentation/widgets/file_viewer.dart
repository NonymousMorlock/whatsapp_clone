import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:whatsapp/core/extensions/integer_extensions.dart';
import 'package:whatsapp/core/extensions/string_extensions.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/chat/models/message.dart';

class FileViewer extends StatefulWidget {
  const FileViewer({required this.message, super.key});

  final Message message;

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  PreviewData? previewData;

  bool get isMe =>
      widget.message.senderId == FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.openLink(
        context,
        url: '${widget.message.text}.${widget.message.fileName!.extension}',
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMe ? messageColorDarker : senderMessageColorDarker,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.insert_drive_file,
              color: Colors.white,
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.fileName!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    if (widget.message.fileSize != null) ...[
                      Text(
                        widget.message.fileSize!.formatFileSize,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.circle, size: 5, color: Colors.grey),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      widget.message.fileName!.extension.toUpperCase(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
