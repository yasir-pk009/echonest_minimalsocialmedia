import 'package:echonest/data/auth_repo.dart';
import 'package:echonest/model/user_model.dart';
import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:echonest/presentation/login/widgets/imagetile.dart';
import 'package:echonest/presentation/login/widgets/signbotton.dart';
import 'package:echonest/presentation/login/widgets/textfield.dart';
import 'package:flutter/material.dart';
// import 'package:student_managment/core/colors.dart';


class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();

  final passwordController = TextEditingController();
  bool obsecureBool = false;

  @override
  void dispose() {
    emailTextController.clear();
    passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Hello!",
                style: TextStyle(
                  color: loginPagetextcolor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  color: loginPagetextcolor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MytextField(
                hinttext: "Email",
                obscure: false,
                controller: emailTextController,
                icon: IconButton(
                    onPressed: () {
                      emailTextController.clear();
                    },
                    icon: const Icon(Icons.clear)),
              ),
              MytextField(
                hinttext: "Password",
                obscure: !obsecureBool,
                controller: passwordController,
                icon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecureBool = !obsecureBool;
                      });
                    },
                    icon: const Icon(Icons.visibility)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password ?",
                      style: TextStyle(
                          color: loginPagetextcolor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SignBotton(onTap: signin, text: "Sign in"),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dont have an account?",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: loginPagetextcolor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageTile(
                    ontap: () {
                      AuthRepo.instance.signInWithGoogle();
                    },
                    imagePath: "assets/google.jpeg",
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ImageTile(
                    ontap: () {
                     
                    },
                    imagePath:
                        "assets/smartphone-and-mobile-phone-free-png.webp",
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }

  signin() {
    final usermodelObject = UserModel(
        name: emailTextController.text.split("@").first,
        password: passwordController.text,
        email: emailTextController.text);

    AuthRepo.instance.signIn(usermodelObject, context);
  }
}
