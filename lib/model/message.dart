import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String reciverID;
  final String messages;
  final Timestamp timestamp;

  Message({required this.senderID, required this.senderEmail, required this.reciverID, required this.messages, required this.timestamp});


   Map<String,dynamic> toMap(){
    return {
      'messages':messages,
      'senderId': senderID,
      'senderEmail':senderEmail,
      'reciverId':reciverID,
      'timestamp': timestamp

    };
   }
}