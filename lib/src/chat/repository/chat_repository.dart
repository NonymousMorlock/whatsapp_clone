import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/core/common/providers/message_reply_controller.dart';
import 'package:whatsapp/core/common/repositories/common_firebase_storage_repo.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/extensions/contact_extensions.dart';
import 'package:whatsapp/core/extensions/media_type_extensions.dart';
import 'package:whatsapp/core/extensions/string_extensions.dart';
import 'package:whatsapp/core/utils/typedefs.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';
import 'package:whatsapp/src/chat/models/chat_stub.dart';
import 'package:whatsapp/src/chat/models/message.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    store: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  const ChatRepository({
    required FirebaseFirestore store,
    required FirebaseAuth auth,
  })  : _store = store,
        _auth = auth;

  final FirebaseFirestore _store;
  final FirebaseAuth _auth;

  Stream<List<Message>> getChats(String receiverUID) {
    return _store
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUID)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map(
          (event) =>
              event.docs.map((doc) => Message.fromMap(doc.data())).toList(),
        );
  }

  Stream<List<ChatStub>> getChatStubs() {
    return _store
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      return Future.wait(
        event.docs.map((e) async {
          final stub = ChatStub.fromMap(e.data());
          final sender = await _getUserById(stub.contactId);
          if (stub.findContact) {
            await findContactByPhoneNumber(
              jsonEncode({
                'phone': sender?.phoneNumber,
                'contactId': sender?.uid,
              }),
            );
          }
          return stub.copyWith(sender: sender?.copyWith(contact: stub.contact));
        }).toList(),
      );
    });
  }

  Future<void> setChatSeen({
    required BuildContext context,
    required String receiverUId,
    required String messageId,
  }) async {
    try {
      await _store
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await _store
          .collection('users')
          .doc(receiverUId)
          .collection('chats')
          .doc(_auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } on FirebaseException catch (e) {
      Utils.showSnackBar(context: context, content: '${e.code}: ${e.message}');
    } catch (e) {
      Utils.showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUId,
    required String receiverIdentifierText,
    required UserModel sender,
    Contact? contact,
    MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();
      final receiverData =
          await _store.collection('users').doc(receiverUId).get();
      await _store
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'lastSeen': timeSent});
      final receiver = UserModel.fromMap(receiverData.data()!);
      final messageId = const Uuid().v1();

      await _storeMessageToUserChats(
        sender: sender,
        receiver: receiver,
        text: MediaType.GIF.emojify,
        receiverIdentifierText: receiverIdentifierText,
        timeSent: timeSent,
        contact: contact,
      );
      const gifBaseUrl = 'https://i.giphy.com/media/';
      final gifId = gifUrl.substring(gifUrl.lastIndexOf('-') + 1);
      await _storeMessageToUserMessages(
        receiverUId: receiverUId,
        text: '$gifBaseUrl$gifId/200.gif',
        mediaType: MediaType.GIF,
        timeSent: timeSent,
        messageId: messageId,
        senderUsername: sender.name,
        receiverUsername: receiverIdentifierText,
        messageReply: messageReply,
      );
    } on FirebaseException catch (e) {
      Utils.showSnackBar(context: context, content: '${e.code}: ${e.message}');
    } catch (e) {
      Utils.showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUId,
    required String receiverIdentifierText,
    required UserModel sender,
    Contact? contact,
    MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();
      final receiverData =
          await _store.collection('users').doc(receiverUId).get();
      await _store
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'lastSeen': timeSent});
      final receiver = UserModel.fromMap(receiverData.data()!);
      final messageId = const Uuid().v1();

      await _storeMessageToUserChats(
        sender: sender,
        receiver: receiver,
        text: text,
        receiverIdentifierText: receiverIdentifierText,
        timeSent: timeSent,
        contact: contact,
      );

      await _storeMessageToUserMessages(
        receiverUId: receiverUId,
        text: text,
        mediaType: MediaType.TEXT,
        timeSent: timeSent,
        messageId: messageId,
        senderUsername: sender.name,
        receiverUsername: receiverIdentifierText,
        messageReply: messageReply,
      );
    } on FirebaseException catch (e) {
      Utils.showSnackBar(context: context, content: '${e.code}: ${e.message}');
    } catch (e) {
      Utils.showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> sendFileMessage({
    required BuildContext context,
    required File file,
    String? fileName,
    required String receiverUId,
    required String receiverIdentifierText,
    required UserModel sender,
    required ProviderRef<dynamic> ref,
    required MediaType mediaType,
    Contact? contact,
    MessageReply? messageReply,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();

      final fileData = await ref.read(commonFirebaseStorageRepoProvider).create(
            'chat/${mediaType.type}/${sender.uid}/$receiverUId/$messageId',
            file,
          );

      final receiverData =
          await _store.collection('users').doc(receiverUId).get();
      await _store
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'lastSeen': timeSent});
      final receiver = UserModel.fromMap(receiverData.data()!);

      await _storeMessageToUserChats(
        sender: sender,
        receiver: receiver,
        text: mediaType.emojify,
        receiverIdentifierText: receiverIdentifierText,
        timeSent: timeSent,
        contact: contact,
      );

      await _storeMessageToUserMessages(
        receiverUId: receiverUId,
        text: fileData.url,
        fileName: fileName,
        fileSize: fileData.size,
        mediaType: mediaType,
        timeSent: timeSent,
        messageId: messageId,
        senderUsername: sender.name,
        receiverUsername: receiverIdentifierText,
        messageReply: messageReply,
      );
    } on FirebaseException catch (e) {
      Utils.showSnackBar(context: context, content: '${e.code}: ${e.message}');
    } catch (e) {
      Utils.showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> _storeMessageToUserChats({
    required UserModel sender,
    required UserModel receiver,
    required String receiverIdentifierText,
    required String text,
    required DateTime timeSent,
    Contact? contact,
  }) async {
    final receiversSenderDocument = _store
        .collection('users')
        .doc(receiver.uid)
        .collection('chats')
        .doc(sender.uid);

    final receiversSenderDocumentData = await receiversSenderDocument.get();

    if (receiversSenderDocumentData.data() == null) {
      final receiverChat = ChatStub(
        senderName: sender.name,
        profilePic: sender.profilePic,
        contactId: sender.uid,
        timeSent: timeSent,
        lastMessage: text,
        findContact: true,
      );
      await receiversSenderDocument.set(receiverChat.toMap());
    } else {
      final receiverChat =
          ChatStub.fromMap(receiversSenderDocumentData.data()!);
      await receiversSenderDocument.update({
        'lastMessage': text,
        'timeSent': timeSent,
        'findContact': receiverChat.contact == null,
      });
    }

    final receiverChatDocumentReference = _store
        .collection('users')
        .doc(sender.uid)
        .collection('chats')
        .doc(receiver.uid);

    final receiverChatDocumentData = await receiverChatDocumentReference.get();

    if (receiverChatDocumentData.data() == null ||
        receiverChatDocumentData.data()!['senderName'] == null) {
      final senderChat = ChatStub(
        senderName: receiverIdentifierText,
        profilePic: receiver.profilePic,
        contactId: receiver.uid,
        timeSent: timeSent,
        lastMessage: text,
        findContact: contact == null,
        contact: contact,
      );
      await receiverChatDocumentReference.set(senderChat.toMap());
    } else {
      await receiverChatDocumentReference.update({
        'lastMessage': text,
        'timeSent': timeSent,
      });
      await receiverChatDocumentReference.get().then((value) {
        if (value.data() == null) return;
        if (value.data()!['contact'] != null) return;
        receiverChatDocumentReference.update({
          'contact': contact?.toJson(),
          'findContact': contact == null,
        });
      });
    }
  }

  Future<void> _storeMessageToUserMessages({
    required String receiverUId,
    required String text,
    String? fileName,
    int? fileSize,
    required MediaType mediaType,
    required DateTime timeSent,
    required String messageId,
    required String senderUsername,
    required String receiverUsername,
    MessageReply? messageReply,
  }) async {
    final message = Message(
      senderId: _auth.currentUser!.uid,
      receiverId: receiverUId,
      text: text,
      mediaType: mediaType,
      timeSent: timeSent,
      fileName: fileName,
      fileSize: fileSize,
      messageId: messageId,
      isSeen: false,
      repliedMediaType: messageReply?.mediaType,
      repliedMessage: messageReply?.message,
      repliedTo: messageReply == null
          ? null
          : messageReply.isMe
              ? _auth.currentUser!.uid
              : receiverUsername,
    );

    await _store
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await _store
        .collection('users')
        .doc(receiverUId)
        .collection('chats')
        .doc(_auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  Future<UserModel?> _getUserById(String userId) async {
    final userData = await _store.collection('users').doc(userId).get();
    if (userData.data() == null) return null;
    return UserModel.fromMap(userData.data()!);
  }

  Future<void> findContactByPhoneNumber(String? searchJson) async {
    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      final searchMap = jsonDecode(searchJson!) as DataMap;
      final phoneNumber = searchMap['phone'] as String;
      final contactId = searchMap['contactId'] as String;
      Contact? contact = contacts.firstWhere(
        (element) {
          for (final phone in element.phones) {
            if (phone.number.onlyNumbers == phoneNumber.onlyNumbers) {
              return true;
            }

            final queryPhoneData =
                PhoneCodes.getCountryDataByPhone(phoneNumber.onlyNumbers);
            if (queryPhoneData != null && queryPhoneData.phoneCode != null) {
              final queryPhone = phoneNumber.onlyNumbers
                  .substring(queryPhoneData.phoneCode!.length);
              if (phone.number.onlyNumbers == queryPhone) return true;
            }
          }
          return false;
        },
        orElse: () => Contact().empty,
      );
      if (contact.id == 'empty') contact = null;

      String? contactPhoneNumber;

      if(contact == null) {
        final contactData = await _store.collection('users').doc(contactId)
            .get();
        contactPhoneNumber = contactData.data()!['phoneNumber'] as String;
      }

      await _store
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(contactId)
          .update({
        'contact': contact?.toJson(),
        'findContact': contact == null, // TODO(LOOK-AT-THIS): This is a bug
        'senderName': contact?.displayName ?? contactPhoneNumber,
      });
    }
  }
}
