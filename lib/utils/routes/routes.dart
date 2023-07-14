import 'package:flutter/material.dart';
import 'package:instagram/utils/routes/route_name.dart';
import 'package:instagram/view/commentScreen.dart';
import 'package:instagram/view/login_screen.dart';
import 'package:instagram/view/mainScreen.dart';

import '../../view/signup_screen.dart';

class Routes {
  static Route<dynamic> onGenerate(RouteSettings setting) {
    final snap = setting.arguments;
     print('onGenerate route: ${setting.name}'); // A
    switch (setting.name) {
      case RouteName.loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case RouteName.signupScreen:
        return MaterialPageRoute(
          builder: (context) => SignupScreen(),
        );
      case RouteName.mainScreen:
        return MaterialPageRoute(
          builder: (context) => const MainScreen(),
        );
      case RouteName.commentScreen:
        return MaterialPageRoute(
          builder: (context) => CommentScreen(
            snap: snap,
          ),
        );
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(child: Text("No Routes Defined")),
                ));
    }
  }
}
