import 'package:echonest/firebase_options.dart';
import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:echonest/presentation/login/screen_authentication.dart';
import 'package:echonest/themes/dart_theme.dart';
import 'package:echonest/themes/light_them.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        // darkTheme: darkTheme,
        home: const AuthPage());
  }
}
