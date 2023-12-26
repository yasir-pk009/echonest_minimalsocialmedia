// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepo {
  AuthRepo._internal();
  static AuthRepo instance = AuthRepo._internal();
  factory AuthRepo() {
    return instance;
  }

  Future<void> signIn(UserModel userValue, BuildContext context) async {
    if (userValue.email.isEmpty || userValue.password.isEmpty) {
      showErrorMessage("Enter your email and password", context);
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            ));
          }
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userValue.email, password: userValue.password);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      if (e.code == "network-request-failed") {
        showErrorMessage("Check Your Internet Connection", context);
      } else if (e.code == "invalid-email") {
        showErrorMessage("Invalid Email", context);
      } else if (e.code == "user-not-found") {
        showErrorMessage("This User is not exist", context);
      } 
      else {
        showErrorMessage(e.code, context);
      }
    }
  }

  signout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }

  void showErrorMessage(String code, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(code),
      backgroundColor: Colors.red,
    ));
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Get authentication details from GoogleSignInAccount
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a credential using the obtained authentication details
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = authResult.user;

      if (user != null) {
        print('Successfully signed in with Google: ${user.displayName}');
      } else {
        print('Failed to sign in with Google');
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final UserCredential authResult =
              await FirebaseAuth.instance.signInWithCredential(credential);

          final User? user = authResult.user;

          if (user != null) {
            print(
                'Successfully signed in with phone number: ${user.phoneNumber}');
          } else {
            print('Failed to sign in with phone number');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Error verifying phone number: $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Verification code sent. ID: $verificationId');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto retrieval timeout. ID: $verificationId');
        },
        timeout: Duration(seconds: 60),
      );
    } catch (error) {
      print('Error signing in with phone number: $error');
    }
  }

  Future<void> signUp(UserModel userValue, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          {
            return const Center(child: CircularProgressIndicator());
          }
        });

    try {
      //create user
      final UserCredential userInfo = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userValue.email, password: userValue.password);

      //add created user details

      FirebaseFirestore.instance
          .collection("Users-collection")
          .doc(userInfo.user!.email)
          .set({
        "username": userValue.name,
        "email": userValue.email,
        "password": userValue.password,
        "profilepic": ""
      });

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      showErrorMessage(e.code, context);
    }
  }
}
