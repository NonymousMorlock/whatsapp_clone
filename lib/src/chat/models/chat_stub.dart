import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp/core/utils/typedefs.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';

@immutable
class ChatStub {
  const ChatStub({
    required this.senderName,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
    this.sender,
    this.contact,
    required this.findContact,
  });

  ChatStub.fromMap(DataMap map)
      : senderName = map['senderName'] as String,
        profilePic = map['profilePic'] as String,
        contactId = map['contactId'] as String,
        timeSent = (map['timeSent'] as Timestamp).toDate(),
        lastMessage = map['lastMessage'] as String,
        sender = null,
        findContact = map['findContact'] as bool,
        contact = (map['contact'] as DataMap?) != null
            ? Contact.fromJson(map['contact'] as DataMap)
            : null;
  final String senderName;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;
  final UserModel? sender;
  final Contact? contact;
  final bool findContact;

  ChatStub copyWith({
    String? senderName,
    String? profilePic,
    String? contactId,
    DateTime? timeSent,
    String? lastMessage,
    UserModel? sender,
    Contact? contact,
    bool? findContact,
  }) {
    return ChatStub(
      senderName: senderName ?? this.senderName,
      profilePic: profilePic ?? this.profilePic,
      contactId: contactId ?? this.contactId,
      timeSent: timeSent ?? this.timeSent,
      lastMessage: lastMessage ?? this.lastMessage,
      sender: sender ?? this.sender,
      contact: contact ?? this.contact,
      findContact: findContact ?? this.findContact,
    );
  }

  DataMap toMap() => {
        'senderName': senderName,
        'profilePic': profilePic,
        'contactId': contactId,
        'timeSent': timeSent,
        'lastMessage': lastMessage,
        'contact': sender?.contact?.toJson(),
        'findContact': findContact,
      };

  @override
  String toString() {
    return 'ChatStub{senderName: $senderName, profilePic: $profilePic, '
        'contactId: $contactId, timeSent: $timeSent, lastMessage: '
        '$lastMessage, sender: $sender, contact: $contact, findContact: '
        '$findContact}';
  }
}
