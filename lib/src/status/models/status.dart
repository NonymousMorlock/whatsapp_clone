import 'package:flutter/foundation.dart';

@immutable
class Status {
  const Status({
    required this.uid,
    required this.username,
    required this.photoURLs,
    required this.createdAt,
    required this.updatedAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
    this.nextStatus,
  });

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] as String,
      username: map['username'] as String,
      photoURLs: List<String>.from(map['photoURLs'] as List<dynamic>),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['createdAt'] as num).toInt(),
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['updatedAt'] as num).toInt(),
      ),
      profilePic: map['profilePic'] as String,
      statusId: map['statusId'] as String,
      whoCanSee: List<String>.from(map['whoCanSee'] as List<dynamic>),
    );
  }

  Status copyWith({
    String? uid,
    String? username,
    List<String>? photoURLs,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profilePic,
    String? statusId,
    List<String>? whoCanSee,
    Status? nextStatus,
  }) {
    return Status(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      photoURLs: photoURLs ?? this.photoURLs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profilePic: profilePic ?? this.profilePic,
      statusId: statusId ?? this.statusId,
      whoCanSee: whoCanSee ?? this.whoCanSee,
      nextStatus: nextStatus ?? this.nextStatus,
    );
  }

  final String uid;
  final String username;
  final List<String> photoURLs;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;
  final Status? nextStatus;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Status &&
          runtimeType == other.runtimeType &&
          statusId == other.statusId &&
          uid == other.uid;

  @override
  int get hashCode => statusId.hashCode ^ uid.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'photoURLs': photoURLs,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }
}
