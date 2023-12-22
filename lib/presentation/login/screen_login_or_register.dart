import 'package:echonest/presentation/login/screen_login.dart';
import 'package:flutter/material.dart';

import 'screen_register.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showloginPage = true;
  void togglePage() {
    setState(() {
       showloginPage = !showloginPage;
    });
   
  }

  @override
  Widget build(BuildContext context) {
    if (showloginPage) {
      return LoginPage(
        onTap: togglePage,
      );
    } else {
      return RegisterPage(
        onTap: togglePage,
      );
    }
  }
}
