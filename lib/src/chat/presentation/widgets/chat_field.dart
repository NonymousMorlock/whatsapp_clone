import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp/core/common/providers/message_reply_controller.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/src/chat/controller/chat_controller.dart';
import 'package:whatsapp/src/chat/presentation/utils/chat_utils.dart';
import 'package:whatsapp/src/chat/presentation/widgets/reply_preview.dart';

class ChatField extends ConsumerStatefulWidget {
  const ChatField({
    super.key,
    required this.receiverUId,
    required this.receiverIdentifierText,
    this.contact,
  });

  final String receiverUId;
  final String receiverIdentifierText;
  final Contact? contact;

  @override
  ConsumerState<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends ConsumerState<ChatField> {
  final messageController = TextEditingController();
  late FlutterSoundRecorder soundRecorder;
  Timer? _typingTimer;
  bool hasTypedMessage = false;
  bool recorderInitialized = false;
  bool isRecording = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isEmojiKeyboardVisible = false;
  final focusNode = FocusNode();

  Future<void> setUserTypingStatus({required bool isTyping}) async {
    // TODO(TYPING): Set user typing status
    final currentUserId = _auth.currentUser!.uid;
    final receiverId = widget.receiverUId;
    final chatDocRef = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverId);
    final typingStatusDocRef =
        chatDocRef.collection('typingStatus').doc(currentUserId);
    await _firestore.runTransaction((transaction) async {
      final chatDoc = await transaction.get(chatDocRef);
      if (!chatDoc.exists) {
        transaction.set(chatDocRef, {'lastTypingTimestamp': null});
      }
      transaction.set(typingStatusDocRef, {
        'isTyping': isTyping,
        'lastTypingTimestamp': isTyping ? FieldValue.serverTimestamp() : null,
      });
    });
  }

  MessageReply? messageReply;

  bool get showMessageReply => messageReply != null;

  @override
  void initState() {
    soundRecorder = FlutterSoundRecorder();
    ChatUtils.openAudio(soundRecorder).then(
      (value) => recorderInitialized = value,
    );
    super.initState();
    messageController.addListener(() {
      setState(() {
        if (messageController.text.isNotEmpty) {
          hasTypedMessage = true;
        } else {
          hasTypedMessage = false;
        }
      });

      if (_typingTimer?.isActive ?? false) {
        _typingTimer!.cancel();
      }

      _typingTimer = Timer(const Duration(seconds: 2), () {
        setUserTypingStatus(isTyping: false);
      });

      if (messageController.text.isNotEmpty) {
        setUserTypingStatus(isTyping: true);
      }
    });
    ref.read(messageReplyProvider.notifier).addListener((state) {
      debugPrint('--------------------------------------------------------');
      debugPrint('Message reply state: $state');
      debugPrint('--------------------------------------------------------');
      if (state != null) {
        focusNode.requestFocus();
      } else {
        focusNode.unfocus();
      }
    });
  }

  Future<void> clear() async {
    FocusManager.instance.primaryFocus?.unfocus();
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  void dispose() {
    messageController
      ..removeListener(() {})
      ..dispose();
    _typingTimer?.cancel();
    soundRecorder.closeRecorder();
    recorderInitialized = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    messageReply = ref.watch(messageReplyProvider);
    return WillPopScope(
      onWillPop: () async {
        if (isEmojiKeyboardVisible) {
          setState(() {
            isEmojiKeyboardVisible = false;
          });
          return false;
        }
        return true;
      },
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: mobileChatBoxColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          if (showMessageReply)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ReplyPreview(
                                isMe: messageReply!.isMe,
                                receiverIdentifierText:
                                    widget.receiverIdentifierText,
                              ),
                            ),
                          TextField(
                            controller: messageController,
                            focusNode: focusNode,
                            onTap: () {
                              setState(() {
                                isEmojiKeyboardVisible = false;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: mobileChatBoxColor,
                              prefixIcon: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (isEmojiKeyboardVisible) {
                                          focusNode.requestFocus();
                                        } else {
                                          focusNode.unfocus();
                                        }
                                        setState(() {
                                          isEmojiKeyboardVisible =
                                              !isEmojiKeyboardVisible;
                                        });
                                      },
                                      icon: Icon(
                                        isEmojiKeyboardVisible
                                            ? Icons.keyboard
                                            : Icons.emoji_emotions,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await ChatUtils.sendGIF(context,
                                            (url, mediaType) async {
                                          await ref
                                              .read(chatControllerProvider)
                                              .sendGIFMessage(
                                                context: context,
                                                gifUrl: url,
                                                receiverUId: widget.receiverUId,
                                                receiverIdentifierText: widget
                                                    .receiverIdentifierText,
                                                contact: widget.contact,
                                              );
                                        });
                                        await clear();
                                      },
                                      icon: const Icon(
                                        Icons.gif,
                                        color: Colors.grey,
                                      ),
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
                                      onPressed: () async {
                                        await ChatUtils.sendMedia(context,
                                            (file, mediaType) {
                                          ChatUtils.sendFile(
                                            ref: ref,
                                            context: context,
                                            file: file,
                                            mediaType: mediaType,
                                            receiverUId: widget.receiverUId,
                                            receiverIdentifierText:
                                                widget.receiverIdentifierText,
                                            contact: widget.contact,
                                          );
                                        });
                                        await clear();
                                      },
                                      icon: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await ChatUtils.sendDocument(context,
                                            (file, mediaType, fileName) {
                                          ChatUtils.sendFile(
                                            ref: ref,
                                            context: context,
                                            file: file,
                                            fileName: fileName,
                                            mediaType: mediaType,
                                            receiverUId: widget.receiverUId,
                                            receiverIdentifierText:
                                                widget.receiverIdentifierText,
                                            contact: widget.contact,
                                          );
                                        });
                                        await clear();
                                      },
                                      icon: const Icon(
                                        Icons.attach_file,
                                        color: Colors.grey,
                                      ),
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF128C7E),
                    radius: 25,
                    child: GestureDetector(
                      onLongPressStart: (_) async {
                        if (!hasTypedMessage &&
                            recorderInitialized &&
                            !isRecording) {
                          setState(() {
                            isRecording = true;
                          });
                          final temporaryDirectory =
                              await getTemporaryDirectory();
                          final path =
                              '${temporaryDirectory.path}/flutter_sound.aac';
                          await soundRecorder.startRecorder(toFile: path);
                        }
                      },
                      onLongPressEnd: (_) async {
                        if (isRecording) {
                          setState(() {
                            isRecording = false;
                          });
                          await soundRecorder.stopRecorder();
                          final temporaryDirectory =
                              await getTemporaryDirectory();
                          final path =
                              '${temporaryDirectory.path}/flutter_sound.aac';
                          if (!mounted) return;
                          await ChatUtils.sendFile(
                            ref: ref,
                            context: context,
                            file: File(path),
                            mediaType: MediaType.AUDIO,
                            receiverUId: widget.receiverUId,
                            receiverIdentifierText:
                                widget.receiverIdentifierText,
                            contact: widget.contact,
                          );
                        }
                      },
                      onTap: () async {
                        if (hasTypedMessage) {
                          await ref
                              .read(chatControllerProvider)
                              .sendTextMessage(
                                context: context,
                                text: messageController.text.trim(),
                                receiverUId: widget.receiverUId,
                                receiverIdentifierText:
                                    widget.receiverIdentifierText,
                                contact: widget.contact,
                              );
                          messageController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                          ref
                              .read(messageReplyProvider.notifier)
                              .update((state) => null);
                        }
                      },
                      child: Icon(
                        hasTypedMessage
                            ? Icons.send
                            : isRecording
                                ? Icons.close
                                : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isEmojiKeyboardVisible)
              SizedBox(
                height: 300,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    messageController.text += emoji.emoji;
                  },
                  onBackspacePressed: () {
                    messageController.text = messageController.text
                        .substring(0, messageController.text.length - 1);
                  },
                  config: Config(
                    bgColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.white
                        : Colors.grey[900]!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
