import 'package:flutter/material.dart';

import '../../utils/app_colors..dart';

class Button extends StatelessWidget {
  final bool isLoadng;
  final String text;
  final Function onTap;
  const Button({
    super.key,
    this.isLoadng = false,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        child: Container(
            decoration: BoxDecoration(
              color: AppColors.blueColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            width: double.infinity,
            height: 47,
            child: isLoadng
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  )),
        onPressed: () {
          onTap();
        },
      ),
    );
  }
}
