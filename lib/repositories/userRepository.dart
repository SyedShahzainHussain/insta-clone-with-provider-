// ignore: file_names
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/model/user_model.dart';
import 'package:instagram/repositories/firestore_storage.dart';
import 'package:instagram/utils/utils.dart';

class UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UsersModel> getUsers() async {
    DocumentSnapshot<Map<String, dynamic>> user = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    return UsersModel.fronSnap(user);
  }

  Future<String> signUp(Uint8List file, String username, email, bio, password,
      BuildContext context) async {
    String res = "Error Occured";
    try {
      UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      String photoUrl =
          await FireStoreStorageMethod().getPhotos('profile-pics', file, false);

      final user = UsersModel(
        uuid: cred.user!.uid,
        photo: photoUrl,
        username: username,
        email: email,
        bio: bio,
        followers: [],
        following: [],
      );

      firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      res = "Success";
      // ignore: use_build_context_synchronously
      Utils().showAnotherFlushbar(context, res);
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        res = "Invalid Email";
        Utils().showAnotherFlushbar(context, res);
      } else if (e.code == 'weak-password') {
        res = 'password is weak';
        Utils().showAnotherFlushbar(context, res);
      } else {
        res = e.message ?? "An error occurred";
        Utils().showAnotherFlushbar(context, res);
      }
    } catch (e) {
      res = e.toString();
      Utils().showAnotherFlushbar(context, res);
    }
    return res;
  }

  Future<String> login(String email, password, BuildContext context) async {
    String res = "Error Occured";
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = 'Success';
      Utils().showAnotherFlushbar(context, res);
    } on FirebaseException catch (e) {
      if (e.code == 'wrong-password') {
        res = "Wrong Password";
        Utils().showAnotherFlushbar(context, res);
      } else {
        res = e.message ?? "An error occurred";
        Utils().showAnotherFlushbar(context, res);
      }
    } catch (e) {
      res = e.toString();
      Utils().showAnotherFlushbar(context, res);
    }
    return res;
  }
}
