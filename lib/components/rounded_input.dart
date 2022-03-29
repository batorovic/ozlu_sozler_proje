import 'package:flutter/material.dart';
import 'package:ozlu_sozler/components/input_container.dart';
import 'package:ozlu_sozler/constants.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        onChanged: (value) {
          // String enteredText = value;
          // print(controller.text);
        },
        controller: controller,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            icon: Icon(
              icon,
              color: kPrimaryColor,
            )),
      ),
    );
  }
}
