import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FireStoreStorageMethod {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> getPhotos(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        firebaseStorage.ref(childName).child(firebaseAuth.currentUser!.uid);
    if (isPost) {
    String postId = const Uuid().v1();
      ref = ref.child(postId);
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String download = await taskSnapshot.ref.getDownloadURL();
    return download;
  }
}
