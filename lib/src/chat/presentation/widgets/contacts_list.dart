import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/common/views/loading_screen.dart';
import 'package:whatsapp/core/common/widgets/global_tile.dart';
import 'package:whatsapp/core/extensions/date_extensions.dart';
import 'package:whatsapp/core/extensions/string_extensions.dart';
import 'package:whatsapp/src/chat/controller/chat_controller.dart';
import 'package:whatsapp/src/chat/models/chat_stub.dart';
import 'package:whatsapp/src/chat/presentation/views/mobile_chat_screen.dart';

class ContactsList extends ConsumerStatefulWidget {
  const ContactsList({super.key});

  @override
  ConsumerState<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends ConsumerState<ContactsList> {
  /// holds a list of contacts that have been checked
  /// checked if their contact has been fetched
  /// this is important in cases where the current user has a chatstub, but
  /// the sender's contact name on their phone hasnt been fetched yet
  /// their contact name will be fetched when we detect that a chatstub's
  /// contact is missing, meaning that user is new for us and we must check
  /// the current user's phone contacts to see if they have a contact with
  /// the same number as the chatstub's contactId, if yes, then we use the
  /// stored name as their display name and add their id to this list
  final List<String> checked = [];

  Stream<List<ChatStub>>? stream;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatStub>>(
        stream: stream ?? ref.watch(chatControllerProvider).getChatStubs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.data == null) return const SizedBox.shrink();
          final stubs = snapshot.data!
            ..sort((a, b) => b.timeSent.compareTo(a.timeSent));
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final chatStub = stubs[index];
              if (chatStub.contact == null &&
                  !checked.contains(
                    chatStub.contactId,
                  )) {
                checked.add(chatStub.contactId);
                stream = ref.watch(chatControllerProvider).getChatStubs();
              }
              return GlobalTile(
                title: chatStub.senderName,
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    chatStub.lastMessage,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                profileImage: chatStub.profilePic,
                trailing: Text(
                  chatStub.timeSent.dateOrDayAgo.titleCase,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    MobileChatScreen.id,
                    arguments: chatStub.sender,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
