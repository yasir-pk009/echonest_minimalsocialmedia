// ignore_for_file: use_rethrow_when_possible, avoid_print, duplicate_ignore

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/model/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final User? currectUser = FirebaseAuth.instance.currentUser;

class UserRepo {
  UserRepo._internal();
  static UserRepo instance = UserRepo._internal();
  factory UserRepo() {
    return instance;
  }

  final postRef = FirebaseFirestore.instance
      .collection("User-collection")
      .doc("lenapk@gmail.com");

  Future<void> updateProfile(imageUrlProfile) async {
    try {
      await postRef.update({"profilepic": imageUrlProfile});
    } on FirebaseException catch (e) {
      print("ERROR HAPPENTS WHILE UPDATE ${e.toString()}");
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    // ignore: avoid_print
    print("STARTED UPDATE FUCTION");
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pics/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => null);

      // Get the download URL
      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      // ignore: avoid_print
      print('Error uploading image to Firebase Storage: $e');
      throw e;
    }
  }

  void addMessage({required Post post}) {
    final user = currectUser!.email!.split("@").first;
    FirebaseFirestore.instance.collection("user posts").add({
      "message": post.message,
      "user": user,
      "imageUrl": post.imageUrl,
      "TimeStap": Timestamp.now(),
      "likes": []
    });
  }


  takePhotoPost(ImageSource source)async{
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if(file != null){
      return File(file.path);
    }else {
      print("no image selected");

    }

  }
}
