import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/typedefs.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';
import 'package:whatsapp/src/chat/presentation/widgets/online_status.dart';

class TypingStatus extends StatelessWidget {
  const TypingStatus({
    super.key,
    required this.snapshot,
    required this.userDataStream,
    required this.userIdentifierText,
  });

  final DocumentSnapshot<DataMap>? snapshot;
  final Stream<UserModel> userDataStream;
  final Text userIdentifierText;

  @override
  Widget build(BuildContext context) {
    debugPrint('TypingStatus: ${snapshot?.data()}');
    return snapshot == null ||
            snapshot!.data() == null ||
            !snapshot!.data()!.containsKey('isTyping')
        ? OnlineStatus(
            userDataStream: userDataStream,
            userIdentifierText: userIdentifierText,
          )
        : snapshot!.data()!['isTyping'] as bool
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userIdentifierText,
                  const Text(
                    'typing...',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              )
            : OnlineStatus(
                userDataStream: userDataStream,
                userIdentifierText: userIdentifierText,
              );
  }
}
