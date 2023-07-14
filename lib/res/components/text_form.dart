import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final bool isPass;
  final TextInputType textInputType;
  final FocusScopeNode focusNode;
  final FocusNode? nextFocus;
  final TextInputAction textInputAction;
  final Widget? icon;

  TextInputWidget({
    super.key,
    required this.controller,
    required this.text,
    this.isPass = false,
    required this.textInputType,
    required this.focusNode,
    this.nextFocus,

    required this.textInputAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: TextFormField(
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(nextFocus);
        },
        textInputAction: textInputAction,
        focusNode: nextFocus,
        controller: controller,
        obscureText: isPass,
        decoration: InputDecoration(
            suffixIcon: icon,
            filled: true,
            hintText: text,
            enabledBorder:
                const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                const OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(14)),
      ),
    );
  }
}
