import 'package:flutter/material.dart';
import 'package:ozlu_sozler/components/input_container.dart';
import 'package:ozlu_sozler/constants.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({
    Key? key,
    required this.hint,
    required this.controllerPassword,
  }) : super(key: key);

  final String hint;
  final TextEditingController controllerPassword;
  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        controller: controllerPassword,
        cursorColor: kPrimaryColor,
        obscureText: true,
        decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            icon: const Icon(
              Icons.lock,
              color: kPrimaryColor,
            )),
      ),
    );
  }
}
