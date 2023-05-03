import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/core/res/res.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
    this.onSelectContact,
    this.onInvite,
    required this.onWhatsapp,
  }) : assert(
          onSelectContact == null || onInvite == null,
          'Cannot provide both onSelectContact and onInvite',
        );

  final Contact contact;
  final VoidCallback? onSelectContact;
  final VoidCallback? onInvite;
  final bool onWhatsapp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          contact.displayName,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: contact.photo == null
              ? const AssetImage(Res.user)
              : MemoryImage(contact.photo!) as ImageProvider,
          radius: 20,
        ),
        trailing: onWhatsapp
            ? null
            : TextButton(
                onPressed: onInvite,
                child: const Text(
                  'Invite',
                  style: TextStyle(color: tabColor, letterSpacing: 1.2),
                ),
              ),
        onTap: !onWhatsapp ? null : onSelectContact,
      ),
    );
  }
}
