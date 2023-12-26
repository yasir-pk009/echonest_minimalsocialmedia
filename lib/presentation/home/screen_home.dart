import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/data/auth_repo.dart';
import 'package:echonest/data/user_posts.dart';
import 'package:echonest/model/post_model.dart';
import 'package:echonest/presentation/home/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:echonest/presentation/login/widgets/drawer/drawer.dart';
import 'package:echonest/presentation/pages/profile.dart';
import 'package:echonest/presentation/login/widgets/listviewtile.dart';
import 'package:echonest/presentation/login/widgets/textfield.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final TextEditingController noteController = TextEditingController();
  File? _image;

  final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
      FirebaseFirestore.instance.collection('user posts').orderBy("message").snapshots();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerWidget(
          signOut: () {
            AuthRepo.instance.signout();
          },
          goToProfile: goToProfile,
          goTochatPage: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Search())),
        ),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: loginPagetextcolor,
          title: const Text(
            "The Echo Nest",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _usersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                     return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Posts Yet"));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: MyWall(
                              message: post["message"],
                              user: post["user"],
                              likes: List<dynamic>.from(post["likes"]),
                              postID: post.id,
                              imageUrl: post["imageUrl"] ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIGOZpywaT1H_mekqLY66lI9aZQo-k95_63w2q3erVuw&s",
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MytextField(
                        hinttext: "Write something...",
                        obscure: false,
                        controller: noteController,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      onPressed: () {
                        selectImage(ImageSource.camera);
                      },
                      icon: const Icon(CupertinoIcons.photo),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () async {
                        final imageUrlProfile = await UserRepo.instance.uploadImageToFirebase(_image!);
                        final postMessage = Post(imageUrl: imageUrlProfile, message: noteController.text);
                        UserRepo.instance.addMessage(post: postMessage);
                        noteController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text("Post"),
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

  void selectImage(source) async {
    File? image = await UserRepo.instance.takePhotoPost(source);
    setState(() {
      _image = image;
    });
  }

  final User? currentUser = FirebaseAuth.instance.currentUser;

  void goToProfile() {
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
  }
}
