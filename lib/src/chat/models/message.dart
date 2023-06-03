import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/core/enums/media_type.dart';
import 'package:whatsapp/core/extensions/string_extensions.dart';
import 'package:whatsapp/core/utils/typedefs.dart';

class Message {
  const Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.mediaType,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    this.repliedMessage,
    this.repliedTo,
    this.repliedMediaType,
  });

  Message.fromMap(DataMap map)
      : senderId = map['senderId'] as String,
        receiverId = map['receiverId'] as String,
        text = map['text'] as String,
        mediaType = (map['mediaType'] as String).toMediaType,
        repliedMediaType = (map['repliedMediaType'] as String?)?.toMediaType,
        repliedMessage = map['repliedMessage'] as String?,
        repliedTo = map['repliedTo'] as String?,
        timeSent = (map['timeSent'] as Timestamp).toDate(),
        messageId = map['messageId'] as String,
        isSeen = map['isSeen'] as bool;

  final String senderId;
  final String receiverId;
  final String text;
  final MediaType mediaType;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String? repliedMessage;
  final String? repliedTo;
  final MediaType? repliedMediaType;

  Message copyWith({
    String? senderId,
    String? receiverId,
    String? text,
    MediaType? mediaType,
    MediaType? repliedMediaType,
    String? repliedMessage,
    String? repliedTo,
    DateTime? timeSent,
    String? messageId,
    bool? isSeen,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      mediaType: mediaType ?? this.mediaType,
      repliedMediaType: repliedMediaType ?? this.repliedMediaType,
      repliedMessage: repliedMessage ?? this.repliedMessage,
      repliedTo: repliedTo ?? this.repliedTo,
      timeSent: timeSent ?? this.timeSent,
      messageId: messageId ?? this.messageId,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  DataMap toMap() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'mediaType': mediaType.type,
        'repliedMediaType': repliedMediaType?.type,
        'repliedMessage': repliedMessage,
        'repliedTo': repliedTo,
        'timeSent': timeSent,
        'messageId': messageId,
        'isSeen': isSeen,
      };
}
