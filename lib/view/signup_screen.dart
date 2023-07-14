import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/repositories/userRepository.dart';
import 'package:instagram/utils/routes/route_name.dart';
import 'package:instagram/utils/utils.dart';

import '../res/components/button.dart';
import '../res/components/text_form.dart';
import '../utils/app_colors..dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  FocusScopeNode _focusNode = FocusScopeNode();
  Uint8List? file;
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController bio = TextEditingController();
  ValueNotifier<bool> obsecure = ValueNotifier<bool>(true);

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    bio.dispose();
    _focusNode.dispose();
  }

  void showImage(ImageSource source) async {
    var _file = await Utils().takePicture(source);
    setState(() {
      file = _file;
    });
  }

  void showModel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              onTap: () {
                showImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
              title: const Text("Choose from gallery"),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              onTap: () {
                showImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
              title: const Text("Choose from camera"),
            ),
          ],
        );
      },
    );
  }

  void signUp() async {
    setState(() {
      isLoading = true;
    });
    String res = await UserRepository().signUp(
        file!, username.text, email.text, bio.text, password.text, context);
    setState(() {
      isLoading = false;
    });
    if (res == 'Success') {
      // ignore: use_build_context_synchronously
      Utils().showAnotherFlushbar(context, "Sign Up SuccessFully");
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, RouteName.loginScreen);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/instalogo.png',
                color: AppColors.primaryColor,
              ),
              Stack(
                children: [
                  file != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(file!),
                        )
                      : const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'),
                          radius: 64,
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () {
                          showModel();
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: AppColors.blueColor,
                        ),
                      )),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextInputWidget(
                      textInputAction: TextInputAction.next,
                      focusNode: _focusNode,
                      controller: username,
                      text: 'Enter your username',
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 8,
                  ),
                  TextInputWidget(
                      textInputAction: TextInputAction.next,
                      focusNode: _focusNode,
                      controller: email,
                      text: 'Enter your email',
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 8,
                  ),
                  ValueListenableBuilder(
                    valueListenable: obsecure,
                    builder: (context, value, child) => 
                     TextInputWidget(
                        isPass: obsecure.value,
                        textInputAction: TextInputAction.next,
                        focusNode: _focusNode,
                        controller: password,
                        text: 'Enter your password',
                        textInputType: TextInputType.text,
                        icon:  InkWell(
                        onTap: () {
                          obsecure.value = !obsecure.value;
                        },
                        child: Icon(obsecure.value ? Icons.visibility_off :Icons.visibility)),),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextInputWidget(
                      textInputAction: TextInputAction.done,
                      focusNode: _focusNode,
                      controller: bio,
                      text: 'Enter your bio',
                      textInputType: TextInputType.text),
                ],
              ),
              Button(
                isLoadng: isLoading,
                text: "Sign Up",
                onTap: () async {
                  if (username.text.isEmpty ||
                      email.text.isEmpty ||
                      password.text.isEmpty ||
                      bio.text.isEmpty ||
                      file!.isEmpty) {
                    Utils().showAnotherFlushbar(context, "Plz enter a value");
                  } else {
                    signUp();
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already an Account?"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.loginScreen);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        " Log In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
