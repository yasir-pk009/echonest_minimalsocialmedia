import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String emailToAlign;

  const ChatMessage({Key? key, required this.text, required this.emailToAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: emailToAlign == 'senderEmail'
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: emailToAlign == 'senderEmail'
              ? Colors.blue
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
