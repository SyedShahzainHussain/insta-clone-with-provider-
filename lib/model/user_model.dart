import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  String? username, email, bio, photo, uuid;
  List? followers;
  List? following;

  UsersModel({
    required this.photo,
    required this.uuid,
    required this.username,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uuid'] = uuid;
    data['bio'] = bio;
    data['photo'] = photo;
    data['username'] = username;
    data['email'] = email;
    data['followers'] = followers;
    data['following'] = following;
    return data;
  }

  static fronSnap(DocumentSnapshot snapshot) {
    final snap = snapshot.data()! as Map<String, dynamic>;
    return UsersModel(
        photo: snap['photo'],
        uuid: snap['uuid'],
        username: snap['username'],
        email: snap['email'],
        bio: snap['bio'],
        followers: snap['followers'],
        following: snap['following']);
  }
}
