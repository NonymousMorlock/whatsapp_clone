import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/app/app.dart';
import 'package:whatsapp/bootstrap.dart';
import 'package:whatsapp/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await bootstrap(
    () => DevicePreview(
      enabled: defaultTargetPlatform != TargetPlatform.iOS &&
          defaultTargetPlatform != TargetPlatform.android,
      builder: (_) => const ProviderScope(child: App()),
    ),
  );
}
