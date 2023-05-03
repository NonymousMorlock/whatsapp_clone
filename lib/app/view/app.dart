import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/common/responsive/mobile_layout_screen.dart';
import 'package:whatsapp/core/common/views/error_screen.dart';
import 'package:whatsapp/core/common/views/loading_screen.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/core/services/router.dart';
import 'package:whatsapp/l10n/l10n.dart';
import 'package:whatsapp/src/auth/controller/auth_controller.dart';
import 'package:whatsapp/src/landing/presentation/views/landing_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarColor,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: generateRoute,
      home: ref.watch(userProvider).when(
            data: (user) {
              if(user == null) return const LandingScreen();
              return const MobileLayoutScreen();
            },
            error: (err, stack) {
              debugPrint('ERROR: $stack');
              return ErrorScreen(error: err.toString());
            },
            loading: () => const LoadingScreen(),
          ),
    );
  }
}
