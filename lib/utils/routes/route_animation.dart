import 'package:flutter/material.dart';

class RouteTransition implements PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );

    // const startPosition = Offset(1.0, 0.0);
    // const endPostion = Offset(0.0, 0.0);
    // Tween<Offset> position = Tween(begin: startPosition, end: endPostion);

    // return SlideTransition(
    //   position: animation.drive(position),
    //   child: child,
    // );
  }
}
