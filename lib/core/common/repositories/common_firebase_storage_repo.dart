import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepoProvider = Provider(
  (ref) => CommonFirebaseStorageRepo(FirebaseStorage.instance),
);

class CommonFirebaseStorageRepo {
  const CommonFirebaseStorageRepo(this._db);

  final FirebaseStorage _db;

  Future<String> create(String ref, File file) async {
    final uploadTask = _db.ref().child(ref).putFile(file);
    final snap = await uploadTask;
    return snap.ref.getDownloadURL();
  }
}
