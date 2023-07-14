import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/utils/app_colors..dart';
import 'package:instagram/view/user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShownUser = false;
  final TextEditingController userController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mobileBackgroundColor,
        title: TextFormField(
          controller: userController,
          decoration: const InputDecoration(labelText: "Search for a user"),
          onFieldSubmitted: (value) {
            setState(() {
              isShownUser = true;
            });
          },
        ),
      ),
      body: isShownUser
          ? FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text("No Data Found"),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                        return  UserProfileScreen(
                              uuid: snapshot.data!.docs[index]['uuid']
                                  .toString());
                        },
                      )),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data!.docs[index]['photo']),
                        ),
                        title: Text(snapshot.data!.docs[index]['username']),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isEqualTo: userController.text)
                  .get(),
            )
          : FutureBuilder(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return MasonryGridView.count(
                  itemCount: snapshot.data!.docs.length,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  crossAxisCount: 3,
                  itemBuilder: (context, index) {
                    return Image.network(snapshot.data!.docs[index]['posts']);
                  },
                );
              },
              future: FirebaseFirestore.instance.collection('posts').get(),
            ),
    );
  }
}
