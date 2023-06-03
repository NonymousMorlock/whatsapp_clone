import 'package:flutter/material.dart';
import 'package:whatsapp/core/extensions/date_extensions.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';

class OnlineStatus extends StatelessWidget {
  const OnlineStatus({
    super.key,
    required this.userDataStream,
    required this.userIdentifierText,
  });

  final Stream<UserModel> userDataStream;
  final Text userIdentifierText;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: userDataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return userIdentifierText;
        }
        final user = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userIdentifierText,
            Text(
              user.isOnline ? 'online' : user.lastSeen.timeAgo,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        );
      },
    );
  }
}
