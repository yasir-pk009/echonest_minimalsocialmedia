import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:echonest/data/chat_repo.dart'; // Import your chat repository
import 'package:echonest/presentation/chat/widget/chat_message.dart';

class ChatPage extends StatelessWidget {
  final String username;
  final String reciverID;

  ChatPage({super.key, required this.username, required this.reciverID});

  final ChatService chatService = ChatService();
  final messageController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(reciverID, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: appbarIconsColor),
        title: Text(
          username,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: loginPagetextcolor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: chatService.getMessages(
                   _firebaseAuth.currentUser!.email.toString(),
                 reciverID
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return  Center(child: Text("No Posts Yet ${snapshot.data!.docs}"));
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return ChatMessage(text: post["messages"],emailToAlign: post["senderId"] == _firebaseAuth.currentUser!.uid ? "senderEmail": "reciverID");
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        sendMessage();
                        messageController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
