import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:flutter/material.dart';


class SignBotton extends StatelessWidget {

  final  Function()? onTap;
  final String text;
  const SignBotton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: loginPagetextcolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child:  Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
