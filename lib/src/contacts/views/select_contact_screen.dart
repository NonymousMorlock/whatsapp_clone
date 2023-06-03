import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/core/common/views/error_screen.dart';
import 'package:whatsapp/core/common/views/loading_screen.dart';
import 'package:whatsapp/src/chat/presentation/views/mobile_chat_screen.dart';
import 'package:whatsapp/src/contacts/controller/contact_controller.dart';
import 'package:whatsapp/src/contacts/widgets/contact_tile.dart';

class SelectContactScreen extends ConsumerWidget {
  const SelectContactScreen({super.key});

  static const id = '/select-contact';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: ref.watch(getContactsProvider).when(
              data: (contacts) {
                return ListView(
                  children: [
                    const SizedBox(height: 20),
                    if (contacts['onWhatsapp']!.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Contacts on Whatsapp',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: contacts['onWhatsapp']!.length,
                        itemBuilder: (context, index) {
                          final contact = contacts['onWhatsapp']![index];
                          return ContactTile(
                            contact: contact,
                            onSelectContact: () async {
                              final navigator = Navigator.of(context);
                              final user = await ref
                                  .read(contactControllerProvider)
                                  .selectContact(
                                    contact,
                                    context,
                                  );
                              if (user != null) {
                                unawaited(
                                  navigator.pushReplacementNamed(
                                    MobileChatScreen.id,
                                    arguments: user.copyWith(
                                      contact: contact,
                                    ),
                                  ),
                                );
                              }
                            },
                            onWhatsapp: true,
                          );
                        },
                      ),
                    ],
                    if (contacts['notOnWhatsapp']!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Invite to Whatsapp',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: contacts['notOnWhatsapp']!.length,
                        itemBuilder: (context, index) {
                          final contact = contacts['notOnWhatsapp']![index];
                          return ContactTile(
                            contact: contact,
                            onInvite: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              if (contact.phones.isEmpty) {
                                messenger
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'No phone number found for '
                                        'this contact',
                                      ),
                                    ),
                                  );
                                return;
                              }
                              final uri = Uri(
                                scheme: 'sms',
                                path: contact.phones.first.normalizedNumber,
                                queryParameters: <String, String>{
                                  'body': Uri.encodeComponent("Let's chat on "
                                      "WhatsApp! It's a fast, simple, and "
                                      'secure app we can use to message and '
                                      'call each other for free. Get it at '
                                      'whatsapp.com')
                                },
                              );
                              if (!await launchUrl(uri)) {
                                messenger
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Could not send invite, please try '
                                        'again',
                                      ),
                                    ),
                                  );
                              }
                            },
                            onWhatsapp: false,
                          );
                        },
                      ),
                    ],
                  ],
                );
              },
              error: (err, stack) {
                debugPrint('ERROR: $stack');
                return ErrorScreen(error: err.toString());
              },
              loading: () => const LoadingScreen(),
            ),
      ),
    );
  }
}
