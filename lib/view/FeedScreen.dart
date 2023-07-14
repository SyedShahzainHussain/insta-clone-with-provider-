import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/app_colors..dart';
import 'package:instagram/widget/PostCard.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: AppColors.mobileBackgroundColor,
          title: Image.asset(
            'assets/images/instalogo.png',
            color: AppColors.primaryColor,
            height: 38,
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: const Text('No posts available'));
            } else {
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  final post = snapshot.data!.docs[index].data();
                  return PostCard(
                    snap: post,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            }
          },
        ));
  }
}
