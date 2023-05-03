import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/extensions/date_extensions.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/src/auth/controller/auth_controller.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';
import 'package:whatsapp/src/chat/presentation/widgets/chat_field.dart';
import 'package:whatsapp/src/chat/presentation/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerStatefulWidget {
  const MobileChatScreen({super.key, required this.friend});

  static const id = '/chat';

  final UserModel friend;

  @override
  ConsumerState<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends ConsumerState<MobileChatScreen> {
  late Stream<UserModel> userDataStream;

  late Text userIdentifierText;

  @override
  void initState() {
    userDataStream = ref.read(authControllerProvider).userData(
          widget.friend.uid,
        );
    userIdentifierText = Text(
      widget.friend.contact == null
          ? widget.friend.unformattedNumber
          : widget.friend.contact!.displayName,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
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
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: ChatList(),
          ),
          ChatField(),
        ],
      ),
    );
  }
}
