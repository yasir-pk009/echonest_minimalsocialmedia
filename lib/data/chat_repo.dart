import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 

 
class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
 


  Future<void> sendMessage(String reciverID, String messages) async {
    final String currectUserId = _firebaseAuth.currentUser!.uid;

    final String currectUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message Newmessage = Message(
        senderID: currectUserId,
        senderEmail: currectUserEmail,
        reciverID: reciverID,
        messages: messages,
        timestamp: timestamp);

    List<String> ids = [currectUserEmail, reciverID];
    ids.sort();
    String chatRoomId = ids.join("_");
    print(reciverID.toString());
    print("${chatRoomId.toString()} thsi tis ");
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(Newmessage.toMap());
        print("added");
  }

  Stream<QuerySnapshot<Object?>> getMessages(
      String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    print("this is getmessage");
    print(chatRoomId.toString());
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
