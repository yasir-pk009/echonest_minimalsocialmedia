
import 'package:flutter/material.dart';



// ignore: must_be_immutable
class MytextField extends StatelessWidget {
  final IconButton? icon;
  final TextEditingController? controller;
  final String hinttext;
   bool? obscure;

   MytextField(
      {super.key,
      this.controller,
      required this.hinttext,
       this.obscure=false,  this.icon});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 16.0,right: 16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Material(
          elevation: 4.0,
          child: TextField(
            
            controller: controller,
            obscureText: obscure!,
            decoration: InputDecoration(
              suffixIcon: icon,
              hintText: hinttext,
              contentPadding: const EdgeInsets.all(16.0),
              border: InputBorder.none, 
            ),
          ),
        ),
      ),
    );
  }
}
