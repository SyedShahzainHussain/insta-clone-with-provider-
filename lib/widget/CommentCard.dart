import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/repositories/userPostRepository.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final data;
  final snap;
  const CommentCard({super.key, this.snap, this.data});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    Timestamp? date = widget.snap['datePublished'] as Timestamp?;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(text: widget.snap['username']),
                  TextSpan(text: ' ${widget.snap['text']}'),
                ])),
                Container(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(DateFormat.yMMMd().format(date!.toDate())))
              ],
            ),
          )),
          InkWell(
            onTap: () {
              UserPostRepository().likeComments(
                  widget.data['postId'],
                  widget.snap['commentId'],
                  widget.snap['uuid'],
                  widget.snap['likes']);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child:  Icon(
                widget.snap['likes'].contains(widget.snap['uuid'])? 
                Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
