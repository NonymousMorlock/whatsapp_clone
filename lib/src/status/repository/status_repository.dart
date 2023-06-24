import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show BuildContext, debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/core/common/repositories/common_firebase_storage_repo.dart';
import 'package:whatsapp/core/utils/firebase_utils.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/status/models/status.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    store: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  const StatusRepository({
    required FirebaseFirestore store,
    required FirebaseAuth auth,
    required ProviderRef<dynamic> ref,
  })  : _store = store,
        _auth = auth,
        _ref = ref;

  final FirebaseFirestore _store;
  final FirebaseAuth _auth;
  final ProviderRef<dynamic> _ref;

  Future<void> uploadStatus({
    required BuildContext context,
    required File statusImage,
  }) async {
    try {
      final now = DateTime.now();
      if (_auth.currentUser == null) throw Exception('User not logged in');
      final statusId = const Uuid().v1();
      final uid = _auth.currentUser!.uid;
      final statusImageData = await _ref
          .read(commonFirebaseStorageRepoProvider)
          .create('/status/$uid/$statusId', statusImage);

      final whoCanSee = <String>[];

      final users =
          await _store.collection('users').doc(uid).collection('chats').get();

      for (final user in users.docs) {
        if (user.data()['contact'] != null) {
          whoCanSee.add(user.id);
        }
      }

      var statusImageURLs = <String>[];
      final statusSnapshots =
          await _store.collection('status').where('uid', isEqualTo: uid).get();
      if (statusSnapshots.docs.isNotEmpty) {
        final status = Status.fromMap(statusSnapshots.docs[0].data());
        statusImageURLs = status.photoURLs..add(statusImageData.url);
        await _store
            .collection('status')
            .doc(statusSnapshots.docs[0].id)
            .update({
          'photoURLs': statusImageURLs,
          'whoCanSee': whoCanSee,
          'updatedAt': now.millisecondsSinceEpoch,
        });
      } else {
        statusImageURLs = [statusImageData.url];
        final status = Status(
          uid: uid,
          username: _auth.currentUser!.phoneNumber ?? 'Unknown',
          photoURLs: statusImageURLs,
          createdAt: now,
          updatedAt: now,
          profilePic: _auth.currentUser!.photoURL!,
          statusId: statusId,
          whoCanSee: whoCanSee,
        );
        // we could actually use collection('status').add(status.toMap()),
        // then call update on the document with the id returned from add
        await _store.collection('status').doc(statusId).set(status.toMap());
      }
    } on FirebaseException catch (e) {
      Utils.showSnackBar(context: context, content: '${e.code}: ${e.message}');
    } catch (e, s) {
      debugPrint(s.toString());
      Utils.showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<Status>> getStatus(BuildContext context) {
    final statusStreamController = StreamController<List<Status>>();

    if (_auth.currentUser == null) {
      statusStreamController
        ..addError(Exception('User not logged in'))
        ..close();
      return statusStreamController.stream;
    }

    final uid = _auth.currentUser!.uid;
    final query = _store
        .collection('status')
        .where('whoCanSee', arrayContains: uid)
        .where(
          'updatedAt',
          isGreaterThan: DateTime.now()
              .subtract(const Duration(hours: 24))
              .millisecondsSinceEpoch,
        );

    final subscription = query.snapshots().listen(
      (statusSnapshots) async {
        if (statusSnapshots.docs.isNotEmpty) {
          final statuses = <Status>[];
          for (final snapshot in statusSnapshots.docs) {
            final displayName = await FirebaseUtils.getDisplayNameByUID(
              snapshot.data()['uid'] as String,
            );
            statuses.add(
              Status.fromMap(snapshot.data()).copyWith(username: displayName),
            );
          }
          statusStreamController.add(statuses);
        } else {
          statusStreamController.add([]);
        }
      },
      onError: (Object error) {
        if (error is FirebaseException) {
          Utils.showSnackBar(
            context: context,
            content: '${error.code}: ${error.message}',
          );
        } else {
          Utils.showSnackBar(context: context, content: error.toString());
        }
        statusStreamController.add([]);
      },
    );

    // Close the stream controller and cancel the subscription when no
    // longer needed  (e.g., when the widget is disposed)
    // You can also define this in a separate method and call it appropriately.
    void closeStream() {
      statusStreamController.close();
      subscription.cancel();
    }

    return statusStreamController.stream;
  }
}
