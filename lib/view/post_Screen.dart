import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/repositories/userPostRepository.dart';
import 'package:instagram/utils/app_colors..dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

import '../provider/userProvider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController postController = TextEditingController();
  Uint8List? _file;
  bool isLoading = false;

  openDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create a Post"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await Utils().takePicture(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await Utils().takePicture(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void addPost(String username, profileImage, uuid) async {
    setState(() {
      isLoading = true;
    });
    String res = await UserPostRepository().publishedPost(
        username, profileImage, uuid, postController.text, _file!);
    if (res == 'Success') {
      Utils().showAnotherFlushbar(context, 'Post Successfull');
      clearImage();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUSer;

    return _file == null
        ? Center(
            child: IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              openDialog();
            },
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.mobileBackgroundColor,
              title: const Text("Post To"),
              leading: IconButton(
                onPressed: () {
                  clearImage();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    if (postController.text.isEmpty) {
                      Utils().showAnotherFlushbar(
                          context, "plz enter a description");
                    } else {
                      addPost(user.username!, user.photo!, user.uuid!);
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.only(right: 7),
                      child: const Center(
                          child: Text(
                        "Post",
                        style:
                            TextStyle(color: AppColors.blueColor, fontSize: 16),
                      ))),
                )
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.photo!),
                      ),
                      SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.45,
                          child: TextField(
                            controller: postController,
                            decoration:
                                const InputDecoration(hintText: "Add Post"),
                          )),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: MemoryImage(_file!))),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
