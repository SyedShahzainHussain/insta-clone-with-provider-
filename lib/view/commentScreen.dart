import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/model/user_model.dart';
import 'package:instagram/repositories/userPostRepository.dart';
import 'package:instagram/utils/app_colors..dart';
import 'package:instagram/widget/CommentCard.dart';
import 'package:provider/provider.dart';

import '../provider/userProvider.dart';

class CommentScreen extends StatelessWidget {
  final snap;
  CommentScreen({super.key, this.snap});

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: AppColors.mobileBackgroundColor,
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return CommentCard(snap: snapshot.data!.docs[index].data(),data:snap);
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(snap['postId'])
            .collection('comments')
            .orderBy('datePublished',descending: true)
            .snapshots(),
      ),
      bottomNavigationBar:
          Consumer<UserProvider>(builder: (context, value, child) {
        final user = value.getUSer;
        return SafeArea(
            child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user.photo!),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 6.6),
                child: TextField(
                  controller: commentController,
                  decoration:
                      InputDecoration(labelText: "Comment ${user.username}"),
                ),
              )),
              InkWell(
                onTap: () {
                  UserPostRepository().postComments(
                      snap['postId'],
                      commentController.text,
                     user.uuid!,
                      user.photo!,
                      user.username!,
                      );
                  commentController.clear();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: const Text(
                    'post',
                    style: TextStyle(color: AppColors.blueColor),
                  ),
                ),
              )
            ],
          ),
        ));
      }),
    );
  }
}
