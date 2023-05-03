import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';

@immutable
class UserModel {
  const UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.unformattedNumber,
    required this.lastSeen,
    this.contact,
    required this.groupId,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      unformattedNumber: map['unformattedNumber'] as String,
      lastSeen: (map['lastSeen'] as Timestamp).toDate(),
      groupId: List<String>.from(map['groupId'] as List<dynamic>),
    );
  }

  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final String unformattedNumber;
  final List<String> groupId;
  final Contact? contact;
  final DateTime lastSeen;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'phoneNumber': phoneNumber,
      'unformattedNumber': unformattedNumber,
      'groupId': groupId,
    };
  }

  UserModel copyWith({
    String? name,
    String? uid,
    String? profilePic,
    bool? isOnline,
    String? phoneNumber,
    String? unformattedNumber,
    List<String>? groupId,
    Contact? contact,
    DateTime? lastSeen,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      isOnline: isOnline ?? this.isOnline,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      unformattedNumber: unformattedNumber ?? this.unformattedNumber,
      groupId: groupId ?? this.groupId,
      contact: contact ?? this.contact,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          uid == other.uid &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode => name.hashCode ^ uid.hashCode ^ phoneNumber.hashCode;
}
