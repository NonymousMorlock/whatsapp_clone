import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';
import 'package:whatsapp/src/contacts/repository/contact_repository.dart';

final contactControllerProvider = Provider(
  (ref) => ContactController(
    repository: ref.watch(contactRepositoryProvider),
    ref: ref,
  ),
);

final getContactsProvider = FutureProvider((ref) {
  final contactRepository = ref.watch(contactRepositoryProvider);
  return contactRepository.getContacts();
});

class ContactController {
  const ContactController({
    required ProviderRef<dynamic> ref,
    required ContactRepository repository,
  })  : _repository = repository,
        _ref = ref;

  final ContactRepository _repository;
  final ProviderRef<dynamic> _ref;

  Future<UserModel?> selectContact(
    Contact selectedContact,
    BuildContext context,
  ) async =>
      _repository.selectContact(selectedContact, context);
}
