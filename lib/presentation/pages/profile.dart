// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/data/user_posts.dart';
import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:echonest/presentation/login/widgets/update_pro.dart';
import 'package:echonest/presentation/pages/widgets/detilas_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imageFile;

  final User? currentUser = FirebaseAuth.instance.currentUser;

  void handleAddProfilePic(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return UploadProfilePictureWidget(
          onchanged: (file) {
            setState(() {
              imageFile = file;
              print("CURRENT STATE OF IMAGEFILE ${imageFile.toString()}");
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: loginPagetextcolor,
        title: const Text(
          'PROFILE PAGE',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users-collection")
            .doc(currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.exists) {
            final Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => handleAddProfilePic(context),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors
                                  .white, // Add your preferred border color
                              width: 2.0, // Adjust the border width as needed
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                    0.5), // Add a subtle shadow color
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 3), // Adjust the shadow offset
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(
                                userData["profilepic"] == "" ?
                                    "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=626&ext=jpg&ga=GA1.1.508103245.1699588812&semt=ais" : userData["profilepic"] ,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () async {
                            if (imageFile == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select a picture!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            print(
                                "THIS IS IMAGE FILE   ${imageFile.toString()}");

                            final imageUrlProfile = await UserRepo.instance
                                .uploadImageToFirebase(imageFile!);
                            print(
                                "THIS IS Http FILE   ${imageUrlProfile.toString()}");
                            UserRepo.instance.updateProfile(imageUrlProfile);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 56, 50, 50),
                            ),
                            child: const Icon(
                              Icons.add_a_photo_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  DetailsBox(
                    title: 'User Details',
                    details: [
                      Text("Username: ${userData["username"]}"),
                      Text("Email: ${userData["email"]}"),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Error"));
          }
        },
      ),
    );
  }
}
