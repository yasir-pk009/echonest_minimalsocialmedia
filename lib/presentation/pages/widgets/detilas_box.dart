import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final User? currentUser = FirebaseAuth.instance.currentUser;

class DetailsBox extends StatelessWidget {
  final String title;
  final List<Widget> details;

  DetailsBox({super.key, required this.title, required this.details});

  final postRef = FirebaseFirestore.instance.collection("Users-collection").doc(currentUser!.email);

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(7.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.black, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Edit Your Profile", style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
                          content: SizedBox(
                            width: 300,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                TextField(
                                  controller: userNameController,
                                  decoration: const InputDecoration(
                                    labelText: "User Name",
                                    prefixIcon: Icon(Icons.person, color: Colors.black),
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    labelText: "Email",
                                    prefixIcon: Icon(Icons.email, color: Colors.black),
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("CANCEL", style: TextStyle(color: Colors.red)),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        postRef.update({"username": userNameController.text, "email": emailController.text});
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: loginPagetextcolor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: const Text("SAVE",style: TextStyle(color: Colors.white),),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
