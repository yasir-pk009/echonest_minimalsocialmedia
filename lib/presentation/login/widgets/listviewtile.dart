// ignore_for_file: invalid_use_of_visible_for_testing_member, avoid_print, invalid_use_of_protected_member, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/presentation/login/widgets/likebottom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyWall extends StatelessWidget {
  final String message;
  final String user;
  final String? postID;
  final List<dynamic> likes;
  final String imageUrl;

  MyWall({
    super.key,
    required this.message,
    required this.user,
    required this.postID,
    required this.likes,
    required this.imageUrl,
  });

  final User? currentuser = FirebaseAuth.instance.currentUser;

  ValueNotifier<bool> likedButtonNotifier = ValueNotifier(false);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
     ),
      height: MediaQuery.of(context).size.height / 2.2,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              user,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
                   decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover,image: NetworkImage(imageUrl))),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              const SizedBox(height: 8),
              Row(
                children: [
                  ValueListenableBuilder(
                    valueListenable: likedButtonNotifier,
                    builder: (context, value, child) {
                      return LikeButton(
                        onTap: () async{
                        final updatedIsLiked = await toggleBool();
                      likedButtonNotifier.value = updatedIsLiked;
                        },
                        isLiked: likedButtonNotifier.value
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    likes.length.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 20,),
                   Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

 Future<bool> toggleBool() async {
   likedButtonNotifier.value = !likedButtonNotifier.value;
  print(likedButtonNotifier.value);


  final postRef = FirebaseFirestore.instance.collection("user posts").doc(postID);

  try {
    if (likedButtonNotifier.value) {
      await postRef.update({
        "likes": FieldValue.arrayUnion([currentuser!.email])
      });
   
    } else {
      await postRef.update({
        "likes": FieldValue.arrayRemove([currentuser!.email])
      });
   
    }
    return true;
      // likedButtonNotifier.notifyListeners();
  } catch (error) {
    // Handle error, and possibly revert likedButtonNotifier.value if needed
    print("Error updating likes: $error");
    likedButtonNotifier.value = !likedButtonNotifier.value;
    likedButtonNotifier.notifyListeners();
     return false;
  }
}

}
