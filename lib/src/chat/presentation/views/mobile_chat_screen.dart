import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/core/utils/typedefs.dart';
import 'package:whatsapp/src/auth/controller/auth_controller.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';
import 'package:whatsapp/src/chat/presentation/utils/chat_utils.dart';
import 'package:whatsapp/src/chat/presentation/widgets/chat_field.dart';
import 'package:whatsapp/src/chat/presentation/widgets/chat_list.dart';
import 'package:whatsapp/src/chat/presentation/widgets/typing_status.dart';

class MobileChatScreen extends ConsumerStatefulWidget {
  const MobileChatScreen({super.key, required this.friend});

  static const id = '/chat';

  final UserModel friend;

  @override
  ConsumerState<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends ConsumerState<MobileChatScreen> {
  late Stream<UserModel> userDataStream;

  late Stream<DocumentSnapshot<Map<String, dynamic>>> typingStatusStream;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late Text userIdentifierText;

  Stream<DocumentSnapshot<Map<String, dynamic>>> _getTypingStatusStream() {
    final currentUserId = _auth.currentUser!.uid;
    final receiverId = widget.friend.uid;
    final chatDocRef = _firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(currentUserId);
    final typingStatusDocRef =
        chatDocRef.collection('typingStatus').doc(receiverId);
    return typingStatusDocRef.snapshots();
  }

  @override
  void initState() {
    userDataStream = ref.read(authControllerProvider).userData(
          widget.friend.uid,
        );
    typingStatusStream = _getTypingStatusStream();
    userIdentifierText = Text(
      widget.friend.contact == null
          ? widget.friend.unformattedNumber
          : widget.friend.contact!.displayName,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await ChatUtils.clearReply(ref);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: StreamBuilder<DocumentSnapshot<DataMap>>(
            stream: typingStatusStream,
            builder: (_, snapshot) {
              return TypingStatus(
                snapshot: snapshot.data,
                userDataStream: userDataStream,
                userIdentifierText: userIdentifierText,
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
          children: [
            Expanded(
              child: ChatList(
                receiverUID: widget.friend.uid,
                receiverIdentifierText: userIdentifierText.data!,
              ),
            ),
            ChatField(
              receiverUId: widget.friend.uid,
              receiverIdentifierText: userIdentifierText.data!,
              contact: widget.friend.contact,
            ),
          ],
        ),
      ),
    );
  }
}
