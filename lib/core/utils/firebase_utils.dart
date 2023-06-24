
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:whatsapp/core/extensions/contact_extensions.dart';
import 'package:whatsapp/core/extensions/string_extensions.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';

class FirebaseUtils {
  static final _store = FirebaseFirestore.instance;
  static Future<String> getDisplayNameByUID(String uid) async {
    final user = await getUserById(uid);
    if (await FlutterContacts.requestPermission()) {
      if(user == null) return 'Unknown User';
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      final phoneNumber = user.phoneNumber;
      final contact = contacts.firstWhere(
            (element) {
          for (final phone in element.phones) {
            if (phone.number.onlyNumbers == phoneNumber.onlyNumbers) {
              return true;
            }

            final queryPhoneData =
            PhoneCodes.getCountryDataByPhone(phoneNumber.onlyNumbers);
            if (queryPhoneData != null && queryPhoneData.phoneCode != null) {
              final queryPhone = phoneNumber.onlyNumbers
                  .substring(queryPhoneData.phoneCode!.length);
              if (phone.number.onlyNumbers == queryPhone) return true;
            }
          }
          return false;
        },
        orElse: () => Contact().empty,
      );
      if (contact.id == 'empty') return user.unformattedNumber;
      return contact.displayName;
    }
    return user?.unformattedNumber ?? 'Unknown User';
  }

    static Future<UserModel?> getUserById(String userId) async {
      final userData = await _store.collection('users').doc(userId).get();
      if (userData.data() == null) return null;
      return UserModel.fromMap(userData.data()!);
    }
}
