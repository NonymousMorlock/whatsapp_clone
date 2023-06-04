import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/common/repositories/common_firebase_storage_repo.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';
import 'package:whatsapp/src/auth/views/otp_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  const AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<UserModel?> getCurrentUserData() async {
    final userData =
        await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    if (userData.data() == null) return null;
    return UserModel.fromMap(userData.data()!);
  }

  Future<void> signInWithPhone(
    BuildContext context, {
    required String formattedNumber,
    required String unformattedNumber,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException exception) {
          throw exception;
        },
        codeSent: (String verificationId, int? resendToken) async {
          await Navigator.of(context).pushNamed(
            OTPScreen.id,
            arguments: {
              'verificationId': verificationId,
              'phone': unformattedNumber,
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(context: context, content: e.toString());
      return Future.value();
    }
  }

  Future<String?> verifyOTP({
    required BuildContext context,
    required String verificationID,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationID,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(context: context, content: e.toString());
      return e.toString();
    }
  }

  Future<bool> saveUserToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef<dynamic> ref,
    required String unformattedNumber,
    required BuildContext context,
  }) async {
    try {
      final uid = _auth.currentUser!.uid;
      var picUrl = 'https://images.freeimages'
          '.com/fic/images/icons/573/must_have/256/user.png';
      if (profilePic != null) {
        final picData =
            await ref.read(commonFirebaseStorageRepoProvider).create(
                  'profile_pic/$uid',
                  profilePic,
                );
        picUrl = picData.url;
      }
      final user = UserModel(
        name: name,
        uid: uid,
        profilePic: picUrl,
        isOnline: true,
        lastSeen: DateTime.now(),
        phoneNumber: _auth.currentUser!.phoneNumber!,
        unformattedNumber: unformattedNumber,
        groupId: const [],
      );
      await _firestore.collection('users').doc(uid).set(user.toMap());
      return true;
    } catch (e) {
      Utils.showSnackBar(context: context, content: e.toString());
      return false;
    }
  }

  Stream<UserModel> userData(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(event.data()!),
        );
  }

  Future<void> setUserState({required bool isOnline}) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
