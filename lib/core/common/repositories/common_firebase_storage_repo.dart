import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepoProvider = Provider(
  (ref) => CommonFirebaseStorageRepo(FirebaseStorage.instance),
);

class CommonFirebaseStorageRepo {
  const CommonFirebaseStorageRepo(this._db);

  final FirebaseStorage _db;

  Future<({String url, int? size})> create(String ref, File file) async {
    final uploadTask = _db.ref().child(ref).putFile(file);
    final snap = await uploadTask;
    final metadata = await snap.ref.getMetadata();
    final fileSize = metadata.size;
    final downloadUrl = await snap.ref.getDownloadURL();
    return (url: downloadUrl, size: fileSize);
  }
}
