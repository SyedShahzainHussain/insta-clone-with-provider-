import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/provider/userProvider.dart';
import 'package:instagram/repositories/userPostRepository.dart';
import 'package:instagram/utils/routes/route_name.dart';
import 'package:instagram/view/likedAnimation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors..dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimated = false;
  int commentlLength = 0;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComment();
  }

  void getComment() async {
    isLoading = true;
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentlLength = snap.docs.length;
      isLoading = false;
    } catch (e) {
      print(e.toString());
      isLoading = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Timestamp? timestamp = widget.snap['datePublished'] as Timestamp;
    return Consumer<UserProvider>(
      builder: (context, value, _) {
        final user = value.getUSer;

        if (user == null) {
          // Show a loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.snap['profileImage'] ?? ''),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(widget.snap['username'] ?? 'username'),
                          )),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: ListView(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shrinkWrap: true,
                                          children: [
                                            "Delete",
                                          ]
                                              .map((e) => InkWell(
                                                    onTap: () {
                                                      UserPostRepository()
                                                          .deletePost(widget
                                                              .snap['postId']);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12,
                                                          horizontal: 16),
                                                      child: Text(e),
                                                    ),
                                                  ))
                                              .toList()),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.more_vert)),
                        ],
                      ),
                    ),
                    InkWell(
                      onDoubleTap: () {
                        UserPostRepository().likePost(widget.snap['postId'],
                            user.uuid, widget.snap['likes']);
                        setState(() {
                          isAnimated = true;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Image.network(
                              widget.snap['posts'] ?? '',
                              fit: BoxFit.cover,
                              height: MediaQuery.sizeOf(context).height * 0.35,
                              width: double.infinity,
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: isAnimated ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: likeAnimation(
                              isAnimaton: isAnimated,
                              duration: const Duration(milliseconds: 400),
                              onEnd: () {
                                setState(() {
                                  isAnimated = false;
                                });
                              },
                              child: const Icon(
                                Icons.favorite,
                                color: AppColors.primaryColor,
                                size: 120,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        likeAnimation(
                          isAnimaton:
                              widget.snap['likes'].contains(user.uuid) ?? false,
                          isSmallLIke: true,
                          child: IconButton(
                              onPressed: () {
                                UserPostRepository().likePost(
                                    widget.snap['postId'],
                                    user.uuid,
                                    widget.snap['likes']);
                              },
                              icon: widget.snap['likes'].contains(user.uuid)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      color: AppColors.primaryColor,
                                    )),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RouteName.commentScreen,
                                  arguments: widget.snap);
                            },
                            icon: const Icon(Icons.comment_outlined)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.send)),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark_border)),
                        ))
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.snap['likes'].length.toString()),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 8),
                            child: Text.rich(TextSpan(
                                style: const TextStyle(
                                    color: AppColors.primaryColor),
                                children: [
                                  TextSpan(text: widget.snap['username']),
                                  TextSpan(
                                      text: " ${widget.snap['description']}"),
                                ])),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteName.commentScreen,arguments: widget.snap);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                "View $commentlLength comments",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.secondaryColor),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              DateFormat.yMMMd().format(timestamp.toDate()),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.secondaryColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
        }
      },
    );
  }
}
