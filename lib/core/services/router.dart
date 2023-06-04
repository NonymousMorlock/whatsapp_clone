import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/common/responsive/mobile_layout_screen.dart';
import 'package:whatsapp/core/common/views/error_screen.dart';
import 'package:whatsapp/core/utils/typedefs.dart';
import 'package:whatsapp/src/auth/models/user_model.dart';
import 'package:whatsapp/src/auth/views/login_screen.dart';
import 'package:whatsapp/src/auth/views/otp_screen.dart';
import 'package:whatsapp/src/auth/views/user_information_screen.dart';
import 'package:whatsapp/src/chat/presentation/views/mobile_chat_screen.dart';
import 'package:whatsapp/src/chat/presentation/views/video_player_view.dart';
import 'package:whatsapp/src/contacts/views/select_contact_screen.dart';
import 'package:whatsapp/src/landing/presentation/views/landing_screen.dart';
import 'package:whatsapp/src/status/presentation/views/status_preview_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LandingScreen.id:
      return _pageBuilder((_) => const LandingScreen(), settings: settings);
    case LoginScreen.id:
      return _pageBuilder((_) => const LoginScreen(), settings: settings);
    case OTPScreen.id:
      final arguments = settings.arguments! as DataMap;
      return _pageBuilder(
        (_) => OTPScreen(
          verificationId: arguments['verificationId'] as String,
          unformattedNumber: arguments['phone'] as String,
        ),
        settings: settings,
      );
    case UserInformationScreen.id:
      final unformattedNumber = settings.arguments! as String;
      return _pageBuilder(
        (_) => UserInformationScreen(unformattedNumber: unformattedNumber),
        settings: settings,
      );
    case MobileLayoutScreen.id:
      return _pageBuilder(
        (_) => const MobileLayoutScreen(),
        settings: settings,
      );
    case SelectContactScreen.id:
      return _pageBuilder(
        (_) => const SelectContactScreen(),
        settings: settings,
      );
    case MobileChatScreen.id:
      return _pageBuilder(
        (_) => MobileChatScreen(friend: settings.arguments! as UserModel),
        settings: settings,
      );
    case VideoPlayerView.id:
      return _pageBuilder(
        (_) => VideoPlayerView(
          videoURL: settings.arguments! as String,
        ),
        settings: settings,
      );

    case StatusPreviewScreen.id:
      return _pageBuilder(
        (_) => StatusPreviewScreen(
          file: settings.arguments! as File,
        ),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => ErrorScreen(error: 'No route defined for ${settings.name}'),
        settings: settings,
      );
  }
}

MaterialPageRoute<void> _pageBuilder(
  Widget Function(BuildContext) pageBuilder, {
  required RouteSettings settings,
}) {
  return MaterialPageRoute(builder: pageBuilder, settings: settings);
}
