import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';
import 'package:whatsapp/src/auth/repository/auth_repository.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.watch<AuthRepository>(authRepositoryProvider),
    ref: ref,
  ),
);

final userProvider = FutureProvider((ref) {
  final authController = ref.watch<AuthController>(authControllerProvider);
  return authController.getCurrentUserData();
});

class AuthController {
  const AuthController({
    required AuthRepository authRepository,
    required ProviderRef<dynamic> ref,
  })  : _authRepository = authRepository,
        _ref = ref;

  final AuthRepository _authRepository;

  final ProviderRef<dynamic> _ref;

  Future<UserModel?> getCurrentUserData() async =>
      _authRepository.getCurrentUserData();

  Future<void> signInWithPhone(
    BuildContext context, {
    required String formattedNumber,
    required String unformattedNumber,
  }) async =>
      _authRepository.signInWithPhone(
        context,
        formattedNumber: formattedNumber,
        unformattedNumber: unformattedNumber,
      );

  Future<String?> verifyOTP({
    required BuildContext context,
    required String verificationID,
    required String otp,
  }) async =>
      _authRepository.verifyOTP(
        context: context,
        verificationID: verificationID,
        otp: otp,
      );

  Future<bool> saveUserToFirebase({
    required String name,
    required File? profilePic,
    required String unformattedNumber,
    required BuildContext context,
  }) async =>
      _authRepository.saveUserToFirebase(
        name: name,
        ref: _ref,
        context: context,
        unformattedNumber: unformattedNumber,
        profilePic: profilePic,
      );

  Stream<UserModel> userData(String userId) => _authRepository.userData(userId);

  Future<void> setUserState({required bool isOnline}) =>
      _authRepository.setUserState(isOnline: isOnline);
}
