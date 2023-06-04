import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:whatsapp/core/extensions/string_extensions.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/chat/models/message.dart';

class TextViewer extends StatefulWidget {
  const TextViewer(this.message, {super.key});

  final Message message;

  @override
  State<TextViewer> createState() => _TextViewerState();
}

class _TextViewerState extends State<TextViewer> {
  PreviewData? previewData;

  String? get link => widget.message.text.extractLink;

  bool get isMe =>
      widget.message.senderId == FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (link != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinkPreview(
            onPreviewDataFetched: (data) => setState(() {
              previewData = data;
            }),
            padding: EdgeInsets.zero,
            openOnPreviewImageTap: true,
            openOnPreviewTitleTap: true,
            onLinkPressed: (url) => Utils.openLink(context, url: url),
            previewBuilder: (context, data) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ColoredBox(
                  color: isMe ? messageColorDarker : senderMessageColorDarker,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.image != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            data.image!.url,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          ),
                        ),
                      if (data.title != null) ...[
                        if (data.image != null)
                          const SizedBox(height: 3)
                        else
                          const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            data.title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (data.description != null) const SizedBox(height: 3),
                      ],
                      if (data.description != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            data.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              );
            },
            previewData: previewData,
            text: link!,
            width: width,
          ),
          const SizedBox(height: 8),
          Linkify(
            text: widget.message.text,
            style: const TextStyle(fontSize: 16),
            linkStyle: const TextStyle(color: Colors.blue),
            onOpen: (link) async {
              await Utils.openLink(context, url: link.url);
            },
          )
        ],
      );
    } else {
      return Text(widget.message.text, style: const TextStyle(fontSize: 16));
    }
  }
}
