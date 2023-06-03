import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/common/providers/message_reply_controller.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/src/auth/controller/auth_controller.dart';
import 'package:whatsapp/src/chat/models/chat_stub.dart';
import 'package:whatsapp/src/chat/models/message.dart';
import 'package:whatsapp/src/chat/repository/chat_repository.dart';

final chatControllerProvider = Provider(
  (ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider),
    ref: ref,
  ),
);

class ChatController {
  const ChatController({
    required ChatRepository chatRepository,
    required ProviderRef<dynamic> ref,
  })  : _chatRepository = chatRepository,
        _ref = ref;

  final ChatRepository _chatRepository;
  final ProviderRef<dynamic> _ref;

  Stream<List<ChatStub>> getChatStubs() => _chatRepository.getChatStubs();

  Stream<List<Message>> getChats(String receiverUID) =>
      _chatRepository.getChats(receiverUID);

  Future<void> setChatSeen({
    required BuildContext context,
    required String receiverUId,
    required String messageId,
  }) async =>
      _chatRepository.setChatSeen(
        context: context,
        receiverUId: receiverUId,
        messageId: messageId,
      );

  Future<void> sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUId,
    required String receiverIdentifierText,
    Contact? contact,
  }) async {
    _ref.read(userProvider).whenData(
          (value) => _chatRepository.sendGIFMessage(
            context: context,
            gifUrl: gifUrl,
            receiverUId: receiverUId,
            sender: value!,
            receiverIdentifierText: receiverIdentifierText,
            contact: contact,
            messageReply: _ref.read(messageReplyProvider),
          ),
        );
  }

  Future<void> sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUId,
    required String receiverIdentifierText,
    Contact? contact,
  }) async {
    _ref.read(userProvider).whenData(
          (value) => _chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUId: receiverUId,
            sender: value!,
            receiverIdentifierText: receiverIdentifierText,
            contact: contact,
            messageReply: _ref.read(messageReplyProvider),
          ),
        );
  }

  Future<void> sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUId,
    required String receiverIdentifierText,
    required MediaType mediaType,
    Contact? contact,
  }) async {
    _ref.read(userProvider).whenData(
          (value) => _chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUId: receiverUId,
            mediaType: mediaType,
            sender: value!,
            receiverIdentifierText: receiverIdentifierText,
            contact: contact,
            ref: _ref,
            messageReply: _ref.read(messageReplyProvider),
          ),
        );
  }
}
