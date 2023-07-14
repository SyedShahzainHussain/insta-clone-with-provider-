import 'package:flutter/material.dart';
import 'package:instagram/repositories/userRepository.dart';
import 'package:instagram/res/components/text_form.dart';
import 'package:instagram/utils/app_colors..dart';
import 'package:instagram/utils/routes/route_name.dart';
import 'package:instagram/utils/utils.dart';

import '../res/components/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  FocusScopeNode _focusNode = FocusScopeNode();
  FocusNode? passwordFocus;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ValueNotifier<bool> obsecure = ValueNotifier<bool>(true);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    _focusNode.dispose();
  }

  void login() async {
    setState(() {
      isLoading = true;
    });
    String res = await UserRepository()
        .login(emailController.text, passwordController.text, context);
    if (res == 'Success') {
      // ignore: use_build_context_synchronously
      Utils().showAnotherFlushbar(context, "Login In SuccessFully");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, RouteName.mainScreen);
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
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Image.asset(
                'assets/images/instalogo.png',
                color: AppColors.primaryColor,
              ),
              const SizedBox(
                height: 8,
              ),
              TextInputWidget(
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNode,
                  controller: emailController,
                  text: 'Enter your email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 8,
              ),
              ValueListenableBuilder(
                valueListenable: obsecure,
                builder: (context, value, child) => TextInputWidget(
                  isPass: obsecure.value,
                  textInputAction: TextInputAction.done,
                  nextFocus: passwordFocus,
                  focusNode: _focusNode,
                  controller: passwordController,
                  text: 'Enter your password',
                  textInputType: TextInputType.emailAddress,
                  icon: InkWell(
                      onTap: () {
                        obsecure.value = !obsecure.value;
                      },
                      child: Icon(obsecure.value ? Icons.visibility_off :Icons.visibility)),
                ),
              ),
              Button(
                isLoadng: isLoading,
                text: "Log In",
                onTap: () {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    Utils().showAnotherFlushbar(context, 'Plz enter a value');
                  } else {
                    login();
                  }
                },
              ),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account?"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.signupScreen);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
