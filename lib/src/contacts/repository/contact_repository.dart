import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';

final contactRepositoryProvider = Provider(
  (ref) => ContactRepository(FirebaseFirestore.instance),
);

class ContactRepository {
  const ContactRepository(this._store);

  final FirebaseFirestore _store;

  Future<Map<String, List<Contact>>> getContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        final contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
        final contactsNotOnWhatsapp = <Contact>[];
        final contactsOnWhatsapp = <Contact>[];

        final userCollection = await _store.collection('users').get();

        for (final contact in contacts) {
          if (await _contactExists(userCollection.docs, contact)) {
            contactsOnWhatsapp.add(contact);
          } else {
            contactsNotOnWhatsapp.add(contact);
          }
        }
        return {
          'onWhatsapp': contactsOnWhatsapp,
          'notOnWhatsapp': contactsNotOnWhatsapp,
        };
      }
      return {'onWhatsapp': [], 'notOnWhatsapp': []};
    } catch (e, s) {
      debugPrint('ERROR: $e\n$s');
      return {'onWhatsapp': [], 'notOnWhatsapp': []};
    }
  }

  Future<bool> _contactExists(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    Contact selectedContact,
  ) async {
    try {
      var isFound = false;
      for (final userDocument in docs) {
        final userData = UserModel.fromMap(userDocument.data());
        if (selectedContact.phones.any(
          (phone) => phone.normalizedNumber == userData.phoneNumber,
        )) {
          isFound = true;
        }
      }
      return isFound;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> selectContact(
    Contact selectedContact,
    BuildContext context,
  ) async {
    try {
      final userCollection = await _store.collection('users').get();
      final userDoc = userCollection.docs.firstWhere(
        (doc) =>
            UserModel.fromMap(doc.data()).phoneNumber ==
            selectedContact.phones.first.normalizedNumber,
      );
      return UserModel.fromMap(userDoc.data());
    } catch (e, s) {
      debugPrint('INFO: $s');
      Utils.showSnackBar(context: context, content: e.toString());
      return null;
    }
  }
}
