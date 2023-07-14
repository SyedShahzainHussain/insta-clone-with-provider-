
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  Future<dynamic> takePicture(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: source);
    return file!.readAsBytes();
  }

  void showAnotherFlushbar(BuildContext context, String message) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          icon: const Icon(
            Icons.info,
            color: Colors.red,
          ),
          forwardAnimationCurve: Curves.decelerate,
          borderRadius: BorderRadius.circular(10),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(15),
          message: message,
        )..show(context));
  }
}
