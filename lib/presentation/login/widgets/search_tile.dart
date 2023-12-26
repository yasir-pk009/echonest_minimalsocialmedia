// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:echonest/presentation/chat/chatpage.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchPageTile extends StatelessWidget {
 
  final String user;
  final imageUrl;
  final void Function()? onTap;

   SearchPageTile({
    super.key,
   required this.imageUrl,
    required this.user,required this.onTap,
  });



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      //
      // () => Navigator.of(context).push(
      //     MaterialPageRoute(builder: (context) => ChatPage(username: user, reciverID: user,))),
      child: Card(
        elevation: 4, // Add elevation to the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
               CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 10),
              // Email and Message on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      user,
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
