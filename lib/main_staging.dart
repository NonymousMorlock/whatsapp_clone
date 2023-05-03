import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/app/app.dart';
import 'package:whatsapp/bootstrap.dart';
import 'package:whatsapp/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await bootstrap(() => const ProviderScope(child: App()));
}
