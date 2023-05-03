import 'package:flutter/material.dart';
import 'package:whatsapp/core/res/colors.dart';

class ChatField extends StatefulWidget {
  const ChatField({super.key});

  @override
  State<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends State<ChatField> {
  final messageController = TextEditingController();
  bool isTyping = false;

  @override
  void initState() {
    messageController.addListener(() {
      setState(() {
        if (messageController.text.isNotEmpty) {
          isTyping = true;
        } else {
          isTyping = false;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.gif, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon:
                              const Icon(Icons.attach_file, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            const SizedBox(width: 5),
            FloatingActionButton(
              onPressed: () {},
              mini: true,
              backgroundColor: const Color(0xFF128C7E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
              ),
              child: Center(
                child: Icon(
                  isTyping ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
