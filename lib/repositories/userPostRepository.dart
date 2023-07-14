import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/repositories/firestore_storage.dart';
import 'package:uuid/uuid.dart';

class UserPostRepository {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<String> publishedPost(
    String username,
    profileImage,
    uuid,
    description,
    Uint8List file,
  ) async {
    String res = "Error Occured";
    try {
      final postUrl =
          await FireStoreStorageMethod().getPhotos('posts', file, true);

      String postId = const Uuid().v1();
      firebaseFirestore.collection('posts').doc(postId).set({
        'uuid': uuid,
        'username': username,
        'profileImage': profileImage,
        'description': description,
        'posts': postUrl,
        'likes': [],
        'datePublished': DateTime.now(),
        'postId': postId,
      });
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, userId, List like) async {
    try {
      if (like.contains(userId)) {
        firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([userId])
        });
      } else {
        firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([userId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComments(
      String postId, text, uuid, profilePic, username) async {
    try {
      final commentId = const Uuid().v1();
      firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        'commentId': commentId,
        'datePublished': DateTime.now(),
        'profilePic': profilePic,
        'text': text,
        'likes': [],
        'username': username,
        'uuid': uuid,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeComments(
    String postId,
    commentId,
    uuid,
    List like,
  ) async {
    try {
      if (like.contains(uuid)) {
        firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uuid]),
        });
      } else {
        firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uuid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uuid, String followId) async {
    try {
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(uuid).get();

      List following = (snap.data() as dynamic)['following'];
      if (following.contains(followId)) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({
          'followers': FieldValue.arrayRemove([uuid])
        });
        await FirebaseFirestore.instance.collection('users').doc(uuid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({
          'followers': FieldValue.arrayUnion([uuid])
        });
        await FirebaseFirestore.instance.collection('users').doc(uuid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    firebaseFirestore.collection('posts').doc(postId).delete();
    await firebaseFirestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .get()
        .then((snapshot) {
      for (var commentDoc in snapshot.docs) {
        commentDoc.reference.delete();
      }
    });
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
}
