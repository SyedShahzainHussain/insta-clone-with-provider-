import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/repositories/userPostRepository.dart';
import 'package:instagram/res/components/FollowButton.dart';
import 'package:instagram/res/components/button.dart';
import 'package:instagram/utils/app_colors..dart';
import 'package:instagram/utils/routes/route_name.dart';

class UserProfileScreen extends StatefulWidget {
  String? uuid;
  UserProfileScreen({super.key, this.uuid});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var userdata = {};
  int followers = 0;
  int following = 0;
  int postLength = 0;
  bool isLoading = false;
  bool isFollowing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

   getUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      print(widget.uuid.toString());
      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid)
          .get();
      userdata = data.data() as Map;
      var snap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uuid', isEqualTo: widget.uuid)
          .get();
      postLength = snap.docs.length;
      followers = data.data()!['followers'].length;
      following = data.data()!['following'].length;
      isFollowing = data
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.mobileBackgroundColor,
              centerTitle: false,
              title: Text(userdata['username']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(userdata['photo']),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStaCloumn(postLength, 'post'),
                                    buildStaCloumn(followers, 'followers'),
                                    buildStaCloumn(following, 'following'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uuid
                                        ? Flexible(
                                          child: FollowButton(
                                              function: () async {
                                                await UserPostRepository()
                                                    .signOut();
                                                Navigator.pushNamed(context,
                                                    RouteName.loginScreen);
                                              },
                                              backgroundColor:
                                                  AppColors.mobileBackgroundColor,
                                              borderColor: Colors.grey,
                                              text: 'Sign Out',
                                              textColor: Colors.white),
                                        )
                                        : isFollowing
                                            ? Flexible(
                                              child: FollowButton(
                                                  function: () async {
                                                    await UserPostRepository()
                                                        .followUser(
                                                            FirebaseAuth.instance
                                                                .currentUser!.uid,
                                                            userdata['uuid']);
                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                  backgroundColor:
                                                      AppColors.blueColor,
                                                  borderColor: Colors.blue,
                                                  text: 'Un Follow',
                                                  textColor: Colors.white),
                                            )
                                            : Flexible(
                                              child: FollowButton(
                                                  function: () async {
                                                    await UserPostRepository()
                                                        .followUser(
                                                            FirebaseAuth.instance
                                                                .currentUser!.uid,
                                                            userdata['uuid']);
                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                  backgroundColor:
                                                      AppColors.blueColor,
                                                  borderColor: Colors.blue,
                                                  text: 'Follow',
                                                  textColor: Colors.white),
                                            )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          // userData['username'],
                          userdata['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(userdata['bio']
                            // userData['bio'],
                            ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 1.5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        return Container(
                          child: Image(
                            image: NetworkImage(
                                snapshot.data!.docs[index]['posts']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uuid', isEqualTo: widget.uuid)
                      .get(),
                )
              ],
            ),
          );
  }
}

Column buildStaCloumn(int number, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        number.toString(),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          label.toString(),
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      )
    ],
  );
}
